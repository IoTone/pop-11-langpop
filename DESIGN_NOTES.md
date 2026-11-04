# Design notes

This is the record of how langpop was built: what the measurements found,
what turned out to be wrong, and why each fix is the shape it is. The
[README](README.md) describes the curriculum and how to run it; this file
is for anyone who wants to change the engine, or who is deciding whether
to trust a number it prints.

Most of what follows was found by running the thing rather than by reading
it. That is the general lesson and the reason two of the tools exist.

## Contents

- [The two tools that find things](#the-two-tools-that-find-things)
- [The ladder](#the-ladder)
- [Questions and answers](#questions-and-answers)
- [Importing](#importing)
- [Sound](#sound)
- [Printing](#printing)
- [Content tranches](#content-tranches)
- [The journal is a log, so it is a file](#the-journal-is-a-log-so-it-is-a-file)
- [Poplog behaviours worth knowing](#poplog-behaviours-worth-knowing)
- [Three things found in the Poplog tree](#three-things-found-in-the-poplog-tree)
- [What the protocol front end cost](#what-the-protocol-front-end-cost)

---

## The two tools that find things

**`--audit` exists because three rungs with no door were found by hand.**
`--check` proves the graph is consistent; it says nothing about whether a
level can actually be finished. `exit(ja, n1, kanji(2230, read), …)` is
perfectly consistent against a graph holding 103 characters.

Three separate holes were found by accident before the audit was written:
`en/a1` declared no exit criterion at all, so it was a room with no door;
all twelve English sound contrasts returned `shape = "none"`, so nothing
in the set could be asked; and `skill(dakuten)` was measured over a set of
one unaskable item. Found by hand means found by luck. The audit turns each
of those classes into a row.

`check(graph)` now also refuses a level with no exit criterion outright, so
the first of them cannot recur:

```prolog
violation(level_without_exit(Lang, Level)) :-
    ladder(Lang, _, Level), \+ exit(Lang, Level, _, _, _).
```

**`oracle.p` exists because the audit reads the graph and not the engine.**
It is a seeded student that climbs the ladder over JSON-RPC, asserting the
engine's invariants at every answer. A failing run prints its seed, and the
seed is the bug report. Several of the findings below have no other
plausible route of discovery: they depend on a particular sequence of
answers over simulated weeks.

The oracle needed two corrections of its own. It used to stop the first
time the question queue emptied, which made review stage 2 unreachable and
left every rung reading as unfinished; it now waits — "come back tomorrow"
— bounded by a counter. The first version of that wait then treated *owed
right now* (an interval that came due between asking for a question and
asking for the status) as nothing owed, and ended the run anyway. Both arms
are needed.

**A third: the starvation check disagreed with itself.** The oracle flags
any ready item it was never offered, which is how a scheduler hole would
show. Seed 42 began failing that check at 9,000 answers — and then passing
it, on the same tree, with the same seed and the same content. Three runs
reached 373, 392 and 412 of the 800 N5 words; the two that got furthest
each left exactly one item unoffered, `w_sengetsu` once and `w_kyuu` once.
Both are words waiting on a kanji, and both were unlocked in the last few
hundred turns of the run that flagged them.

So the check was measuring the budget, not the scheduler. How far a run
gets is a function of wall-clock speed, because the scratch server runs a
200ms day and the review ladder is measured in days — a quieter machine
climbs further in the same number of answers, unlocks more items, and is
more likely to end holding one it had no turns left to ask. **A gate that
is a function of machine load is not a gate**, and this one was reporting
progress as a defect: the run that got furthest was the run that failed.

An item is starved when the scheduler had the chance to offer it and did
not, so the chance is now what is measured. The ready pool is sampled once,
halfway through the budget, and only an item that was ready *then* and was
never offered after counts. A run that stops before halfway leaves the
sample empty and claims nothing, which is right — it stopped because there
was nothing left to ask, which is the opposite of starvation.

The same seed given 14,000 answers rather than 9,000 **finishes the rung**:
804 of 800 words read, the run ending at 12,518 turns because it had run
out of things to ask. That is worth recording for its own sake. It is the
first time a simulated student has reached the N5 reading criterion, rather
than the graph merely holding enough words for one to be able to.

---

## The ladder

### A skill measured over itself, when it has no probe

`criterion_item(skill(S), S)` answered with the skill item, which has no
written form and so no probe. `skill(dakuten)` was therefore measured over
a set of one unaskable thing, reported *0% right over 0 answers* for ever,
and could never be met. **Three of the five Japanese pre-school criteria
were in that state.**

A skill is now measured over what it rolls up over, transitively, skipping
skills on the way down — because `mora_sokuon` requires `mora_count`, which
is itself a skill, so one level of expansion would have swapped one
unaskable item for another.

The companion case is a skill that *does* carry a probe, and there the
original rule is right: `skill(dakuten)` is *read the voiced kana*, so
reading them is the evidence.

### A criterion naming a contrast the graph did not hold

`--audit` then said `skill(dakuten)` passed on one item. The skill's gloss
is *か/が, は/ば/ぱ — one mark changes the sound*; it required `hi_ka`, and
the kana table held base kana only. So the criterion was answerable by
reading か — an **unvoiced** kana, the one thing that cannot demonstrate
the contrast the skill is named for. It would have passed, and it would
have meant nothing.

The fix was the glyphs rather than the criterion. Dakuten is the base
codepoint + 1 and handakuten the base + 2, so the 46 voiced kana are
generated along with the other 92 and a glyph cannot be subtly wrong.

| | before | after |
| --- | --- | --- |
| `kana/5` facts | 92 | 138 |
| `recognise(hiragana)` | 46 | 69 |
| `skill(dakuten)` | 1 item, `thin` | 46 items, `ok` |
| graph | 521 items | 567 items |

It also closed a gap nobody had noticed. The aggregates fan out by rule —
`requires(hiragana_all, Id) :- kana(Id, hiragana, _, _, _).` — so the
voiced kana joined them with no edit, and **がっこう needs が**: until then
the starter words required a `hiragana_all` that did not contain it.

### `thin`, and counting questions instead of items

Two criteria came back `thin` over a set of one item — あ — which cannot
demonstrate beat counting whatever a student does with it. The obvious
reading of that was *timing needs audio*, and it was wrong: producing
correct timing needs a microphone, but knowing how many beats a word has is
a reading question with a number for an answer.

Adding a generated probe then broke the audit's arithmetic in the other
direction. A skill with a generated probe is one item that can be asked
about fifty words, so counting it as one item called the criterion thin
when it was not. The audit counts **askable questions** now. The reverse is
what matters more: when the material for a skill runs to a single word, the
criterion genuinely is thin, and nothing else would have said so —
`skill(mora_sokuon)` had exactly one pre-school word with a small っ in it.

That number named the curation precisely:

| | before | after |
| --- | --- | --- |
| `vocabulary(50, read)` | short by 10 | **50 of 50, ok** |
| `skill(mora_sokuon)` | 1 question, thin | **7 questions, ok** |
| `skill(mora_count)` | 1 item, thin | **51 questions, ok** |

Ten more starter words closed all three, and choosing them taught something
about the list. The first draft picked きっぷ, ざっし, でんしゃ, おちゃ,
じしょ, しゅくだい and でんわ — all good mora examples, and **all seven
already in the N5 pick list** as 切符, 雑誌, 電車, お茶, 辞書, 宿題 and
電話. `--check` caught it as `requires_from_above`: one id at two levels,
with the pre-school word inheriting the N5 word's character prerequisites.

Adverbs and expressions are the right material anyway. A learner meets
ちょっと and たくさん constantly, in kana, and will never meet them as 一寸
and 沢山, so teaching them at pre-school costs nothing later. Teaching
でんしゃ in kana is teaching a word that has to be relearned as 電車 two
rungs up. "Words normally written in kana" is the criterion a kana-only
list should have had from the start.

### The long-vowel probe, which went wrong first

いえ is `ie`: two vowels, and two **different** ones — い then え, two beats
of two sounds, no length anywhere. The first version of the probe took any
adjacent vowel pair and duly offered いえ as a long-vowel exercise. A long
vowel is the same vowel twice, or one of the two spellings Japanese uses
for one: おう and えい.

### Two holes in the English ladder

`--audit` walks the exit criteria, so **a rung that declares no criterion
produces no rows** and is invisible in that table. That is how `en/a1` came
to be a room with no door, and how `en/c1` still was, two sections later,
in the same file.

**B1 declared one criterion**, `coverage(reading, 0.95)` — and nothing
measured coverage, so B1 was the same missing door differently disguised.
Its counts also jumped 1,000 to 5,000 with nothing between, which is two
CEFR bands of silence. B1 now carries 2,500 reading and 2,000 listening.

**C1 declared nothing at all.** *What does it mean to have finished?* is
the question a ladder exists to answer, and `ja/n1` answers it. C1 now
carries 8,000 reading, 6,000 listening and a listening coverage floor.

### Cumulative counts against a level-exact denominator

The mastered count had no level bound at all and the graph's total had an
exact one, so the two figures on one `:status` line were counted three
different ways. English A2 made it absurd rather than merely wrong: A2
declares no words of its own and inherits every one of them, so a student
with 499 words read

```
vocabulary(1000, read): 499 of 1000 (graph holds 0)
```

All three count procedures are bounded by the level index now.

### An item forgotten after moving up was orphaned

That absurdity was the visible edge of a real defect. `ready/4` asked for
the student's level **exactly**, while every other count in the design is
cumulative. And the review ladder drops an item the moment it falls back
under mastery. So a word the student forgot after moving up sat in neither
the teaching plan nor the review queue, was still counted against the
rung's criterion, and could only be found again by setting the level back
by hand.

English A2 is where it stopped being theoretical, because A2 declares no
items of its own and its plan was empty by construction.

This is the other half of the review argument: reviews catch the
*remembered* case, and nothing caught the forgotten one. The fix is
`at_or_below`:

```prolog
at_or_below(Lang, Lv, Level) :-
    ladder(Lang, N, Lv), ladder(Lang, Top, Level), N =< Top.
```

The oracle prices it — the same seed went from 497 of 531 words mastered to
531 of 531.

It was proved with a scratch script before being fixed: master `t_smart` at
pre-school, move the student to A1, fail it twice, and observe that it
appears in no plan and on no ladder.

### Excusing a criterion nothing can measure

`--audit` said **zero of twelve** rungs could be left, for a long time, and
that figure is the history of two separate problems.

The first is that `needs_audio` and `no_probe` had been the same verdict.
The first run reported `sound_contrasts` as a bug, which is wrong: the
probe is not missing, the microphone is. An item-set criterion whose every
item sits on an unverifiable channel is a limit of the build.

The second is that reporting it was not enough. A rung held shut by a
criterion nothing on this machine can measure is a rung no student can ever
leave, however well they do. So the engine now **excuses** such a criterion
by name: the student moves up, and the tutor says which criterion it could
not ask about. A rung of nothing but excuses does not pass.

`--audit` stopped saying `not yet` of a rung the engine will pass, and says
both things instead — the rung can be left, and part of it will not have
been measured when it is.

The excuse covers four cases: `audio` (nothing can hear), `unbuilt`
(content not generated), a measured criterion with zero items, and a
measured criterion where not one item is askable on any verifiable channel.
The last of those was added for `sound_contrasts` at English pre-school,
which had been reading 0% over 0 reviews for ever.

### The honest `ok`

`sound_contrasts` reporting `ok` with four of its twelve contrasts silent
looks like a false claim, and the columns made it worse: `12  29` reads as
full coverage, because `askable` counts distinct questions rather than
items. That is the price of counting questions, and this was the first
criterion partial enough to show it.

The verdict is right and stays: accuracy on an item-set criterion is
measured over the answers given, so an item nobody can be asked about
leaves the measurement rather than capping it. What was missing was the
reader being told. Hence `ok -- 4 of 12 cannot be asked`, and with no voice
installed at all, `needs_audio -- 12 of 12 cannot be asked`.

### What is left

Coverage was the last `unmeasured` row in the graph, and it is measured
now. What is left on every rung is content — which is the only verdict
allowed to be large.

---

## Questions and answers

### 251 imported items could not be asked about, silently

`lp_question/1` could only build a probe for an item carrying a **romaji**
form, and the importer emits kanji, hiragana and katakana forms and no
romaji. So every imported Japanese item returned `shape = "none"`:

```
ja n5 grapheme  103 items, 103 unprobeable
ja n5 word      148 items, 148 unprobeable
```

251 of 521 items, with no violation, because nothing checked that an item
could be *answered*. The tutor simply said *"nothing here can be checked by
typing."*

The fix is not to emit romaji into the graph. `form(k_5c71, kanji, '山')`
together with `form(k_5c71, hiragana, 'やま')` **already is** a probe —
prompt one, answer the other. What was missing was the ability to accept
that answer typed in Latin letters, which is a fact about the writing
system rather than about any item, so it lives beside the answer checking
and not in the graph.

**26 items remain unprobeable, and that is the right number**: the eight
skills (roll-ups over what they require), the three patterns (produced, not
typed) and the fifteen sound contrasts (which need audio). The suite
asserts that *shape* rather than a count — *every item that cannot be typed
is a skill, a pattern or a sound* — which is the invariant the original bug
broke.

The youon transliteration rule is where a one-liner gets it wrong. Dropping
the trailing `i` and adding the small kana's vowel turns きょ into `ko`; the
stem needs a `y` *unless* it already palatalises, and "ends in h" is not
that test:

| | stem | | |
| --- | --- | --- | --- |
| き + ょ | `k` | → `kyo` | needs the y |
| し + ゃ | `sh` | → `sha` | already palatalises |
| ち + ゃ | `ch` | → `cha` | already palatalises |
| ひ + ゃ | `h` | → `hya` | **needs the y** |

The kunrei rows are not optional. A table that only knew `shi → si`
rejected `densya` while accepting nothing, and でんしゃ is the commonest
row in the syllabary.

### The answer key was recomputed at grading time

The most serious defect found in the project, and it survived for a long
time because of a coincidence.

`lp_m_answer` rebuilt the question in order to grade it. A `pick` question
turns its options over on every call — so recomputing it swapped option 1
for option 2. It worked only because the plan and the chooser also call
`lp_question`, so the number of calls between asking and grading happened
to be even and the parity came out right.

Injecting a review question added one call. Half of every English answer
was then marked wrong.

The question in flight is stored in the session now — `{shape, prompt,
answer, options}` — set when the question is issued and cleared when
something is recorded. The regression test registers a student, asks for a
question, makes one extra `lp_question` call, answers correctly and expects
`correct: true`. It was verified to fail with the fix reverted.

The same class of error hit the oracle: `ora_truth` recomputed the question
locally in order to know the right answer, and a written confusion's
*stimulus* varies with how many times it has been asked, so the oracle
marked the server wrong on every confusion — 933 violations in one run. It
derives the answer from the prompt now. A question nothing outside the
server can mark is a question nothing outside the server can check.

### The tie-break had never fired, once

```pop11
if not(best) or b < bb or (b == bb and a < ba) then
```

A belief is a float, and in Pop-11 `==` on floats is **identity**: two
`0.0` literals are not `==` each other, let alone two separately computed
ones. So `b == bb` was false for every pair of beliefs ever compared, and
the chooser returned the first item in plan order and kept returning it
until it was mastered — which is precisely what its own comment says it
exists to prevent, *"which is how a learner comes to hate a flashcard"*.

It showed up because a listening session asked ひと twice in a row with 49
untouched words in the pool. In the reading path the same bug is invisible:
ties at 0.0 are broken by plan order, which looks like a reasonable
curriculum order, so nobody would notice.

The fix is one character, `=` for `==`, in both choosers.

### A deferred item came back as the very next question

`later` and `:oops` both put an item back in the queue, and the first
version re-asked it immediately — because the deferred item had the lowest
belief of anything ready, which is exactly what the chooser picks.

That matters most for `:oops`, which is used *after* the tutor has said what
the answer was. Asking again straight away would measure the echo rather
than the memory, and would hand a free correct answer to anything got
wrong. There is a gap of three questions now. Only running it showed this.

### The reveal said `It is 2.`

For a question answered by a number, the answer *is* a number, and
revealing it teaches nothing:

```
  Not yet. We will return to it.  It is 2 -- /v/ - /b/.
```

This had been true of the trap questions all along, not only of the new
listening ones. The reveal shows the option now, and `expected` on the wire
does too.

### Each pair would always have played the same side

`lp_pair_item` picks the pair with `asked mod 4`, so choosing the side with
`asked mod 2` gives pair 0 an even count every time: `right`/`light` would
play *right* for ever and *light* never, and a student could learn the pair
number instead of the contrast. Dividing first — `(asked div npairs) mod 2`
— means the first pass through the pairs plays one side of each and the
second pass plays the other.

### Two displays preferred the wrong form

`lp_any_form/1` and the card's term order both preferred hiragana over
kanji. That was right while every item was a kana or a kana-only starter
word, and wrong the moment the import brought in characters: `:why k_4e00`
headed itself ひと rather than 一, and the card for 山 came out as a card
reading やま with no reading line at all.

Putting kanji first then did the same thing to English in reverse — a
loanword trap came out as マンション with `mansion`, the word the item
exists to teach, nowhere on it. The rule is per-language: the term is the
form in the **item's own** language.

The gloss direction turned up a modelling error it had been hiding. The
loanword traps filed **English text under `ja`** —
`gloss(t_mansion, ja, 'apartment building')` — where the schema defines a
gloss as what an item means in a named language. Nothing read it that way
until a card asked for the Japanese, and then the card for `mansion`
proudly displayed the very meaning the item exists to unteach.

---

## Importing

### Four things Pop-11 and Prolog do that the code did not ask for

**A property compares its keys with `==`.** So two equal strings are two
different keys:

```pop11
lvars p = newproperty([], 8, [], "perm"), a = 'yama';
[x] -> p(a);
p(consstring(`y`,`a`,`m`,`a`,4)) =>      ;;; ** []
```

The importer keyed 148 wanted headwords by string and every lookup missed,
which read back as *matches no entry* for all 148 picks — a plausible
result, since a missing word is exactly what a bad key produces. Words are
interned, so the fix is `consword`; the entry side then needs a cheap
pre-filter (length and first byte) so that interning 148 keys does not mean
interning three quarters of a million headwords to find them.

**`printf` has no hex conversion.** `REF * PRINT` lists `p P s S c M` and
`%%`, then says of `b`, `d`, `i` and `x` that they are "reserved for system
use". `%x` duly prints the raw tagged machine word:

```pop11
sprintf('%x', [16:5C71]) =>      ;;; ** '00000000000171C7'   (23665*4+3)
```

Every character id is minted from a codepoint, so this produced 103 items
named `k_00000000000171c7` and not one of the word-to-character edges
matched. It also meant the JSON escape for a control character was emitting
`\u00000000000000a9` for a newline — invalid JSON, latent because nothing
in the graph has a control character in it. Both use a hex formatter
written out longhand now.

**`==` on two string literals is `false`.** The emitter decided which
source name to stamp with `srcname == 'JMdict'`, which is never true, so
the words file announced itself as `generated(kanjidic2, …)`.

**A quoted atom cannot escape a quote by doubling it.** Standard Prolog
does; Poplog Prolog does not:

```prolog
d1('doubled''quote').     % FOUND : 'quote'  -- the clause is DROPPED
d2('backslash\'quote').   % ok
```

A syntax error in a consulted file is **not fatal** — Prolog reports it,
skips that clause and carries on — so the first import emitted three glosses
containing an apostrophe that never reached the graph, and `--check` still
said *no violations*, because no integrity rule says an item must have a
gloss. The error does print, in a line of loading noise, among several
hundred others.

Two things came out of that. The escape is a backslash now; and the importer
**reads back what it wrote** (`imp_verify`), comparing what the emitter
meant to emit against what the graph actually holds, so any emission bug by
this route is loud:

```
LOST w_byouin: gloss missing or wrong
;;; MISHAP - import: facts written but not in the graph (quoting? syntax?)
```

The test that should have caught the original was asserting the *shape* of
the atom quoter's output — and passing, because it asserted the standard's
doubled quote, which is wrong here. The checks round-trip the atom through
`prolog_compile` and ask the real consumer now, including one that asserts
the doubled form would **not** have survived.

A related trap in the same file: Prolog single-quoted atoms cannot hold a
bare apostrophe at all, which is why a gloss reads `'twelve hours after
noon'` rather than `o'clock`.

### A guard clause became an item

`mix/4` carries a guard row — `mix(none, '', '', none).` — so that the
relation exists when no confusions are declared. The derivation rules
matched it, and `written_confusions` read 13 items with one unaskable. Every
derivation goes through a guard predicate now:

```prolog
mixed(Id, A, B, Why) :- mix(Id, A, B, Why), Id \== none.
```

### The importer took the first spelling

`--source cmudict` enriched an item from its first `latin` form, which is
fine until an item has two: `m_rice` got the pronunciation of `rice` alone.
Both enriching modes read every latin form now. `imp_verify` then reported
every second pronunciation as LOST, because it asked whether the graph held
*the* form of that script rather than whether it held *this* one.

### The importer derived an edge the schema forbids

`requires(m_think, s_th_un)` is true of the word and wrong about the
teaching order. It was invisible with no voice installed, because an
unverifiable prerequisite does not hold the door shut — but with a voice
installed it would have moved the whole written-confusion rung behind the
listening one, which is the separation those items exist to maintain. No
contrast edge is emitted for a written confusion.

### A generated file the engine did not load

The traps had never been enriched: `--source cmudict` filters by level and
had only ever been run for `a1`. Running it for `preschool` wrote a new
file, and `imp_verify` reported all 23 facts as LOST, because the engine's
manifest is a hand-written list and never loaded the file.

The verifier was right and the message was baffling, so the importer refuses
the write instead:

```
import: the engine does not load that file -- add it to
GRAPH_GENERATED in langpop.p, or pass --out
```

And one card quietly changed when the traps gained pronunciations: the
English term order put `ipa` before `katakana`, so every trap card swapped
マンション for `/mˈænʃən/` and stopped showing the thing the item exists to
contrast. A katakana form on an English item *means* the word is a loanword
trap; the IPA is a pronunciation guide.

### Reading a bilingual dictionary backwards does not work

It was measured before it was built, which is the only reason the Japanese
glosses in `a1.pl` are hand-written:

| English | what the reverse lookup returns |
| --- | --- |
| water | 水分, お水, ウォーター — and never 水 |
| think | シンク, the katakana loanword |
| mountain | ベルグ, マウンテン, 山 — the first is German |
| very | 迚も, an archaic spelling |
| remember | 銘記 |

Filtering to priority-tagged entries and dropping the katakana-only ones
cleans up the worst of it (`mountain` → 山) and still leaves `water` → 水分,
which means *moisture*.

### What the gap report found on its first run

The entire English top-30 gap is **function words**, which is the coverage
an A1 content list cannot reach by construction. And the Japanese list
showed the tokeniser splitting verbs from their endings — 話す as 話, 分かる
as 分か — so the report was listing the stem of every verb already taught as
a gap. Measured: 3.90% of the corpus credited, 5.16% held by a stem and
wrongly called missing, 9.06% genuinely absent. 知, 話, 分か, 聞, 持, 会 and
入 were at the top of the queue, and a curator working it would have picked
seven words already in the pick list, all of which the importer would have
refused as taken.

The contraction rule took two attempts. "Has an apostrophe" caught 315
tokens, among them `'em`, `'cause` and `'bout` — real spoken words at a rank
a curator should see. Filing those under *nothing to teach* would be the
report answering a curation question by itself, so the rule is two closed
lists.

---

## Sound

### `hear` and `produce` were parked together as "audio"

For most of the project's life `hear` sat outside the verifiable set with a
comment explaining that there is no audio in langpop. That conflated two
different problems. Producing a sound needs a microphone, a phoneme model
and a verdict. *Hearing* one needs a speaker.

Once output existed, a listening question turned out to need almost nothing
new: play the word, the student types what they heard, graded by exact match
exactly as reading is. No new evidence tier, because the only machine in it
is the one that spoke.

The consequence was larger than expected. With a voice for both languages,
every `vocabulary(N, hear)` row became measurable and **`needs_audio` went
empty**. All fourteen of those rows were `hear`; not one was `produce`,
which had been inside the verifiable set the whole time.

Which is also the uncomfortable conclusion about the production work: a
pronunciation verdict would not move a single row of `--audit`. Production
is an **unstated goal** — if it matters, the ladder has to declare criteria
that say so, and it does not. That is a curation question before it is an
engineering one, and it is written up in
[docs/langpop-production-criteria.md](docs/langpop-production-criteria.md).

### Making `hear` verifiable re-locked the English ladder

`gate_ok/2` lets an unverifiable prerequisite off, so that a channel nothing
can check does not hold the door shut. That exemption was *"is the gate
channel outside the verifiable set?"* — and the twelve English contrasts are
sound items whose gate is `hear`. Install a voice, and the exemption
vanishes and every one of them starts locking everything built on it. The
defect that had been fixed months earlier came back in through the door
output had opened.

The first fix was wrong in an instructive way. Making the exemption *"can
this item be drilled?"* is true of a contrast and also true of
`hiragana_all` — an aggregate with no probe whose belief rises by inference
from the 46 kana it requires. Undrillable is not uncheckable. The result was
that every aggregate became a free pass and all 50 starter words were
declared ready at the first question. The suite caught it: *only the vowels
are ready at the start* went from 5 items to 53.

`lp_ungateable/1` is the narrow version. For `read` and `produce` it is the
channel alone, exactly as before. For `hear` — which became verifiable only
because a voice exists — it asks whether a listening question can actually
be asked, and where one cannot, nothing has changed from the state before
the voice arrived.

### A contrast has no written form, so it had nothing to swap

All twelve contrasts were reported `needs_audio` after the listening
question existed, because the question works by replacing a written
stimulus with a sound and a contrast has no written form. **It was never the
microphone that was missing; it was a pair.**

`pair(Contrast, A, B)` gave 29 pairs over 8 of the 12. Shaped as a
two-option question deliberately, so the drill loop, the protocol and every
client need no new arm — only what the options *mean* differs, two glosses
for a trap and two words for a contrast.

The pair words are **not items**. `right` and `light` are drill material
belonging to a contrast, and making them items in order to get them spoken
would have inflated every English vocabulary criterion with words whose only
job is a drill. So the audio cache lost its assumption that everything it
speaks is an item: the key is `{name, voice, rate, model, text}`, where an
item's name is its id and a pair word's is a slug of the word. One file per
word, shared between the contrasts that use it — `berry` separates /r/–/l/
from *belly* and /v/–/b/ from *very*.

### The scorer measures something other than what the plan specified

The audio plan scoped the first measuring stage as *beat boundaries, a
duration per mora, a comparison against a count the graph already computes*.
**The first half of that is wrong, and measuring it is how we found out.**

An energy envelope finds voiced runs, not beats. がっこう comes back as two
runs — が, then っこう — because こ and う are one continuous voiced stretch
with nothing between them to detect. No threshold produces four.

What the envelope does see is silence, and one Japanese mora is made of
silence. So the scorer answers the question `mora_sokuon` actually asks and
declines the rest. The numbers are in the README; the useful part is that
the ratio is normalised by the word's own mean mora length, so no
calibration utterance is needed.

### A silent recording reported that the voice filled it

The case the microphone meter exists for, and it was wrong on the first
attempt. With a peak of zero the gate is zero, so `v >= gate` was true for
every frame and a silent recording reported *"the voiced part fills the
whole recording"* — true, and the exact opposite of useful. The gate needs
`v > 0` as well.

The meter also exited non-zero on that case, which made the tutor say *"I
could not run the meter"* over a perfectly good report of a dead
microphone. A non-zero exit now means only **I could not read the
recording**; reporting that nothing arrived is a successful run.

### `json_generate` drops a `false`, for the third time

`detectable: false` left the key out altogether — and the scorer, reading an
absent key as its default, duly measured a gap in いっしょ and called it
**right**. An absent field and a false field are the same thing once parsed,
so the fact is carried positively now: `"detectable": "no"`.

This is the third time the same shape of defect has appeared. The aids
store *names* rather than a map of booleans for the same reason: a map could
not tell a profile written before an aid existed from one that switched it
off, and reading the first as the second would silently take an aid away.
And the same is true of the audio parameter — `cached_only: true` rather
than `render: false`, because a `render` parameter would read every client
that omitted it as one switching rendering off.

### Why the scorer is a command and not a side-car

The plan said a JSON-RPC side-car, and the argument for a persistent process
was model load time. The scorer that exists loads no model, so the latency
that justified it is not there to measure. The contract is identical either
way — a request object in, a verdict object out — so the day a model makes
startup hurt, the transport changes in one procedure and nothing above it
moves.

---

## Printing

### Nothing is vendored, and that is the whole of the licence answer

The obvious way to build the booklet is to take a free zine template and
fill it in. The one we looked at
([taylorsmithdesigns.co.uk/free-zine-pdf](https://www.taylorsmithdesigns.co.uk/free-zine-pdf))
says *"the template itself must not be sold commercially, but feel free to
share"* under a footer reading *"© 2025 … All Rights Reserved"*.

That is a permission note, not a licence: no named licence, no version, and
two clauses that disagree with each other. It is the same shape as the NGSL
word list, which this project turned down for the same reason. It is also
37 MB of somebody else's PSD and PDF.

And we do not need it. What a template gives you is the **imposition**, and
that is not a creative work — it is a consequence of folding a sheet in half
three times and cutting the middle. Follow a panel through the fold and the
arrangement falls out. Every zine template in the world shows the same one,
because the paper leaves no choice. So the derivation is written down beside
the table and the suite checks it: each page in exactly one panel, the cover
bottom-right and upright, the top row inverted, and the cut line spanning
the middle two columns **only**. A dashed line the full width would be an
instruction to cut the booklet in half, which is the one mistake that cannot
be undone.

### Two things a printed page does that a screen does not

**Nothing clips.** A dictionary gloss — *"a very large and rather grand
house, in American usage an apartment building"* — set as one line anchored
to the right edge ran clean across the sheet and over the three panels
beside it. SVG does not wrap and does not clip: a line that does not fit
does not get smaller, it escapes. The hint is cut to the column now and the
cut is marked with an ellipsis, so a reader can tell a short gloss from a
trimmed one.

**Japanese has no spaces.** A space-splitting wrap put a whole Japanese
sentence on one line and sent it off the panel the same way. The wrap
measures in **columns** (a kana is two), breaks at a space where there is one
and between characters where there is not, and keeps the one typographic
rule worth keeping — kinsoku: a line may not *begin* with closing
punctuation, or a sentence breaks before its own full stop and the next line
opens with a lone 。

English still does not break mid-word. A wrap that split
`supercalifragilistic` across two lines without a hyphen would be worse than
one that let it hang over the edge, so a mid-word break requires a wide
character.

### Not TeX, and why

TeX would do this, and it was the obvious fallback for a page with rotation
on it. But SVG already draws the cards and the charts, and turning half the
page over is one attribute:

```xml
<g transform="translate(2970,4200) rotate(180)">
```

A whole toolchain bought for one rotation is a bad trade, and the graphics
requirement for this project has been *"a system call to run an external
program is probably good enough"* from the start.

### The unit, which is the trap

The booklet page is in **twentieths** of a millimetre, not the tenths the
other sheets use, so that a quarter of A4's width is an integer: 74.25 mm is
1,485 units exactly. The cost is that type sizes carried over from the other
sheets mean half what they say, and the first draft of the page was
unreadable at about five point. The sizes are named constants with the point
size in the comment now.

### One size for both scripts was the same mistake again

A single glyph size was used for *either a kana or a kanji*, which is the
terminal's assumption on paper. 18pt renders あ cleanly and closes up the
inside of 語. Mixed-script house styles set CJK **above** the Latin beside it
for exactly this reason: a Latin lowercase letter fills about half the em box
vertically and a third of it across, while a kanji fills the box and then
subdivides it.

Characters are 24pt and kana stay at 18. What paid for it is the layout: the
booklet panel is 74.25 × 105 mm and the plan page holds eight rows at a fixed
pitch of 185 units.

- With the hint **under** the glyph, the pitch has to carry `1.36 × size +
  10`, which is where the old size came from — and it was already two units
  past that limit.
- With the hint **beside** it, the constraint is only `0.88 × size`, so 24pt
  fits with room and the page still holds eight. Going larger costs rows,
  and a plan page showing four items is a different page.

Beside is better for a glyph anyway: kana and characters are both square and
leave the width of the panel empty, which is where the reading goes on every
flashcard ever printed. A **Latin** term keeps its hint underneath, because
that is a word rather than a glyph and the two would collide.

**Kana had to move too, and that is not about kana.** A kana row with its
hint 62 units under the baseline, followed by a character row at 24pt, puts
the character's top *above* that hint: the first render printed `neko` inside
日. A page mixes the two freely, so both go beside.

### SVG rather than a raster, and why determinism was the point

The design specified `gfx_text` over a font atlas drawn headless. No headless
path exists that Pop-11 can drive: the validation script runs a standalone
C++ harness that draws one hard-coded scene, and the Pop-11 graphics surface
needs an initialisation call that opens a window. Turning that into a
renderer langpop can call means new C exports, a build flag and a PPM-to-PNG
step, on Linux only — a graphics-backend change, not a langpop change.

SVG keeps every property the card renderer was asked for and costs none of
that, and it buys one thing a GPU rasterisation cannot: the card suite
renders the same item twice and compares the **bytes**. A rendering
regression becomes a failing diff rather than something somebody notices
months later.

### `pop_status` is the wait status, not the exit code

A child that exits 2 leaves 512 there. Everything else in the tree compares
it with zero, where the two readings agree, and the terminal image writer is
the first caller that has to tell 2 (no image protocol) from 3 (no SVG
converter). A plain false would have made those the same thing and the hint
would have been wrong half the time.

---

## Content tranches

### Written confusions, 2026-10-30

English pre-school could not be finished. Two of its three criteria needed a
voice, so a student with no microphone could not leave the rung however well
they read.

The content for it was already named by the project's owner: *"for English,
the challenge for a Japanese learner will be the difference between words
that sound the same: Presents vs Presence, or words that will be clearly
mispronounced because of katakana sounds."* Twelve `mix/4` rows, asked by
showing one word's Japanese sense and offering both spellings.

The design decision worth recording is what the confusion is **not**. It
would have been easy to make it another channel of the sound contrast that
causes it, and that would have been a false claim: a contrast is measured by
playing a sound, and a reading answer is no evidence of hearing. So the
cause is recorded in the fourth argument and is deliberately not a
`requires` edge. The exit threshold is reading's 0.85 rather than hearing's
0.90, because a choice on a page is an easier question than a sound in the
air.

A `pair/3` is derived from each `mix/4`, so each confusion is audible for
free once a voice exists. The hearing half is documented and not built.

### A1 English, 100 words to 519, 2026-10-31

The rung asked for 500 and held 100.

**The corpus decided nothing.** All 419 new words were curated, then
*attested*: every one appears in the frequency list and in CMUdict, which
mechanically catches a spelling that is archaic, mistyped or invented. All
519 resolved to a pronunciation on the first run. Median rank 983, worst
8,551.

The worst ranks are the argument for keeping selection human. `pencil` is
5,821st in film dialogue, `vegetable` 7,532nd, `insect` 8,551st, and all
three are in every A1 syllabus ever written.

**Nothing from the function-word queue is in it.** Six of those rows need a
decision nobody should make alone — articles as words or as patterns, dummy
`it`, `be` as one item or four rows, `do` and `have` as auxiliaries — and
taking them would have answered those questions by writing content. `back`,
`kind`, `well`, `light` and `glass` were also dropped, for the reason that
queue defers `just`, `like` and `get`: their rank is carried by a sense a
beginner does not want.

The result strengthens the queue's case rather than weakening it. Four
hundred content words bought 5.60% → 13.57% coverage against a B1 line of
95%, and the twenty-one words the gap report ranks highest are every one of
them a row on that page.

Four defects surfaced that only new content could expose: the first-spelling
pronunciation, the forbidden derived edge, the level-exact denominator and
the orphaned forgotten item. Each is above.

Three Japanese glosses collided across the 519 — 店, 時間 and 高い — and are
now 店舗, 1時間 and （位置が）高い. Two items sharing a Japanese gloss give a
learner no way to tell them apart, which is checked rather than asserted.

`s_ts` turned out to be derivable after all: a word-final /ts/ is exactly
the cluster the contrast is about, CMUdict shows it, and `pants` is the word
at A1 that exercises it. The list now covers every contrast a rule can
derive, 10 of 13.

### N5 Japanese, 170 words to 773, 2026-10-31

The rung asked for 800 and the graph held 220 counting pre-school, so
`vocabulary(800, read)` was not merely unfinished — it was unfinishable,
and `ja` never left N5 in any oracle run. 580 more picks were written in
one pass, by theme, the way a first-year course moves through a
vocabulary: the people in the room, the body, what is on the table, what
is outside the window. The ladder now reads 823 words held, 804 askable,
and the criterion is met.

**Resolving the keys is most of the work, and it can be mostly
mechanical.** 133 of the first 500 keys came back ambiguous, which is the
rate the tranche doc predicted. A pick id is `w_<romaji>[_<sense>]`, so
the id already names the reading the curator meant — and matching each
candidate's reading against it settled 124. The nine left over were
loanwords with a second sense (`コート` is a coat or a court, `ボタン` a
button or a peony), which is a judgement, and judgement is what the pick
list is for.

The transliterator used for the matching had a bug worth recording,
because it was the safe kind: it required a kanji field, so every
kana-only entry mis-parsed. Those candidates were therefore *skipped*
rather than matched wrongly, and every affected pick landed in the pile
marked "needs a human". A parser that fails closed is a parser whose
mistakes you find.

### The question was a spelling no beginner should see

JMdict gives コーヒー the kanji headword 珈琲 and とても the headword
迚も. Both are real; both are tagged — `&ateji;` and `&rK;` — and the
importer took the first kanji headword as the written form, which is the
form the question shows. So the tutor was asking beginners to read 珈琲
and filing it as N5 vocabulary.

The tags are the one thing upstream knows about a spelling that we could
not work out: `&rK;` rarely used, `&ateji;` phonetic borrowing, `&oK;`
out-dated, `&iK;` irregular, `&sK;` search-only. `imp_rare_kanji` reads
them, and a word whose every kanji spelling is tagged now has no kanji
form at all — which is the right answer, because コーヒー is written in
katakana and the kana is the whole of its orthography. 何時 went the same
way for いつ, and 呉れる for くれる. 余り keeps its spelling, because only
its second and third headwords are tagged.

This is the same argument as KANJIDIC2's level field: where upstream has
made a judgement, use it, and where it has not, make it here.

### A word written only in kana has no reading question

A reading question holds one form up and asks for another — 山 prompts
and やま answers — so it needs two forms, and a kana-only word has one.
With the spelling fix above there were 61 of them, and they were silently
dropped from the measurement: `--audit` counts **askable** questions, so
the criterion read `801 have, 740 askable, short by 60`. A word list long
enough on paper was still short in the lesson.

About fifty of those are katakana loanwords, and for them the kana *is*
the exercise. Reading コーヒー as koohii is what the katakana half of
pre-school teaches and what a learner has to do with a word they
half-recognise: the long vowel, the ー and the small ッ are exactly where
it goes wrong. So `lp_question` gained a loanword branch — prompt the
katakana, accept the romaji — with the prompt spelling dropped from the
accepted answers, since a question whose answer is its own prompt asks
nothing. Askable went from 740 to 782.

The remaining nineteen are kana-only expressions: はい, いいえ,
こんにちは, さようなら, とても, もう, いつ, くれる. **They are
deliberately left unasked.** By N5 the student has hiragana, so prompting
とても and accepting `totemo` is a free mark, and a criterion padded with
free marks measures less than it did before. They stay in the graph
because a beginner's vocabulary without はい and すみません is a worse
vocabulary, and the audit reports `have` and `askable` separately so the
gap is visible — the same shape as the four sound contrasts with no pair.
The honest probe for one of them is a question about *meaning*, and a
meaning question needs a distractor the graph does not yet choose.

The shortfall was then made up with twenty-three words that are honestly
askable, which is the right way round: the criterion pulled the curation
rather than the curation bending the criterion.

The invariant that caught all this is the one written for the
251-unprobeable-item bug — *every item that cannot be typed is a skill, a
pattern or a sound* — and it now reads "or a word written only in kana",
with the allowance asserted narrowly: no kanji, no katakana, no romaji,
and a hiragana form it does have. The original bug had kanji and kana on
every item, so it would still be caught.

### Two picks, one word, and both of them counted

早い and 速い are both はやい. A curator may reasonably expect two items —
the first is *early*, the second is *fast*, and a learner has to be taught
the difference — so this tranche had `w_hayai` for one and `w_hayai_fast`
for the other.

JMdict holds them as **one entry**, 1404975, with two kanji headwords. So
both picks resolved to the same entry, and since the emitter writes the
first headword, the import produced two items with identical forms and an
identical gloss. A student would have met the same question under two
names, and both would have counted toward `vocabulary(800)`.

Nothing caught it. Neither id was taken, so the existing collision check
passed; neither key was ambiguous, so the resolver was happy; and
`imp_verify` reads back what the emitter meant to write, which was exactly
this. It was found by asking a question nothing in the tree asks — *does
any two items share a provenance?* — which is now `imp_shared_entries`,
reported with both ids before anything is written.

The pick is gone rather than half-built. To JMdict this is one word spelled
two ways, and teaching 速い as its own item needs the importer to emit a
word's *second* kanji form, which it does not do. That is a defensible
piece of work and it is not this one.

The guard catches the plainer version too: one word picked twice under two
keys, `jmdict_kanji('山')` and `jmdict('1302680')`, which nothing else
would notice.

### Four geminates the voice test got wrong, and none of them the scorer's

The audio suite came back with four disagreements, all of them katakana:
コップ, ポケット, ベッド, サッカー, each one "the beat is there" and each
one scored `wrong`. A false negative against a student is exactly what
this project does not accept, so the first move was to measure rather
than to adjust anything.

Rendered with the real voice and scored directly, those four come back at
ratios of **1.24 to 1.46** — the same band as the twelve native geminate
words, which run 1.33 to 1.55, against controls at 0.00 to 0.90. The
threshold of 1.1 separates them exactly as documented. Nothing was wrong
with the scorer, the threshold or the mora count.

*That last sentence did not survive a larger word set — see below.*

The fault was in the suite's own fake voice, which decides whether to
hand back a held-beat recording with `grep -q っ` — the **hiragana** small
tsu. Every geminate word in the graph was native vocabulary when that
stub was written; the loanwords brought in words whose beat is the
katakana ッ, so the stub handed each of them the dropped-beat recording
and the chain quite correctly said the beat was missing. It greps for
either script now.

Worth the half hour: the measurement ruled out three plausible culprits
before a line changed, and the one that was actually wrong would not have
been found by reading the failing assertion.

### The two populations overlap, so one threshold cannot separate them

`--voicetest` came back with two disagreements, しゅっぱつ and サッカー, each
one said correctly and each scored `near`. The same discipline as last
time: measure first. But the test printed its measurement only for the
rows it was unhappy about, which is backwards for an instrument whose
whole job is calibration — a verdict that agrees with no margin reads as
`ok`. It prints the measurement for every case now, and that is what made
the rest of this visible.

All thirty-two timed renders, as gap ÷ mean mora:

| | n | range |
|---|---|---|
| the beat as written | 16 | 0.99 – 1.56 |
| the beat dropped | 16 | 0.00 – 1.27 |

**They overlap between 0.99 and 1.27, so no threshold separates them.**
Two mechanisms, both visible in the numbers:

- **A short word inflates the dropped ratio.** きぷ is two morae of 63 ms,
  so an ordinary 80 ms transition is 1.27 of a mora. Deleting a mora
  shortens the word, which shrinks the denominator — the measure is
  contaminated by the thing it is measuring.
- **A long word depresses the held ratio.** しゅっぱつ has the longest mean
  mora here at 172 ms and holds its beat for 170 ms, which is one mora and
  phonetically right, for a ratio of 0.99. The threshold assumed the
  synthesised geminate silence runs longer than the mean mora; that is
  true when the other morae are short and false when they are not.

The calibration this threshold came from was **181 real words** with no
geminate, topping out at 0.90. A learner who drops the beat is not saying
another real word — they are saying きぷ for きっぷ — and that is the
population the scorer actually faces. It was never measured, because the
only renders of it are the ones `--voicetest` makes.

**What was actually dangerous.** The scorer abstained when
`|ratio − 1.1| / 1.1 < 0.15`, a band of 0.935 to 1.265. きぷ, a *dropped*
beat, measures 1.27 — it abstained only because the rounding fell that
way. One millisecond the other side and the test would have reported a
dropped beat CREDITED, which is the one verdict the scorer must never
produce. The symmetric band was carrying three of these: もと and コプ at
1.13 and きぷ at 1.27 are all above 1.1, and all three would be credited
by the threshold alone.

So the single threshold is now two edges, with the band between them
declined rather than guessed: **1.30** credits the beat, below **0.95**
refuses it. Both sit outside both measured populations. On the measured
set the verdicts are identical — the same 14 of 16 held beats credited,
the same 7 abstentions — and きぷ's margin goes from 0.005 to 0.03.

**And the test's own contract was asymmetric.** A dropped beat coming
back `near` was accepted as a safe abstention; a held beat coming back
`near` was a disagreement. Both are abstentions and neither is unsafe:
`near` moves no belief and tells the student so. Only two outcomes are
unsafe — a dropped beat credited, and a held beat marked wrong — and
those are what the test asserts now. Which leaves one way to pass by
doing nothing, so the count of held beats *credited* is asserted too: a
scorer abstaining on more than half of them is safe and useless, and
would otherwise have read as a clean run.

**Nothing in `./langpop test` had an opinion about any of this.** The
audio suite uses a fake voice and a fake scorer, which is what lets it
run on a machine with no sound — and means the bands were covered only by
`--voicetest`, which needs a voice. The scorer now carries a `--selftest`
over every ratio measured here, run from the audio suite where it cannot
be forgotten. Against the old single threshold it fails with five lines,
naming the three credits and the false negative.

### Running without the content was a shell dance with a hole in it

The suites and `--check` both have to pass on a tree where nothing has been
imported, because that is what a fresh clone is. The way to run that was to
move `graph/*/generated/*.pl` aside, run, and move them back. I did that,
and the restore put the three English files into the **Japanese**
directory.

Nothing complained. A generated file that is not where the manifest says it
is cannot be told from one that was never built — the loader skips a
missing generated file deliberately, so an unimported tree loads — and the
item count did not move either, because the English *items* are in the
tracked `graph/en/a1.pl` and those three files carry sounds and attestation.
`--check` reported the same 1,635 items and no violations. What actually
changed was 28 checks in the main suite quietly not running, 614 down to
586.

Two things made that hard to see. The confirmation I ran was
`ls graph/ja/generated/*.pl graph/en/generated/*.pl | wc -l`, which printed
5 — five files in one directory counts as five, and the failing glob went
to stderr. And 28 happened to be exactly the number of checks the journal
tests had just added, so the drop read as though those had stopped running.

So the file-moving is gone. `LANGPOP_NO_CONTENT=1` holds the generated
files back in `lp_load_except`, where the single-file skip already lived,
and the two runs now differ by a switch rather than by the state of the
working tree. It reproduces both figures exactly — 759 items and 521
checks — with nothing moved.

The general shape is worth keeping: **a verification step that mutates the
tree can leave the tree wrong, and the check that it restored correctly is
itself a thing that can be wrong.** A switch has neither failure.

### The save got expensive, and the heap ran out

A nine-thousand-answer run came back with 1,559 violations, all of them
`langpop/answer: internal error` — which is the client's view of a mishap,
and a mishap is a bug. The server's log named it:

```
;;; MISHAP - rom: MEMORY LIMIT (popmemlim) EXCEEDED (using heap space)
;;; DOING : consstring json_generate lp_save lp_m_answer lp_rpc_handle ...
```

Two things compound into that. The graph is resident — 1,635 items with
their forms, glosses and edges once the content is built. And `lp_save`
writes the student's **whole profile on every answer**: `json_generate`
pushes the characters and `consstring` takes them off the stack, so the
cost of a save grows with the journal, and the journal grows with every
answer and is never trimmed, because the reading resets every 28 days and
the record does not.

At about 7,600 journal entries the profile is 450KB and the save fails.
Poplog's default `popmemlim` is 1,500,000 words — about 12MB — which is
simply too small for this program, so it is raised to 24,000,000, about
190MB. Generous for a tutor, and still a guard rather than no limit.

**That was the symptom fixed and not the design.** Writing the whole
profile after every answer is O(n²) in journal length over a session, and
nothing bounds the journal. It had never mattered because no rung held
enough content for a run to get that long: the N5 word list is what made
the climb long enough to reach it. Three options —

- append journal entries to a file of their own instead of rewriting the
  profile, which keeps every entry and makes a save flat;
- save every N answers rather than every one, which risks losing work on
  a crash and is the wrong trade for a tutor;
- trim the journal, which loses the record that the review ladder, the
  day's sheet and the audit all read.

The first is the right one, and it is
[a section of its own](#the-journal-is-a-log-so-it-is-a-file) below: it is
a change to how a student is stored, not anything the N5 words did.

### A2 English, 531 words to 1081, 2026-11-01

A1 reading was finishable and A2 was short by 469, so the rung got 550
hand-written rows: work, travel, health, money, school, the law, and the
verbs and adjectives that describe change rather than things. 185 of the
550 are verbs. `vocabulary(1000, read)` reads **1081 of 1000, all
askable, ok**, and the whole graph is 2185 items.

The rows were built as data and validated before a line of Prolog was
written, which caught three collisions with A1 that would otherwise have
reached the file: `require` glossed 必要とする, which is A1's `need`;
`appreciate` glossed 感謝する, which is A1's `thank`; and `practise`,
which is A1's `practice` in the other spelling. Also thirteen British
spellings — A1 has color, favorite and theater, and a TOEIC candidate
meets American English.

**Two words were already taught, and taught better.** The suite failed on
興奮した: `excited` was written as A2 vocabulary while `graph/en/items.pl`
already holds it as the katakana trap `t_tension`. Looking for others of
the same shape found `service`, held as `t_service`, and that one is
worse than a duplicate. The gloss written for it here was サービス — which
is the exact misunderstanding the trap exists to correct, since a
Japanese サービス is something given free. A plain vocabulary row would
have taught the error the rung below is there to undo. Both rows are
gone.

**And `service` tripped nothing.** The gloss check caught `excited` only
because the two Japanese glosses happened to agree; `service` had a
different gloss and went through clean. Two items of one kind presenting
one English spelling is the same error one field over, so that is checked
now — scoped to the same kind, because across kinds it is deliberate:
`m_rice` drills rice/lice as a written confusion and `e_rice` teaches the
word, and eight pairs do that on purpose.

Two words have no pronunciation: CMUdict has `headache` but not
`toothache` or `stomachache`. They stay, because `read` is the criterion
that matters and works, and the importer now says which items it could
not find — see below.

**What the tranche says about coverage.** `coverage(reading, 0.95)` went
from 519 words and short by 81 to 1071 words and short by 78. Five
hundred and fifty words bought three points, which is the clearest
evidence yet for what `docs/langpop-function-words.md` argues: what is
left of reading coverage is not vocabulary. It is the articles, the
auxiliaries and the prepositions, and no amount of A2 nouns reaches it.

### N4 Japanese, one half counted and the other judged, 2026-11-01

The rung came in two pieces that could hardly have been less alike.

**The kanji needed no curation at all.** KANJIDIC2 carries a `<jlpt>` field
holding the pre-2010 four-level syllabus; old level 3 is the one that became
N4, and counting it gives 181 characters. With N5's 103 that is 284 — which
is exactly the number `graph/ja/ladder.pl` already asked for, because the
count was read off the same field when the ladder was written. One command:

    ./langpop import --source kanjidic --file <dir>/kanjidic2.xml \
         --level n4 --jlpt 3

and `kanji(284, read)` went from *short by 181* to **ok**, 284 of 284
askable.

**The words are an estimate, and 749 of them.** JLPT has published no word
list since 2010 and JMdict carries no level marking, so "which 1500 words
are N4" is a teaching claim a human has to make. With N5's 773 and the fifty
at pre-school the rung now holds 1572 words, 1514 of them askable, against
`vocabulary(1500, read)` — **ok**.

#### What validating the picks as data was worth

1,074 candidates were drafted as a two-column file — id and lookup key — and
checked against JMdict *before any Prolog was written*. The check asked four
things of each row: that the key resolves to exactly one entry, that the
entry's reading is the romaji the id claims, that neither the id nor any
spelling of the word is already in the graph, and that the id is not used
twice. What it found:

| | |
|---|---|
| 276 | words the graph already teaches, by id |
| 49 | words the graph already teaches, under another spelling |
| 90 | ids whose romaji was not the word's reading |
| 75 | keys naming more than one JMdict entry |
| 15 | words whose every kanji spelling upstream tags as rare |
| 7 | forms that are not words at all |

The first two lines are the important ones. 325 of the drafted picks were
words a student may already have beliefs about, and minting a second
identity for one of them would split those beliefs in half with nothing
downstream able to tell. `import.p` refuses that collision too — but it
refuses it at build time, after the file is written and committed, and the
point of checking first is that the file never contains the row.

The reading check earned its place as well: 住宅 is *juutaku* and not
*jutaku*, 掃除機 is *soujiki*, 底面 is *teimen* and not *sokomen*. An id
that misreads its own word is a lie the journal then repeats forever.

Of the 75 ambiguous keys, 69 were resolved to a sequence number by reading
the candidates' glosses and 6 were left out, because 詩 is a headword of
both うた and the poem, 虹 of both the rainbow and 二次 (*second*), and a
curator who guesses at that is worse than one who skips it.

#### An id should not describe grammar

An early draft wrote 連絡 as `w_renraku_suru`. That is a claim about
grammar and not an identity: 連絡 is a noun whichever way it is used, and
する belongs to the pattern layer. Stripping the suffix also showed what it
had been hiding — several of those nouns were already picked at N5, and the
suffix had been concealing the collision from the very check that exists to
catch it.

### Three things the import broke, and none of them the import

The suites were green before the tranche and three of them failed after it.
Every one was a test or a default that had quietly depended on how much
content the graph held.

**`--check` went from seconds to 288 of them.** `violation(cycle(I))`
asked `reaches(I, I)` of every item in the graph, and `reaches/2`
enumerates *paths* rather than reachable nodes — so the cost was items ×
paths-below-an-item × the cost of a `requires/2` lookup, and the import
raised the first and third of those at once. The fix is two guards:
an item on a cycle has an edge out of it and an edge into it, and in a
vocabulary graph almost nothing has both. A word is required by nothing
and a kana requires nothing, so most of the 3,115 starts are excluded and
no cycle is lost. Measured: 288 seconds of CPU before, 28 after, on the
same graph and with the same verdict. It is the arithmetic that was
wrong, not the check.

Both guards are predicates with a cut rather than bare goals, because a
bare `requires(I, _)` leaves a choice point per edge and would report one
cycle once per path into it.

**A voice-test fixture was measuring the vocabulary.** The borderline
scenario renders one 130/90/130 ms wav and asserts that the whole graph's
geminate words come back as abstentions. Whether a 90 ms gap is a dropped
beat depends on the word: against きって's three morae the mora is 117 ms
and the gap is plainly short, against しょうがっこう's six it is 58 ms and
the gap is a *held beat*. N4 brought five words long enough to cross that
line and the fixture reported five disagreements of its own making. So
`lp_vt_only` now lets a caller name one item — the scenario says がっこう,
which is the word its arithmetic was always about — and `--voicetest
<item>` exposes the same switch, because the question a teacher has is
about the one word that sounded wrong.

**Two tests named a level nobody had imported yet.** One asserted that
`n4` has no content stamp; its own comment said the fix for the previous
version "is to name a level nobody is about to" import, and n4's kanji
were imported a week later. It now *finds* a stampless level instead of
naming one, and fails rather than passing vacuously if the ladder ever
runs out of them. The other asserted that N1's kanji shortfall is over
2,000; it fell to 1,946. That check now asserts the arithmetic —
`short_by == wanted - askable` — which is what the field was ever
promising a client.

### The brackets were for the eye, and the voice was reading them

KANJIDIC2 writes a kun reading as `やす.い`, and `imp_kun` turns the dot
into brackets — やす(い) — so that a card can show what the character says
and what the word around it adds. That is display notation, and two
things were reading it as text: the voice, which was handed `(` and `)`
to pronounce, and `lp_morae`, which counts every codepoint that is not
small kana.

The second one is the dangerous one, because the mora count is the
denominator the geminate scorer divides by. 以 reads もっ(て), which
`lp_morae` measured as four morae where もって has three, and at four a
*dropped* beat came back credited: 90 ms of silence against a 68 ms mora
is a ratio of 1.32, over the 1.30 edge that was set two commits earlier
with a 6× margin on the words then in the graph. 以 is the first
character on the ladder whose kun reading holds a geminate, which is why
103 N5 kanji never showed it — and it arrived with old JLPT level 3.

`lp_audio_text` now strips the brackets, which is right for both readers:
やすい is what the mouth says, and three is what もって measures. 115
characters carry a bracketed reading, 85 of them new.

### An unresolved pick is not always a pick

The A2 pronunciation import reported its two misses like this:

```
UNRESOLVED 101: 111(116) matches no entry
UNRESOLVED 101: 111(109) matches no entry
```

Both lines name the same item as far as a reader can tell, and neither
names it. 101 is `e`, 111 is `o`, 116 is `t`, 109 is `m`: `imp_report`
was indexing a Pop-11 **word** as if it were a pick record, and a word
subscripts to character codes. `e_toothache` has `o` at 5 and `t` at 6;
`e_stomachache` has `o` and `m`.

The two paths hand over different things and only one of them is a pick.
The jmdict path reports the pick record — id, key kind, key — because a
curator fixing a key needs to see the key. The cmudict path has no key:
it enriches items the graph already holds, so all it can say is which
item upstream does not know, and what it passes is the bare id. It reads
`UNRESOLVED e_toothache: no entry upstream` now.

Worth noting what kind of bug this is. Nothing was wrong with the import
— the right 548 entries were written and verified back out of the graph
— and nothing downstream was affected. What was broken was the one line
a person has to read in order to act, which is the part of a tool that
has no test unless someone writes one. There is one now.

### The Japanese frequency list cannot attest a word, and it cannot measure coverage

The English tranche was *attested* against hermitdave/FrequencyWords —
curation chooses the words, the corpus confirms they are current English.
The same check was run for Japanese and reported 54.8%, with 僕, 誰, 血,
父 and バス among the words it called absent. Those are not absent from
Japanese, so the check was wrong, and the reason is upstream.

`content/2018/ja/ja_full.txt` holds 34,504 entries over 3,794,284 tokens;
the English file holds 50,000 over 725 million. And it is missing 私, 僕,
君, 俺 and 誰 — the commonest first and second person pronouns and the
word for *who* — **in every spelling, kanji and kana alike**, while
holding 、, 。, あなた, お前 and 彼女. A list that has あなた and not 私
has been filtered somewhere, and the file is the genuine upstream one, so
this is not a download that went wrong.

Two consequences, and both are about not claiming things:

- **The N5 words in this tranche are curated and not corpus-attested**,
  and the pick file says so. The English list's provenance story does not
  transfer, and pretending it did would be worse than having no check.
- **Any Japanese coverage figure derived from this file is unsound**,
  including the 14.6% in the tranche doc and the 35.05% a gap run prints
  today. The `ja` `coverage(reading)` criterion the owner deferred should
  stay deferred, and now there is a concrete reason rather than a
  preference: the denominator is missing its most frequent words.

The Japanese `--gap` report is still useful for what it was built for —
*which characters does a word need that the graph lacks* — because that
part reads the graph rather than the corpus. What it cannot do is rank by
share.

### The Japanese tranche

See [docs/langpop-japanese-tranche.md](docs/langpop-japanese-tranche.md) for
how the rows were argued. Two findings from it generalise.

**Half the keys a curator writes will be ambiguous, by design.** Of 28
candidate picks probed against JMdict, fourteen came back ambiguous — 人
matches four entries, 家 eight, 中 five. The importer refuses each and
prints the candidates with glosses, which means a Japanese tranche cannot be
marked without a pass of sequence numbers.

**The largest single opportunity needed no new words at all.** Pre-school is
the kana level, so all 50 of its words are kana-only by design. But the
corpus writes them in kanji: 行 is 1.18% of all dialogue and it is `w_iku`, a
word the graph has taught since the first commit. 32 of the 50 pre-school
words have a kanji form the corpus uses, and together they are 5.72% of the
corpus — more than everything the graph credited in Japanese at the time. No
new identity, no gloss, no level decision, no key. A spelling.

---

## The journal is a log, so it is a file

What was in the profile was not all of a kind. The beliefs, the review
ladder, the period and the settings are the student's **state**: current
values, revised in place, and all of them bounded by the size of the graph
— there cannot be more beliefs than there are items and channels. The
journal is a **log**: entries are appended in order and never revised, and
it is bounded by nothing at all.

Rewriting a log to add a line to it is the mistake, so the journal now has
a file of its own, `~/.langpop/<student>.journal`, one line per answer,
tab separated, oldest first:

```
hi_a    read    1    right    1240    1762000123456    learn
w_mizu  read    1    near     3010    1762000131002    review
```

Not JSON, because a log is read a line at a time and every field is an
identifier or a number, so there is nothing to quote. A line with more
fields than the reader knows is read for the fields it does know, which is
how the phase was added to an entry that had six. A line with fewer than
six is dropped rather than reported: a log can end in the middle of a
line, because the process writing it can stop in the middle of a line, and
the right thing is to keep the answers that are whole.

**What tells an append from a rewrite.** A flush has to know which entries
are new. A count of what is on disk would be the obvious way and it is
wrong, because `:oops` makes the file one answer longer than the truth.
What is held instead is the journal **pair** that was last written.
`lp_journal` is newest first and every answer conses onto the front, so
the entries added since the last write are exactly those in front of that
pair, and the shared tail means finding it costs one comparison per new
entry. After an undo the marked pair is not in the list at all — the undo
restored the older list, which does not contain it — the walk runs off the
end, and the file is written whole. The pair is doing the work a version
number would do, for free, because a list that shares structure already
records its own history.

**Two students at once.** The server switches the engine's globals per
request, so the mark could have been the wrong thing to keep in a global
of its own. It is not, because `lp_load_profile` builds the journal list
afresh from the file and marks it: whichever student binds next, the mark
names exactly what their file already holds, and their next answer is one
appended line. A switch costs the read it always cost — the profile used
to carry the journal, so the same bytes came off the disk either way.

**Migrating.** A profile written before this holds its answers in a
`journal` field. That profile was written by the version that kept them
there, so it is the later record of the two and a journal file beside it
is stale by construction: the field wins, the mark is left empty, and the
first save writes the file whole and drops the field. Nothing has to be
converted by hand and nothing is lost if a student is opened by the old
version in between.

**What it measured.** Over 25,000 answers, each one recorded and saved:

| answers | record | save | profile | journal file | heap |
|---|---|---|---|---|---|
| 5,000 | 7 µs | 2,524 µs | 126,965 B | 257 KB | 978K words |
| 10,000 | 8 µs | 4,775 µs | 126,965 B | 514 KB | 1,038K |
| 15,000 | 8 µs | 4,830 µs | 126,965 B | 771 KB | 1,149K |
| 20,000 | 7 µs | 4,708 µs | 126,965 B | 1,028 KB | 1,175K |
| 25,000 | 8 µs | 4,854 µs | 126,474 B | 1,286 KB | 1,286K |

The profile is the same size byte for byte from 5,000 answers on, because
by then every item in the graph has a belief and there is nothing left to
add. The rise to 4.8ms and the flat line after it are that filling up and
then being full: the cost is bounded by the graph, which is what the
change was for. For comparison, the journal that was taken out of the
profile cost **10,551 µs and 560,658 bytes to generate at 9,000 entries**,
and both of those numbers were still climbing.

**What still grows.** `lp_journal` is resident, one seven-element vector
per answer, and the heap column above is it — 300,000 words over 25,000
answers. That is now what `popmemlim` is headroom for rather than the
save. It is a long way from mattering: a student answering two hundred
questions a week reaches 25,000 in two and a half years, and a session
only ever loads one student. Reading the journal lazily, or holding only
the current period and the scheduled items, is the next thing if it ever
does.

---

## Poplog behaviours worth knowing

**A declaration with an initialiser runs, so a lazily compiled file resets
whatever it declares.** `--voicetest <item>` was written as `consword(...) ->
lp_vt_only` in langpop.p's argument loop, which is the obvious thing and
silently did nothing: `audio.p` is compiled further down the same procedure,
`vars lp_vt_only = false` there *executes*, and the flag was wiped between
being parsed and being read — `./langpop --voicetest w_gakkou` dutifully
tested all 118 words. The fix is a local, copied across after
`lp_load_audio()`. In a program that compiles its optional halves on demand,
an argument may only touch variables that already exist when it is parsed.

**`prolog_compile` has reconsult semantics per predicate.** A second file
that defines `item/5` silently replaces the clauses the first one gave it,
and `:- dynamic` does not change that. A seven-file graph loaded
file-by-file therefore ends up holding only the last file's items — with no
error. So the loader concatenates the manifest and compiles once.

**There is no `forall/2`** — not in `pop/plog/lib/`, not in any help file.
`schema.pl` states the idiom once:

```prolog
all_hold(Cond, Action) :- \+ (Cond, \+ Action).
```

**A call to an undefined predicate fails** rather than raising, which is how
the missing `forall/2` hid: the rule using it simply never succeeded, and a
level with nothing ready in it looks like a data problem. This is
configurable and the default is the trap, so `schema.pl` opens with the two
lines that turn it off:

```prolog
:- library(unknown).
:- unknown(_, error).
```

See `PLOGHELP UNKNOWN` — `fail` (the default), `error`, `autoload`, `debug`.
Every graph file is loaded together, so nothing in this graph is legitimately
undefined, and a misspelled predicate now raises.

**A cycle check needs a visited list.** Without one, a two-item cycle has
infinitely many proofs and the check exhausts `pop_prolog_lim` instead of
reporting the cycle, so `reaches/2` carries the path it has walked.

**Prolog quoted atoms deref to Pop-11 words, never to strings.** So a test
comparing an atom from the graph against a string literal fails; both sides
need `sys_>< ''`.

**`==` on floats is identity**, which is what hid the chooser's tie-break
for the whole of the project's history. See above.

### Editing the file a Poplog program is running from

Worth its own section, because it cost a session and the trace it leaves
blames the wrong thing.

Poplog compiles a `.p` file incrementally: it reads, compiles and runs as it
goes. So by the time the last statement of `langpop.p` —

```pop11
unless isdefined("langpop_lib") then lp_main() endunless;
```

— is executing, the whole tutoring session is running *inside* the compiler's
read of the file, which is still open at a byte offset. Rewrite the file
while that session is up, and when `lp_main` returns the reader resumes **at
its old offset in the new text**. Whatever happens to be there is compiled as
Pop-11.

The resulting trace reads as though the tutor crashed on the way out:

```
また今度。
;;; DECLARING VARIABLE bad
;;; FILE : .../langpop.p   LINE NUMBER: 12482
;;; DOING : Comp_expr_seq trycompile
;;; MISHAP - NUMBER(S) NEEDED ... Arith_> > trycompile
```

**The impossible line number is the tell.** `langpop.p` is about 4,300
lines; a mishap reported past that is not a mishap in the program, it is the
reader somewhere in a file that changed underneath it. A segmentation fault
in the compiler can follow, which looks far worse than it is.

The window closes by not returning at all: all three front ends `sysexit()`
after their main rather than letting control fall back to the reader. Nothing
was ever at risk in the student's profile either way — the save runs *before*
the signoff, not after it.

### One trap inside the library probe

`syslibcompile` must be handed `popuseslist` explicitly, because its
one-argument form searches the autoload list, which does not include
`pop/lib/lib`. It would answer false for a library that `uses` finds without
complaint.

---

## Three things found in the Poplog tree

Building langpop turned these up, and none of them is langpop's to carry.

**No font was loaded by either ImGui backend** — so `gfx_text` took UTF-8 and
drew Japanese as blank space, with no error. Both backends went
`CreateContext()` → renderer init, leaving ImGui's built-in ASCII atlas in
place. Fixed: `pop/extern/lib/imgui_font.cpp` loads a CJK-capable face
(`tools/fetch-gfx-font.sh` pins Noto Sans JP, SIL OFL 1.1, by commit and
sha256; the OS's own font is the fallback), `gfx_font()` reports which file,
and `make gfx-font-test` asserts both halves without needing a display. See
`docs/bugs/imgui-atlas-ascii-only.md`.

**A millisecond wall clock was there all along.** `lp_now_ms()` was first
written against `sys_real_time()` — whole seconds — having concluded from
`HELP CLOCK` that nothing finer existed. `REF TIMES` has `sys_microtime()`,
which is microseconds of real time, and HELP CLOCK never mentioned it. Fixed
in the help file, with three checks in `test_datetime.p` holding the
real-versus-CPU distinction down. langpop uses it, and the latency criteria
mean what they say.

**Twelve words were honoured as interactive commands while a file was being
consulted**, not just at the Prolog prompt: `ved help teach ref showlib im
source cd pwd pop11 bye`. A data file containing `help(a).` did not define
`help/1` — it tried to open a HELP file and said `;;; HELP (A). not found`,
with no hint that a clause had been swallowed. `source/2` as a provenance
relation made the graph fail to load with an error naming a goal the file
does not contain. Fixed in `pop/plog/src/prolog_compile.p` — commands now
apply only in query mode — with the first test suite for the Prolog subsystem
in this fork, `tools/tests/test_prolog_consult.p`. See
`docs/bugs/prolog-commands-swallow-clauses.md`. The relation here is still
called `provenance/2`, which reads better anyway.

---

## What the protocol front end cost

Three changes to the engine, and two of them were bugs the single-process
front end had and nobody had noticed.

**Assignments were written to the profile and never read back**, so a student
who was given work on Monday was told "No assignment 1." on Tuesday — the
entire assignment model, broken in the one place a local terminal session
never looks.

**`lp_measure` returned Pop-11 ratios rather than floats**, which compare
equal to the float they denote, so the tests passed, and cannot be serialised
at all.

The third was a data-directory override, so the suite can write profiles
somewhere other than a real person's home.

One more came out of the server being long-lived. `lp_load_profile` cleared
the journal, the assignments and the refused guesses *after* its early
return, so a failed load left the previous student's behind. In a one-shot
terminal session that never showed; a server serves whoever asks, so binding
to a student who does not exist used to leave the last one's work sitting in
the globals. Beliefs were never at risk — the belief key includes the student
— but the rest was.

### The one clock the client is allowed to hold

The protocol gives the server the stopwatch on purpose: `langpop/next`
starts it, `langpop/answer` stops it, and the reply says `latency_source:
"server"` so a client cannot quietly become the authority on how fast a
student answered. Every pre-school exit criterion has a millisecond budget,
and a budget measured by the thing being measured is not a budget.

Adding a session timer meant deciding whether that line had just been
crossed, and it had not, because there are two clocks and they answer
different questions. *How long did that answer take* is evidence about an
item, is written to the journal, and decides whether a rung is passed — the
server's. *How long have I been sitting here* is evidence about nothing, is
sent nowhere, and the server cannot answer it even in principle: it knows
when the session was opened, and not whether the person is still in the
chair. A client that cannot tell a student they have been at it for forty
minutes is not protecting anything.

So the clock starts at the greeting rather than at connect — the minutes
spent typing a name are not study — and the elapsed time sits in the prompt,
because a student who has to ask what time it is has already lost track of
it.

One thing it is allowed to be opinionated about. `:status` already prints a
sitting length, from the server's own consistency report: *a suggestion: 20
minutes a day would keep up with it*. Having asked for twenty minutes it
would be strange not to notice the twentieth, so the client keeps the figure
when it sees it and says so on reaching it — once, because a nudge on every
answer afterwards is a nag, and the student is being told something they
were just told. It does not invent a target, and until `:status` has been
asked it has none.

The suite is the first one `client.p` has ever had, and it tests the three
things in the client that are not a printf of something the server said: the
duration formatting, the pace arithmetic, and that the nudge fires once.
A clock that renders nine minutes five seconds as `9:5` is wrong in a way no
server test can see.

### Mr Hill asking for hiragana

`./langpop --lang en --user dkords` loaded the English teacher and then
taught Japanese. Two halves of one decision were read from two different
places: `lp_main` chose the persona from the flag, and `lp_load_profile`
restored `lp_lang` from the file a few lines later, unconditionally. Neither
was wrong on its own, and nothing compared them.

The rule that was missing is which one speaks for the student. A flag is an
instruction — somebody typed it this morning — and a stored language is a
default, which is what makes it useful when no flag is given. So
`lp_lang_asked` records *whether the language was asked for*, and the profile
only restores a language nobody asked about. The same flag now drives the
protocol: `langpop/register` sets the language before reading the profile
rather than after, which also fixed the quieter half of the bug, where a
returning student's `language` parameter was ignored altogether.

That change forced a second one out into the open. The level was a single
field, and a level is only meaningful against a ladder: a student at N5 in
Japanese is not at N5 in English, where there is no such rung. Honouring the
flag without touching the level would have started an English session "at
n5", which nothing can ask a question at and which `--audit` would have
reported as a rung with no content. So the profile now holds a rung per
language, `levels: {ja: n5, en: a2}`, with the old single `level` still
written for a build that reads only that, and read as belonging to the
language stored beside it. Each language resumes where it was left; a
language never studied starts at the bottom of its own ladder; and a stored
rung that is not on the ladder at all — a hand-edited profile, or one written
against a different ladder — starts at the bottom rather than binding a
student to a level nothing can be asked at.

The switch is announced, which is the part that is a judgment rather than a
fix. A student who typed the wrong flag should find out in the greeting
rather than four questions later, and what they most need to hear is that
nothing was lost:

```
dk, is it not?  Level a2.
  (en this session, as you asked.  n5 is where you
  were in ja, and it is kept.)
```

#### The same bug, one setting down

The rule is worth more than the fix, because looking for the rest of it found
`--rate`. It was set in `lp_main` before the profile was read, and
`lp_load_profile` put the stored rate back over it, so a student who had ever
chosen a listening speed could not ask for a different one from the command
line. Quieter than Mr Hill asking for hiragana — nobody would file it, they
would just type `:rate slow` again — and the same defect, fixed the same way
with `lp_rate_asked`.

Anything that is both a stored preference and a command-line argument needs
the pair: the value, and whether it was asked for. A single variable cannot
hold both answers, and the one it loses is always the one the student typed
most recently.

And the client now sends a language only when it was given one. It used to
default to `'ja'` and send that on every connect, which under the new rule
would have been an instruction — flipping a returning English student back to
Japanese every time they started the client. A default is not an instruction,
and a protocol cannot tell the two apart unless the caller declines to send
one.

### The cover line was sized for the wrong language

`がんばって` is five characters. `you can do this` is fifteen. Both were set at
215 units because the size had been chosen against the Japanese — there is
even a comment saying so, *sized to the PANEL, not to taste: five kana at 290
units each overran 1485* — and the English ran from −64 to 1548 across a
1485-wide panel, out through the cover frame on both sides.

What let it through is the shape of the test. `sheet_maxy` walks every `y="`
in the SVG and checks nothing is drawn below the page, and it had been
checking the English booklet for a month. There was no `sheet_maxx`, and the
one piece of type on the one page that is nothing but type was off the sheet
horizontally while sitting comfortably on it vertically.

The fix is not a smaller number. Shrinking to one line that fits gives 166
units, a third smaller than the Japanese cover's, on a page whose whole job
is to carry a line of type. So the motto **wraps first and shrinks only if
wrapping is not enough**: two lines at full size beat one line of small type,
and the Japanese — which fits on one line at 215 — comes out byte for byte
what it was. Below `Z_TITLE` it stops shrinking and takes a third line
instead, because cover type that kept shrinking would end up the size of the
body text, and there is a thousand units of empty page between the name above
and the level below for a line to go into.

The measurement was already in the file. `zine_cw` answers "how much room
does this character take" — 2 for an ideograph, 1 for everything else —
because the prose wrapper needs it, so a column is half an em and
`zine_width` is a sum. It is approximate for Latin, where `i` and `m` are not
the same width, and the error is on the safe side: half an em is a wide
average for lower-case sans.

#### The check that was missing, written as the general one

`zine_overrun` parses a page's `<text>` elements and measures each against the
panel, and the suite runs it over all eight pages in both languages. A page
builder's output is in panel coordinates — `zine_place` is what moves it to a
corner of the sheet — so each one measures on its own without following a
transform.

It cannot catch an error in `zine_width` itself, since the fitting uses the
same estimate. What it catches is type sized for one language and set in the
other, which is the thing that happened, and the thing that will happen again
the next time a string in `ZINE_WORDS` is translated.

### The kanji column, and the one rung the source could not answer

Filling N3, N2 and N1 took three commands and one decision.

Two of the three are rules. `<jlpt>` is the pre-2010 four-level syllabus, and
its per-level counts sum to the ladder's cumulative numbers exactly: 103,
+181 = 284, +739 = 1023, +1207 = 2230. Nothing was fitted to make that true —
`graph/ja/ladder.pl` took its counts from the published syllabus and the
import reads the same field — so old level 1 imported at N1 finishes
`kanji(2230, read)` to the character, the way N5 and N4 did.

N3 is the rung inserted in 2010 with no old level of its own, and
`provenance(exit(ja, n3, kanji(_, _), _, _), estimate(community))` has said so
since the ladder was written. 650 cumulative minus the 284 already taught
leaves 366 of old level 2's 739 characters to be chosen, and no upstream field
chooses them. The argument is in [docs/langpop-n3-kanji.md](docs/langpop-n3-kanji.md);
the short version is that the two available rules disagree about 118
characters, and the disagreement has a shape:

| | |
| --- | --- |
| by grade, then frequency | 雪 雲 湖 湯 酒 船 歯 鼻 血 衣 箱 笑 泣 泳 焼 皿 祭 … |
| by frequency alone | 党 劇 券 貿 販 警 蔵 脳 療 禁 歳 殺 権 批 論 識 賞 … |

`<freq>` is a *newspaper* rank. Its top of old level 2 reads 政議連対部党内相定選,
which is honestly what a Japanese newspaper uses most and is not what a
learner at the bridge level meets. `<grade>` is the year of Japanese school
in which a character is taught — a published curriculum, written by people
answering the same question about the same characters with better standing
than a corpus. So: all of grades 1 to 4, then the most frequent of grade 5
until the count is met, with frequency breaking ties only inside the one
school year where the syllabus is silent.

#### A decision belongs in the data, not only in the prose

```prolog
item(k_96ea, grapheme, ja, n3, kanjidic2(ucs('96ea'), jlpt(2), split(grade_freq, 366))).
```

`jlpt(2)` is a fact about upstream. `split(grade_freq, 366)` is this file's
judgment sitting next to it, and it is on both halves of the split because
one decision made both. The split is `--order`/`--take`/`--skip` rather than a
checked-in list, so disagreeing with it is one command and not a diff.

#### Four tests, and all four were asserting that content was missing

The import raised four failures and none of them was in the import — the
fourth time this has happened, and by now the pattern is specific enough to
name. Every one asserted the *absence* of content:

- `N1 kanji is short` (twice, once in the engine suite and once over the
  protocol) chose that criterion precisely because it was reliably empty. One
  of them already carried a comment explaining that counts shrink as content
  arrives; the comment was right and the row it was attached to was not.
- `誕 is not an N5 kanji, so nothing requires it` named a character for being
  absent. 誕 is old level 2 and arrived with N3, at which point the check
  asserted the opposite of the rule two lines above it.
- the dump suite's `popmemlim` has now been raised twice by a content import,
  which is the price of holding whole exports in memory to read them back,
  and still cheaper than not reading them back.

A test that names a thing for being missing has a shelf life ending on the day
the project succeeds at its stated goal. The repair in each case was to assert
the property over whatever is short, absent or thin *now* — plus, where it was
cheap, the complementary case, because "short means it holds fewer than it
wanted" and "ok means it holds at least what it wanted" together say the
comparison runs the right way round, and one row cannot.

`--check` went from 28 seconds to 61 on the way, which is the cycle guard's own
comment holding: what the cost grows with is the roll-ups and the characters
rather than the vocabulary, and the characters just went up sevenfold.

### A gloss can mention a thing; only an item can ask about it

The function-word queue had sat since 2026-10-26 with six rows reserved
for a decision the page would not make alone. Four of those six -- the two
articles, `do` and `have` -- all posed the same question in different
clothes: *this word does a grammatical job that Japanese does with
something other than a word. Where does that go?*

The cheap answer is the gloss. `do` is `する`, and a parenthesis saying
*also makes a question* costs nothing. The expensive answer is a second
item. What decided it is that **a gloss is never asked about.** A learner
reads it once beside the word, nothing records whether they took it in,
and no criterion is moved by it. A `pattern` item has a belief, a review
interval and a question, so the thing can be got wrong, which is the only
way the tutor learns that it has not landed.

So the division came out as: the word, where it is a translation; a
pattern, where it is a job. `the` and `a` went in as words anyway,
because the alternative was to leave 5.14 points of reading coverage on
the floor for a channel that cannot collect it -- and their contrast
followed as patterns regardless. Nothing is glossed as doing two things.

#### The coverage figure is why the articles are words at all

A pattern is on the `produce` channel alone, and `coverage(reading, _)`
counts what can be read. So every pattern written here moved the coverage
figure by exactly nothing, and `vocabulary(1000, read)` at A2 still reads
1117 with four more items in the graph.

That is a property worth a test rather than a footnote. A vocabulary
count that could be satisfied by writing grammar frames would be
measuring the curator's output instead of the student's reading, and the
two are the same number only by accident.

#### Two frames, one fact

The article contrast is two items and not one. A learner who can fill
`I need ___ book` has shown nothing about `___ book is here`, because
each blank has a defensible wrong answer that the other frame rules out.
The pair differ in exactly one thing -- whether the speaker and the
listener already share the book -- and they deliberately do not require
each other, since neither is a prerequisite for the other. `no` and `not`
sit adjacent in `a1.pl` for the same reason.

### The newspaper knew the word; the subtitles knew the speaker

N3 Japanese is the first rung too big to pick a word at a time. 2,236 words
is not an afternoon's judgment, and a judgment made four thousand times is
not the same judgment at the end as at the start, so the rung needed a rule.

Both corpora were already in the tree. JMdict carries priority marks, and
the `nf` bands among them are the Mainichi Shimbun frequency corpus in
blocks of 500 -- a published ranking, which is exactly the kind of thing
this project prefers to its own opinion. So the first pool was ordered by
them, and its opening three hundred words were 議員, 当局, 外相, 安保,
地検, 議席, 税制, 支局, 書記, 五輪, 日米, 連立, 比例, 定数.

That is Diet reporting. Every word in it is genuinely common and the ranking
is not wrong about anything; it is answering a question nobody asked. The
words a bridge-level learner needs -- 友人, 父親, 母親, 理解, 人生, 夕食 --
were reaching the list only where the *other* corpus happened to rescue
them.

Reordering by the dialogue list (OpenSubtitles, the same file the English
side uses for coverage) put those six in the first twenty and pushed the
Diet down where it belongs. The newspaper marks did not stop being useful;
they stopped being the order. They are the **gate** -- a word upstream does
not mark common at all never enters the pool -- and that is the division the
rung turned out to need: *the newspaper knows the word exists, the subtitles
know that a person says it, and a bridge-level word is one both of them
use.*

The same shape as the N3 kanji rule one decision earlier, where school grade
was the curriculum and `<freq>` was the newspaper. Twice now, when two
sources disagreed, the right move was not to pick the better source but to
ask what each one is actually a measurement *of*.

#### A filter that matches nothing looks exactly like a filter with nothing to reject

The pool's mechanical filters are written against JMdict's abbreviations:
skip `arch`, `vulg`, `uk`; skip an entry whose senses are all `exp` or
`ctr`; treat `v1` and `adj-i` as verbs. None of them fired, and nothing said
so.

ElementTree **expands the DTD entities**. `<pos>&v1;</pos>` arrives as the
text `Ichidan verb`, `&uk;` as `usually written using kana alone`, and every
test against the short form compares a long string to a two-letter one and
quietly says no. The pool looked plausible the whole time -- 10,149
candidates, correctly ranked -- because the filters that *did* work were
doing the visible work, and the ones that did not were only supposed to
remove things.

That is the failure mode worth remembering: a filter that silently matches
nothing is indistinguishable, from the outside, from a filter that found
nothing to remove. It was caught by a counter ticket in the output -- 出来
and 面白 still at the top after a rule that should have removed both --
rather than by any error.

The fix is in the file's own header: JMdict ships its DTD inline, so the
expansion is reversible, and `abbr()` maps the long text back. 10,149
candidates became 8,437 the moment the entity table was read: 1,712 words
the pool had been offering that its own rules had always meant to refuse.
The single tag doing the most of that work is `uk` -- *usually written using
kana alone* -- which is the one removal that was never a matter of taste,
since a word nobody writes in kanji has no reading question to ask.

#### 人間らしい is not a stem of 人間

The stem rule is the one piece of linguistics in the pool builder, and it
earned its place: the dialogue list counts surface forms, so every 出来る
was counted as 出来 and every 面白い as 面白, and both arrive at the very top
of a frequency ranking carrying a verb's weight. A stem is not a word to
teach. The verb is.

The first version of the rule was: reject the headword if any verb or
adjective's headword begins with it. It threw out 人間, 女性, 理解 and
several hundred others, because 人間らしい begins with 人間, 女性らしい with
女性, and 理解しがたい with 理解. The rule had quietly become *reject any
noun some adjective is built on*, which is most nouns.

What makes 出来 a stem of 出来る and 人間 not a stem of 人間らしい is the
**size of the extension**: one verb ending, not a word. So the test is now
`vk[len(keb):] in TAILS`, with `TAILS` the sixteen okurigana a verb or an
adjective can end in, and the reading has to extend by the same characters.
30 stems still got through it, every one with an ending that is not a verb
ending -- 教え, 始まり, 動き, 読み -- and those were thrown out by hand, one
line each, with the verb named in the reason.

#### The graph's own inventory is the only honest one

The pool excludes any word the graph already teaches, because minting a
second id for a word a student has beliefs about splits those beliefs in
half and nothing downstream can tell. The first draft of that check read
the `form/3` facts out of `graph/ja/**/*.pl` with a regular expression, and
学校 came back as the sixth most important word the rung was missing.

`w_gakkou` has been an item since the first week. It is not written as
`item/5` and `form/3`; it comes out of `starter/4` and `starter_kanji/2`
rules in `items.pl`, which is how all fifty pre-school starters are
written. A text scan of the source sees none of them. A second bug was in
the same two lines -- the generated files put several facts on one line, and
`re.match` only ever returned the first.

The fix is to ask the graph rather than read it: `./langpop dump --lang ja`
prints every item with its forms and its level, derived rules included, and
the pool builder reads that. Which also means the kanji-availability filter
gets its 650 characters from the same place, so it cannot disagree with the
import that produced them.

#### The audit got 6.6 times slower for 1.48 times the graph

`./langpop --check` was 28 seconds before the kanji column, 61 after it, and
402 after these 2,464 words. Items went 5,101 to 7,565. A factor of 1.48 in
the data for a factor of 6.6 in the time is the signature of something
quadratic, not something merely large -- the same smell as the `reaches/2`
blow-up, which the cycle guard's own comment predicted would come back.

It is recorded rather than fixed, which is a deliberate choice and not a
happy one: the import is correct, the audit's answer is correct, and
guessing at a Prolog goal's cost without measuring it is how the 288-second
version got written in the first place.

#### Measured, and it was three clauses

**`--check` is 5.6 seconds now, where it was 402.** Not an optimisation
pass: one profile, and then the three lines it pointed at.

The profile was a scratch program that compiled the graph once and then ran
each violation on its own with `systime()` around it. In centiseconds of
CPU — the sum runs a little over the 402 seconds `--check` takes end to
end, because the machine was busier that evening:

```
reaches/2, inside violation(cycle(I))     41973
requires_crosses_language                  1636
requires_from_above                         960
item_without_form                           202
item_without_source                         118
requires_unknown_item                        45
level_not_on_ladder, level_without_exit       0
```

One check is 92% of the report, and the two behind it are the same mistake
in a milder form. **Poplog's Prolog does not index clause heads.** A goal
whose first argument is bound still walks every clause of the predicate, so
`item(Pre, _, L2, _, _)` with `Pre` bound is a scan of all 7,565 item facts
— and `requires_crosses_language` runs it twice for each of 12,505
prerequisite edges. Nothing about that clause looks expensive. It looks
like a definition, which is what it is; it was being executed as a search.

The fix for those two is to give the check its own tables. `check(graph)`'s
first goal now builds three of them in one pass each — an item's language,
an item's level, the edges both ways — and the clauses ask those. What they
*say* is unchanged. 26 seconds became nothing measurable.

`reaches/2` was not a lookup problem. It answered *is this item on a cycle*
by enumerating every distinct ROUTE below the item, and the N3 words
multiplied the routes: 780 items survived the guards, and under each one
the same forty-six kana were reached again by thousands of different paths,
each step of each path scanning all 12,505 requires facts. Its own comment
had recorded the first version of this — 288 seconds down to 28, by
pruning the leaves — and said what the cost now grows with. Guarding a
wrong algorithm buys a rung or two of content. It does not stop the thing
from being exponential in the branching, and the graph will keep growing.

A cycle is a question about NODES. `lp_ck_reaches_self` walks the same
edges with one visited set for the whole search, which makes it linear in
the edges below the item rather than exponential in its branching, because
a node already seen cannot lead anywhere new. 414 seconds became 0.02.

The part worth keeping: **the guards were what made it survivable, and that
is why it came back bigger.** Pruning the leaves in October took the report
from five minutes to half a minute and the question stopped being asked. A
constant factor on a wrong algorithm reads exactly like a fix until the
data grows.

And the tables are rebuilt on every call rather than shared with
`lp_index`, which is not an accident: `tests/bad.pl` replaces `item/5`,
`form/3` and `requires/2` under a loaded graph on purpose, and a check
reading a cache built before that would be reporting on the graph that is
gone — the vacuous-test failure of the day before, one layer down. The
broken graph still produces all seven violations, which is the only proof
that any of this still checks anything.

#### A margin that absorbs exactly four items

The day the N3 words went in, the audit said 4,038 words have and 3,976
askable, and I wrote in `docs/langpop-n3-vocabulary.md` that four of the
2,466 picks are not askable for `read`, *which is what the margin is for*.
The margin is real and the sentence was true. It was also a bug describing
itself, and I filed it as an accounting note.

The four were 味方, 無茶, 心地 and 日和. JMdict tags all four `ateji` --
kanji chosen for sound and not for sense — and `import.p` has refused since
N5 to teach a tagged spelling, which is the rule that keeps 珈琲 off a
beginner's コーヒー card. So the importer emitted no kanji form, and four
Japanese words arrived written in kana at the one rung whose entire
selection rule is *written in kanji the student already has*. A reading
question holds one form up and asks for another. With one form there is no
question, and nothing in the project said that a kana-only N3 word is a
contradiction in terms.

`tools/draft-picks.py` had a filter for exactly those tags, from the first
draft. It compared JMdict's short codes to text ElementTree had already
expanded — `&ateji;` arrives as `ateji (phonetic) reading` — and so
matched nothing, which is the third time that one bug has been found in this
file. The first two were caught by a word that should not have survived.
This one was caught by a number I had explained.

Fixing it moved the hand-reviewed boundary by four rows, which is the part
worth saying out loud: the pool is a ranking, the review went 2,800 deep,
and removing four candidates pulls four more in at the bottom. 初回, 格安
and 自伝 are picks and 有線 is a reject (telecoms), and バラ色, which was
in the window all along, is a reject too — its kanji spelling is 薔薇色 and
this rung does not teach 薔 or 薇, so the headword JMdict leads with is
バラ色 and there is no reading exercise in it either. 2,464 picks, 336
rejections, and the two together still account for every one of the 2,800
rows that was read.

#### A test that could not have failed

Writing the check that would have caught those four turned up a second one
of the same shape, in the test suite rather than the pool. `no two English
items of one kind share a spelling` has been green since A2. It builds its
key by concatenating the spelling, a slash and the kind — a fresh string
every iteration — and a Pop-11 property compares keys with `==`. Equal
strings are not the same string. Every lookup missed, every iteration stored
a key nothing would ever find again, and the check would have stayed green
if every English word in the graph had been spelled `service`.

`import.p` knows this. It is why its own lookup tables are keyed by words,
and its comment says so in as many words: *a property compares its keys with
== , so two equal strings are two different keys and every single lookup
missed*. That was written about this exact failure, one file over, and did
not reach the test that needed it. Both checks key on `consword` now, and
the new Japanese one — no two words share a kanji spelling, 3,840 forms in
one pass — was written that way from the start.

Each of them also ends with a lookup of a key its own loop has certainly
stored: `people/word` must come back `e_people`, 人間 must come back
`w_ningen`. One line, and it is the difference between a check that found
nothing and a check that cannot find anything.

### N2, and the three things a second rung from the same rule taught

The N3 pool was built to answer one rung. Pointing it at the next one is
the only way to find out which of its rules were rules and which were
coincidences of the rung it was written for. Three turned out to be the
second kind, and each was found by a word going wrong rather than by
reading the code.

#### The corpus itself was the N3 rule, not a component of it

N3's sentence was *a bridge-level word is one that both corpora use*. At N2
that sentence refuses 判断.

Not ranks it low — refuses it. 判断, 批判, 段階 and 背景 are **absent** from
the 34,504-form subtitle list, while 捜査 is at rank 109 with 4,939
occurrences. The list is an excellent record of what people say out loud,
and those four are words people write. N2 is the rung at which a learner
reads editorials, so the gate that made N3 honest would have thrown out
judgment and criticism and kept murder and weapon.

So the newspaper orders this rung and the dialogue count is the tiebreak,
which is N3 reversed. It does not feel like the same rule, and it is: *ask
what each corpus is a measurement of*. Written down once more, because this
is now the third time it has paid — school grade against `<freq>` for the
N3 characters, the newspaper against the subtitles for the N3 words, and now
the subtitles against the newspaper for N2's.

#### A rejection is a judgment, and judgments have to be carried

The pool excludes what the graph HAS. Nothing excluded what a curator had
already looked at and refused, so the N2 pool opened with 出来 as
しゅったい, 今日 as こんにち and 日本 — all three thrown out of N3 by hand
the day before. Reading them again is the small cost. The real one is that a
word refused as a proper noun at one rung and accepted at the next is not a
curriculum, it is two opinions.

Carrying them forward cost one word to learn, and it is a good one.
Keying the carry-forward by id alone silently refused 捜査, because
`w_sousa` had been refused at N3 — as 走査, raster scanning. An id is a
reading, not a word. The reject files now name the headword in a column of
their own, and the key is the pair: a row reading `w_sousa register imaging
technology` does not even tell a reader which そうさ its writer meant.

#### Which word owns an id cannot depend on which rung is being built

Three words read どうし: 同志, 同士 and 同市. The pool marks the second and
third `DUPID` so a curator drops them, and the first one in the ranking
keeps the name. Which means the ranking decides what `w_doushi` is — and
the ranking is now per-rung. Ordered by dialogue the id goes to 同志,
which is a word; ordered by the newspaper it goes to 同市, "the said city",
which is journalese. N3 would have taught one and N2 the other, from the
same name.

The id is settled once, by the dialogue order, at every rung. Not because
dialogue is the better corpus — this rung is evidence it is not — but
because a name has to mean one thing, and the ordering of the rung being
built is the one input that must not reach it.

#### And the arithmetic at the end

2,900 rows read, 724 refused (25%, against N3's 12%, which is the
newspaper's own junk showing up as work), 2,176 picks. 9,741 items.
`exit(ja, n2, vocabulary(6000, read))` is **ok** with 154 askable to spare,
every Japanese reading criterion below N1 is met, and 21 of 40 criteria now
pass. Both test passes green, with one stale assertion fixed: the voice
test said *and with gaps this clear, no abstentions either*, and N2 brought
専門学校 and 高等学校 — at seven morae a dropped beat is a seventh of the
word, which lands inside the scorer's `near` band. The scorer declining is
the band working. What the test asserts now is that nothing is **credited**
wrongly, that declining stays rare, and that a four-mora word is still
decided outright.

### The third corpus, and what it cost to find out it was not the answer

N2 was built by changing corpora. So before reading seven thousand rows for
N1, the thing to do was find the corpus that measures N1 — written,
non-journalistic Japanese — rather than assume the newspaper would stretch.
An hour, and the answer is no, with numbers.

**What was looked at.** Leipzig's collection (CC BY 4.0, and its corpora are
labelled by register, which is exactly the discipline this project wants)
now sits behind a proof-of-work gate aimed at automated clients; that is a
request not to fetch it this way, so it was not fetched. The novel and
non-fiction lists at jiten.moe are CC BY-SA 4.0 and the right register, but
are derived from commercial books, and the licence on a list does not settle
the provenance of the texts under it. What was used is the Wiktionary list
drawn from the August 2022 Japanese Wikipedia dump through the kagome
analyser: CC BY-SA 4.0, the same share-alike the subtitle list already
carries, source text that is itself freely licensed, two pages fetched with
`action=raw`, one regexp to parse, 20,000 entries — and **lemmas rather
than surface forms**, which is the defect that made N3 need a stem rule at
all.

**It is a real register shift.** It ranks every word the subtitle corpus
could not: 判断 823, 批判 1387, 背景 1925, 段階 1941, with 概念, 要素 and
現象 in the 2000s — and it demotes 犯人 from the subtitles' rank 133 to
5134.

**And its own top forty is the apparatus of editing an encyclopedia.**
削除, 一覧, 項目, 執筆, 記載, 閲覧, 目次, 注釈, 掲載, 当該, 履歴 — and
存命 and 生年月日, which are not words so much as infobox fields.

Which is the generalisation worth keeping, now that there are three of
them. Subtitles put drama at the top (殺人, 犯人, 捜査). Newspapers put
journalese at the top (同省, 与野党, 同夜). Wikipedia puts its revision
history at the top. **Every corpus's most frequent words are partly its own
operating manual**, and the hand pass that follows the ranking is not the
price of having chosen badly — it is the price of using any corpus as a
syllabus. The N3 rung paid 12%, N2 paid 25%, and N1 will pay about 45%
whichever of the three leads.

**The arithmetic.** Of the 11,437 rows in the N1 pool the newspaper ranks
10,307 and the Wikipedia list ranks 2,315 — 2,198 of them ranked by both,
and 117 by Wikipedia alone, most of which are place names. Sampled at three
depths, the agreed tier is refused 27%, 43% and 45% of the time: about 1,355
picks out of the 3,846 the rung needs. The remaining 2,491 still come out of
the newspaper tail at 30–65%. Six thousand eight hundred rows against
seven thousand to seven and a half. The second opinion is worth having as a
column a curator can see, because agreement at the top of the pool is a
genuine quality mark; it is not worth an upstream dependency, so the recipe
is written down and nothing was wired in.

**So the constraint was never the corpus.** It is `vocabulary(10000,
read)`, which `graph/ja/ladder.pl` marks `estimate(community)` — the same
mark the other five rungs carry, and the only one of them big enough for the
mark to matter. Ten thousand words asks for most of what a general corpus
holds above the N2 line, specialist tail and all: 6,800 rows read to admit
溶媒 and 砲台 along with 矛盾 and 衝撃. That is a decision about what N1
MEANS, which is the owner's, and it is a better use of an hour than the
first three hundred rows would have been.

### The same lookup, this time in front of the student

`--check` was 402 seconds because a Prolog goal with its first argument
bound still walks every clause of the predicate (finding 24). That was a
report nobody runs twice a day. Measuring the N2 content turned up the same
thing in the one place it is not an inconvenience: **`lp_plan()`, which the
engine calls once per question.**

Per rung, before:

```
ja pre-school  0.02 s        ja N3  1.01 s
ja N5          0.03 s        ja N2  2.79 s
ja N4          0.11 s        en A2  1.25 s
```

A student at N2 waited nearly three seconds for every question, and the
pre-school number is only small because `at_or_below` keeps 199 items in
scope. The cost is (items at or below the student's rung) x (requires
facts), both of which grow with every tranche of content, so this was
always going to arrive: it was 0.3 s before the N3 words and nobody
noticed, and N1 would have made it six.

The goal was `all_hold(requires(I, Pre), gate_ok(S, Pre))` -- for each of
9,741 items, a scan of 12,505 requires facts. The edges are already in a
Pop-11 property that `lp_why` and `lp_infer` read, and an item has two or
three of them. `lp_gates_ok/2` walks that instead and says exactly what the
two clauses of `gate_ok/2` say, in the same order. **2.79 s to 0.01 s, and
flat across every rung** -- which is the part that matters, because flat
means the next tranche does not bring it back.

`gate_ok/2` stays in `schema.pl`. It is still the statement of what "in
place" means, `why/1` still reads it, and the test suite still asserts
through it; what moved is where `ready/4` does the lookup. Both passes
green, with the same check counts as before the change.

The lesson is now three for three, so it is worth stating as a rule for
this engine rather than as three anecdotes: **a Prolog goal whose first
argument is bound is a full scan, so any such goal inside a loop over the
graph is quadratic in the content.** `reaches/2` was one, the three
violation clauses were another, and `ready/4` was the third and the only
one a student could feel. The remaining per-item scans are in `--audit`'s
`skill_leaf/2` and `criterion_item/2`, which run once per criterion rather
than once per item, and the audit is a second and a half.

### The same homework for ever

`assign` is for the work a keyboard cannot check: a minimal pair to listen
to, a sentence pattern to practise. It walked the plan, took the first item
that cannot be drilled here, and handed it over with a resource.

Every time. A reported result caps an item at `TIER2_CAP`, which sits below
`MASTERY` on purpose -- a student saying "18 out of 20" is evidence, not
proof -- so the item stays unmastered, stays in the plan, and is the first
thing the loop finds on the next call. A student who did that work and came
back for more got the same piece of homework, with a new id, for ever.

And the id is the second defect. Each call appended a row to `lp_assigns`,
which is part of the profile, so asking repeatedly grew the student's own
file with rows about one item nobody had asked twice about.

Both the TUI and the protocol handler had their own copy of the loop, and
so their own copy of both defects. `lp_assign_pick` is now the one
selector. It skips what this student has already been given; when
everything assignable has been handed out it returns the oldest still-open
assignment **as itself**, with its own id and nothing appended, because
outstanding work is the right answer to "what should I do away from the
keyboard"; and only when nothing is open is the answer nothing. The
protocol reply gained an `again` field so a client can tell a new
assignment from a reminder, and the TUI and the TUI-over-the-wire client
both say *still open* when it is one.

What it did not need was a way to ask for the *next* one, which is how the
gap was written down when it was first noticed. Asking again is asking for
the next one, once asking again means something.

Two things worth keeping from the hour it took, both Pop-11 rather than
design:

A list literal is **space-separated**. `[{% ... %}, {% ... %}]` is a list
of three things, the middle one being the word `,`, and the first thing
`lp_assigned_for` did with it was subscript it.

And a test must not look for the situation it is about. The first version
asked the plan for assignable items, which depends on the student, on how
much content is built, and -- for the English contrasts, whose gate is
`hear` -- on whether a voice happens to be configured, so it passed in one
context and failed in another for reasons that had nothing to do with
assignments. The version that stands seeds two outstanding rows with old
timestamps, takes whatever the plan will give with newer ones, and then
knows which row is the oldest open one whether the plan gave fourteen items
or none.

### The English pool, and a criterion that cannot be met by writing lists

B1 wants 1,383 more askable English words, so the pool was built the way
the Japanese ones were: the frequency list minus what the graph already
teaches, with the mechanical doubts named in a column rather than left for
a reader to spot.

The diseases are the same three, in a third dialect. Its tokenizer gives
`don`, `hasn`, `isn`, `ve`, `re` -- halves of contractions -- and `bleep`,
`groaning`, `sighs`, which are subtitle stage directions, the corpus's own
operating manual again. Its proper nouns give michael, george, europe,
smith. Its register is film and television, so murderer, evidence,
kidding, goodbye arrive early.

And one that is English's own: the list counts surface forms and the graph
teaches lemmas, so `works`, `needed`, `watching`, `trees` are not new
words. Suffix rules catch most of it. They catch none of `been`, `were`,
`got`, `made`, `thought`, `does`, `done`, or of `him`, `her`, `his`, which
are `he` and `she` one part of speech over -- so there is a named table of
irregulars, and without it the clean half of the pool opened with eleven
rows that were the verbs a learner met at A1.

47,174 candidates; 38,575 with no mechanical doubt against them.

Then the measurement, against the list's own 725 million tokens: what the
graph teaches covers **55.2%** of the corpus -- which is a cross-check,
because the README already claims 55% from the function-word tranche,
arrived at a different way. Adding the first hundred clean candidates
takes it to **65.4%**. The first two hundred, 67.2%. The whole 1,383-word
B1 gap, 71.5%. Two thousand words, 72.4%.

So `coverage(reading, 0.95)` cannot be met by writing word lists. Zipf
decides that, not effort: the last twenty-four points are tens of
thousands of words, and the criterion as written is a target no amount of
curation reaches. That belongs with the other arguable numbers rather than
being quietly worked towards.

And the shape of the curve is the useful part: **the top hundred words are
worth two thirds of what the entire B1 gap is worth.** `just`, `now`,
`well`, `from`, `back`, `really`, `some`, `too`, `more`, `only`,
`because`. Whatever gets written next should start there and not at the
alphabet.

Which leaves one question this stops at rather than answering, because it
is a teaching decision and not a measurement: those words are A1 and A2
by any CEFR list and by frequency, but the gap that needs them is B1's.
Declaring them at B1 would mean an A2 student never meets `because`. The
33 function words already in `a1.pl` are the precedent for putting them
low, and A1 and A2 are both met on their counts, so adding to either
breaks nothing.

## A voice is a command, which is the thing that does not port

The question was how audio survives the client being somewhere else — a
browser, a phone, Windows, Linux — and whether the abstraction belongs on
the client side. It does, and the code already said where the boundary
was, give or take one place where it sat in the wrong spot.

Four couplings to this machine, not one, and they fail differently:

**`audio.conf` names a shell command.** `"cmd": "/usr/bin/say -v Kyoko -r
%r -f %i -o %o"`, with `%i` the text file and `%o` the wav to write. That
is a desktop abstraction all the way down: iOS, Android and the browser
have no shell and no `%o`. This is the one that cannot be fixed by
improving it, and it is the whole finding — **a voice has to be a
capability the client declares, not a command the server reads.**

**`audio.say` returns a path.** Its header defends this well — *"putting a
wav down a JSON-RPC line would make every caller pay for it in base64"* —
but the argument quietly assumes the caller shares the disk. Over a socket
to a phone, bytes are not the expensive option; they are the only one.

**Playback is server-side**, `PLAYERS = [afplay aplay paplay]`. Harmless:
that is the TUI being a thin client over a local server, and the contract
is already *here is a file, you play it*.

**And the one that mattered: askability was a fact about the server's
disk.** `lp_hear_question` refuses unless `lp_audio_path(item, "normal")`
hits the cache, and `lp_can_hear` meant *is a voice configured in this
process*. Put the voice on the client and the server can no longer tell
whether a question is askable — and the criterion, which is this project's
whole evidentiary spine, stops being measurable from the build.

### The split

Separate **can this be asked** from **who makes the sound**.

The first is a property of the graph and it already existed as exactly one
procedure: `lp_audio_text` returns the text, or `no_spoken_form`, or
`has_blank`. That is the entire platform-independent answer to *is there
something to say here*; it simply was not on the wire. It is now, as
`langpop/audio.text`, with the script beside it — because every platform
TTS is configured by something like a BCP-47 tag and the language does not
settle it. `ja` with `kanji` means `SPOKEN_JA` reached its last resort and
the reading was missing.

The second is `capabilities` on `session.open`. `lp_can_hear` now reads
what the client said about itself and falls back to this installation's own
voice when nothing was said.

**Absent is not empty, and that distinction is the design.** Saying
nothing means *do as you did before* — which is what `./langpop`, the
oracle and every caller written before the field existed need, so they are
untouched. `{"audio": {"play": []}}` means *I am here and I have no
speaker*. One `false` cannot carry both, so `lp_client_caps` is `false` for
no claim and a vector `{play, tts, record}` for a claim.

Three places had to be got right, and each is a rule the codebase already
knew:

- the claim lives **on the session**, not in a global, because one server
  serves a browser and a terminal at once;
- it is swapped in by `lp_q_in` beside the queue, and `lp_q_out` does
  **not** write it back — nothing in here may edit what the client said;
- and `lp_rpc_handle` clears it per request, which is the rule
  `lp_lang_asked` already keeps: one caller's claim must not outlive their
  call. Without that line a browser's *no speaker* would still be installed
  when the next request arrived, and the terminal would quietly stop being
  offered listening questions.

### It was already offering a question the client could not ask

`client.p` renders `pick` and prints `prompt` for every other shape. A
listening question's `prompt` is `null` **by design** — there is nothing to
read, that being the question — and its sound arrives in `audio` as a path
the TUI never looks at. So the student would have been shown nothing, typed
something, and been marked wrong.

It has never happened, and the reason is luck of a particular kind:
`lp_hear_plan` asks only about words already mastered by eye, and the one
client that cannot play has no student who has got that far. A probe
against a fresh student confirms it — ten questions, all `read`. But it was
waiting, and the fix is not to teach `client.p` about audio: it is to stop
the server guessing. The TUI declares an empty list of formats and is not
offered the question.

### Client synthesis is not the poor relation

A browser has `SpeechSynthesisUtterance`, iOS has `AVSpeechSynthesizer`,
Android has `TextToSpeech`, Windows has the WinRT synthesiser, Linux has
`spd-say`. **All five ship Japanese.** Not one of them can run `say -v
Kyoko -o %o`. So client-side TTS is the best-covered option on the targets,
not a fallback for the unlucky.

### Where this deliberately stops

A `tts` claim is **carried and not yet trusted**. A listening question
still wants a wav cached here at the normal rate, so a browser that says
日本語 perfectly well is recorded as able to and still not asked. Lifting
that precondition means giving `timing_sensitive` teeth in the same breath:
the mora scorer was calibrated against one render, and a geminate judged
against a voice nobody has heard is a measurement of nothing. **Client TTS
for exposure, server render for measurement** — a one-line policy, and the
field that carries it already existed, marked in `audio.say` as *said, not
enforced*.

The microphone half is a different problem and a privacy decision rather
than a design one. Recording is unavoidably the client's, the phoneme CTC
model will never run in a browser, so bytes have to go **up** — and that
turns *samples are scratch, scored and deleted* into a claim about a
network hop. Not decided here.

## Client-side TTS cannot serve a listening question

Step 2 of the portability work was going to be *askability stops being a
fact about the server's disk*, so a `tts` claim could be trusted and a
browser with its own Japanese voice could be asked to listen. That is
wrong, and the reason is not the one the previous section gave.

**A listening question's stimulus IS its answer.** `lp_hear_question`
turns a `type` question into `listen` and a `pick` into `listen_pick`,
and both ask *what did you hear*. So a client that synthesises the
stimulus has to be told the word it is about to say — which is the answer
to the question it is asking.

`listen_pick` does not escape it either. `lp_pair_question` sends
`[said, other]` as the options and the position of `said` as the answer;
the client already holds both words, and telling it which to speak is
exactly telling it which position is right.

This collides with the first of the three things the protocol keeps on
the server's side: *the answer never leaves*. A protocol that hands over
the answer key is a quiz file, not a tutor. So the limit is **structural
and permanent**, not a calibration problem waiting on a better scorer:

> **A `hear` question requires the server to deliver sound, not text.**

Client TTS is still right for `:say` — exposure, where the student asks
to hear a word they are looking at and already knows. It can never serve
measurement. The earlier note had the right policy line, *client TTS for
exposure, server render for measurement*, but the reason given was
`timing_sensitive` and calibration, which covers only the geminates. The
real reason covers every listening question there is.

So the portable path for `hear` is **delivery**, not synthesis: a `url`
or bytes, so the client plays sound it cannot read. That is a smaller
job than the one that was planned, and the `tts` claim stays carried and
untrusted — now permanently, with a reason, rather than pending.

### What the step turned into instead

The thing actually wrong with askability was not where it lived but what
the report made of it. `--audit` said this:

```
  ja    n5         vocabulary(800, hear)     823   63       short by 737
```

`short` is defined in this file's own legend as **curation: the criterion
works, the content is thin**. For n5 that was false in every particular.
823 words are there, every one of them has kana, and the whole shortfall
is that nobody has run `--audio n5` on this machine. One of those is a
month of reading dictionaries; the other is one command. The report said
the same word about both, and a reader would have gone looking for words
that were already in the graph.

`lp_renderable(item, ch)` answers the question the cache is not part of —
*is there something to say, and would the question build around it once it
was said* — and the audit gains a seventh verdict:

```
  ja    n5         vocabulary(800, hear)     823   63       unrendered by 737
  ja    n1         vocabulary(10000, hear)   6212  98       short by 9902
```

Those two lines differ by one word and that word is the whole difference:
n5 needs a command, n1 needs 3,846 words that do not exist yet. Nothing
was told to distinguish them — `lp_renderable` worked it out from the
graph, which is the test that it means something.

`lp_hear_question` is untouched, and deliberately: it still requires the
wav to be cached, because a student waiting on a model load mid-question
is a tutor that feels broken. The fix was never to relax it.

Three details worth keeping:

- the roll-up ranks `unrendered` **below** `short` and **above**
  `needs_audio`, which is right on both sides. It blocks the rung as
  surely as `short` does — the channel is verifiable, so the engine does
  not excuse the criterion — but it is not a hole in the content.
- `lp_coverage` gained a third mode, and the word has to be tested
  *before* the truth: a word is true in Pop-11, so `if every then` would
  have swallowed `"renderable"` and silently answered the probeable
  question.
- a skill must never become `unrendered`. `mora_count` has no utterance,
  so no amount of rendering reaches it, and there is a check saying so.

## The English voice, and three rungs that stopped being excused

`audio.conf` gained an `en` block — `say -v Samantha`, the same shape as
Kyoko's. Worth saying plainly: **macOS has no regional US voices.** The
en_US set here is Samantha plus novelty voices (Fred, Ralph, Zarvox,
Bells), and Samantha is General American. A West Coast accent is not
something any voice on this machine encodes, and the Premium en_US
downloads (Ava, Allison, Tom) are not regional either. Samantha is the
only serious en_US voice installed, so that is the honest pick for a US
West Coast request, and the thing it gets right — a General American
reference the TOEIC listening section also uses — is the part that
matters for teaching.

1,193 wavs over three rungs: 88 at pre-school, 555 at a1, 550 at a2,
with 4 patterns skipped as `has_blank` and 17 pre-school items with no
spoken form.

And the estimate held. The README costed English at **25.7 KB a word**
from a regression over 40 Samantha renders whose R² was only 0.48 —
openly a mean rather than a model. Measured over all 1,193: **25.9 KB**,
and 30.2 MB against the 29.4 MB predicted. The weak fit did not matter
because only the mean was ever used.

One thing the estimate could not have known: `du` reports **37 MB**, not
30.2. The difference is filesystem block rounding over 1,193 small files,
about 5.8 KB of slack each. For a disk-cost table that is the honest
number to quote, so both belong — 30.2 MB of audio, 37 MB of disk.

What it bought, and this is the part worth the disk:

```
  before                                  after
  en preschool sound_contrasts  needs_audio -- 13 of 13   ok (30 askable)
  en a1  vocabulary(500, hear)  needs_audio               ok (567)
  en a2  vocabulary(1000, hear) needs_audio               ok (1117)
  en b2  coverage(listening)    needs_audio               short by 40
```

**Every `needs_audio` row in the audit is gone** — eight of them. The
twelve English sound contrasts have been unaskable since the day they
were written, and `--audit` said so for just as long; they are now asked
through the pairs the graph already linked. And the three English rungs
that read *"yes — with an audio criterion excused, so partly
unmeasured"* now read **`yes`**, with nothing excused.

`coverage(listening, 0.95)` landing on 55, exactly where
`coverage(reading, 0.95)` sits, is its own small proof: the listening
channel is now as measured as the reading one, and what is left is the
Zipf problem both of them have.

## Sound down the line the client is already on

`audio.fetch` is the portable path for `hear`, and after the last section
it had to be bytes rather than text: a listening question's stimulus is
its answer, so synthesis on the client cannot serve measurement. What was
left was delivery.

**Bytes before a URL, deliberately.** A static file door wants a second
listener, a second port and a second security surface; the JSON-RPC line
is already open and already carries a session. So `audio.fetch` sends
base64 on the existing connection, and an HTTP door becomes an
optimisation for a page that wants to cache sounds across loads rather
than the only way in.

`audio.say`'s header argues against exactly this — *putting a wav down a
JSON-RPC line would make every caller pay for it in base64* — and the
argument is still right about the caller it had in mind. It assumed the
caller shared the disk. Over a socket to a phone a path names nothing and
bytes are not the expensive option but the only one. So both methods
exist and **the client chooses**, which is the `capabilities` principle
again: the server does not guess which door a program on the other end
can walk through.

`lp_m_audio_fetch` calls `lp_m_audio_say` straight through and adds the
bytes. That is the whole implementation, and it is why the two cannot
disagree about rates, caching, or what a missing voice means — and why
every error `audio.say` gives is this method's error with the same code,
which there are four checks asserting rather than taking on trust.

### Three things the implementation turned on

**There is no `fi_>>` in Pop-11.** The first encoder used it throughout
and the failure was a compile error inside a procedure nothing had called
yet, reported as `DOING: datalength lp_base64 trycompile` — which points
at the wrong line entirely. `LIB * MIMENCODE` mixes `>>` with `fi_<<` on
adjacent lines for this reason, which reads like sloppiness and is not.

**`sysopen(path, 0, true, \`A\`)`, where `true` is the org argument** —
Poplog's raw mode (REF * SYSIO). `discin` and `lp_read_file` are text
devices and are not promised to hand back a 0x8b in the middle of a wav
unchanged. The first attempt passed `false` as a fourth argument, which
is an err_char and not a flag, and failed.

**The encoder was written rather than borrowed, for two reasons.**
`LIB * MIMENCODE` writes to a consumer or a file where this wants a
string, and it reads through `discin`, which is the text device the whole
exercise exists to avoid. It also wraps at 72 columns, right for a mail
body and wrong for a JSON string where a newline is an escape sequence
paid for twice.

### Verified against the only authority that counts

`/usr/bin/base64`, not a reimplementation of the same idea:

- RFC 4648's own vectors — the empty string, `f`, `fo`, `foo`, `foob`,
  `fooba`, `foobar`, `any carnal pleasure.` — all seven padding cases;
- a byte of 0xFF and a pair 0xFF 0xFE, which is the top-bit path that raw
  mode exists for;
- five real wavs out of the cache, 77,897 characters, byte-identical;
- and then over a real socket: `w_neko` at 20,300 bytes and `w_gakkou` at
  29,298, each decoding to exactly the file on disk and each matching
  `/usr/bin/base64` character for character.

### Two small decisions worth the comments they have

`path` comes back **`false` and not removed**. A false member and a
missing member are different statements, and this one is a statement:
there is no path for you. That distinction only works because
`jsonrpc_obj` was fixed to put `false` on the wire — a bug found from
this very server, written up in the Poplog tree as
`docs/bugs/jsonrpc-obj-drops-false.md`.

`-32006` is its own code. Too big to hand over *this way* is not invalid
params — the call was well formed — and not unbuilt, because the file
exists. A client that gets it should fall back to `audio.say` if it shares
the filesystem, and otherwise say it cannot carry this one, rather than
retrying the same call. The cap is 2 MB of WAV, roughly fifty words, and
it exists for the case the graph does not control: a voice configured to
say something long. It is tested with a voice that writes three megabytes
of zeros, because this is the one reply whose size is set by a file rather
than by the graph.

## The prompt is not the answer key

TOEIC Part 1 is the one part of that test langpop could not address at
all — not for want of curation, like the passages and the conversations,
but because it needs a photograph to exist. A local image model changes
that: forty seconds on this laptop for a 1024×1024 PNG.

The first image generated here settled the design of everything around
it. The prompt was `"A person walking a dog, realistic photograph"`. It
drew a person walking **two dogs**, one on a leash and one loose.

Nothing is wrong with the picture. It is better than the request — two
dogs with one leashed is a richer Part 1 photo than one dog. But Part 1's
distractors are *precisely* about number, action and state, so an item
keyed from the prompt would have marked the student who counted
correctly as wrong. The second photograph repeated it: asked for two
office workers *"one holding a stack of papers"*, it drew two women both
apparently holding papers.

So the prompt is a **request**, discarded the moment the file exists.
After that the image is the only authority on itself — the same rule the
project already runs on everywhere else, arriving somewhere new.

### The gate found a defect in the first distractor, and it was mine

`tools/mkphoto.py check` puts each statement alone to a vision model that
has not seen the prompt and does not know which answer is wanted. The
expected job is catching a wrong key. The unexpected job turned out to be
the more useful one:

```
WRONG want=False got=True   A woman is walking a dog.
        the model says: The woman is walking multiple dogs, so the
        statement that she is walking a dog (at least one) is accurate.
```

That is correct, and the distractor was mine. A distractor that survives
on a reading of *"at least one"* is a second right answer wearing a
disguise.

The rule that came out of it is sharper than "check the key". On the
office photo the checker insists, twice and in different words, that both
women hold papers, where to a human reader the second woman's hands look
out of frame. One of the two is misreading a 640px JPEG — and **it does
not matter which**. A statement two careful readers cannot agree on is
unfit to be an option whichever way it resolves. *Drop the statement,
never adjudicate it.*

Which also fixes what each mode is for. `describe` is unconstrained and
confabulates — it is the mode that produced the hands. `check` is one
constrained TRUE/FALSE about one statement, and has not yet been wrong
about a count, an absence or a posture. So `describe` drafts and `check`
gates, and neither is an oracle about the world: the gate only ever tests
whether a statement is **plain**.

### Small web-palette GIFs, measured, are the worst option

The natural instinct for "smallest" is a 256-colour GIF. On the dog
photograph, at 640px:

```
JPEG q70       81,297          PNG8, 256 colours    216,469
WebP q80       93,846          GIF, 256 colours     307,318
JPEG q80      106,141
```

Nearly four to one against the palette formats, which is the opposite of
what the instinct predicts. GIF and PNG8 win on *flat-colour* graphics by
replacing a continuous-tone field with an index. A photograph **is** a
continuous-tone field, so quantising spends bytes encoding dither noise
JPEG never represents at all. WebP's edge is real and small, and not
worth a third decoder in every future client.

JPEG, 640px, q80, ~100 KB. Worth noting the master would not have fitted:
2,213,706 bytes is over `AUDIO_FETCH_MAX` by 116 KB, so the very first
image generated failed the cap — which is why resizing is a step in the
tool rather than advice in a README.

### Photographs are kept, where sound is cached

This is where the analogy with audio breaks, and it simplifies the engine
side considerably. A WAV is 25.9 KB, deterministic, and regenerable from
its text forever, so `~/.langpop/audio/` is a cache that can be deleted
without losing anything. A photograph is a one-off — forty seconds, a
human review, and no way to get the same image back from the same prompt.
It has to be kept, so it is committed content under `graph/en/photos/`
beside the JSON recording what was checked against it.

Which means `image.p`, when it exists, has no render command, no rates
and no voice configuration — only *is there a file for this item, and
what are its bytes*. All the generation lives in `tools/`. And a
generated image has no corpus-attribution problem at all: cleaner
provenance than JMdict or OpenSubtitles.

## The see channel, and three things it turned over

`see` is `hear` with one word changed, and building it that way was the
whole point: item kind `photo`, channel `[see]`, `lp_can_see()` gated on
the client's `show` claim exactly as `lp_can_hear()` is gated on `play`,
`lp_see_question` producing `look_pick`, `langpop/image.fetch` carrying
the bytes.

Where it is *not* `hear` matters more. A listening question asks what did
you hear, so its stimulus **is** its answer — which is why client-side
TTS can never serve one. A picture names nothing, and four sentences
about it are still four sentences, so the stimulus can be handed over
freely. Same rule, opposite consequence.

`VERIFIABLE_SEEN` is its own list rather than another entry in
`VERIFIABLE_HEARD`, though the shape is identical, because the two are
separately true: a terminal with a speaker has no canvas, and a silent
browser is the other way round. One list could not say that. For the
same reason `image` is a **sibling** of `audio` in `capabilities` and not
a field inside it, and an early draft got this wrong — it returned early
when `audio` was absent, throwing away an image claim that had arrived
alone. There is a check for that now.

### The encoder did not belong to audio

`lp_read_bytes` and `lp_base64` were written in `audio.p` and have
nothing to do with sound. The `see` channel wants both for exactly the
reason `hear` does — a stimulus the client cannot reach by path has to
travel down the line it is already on — so a photograph reaching into
the audio file for its encoder would have been a lie about the
architecture. They moved to `langpop.p` and both channels call them from
there.

### check(graph) caught the new kind, and the exemption was paid for

Both photographs came back as `item_without_form` the first time the
suite ran, which is correct: a photo has no written form. The easy fix is
to exempt `photo` the way `skill` is exempted. The honest one is to
exempt it *and replace what was lost* — `photo_without_file`,
`photo_without_key` and `photo_short_of_distractors` now demand of a
photo what `form/3` demands of everything else. An item kind that carries
its content outside the graph has to be checked for carrying it, or the
exemption is a hole.

(Four options with exactly one true is what a Part 1 question **is**, so
a photograph short of three checked distractors is not a thin item; it is
a different question with a different guess rate, and the validator says
so.)

### The protocol suite cannot round-trip a photograph

`test_langpop_server.p` is one process talking to itself over a
`sys_socket_pair`: `lp_rpc_handle` writes the whole reply before anything
reads it. A reply over the socket buffer — about 64 KB — blocks the write
for ever, and the suite hangs **with no output at all**, which is a
singularly unhelpful way to fail. `audio.fetch` escapes it only because a
word is 20 KB of WAV; a 106 KB photograph is 141 KB of base64 and does
not.

That is a limit of the harness and not of the method, so the payload
assertions call `lp_m_image_fetch` directly and the error cases still go
over the wire where the framing is what is being tested. The real thing
was verified between two processes on a socket: 106,141 bytes out,
141,524 characters on one line, decoding byte-identical to the file on
disk, `path: false`, and `can_see` answering true/false/true/true across
no claim, no screen, a screen, and a screen with no speaker.

## The menu that offered what the track could not do

`--lang en` printed, on every session start:

```
:chart <script>  hiragana, katakana or youon, on one page
:aids            which helps are on (slip, oops, later,
                 glyph)
```

and `:chart hiragana` then **worked** — it wrote
`~/.langpop/sheets/hiragana.svg` and reported the path, to a student
studying English. `lp_help` was a flat list of `printf` calls with no
condition on it anywhere, and the `:chart` arm of the command dispatch
asked only whether an argument had been supplied.

The fix is one derived question, `lp_has_syllabary()`: does this
language have any item of kind `grapheme`? Not `lp_lang == "ja"`. A
chart is a picture of a set of grapheme items, so that is the honest
test, and it is the same move `lp_place_axes` makes when it builds the
placement axes out of the declared exit criteria instead of a list of
scripts. A language that later arrives with a syllabary gets its chart,
its big-glyph aid and both menu lines back without anything here
changing.

Three things followed from it, and the third is the one worth keeping:

- the two menu lines are printed only where they apply;
- the big glyph drops out of `:aids`, because an aid you cannot use is
  not a choice — and the glyph aid exists to make a fourteen-stroke
  kanji legible in a terminal cell, which English does not have;
- **`:chart` refuses, rather than merely going unadvertised.** Hiding
  the line and leaving the command working is half a fix, and the half
  left over is the half that writes a file. The wording follows
  `lp_show_rate`, which has said `I have no %p voice, so there is no
  rate to set` since the voices arrived.

What is *not* a defect, and was the question that found this: the
English track is full of katakana on purpose. Its student is a Japanese
test-taker, which `lp_learner_lang()` states outright — learning `en`
means reading `ja` — so twelve loanword traps are keyed on the katakana
reading (`consent` is not コンセント), six glosses are in Japanese, and
`probe(final_consonants, syllables(katakana))` asks how many syllables
`slim` has precisely because スマート has four. Answering four is
recorded as `near` rather than `wrong`, and `lp_count_near` prints the
katakana back as the explanation. None of that is leakage from the
Japanese ladder; it is the first language showing through, which is
what the rung is for.

## The vocabulary question with two right answers

`:chart hiragana` in an English session was a menu defect. Asking *why*
the English track was full of katakana found a worse one underneath it.

An English item carries two glosses, and this is correct — the same word
has to be sayable to a Japanese reader and to an English one:

```prolog
gloss(e_people, en, 'persons, in general').
gloss(e_people, ja, '人々').
```

`lp_question` put **both of them up as the two options**, with the
English one always the key:

```
people
  1) persons, in general          <- keyed correct
  2) 人々                          <- keyed wrong
```

人々 is what `people` means. The student chose between two correct
answers and was marked wrong for the Japanese one. And because the key
was always the option that was not in their own script, a Japanese
reader scored 100% over all 1,105 vocabulary words without reading a
word of English — which is exactly what `exit(en, a1,
vocabulary(500, read), 0.80, _)` was measuring. 1,117 English words
carry both glosses; 12 of them are traps.

**The shape was right for the twelve it was written for.** A loanword
trap asks whether you are reading English through katakana, so `outlet`
against `コンセント` is a real question with one right answer. The branch
was written for the traps and then inherited by eleven hundred words
where the premise does not hold. So the traps keep it, selected on
`lp_isrc(item) = own(loanword_trap)`, and everything else gets the
question it should always have had: the gloss in the language the
student reads, against the glosses of **other words** at the same rung.

Distractors come from the item's own rung rather than the student's
level. That is the right bound pedagogically — nobody should have to
rule out vocabulary they have not met — and it keeps the question stable
under placement, which probes a level that is not `lp_level`.

### `--l1`, and why it is a different question from `--lang`

Which gloss is the answer depends on who is being asked, so
`lp_learner_lang()` moved out of the sheets section and up next to the
questions. It had been a two-way flip: learning `ja` means reading `en`,
and the other way round. That is right for the only two languages the
graph holds and wrong the moment somebody who does not read Japanese
wants to try the English ladder. `--l1` sets it; the flip stays as the
default, so nothing that worked before moves.

What `--l1 en` does **not** do is make pre-school a generic English
rung. All four of its criteria are chosen for a Japanese ear. The useful
finding is that they are all answerable anyway: the contrasts and
confusions are real English minimal pairs, a trap's key is its English
explanation, and `probe(final_consonants, syllables(katakana))` turns
out to ask *how many syllables does `mansion` have* — two, and a native
speaker answers it without knowing マンション exists.

### Two things it cost

**A scan with a Prolog goal in it.** The first version walked `lp_items`
per question to collect distractors, with `lp_gloss_of` — a Prolog goal
— inside the loop. The plan asks `lp_drillable` of every item, so one
session walked 1,117 words x 7,565 items x a goal each, and the suite
stopped finishing inside two minutes. That is the mistake this file's
own `--check` section names: *a lookup written as a goal, run once per
edge or once per path*. `lp_gloss_pool` builds one list per rung and
keeps it; 7,565 goals in total, and the suite runs in 47 seconds.

**A word is not a string, again.** `lp_gloss_of` hands back a **word**,
because that is what a Prolog quoted atom derefs to, so the options
compared false against every string literal in the new tests. The same
trap `lp_depict` hit one tranche earlier, and the same fix: a sentence
that goes out over JSON and gets compared with `=` is converted at the
question boundary. The test-side version of it is worth recording too —
a Pop-11 string here is 8-bit, so `s(i)` yields UTF-8 **bytes** and a
test for `> 12288` is false of 人々 and of コンセント alike. One byte over
127 settles it, and `16r3000` is not how Pop-11 spells a radix literal
in any case (`16:3000` is).
