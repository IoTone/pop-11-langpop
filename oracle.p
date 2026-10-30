/* oracle.p -- the oracle student: a seeded client that climbs the ladder.

   Deterministic, no model.  For each item it carries a competence and a
   coin; the coin decides whether this answer shows the competence, and
   the competence rises with exposure, so a long run resembles learning
   rather than a fixed error rate.  When it is wrong it is wrong the way
   a student is: it reaches for the confusable partner the graph already
   records, mistypes an answer it knew, or freezes -- because those are
   the paths through lp_m_answer, and random noise exercises one of them.

       ./langpop server --port 7899 --data /tmp/oracle-run &
       ./langpop oracle --port 7899 --seed 42 --answers 2000

   It answers over JSON-RPC and nothing else: no pty, no prompt
   scraping, the same surface a GUI client would use.  Its ground truth
   comes from compiling the SAME graph locally -- so it must run against
   a server built from the same checkout, and when the two disagree, one
   of them is wrong and the seed reproduces the disagreement.

   What it asserts, every answer, from the plan's invariant list
   (docs/langpop-standalone-and-validation.md):

     - nothing is offered before its prerequisites: every first offer is
       cross-examined with langpop/explain;
     - the tier-1 belief arithmetic is exact: the belief in the reply is
       the belief in the question moved by the published constants, and
       never past 1.0, and `mastered` flips exactly at MASTERY;
     - a slip, a `later` and an `oops` record nothing and move nothing;
     - save and reload is a fixed point: every so often the run forces
       the server to rebind the student from disk, twice, and the second
       reload must change nothing the first one left;
     - no starvation: the run reports any ready item never offered.

   A failing run prints its seed, and the seed is the bug report.
*/

vars langpop_lib = true;        ;;; the engine as a library: ground truth only
lconstant HERE = sys_fname_path(popfilename);
pop11_compile(HERE <> 'langpop.p');

lp_need_lib("jsonrpc", "jsonrpc_listen");

;;; ------------------------------------------------------------ the knobs
;;; vars, not lconstants, so the test suite can reach them.
vars
    ora_seed      = 1,
    ora_budget    = 2000,
    ora_skill     = 0.0,        ;;; starting competence: 0.0 is "from empty"
    ora_learn     = 0.35,       ;;; competence gained when the answer is shown
    ora_reinforce = 0.15,       ;;; competence gained by answering it right
    ora_later_rate = 0.015,
    ora_fp_every  = 250,        ;;; answers between save/reload fixed-point checks
    ora_verbose   = false,
;

;;; Inside a wrong answer: how the wrongness is spent.  Confusables
;;; first, because シ for ツ is the mistake worth testing; the rest
;;; exercises the slip detector, the skip outcome, and plain error.
lconstant
    ORA_CONFUSE = 0.50,
    ORA_TYPO    = 0.20,
    ORA_SKIP    = 0.15;

lconstant ORA_TOL = 1e-5;       ;;; transport rounds floats near 1e-8

;;; ------------------------------------------------------------- the state
vars
    ora_conn = false,
    ora_seq = 0,
    ora_sid = false,
    ora_user = false,
    ora_lang = 'ja',
    ora_place = false,
    ora_comp = newproperty([], 256, false, "perm"),  ;;; item -> competence
    ora_assigned = newproperty([], 16, 0, "perm"),   ;;; item -> reports sent
    ora_offered = newproperty([], 256, 0, "perm"),   ;;; item -> times offered
    ora_violations = [],
    ora_stats = newproperty([], 16, 0, "perm"),
;

define ora_note(s);
    lvars s;
    conspair(s, ora_violations) -> ora_violations;
    printf('ORACLE VIOLATION: %p\n', [^s]);
enddefine;

define ora_count(k);
    lvars k;
    ora_stats(k) + 1 -> ora_stats(k);
enddefine;

;;; A coin in [0.0, 1.0), from the seeded generator, so a run is a seed.
define ora_u() -> r;
    lvars r;
    random0(1.0) -> r;
enddefine;

;;; --------------------------------------------------------------- the wire
define ora_rpc(method, params) -> result;
    lvars method, params, reply, err;
    ora_seq + 1 -> ora_seq;
    jsonrpc_write(ora_conn,
        jsonrpc_obj([% 'jsonrpc', '2.0', 'id', ora_seq,
                       'method', method, 'params', params %]));
    jsonrpc_read(ora_conn) -> reply;
    if reply == termin or reply == false then
        ora_note('the server stopped answering at ' <> (method sys_>< ''));
        false -> result;
        return;
    endif;
    reply('error') -> err;
    if err then
        ;;; An error reply mid-run is itself a finding: the oracle only
        ;;; sends calls a correct client could send.
        ora_note((method sys_>< '') <> ': ' <> (err('message') sys_>< ''));
        false -> result;
    else
        reply('result') -> result;
    endif;
enddefine;

define ora_p(o, key) -> v;
    lvars o, key, v = false;
    if o and (isproperty(o) or isjson_object(o)) then o(key) -> v endif;
    if v == json_null then false -> v endif;
enddefine;

;;; --------------------------------------------------------- ground truth
;;; What the graph says the answer is, recomputed on this side of the
;;; socket.  A counting probe's answer depends on which material the
;;; server chose, so it is recomputed FROM THE PROMPT; everything else
;;; comes from asking the local lp_question the same question.  An empty
;;; list means "this side cannot know" (a listening pair, where the
;;; answer is in the audio), and the oracle declines those rather than
;;; guessing.
define ora_truth(item, shape, prompt, options) -> t;
    lvars item, shape, prompt, options, t = [],
          sh, pr, ans, op, a, m, f, i, correct;
    (shape sys_>< '') -> shape;
    if shape = 'type' or shape = 'listen' then
        lp_question(item, lp_primary(item)) -> (sh, pr, ans, op);
        [% for a in ans do a sys_>< '' endfor %] -> t;
    elseif shape = 'count' then
        if lp_probe_kind(item) == "morae" then
            [% lp_morae(prompt) sys_>< '' %] -> t;
        else
            for m in lp_probe_material(item) do
                lp_form_of(m, "latin") -> f;
                if f and (f sys_>< '') = (prompt sys_>< '') then
                    [% lp_syllables(lp_form_of(m, "ipa")) sys_>< '' %] -> t;
                    quitloop;
                endif;
            endfor;
        endif;
    elseif shape = 'pick' then
        ;;; The local coin flip need not match the server's, so the match
        ;;; is on the TEXT of the right option, mapped to the server's
        ;;; numbering.
        lp_question(item, lp_primary(item)) -> (sh, pr, ans, op);
        if sh == "pick" and ans /== [] then
            op(strnumber(hd(ans) sys_>< '')) -> correct;
            for i from 1 to length(options) do
                if lp_norm(options(i) sys_>< '') = lp_norm(correct sys_>< '')
                then [% i sys_>< '' %] -> t; quitloop;
                endif;
            endfor;
        endif;
    endif;
enddefine;

;;; A typo the slip detector is meant to catch: one character changed, on
;;; an answer long enough that lp_typo_tol allows any tolerance at all.
;;; Returns false when the answer is too short to slip on.
define ora_typo(right) -> t;
    lvars right, t = false, n;
    (right sys_>< '') -> right;
    length(right) -> n;
    returnif(lp_typo_tol(n) == 0);
    copy(right) -> t;
    if t(2) == `q` then `x` else `q` endif -> t(2);
enddefine;

;;; The confusable partner's form, lowered the way lp_mistook compares it,
;;; or false when the item has no partner with a typable form.
define ora_confusion(item) -> given;
    lvars item, given = false, p, sc, f;
    for p in lp_confs(item) do
        for sc in [romaji latin hiragana katakana kanji] do
            lp_form_of(hd(p), sc) -> f;
            if f then lp_lower(f sys_>< '') -> given; return endif;
        endfor;
    endfor;
enddefine;

;;; ------------------------------------------------------- the invariants
define ora_check_prereqs(item);
    lvars item, res, pre, prew;
    ora_rpc('langpop/explain',
            jsonrpc_obj([% 'session_id', ora_sid,
                           'item', item sys_>< '' %])) -> res;
    returnunless(res);
    for pre in datalist(ora_p(res, 'prerequisites')) do
        nextif(ora_p(pre, 'known'));
        ;;; A prerequisite nothing can check does not hold the door shut
        ;;; -- gate_ok's second clause, judged here from the same graph.
        ;;; Every English trap requires the sound contrasts, and all of
        ;;; them are ungateable until a listening question can ask a
        ;;; minimal pair.
        consword(ora_p(pre, 'item') sys_>< '') -> prew;
        nextif(lp_ungateable(prew));
        ora_note((item sys_>< '') <> ' offered before its prerequisite '
                 <> (prew sys_>< ''));
    endfor;
enddefine;

define ora_expected_post(pre, outcome) -> post;
    lvars pre, outcome, post;
    if     outcome = 'right' then pre + (1.0 - pre) * 0.45
    elseif outcome = 'near'  then pre * 0.45
    elseif outcome = 'wrong' then pre * 0.30
    else                          pre * 0.20      ;;; skip
    endif -> post;
enddefine;

;;; The belief in the reply against the belief in the question, moved by
;;; the published tier-1 constants.  Only when the question was asked on
;;; the item's gate channel, because that is the channel both numbers
;;; report.
define ora_check_arith(item, outcome, pre, post, mastered);
    lvars item, outcome, pre, post, mastered, want;
    ora_expected_post(pre * 1.0, outcome) -> want;
    unless abs(post - want) < ORA_TOL then
        ora_note((item sys_>< '') <> ' ' <> outcome <> ': belief '
                 <> (pre sys_>< '') <> ' became ' <> (post sys_>< '')
                 <> ', expected ' <> (want sys_>< ''));
    endunless;
    unless post <= 1.0 then
        ora_note((item sys_>< '') <> ': belief above 1.0: ' <> (post sys_>< ''));
    endunless;
    unless mastered == (post >= MASTERY - ORA_TOL) or abs(post - MASTERY) < ORA_TOL
    then
        ora_note((item sys_>< '') <> ': mastered says ' <> (mastered sys_>< '')
                 <> ' at belief ' <> (post sys_>< ''));
    endunless;
enddefine;

;;; Save and reload as a fixed point.  lp_bind is a no-op for the student
;;; already bound, so the reload is forced by binding a decoy and coming
;;; back.  Two round trips, compared to each other rather than to the
;;; in-memory value: the first reload may round what the save rounded,
;;; but a reload of what a reload produced must change NOTHING, or the
;;; profile drifts a little every restart.
define ora_fixed_point(sample);
    lvars sample, it, res, a = [], b = [], x, y, pa, pb;

    define grab(sample) -> l;
        lvars sample, it, res, l;
        [% for it in sample do
               ora_rpc('langpop/explain',
                       jsonrpc_obj([% 'session_id', ora_sid,
                                      'item', it sys_>< '' %])) -> res;
               if res then ora_p(res, 'belief') * 1.0 else false endif;
           endfor %] -> l;
    enddefine;

    define rebind();
        lvars res;
        ora_rpc('langpop/register',
                jsonrpc_obj([% 'student_id', 'oracle-decoy' %])) -> res;
        ora_rpc('langpop/session.open',
                jsonrpc_obj([% 'student_id', ora_user %])) -> res;
        returnunless(res);
        ora_p(res, 'session_id') -> ora_sid;
    enddefine;

    rebind(); grab(sample) -> a;
    rebind(); grab(sample) -> b;
    for it in sample do
        dest(a) -> (pa, a); dest(b) -> (pb, b);
        nextunless(pa and pb);
        unless abs(pa - pb) < 1e-12 then
            ora_note((it sys_>< '') <> ': reload is not a fixed point: '
                     <> (pa sys_>< '') <> ' then ' <> (pb sys_>< ''));
        endunless;
    endfor;
enddefine;

;;; -------------------------------------------------------- away from keys
;;; When nothing is left that typing can check, a real student asks for
;;; homework, does it, and reports back -- the tier-2/3 path, which no
;;; harness had ever walked.  The arithmetic is asserted exactly, like
;;; tier 1's: a score moves the gate belief by lp_record's tier-2 rule
;;; and never past TIER2_CAP; "ok" moves it by the tier-3 rule and never
;;; past TIER3_CAP; neither ever reaches mastery on its own.
;;;
;;; Returns true when an assignment was reported, false when the tutor
;;; has nothing left to hand out -- which is where the run ends.
define ora_study() -> did;
    lvars did = false, res, item, itemw, aid, pre, post, want, outcome,
          c, tier;

    define belief_of(itemw) -> b;
        lvars itemw, b = false, res;
        ora_rpc('langpop/explain',
                jsonrpc_obj([% 'session_id', ora_sid,
                               'item', itemw sys_>< '' %])) -> res;
        if res then (ora_p(res, 'belief') or 0) * 1.0 -> b endif;
    enddefine;

    ora_rpc('langpop/assign', jsonrpc_obj([% 'session_id', ora_sid %])) -> res;
    returnunless(res);
    ora_p(res, 'assignment_id') -> aid;
    returnunless(aid);
    consword(ora_p(res, 'item') sys_>< '') -> itemw;

    ;;; An unprobeable item reported for ever asymptotes at TIER2_CAP and
    ;;; never leaves the plan, so the tutor will hand it out again and
    ;;; again -- which is honest of the tutor and would be an endless run
    ;;; for the oracle.  Three reports is enough to test the path.
    returnif(ora_assigned(itemw) >= 3);
    ora_assigned(itemw) + 1 -> ora_assigned(itemw);

    if ora_comp(itemw) == false then ora_skill -> ora_comp(itemw) endif;
    ora_comp(itemw) -> c;
    belief_of(itemw) -> pre;
    returnunless(pre /== false)(true -> did);

    if ora_u() < 0.25 then
        'ok' -> outcome; 3 -> tier;
    elseif ora_u() < c then
        '18/20' -> outcome; 2 -> tier;      ;;; a result worth reporting
    else
        '10/20' -> outcome; 2 -> tier;      ;;; below the 0.7 line
    endif;
    ora_rpc('langpop/report',
            jsonrpc_obj([% 'session_id', ora_sid,
                           'assignment_id', aid,
                           'outcome', outcome %])) -> res;
    returnunless(res)(true -> did);
    true -> did;
    ora_count("report");

    unless ora_p(res, 'tier') == tier then
        ora_note((itemw sys_>< '') <> ': reported "' <> outcome
                 <> '" expecting tier ' <> (tier sys_>< '')
                 <> ', server said ' <> (ora_p(res, 'tier') sys_>< ''));
    endunless;
    (ora_p(res, 'belief') or 0) * 1.0 -> post;
    if tier == 2 then
        min(pre + (1.0 - pre) * 0.20
              * (if outcome = '18/20' then 1.0 else 0.3 endif),
            TIER2_CAP) -> want;
    else
        min(pre + 0.05, TIER3_CAP) -> want;
    endif;
    unless abs(post - want) < ORA_TOL then
        ora_note((itemw sys_>< '') <> ' report ' <> outcome <> ': belief '
                 <> (pre sys_>< '') <> ' became ' <> (post sys_>< '')
                 <> ', expected ' <> (want sys_>< ''));
    endunless;
    if ora_p(res, 'mastered') and pre < MASTERY then
        ora_note((itemw sys_>< '') <> ': a report alone reached mastery');
    endif;

    ;;; studying teaches, whatever the report said
    c + (1.0 - c) * ora_learn -> ora_comp(itemw);
enddefine;

;;; ------------------------------------------------------------- one turn
;;; Returns true while there is anything left to answer.
define ora_turn() -> more;
    lvars more = true, q, item, itemw, shape, prompt, options, ch, chw,
          pre, requeued, truth, given, intent, res, outcome, recorded,
          post, mastered, c, u, gate;

    ora_rpc('langpop/next', jsonrpc_obj([% 'session_id', ora_sid %])) -> q;
    returnunless(q)(false -> more);
    ora_p(q, 'item') -> item;
    unless item then
        ;;; nothing to type: ask for homework instead, and only when the
        ;;; tutor has none either is the rung exhausted for this harness
        ora_study() -> more;
        if not(more) and ora_verbose then
            printf(';;; next: %p\n', [% ora_p(q, 'note') %]);
        endif;
        return;
    endunless;
    consword(item sys_>< '') -> itemw;
    ora_p(q, 'shape') sys_>< '' -> shape;
    ora_p(q, 'prompt') -> prompt;
    datalist(ora_p(q, 'options') or {}) -> options;
    ora_p(q, 'channel') -> ch;
    consword(ch sys_>< '') -> chw;
    (ora_p(q, 'belief') or 0) * 1.0 -> pre;
    ora_p(q, 'requeued') -> requeued;

    ;;; the arithmetic is only checkable when both numbers are on the
    ;;; gate channel, which is where lp_m_answer reports belief
    chw == lp_primary(itemw) -> gate;

    if ora_offered(itemw) == 0 then ora_check_prereqs(itemw) endif;
    ora_offered(itemw) + 1 -> ora_offered(itemw);

    ora_truth(itemw, shape, prompt, options) -> truth;
    if truth == [] then
        ;;; this side cannot know the answer (a listening pair): decline
        ;;; honestly rather than guess, and expect a recorded skip
        '' -> given; 'skip' -> intent;
    else
        if ora_comp(itemw) == false then ora_skill -> ora_comp(itemw) endif;
        ora_comp(itemw) -> c;

        if ora_u() < ora_later_rate and not(requeued) then
            ora_rpc('langpop/answer',
                    jsonrpc_obj([% 'session_id', ora_sid,
                                   'item', itemw sys_>< '',
                                   'action', 'later' %])) -> res;
            returnunless(res);
            if ora_p(res, 'recorded') then
                ora_note((itemw sys_>< '') <> ': later was recorded');
            endif;
            ora_count("later");
            ;;; accepted or refused, nothing was answered: the item comes
            ;;; round again and the turn is over
            return;
        endif;

        if ora_u() < c then
            hd(truth) -> given; 'right' -> intent;
        else
            ora_u() -> u;
            if u < ORA_CONFUSE and (shape = 'type' or shape = 'listen')
            and ora_confusion(itemw) then
                ora_confusion(itemw) -> given;
                ;;; the partner's form could, on a bad day, be a correct
                ;;; answer or a near-typo; classify it the way the server
                ;;; will, from this side's own structures
                if member(lp_norm(given), maplist(truth, lp_norm)) then
                    'right'
                elseif lp_mistook(itemw, lp_norm(given)) then 'near'
                elseif lp_slip(lp_norm(given), truth) then 'slip'
                else 'wrong'
                endif -> intent;
            elseif u < ORA_CONFUSE + ORA_TYPO and ora_typo(hd(truth)) then
                ora_typo(hd(truth)) -> given;
                if lp_mistook(itemw, lp_norm(given)) then 'near'
                else 'slip' endif -> intent;
            elseif u < ORA_CONFUSE + ORA_TYPO + ORA_SKIP then
                '' -> given; 'skip' -> intent;
            else
                'zzq' -> given;
                if shape = 'count' then 'count_wrong' else 'wrong' endif -> intent;
            endif;
        endif;
    endif;

    ora_rpc('langpop/answer',
            jsonrpc_obj([% 'session_id', ora_sid,
                           'item', itemw sys_>< '',
                           'answer', given %])) -> res;
    returnunless(res);

    ora_p(res, 'outcome') sys_>< '' -> outcome;
    ora_p(res, 'recorded') -> recorded;

    ;;; A slip is forgiven once and recorded never; the oracle, like the
    ;;; student the aid was built for, gets it right on the second go.
    if outcome = 'slip' then
        ora_count("slip");
        if recorded then
            ora_note((itemw sys_>< '') <> ': a slip was recorded');
        endif;
        if gate and abs((ora_p(res, 'belief') * 1.0) - pre) > ORA_TOL then
            ora_note((itemw sys_>< '') <> ': a slip moved the belief');
        endif;
        unless intent = 'slip' then
            ora_note((itemw sys_>< '') <> ': ' <> intent
                     <> ' was judged a slip: ' <> given);
        endunless;
        hd(truth) -> given; 'right' -> intent;
        ora_rpc('langpop/answer',
                jsonrpc_obj([% 'session_id', ora_sid,
                               'item', itemw sys_>< '',
                               'answer', given %])) -> res;
        returnunless(res);
        ora_p(res, 'outcome') sys_>< '' -> outcome;
        ora_p(res, 'recorded') -> recorded;
    endif;

    unless recorded then
        ora_note((itemw sys_>< '') <> ': an answer was not recorded ('
                 <> outcome <> ')');
        return;
    endunless;

    ;;; the outcome the server declared against the outcome this side
    ;;; expected from the same graph
    unless outcome = intent
    or (intent = 'count_wrong' and (outcome = 'wrong' or outcome = 'near'))
    then
        ora_note((itemw sys_>< '') <> ': answered "' <> given
                 <> '" expecting ' <> intent <> ', server said ' <> outcome);
    endunless;
    ora_count(consword(outcome));

    (ora_p(res, 'belief') or 0) * 1.0 -> post;
    ora_p(res, 'mastered') -> mastered;
    if gate then ora_check_arith(itemw, outcome, pre, post, mastered) endif;

    ;;; learning: being shown the answer teaches more than being right
    ora_comp(itemw) -> c;
    if outcome = 'right' then c + (1.0 - c) * ora_reinforce -> ora_comp(itemw);
    elseif ora_p(res, 'expected') then
        c + (1.0 - c) * ora_learn -> ora_comp(itemw);
    endif;
enddefine;

;;; ----------------------------------------------------------- placement
;;; --place runs the five-minute interview instead of the climb.  The
;;; student's competence is FIXED here (ora_skill, no drift): a test is
;;; a measurement, and a student who learns the material from the test
;;; while taking it would make the verdict untestable.
;;;
;;; What it asserts, against its own transcript rather than the server's
;;; bookkeeping -- the engine's constants restated: PLACE_SAMPLE 4,
;;; PLACE_PASS 0.75, PLACE_FREEZE 2 (lconstants in langpop.p, so they
;;; are repeated here; if someone retunes the descent, this is the test
;;; that says the oracle must be retuned with it):
;;;
;;;   - the descent TERMINATES well inside a budget; the sampler used to
;;;     return the same head every time, and a driver looping on it
;;;     asked about the same kana four times running;
;;;   - nothing is asked again once an answer to it was RECORDED (a slip
;;;     is not recorded, so the retry is the same question, honestly);
;;;   - every axis the report places is one the transcript agrees was
;;;     passed: accuracy >= 0.75 over that axis's items at that level,
;;;     with the sample quorum met.
define ora_place_run();
    lvars q, item, itemw, shape, prompt, options, truth, given, res,
          outcome, recorded, u, n = 0, level = false,
          answered = newproperty([], 64, 0, "perm"),
          transcript = [];        ;;; [[item outcome] ...] as recorded

    repeat 300 times
        ora_rpc('langpop/placement.next',
                jsonrpc_obj([% 'session_id', ora_sid %])) -> q;
        returnunless(q);
        if ora_p(q, 'done') then
            ora_p(q, 'level') -> level;
            quitloop;
        endif;
        n + 1 -> n;
        consword(ora_p(q, 'item') sys_>< '') -> itemw;
        ora_p(q, 'shape') sys_>< '' -> shape;
        ora_p(q, 'prompt') -> prompt;
        datalist(ora_p(q, 'options') or {}) -> options;

        if answered(itemw) > 0 then
            ora_note('placement asked ' <> (itemw sys_>< '')
                     <> ' again after recording an answer');
        endif;

        ora_truth(itemw, shape, prompt, options) -> truth;
        if truth == [] or (ora_u() >= ora_skill) then
            ;;; wrong on purpose: half freezes, half reaches for the
            ;;; confusable -- the two mistakes the descent reads
            if truth == [] or ora_u() < 0.5 then '' -> given;
            else (ora_confusion(itemw) or 'zzq') -> given;
            endif;
        else
            hd(truth) -> given;
        endif;
        ora_rpc('langpop/answer',
                jsonrpc_obj([% 'session_id', ora_sid,
                               'item', itemw sys_>< '',
                               'answer', given %])) -> res;
        returnunless(res);
        if (ora_p(res, 'outcome') sys_>< '') = 'slip' then
            ;;; not recorded; answer properly, as the student would
            ora_rpc('langpop/answer',
                    jsonrpc_obj([% 'session_id', ora_sid,
                                   'item', itemw sys_>< '',
                                   'answer', if truth == [] then ''
                                             else hd(truth) endif %])) -> res;
            returnunless(res);
        endif;
        if ora_p(res, 'recorded') then
            answered(itemw) + 1 -> answered(itemw);
            conspair([% itemw, consword(ora_p(res, 'outcome') sys_>< '') %],
                     transcript) -> transcript;
        endif;
    endrepeat;

    unless level then
        ora_note('placement did not settle within 300 questions');
        return;
    endunless;
    printf('placed after %p questions: teaching starts at %p\n',
           [% n, level %]);

    ;;; the verdict, re-derived from this side's transcript
    ora_rpc('langpop/placement.report',
            jsonrpc_obj([% 'session_id', ora_sid %])) -> res;
    returnunless(res);
    lvars row, ax, placed, a, axis, items, e, right, total;
    for row in datalist(ora_p(res, 'axes') or {}) do
        ora_p(row, 'axis') sys_>< '' -> ax;
        ora_p(row, 'placed') -> placed;
        printf('  %p: %p (%p)\n', [% ax, placed or 'unplaced',
                                     ora_p(row, 'why') %]);
        nextunless(placed);
        false -> axis;
        for a in lp_place_axes() do
            if (a(1) sys_>< '') = ax then a -> axis; quitloop endif;
        endfor;
        unless axis then
            ora_note('the report names an axis this graph does not: ' <> ax);
            nextloop;
        endunless;
        lp_place_items(axis, consword(placed sys_>< '')) -> items;
        0 -> right; 0 -> total;
        for e in transcript do
            nextunless(member(e(1), items));
            total + 1 -> total;
            if e(2) == "right" then right + 1 -> right endif;
        endfor;
        if total == 0 then
            ora_note(ax <> ' placed at ' <> (placed sys_>< '')
                     <> ' with no recorded answer there');
        elseif total < min(4, length(items)) then
            ora_note(ax <> ' placed at ' <> (placed sys_>< '')
                     <> ' on ' <> (total sys_>< '') <> ' answers, below the quorum');
        elseif (right * 1.0) / total < 0.75 then
            ora_note(ax <> ' placed at ' <> (placed sys_>< '') <> ' on '
                     <> (right sys_>< '') <> ' of ' <> (total sys_>< ''));
        endif;
    endfor;
enddefine;

;;; -------------------------------------------------------------- the run
define ora_sample() -> l;
    lvars l = [], n = 0;
    appproperty(ora_offered,
                procedure(k, v);
                    lvars k, v;
                    if v > 0 and n < 5 then
                        conspair(k, l) -> l; n + 1 -> n
                    endif;
                endprocedure);
enddefine;

define ora_report();
    lvars res, c, items, i, missing = [], ready = 0;
    ora_rpc('langpop/status', jsonrpc_obj([% 'session_id', ora_sid %])) -> res;
    if res then
        printf('\nlevel %p, %p ready\n',
               [% ora_p(res, 'level'), ora_p(res, 'ready_count') %]);
        for c in datalist(ora_p(res, 'criteria') or {}) do
            if ora_p(c, 'kind') = 'count' then
                printf('  %p: %p of %p (graph holds %p)\n',
                       [% ora_p(c, 'criterion'), ora_p(c, 'have'),
                          ora_p(c, 'want'), ora_p(c, 'in_graph') %]);
            elseif ora_p(c, 'kind') = 'measured' then
                printf('  %p: accuracy %p, within latency %p, over %p\n',
                       [% ora_p(c, 'criterion'), ora_p(c, 'accuracy'),
                          ora_p(c, 'within_latency'), ora_p(c, 'answers') %]);
            endif;
        endfor;
    endif;

    ;;; starvation: a ready item the whole run never offered.  Only the
    ;;; DRILLABLE ready items count -- a pattern has no typed question
    ;;; and is taught by assignment, so `next` not offering it is the
    ;;; design, not a scheduler hole.  It is still printed, because a
    ;;; rung whose remaining pool is entirely unaskable is worth seeing.
    lvars unaskable = [];
    ora_rpc('langpop/plan',
            jsonrpc_obj([% 'session_id', ora_sid, 'limit', 100000 %])) -> res;
    if res then
        datalist(ora_p(res, 'items') or {}) -> items;
        length(items) -> ready;
        for i in items do
            lvars iw = consword(ora_p(i, 'item') sys_>< '');
            nextunless(ora_offered(iw) == 0);
            if lp_drillable(iw) then conspair(iw, missing) -> missing;
            else conspair(iw, unaskable) -> unaskable;
            endif;
        endfor;
        unless missing == [] or ora_budget < 20 * ready then
            ora_note((length(missing) sys_>< '')
                     <> ' askable ready items were never offered, e.g. '
                     <> (hd(missing) sys_>< ''));
        endunless;
        unless unaskable == [] then
            printf(';;; %p ready items have no typed question (assign teaches them), e.g. %p\n',
                   [% length(unaskable), hd(unaskable) %]);
        endunless;
    endif;

    printf('\n%p answered: %p right, %p near, %p wrong, %p skip; %p slips, %p laters, %p reports\n',
           [% ora_stats("right") + ora_stats("near")
                + ora_stats("wrong") + ora_stats("skip"),
              ora_stats("right"), ora_stats("near"), ora_stats("wrong"),
              ora_stats("skip"), ora_stats("slip"), ora_stats("later"),
              ora_stats("report") %]);
enddefine;

define ora_main();
    lvars args = poparglist, a, host = 'localhost', port = 7801, res, n = 0;
    find_dir() -> langpop_dir;
    lp_load();
    lp_index();
    until args == [] do
        hd(args) -> a;
        if a = '--port' then strnumber(hd(tl(args))) -> port; tl(tl(args)) -> args;
        elseif a = '--host' then hd(tl(args)) -> host; tl(tl(args)) -> args;
        elseif a = '--seed' then strnumber(hd(tl(args))) -> ora_seed; tl(tl(args)) -> args;
        elseif a = '--answers' then strnumber(hd(tl(args))) -> ora_budget; tl(tl(args)) -> args;
        elseif a = '--skill' then strnumber(hd(tl(args))) -> ora_skill; tl(tl(args)) -> args;
        elseif a = '--user' then hd(tl(args)) -> ora_user; tl(tl(args)) -> args;
        elseif a = '--lang' then hd(tl(args)) -> ora_lang; tl(tl(args)) -> args;
        elseif a = '--place' then true -> ora_place; tl(args) -> args;
        elseif a = '--verbose' then true -> ora_verbose; tl(args) -> args;
        else tl(args) -> args;
        endif;
    enduntil;
    ;;; the local engine judges gateability per language, so it must be
    ;;; looking at the same one the server is teaching
    consword(ora_lang sys_>< '') -> lp_lang;
    unless ora_user then
        'oracle-' sys_>< ora_lang sys_>< '-' sys_>< ora_seed -> ora_user
    endunless;
    ora_seed -> ranseed;

    jsonrpc_connect_wait(host, port, "line", 5) -> ora_conn;
    unless ora_conn then
        printf('oracle: no server at %p:%p\n', [% host, port %]);
        sysexit(3);
    endunless;

    ora_rpc('langpop/register',
            jsonrpc_obj([% 'student_id', ora_user,
                           'language', ora_lang %])) -> res;
    ora_rpc('langpop/session.open',
            jsonrpc_obj([% 'student_id', ora_user %])) -> res;
    unless res then
        printf('oracle: could not open a session\n');
        sysexit(3);
    endunless;
    ora_p(res, 'session_id') -> ora_sid;

    if ora_place then
        printf('oracle: placement, seed %p, skill %p, as %p\n',
               [% ora_seed, ora_skill, ora_user %]);
        ora_place_run();
        if ora_violations == [] then
            printf('ORACLE PASS (placement, seed %p)\n', [^ora_seed]);
            sysexit(0);
        else
            printf('ORACLE FAIL (placement, seed %p): %p violations\n',
                   [% ora_seed, length(ora_violations) %]);
            sysexit(2);
        endif;
    endif;

    printf('oracle: seed %p, %p answers, skill %p, as %p\n',
           [% ora_seed, ora_budget, ora_skill, ora_user %]);

    repeat ora_budget times
        n + 1 -> n;
        quitunless(ora_turn());
        if n mod ora_fp_every == 0 and ora_sample() /== [] then
            ora_fixed_point(ora_sample());
        endif;
    endrepeat;

    ora_report();
    if ora_violations == [] then
        printf('ORACLE PASS (seed %p, %p turns)\n', [% ora_seed, n %]);
        sysexit(0);
    else
        printf('ORACLE FAIL (seed %p): %p violations\n',
               [% ora_seed, length(ora_violations) %]);
        sysexit(2);
    endif;
enddefine;

unless isdefined("langpop_oracle_lib") then
    ora_main();
endunless;
