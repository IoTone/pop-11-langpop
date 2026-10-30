;;; tests/test_langpop_oracle.p -- suite for the oracle student's own parts.
;;;
;;;     poplog basepop11 tests/test_langpop_oracle.p </dev/null
;;;
;;; The oracle's value is that a failing run is a seed, so the parts that
;;; make a run from a seed are what this suite pins down: the generator
;;; repeats, the ground truth answers what the server will ask, the typo
;;; is one the slip detector catches, and the arithmetic it asserts is
;;; the arithmetic lp_record performs.  The socket itself is exercised by
;;; `./langpop oracle`, not here -- a suite that had to spawn a server
;;; would be testing the shell.

uses poptest;
uses utf8;

vars langpop_oracle_lib = true;
lconstant HERE = sys_fname_path(popfilename);
pop11_compile(HERE <> '../oracle.p');

find_dir() -> langpop_dir;
lp_load();
lp_index();
"oracle_test" -> lp_user;
"ja" -> lp_lang;
"preschool" -> lp_level;

;;; --------------------------------------------------------- the generator
;;; One seed, one run: the whole argument for the oracle over a model.
lvars a, b;
7 -> ranseed;
[% repeat 5 times ora_u() endrepeat %] -> a;
7 -> ranseed;
[% repeat 5 times ora_u() endrepeat %] -> b;
check('the same seed deals the same coins', a, b);
check_true('and they are coins', ora_u() >= 0.0 and ora_u() < 1.0);

;;; -------------------------------------------------------- the arithmetic
;;; The constants the oracle asserts against are lp_record's, checked by
;;; doing what lp_record does and comparing.  If someone retunes the
;;; engine, this is the test that says the oracle must be retuned with it.
lvars pre = 0.5;
lp_record("hi_a", "read", 1, "right", 400);
check_true('right matches lp_record',
           abs(ora_expected_post(0.0, 'right')
               - lp_bel("hi_a", "read")) < 1e-9);
lp_record("hi_i", "read", 1, "wrong", 400);
check_true('wrong matches lp_record',
           abs(ora_expected_post(0.0, 'wrong')
               - lp_bel("hi_i", "read")) < 1e-9);
check_true('three rights from nothing is mastery',
           ora_expected_post(ora_expected_post(ora_expected_post(0.0, 'right'),
                                               'right'), 'right') >= MASTERY);
check_true('and two is not',
           ora_expected_post(ora_expected_post(0.0, 'right'), 'right')
           < MASTERY);

;;; ---------------------------------------------------------- ground truth
;;; A typed kana question: the truth is the romaji the graph hands out.
lvars t = ora_truth("hi_a", 'type', 'あ', []);
check_true('a kana truth is its romaji', member('a', t));

;;; A counting probe's answer depends on which material the server chose,
;;; so it is recomputed from the PROMPT, not from a second coin flip.
check('a morae truth is counted from the prompt',
      ora_truth("mora_count", 'count', 'がっこう', []), ['4']);

;;; A pick question's options arrive in the SERVER's order, so the truth
;;; is the right text mapped to the server's numbering -- both orders
;;; must give the right index.
lvars w = false, i;
for i in lp_items do
    if lp_kind(i) == "word" and lp_ilang(i) == "en"
    and lp_gloss_of(i, "en") and lp_gloss_of(i, "ja") then
        i -> w; quitloop;
    endif;
endfor;
if w then
    lvars en = lp_gloss_of(w, "en") sys_>< '',
          ja = lp_gloss_of(w, "ja") sys_>< '';
    check('the right text in first place is 1',
          ora_truth(w, 'pick', '', [^en ^ja]), ['1']);
    check('and in second place is 2',
          ora_truth(w, 'pick', '', [^ja ^en]), ['2']);
else
    printf(';;; no two-gloss English word loaded -- pick truth not checked\n');
endif;

;;; ------------------------------------------------------------- the typo
;;; The typo exists to exercise the slip aid, so the one test that
;;; matters is that lp_slip calls it a slip.
check_false('a short answer cannot slip', ora_typo('ka'));
lvars ty = ora_typo('gakkou');
check_true('a long one is one character out', ty /= 'gakkou');
check_true('and the slip detector catches it', lp_slip(ty, ['gakkou']));
check('a q in the answer still mutates', ora_typo('qqqqq'), 'qxqqq');

;;; --------------------------------------------------------- the confusion
;;; When the oracle is wrong on purpose it reaches for the partner the
;;; graph records, because that is the mistake lp_mistook can diagnose.
lvars cf = ora_confusion("hi_shi");
if cf then
    check_true('the confusion is a form lp_mistook recognises',
               lp_mistook("hi_shi", lp_norm(cf)) and true);
else
    printf(';;; hi_shi has no confusable partner -- confusion not checked\n');
endif;

test_summary();
