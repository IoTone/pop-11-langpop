/* client.p -- the TUI, demoted to a client.

   Same session as Proposal A, same teacher, same questions -- but this
   program holds no graph, no beliefs and no judgment.  It asks the server
   what to show and sends back what the student typed.  Everything it can
   do, an application in any language can do, which is the only honest
   test of an API: the reference client has no private door.

       ./langpop server --port 7801 &
       ./langpop client --port 7801 --user bob

   Note what is NOT here: no answer key, no scoring, no belief arithmetic.
   The client cannot tell whether an answer was right until the server
   says so, and cannot time the student either -- langpop/next starts the
   clock on the server, which is what keeps the speed half of a level's
   exit criteria worth anything.
*/

uses jsonrpc;

vars
    lp_conn = false,
    lp_rpc_seq = 0,
    lp_sid = false,
    lp_teacher = 'the teacher',
;

;;; One call, one reply.  LIB * JSONRPC does not correlate requests for a
;;; client (HELP * JSONRPC, "Limits"), which is fine here: this client is
;;; a person typing, so there is never more than one request in flight.
define rpc(method, params) -> result;
    lvars method, params, reply, err;
    lp_rpc_seq + 1 -> lp_rpc_seq;
    jsonrpc_write(lp_conn,
        jsonrpc_obj([% 'jsonrpc', '2.0', 'id', lp_rpc_seq,
                       'method', method, 'params', params %]));
    jsonrpc_read(lp_conn) -> reply;
    if reply == termin or reply == false then
        printf('\n(the tutor stopped answering)\n');
        sysexit();
    endif;
    reply('error') -> err;
    if err then
        printf('  ! %p (%p)\n', [% err('message'), err('code') %]);
        false -> result;
    else
        reply('result') -> result;
    endif;
enddefine;

define p(o, key) -> v;
    lvars o, key, v = false;
    if o and (isproperty(o) or isjson_object(o)) then o(key) -> v endif;
    if v == json_null then false -> v endif;
enddefine;

;;; ------------------------------------------------------------- the TUI

;;; A MINUTE WITH NOTHING TYPED IS NOT STUDY.  Every wait for a
;;; character is timed, and a silence longer than the grace is deducted
;;; from the grace onwards, so the clock below counts the sitting and
;;; not the interruption.  The first minute of each silence still
;;; counts: thinking about a question is the study.
;;;
;;; This is the third thing the client owns a copy of, after yes() and
;;; the clock itself, and for the same reason -- the server knows when
;;; the session opened and cannot know whether anybody is in the chair.
;;; Here the keystrokes arrive, so here is the only place that can tell.
vars lp_idle_ms = 0;
lconstant LP_IDLE_GRACE = 60000;

define readline() -> line;
    lvars c, t, n = 0;
    repeat
        sys_microtime() div 1000 -> t;
        charin() -> c;
        if ((sys_microtime() div 1000) - t) > LP_IDLE_GRACE then
            lp_idle_ms + ((sys_microtime() div 1000) - t) - LP_IDLE_GRACE
                -> lp_idle_ms;
        endif;
        if c == termin then
            if n == 0 then termin -> line; return endif;
            quitloop;
        endif;
        quitif(c == `\n`);
        c; n + 1 -> n;
    endrepeat;
    consstring(n) -> line;
enddefine;

define trim(s) -> t;
    lvars s, i = 1, j;
    if s == termin then '' -> t; return endif;
    length(s) -> j;
    while i <= j and s(i) == ` ` do i + 1 -> i endwhile;
    while j >= i and s(j) == ` ` do j - 1 -> j endwhile;
    if j < i then '' else substring(i, j - i + 1, s) endif -> t;
enddefine;

;;; A yes, in either language.  The client carries its own copy rather
;;; than loading langpop.p: it is a client, and the only thing it is
;;; allowed to know about the tutor is the protocol.
define yes(line) -> b;
    lvars line, s = trim(line), b;
    lowertoupper(s) -> s;        ;;; cheap fold; the tests below are ASCII
    uppertolower(s) -> s;
    s = 'y' or s = 'yes' or s = 'はい' or s = 'hai' -> b;
enddefine;

define split2(s) -> (a, b);
    lvars s, c = locchar(` `, 1, s);
    if c then (substring(1, c - 1, s), trim(allbutfirst(c, s))) -> (a, b)
    else (s, '') -> (a, b)
    endif;
enddefine;

;;; ------------------------------------------------------ the sitting clock
;;; WHAT THIS CLOCK IS NOT.  The header above says the client cannot time
;;; the student, and that stands: the clock that scores an ANSWER starts
;;; on the server at langpop/next, because latency sits in the exit
;;; criteria and a criterion whose stopwatch is held by the client is
;;; worth nothing -- test_langpop_server.p pins that down by sending a
;;; dishonest figure and checking the reply says latency_source server.
;;;
;;; What a client may own is the clock the student can SEE.  How long
;;; this sitting has run is not evidence about any item, nobody is graded
;;; on it, and it is the one number the server cannot supply: the server
;;; knows when the session was opened and not whether the person is still
;;; in the chair.
;;;
;;; Real wall clock, like the day count in :status and for the same
;;; reason.  --day-ms scales the server's day for a test and does not
;;; tell the client about it, so this measures minutes of the student's
;;; afternoon and makes no claim at all about the tutor's calendar.
vars
    lp_t0 = false,            ;;; when this sitting started, in ms
    lp_answered = 0,          ;;; questions answered during it
    lp_goal_min = false,      ;;; sitting length :status last suggested
    lp_goal_said = false,     ;;; so the nudge arrives once, not per answer
;

;;; The client's own clock, as the client has its own yes(): it may know
;;; the protocol and nothing else about the tutor, so it cannot call
;;; langpop.p's lp_now_ms.  sys_microtime is wall clock; systime is CPU
;;; time and barely moves while a human types.
define lp_elapsed_ms() -> ms;
    lvars ms;
    if lp_t0 then max(0, (sys_microtime() div 1000) - lp_t0 - lp_idle_ms)
    else 0 endif -> ms;
enddefine;

;;; m:ss while a sitting is a sitting, and h m once it stops being one.
;;; The zero pad matters more than it looks: 9:5 reads as nine minutes
;;; five seconds to nobody.
define lp_clock(ms) -> s;
    lvars ms, s, secs = ms div 1000, m, r;
    secs div 60 -> m; secs rem 60 -> r;
    if m >= 60 then
        sprintf('%ph%p%pm', [% m div 60,
                               if m rem 60 < 10 then '0' else '' endif,
                               m rem 60 %]) -> s;
    else
        sprintf('%p:%p%p', [% m, if r < 10 then '0' else '' endif, r %]) -> s;
    endif;
enddefine;

;;; The schedule already says how long a sitting should be -- :status
;;; prints it as "a suggestion: 20 minutes a day" and the figure comes
;;; from the server's own consistency report.  Having asked the student
;;; for twenty minutes it would be rude not to notice the twentieth, and
;;; a learner who is told when they have done the day's share is a
;;; learner who stops at a sensible place rather than at a wrong answer.
define lp_goal_check();
    if lp_goal_min and not(lp_goal_said)
    and lp_elapsed_ms() >= lp_goal_min * 60000 then
        true -> lp_goal_said;
        printf('\n  (%p minutes -- that is the sitting the schedule asked for.'
               <> '  Stopping here is fine; so is carrying on.)\n',
               [% lp_goal_min %]);
    endif;
enddefine;

define show_time();
    lvars ms = lp_elapsed_ms();
    unless lp_t0 then printf('  no sitting open\n'); return endunless;
    printf('\n  %p at the keyboard, %p question(s) answered\n',
           [% lp_clock(ms), lp_answered %]);
    ;;; Said rather than silently subtracted: a clock reading lower than
    ;;; the one on the student's wall has to account for the difference.
    if lp_idle_ms >= 60000 then
        printf('    (%p of it away from the keyboard, not counted)\n',
               [% lp_clock(lp_idle_ms) %]);
    endif;
    ;;; Seconds per question is not a score and is not sent anywhere; it
    ;;; is the number that tells a student they have spent the sitting
    ;;; reading the screen rather than answering it.  Half a minute in
    ;;; before it says anything, because a pace over two questions is
    ;;; not a pace, and rounding one up to "about 1 seconds" reads like
    ;;; a bug in the clock.
    if lp_answered > 0 and ms >= 30000 then
        printf('    about %p seconds a question\n',
               [% round(ms / (lp_answered * 1000)) %]);
    endif;
    if lp_goal_min then
        if ms >= lp_goal_min * 60000 then
            printf('    the schedule asked for %p minutes; done\n',
                   [% lp_goal_min %]);
        else
            printf('    the schedule asked for %p minutes; %p to go\n',
                   [% lp_goal_min,
                      lp_clock(lp_goal_min * 60000 - ms) %]);
        endif;
    endif;
enddefine;

define help();
    printf('\n  <enter>          the next thing to learn\n');
    printf('  :plan            what is ready now\n');
    printf('  :why <item>      the derivation, from the graph\n');
    printf('  :status          the exit criteria of this level, measured\n');
    printf('  :card <item>     ask the tutor to draw it\n');
    printf('  :assign          something to do away from the keyboard\n');
    printf('  :report <n> ok | 17/20\n');
    printf('  :time            how long this sitting has run\n');
    printf('  :quit            close the session and stop\n');
enddefine;

;;; Ask, show, read, send.  The client never decides anything about the
;;; answer -- it does not even know what the answer was until it is told.
define ask_one();
    lvars q = rpc('langpop/next', jsonrpc_obj([% 'session_id', lp_sid %])),
          item, shape, opts, i = 0, o, line, ans;
    returnunless(q);
    p(q, 'item') -> item;
    unless item then
        printf('  %p\n', [% p(q, 'note') or 'nothing ready' %]);
        return;
    endunless;
    p(q, 'shape') -> shape;
    p(q, 'options') -> opts;
    if p(q, 'task') then printf('\n  %p\n', [% p(q, 'task') %]) endif;
    if shape = 'pick' then
        printf('\n  %p\n', [% p(q, 'prompt') %]);
        for o in_vector (opts or {}) do
            i + 1 -> i; printf('    %p) %p\n', [% i, o %]);
        endfor;
        printf('  -> ');
    else
        printf('\n  %p    -> ', [% p(q, 'prompt') %]);
    endif;
    sysflush(popdevout);
    readline() -> line;
    returnif(line == termin);
    rpc('langpop/answer',
        jsonrpc_obj([% 'session_id', lp_sid, 'item', item,
                       'answer', trim(line) %])) -> ans;
    returnunless(ans);
    ;;; Counted here and not at the question: a prompt the student walked
    ;;; away from is not a question they answered, and this number is
    ;;; divided by to get a pace.
    lp_answered + 1 -> lp_answered;
    if p(ans, 'correct') then
        printf('  %p\n', [% p(ans, 'reply') %]);
    elseif p(ans, 'mistook_form') then
        printf('  %p  That is %p -- the two are confused constantly.\n',
               [% p(ans, 'reply'), p(ans, 'mistook_form') %]);
    else
        printf('  %p  It is %p.\n', [% p(ans, 'reply'), p(ans, 'expected') %]);
    endif;
    lp_goal_check();
enddefine;

define show_plan();
    lvars pl = rpc('langpop/plan', jsonrpc_obj([% 'session_id', lp_sid %])), it;
    returnunless(pl);
    printf('\n');
    for it in_vector (p(pl, 'items') or {}) do
        printf('  %p  %p  (belief %p)\n',
               [% p(it, 'form'), p(it, 'kind'), p(it, 'belief') %]);
    endfor;
    printf('  ... %p ready in all\n', [% p(pl, 'ready_count') %]);
enddefine;

;;; The card is rendered and stored on the SERVER.  When the two are the
;;; same machine -- which is every run of this pair today -- the client can
;;; open the file it was handed.  When they are not, the path is still the
;;; honest answer: the client says where it is rather than pretending it
;;; can show it, and a remote client that wants the bytes needs a method
;;; that sends them, which card.render deliberately is not.
define show_card(item);
    lvars item, c = rpc('langpop/card.render',
                        jsonrpc_obj([% 'item', item, 'style', 'word' %])),
          path, opener;
    returnunless(c);
    p(c, 'path') -> path;
    printf('\n  %p  (%p x %p %p)\n',
           [% path, p(c, 'width'), p(c, 'height'), p(c, 'format') %]);
    unless sys_file_exists(path) then
        printf('  The tutor drew it on its own machine; I cannot reach it.\n');
        return;
    endunless;
    for opener in ['/usr/bin/open' '/usr/bin/xdg-open' '/usr/bin/see'] do
        if sys_file_exists(opener) then
            sysobey(opener <> ' ' <> path); return;
        endif;
    endfor;
    printf('  No viewer here; the file is on disk.\n');
enddefine;

define show_why(item);
    lvars item, w = rpc('langpop/explain',
                        jsonrpc_obj([% 'session_id', lp_sid, 'item', item %])),
          pre;
    returnunless(w);
    printf('\n  %p  (%p, %p, %p)\n',
           [% p(w, 'form'), p(w, 'kind'), p(w, 'level'), p(w, 'source') %]);
    if p(w, 'gloss') then printf('    %p\n', [% p(w, 'gloss') %]) endif;
    for pre in_vector (p(w, 'prerequisites') or {}) do
        printf('    %p %p\n',
               [% if p(pre, 'known') then 'known  ' else 'missing' endif,
                  p(pre, 'item') %]);
    endfor;
    printf('    belief %p on channel %p (mastery is %p)\n',
           [% p(w, 'belief'), p(w, 'channel'), p(w, 'mastery_threshold') %]);
enddefine;

define show_status();
    lvars st = rpc('langpop/status', jsonrpc_obj([% 'session_id', lp_sid %])), c;
    returnunless(st);
    printf('\n  %p, %p -- level %p, period %p\n',
           [% p(st, 'display_name'), p(st, 'language'), p(st, 'level'),
              p(st, 'period') %]);
    for c in_vector (p(st, 'criteria') or {}) do
        if p(c, 'kind') = 'measured' and p(c, 'answers') == 0 then
            ;;; Nothing to read yet rather than nought per cent: a
            ;;; student who has not been asked anything this period has
            ;;; not failed it.
            printf('    %p: no reviews yet this period (needs %p)\n',
                   [% p(c, 'criterion'), p(c, 'need') %]);
        elseif p(c, 'kind') = 'measured' then
            printf('    %p: %p%% right, %p%% within %pms at the latest review, %p of %p reviewed (need %p)\n',
                   [% p(c, 'criterion'), round(p(c, 'accuracy') * 100),
                      round(p(c, 'within_latency') * 100), p(c, 'latency_ms'),
                      p(c, 'answers'), p(c, 'need'),
                      round(p(c, 'threshold') * 100) %]);
        elseif p(c, 'kind') = 'count' then
            printf('    %p: %p of %p\n',
                   [% p(c, 'criterion'), p(c, 'have'), p(c, 'want') %]);
        else
            printf('    %p: %p\n', [% p(c, 'criterion'), p(c, 'note') %]);
        endif;
    endfor;
    printf('    %p items ready to teach now', [% p(st, 'ready_count') %]);
    if (p(st, 'reviews_due') or 0) > 0 then
        printf(', %p waiting to come round again', [% p(st, 'reviews_due') %]);
    endif;
    printf('\n');
    ;;; Nothing owed today is not nothing left to do, and the server
    ;;; says which day the next one falls on so a client can tell a
    ;;; student to come back rather than sounding like it has run out.
    ;;;
    ;;; A real day, in a client, deliberately: --day-ms scales the
    ;;; server's clock for a test and a client is not told about it, so
    ;;; against a scaled server this says "1 day" and is wrong by design
    ;;; rather than by accident.
    lvars soon = p(st, 'next_review_in');
    if (p(st, 'reviews_due') or 0) == 0 and isinteger(soon) and soon > 0 then
        printf('    nothing owed today -- the next review comes round in %p day(s)\n',
               [% max(1, round(soon / 86400000)) %]);
    endif;
    ;;; The month as it has actually gone, and a schedule only when the
    ;;; server offers one -- it says nothing when the student is keeping
    ;;; up, and so does this.
    lvars cy = p(st, 'consistency'), ad;
    if cy then
        printf('    %p of the last %p days had some study in them\n',
               [% p(cy, 'days_worked'), p(cy, 'days_elapsed') %]);
        p(cy, 'advice') -> ad;
        if ad then
            ;;; Kept, so :time can hold the answer up against it.  The
            ;;; client does not invent a target and does not nag for
            ;;; one: it has a target only once the student has asked
            ;;; for :status.
            p(ad, 'minutes') -> lp_goal_min;
            if p(ad, 'shape') = 'daily' then
                printf('    a suggestion: %p minutes a day would keep up with it\n',
                       [% p(ad, 'minutes') %]);
            elseif p(ad, 'shape') = 'weekly' then
                printf('    a suggestion: %p sittings a week, %p minutes each\n',
                       [% p(ad, 'times'), p(ad, 'minutes') %]);
            else
                printf('    a suggestion: %p sittings this month, %p minutes each\n',
                       [% p(ad, 'times'), p(ad, 'minutes') %]);
            endif;
        endif;
    endif;
enddefine;

define do_assign();
    lvars a = rpc('langpop/assign', jsonrpc_obj([% 'session_id', lp_sid %]));
    returnunless(a);
    unless p(a, 'assignment_id') then
        printf('  %p\n', [% p(a, 'note') %]); return;
    endunless;
    ;;; `again` means this is work already outstanding rather than
    ;;; something new, and saying so is the difference between a reminder
    ;;; and a second piece of homework.  Same wording as the TUI's.
    printf('\n  Assignment %p%p: %p\n',
           [% p(a, 'assignment_id'),
              if p(a, 'again') then ', still open' else '' endif,
              p(a, 'form') %]);
    if p(a, 'gloss') then printf('    %p\n', [% p(a, 'gloss') %]) endif;
    printf('    %p   (%p, checked %p)\n',
           [% p(a, 'url'), p(a, 'resource_kind'), p(a, 'checked') %]);
    printf('  %p\n', [% p(a, 'say') %]);
enddefine;

define do_report(arg);
    lvars arg, id, outcome, r;
    split2(arg) -> (id, outcome);
    strnumber(id) -> id;
    unless id then printf('  :report <number> ok|17/20\n'); return endunless;
    rpc('langpop/report',
        jsonrpc_obj([% 'session_id', lp_sid, 'assignment_id', id,
                       'outcome', if outcome = '' then 'ok' else outcome endif %]))
        -> r;
    returnunless(r);
    printf('  Recorded as tier %p evidence.  %p\n', [% p(r, 'tier'), p(r, 'note') %]);
enddefine;

;;; --------------------------------------------------------------- main
;;; Poplog wraps terminal output at poplinewidth (70 by default), and
;;; hard-breaks at poplinemax, inserting a newline and a TAB.  That is
;;; sensible for a listing and wrong for a tutor: it had been cutting the
;;; resource URLs an assignment hands out, mid-token, so a student could
;;; not copy one -- `checked 2026-10-1\n\t9)`.  Nothing here wants
;;; automatic wrapping; what needs wrapping is wrapped by hand.
4000 -> poplinewidth;
4096 -> poplinemax;

define client_main();
    ;;; `lang` starts as false and not as 'ja': it is sent only when it
    ;;; was asked for, because the server treats a language it is given
    ;;; as an instruction that beats the student's stored one.  A client
    ;;; that always sent its own default would flip a returning English
    ;;; student back to Japanese every time they connected.  With none
    ;;; sent, the server uses the profile's, or Japanese for a student
    ;;; it has never met.
    lvars args = poparglist, a, host = 'localhost', port = 7801,
          user = false, name = false, lang = false, l1 = false,
          reg, sess, line, cmd, arg;
    ;;; Every flag below reads hd(tl(args)), so the engine's rule from
    ;;; lp_args_ok applies here too: a value-taking flag with no value
    ;;; after it is refused in one line, not three procedures later in
    ;;; a mishap.  The client carries its own copy of the rule for the
    ;;; reason it carries its own clock and its own yes().
    lvars rest = args;
    until rest == [] do
        hd(rest) -> a;
        unless member(a, ['--port' '--host' '--user' '--name'
                          '--lang' '--l1']) then
            tl(rest) -> rest; nextloop
        endunless;
        if tl(rest) == [] or issubstring('--', hd(tl(rest))) == 1 then
            printf('%p wants a value after it.\n', [^a]);
            return;
        endif;
        tl(tl(rest)) -> rest;
    enduntil;
    until args == [] do
        hd(args) -> a;
        if a = '--port' then strnumber(hd(tl(args))) -> port; tl(tl(args)) -> args;
        elseif a = '--host' then hd(tl(args)) -> host; tl(tl(args)) -> args;
        elseif a = '--user' then hd(tl(args)) -> user; tl(tl(args)) -> args;
        elseif a = '--name' then hd(tl(args)) -> name; tl(tl(args)) -> args;
        elseif a = '--lang' then hd(tl(args)) -> lang; tl(tl(args)) -> args;
        ;;; What the student already reads, where --lang is what they
        ;;; are learning.  Sent only when it was given, like --lang and
        ;;; for the same reason: the absent case is the server's flip,
        ;;; and a client that always sent a default would pin every
        ;;; session to it.
        elseif a = '--l1' then hd(tl(args)) -> l1; tl(tl(args)) -> args;
        else tl(args) -> args;
        endif;
    enduntil;

    jsonrpc_connect_wait(host, port, "line", 5) -> lp_conn;
    unless lp_conn then
        printf('langpop: no tutor at %p:%p -- start server.p first\n',
               [% host, port %]);
        return;
    endunless;

    ;;; Enter is asked again here, so a slip costs nothing; anything
    ;;; else the tutor will not file under is the server's to refuse,
    ;;; and it says why (lp_username_why, server side).
    until user do
        printf('Username?  '); sysflush(popdevout);
        readline() -> line;
        returnif(line == termin);
        unless trim(line) = '' then trim(line) -> user endunless;
    enduntil;

    ;;; Ask whether the tutor thinks it has met this person before
    ;;; registering them.  This is the whole point of langpop/recognise
    ;;; existing: without it a client gets a database lookup where the
    ;;; in-process TUI gets a teacher, and the one feature the project
    ;;; asked for by name -- "ahh, is it Bob Smith?" -- was the one thing
    ;;; only langpop.p could do.
    lvars not_me = false, rec, g;
    rpc('langpop/recognise',
        jsonrpc_obj([% 'student_id', user,
                       'display_name', name %])) -> rec;
    if rec and p(rec, 'guess') then
        p(rec, 'guess') -> g;
        printf('Ah -- %p?  (y/n) ', [% p(g, 'display_name') %]);
        sysflush(popdevout);
        readline() -> line;
        if line /== termin and yes(line) then
            ;;; It was them.  Carry on as that student, not a new one.
            p(g, 'student_id') -> user;
        else
            ;;; It was not.  The refused name goes back with the
            ;;; registration so the tutor never offers it to them again.
            p(g, 'display_name') -> not_me;
            printf('My mistake.  And your name?  ');
            sysflush(popdevout);
            readline() -> line;
            if line /== termin and trim(line) /= '' then trim(line) -> name endif;
        endif;
    endif;

    rpc('langpop/register',
        jsonrpc_obj([% 'student_id', user,
                       'display_name', name or user,
                       'language', lang,
                       'not_me', not_me %])) -> reg;
    returnunless(reg);
    p(reg, 'teacher') -> lp_teacher;

    ;;; THIS CLIENT HAS NO SPEAKER, AND SAYS SO.  Look at ask_one: it
    ;;; handles `pick` and prints `prompt` for everything else.  A
    ;;; listening question's prompt is null by design -- there is nothing
    ;;; to read, that being the question -- and its sound arrives in
    ;;; `audio` as a path this program never looks at.  So the honest
    ;;; declaration is an empty list of formats, and the server stops
    ;;; offering a question this client cannot ask.
    ;;;
    ;;; An empty list and an absent key are not the same thing here: see
    ;;; lp_client_caps.  Saying nothing would mean "do as you did
    ;;; before", which is exactly the behaviour being fixed.
    ;;;
    ;;; This is also the half of portability that costs nothing to state:
    ;;; a browser or phone build of this client fills the same field in
    ;;; with what it really has, and nothing on the server changes.
    rpc('langpop/session.open',
        jsonrpc_obj([% 'student_id', user,
                       if l1 then 'l1', l1 endif,
                       'capabilities', jsonrpc_obj([%
                           'audio', jsonrpc_obj([% 'play', {},
                                                   'record', false %]),
                           ;;; A terminal cannot put a jpeg on the screen,
                           ;;; so it says so, for the same reason it says
                           ;;; it has no speaker: a question whose stimulus
                           ;;; this client cannot render is one the student
                           ;;; would be shown nothing for and marked wrong
                           ;;; on.  tools/term-image.py exists and could
                           ;;; change this answer; until the TUI actually
                           ;;; calls it, the honest claim is none.
                           'image', jsonrpc_obj([% 'show', {} %])
                       %]) %])) -> sess;
    returnunless(sess);
    p(sess, 'session_id') -> lp_sid;
    ;;; The sitting starts at the greeting rather than at connect: the
    ;;; minutes before it are the student typing their name, and they are
    ;;; not study.
    sys_microtime() div 1000 -> lp_t0;
    0 -> lp_answered;
    ;;; The minutes before the greeting were the student typing a name,
    ;;; and a pause over that is not time this sitting owes back.
    0 -> lp_idle_ms;
    printf('%p\n', [% p(sess, 'greeting') %]);
    printf('%p -- %p, level %p, %p ready.\n',
           [% p(sess, 'display_name'), p(sess, 'language'),
              p(sess, 'level'), p(sess, 'ready_count') %]);
    help();

    repeat
        ;;; The clock lives in the prompt because a student who has to
        ;;; ask what time it is has already lost track of it.
        printf('\n%p %p> ', [% lp_teacher, lp_clock(lp_elapsed_ms()) %]);
        sysflush(popdevout);
        readline() -> line;
        quitif(line == termin);
        trim(line) -> line;
        if line = '' then
            ask_one();
        elseif line(1) == `:` then
            split2(allbutfirst(1, line)) -> (cmd, arg);
            if cmd = 'quit' or cmd = 'q' then quitloop
            elseif cmd = 'help' or cmd = '?' then help()
            elseif cmd = 'plan' then show_plan()
            elseif cmd = 'why' then
                if arg = '' then printf('  :why <item id>\n') else show_why(arg) endif
            elseif cmd = 'status' then show_status()
            elseif cmd = 'card' then
                if arg = '' then printf('  :card <item id>\n') else show_card(arg) endif
            elseif cmd = 'assign' then do_assign()
            elseif cmd = 'report' then do_report(arg)
            elseif cmd = 'time' then show_time()
            else printf('  I do not know ":%p".  Try :help\n', [^cmd])
            endif;
        else
            printf('  Press enter for the next question, or :help.\n');
        endif;
    endrepeat;

    lvars bye = rpc('langpop/session.close',
                    jsonrpc_obj([% 'session_id', lp_sid %]));
    if bye then printf('\n%p\n', [% p(bye, 'signoff') %]) endif;
    ;;; After the signoff, not instead of it.  The tutor says goodbye;
    ;;; the client says what the sitting was.
    printf('  %p at the keyboard, %p question(s) answered.\n',
           [% lp_clock(lp_elapsed_ms()), lp_answered %]);
    jsonrpc_close(lp_conn);
enddefine;

unless isdefined("langpop_client_lib") then
    client_main();
    ;;; AND STOP, for the reason langpop.p gives at the same place:
    ;;; returning here drops whoever is at the terminal into the
    ;;; Pop-11 top level, which compiles what they type next.
    sysexit();
endunless;
