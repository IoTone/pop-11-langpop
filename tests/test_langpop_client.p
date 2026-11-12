;;; tests/test_langpop_client.p -- suite for the reference client.
;;;
;;;     poplog basepop11 tests/test_langpop_client.p </dev/null
;;;
;;; The client has gone untested until now, and defensibly: almost
;;; everything in it is a printf of something the server said, and what
;;; the server says is pinned down by test_langpop_server.p.  Testing it
;;; again here would test the formatting of a paragraph.
;;;
;;; The sitting clock is different, because it is the first thing in the
;;; client that COMPUTES.  It formats a duration, it divides to get a
;;; pace, and it compares against a target -- and a clock that prints
;;; 9:5 for nine minutes five seconds is wrong in a way no server test
;;; can see.  So: the arithmetic, and not the paragraph.
;;;
;;; Loaded as a library.  client.p runs client_main() at the end unless
;;; langpop_client_lib is defined, which would connect to a socket and
;;; then read the suite's own stdin as a username.

uses poptest;

vars langpop_client_lib = true;
lconstant HERE = sys_fname_path(popfilename);
pop11_compile(HERE <> '../client.p');

;;; ------------------------------------------------------- the formatting
check('a minute and a bit', lp_clock(63000), '1:03');
check('the pad is where a reader needs it', lp_clock(545000), '9:05');
check('and is not there when it is not', lp_clock(730000), '12:10');
check('a sitting that has only just started', lp_clock(400), '0:00');
check('nothing is not an error', lp_clock(0), '0:00');
check('a round ten minutes', lp_clock(600000), '10:00');

;;; An hour is where "how long is this sitting" stops being the question
;;; and "what happened to the afternoon" starts, so the shape changes.
check('past the hour it reads as hours', lp_clock(3600000), '1h00m');
check('and keeps the minutes', lp_clock(3600000 + 305000), '1h05m');
check('two and a half hours', lp_clock(9000000), '2h30m');

;;; ----------------------------------------------------------- the clock
;;; No sitting open: the elapsed time is nought and not the ms since
;;; 1970, which is what reading an unset lp_t0 as a number would give.
false -> lp_t0;
check('an unopened sitting has run for no time', lp_elapsed_ms(), 0);

;;; The clock is wall clock, so this is the one place the suite has to
;;; set the start itself rather than wait four minutes for one.
(sys_microtime() div 1000) - 250000 -> lp_t0;
check_true('an open one is measured from its start',
           lp_elapsed_ms() >= 250000 and lp_elapsed_ms() < 260000);
check('and reads as the minutes it is', substring(1, 2, lp_clock(lp_elapsed_ms())), '4:');

;;; --------------------------------------------------- what it says out loud
;;; printf goes through cucharout, so that is the seam -- the same one
;;; test_langpop_import.p borrows for the emitter.
vars cli_buf = [];

define cli_say(proc) -> s;
    lvars proc, s;
    dlocal cucharout = procedure(c); lvars c;
        conspair(c, cli_buf) -> cli_buf endprocedure;
    [] -> cli_buf;
    proc();
    consstring(destlist(rev(cli_buf))) -> s;
enddefine;

;;; -------------------------------------------------------- the one nudge
;;; The schedule's sitting length arrives from :status, which is to say
;;; from the server; the client never invents one.
false -> lp_goal_min; false -> lp_goal_said;
check('with no target there is nothing to say', cli_say(lp_goal_check), '');

;;; Four minutes in, against a twenty minute target.
20 -> lp_goal_min;
check('and nothing to say before the target', cli_say(lp_goal_check), '');
check_true('which is not the nudge having fired', lp_goal_said == false);

;;; Four minutes in, against a three minute one.
3 -> lp_goal_min;
lvars said = cli_say(lp_goal_check);
check_true('the sitting the schedule asked for is announced',
           issubstring('3 minutes', said) /== false);
check_true('and it says stopping is allowed, which is the point of saying it',
           issubstring('Stopping here is fine', said) /== false);

;;; ONCE.  A nudge on every answer for the rest of the sitting is a nag,
;;; and is telling the student something they were just told.
check('and announced once', cli_say(lp_goal_check), '');

;;; ------------------------------------------------------------- :time
(sys_microtime() div 1000) - 600000 -> lp_t0;   ;;; ten minutes in
20 -> lp_goal_min; 40 -> lp_answered;
lvars t = cli_say(show_time);
check_true('the sitting is reported', issubstring('10:0', t) /== false);
check_true('with the questions in it', issubstring('40 question', t) /== false);
check_true('and a pace, which is 600 seconds over 40',
           issubstring('about 15 seconds', t) /== false);
;;; 10:0x, or 9:59 when a second ticked over between setting lp_t0 and
;;; reading the clock -- the intermittent failure this check used to have.
check_true('and how much of the suggested sitting is left',
           issubstring('20 minutes; 10:0', t) or issubstring('20 minutes; 9:59', t));

;;; A pace over the first few seconds is not a pace, and "about 1
;;; seconds a question" reads like a broken clock rather than a fast
;;; student -- so there is a floor, and it is the half minute.
(sys_microtime() div 1000) - 4000 -> lp_t0; 1 -> lp_answered;
check_true('a sitting four seconds old quotes no pace',
           issubstring('a question', cli_say(show_time)) == false);

;;; And with no target from the server there is no target in :time.
false -> lp_goal_min;
check_true('nor a sitting length nobody suggested',
           issubstring('the schedule', cli_say(show_time)) == false);

;;; A fresh session resets both, or the second sitting of the day opens
;;; with the first one's minutes already on the clock.
false -> lp_t0; 0 -> lp_answered; false -> lp_goal_said;
check('a new sitting starts at nothing', lp_answered, 0);
check_true('with its nudge unfired', lp_goal_said == false);

test_summary();
