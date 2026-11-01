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
