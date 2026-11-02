% graph/schema.pl -- the item schema, and what makes it a graph.
%
% Everything the tutor knows about a language is one of the relations
% below.  Nothing else is allowed in a graph file: a fact that does not
% fit one of these shapes is a fact nothing can reason over.
%
%   item(Id, Kind, Lang, Level, Source)
%       Id      a flat atom, the item's IDENTITY.  An item is not its
%               spelling: hi_a is the identity, 'あ' is one of its forms.
%       Kind    grapheme | sound | word | pattern | skill | confusion
%       Lang    ja | en
%       Level   a ladder node (ladder/3 below), never an integer
%       Source  provenance, always: own(kana) | jmdict('1358280') |
%               tatoeba('82431') | ets(cefr_mapping) | ...
%
%   form(Id, Script, Text)        one item, many written forms
%       Script  hiragana | katakana | kanji | romaji | latin | ipa
%   gloss(Id, Lang, Text)         what it means, in a named language
%   requires(Id, Pre)             the prerequisite DAG, within one language
%   confusable(A, B, Why)         declared one way, read both ways
%
%   rank(Id, Scale, N)            an ordinal difficulty proxy, lower first
%       Scale   freq | grade | strokes
%
%       NOT provenance, and not a property of the item's meaning: it is
%       how hard or how common the item is, on a named scale that
%       somebody else published.  Optional -- English carries none,
%       because no source we can use publishes one.
%
%       Placement is what wants it.  Probing 103 kanji one at a time to
%       find out whether somebody reads kanji is absurd; four probes
%       spread along a frequency rank locate them.  A criterion stated as
%       a bare count has the same weakness from the other side --
%       kanji(2230) is satisfied by any 2,230 characters, including
%       2,230 obscure ones -- which is the argument for ranking one.
%
%   ladder(Lang, Index, Level)    the levels of a language, in order
%   exit(Lang, Level, Criterion, Threshold, LatencyMs)
%
% Nothing here names JLPT or TOEIC.  A ladder is a per-language list, so
% the same engine drives 5->1 and a band of cut scores.
%
% The learner overlay is NOT here.  Beliefs live in Pop-11 (langpop.p)
% and reach Prolog as lp_belief/3 and lp_known/2, because they change
% every turn and the graph does not.

% A call to an undefined predicate FAILS in Poplog Prolog by default,
% which hides a typo in a rule as a level with nothing ready in it.  Say
% so once, here, and a misspelled predicate raises instead (PLOGHELP
% UNKNOWN).  Every graph file is loaded together, so nothing in this
% graph is legitimately undefined.
:- library(unknown).
:- unknown(_, error).

% Poplog Prolog has no forall/2 -- it is in no library and no help file --
% so state the idiom once, here.  Under unknown(_, error) above, a rule
% that reached for forall/2 would now raise rather than quietly never
% succeed, which is how this was found the slow way.
all_hold(Cond, Action) :- \+ (Cond, \+ Action).

% Confusability is symmetric; the data states each pair once.
confused_with(A, B, Why) :- confusable(A, B, Why).
confused_with(A, B, Why) :- confusable(B, A, Why).

% --- Imported content ----------------------------------------------------
% A level's content can come from upstream reference data rather than from
% this directory (import.p), and a generated file stamps
% itself with one of these.  The point of the stamp is a distinction the
% rest of the graph cannot make: a level with no items because nobody has
% curated it yet and a level with no items because its content was never
% BUILT look identical to ready/4, and they are not remotely the same
% thing to say to a student.
%
% The clause below matches no real stamp.  It is here because a predicate
% with no clauses at all RAISES under the unknown(_, error) above, and
% with nothing imported there would be none -- so every caller of
% content_built/2 would have failed in the one case it exists to report.
generated(none, none, none, 0, none).

% Same reason: with no imported content there is not a single rank/3 in
% the graph, and a predicate with no clauses RAISES under the
% unknown(_, error) above rather than failing.  This one matches nothing.
rank(none, none, 0).

content_built(Lang, Level) :- generated(_, Lang, Level, N, _), N > 0.

% A level that declares an exit criterion but holds no items.  Not a
% violation: it is the honest state of a ladder whose upper rungs are
% still to be written, and check(graph) would then never be clean.  It is
% reported on its own, by whoever asks.
level_empty(Lang, Level) :-
    ladder(Lang, _, Level),
    \+ item(_, _, Lang, Level, _).

% --- Teaching ------------------------------------------------------------
% An item is ready when the student does not know it and knows everything
% it requires.  This is the whole of the tutor's choice, and it is one
% clause because the prerequisite edges carry the pedagogy.

% A prerequisite the tutor has no way to check does not hold the door
% shut -- lp_unverifiable/1, and see its comment in langpop.p.  Every
% English sound contrast is on the `hear` channel, so without this
% clause the whole English pre-school rung had nothing ready, ever.
gate_ok(S, Pre) :- lp_known(S, Pre).
gate_ok(_, Pre) :- lp_unverifiable(Pre).

% AT OR BELOW the student's rung, and not that rung exactly.  Everything
% else in the design is cumulative -- the exit criteria (vocabulary(1000)
% at A2 counts every word through A2), the audit pool, the mastered
% counts, and lp_hear_plan -- and this clause was the one place that was
% not, which orphaned any item the student FORGOT after moving up:
% ready/4 did not reach down to it, and lp_review_note takes an item off
% the review ladder the moment it falls under MASTERY, so it sat in
% neither the plan nor the queue and could only be found by setting the
% level back by hand.
%
% English A2 is where this became visible rather than theoretical,
% because A2 declares no items of its own: every word it is measured
% over lives at A1, so at A2 the plan was empty by construction and a
% forgotten word stayed forgotten while still being counted against the
% criterion.
at_or_below(Lang, Lv, Level) :-
    ladder(Lang, N, Lv), ladder(Lang, Top, Level), N =< Top.

% lp_gates_ok/2 is what `all_hold(requires(I, Pre), gate_ok(S, Pre))`
% said, asked of the edge table instead of the clause store: with I bound
% that goal still walked all 12,505 requires facts, once per item, and
% ready/4 considers every item in the language.  One plan was 2.8 seconds
% at N2 and the engine asks for a plan once per question.  See
% lp_gates_ok in langpop.p; gate_ok/2 below is still the statement of
% what "in place" means, and is still what why/1 and the tests read.
ready(S, Lang, Level, I) :-
    item(I, _, Lang, Lv, _),
    at_or_below(Lang, Lv, Level),
    \+ lp_known(S, I),
    lp_gates_ok(S, I).

% Everything ready at the student's current level or below, for the
% Pop-11 driver.
plan(S, Lang, Level) :- ready(S, Lang, Level, I), lp_take(I), fail.
plan(_, _, _).

% Why this item: its prerequisites, and whether each is in place.
why(I) :-
    requires(I, Pre),
    ( lp_known_now(Pre) -> lp_take(known(Pre)) ; lp_take(missing(Pre)) ),
    fail.
why(_).

% --- Integrity -----------------------------------------------------------
% Checks the test suite runs over whatever graph is loaded.  Each one
% enumerates violations; no answers means the graph is sound.

violation(level_not_on_ladder(I, Lang, Level)) :-
    item(I, _, Lang, Level, _), \+ ladder(Lang, _, Level).

% lp_cross_lang/2 and lp_from_above/2 ask the check's own tables rather
% than the clause store, and the reason is in langpop.p above
% lp_check_tables: Poplog's Prolog does not index clause heads, so
% item(Pre, _, L2, _, _) with Pre bound still walks all 7,565 item facts
% -- once per prerequisite edge, which is 12,505 times.  These two
% clauses alone were 26 seconds of a 402-second report.  What they SAY
% is unchanged; where they look it up is not.
violation(requires_crosses_language(I, Pre)) :-
    requires(I, Pre), lp_cross_lang(I, Pre).

violation(requires_unknown_item(I, Pre)) :-
    requires(I, Pre), \+ item(Pre, _, _, _, _).

violation(requires_from_above(I, Pre)) :-
    requires(I, Pre), lp_from_above(I, Pre).

% ON A CYCLE, which is a question about nodes and was asked about paths.
%
% reaches/2 used to live here and enumerated every distinct ROUTE below
% an item.  Guarding it (an item on a cycle has an edge in and an edge
% out, so leaves can be skipped) took the N4 graph from 288 seconds to
% 28, and it came back at 414 as soon as the N3 words multiplied the
% routes below the characters: 780 items survived the guards, and the
% walk below each one re-reached the same forty-six kana by thousands of
% different paths, scanning all 12,505 requires facts at every step.
%
% lp_on_cycle/1 walks the same edges with one visited set for the whole
% search, over a table built in one pass, which is linear in the edges
% below the item -- see lp_ck_reaches_self in langpop.p.  Same answers,
% same order, and the guards are inside it.
violation(cycle(I)) :- item(I, _, _, _, _), lp_on_cycle(I).

violation(item_without_form(I)) :-
    item(I, Kind, _, _, _), Kind \== skill, \+ form(I, _, _).

violation(item_without_source(I)) :- item(I, _, _, _, _), \+ provenance_ok(I).

% A rung with no exit criterion is a room with no door: a student who
% reaches it can never leave, and :status has nothing to measure.  It
% has happened twice -- en/a1 and en/c1 -- and both times it was found
% by hand, because a rung that declares nothing produces no rows in
% --audit's table and so is invisible there.
violation(level_without_exit(Lang, Level)) :-
    ladder(Lang, _, Level), \+ exit(Lang, Level, _, _, _).
provenance_ok(I) :- item(I, _, _, _, S), nonvar(S), S \== unknown.

% The tables the three clauses above consult, in one pass each: an
% item's language and level, the rungs of each ladder, and the edges.
% Read by lp_check_tables in langpop.p, which is where the shape of
% these rows is described.
check_facts :- item(I, _, Lang, Lv, _), lp_take(ck_item(I, Lang, Lv)), fail.
check_facts :- ladder(Lang, N, Lv), lp_take(ck_rung(Lang, N, Lv)), fail.
check_facts :- requires(I, Pre), lp_take(ck_edge(I, Pre)), fail.
check_facts.

% The preparation is the first goal of the check and not a thing the
% caller has to remember, so `?- check(graph).` typed at a prompt is the
% same complete check the driver runs -- and so that the tables describe
% whatever graph is loaded NOW, which is the whole point of
% tests/bad.pl.
check(graph) :- lp_check_prepare, violation(V), lp_take(V), fail.
check(graph).

% --- Indexing ------------------------------------------------------------
% One pass that hands the whole graph to Pop-11 at startup, so the TUI and
% the tests can work without a Prolog call per lookup.  Failure-driven,
% because Poplog Prolog has no findall over a Pop-11 predicate worth using
% here and this is simpler to read.

index :- item(I, K, L, Lv, S), lp_item(I, K, L, Lv, S), fail.
index :- form(I, Sc, T), lp_form(I, Sc, T), fail.
index :- gloss(I, Lg, T), lp_gloss(I, Lg, T), fail.
index :- confusable(A, B, W), lp_conf(A, B, W), fail.
index :- starter_kanji(I, K), lp_skanji(I, K), fail.
index :- ladder(Lang, N, Level), lp_ladder(Lang, N, Level), fail.
index :- exit(Lang, Level, C, Th, Ms), lp_exit(Lang, Level, C, Th, Ms), fail.
index :- resource(R, Lang, Kind, Target, Url, Checked),
         lp_resource(R, Lang, Kind, Target, Url, Checked), fail.
index :- generated(S, Lang, Level, N, Date), N > 0,
         lp_generated(S, Lang, Level, N, Date), fail.
index :- rank(I, Scale, N), I \== none, lp_rank(I, Scale, N), fail.
index.

% The prerequisite edges, which index/0 deliberately does not collect: the
% tutor never needs the whole DAG, only ready/4's one-level check, so the
% overlay would carry 200 pairs nothing reads.  The exporters do need them
% (dump.p), and they ask for them once.
edges :- requires(I, Pre), lp_take(requires(I, Pre)), fail.
edges.

% Which items a level's exit criterion is measured over.  A criterion that
% is a count (vocabulary(N), coverage(Axis, Fraction)) has no item set and
% is answered by the driver instead.
%
% A skill is measured over WHAT IT ROLLS UP OVER, not over itself.  It
% used to answer with the skill item, which has no written form and so no
% probe -- so skill(dakuten) was measured over a set of one unaskable
% thing, reported 0% over 0 answers for ever, and could never be met.
% Three of the five Japanese pre-school criteria were in that state and
% nothing said so until --audit asked.
%
% Transitively, and skipping skills on the way down, because a skill may
% require another: mora_sokuon requires mora_count, so one level of
% expansion would have replaced one unaskable item with another.  The
% graph is a DAG -- check/1 proves it -- so the recursion terminates.
skill_leaf(S, I) :- requires(S, I), \+ item(I, skill, _, _, _).
skill_leaf(S, I) :- requires(S, X), item(X, skill, _, _, _), skill_leaf(X, I).

% A skill with a PROBE of its own is measured over ITSELF, and a skill
% without one over what it rolls up over.
%
% The difference is which thing the question is about.  skill(dakuten)
% is "read the voiced kana", so reading them is the evidence and the
% criterion is measured over the 46 of them.  skill(mora_count) is
% "count the beats", and reading あ is no evidence of that whatever --
% which is why it sat at `thin` in --audit over a set of one item that
% could not demonstrate it.  Its question is generated: a word is drawn
% from the graph, its beats are counted from its kana, and the student
% is asked for the number.  So the answers accumulate against the skill,
% the material varies every time, and the skill is the item.
%
% probe(Skill, morae(Feature)) says so, and names the material the
% feature picks out.  See lp_morae/1 and lp_kana_feature/2.
criterion_item(recognise(Script), I) :- kana(I, Script, _, _, _).
criterion_item(skill(S), S) :- probe(S, _).
criterion_item(skill(S), I) :- \+ probe(S, _), skill_leaf(S, I).

% A criterion named by a bare atom -- sound_contrasts, final_consonants
% -- takes the same bargain.  It is a separate pair of clauses and not a
% special case of the ones above because the Japanese ladder writes
% skill(mora_count) and the English one writes final_consonants, two
% spellings of one idea that nobody has reconciled; the probe should
% work under either, and did not under the second, which is why
% final_consonants stayed at needs_audio after it was given one.
criterion_item(Named, Named) :- atom(Named), probe(Named, _).
criterion_item(Named, I) :-
    atom(Named), \+ probe(Named, _), requires(Named, I).

% The ladder rungs that hold nothing, for the --check report.
empties :- level_empty(Lang, Level), lp_take(empty(Lang, Level)), fail.
empties.

criteria(Lang, Level) :- exit(Lang, Level, C, Th, Ms), lp_take(crit(C, Th, Ms)), fail.
criteria(_, _).

criterion_items(C) :- criterion_item(C, I), lp_take(I), fail.
criterion_items(_).

% The syllabary table, whole.  index/0 does not collect the ROW -- the
% tutor has never needed it -- and a printed chart is laid out by row, so
% the sheet asks for the facts rather than reassembling them from the
% overlay.  Same bargain as edges/0: not in the index, available on ask.
kana_table :- kana(I, Script, Glyph, Romaji, Row),
              lp_take(k(I, Script, Glyph, Romaji, Row)), fail.
kana_table.

% The skills that carry a generated question.  Guarded, like rank/3, so
% that a graph holding none of them still answers rather than raising.
probe(none, none).

% The confusion pairs that make a sound contrast askable.  Guarded for
% the same reason as probe/2 -- the Japanese graph declares none, and an
% undefined predicate raises under :- unknown(_, error).
pair(none, '', '').

pairs :- pair(C, A, B), C \== none, lp_take(pr(C, A, B)), fail.
pairs.

% WRITTEN confusions: two spellings a learner merges on paper because
% their ears merge them, and what each spelling means.  Guarded for the
% same reason as pair/3.
%
% Deliberately separate from pair/3 even though a confusion also yields
% one.  A pair exists to be PLAYED -- it is how a sound contrast becomes
% askable, and it needs a voice.  A confusion is asked by showing a
% meaning and offering the two spellings, which needs nothing but a
% screen; the fourth argument records WHY the two merge, and is a
% contrast id wherever one of the declared contrasts explains it.
%
% It is not a `requires` edge to that contrast, and must not become one.
% Telling `rice` from `lice` in writing is the easier half of the same
% problem and is where a learner starts; gating it behind hearing the
% contrast would put the harder task first and -- with no voice
% installed -- behind a door that cannot be opened.
mix(none, '', '', none).
sense(none, '', '', '').

mixes :- mix(I, A, B, Why), I \== none, lp_take(mx(I, A, B, Why)), fail.
mixes.

senses :- sense(I, W, En, Ja), I \== none, lp_take(sn(I, W, En, Ja)), fail.
senses.

% The characters a written form may hold that are not kana in their own
% right.  Guarded for the same reason -- the English graph declares none.
modifier(none, none, none).

modifiers :- modifier(G, S, W), G \== none, lp_take(m(G, S, W)), fail.
modifiers.

% How much running text a word accounts for, and the corpus that is a
% count out of.  rank/3 says WHERE a word sits; freq/3 says how much of
% the text it is, which is what coverage/2 needs and a rank cannot give:
% `the` and the fifty-thousandth word are one rank apart from their
% neighbours and four orders of magnitude apart in how much text they
% cover.  Both guarded, like rank/3, since neither is committed.
freq(none, none, 0).
corpus(none, 0, 0).

freqs :- freq(I, S, N), I \== none, lp_take(f(I, S, N)), fail.
freqs.

corpora :- corpus(S, E, T), S \== none, lp_take(c(S, E, T)), fail.
corpora.

probes :- probe(S, F), S \== none, lp_take(p(S, F)), fail.
probes.
