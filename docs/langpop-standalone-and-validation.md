# langpop on its own, and climbing the whole ladder

**Status, 2026-10-29: Part 1 is executed.** This repository is the
result — carved from the Poplog tree's `langpop-placement` branch with
the history kept (paths in Part 1 name the old tree, and stay as
written because they describe it). Decision A was overruled by its
owner, deliberately: the point of the split is that poplog's history
should not absorb langpop's, so the carve came first and the PR to
`dev` closes unmerged. Parts 2 and 3 are still the plan.

Three questions, asked together because the answers depend on each
other: carve langpop out of the Poplog tree, decide what it means to
*validate* a climb from pre-school to the top of each ladder, and work
out whether a local model can be the student who climbs it.

Nothing here is built. Every number in the first two parts was measured
in the tree on 2026-10-28 and says where it came from. **Decisions are
marked `yes` / `no` / `other`.**

---

# Part 1 -- the carve

## What actually moves

`git log` over `examples/langpop` and `docs/langpop-*.md`:

| | |
|---|---|
| commits touching langpop | **44**, the first `9010925` (2026-10-19), the last `f01eb23` (2026-10-26) |
| commits on the branch in total | 691 |
| files in the directory | 49, 1.2 MB |
| paths those 44 commits touch outside `` | 7 |

The seven: five `docs/langpop-*.md` (audio, function-words,
japanese-tranche, production-criteria, pronunciation -- six, with this
one), one row in
`examples/README.md`, and -- in one commit -- `gfx-font-test`,
`pop/extern/fonts/NotoSansJP.ttf` and `OFL.txt`.

**The font does not come.** Nothing under `examples/langpop` names
NotoSansJP: that commit was doing two things, and the SVG cards ask for
a family by name and let the renderer find it. The `examples/README.md`
row does not come either; it is a row in an index that stays behind.

So the carve is: **44 commits, `` to the root, plus
the five project docs into `docs/`.** That is unusually clean -- the
history was written in one directory and never wandered.

## The three things that break

**1. Hard-coded load paths.** `server.p`, `client.p`, `dump.p` and the
test suites all say

```pop11
load 'langpop.p';
```

and the tests are invoked as `./poplog basepop11
tests/test_langpop.p`. Moving the directory to the root
breaks every one. There is already a right answer in the tree --
`langpop_dir`, set by `find_dir()` -- so the fix is mechanical: one
`load` of `langpop.p` by a path relative to the loading file, and
`langpop_dir` for everything after. **One commit, made in the Poplog
tree before the carve**, so that the carved history is already correct
and no commit in the new repo is broken at its own revision.

**2. Poplog library dependencies, two of them younger than langpop.**

| lib | lives at | last touched |
|---|---|---|
| `jsonrpc` | `pop/lib/lib/jsonrpc.p` | 2026-10-20 -- *during* langpop's development |
| `json` | `pop/lib/lib/json.p` | 2026-10-01 |
| `utf8`, `datetime`, `poptest` | `pop/lib/lib/` | 2026-08-10, stable |

`jsonrpc.p` and `json.p` are not incidental: `jsonrpc` was finished to
make `server.p` possible, and `json_generate`'s dropped `false` is one
of the traps in DESIGN_NOTES.md. A standalone langpop needs a
Poplog that has them.

Three ways, and I would not vendor:

1. **Declare a minimum Poplog, and check it at startup.** `langpop.p`
   already runs a `--check`; add to it a probe for `json_object` and
   `jsonrpc_obj` and fail with the sentence *"needs Poplog with
   lib/jsonrpc (2026-10-20 or later); see README"*. Cheapest, honest,
   and it fails at the only moment anybody can act on it.
2. **Vendor `json.p` and `jsonrpc.p` into `lib/`** and prepend to
   `popautolist`. Works offline, and guarantees drift: two copies of a
   library whose bugs are being fixed in the other repo.
3. **Submodule the Poplog tree.** A 100 MB dependency for two files.

**Recommend (1)**, with a named release. The project already publishes
builds to the `poplog-builds` bucket, so "needs release X" is a
sentence a reader can act on.

**3. The invocation.** Everything is `./poplog basepop11 ...`, which is
a wrapper in the Poplog tree, not in langpop. The new repo needs its
own two-line `./langpop` that finds a Poplog (`$usepop`, `which poplog`,
then a guess) and reports the dependency failure above if it cannot.

## Mechanics

```bash
# From a FRESH clone -- filter-repo rewrites history and refuses a dirty
# tree, and you want the poplog clone you work in left alone.
git clone --no-local /Users/dkords/dev/projects/iotone/poplog /tmp/carve
cd /tmp/carve && git checkout langpop-placement

git filter-repo \
  --path examples/langpop \
  --path-glob 'docs/langpop-*' \
  --path-rename : \
  --path-rename docs/langpop-:docs/

git init --bare /Users/dkords/dev/projects/iotone/pop-11-langpop.git
git remote add origin /Users/dkords/dev/projects/iotone/pop-11-langpop.git
git push origin --all --tags
```

Expect 44 commits, every one of them a langpop commit, with
`README.md` appearing as `README.md` throughout its
history -- `git log --follow` keeps working because filter-repo rewrites
the trees rather than adding a rename.

Afterwards, verify rather than assume: `git log --oneline | wc -l` is
44, `git log --diff-filter=A --name-only | grep examples/` is empty, and
the suites pass from the new root (which is where break (1) shows up if
it was not fixed first).

## Two decisions about order and about what stays

**Decision A -- land PR #72 first.** It is 37 commits to `dev`, and
`dev -> master` after that. Carving from an unreviewed branch means the
carved history is the unreviewed history, and any review comment lands
in a repo the reviewer cannot see from the PR. **Recommend: PR #72 to
`dev`, `dev` to `master`, then carve from `master`.** The project's own
rule -- branch to dev to master, never skipping -- says the same thing.

**Decision B -- does Poplog keep a copy?** Three options: delete the
directory and leave a pointer row in `examples/README.md`; keep it as a
frozen copy; add it as a submodule. **Recommend: delete, with the
pointer.** Two copies of a live project in two repos is the `json.p`
problem again one level up, and langpop is no longer an example of
Poplog -- it is a program that needs one. The deletion is one commit on
`master` after the carve is pushed and verified, and it is the only
commit in the sequence that is hard to undo, so it goes last.

---

# Part 2 -- what a climb is, and how far one can get today

## The ladder, and the ceiling under it

`--check` reports 577 items, 12 rungs, 39 exit criteria, no violations.
A sound graph is not a climbable one -- and the report that says how far
one can climb **already exists**. The first draft of this document
proposed building it, which was wrong twice: `--audit` prints exactly
this table, per criterion with `short by N` and rung by rung with *can
it be left*, and it counts the pools **cumulatively**, which is the
correct reading because the criteria are -- `kanji(2230)` at N1 means
every kanji through N1. The draft's hand-walked numbers counted each
level alone and understated n5 by fifty words. (A duplicate `--ceiling`
was built, found to restate `--audit` less correctly, and removed the
same hour; the project's own rule -- one measurement, one rendering --
decides this.)

`--audit`, 2026-10-29:

| rung | criterion | needs | askable (cumulative) |
|---|---|---|---|
| ja preschool | all 7 | | **ok -- the rung can be left** |
| ja n5 | kanji(103, read) | 103 | **103, ok** |
| ja n5 | vocabulary(800, read) | 800 | **198**, short by 602 |
| ja n5 | vocabulary(800, hear) | 800 | **52**, short by 748 |
| ja n4 … n1 | kanji / vocabulary | 284…2230 / 1500…10000 | 103 / 198, short |
| en preschool | sound_contrasts | 12 | 0 askable -- needs_audio |
| en a1 | vocabulary(500, read) | 500 | **112**, short by 388 |
| en a2 … c1 | 1000 … 8000 | | 112, short |
| en b1/b2/c1 | coverage(reading/listening) | 95--98% | a 100-word freq list, short/needs_audio |

Bottom line, in `--audit`'s own words: **"1 of 12 rungs can be left as
the graph stands"** -- `ja preschool`, with `ja n5` blocked only by
words (the kanji half is full). `en preschool` is blocked by
`needs_audio` on `sound_contrasts`, which is an instrument gap rather
than a content gap, and the audit's six verdicts keep those apart --
that distinction is the backbone of everything below.

**So the first finding of the validation work arrives before any
student, simulated or real: the report already existed, it says the
climb is blocked by content, and the code part of validation is small.**

## What a climb costs in answers

Tier 1, right: `b + (1 - b) * 0.45`. From zero: 0.45, 0.6975, **0.834**.
`MASTERY` is 0.80, so **three correct checks carry an item from nothing
to mastered, and nothing carries it in two.**

A perfect student, never wrong, never skipping, lower bound, new items
only at each rung:

| | items × 3 | answers |
|---|---|---|
| ja preschool | 138 kana + 50 words + probes | ~700 |
| ja n5 | 800 words + 103 kanji | ~2,700 |
| ja n4 | +1500 + 284 | ~5,400 |
| ja n3 | +3750 + 650 | ~13,200 |
| ja n2 | +6000 + 1023 | ~21,100 |
| ja n1 | +10000 + 2230 | ~36,700 |
| **ja, pre-school to N1** | | **~79,000** |
| en preschool → c1 | 500+1000+2500+5000+8000 | **~51,000** |

A student who is right 80% of the time pays for each wrong answer twice
-- `b * 0.30` throws away most of the progress -- so a realistic climb
is roughly **double**: of order 10^5 answers per language. That number
decides Part 3 by itself.

## Pre-school to N5, as a validation target

The honest target, and the one the content can nearly reach:

1. **Content.** 602 more n5 words (the pool is cumulative: 198 held). The importer already does this
   (`import.p`, `tools/fetch-upstream.sh`, the n5 picks file); the
   blocker is curation, and `docs/langpop-japanese-tranche.md`
   is waiting on marks. The okurigana-stripped kun readings -- about 16
   of the 28 one-character hiragana forms, 会 expecting あ -- is a bug in
   the content and must be fixed before any climb, because a simulated
   student scored against the graph would *agree with the graph* and the
   run would look clean.
2. **The climb itself**, as an assertable run: an empty profile reaches
   `ja preschool` passed and `ja n5` passed, in some bounded number of
   answers, with every rung's criteria measured and none of them `thin`.
3. **`hear` stays unmeasured** and `:status` must keep saying so. The
   climb report that prints *n5 passed* while two of its three criteria
   say `needs audio` would be the ladder lying, and the wording is
   already written for the student's screen -- the harness should assert
   that wording survives, not route around it.

## Pre-school to the top of the English ladder

Two corrections to the target as stated.

**TOEIC's ceiling is not 1600.** Listening & Reading is 10--990;
Speaking & Writing is 0--200 each, so 400; the two together cap at
**1390**, and nobody reports them as one number. If "the top score" means
L&R, it is **990**.

**990 does not need a new rung.** ETS maps L&R 945+ to CEFR C1, and the
ladder's top rung is `en c1` at `vocabulary(8000, read)` /
`vocabulary(6000, hear)`, which is the right band for it -- consistent
with the figure already on record here, a strong TOEIC reader at about
5,000 words, which is B2-to-C1 territory and not the ceiling. So the
English target is **pre-school to `en c1`**, and TOEIC enters as a
*reporting* question, not a ladder question:

- a band table in `graph/resources.pl` -- score range to rung -- so
  `:status` can say *"about 850--945 on TOEIC L&R"* beside the rung, with
  the mapping's source named, because a score range inferred from a
  vocabulary count is a weaker claim than a measured criterion and must
  read as one;
- there is no `c2`, and C1 is where the ladder stops. 990 is inside C1,
  so this is a coincidence that works. Worth writing down before
  somebody adds a rung to chase a number.

**The coverage criteria are the English blocker,** more than the
vocabulary ones. Coverage is the one criterion that cannot be satisfied
by importing more items -- it needs a corpus, with a licence checked the
way speechocean762's was, and the corpus is now there (`en_50k.txt`).

What it cannot be satisfied by is *content words*, and the second A1
tranche is the measurement of that: four hundred of them took the graph
from 5.60% to **13.57%** of the corpus, against a B1 line of 95%. The
twenty-one words the gap report now puts at the top of the queue are
`you`, `i`, `the`, `to`, `a`, `it`, `and` ... every one of them a row in
`docs/langpop-function-words.md`, which is still waiting to be marked.
A learner who knows five hundred nouns and no articles reads nothing,
and the number now says so twice.

## What "validated" should mean -- three layers, separately reported

1. **Reachable** -- the `--audit` table: can each rung's criteria be
   satisfied at all by the content present? Static, cheap, no student,
   and already built.
2. **Sound** -- the invariants below hold over a long run. This is where
   bugs live.
3. **Taught** -- the order makes sense to a person. A simulated student
   cannot answer this one and should not be asked to.

### The invariants a long run should assert

Each of these is a test that a bug would break, and several of them
restate a decision the project has already made, which is the point:

- **nothing is offered before its prerequisites** -- `lp_next` never
  returns an item with an unmet `requires`; the DAG is the claim and a
  10^5-answer run is the test;
- **belief is bounded by tier** -- no machine verdict alone takes an
  item past `MACHINE_CAP`, no inference past `INFERRED_CAP`, nothing
  past `MASTERY` without a tier-1 entry. (Lock 3 of
  `langpop-production-criteria.md`, as an assertion instead of a
  constant.)
- **no criterion is satisfied without evidence** -- a rung reported
  passed has, for each criterion, a count whose journal entries exist
  and are at the tier the criterion claims;
- **`skip` is in the denominator and `near` in neither** -- the two
  arguments the project has settled, checked on real numbers;
- **the journal reconstructs the profile** -- replay `lp_journal` from
  empty and get the same beliefs. This is the strongest single
  invariant: it makes every belief in the file auditable, and any
  ordering bug or lost update shows up as a divergence;
- **save and reload is a fixed point** -- round-trip the profile at
  random points in the run and nothing changes (which is where
  `json_generate`'s dropped `false` would reappear);
- **no starvation** -- every item in the current rung's pool is offered
  within some bound; an item the scheduler can never reach is a word the
  student can never learn, and the count-based criteria make that look
  like the student's failure;
- **no crash, and no unhandled mishap, over the whole run**, with the
  file not being edited underneath it (see DESIGN_NOTES.md on that).

---

# Part 3 -- the student who climbs it

## One correction first: model size is not learner level

"A local LLM that has various skill levels" has a trap in it. A small
model is not a beginner; it is a *differently* wrong thing. It does not
know 300 kanji and fail on the 301st -- it hallucinates readings for
kanji a beginner has never seen, and gets 山 wrong after getting 曜 right.
Scoring the ladder against that measures the model, and every bug found
would be arguable.

**Level belongs in a knowledge mask, not in the weights.** The harness
decides, from the graph, which items this student knows and how well;
the model (where one is used at all) only renders an answer. Then "a
student at N5 level" is a precise, reproducible object, and when the
tutor disagrees with it, the tutor is wrong.

## The oracle student -- the primary harness

Deterministic, seeded, no model. For each item it carries a true
competence `p(item)`, drawn from a profile: *kana solid, 500 kanji,
grammar thin, katakana leaky* -- which is the real student this project
was written for, as a parameter.

It answers over **JSON-RPC** (`server.p`, 18 methods: `next`, `answer`,
`explain`, `status`, `placement.next`, `placement.report`, `aids`,
`audit`, …), not through the TUI. No pty, no prompt scraping, and the
same surface a GUI client would use -- so the harness tests the API that
is meant to outlive the TUI.

Its error model is drawn from the tutor's own structures, which is what
makes it worth more than random noise:

- **confusables** -- when it is wrong, it answers with the confusable
  partner (`lp_mistook`'s pairs), because ツ for シ is the mistake a real
  student makes and a random string is not;
- **typos** -- adjacent-key slips at a set rate, to exercise the `slip`
  aid and, more importantly, to check that a slip never lowers a belief;
- **latency** -- sampled around the rung's `ms` floor, including
  deliberately straddling it, since every criterion measures speed and
  nothing has ever tested the speed half;
- **skips and `later`** -- at a rate, because `skip` in the denominator
  is a decision with arithmetic behind it;
- **drift** -- competence rises slowly with exposure, so that the run
  resembles learning rather than a fixed coin, and the scheduler's
  spaced return is exercised.

Because it is seeded, a failing run is a seed, and a seed is a bug
report. That is the single biggest reason to build this before reaching
for a model.

**Cost: minutes.** 10^5 answers over a local socket is wall-clock
negligible, so the whole-ladder run can be a nightly job rather than an
occasion.

## Where a local model genuinely earns its place

Four jobs the oracle student cannot do, all of them narrow:

1. **Free text.** The front end is an Eliza-style teacher: a student
   types sentences, not just answers. The oracle student cannot produce
   *"wait, why is it きって and not きて"*, and that path -- `lp_chat`, the
   persona files, the `:why` explanations -- is otherwise untested by the
   long run.
2. **Adversarial input.** Plausible human mess: romaji with macrons,
   half-width katakana, a trailing space, an answer in the wrong script,
   a command typed at the display-name prompt. Two bugs of exactly this
   shape are already on the record (an empty username registers; a
   `:command` becomes a display name), which is evidence the class is
   productive.
3. **English production and `pick`.** Where the answer is a gloss rather
   than a reading, a model is a better generator of wrong-but-reasonable
   answers than a confusable table.
4. **Grading open answers** -- but only as a *proposal*. A model's
   verdict is tier 5 at best, and `MACHINE_CAP` is 0.77 for exactly this
   reason. The model may never certify.

Shape: Ollama locally, one small instruct model, pinned by name and
digest, temperature 0, every prompt and reply written to a transcript so
a failure is reproducible even though generation is not fully so.
**Sampled, not in the loop**: a fixed adversarial suite of a couple of
thousand turns, plus one model turn in every few hundred oracle turns.
At 300 ms--1 s per turn, 10^5 model turns is 8--28 hours; 2,000 is
minutes, and finds the same bugs.

## What this will actually find

Honest expectations, ranked by how likely I think each is:

- **content bugs, in bulk** -- the okurigana class, the homophone ids,
  the `w_ki2` placeholder. A climb over 800 words meets every curation
  decision once. *But only if the oracle's ground truth is independent
  of the graph* -- scored against the graph, a student agrees with its
  own bugs. So the oracle takes its truth from the graph and the
  **disagreements get logged for a person**, which turns the run into a
  curation queue rather than a verdict;
- **scheduler and starvation bugs** -- these need scale, and have never
  had it; 198 words is not enough to starve anything;
- **criterion arithmetic at the boundary** -- the 0.80 threshold, the
  `ms` floor, `thin` pools, and what `:status` prints at 799 of 800;
- **save/restore and journal replay** -- the round-trip invariant over a
  long run is where a dropped field finally shows;
- **the aids interacting** -- four of them now, independently switchable,
  logged, and never exercised in combination.

## What the first runs actually found (2026-10-29/30)

Phase 4 is built (`oracle.p`, `./langpop oracle`), and its first runs
did what the section above predicted, in order:

1. **The roll-up deadlock.** `hiragana_all` could never be mastered --
   no probe, inference runs the other way, every indirect tier capped
   below `MASTERY` -- so every starter word was locked for ever and the
   first long run sat at vocabulary 0 of 50 with every kana mastered.
   Fixed: a probeless skill with requires is mastered exactly when
   everything it requires is (`lp_rollup_mastered`). Seed 42 now climbs
   to 50 of 50.

2. **The oracle itself over-reached twice**, which is also the harness
   working: ready items with no typed question (the patterns, taught by
   `assign`) are not starvation, and an *ungateable* prerequisite (the
   English sound contrasts) not holding the door shut is `gate_ok`'s
   second clause, not a violation. Both invariants are now stated with
   the same exemptions the engine argues for.

3. **Open design question -- the lifetime denominator.** `lp_measure`
   runs over the whole journal, so a student who starts from zero
   carries every early mistake for ever: seed 42 plateaus near 0.57
   recognise-accuracy while demonstrably knowing all of it, and the
   0.90 exit line may be unreachable for any genuine beginner. The
   honest measure is probably recency-windowed (or read off current
   beliefs, which already decay the past geometrically). Not changed:
   it moves an exit criterion, which is an owner's decision.

4. **The lifetime denominator: settled, 2026-10-30.** It was not a
   denominator problem at all. A window onto the same journal reads
   0.645 where the lifetime reads 0.569, because `ready/4` excludes what
   is known: an item is asked only while it is unlearned, so the journal
   holds the record of not-yet-knowing and no evidence of knowing. The
   answer was refresh reviews, a ladder that burns, and a 28-day period
   the scores reset with -- see `langpop-reviews-and-periods.md`. The
   same criteria now read 0.97-1.00 for the same student.

5. **A review answered after a typing slip was recorded as learning.**
   Found by the oracle counting six passed reviews of a four-rung
   ladder. `lp_m_answer` cleared the item in flight as soon as any
   answer arrived, so the retry -- the same question -- fell back to the
   gate channel and the learning phase. The channel half of that
   predates phases and was live. Pinned in the server suite.

6. **A cap demoted what it was meant to limit.** Every capped tier was
   a plain `min()`, so positive evidence about an item already better
   known than the cap *lowered* it: an inference took a mastered item to
   `INFERRED_CAP` (0.75), and a compliance report took one to
   `TIER3_CAP` (0.50). Found by the review ladder, which schedules on
   mastery and so saw items being reviewed at exactly the two caps.
   `lp_cap` is now `max(b, min(raised, cap))`, pinned in the suite.

7. **ja pre-school passes, and n5 is reachable.** With reviews and
   `lp_criterion_met`, the ladder is climbed end to end for the first
   time: pre-school finished, n5 at 103 of 103 kanji and 220 of 800
   words, blocked on curation and saying so (the graph holds 170). en
   pre-school correctly does not pass -- its criteria have items but
   every one is hear-gated and unaskable, which is the pronunciation
   gap, not the student.

8. **The answer key was recomputed, not remembered.** A `pick` turns
   its options over on every call so a student cannot learn the
   position, and `lp_m_answer` rebuilt the question to mark the answer
   -- so the key it built was not always the key the student had been
   shown. It survived in the learning phase because `lp_plan` and
   `lp_choose` ask `lp_question` too, on their way to choosing, so the
   turnovers between asking and grading came out even; injecting a
   review made one more call and reversed the parity. Half of every
   English answer was then marked wrong, including the ones the oracle
   had just been told were right. The question in flight now lives in
   the session beside the clock and the channel, for the same reason
   they do. Pinned in the server suite -- the test makes one extra
   `lp_question` call between asking and answering, which is all it
   takes.

9. **A set nothing could ask held a rung shut.** `sound_contrasts` is
   measured over thirteen contrasts that live on `hear` alone, so on a
   machine with no voice it was measured, scored 0% over 0 reviews, and
   could never be met: a tutor reporting its own missing speaker as a
   student's failure. The `vocabulary(N, hear)` branch had said
   `audio` for this since the channels were split; the item-set branch
   had not. Now a measured criterion where not one member is askable on
   any channel this build can check reports `audio` and is excused by
   name, and English pre-school finishes.

10. **The English rung had nothing a learner could finish.** Two of its
   three criteria needed a voice, so the level could not be left
   however well its student read. The fix was content, and it was the
   user's own observation: the words that sound the same. A written
   confusion (`mix/4`) is the reading half of a merge -- show what one
   of `rice`/`lice` means, offer both spellings -- and needs no
   speaker, no microphone and no cache. Twelve of them, a thirteenth
   contrast (`/ts/`, for *presents* against *presence*), and a fourth
   criterion. `en preschool` now passes and the student advances to
   a1, where 100 words exist of 500 wanted: the same honest curation
   wall `ja n5` reports, reached from the other ladder.

11. **The harness had to learn to come back tomorrow.** A run that
   stops the first time the queue is empty never sees review stage 2 --
   the gaps widen to 28 days -- so it reported rungs as unfinished when
   all that was missing was the next day. `ora_wait` waits for
   `next_review_in`, and only for a gap that is short in real time,
   which with a real 24-hour day is never. The server reports that
   number because a client with nothing to ask should say "nothing
   today, two more tomorrow" rather than sounding like it has run out.

12. **A1 English, 100 words to 519, and two rungs climbed.** The
   curation wall `en a1` reported -- 100 words where 500 are wanted --
   is gone: `exit(en, a1, vocabulary(500, read))` is met and the oracle
   now climbs pre-school, A1 and into A2, where it stops at 531 of
   1000 -- every English word the graph holds, and the honest curation
   wall one rung further up. The corpus share went 5.60% to 13.57%, and the word list now
   exercises every sound contrast a pronunciation rule can derive (10
   of 13; the other three are `s_final`, `s_stress` and `s_rhythm`,
   which no single CMUdict entry can show).

   Three things the new content found, all of them half-truths that had
   been true-enough while no item had two spellings:

   - **The cmudict import took the first spelling and called it the
     item's.** A written confusion has two, so `m_rice` was given the
     pronunciation of `rice` alone. Both modes now read every `latin`
     form, which is what `imp_en_forms` was already doing for
     frequency and for the same stated reason.
   - **It also derived a prerequisite edge the schema forbids.**
     `requires(m_think, s_th_un)` is true of the word and wrong about
     the teaching order: a confusion is the half of a merge that can be
     *read*, and gating it behind hearing the contrast puts the harder
     task first. Invisible without a voice installed, because `gate_ok`
     opens a door no channel can check -- with one installed the whole
     written rung would have moved behind the listening one.
   - **A cumulative criterion was reported against a level-exact
     denominator.** A2 declares no words of its own, so a student with
     499 of them read `499 of 1000 (graph holds 0)`. Both halves of
     that line are now counted the same way, cumulatively and bounded
     by the student's own rung, which is what the criteria mean.

   And a fourth, which is the one worth remembering: **an item
   forgotten after moving up was orphaned.** `ready/4` asked for the
   student's level *exactly* while everything else in the design is
   cumulative -- the criteria, the audit pool, the mastered counts,
   `lp_hear_plan` -- and `lp_review_note` takes an item off the review
   ladder the moment it falls under `MASTERY`. So a word the student
   forgot sat in neither the plan nor the review queue, was still
   counted against the criterion, and could only be found again by
   setting the level back by hand. A2 is where it stopped being
   theoretical: A2 declares no items of its own, so its plan was empty
   by construction. The plan is cumulative now, which is what "it walks
   back into the plan" had been claiming since the review ladder was
   built. The oracle measures what it was costing: the same seed went
   from 497 of 531 words mastered to 531 of 531.

   And `s_ts` is derivable after all: a word-final /ts/ is exactly the
   cluster, CMUdict shows it, and `pants` is the word at A1 that
   exercises it.

13. **N5 Japanese, 170 words to 773, and a question nobody should have
   been asked.** The rung wanted 800 and held 220 counting pre-school, so
   it was unfinishable and `ja` never left N5. It is 823 held and 804
   askable now, and `vocabulary(800, read)` is `ok`. Four things the
   content exposed, all of them in DESIGN_NOTES.md at length:

   - **The question was a spelling no beginner should see.** JMdict gives
     コーヒー the headword 珈琲 and とても the headword 迚も, both tagged
     `&ateji;` and `&rK;`, and the importer took the first headword as the
     written form. The tags are read now, and a word whose every kanji
     spelling is tagged has no kanji form at all -- which is right, since
     コーヒー is written in katakana.
   - **A word written only in kana has no reading question**, and 61 of
     them were silently outside the measurement: `801 have, 740 askable`.
     The katakana loanwords are asked now, prompted as katakana and
     answered in romaji, which takes it to 805; the nineteen kana-only
     expressions are deliberately left unasked, because prompting とても
     for `totemo` at N5 tests hiragana and pads the criterion.
   - **Four voice-test disagreements, none of them the scorer's.** The
     suite's fake voice greps for the hiragana っ, so every katakana
     geminate was handed the dropped-beat recording. Measured against the
     real voice the four sit at 1.24-1.46, where the native words are.
   - **Two picks resolved to one dictionary entry**, and both counted.
     早い and 速い are one JMdict entry with two headwords, so
     `w_hayai` and `w_hayai_fast` came out as two items with identical
     forms and an identical gloss. No existing check could see it: both
     ids were free, neither key was ambiguous, and `imp_verify` confirmed
     the emitter wrote what it meant to. `imp_shared_entries` asks the
     question now.
   - **The Japanese frequency list cannot attest a word.** See finding 14.

14. **The Japanese frequency corpus is not usable for shares, and this
   invalidates numbers already written down.** hermitdave's 2018 Japanese
   list is missing 私, 僕, 君, 俺 and 誰 in every spelling, while holding
   、, 。, あなた and お前. It was found by trying to attest the N5
   tranche the way `graph/en/a1.pl` is attested: the check reported 僕 and
   誰 as absent from Japanese, which is false, so the check was wrong and
   the reason is upstream. The file is the genuine
   `content/2018/ja/ja_full.txt`.

   Consequences, each one a claim withdrawn rather than a thing to fix:
   the N5 words are curation and **not** corpus-attested; every *share of
   the corpus* in `docs/langpop-japanese-tranche.md` is unsound, the 14.6%
   headline included; and the ja `coverage(reading)` criterion the owner
   deferred should stay deferred for a concrete reason, which is that its
   denominator is missing its most frequent words. The `--gap` report's
   annotations are computed from the graph and still stand; its `share`
   and `if-added` columns do not. English is unaffected -- `en_50k.txt`
   has `you`, `i` and `the` at the top, where they belong.

15. **A long run exhausted the heap, and the reason is the save.** 9,000
   answers produced 1,559 `langpop/answer: internal error` violations --
   a mishap, reported as -32603. `lp_save` writes the whole profile on
   every answer and the journal is never trimmed, so at ~7,600 entries
   the profile is 450KB and `consstring` inside `json_generate` runs past
   Poplog's default `popmemlim` of 1.5M words. Raised to 24M words, and
   seed 1 then passed at 9,000. It had never mattered because no rung
   held enough content for a run to get this long.

   **Since fixed, and no longer the limit's doing.** The journal is a
   file of its own, appended to one line per answer, and the profile
   holds only the student's state -- all of which is bounded by the size
   of the graph. Measured over 25,000 answers the profile stays at 127KB
   and a save at 4.8ms, where the journal taken out of it cost 10.5ms
   and 560KB to generate at 9,000 entries and was still climbing. The
   raised `popmemlim` stays, for the reason that is actually true: the
   resident graph alone puts the heap above 3.5M words. See
   DESIGN_NOTES.md, *The journal is a log, so it is a file*.

16. **The starvation check was measuring the budget, not the scheduler.**
   ja seed 42 at 9,000 answers failed `1 askable ready items were never
   offered` -- and passed the same check, on the same tree, with the same
   seed. Three runs reached 373, 392 and 412 of the 800 N5 words; the two
   that got furthest each left one item unoffered (`w_sengetsu`,
   `w_kyuu`), both words waiting on a kanji and both unlocked in the last
   few hundred turns. How far a run gets is a function of wall-clock
   speed, because the scratch server runs a 200ms day, so the gate was a
   function of machine load and was reporting progress as a defect.
   Fixed: the ready pool is sampled halfway through the budget and only
   an item ready *then* and never offered after counts. The same seed at
   14,000 answers **finishes the rung** -- 804 of 800 words, ending at
   12,518 turns with nothing left to ask, which is the first time a
   simulated student has reached the criterion rather than the graph
   merely holding enough for one to.

17. **A2 English, and what it says about coverage.** 550 hand-written
   rows took `vocabulary(1000, read)` to 1081 of 1000, all askable, ok.
   Two rows had to be withdrawn: `excited` and `service` are already
   taught as katakana traps, and the gloss written for `service` was
   サービス -- the exact misunderstanding `t_service` exists to correct.
   Only `excited` tripped a check, and only because the two Japanese
   glosses happened to agree, so "no two English items of one kind share
   a spelling" is now checked too. **The coverage figure barely moved:**
   `coverage(reading, 0.95)` went from short by 81 to short by 78. Five
   hundred and fifty words bought three points, which is the strongest
   evidence yet that what is left of reading coverage is function words
   and not vocabulary -- see docs/langpop-function-words.md, still
   awaiting the owner's marks on articles, dummy `it`, `be` and
   `do`/`have`.

18. **N4 Japanese, and three things that broke with it.** The rung's two
   criteria are both met: `kanji(284, read)` from one KANJIDIC2 command
   (old level 3, 181 characters, and 103 + 181 is exactly what the
   ladder asked for), and `vocabulary(1500, read)` at 1572 of 1500,
   1514 askable, from 749 hand-written picks. Validating the picks as
   data before writing any Prolog is what the tranche cost least:
   325 of 1,074 drafted rows were words the graph already teaches, and
   90 more had an id whose romaji was not the word's reading.

   None of the three failures that followed was in the import. `--check`
   went to 288 seconds of CPU, because `violation(cycle(I))` asked
   `reaches(I, I)` of all 3,115 items and `reaches/2` enumerates paths;
   two guards (an item on a cycle has an edge in and an edge out) take
   it to 28 seconds on the same graph, with the same verdict. A voice-test fixture that renders one wav
   and runs it over every geminate in the graph was measuring the
   vocabulary rather than the scorer -- a 90 ms gap is a dropped beat in
   a three-mora word and a held one in a six-mora word -- so
   `lp_vt_only` and `--voicetest <item>` now let a caller name the word.
   And 以 (もっ(て)) was the first character whose kun reading holds a
   geminate: the display brackets were reaching both the voice and
   `lp_morae`, and at four morae instead of three a *dropped* beat came
   back credited.

19. **A test that names a thing for being missing has a shelf life
   ending on the day the project succeeds.** Filling the kanji column
   (2026-11-01, N3/N2/N1, 2,230 characters) broke four checks and none
   of them was in the import, which is the fourth time that has
   happened. All four asserted the ABSENCE of content: `N1 kanji is
   short` in two suites, chosen for being reliably empty -- one of them
   already carrying a comment about counts shrinking as content arrives
   -- `誕 is not an N5 kanji, so nothing requires it`, which asserted
   the opposite of the rule two lines above it the moment 誕 arrived
   with N3, and the dump suite's `popmemlim`, now raised twice by a
   content import. The repair each time is to assert the property over
   whatever is short or absent NOW, plus the complementary case where
   it is cheap: "short means it holds fewer than it wanted" and "ok
   means it holds at least what it wanted" together say the comparison
   runs the right way round, and one row cannot.

20. **A filter that silently matches nothing looks exactly like a
   filter with nothing to reject.** The N3 word pool (2026-11-01) is
   built in Python over JMdict, and ElementTree expands the DTD
   entities: `<pos>&v1;</pos>` arrives as the text `Ichidan verb` and
   `&uk;` as `usually written using kana alone`, so every filter
   written against the abbreviation compared a long string to a
   two-letter one and said no. Nothing errored. The pool looked
   plausible -- 10,149 candidates, correctly ranked -- because the
   filters that worked were doing the visible work and the broken ones
   were only ever supposed to REMOVE things. What caught it was a word
   that should not have survived (出来, still at the top after a rule
   written to drop verb stems), not any message. Reading JMdict's own
   inline DTD back into a text-to-abbreviation map removed 1,712
   candidates the pool's rules had always meant to refuse. The general
   version: a rule whose only effect is subtraction needs a test that
   names something it must subtract.

21. **An exclusion that reads the source instead of asking the graph
   will miss whatever the graph derives.** The same pool excludes words
   already taught, and its first draft scanned `form/3` facts out of
   `graph/ja/**/*.pl` -- so 学校 came back as the sixth most important
   word N3 was missing, while `w_gakkou` had been an item since the
   first week. All fifty pre-school starters come out of `starter/4`
   and `starter_kanji/2` RULES, which no text scan sees, and the
   generated files put several facts on one line, which `re.match` only
   half-reads. `./langpop dump --lang ja` is the inventory; it prints
   derived items too, and the kanji-availability filter now takes its
   650 characters from the same place, so it cannot disagree with the
   import that wrote them.

22. **The same expansion bit a third time, in the filter whose only job
   was to agree with another program.** The N3 pool refuses the spellings
   JMdict does not recommend -- `ateji`, `rK`, `oK`, `iK`, `sK` --
   because `import.p` refuses to TEACH them, and the two rules have to
   say the same thing or a pick arrives as something other than what it
   claimed. That filter was the one place `abbr()` was not applied
   (finding 20), so it matched nothing, and four phonetic borrowings
   walked into the rung: 味方, 無茶, 心地, 日和. The importer then did
   exactly what it promises -- no kanji form for a tagged spelling -- so
   four Japanese words arrived written in kana at the rung whose entire
   selection rule is *written in kanji the student has*, with no reading
   question at all. **And the audit said so, in a number I explained
   instead of chasing:** "four of the 2,466 picks are not askable for
   `read`, which is what the margin is for" is a sentence I wrote into
   `docs/langpop-n3-vocabulary.md` the same day. A margin that absorbs
   exactly four items is four items that should not be there. Fixed with
   one `abbr()` call and the test the rule always needed: every N3 word
   has a kanji form and a reading.

23. **A test that cannot fail passes.** `tests/test_langpop.p` has
   asserted since A2 that no two English items of one kind share a
   spelling -- the check written the day `service` and `excited` turned
   up in `a2.pl` while `items.pl` already held both as katakana traps.
   It built its key by concatenating strings, and a Pop-11 property
   compares keys with `==`, so every iteration made a fresh string, no
   lookup ever hit, and the check could not have failed if every English
   word in the graph had been spelled the same. `import.p` had learned
   this exact lesson about its own lookup tables and written it in a
   comment -- *keyed by WORDS and not by strings... every single lookup
   missed* -- and the lesson did not travel one file over. The keys are
   `consword`ed now, and the new Japanese kanji-spelling check was
   written that way from the start, and both now end with a lookup of a
   key the loop has certainly stored -- `people/word` is `e_people`,
   人間 is `w_ningen` -- which is the whole fixture and costs one line.
   The general version: a test that reports an empty list of problems
   should also show that it can find one, or all it tests is that
   iteration terminates.

24. **Guarding a wrong algorithm buys a rung of content, and hides
   that it is the wrong algorithm.** `--check` was 402 seconds where it
   had been 61 (2026-11-02), and a profile -- one scratch program,
   `systime()` around each violation on its own -- put 92% of it inside
   `reaches/2` and most of the rest in two clauses that look an item up
   by name. Both are the same fact about this engine: **Poplog's Prolog
   does not index clause heads**, so `item(Pre, _, L, _, _)` with `Pre`
   bound still walks all 7,565 item facts, and
   `requires_crosses_language` ran that twice for each of 12,505 edges.
   A clause like that reads as a definition and executes as a search.
   `check(graph)` now builds three tables of its own first -- language,
   level, edges both ways -- and the clauses ask those; what they say is
   unchanged. `reaches/2` was worse than slow: it answered *is this item
   on a cycle* by enumerating every distinct ROUTE below it, and the N3
   words multiplied the routes. The guards added in October (an item on
   a cycle has an edge in and an edge out, so leaves can be skipped)
   took it from 288 seconds to 28 and the question stopped being asked
   -- a constant factor on a wrong algorithm reads exactly like a fix
   until the data grows. One visited set for the whole search makes it
   linear in the edges below the item: 414 seconds to 0.02. **402
   seconds to 5.6**, same answers, and `tests/bad.pl` still produces all
   seven violations, which is the only reason to believe any of it.

25. **A tool written for one rung is a hypothesis about which of its
   rules were rules.** The N3 word pool was pointed at N2 (2026-11-02)
   and three of its rules turned out to belong to N3 rather than to the
   question. Each was found by a word, not by reading the code. (a) The
   N3 rule *a word both corpora use* REFUSES 判断: it is absent from the
   34,504-form subtitle list, as are 批判, 段階 and 背景, while 捜査 is
   at rank 109 — a subtitle corpus measures what people say, and N2 is
   the rung that reads editorials, so the newspaper orders this rung and
   the dialogue count is the tiebreak. (b) The pool excluded what the
   graph HAS and not what a curator had refused, so N2 opened with three
   words thrown out of N3 the day before; carrying rejections forward by
   ID ALONE then refused 捜査, because `w_sousa` had been refused as 走査,
   raster scanning. An id is a reading, not a word: the key is now (id,
   headword) and the reject files name the headword. (c) Which word owns
   an id was being decided by the ranking of the rung being built — three
   words read どうし, and `w_doushi` would have been 同志 at N3 and 同市
   ("the said city") at N2, which is identity-splitting arriving through
   the one door the pool exists to hold shut. Settled once, by the
   dialogue order, at every rung.

26. **Every corpus's top is partly its own operating manual, and that
   is why N1 does not need a better corpus.** The N2 rung was built by
   changing corpora (finding 25), so the obvious move before reading
   7,000 rows for N1 was to find the one that measures N1: written,
   non-journalistic Japanese. Measured instead of assumed (2026-11-02).
   The Wiktionary list drawn from the August 2022 Japanese Wikipedia
   dump through the kagome analyser -- 20,000 LEMMAS rather than surface
   forms, CC BY-SA 4.0, two pages fetched with `action=raw` and parsed
   with one regexp -- ranks every word the subtitle corpus could not:
   判断 at 823, 背景 at 1925, 段階 at 1941, 批判 at 1387, and 概念,
   要素 and 現象 in the 2000s, while demoting 犯人 from the subtitle
   corpus's rank 133 to 5134. The register shift is real.
   **And its own top forty is the apparatus of editing an
   encyclopedia**: 削除, 一覧, 項目, 執筆, 記載, 閲覧, 目次, 注釈,
   掲載, 当該, and 存命 and 生年月日, which are infobox fields.
   Subtitles give drama (殺人, 犯人, 捜査), newspapers give journalese
   (同省, 与野党, 同夜), Wikipedia gives revision-history words. A
   hand pass is not the price of a badly chosen corpus; it is the price
   of using any corpus as a syllabus.
   The arithmetic that settles it: of the 11,437 rows in the N1 pool the
   newspaper ranks 10,307 and this list ranks 2,315, of which 2,198 are
   ranked by both and 117 by Wikipedia alone -- and those 117 are mostly
   place names. Sampled at three depths, the agreed tier is refused 27%,
   43% and 45% of the time, so it yields about 1,355 of the 3,846 picks
   N1 needs; the rest still has to come out of the newspaper tail at
   30-65%. Total reading about 6,800 rows against 7,000-7,500 with the
   newspaper alone. **The corpus was never the constraint.** What
   binds is `vocabulary(10000, read)`, which `graph/ja/ladder.pl` marks
   `estimate(community)`: at that size the criterion asks for most of
   what any general corpus holds above the N2 line, specialist tail and
   all. The second signal is worth having as a COLUMN a curator can see
   -- agreement is a genuine quality mark at the top of the pool -- but
   it is not worth an upstream dependency, so it is recorded here with
   its recipe rather than wired in.

27. **The same unindexed lookup, a third time, and this one was in
   front of the student.** Finding 24 fixed `--check`; measuring the N2
   content (2026-11-02) found the identical pattern in `lp_plan()`,
   which the engine calls once per QUESTION. `ready/4` ended in
   `all_hold(requires(I, Pre), gate_ok(S, Pre))`, so for each of 9,741
   items it scanned all 12,505 `requires` facts. Per rung: 0.02 s at
   pre-school, 0.03 at N5, 0.11 at N4, **1.01 at N3 and 2.79 at N2** --
   three seconds of waiting between questions, growing with every
   tranche of content (it was about 0.3 s before the N3 words, and N1
   would have made it six). `lp_gates_ok/2` asks the edge property that
   `lp_why` already reads -- an item has two or three prerequisites --
   and says what `gate_ok/2`'s two clauses say, in their order.
   **2.79 s to 0.01 s, flat across every rung**, same check counts in
   both passes. The rule for this engine, now three for three: a Prolog
   goal whose first argument is bound is a full scan, so any such goal
   inside a loop over the graph is quadratic in the content. The ones
   left are in `--audit`, which runs them once per criterion rather than
   once per item.

28. **The same item for ever, and a row per call.** The observation
   below was that a reported-but-never-masterable item is re-assigned on
   every `assign` call with no way for a client to ask for the next one.
   Fixed 2026-11-02, and it was two defects sharing a loop -- a loop the
   TUI and the protocol handler had a copy of each. `lp_assign` took the
   first assignable item in the plan every time it was asked; a reported
   result caps an item at `TIER2_CAP`, below `MASTERY` deliberately, so
   the item stays unmastered, stays in the plan, and comes back for ever
   -- and every call APPENDED a row to `lp_assigns`, which is saved to
   the profile, so a student who kept asking grew their own profile
   without being given anything new. `lp_assign_pick` in `langpop.p` is
   now the one selector: it skips what this student has already been
   given, and when everything assignable has been handed out it returns
   the oldest still-OPEN assignment as itself -- same id, nothing
   appended -- because outstanding work is the honest answer to "what
   should I do away from the keyboard". Only when nothing is open is the
   answer nothing. The protocol reply gained an `again` field so a
   client can tell the two apart. No new API was needed for "the next
   one": asking again IS asking for the next one now.

29. **Smaller observations, not yet acted on:** `vocabulary(50, hear)`
   needs the audio build before any run can move it, exactly as
   `--audit` says.

Soak state: seeds 1-5 (ja) and 1-3 (en) all pass, and seed 42 passes on
the enlarged graph -- 3,000 answers against 9,741 items (2026-11-02),
climbing pre-school to N5 with 243 items burned and 1,154 of the answers
reviews, no invariant broken. At 9,000 answers the same seed
reaches 375 of the 800 N5 words and 62 of the 103 N5 kanji, which lands
inside the 371/392/412 band three earlier runs gave -- so the thirtyfold
scheduler speed-up moved the distance not at all, and the thing that
limits it really is the 200ms day rather than the engine. That run is also
how finding 27 was confirmed: 87ms an answer, where the same run before the
`ready/4` fix was about three seconds an answer, which is why it had never
been run against this content before. Not *deterministically*
-- finding 16 is what that word was hiding. The answers a seed gives are
deterministic; how many of them a run fits into its budget is not, because
the simulated day is 200ms of real time.
~1300 turns to exhaust ja pre-school's typed pool from empty before
reviews existed; ~2650 with them, which is the ladder being climbed four
rungs deep on every item and then burned; ~5700 with advancement. The
English runs went ~100 to ~1900 once there was something on the rung a
learner could finish and the harness would come back the next day for
it, and ~1900 to ~7800 once A1 held 519 words rather than 100. The
Japanese runs make the same move for the same reason now N5 holds 773
words rather than 170: a rung that can be finished is a rung the harness
spends answers on.

---

# Sequencing

Each phase ends with something checkable, and no phase depends on a
later one.

| phase | what | ends when |
|---|---|---|
| 0 | PR #72 to `dev`, `dev` to `master` | merged |
| 1 | the `load`-path fix; `./langpop`; the Poplog-version check | suites pass from a root-relative layout |
| 2 | the carve; verify 44 commits; delete from Poplog with a pointer | new repo's suites pass from a fresh clone |
| 3 | ~~a ceiling report~~ already built: it is `--audit` | nothing to do |
| 4 | the oracle student over JSON-RPC, and the invariant assertions | `ja preschool` climbs from empty, reproducibly, from a seed |
| 5 | the okurigana fix and the n5 word tranche to 800 | ~~`ja n5` climbs~~ the reading half does (2026-10-31, 773 picks, 823 words, 804 askable); the listening half wants `--audio n5`. N4's reading half followed (2026-11-01, 749 picks, 1572 words, and its 284 kanji by rule) |
| 6 | N3 vocabulary, 2,236 words | done (2026-11-01): 2,464 picks, `vocabulary(3750, read)` ok with 228 askable to spare, N2 short by 2,022 where it was 4,486. The rung was too big to pick a word at a time, so it has a rule instead -- JMdict's priority marks gate the pool, the dialogue corpus orders it -- argued in langpop-n3-vocabulary.md. 7,565 items, no violations, `--check` 61s to 402s and then to 5.6s once finding 24 was measured. Four picks were withdrawn the next day as findings 22 and 23 -- ateji spellings the pool's own filter had always meant to refuse, and the two property checks that now say so |
| 6 | the kanji column, all of it | done (2026-11-01): 650, 1023 and 2230 all read ok. N1 by rule, N3 and N2 by splitting old level 2 on school grade then newspaper frequency -- the one rung the source cannot answer, argued in langpop-n3-kanji.md. 5,061 items, no violations, `--check` 28s to 61s |
| 6 | N2 vocabulary, 2,022 words | done (2026-11-02): 2,176 picks from 2,900 rows read, 724 refused. `vocabulary(6000, read)` ok with 154 askable to spare; every Japanese reading criterion below N1 now met; 9,741 items, no violations, `--check` 10.5s. The rung needed the OTHER corpus -- see finding 25 and langpop-n2-vocabulary.md |
| 6 | the model harness: adversarial suite and sampled chat turns | the suite runs in CI-time and its failures are transcripts |
| 8 | N1 vocabulary, 3,846 words | **not started, and costed before starting** (2026-11-02): about 6,800 rows to read by hand, 2.5x the N2 rung, and finding 26 says a third corpus does not shrink that. The kanji criterion is already met. The question to settle first is the 10,000 itself, which is `estimate(community)` |
| 7 | English: the frequency corpus, the coverage criteria, the TOEIC band table | ~~`en a1` climbs~~ it does (2026-10-31, 519 words); `coverage` measures something real -- 13.57% of 95%, and the function-word queue is what moves it |

Phases 0--4 are days of small work (and 3 is none). Phase 5 upward is content, and that
is where the time actually goes -- which is the same conclusion the
audit table reaches, arrived at from the other end.

---

# Decisions

| # | decision | recommend |
|---|---|---|
| A | land PR #72 and reach `master` before carving | **yes** |
| B | Poplog deletes its copy and keeps a pointer row | **yes** |
| C | depend on a named Poplog release rather than vendoring `json`/`jsonrpc` | **yes** |
| D | repo name `pop-11-langpop.git` as asked, keeping the `pop-11-` prefix | yes |
| E | the English target is `en c1`; TOEIC is a reported band, not a rung | **yes** |
| F | the oracle student is the primary harness; the model is sampled and adversarial only | **yes** |
| G | a model verdict never certifies -- `MACHINE_CAP` holds for the harness too | **yes**, and this one is Lock 3 |
