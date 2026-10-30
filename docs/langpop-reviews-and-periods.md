# Reviews, and the month they are scored in

**Status:** built, 2026-10-30. This records a measurement that settled an
open design question, the mechanism it forced, and what is still a
number somebody should argue about.

## The question

Every measured exit criterion — `exit(ja, preschool, recognise(hiragana),
0.90, 3000)` and its thirty-eight siblings — was computed by `lp_measure`
over the student's whole journal. The denominator was their lifetime.

The oracle made the consequence concrete. Seed 42, climbing ja
pre-school from empty, reaches a state where *every one of the 69 kana is
at mastery belief* — the tutor's own overlay says the student knows all
of it — and the criterion reads **0.569**. Dragging a lifetime 0.569 up
to 0.90 needs about 1,900 further consecutive correct answers on material
already known. The rung was unpassable by anyone who had actually
climbed it, and easy for someone who arrived knowing the material.

## What the measurement showed

The obvious fix is a recency window. It does not work, and the numbers
say why:

```
recognise(hiragana), seed 42: 501 tier-1 answers, 69 items, all mastered
  lifetime        0.569
  last 400        0.645   (64 distinct items)
  last 200        0.645   (50)
  last 100        0.640   (23)
  last  50        0.660   (14)
  last 3 per item 1.000   <- tautology: mastery IS three rights running
```

A window narrows onto the hard remainder rather than onto settled
knowledge, because of how the journal is produced: `ready/4` excludes
what is known, so **an item is asked only while it is unlearned and
leaves the plan the moment it is mastered.** The journal therefore holds
the record of not-yet-knowing and no evidence at all of knowing. No
denominator over it can be made to mean what the criterion says.

Reading accuracy off the beliefs instead was the other candidate. It
fails differently: beliefs carry no latency, and the speed half of every
pre-school criterion would have to go.

## What was built

**Mastery schedules an item instead of retiring it.** The ladder is
`REVIEW_GAPS = [1 3 7 28]` days, widening, and an item that comes back
right after the last gap is **burned** — it stops being scheduled.
Burning is not a claim that it can never be forgotten; it is a claim
that individual drill has stopped earning its place in the hour. In
Japanese it keeps being tested anyway, because a burned kanji is a
building block of every later word that contains it.

A review that goes wrong needs no new arithmetic: the ordinary update
multiplies the belief by 0.30, which takes 0.83 to 0.25 — under
`MASTERY`, so the item walks back into the plan by itself and the ladder
forgets where it had got to. A skipped review falls further (0.20),
honestly so.

**A journal entry carries a phase.** Seven fields now, the seventh being
`learn` or `review`; a six-field entry from an older profile reads as
learning, which is what every answer before the ladder existed was.

**A period, and the scores reset with it.** 28 days, on the student's own
clock from their first answer, in whole weeks — not a calendar month,
which would put the boundary on the 1st for everybody, truncate whoever
started on the 28th, and move a weekly rhythm to a different weekday
every period. *The reading resets, not the record:* the journal stays
append-only and complete, and the period is a lower bound on what the
criteria read from it. Nothing is deleted to make a student look better.

**The criteria read reviews from the current period**, and carry a floor.
`lp_measure_in(items, ms, since, phase)` does the scoping; the status row
reports `need` — the size of the item set — beside `answers`, because
100% over three reviews of a 69-item set is a sample and not a skill.
Without the floor the window would be easier to game than the lifetime
denominator was, which is the objection the old "a skip counts in the
denominator" comment existed to answer. Placement still reads
everything: the answers it weighs are the ones it has just collected.

**Consistency, and a schedule offered rather than demanded.** The period
is a month a student can be behind in, and being behind is the one thing
a tutor can help with — the reviews pile up whether or not anybody turns
up. So the facts are counted (`days_worked`, `days_elapsed`, `sittings`,
`minutes`, a sitting being a run of answers that half an hour of silence
ends) and the suggestion is built from the student's own record:

- fewer than four days into the period: no opinion. A tutor with
  opinions on day two is a tutor nobody listens to on day ten.
- studied on half the elapsed days or more: nothing is said.
- turns up about weekly: *weekly*, as many sittings as they already
  manage, as long as they already sit.
- less than that: *daily*, the shorter and likelier habit, capped at 15
  minutes.
- nothing at all this period: ten minutes a day — the smallest honest
  ask, not a schedule invented out of no evidence.

A learner who has managed three sittings in three weeks will not start
studying daily because a program told them to. They might agree to three
sittings a week, because they have already proved they can. The engine
returns numbers; the wording belongs to the persona and the client.

### What the ladder did to the numbers

Same seed, same graph, after the change:

```
recognise(hiragana): 0.97 over 34 of 69 reviews   (was 0.569 lifetime)
recognise(katakana): 1.00 over 55 of 69
skill(dakuten):      0.97 over 39 of 46
```

The 0.90 thresholds are reachable, and reachable by having learned the
material rather than by having answered a great many questions.

## What the oracle caught on the way

A review answered after a **typing slip** was recorded as *learning*.
`lp_m_answer` cleared "the item in flight" as soon as any answer
arrived, so the retry — which is the same question — came in with
`asked` false and fell back to the gate channel and the learning phase.
It then counted towards no criterion and left the item's rung where it
was. The channel half of that bug predates phases and was live.

Fixed by keeping the question in flight until something is actually
recorded; the clock still runs from `s(4)`, which the slip path has
always left alone on purpose, so a deliberate slip still buys no time.
The oracle found it by counting six passed reviews of a four-rung ladder
(`tests/test_langpop_server.p` now pins it).

`--day-ms` is the one piece of instrumentation this needed: a run lasts
seconds and a gap is a day, so without a short day no review could ever
come due. It scales the clock and nothing else — no outcome, no
threshold, no interval order. The scratch server the oracle provisions
uses 200ms.

## Passing the rung

Thirty-nine criteria were declared, measured and printed, and nothing
read the answer: a student could satisfy every one of them and stay
where they were, because the level was only ever set at login or by hand
with `:level`. `lp_criterion_met` is the other half, and a criterion is
one of three things:

- **met** — a measured one needs *both* halves over the threshold
  (`within_latency` counts the answers that were right *and* quick, so
  asking for both says what the criterion means) *and* the floor:
  `answers + settled >= need`. A counting one needs `have >= want`.
- **unmet** — plainly short.
- **excused** — and this is not a kindness. It is the `lp_ungateable`
  argument again: a criterion nothing on this machine can measure is
  reporting the *tool's* limit, so holding the door shut on it would
  mean a student with no voice configured could never leave pre-school
  however well they read. Three cases are excused: `vocabulary(n, hear)`
  where nothing can hear, a criterion whose content is not generated,
  and a measured criterion with **no items in the graph at all** — that
  last one would otherwise wedge a rung shut for good, silently, on
  content nobody has written yet.

Excused criteria are *named* every time the level is reported, in both
doors. Excusing something quietly would be the comfortable averaging the
tier system exists to prevent. And a rung with nothing but excuses does
not pass: `passed` needs something actually met, or advancing would walk
a student up the whole ladder on the strength of criteria nobody has
written.

**Settled items count towards the floor, and towards the percentage.**
An item is burned by answering it right four times running over four
weeks, so a settled item is stronger evidence than any single review.
Counting it once as `right` understates it; not counting it at all
reads 0% for a student who has settled the whole set and so has nothing
left to be asked — which is the state the oracle reached on
`skill(mora_count)`, a one-item criterion: settled, perfect, scoring
nought. `lp_blend` folds them in, and both counts stay visible in the
row (`over N reviews and M settled of K`) so nothing hides in the
average. It is also what makes the measurement survive one bad day:
sixty-eight settled and one fluffed review reads 98.5%, not 0%.

A pass moves the student immediately, in whichever door they came
through, and the move is *said* — `langpop/answer` carries
`level_passed`, the TUI prints it. A student should be told by the
teacher, not discover it from a status screen three sessions later. The
top of the ladder is passed and stayed at: somebody who finishes `n1`
has run out of rungs, not out of language. `lp_passed` keeps the dates,
because the journal holds answers and not verdicts.

### What it then found

ja pre-school passes and the student climbs to n5, which is the first
time the ladder has been climbed end to end:

```
level n5, moved up to: [n5]
  kanji(103, read):     103 of 103
  vocabulary(800, read): 220 of 800   (graph holds 170)
  vocabulary(800, hear):  52 of 800   (graph holds 170)
  still to finish: [vocabulary(800, read) vocabulary(800, hear)]
```

The rung is now blocked by *curation* and says so precisely: 170 words
exist where 800 are wanted. That is phase 5, and the audit said the same
thing from the other end.

English pre-school correctly does **not** pass. Its three criteria have
items (12, 12, 1) but every one is hear-gated and unaskable until
minimal-pair listening questions exist, so there are no reviews and
nothing settled. A student genuinely has not demonstrated the sound
contrasts, and the criteria are not excused — the items are there, the
questions are not. See `langpop-pronunciation.md`.

### And one bug underneath all of it

Every capped tier was a plain `min()`, which made a cap a level it
dragged a belief *to* rather than a ceiling it could not pass. Positive
evidence about an item already better known than the cap demoted it: a
student with 誕生日 at 0.99 who read it again had 日 inferred, and
`min(0.99 + …, INFERRED_CAP)` handed back **0.75** — an item fell out of
mastery because something good was observed about it. `TIER3_CAP` was
worse: saying "I did the homework" took a mastered item to **0.50**.

`lp_cap(b, raised, cap)` is `max(b, min(raised, cap))`, and the ceiling
still does its job in the direction it was written for — an item *below*
a cap cannot be carried past it, so one verified check is always what
tips it over. The oracle found it through the ladder, which schedules on
mastery and so reported items being reviewed at exactly 0.75 and exactly
0.50: the two caps, named in the violation.

## Still arguable

| # | thing | current | why it is arguable |
|---|---|---|---|
| 1 | `REVIEW_GAPS` | `[1 3 7 28]` days | four rungs to burn is a pacing decision, not a measurement; a real SRS would fit the curve to the student |
| 2 | `PERIOD_DAYS` | 28 | whole weeks beat a calendar month, but 28 against 21 or 35 is taste |
| 3 | ~~the floor~~ | enforced by `lp_criterion_met` as `answers + settled >= need` | settled |
| 4 | burning | permanent | an item burned a year ago is not evidence about today; a second, much longer rung (a year) may be the honest answer |
| 5 | placement | reads everything, unwindowed | right for a fresh student; for a returning one, a window would place them on who they are now |
| 6 | goals | the rung's criteria *are* the goals | deliberately no second scoring system; if a period wants a target it should be drawn from the gap to the criteria, not invented |
| 7 | advancement | automatic, and immediate | WaniKani levels you up; a tutor that waited to be asked would be hiding the thing the student is working for. But it means a rung can be passed mid-session, which nobody has watched a real student react to yet |
| 8 | excusing a criterion with no items | excused | right while a graph is being built; once `--audit` says a rung is complete, an empty criterion is a *bug* and excusing it hides one |
