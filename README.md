# langpop — a language curriculum as a knowledge graph

langpop is a tutor for two languages: **Japanese** for a Western learner,
and **English** for a Japanese test-taker. What it knows about each
language is a Prolog graph of items and the order they have to be taught
in. What it knows about a student is a separate set of numbers that
changes every time they answer a question.

Both languages begin at a level below the bottom of the official ladder,
because that is where learners begin. A learner with no hiragana is not a
beginner at N5; they are below it.

This README describes the curriculum and how to run it. The record of how
it was built — what the measurements found, what had to be corrected and
why — is in [DESIGN_NOTES.md](DESIGN_NOTES.md).

There are two front ends over one engine:

**A — one process.** `langpop.p`: the graph is Prolog, the student record
and the terminal interface are Pop-11, and nothing leaves the process. No
server, no model, no network.

**B — one protocol.** `server.p` and `client.p`: the same engine behind
JSON-RPC. The terminal interface becomes a client with no privileges a
phone app would not have.

```sh
# A: the whole thing in one process
./langpop                    # Japanese, with Aoi
./langpop --lang en          # English, with Mr Hill
./langpop --check            # integrity-check the graph
./langpop --audit            # which rungs can be climbed
./langpop --deps             # what it needs from this machine, and has
./langpop --chart hiragana   # a page to print
./langpop --zine --user bob  # a booklet to fold
./langpop --audio preschool  # make the sound files
./langpop --voicetest        # check the voice against the scorer
./langpop --voicetest w_gakkou   # ... or just the one word that sounded wrong

# B: the same session, over a protocol
./langpop server --port 7801 &
./langpop client --port 7801 --user bob

./langpop test               # every suite; nonzero exit if any fails
./langpop oracle --seed 42 --answers 3000
```

---

## Contents

- [Installing](#installing)
- [From scratch, as a Japanese learner](#from-scratch-as-a-japanese-learner)
- [A session](#a-session)
- [How the curriculum is built](#how-the-curriculum-is-built)
  - [An item is not its spelling](#an-item-is-not-its-spelling)
  - [What is in the graph](#what-is-in-the-graph)
  - [Prerequisites do the teaching](#prerequisites-do-the-teaching)
  - [Channels: reading a word is not knowing it](#channels-reading-a-word-is-not-knowing-it)
  - [Evidence has tiers](#evidence-has-tiers)
  - [Review, and the 28-day period](#review-and-the-28-day-period)
  - [Exit criteria, and the audit](#exit-criteria-and-the-audit)
  - [Provenance](#provenance)
- [The two pre-schools](#the-two-pre-schools)
- [The Japanese content](#the-japanese-content)
- [The English content](#the-english-content)
- [Adding content from a reference source](#adding-content-from-a-reference-source)
- [Coverage, and the gap report](#coverage-and-the-gap-report)
- [Teaching aids the student controls](#teaching-aids-the-student-controls)
- [Placement](#placement)
- [Things to print](#things-to-print)
- [Sound](#sound)
- [The protocol](#the-protocol)
- [Looking at the graph](#looking-at-the-graph)
- [Commands](#commands)
- [Repository layout](#repository-layout)
- [What it costs on disk](#what-it-costs-on-disk)
- [Limits](#limits)

---

## Installing

langpop runs on [Poplog](https://github.com/IoTone/poplog). `./langpop` is
a wrapper over `poplog basepop11 <file>`; it finds a Poplog by
`$LANGPOP_POPLOG`, then by an enclosing Poplog source tree's `./poplog`,
then by `poplog` on `PATH`. The working directory does not matter.

The quickest way to get a Poplog is the main project's installer:

```sh
curl -fsSL https://raw.githubusercontent.com/IoTone/poplog/master/tools/install-skill.sh | sh
LANGPOP_POPLOG="$HOME/.local/share/pop11-skill/poplog" ./langpop
```

One version check to be aware of. The tutor needs Poplog's `lib/json`
(2026-10-01), which the current release carries. The JSON-RPC pieces —
`server`, `client`, `oracle` — need `lib/jsonrpc` (2026-10-20), which is
newer than the most recent binary release. Until a newer release ships,
those three need a Poplog [built from
source](https://github.com/IoTone/poplog/blob/master/INSTALL). langpop
probes for both libraries at startup and names the release it needs
rather than failing part-way through compiling.

### What it needs, and what is optional

**Only Poplog is required.** Everything else switches on one feature, and
without it that feature is simply not there: nothing fails, which is also
why a missing program is easy not to notice. `./langpop --deps` checks this
machine and says, for anything missing, what it costs and how to get it:

```
  sound
    ok       a voice for ja                     /usr/bin/say
    MISSING  lengthening short kana, ja         sox
             -> brew install sox (or apt install sox)
    --       a voice for en                     none named
```

`ok` is here, `--` is not set up and nothing depends on it, `MISSING` is
asked for by your configuration and not found. It reads the commands out of
your own voice config, so it also catches a voice that is named but not
installed, and a script path that no longer exists.

| for | needs | without it |
|---|---|---|
| the tutor | Poplog with `lib/json` | does not start |
| `server`, `client`, `oracle` | Poplog with `lib/jsonrpc` (2026-10-20) | those three do not start |
| sound | a speech command named in `~/.langpop/audio.conf` (macOS `say` and an installed voice, or any other), and a player (`afplay`, `aplay`, `paplay`, `play`) | no listening questions; the listening half of each level is reported as not checkable |
| longer single kana | [SoX](https://sox.sourceforge.net) (`sox`) | kana are played as short as the voice says them |
| `:speak`, `:mic` | a recorder (`rec` from SoX, or `ffmpeg`) and `python3` | no speaking practice |
| cards in the terminal | `python3`, one of `rsvg-convert` / `magick` / `convert`, and a terminal with the kitty or iTerm image protocol | cards open in a viewer instead |
| opening cards, sheets, booklets | `open`, `xdg-open` or `see` | the file is written and its path printed |
| importing reference content | `curl`, `gunzip`, `python3` | the 1,309 committed items only |
| new photographs (authors only) | `magick` or `sips`, and an image model | the committed photographs only |

A fresh clone holds 1,309 items. The content imported from reference
sources is not kept in git — it is regenerated on demand (see [Adding
content from a reference source](#adding-content-from-a-reference-source))
— and every test suite passes with it and without it.

---

## From scratch, as a Japanese learner

Nothing below needs any content to be imported first: hiragana, katakana and
the first fifty words are committed to the repository, which is enough for
the first several weeks.

```sh
git clone https://github.com/IoTone/pop-11-langpop
cd pop-11-langpop
./langpop --check          # the graph is sound, and names what is short
./langpop --user you --lang ja
```

That is the whole of it. The first session will ask for a name, guess at
hiragana, and stop when you stop. `--lang ja` is the Western learner's
Japanese; `--lang en` is the other direction, English for a Japanese test
taker, and a student is registered in one of them.

**Who the English track assumes you are.** `--lang en` is written for a
student who already reads Japanese: the twelve loanword traps turn on the
katakana reading, and every gloss has a Japanese side. `--l1` says which
language the student can already read, and it is the one thing the track
needs in order to be usable by anybody else:

```
./langpop --lang en --l1 en     # English, explained in English
./langpop --lang en             # the default: explained in Japanese
```

Both flags take one of the languages the graph holds, and say so rather
than failing later — `--lang jp` is the obvious guess for Japanese and
the wrong one:

```
$ ./langpop --lang jp
I have no jp ladder.  I teach: [ja en]
$ ./langpop --lang
--lang wants a value after it.
```

With no flag it stays the flip it has always been — a student of English
reads Japanese, a student of Japanese reads English — so nothing that
worked before needs the flag. What changes is which gloss is the answer
to a vocabulary question and which glosses stand beside it. The
pre-school rung is still a set of *Japanese*-interference contrasts, and
every one of its criteria is answerable without any Japanese: the
contrasts and confusions are real English minimal pairs, a loanword
trap's key is its English explanation, and `final_consonants` asks how
many syllables `mansion` has.

**The first week** is kana, because everything above it requires them. An
empty line asks for the next thing; `:chart hiragana` prints the table on one
page if you would rather look at it than be asked. `:why hi_ka` says why that
character came up now.

**When the kana are solid** the first words arrive by themselves — a word
requires the kana that spell it, so the graph opens them rather than a
syllabus deciding a date. `:status` is the honest answer to "how am I doing":
it prints this level's exit criteria measured over the last 28 days, not a
streak.

**To go past the committed fifty words** import the Japanese content. It
needs two files from the EDRDG — `JMdict_e` and `kanjidic2.xml` — and eight
commands, and takes a few minutes:

```sh
./langpop import --source kanjidic --file kanjidic2.xml --level n5 --jlpt 4
./langpop import --source kanjidic --file kanjidic2.xml --level n4 --jlpt 3
./langpop import --source jmdict --file JMdict_e --picks graph/ja/picks/n5.pl
./langpop import --source jmdict --file JMdict_e --picks graph/ja/picks/n4.pl
./langpop import --source kanjidic --file kanjidic2.xml --level n3 --jlpt 2 \
    --order grade_freq --take 366
./langpop import --source jmdict --file JMdict_e --picks graph/ja/picks/n3.pl
./langpop import --source kanjidic --file kanjidic2.xml --level n2 --jlpt 1
./langpop import --source jmdict --file JMdict_e --picks graph/ja/picks/n2.pl
```

That is 6,212 words and 1,023 characters: N5 through N2 reading in full. The
characters of N1 are one more command — see [Adding content
from a reference source](#adding-content-from-a-reference-source) — and the
words above N2 are not written yet. The
licences and what each command does are under [Adding content from a
reference source](#adding-content-from-a-reference-source), and
`./langpop --audit` says what every rung still wants afterwards.

**Sound is a separate build**, because it is a few hundred files and it is
yours: `./langpop --audio n5` renders every N5 word with the system voice
under `~/.langpop/audio/`. That rung is 876 files and 20 MB; the whole
Japanese ladder is 156 MB, and [What it costs on
disk](#what-it-costs-on-disk) has the rest of the arithmetic. Until it is
run, listening questions have nothing to play and `--audit` says so rather
than asking them — as `unrendered`, which is a different word from `short`
on purpose.

English is rendered the same way, with `--lang en`: `./langpop --lang en
--audio a1`. The three English rungs together are 1,193 files and 37 MB,
and running them is what turned the twelve sound contrasts from *cannot be
asked* into asked.

**What to expect at the keyboard.** Being asked a character a day after
getting it right is the review ladder working, not a bug — the gap widens
each time it is right and resets when it is wrong. `:oops` takes back an
answer that was a typing slip. `later` puts a question off until the end of
the session. `:assign` gives something to do away from the screen and
`:report` records how it went.

---

## A session

```
はじめまして。I am Aoi, and I will be your teacher.
Bob White, then.  We begin at preschool.

Aoi>                          <- empty line: the next thing to learn
  あ    ->  a
  そうです。

Aoi>
  い    ->  o
  Close. Look again at the shape.  That is お -- the two are confused constantly.

Aoi> :why hi_ka
  か  (grapheme, preschool, own(kana))
    ka
    missing(hi_a)  missing(hi_i)  missing(hi_u)  missing(hi_e)  missing(hi_o)
    belief 0.0 on channel read (mastery is 0.8)
```

An empty line asks for the next thing to learn: the item with the weakest
belief that the student is ready for, breaking ties by whichever has been
asked about least. `:why` shows the derivation — what the item requires,
where the fact came from, and where the student stands on it.

Something answered in the last three questions is not asked again while
anything else is ready, whether the answer was right, wrong or "I do not
know". Without that rule, a student who doesn't know an item gets it back
straight away, because a miss makes it the weakest thing there is. If
nothing else is ready, it is asked anyway.

Student records live in `~/.langpop/`, two files per student. The JSON file
holds what they are believed to know — the beliefs, the review ladder, the
period, the settings they chose, and the rung they have reached in *each*
language they have studied. The `.journal` file beside it holds every
answer they have ever given, one tab-separated line per answer, oldest
first: item, channel, evidence tier, outcome, how long it took, when, and
whether it was learning or review. It is plain text on purpose, because it
is the audit, and `grep`, `cut` and `sort` are the right tools for an
audit. There is no password; this is a local tool.

### How it is going: `:progress`

`:status` says what is left of the rung. `:progress` says how the last four
weeks have gone, one mark a day with today on the right:

```
Aoi> :progress
  Dave Kordsmeier, the last 28 days   (one mark a day, today on the right)

  studied    ··········█······█··██·█████   9 of 28 days
  minutes    ··········▇······█··▅▁·▁▄▇▃▅   79 in all, about 9 a day you studied
  questions  ··········▃······█··▁▁·▄▃█▆▅   675 answered
  right      ··········▇······█··▁█·██▇█▇   94%  ↑ up 2 points on the week before
  speed      ··········█······█··▇▂·█▇█▇▆   1.6 s typical right answer  ↓ 0.2 s slower than the week before
```

- `·` is a day with no study.
- Each bar is scaled to its own row. `right` runs from half right (lowest)
  to all right (tallest).
- `speed` is the typical (median) time of a right answer, and is drawn
  turned over: a taller bar is a faster day, from six seconds at the bottom
  to one second at the top.
- The arrows compare the last 7 days with the 7 before them. ↑ is better,
  meaning more right or faster. Within two points, or 0.15 s, it says
  "about the same". A trend needs at least 20 answers in each week.
- The minutes are counted the way `:status` counts them. A sitting ends
  after half an hour of quiet, and no single gap counts for more than five
  minutes.
- Only first-hand answers in the language being studied are counted.

### Which language a session is in

`--lang` is an instruction and beats the language on file; with no flag, the
profile's language stands, and a student the tutor has never met starts in
Japanese. `--l1` is the companion flag and names the language the student
already reads, which is a different question: `--lang` is what they are
learning and therefore the one thing they cannot be assumed to follow. The
flag is honoured out loud rather than quietly:

```
Welcome back. Let us continue where we stopped.
dk, is it not?  Level a2.
  (en this session, as you asked.  n5 is where you
  were in ja, and it is kept.)
```

The rung is kept **per language**, because one level cannot answer for two
ladders: a student who has reached N5 in Japanese is not at N5 in English,
where there is no such rung. So each language resumes where it was left, and
an evening of English costs nothing in Japanese. A language the student has
never studied starts at the bottom of its own ladder.

Reviews are kept per language for the same reason. A Japanese student who
sits down with `--lang en` is not asked their Japanese reviews by Mr Hill;
they wait, still owed, for the next Japanese sitting. And the language a
student studied last is the one they get next time with no flag, so after
an English evening, `./langpop --lang ja` is how to go back.

`--l1 en` reaches every question, including the first one on the English
pre-school rung, which shows a meaning and asks which spelling has it:

```
  the grain you eat               (with --l1 en)
    1) rice
    2) lice

  米                               (the default: a Japanese reader)
    1) rice
    2) lice
```

This is also why `./langpop client` sends a language only when it was given
one. The server treats a language it is handed as an instruction, so a client
that always sent its own default would flip a returning English student back
to Japanese on every connect.

---

## How the curriculum is built

### An item is not its spelling

Every item's identity is a flat atom, and it is never the written form.
`hi_a` is the item; `あ` is one of its forms and `a` is another. The same
is true one rung up: `みず` and `水` are one word, `w_mizu`, met twice.

This is the decision that lets one engine teach a syllabary, a sound
contrast and a sentence pattern, and it is the decision that keeps a
student's record intact when a spelling is corrected or a second script
is added. An id minted from a reference source would change when that
source renumbered, and every belief recorded against it would quietly
detach.

`graph/schema.pl` states every relation a graph file may contain. Nothing
outside that list is allowed in.

### What is in the graph

| File | Holds | Facts |
| --- | --- | --- |
| `graph/schema.pl` | the relations, the teaching rule, the integrity checks | — |
| `graph/ja/ladder.pl` | pre-school → N5 → N1, with exit criteria | 6 levels |
| `graph/ja/kana.pl` | both syllabaries, voiced included, confusable pairs, mora skills | 138 kana |
| `graph/ja/items.pl` | 50 starter words, kana-only, 3 sentence patterns | 53 |
| `graph/ja/picks/n5.pl` | which words are N5, by reference key — the curation | 773 picks |
| `graph/ja/picks/n4.pl` | the same for N4, whose count is measured over both | 749 picks |
| `graph/ja/picks/n3.pl` | the same for N3, where the rung was too big to pick a word at a time and needed a rule | 2,464 picks |
| `graph/ja/picks/n3-rejects.tsv` | what the N3 review threw out, with a reason for each | 336 rows |
| `graph/ja/picks/n2.pl` | the same for N2, where the newspaper rather than the dialogue list is the order | 2,176 picks |
| `graph/ja/picks/n2-rejects.tsv` | what the N2 review threw out; journalese did most of the refusing | 724 rows |
| `graph/en/ladder.pl` | pre-school → A1 → C1, CEFR bands and section floors | 6 levels |
| `graph/en/items.pl` | 13 sound contrasts, 12 loanword traps, 12 written confusions | 40 |
| `graph/en/a1.pl` | 552 A1 words with Japanese glosses, hand-written — 519 content words and the 33 function words that carry the corpus | 552 |
| `graph/en/a2.pl` | the same for A2, whose count is measured over both, plus 4 grammar patterns | 550 words, 4 patterns |
| `graph/resources.pl` | the catalogue: URLs and check dates, never content | 9 |
| `graph/*/generated/*.pl` | content imported from reference sources; a build product, never committed | 8,392 items (ja): 2,230 kanji and 6,162 words; for English, facts only: 1,103 pronunciations, 1,069 frequencies |
| `viewer/page.html` | the curator's view of all of it, filled by `dump.p` | — |

1,342 committed items, 9,741 once the imported content is built; 12 ladder
levels, 40 exit criteria, no integrity violations either way. Those are
the figures `./langpop --check` prints.

### Prerequisites do the teaching

The whole of the tutor's choice of what to teach next is one clause:

```prolog
ready(S, Lang, Level, I) :-
    item(I, _, Lang, Lv, _),
    at_or_below(Lang, Lv, Level),
    \+ lp_known(S, I),
    all_hold(requires(I, Pre), gate_ok(S, Pre)).
```

An item is ready when it sits at or below the student's level, is not
already known, and every prerequisite is satisfied. `at_or_below` rather
than the level exactly, because everything else in the design is
cumulative: a student who moves up and then forgets a word from the level
below must be able to meet it again.

Edges are derived wherever a rule can state them. The 138 `kana/5` facts
produce 138 items and 276 forms; the katakana-after-hiragana edges, the
vowels-first edges, が-after-か and the か/が confusable pairs are all
rules rather than typed data. A glyph can only be wrong in one place —
and the kana table itself is generated from Unicode codepoints by
`tools/mkkana.py`, so it is not wrong at all.

Two kinds of edge get drawn automatically when content is imported:

- **A word needs the kana.** Every imported Japanese word requires
  `hiragana_all`.
- **A word needs the characters written in it**, where the graph holds
  them. 本 is in 日本, which is a fact rather than a teaching opinion.

What is never derived is teaching order *between words*. KANJIDIC2 has
radical and stroke data that would support a deeper ordering, but which
radicals come before which characters is a claim the source does not
make, and a hundred edges nobody chose is not a graph anyone can reason
about. The orderings that matter are stated by hand as `pick_requires/2` —
antonym pairs, mostly, where the second word is introduced as the
negation of the first and means little before it.

**Beliefs live outside the graph.** A belief is a number between 0 and 1,
per item per channel, held in Pop-11. The graph holds no student state at
all, which is why `--check`, `--audit`, the charts and the viewer need no
student.

### Channels: reading a word is not knowing it

Each item is judged on a list of channels:

| Item kind | Channels |
| --- | --- |
| character | `read` |
| word | `read hear speak` |
| sound contrast | `hear speak` |
| written confusion | `read hear` |
| sentence pattern | `produce` |

And the exit criteria name the channel they measure:

```prolog
exit(ja, n5, vocabulary(800, read), 0.80, 4000).
exit(ja, n5, vocabulary(800, hear), 0.80, 4000).
exit(ja, n5, kanji(103, read),      0.80, 4000).
```

Vocabulary is the one axis in language learning that enumerates, so it is
the one that gets ground: a word count rises while listening rots. Every
JLPT level has a 聴解 section that a word count does not touch, so asking
for the same vocabulary on two channels is not an invention — it is what
the exam already asks.

Characters take no `hear` channel. A character is not heard; its
*reading* is, and that is the word's channel rather than the character's.

**Unlocking and passing are separate questions.** `lp_primary/1` is the
**gate** — the head of an item's channel list, and the thing that opens
the prerequisite graph. For reading something built on reading, reading is
enough. If the gate demanded every channel, then on a machine that cannot
check `hear`, nothing would unlock and the ladder could not be climbed.
Passing a level is what the exit criteria are for, and they report each
channel separately rather than averaging two numbers into a comfortable
one.

A prerequisite the tutor has no way to check does not hold the door shut:

```prolog
gate_ok(S, Pre) :- lp_known(S, Pre).
gate_ok(_, Pre) :- lp_ungateable(Pre).
```

The edge is still true and still teaches order; it simply cannot be a
*condition*, because nothing could satisfy it. This does not let anybody
pass anything — an unmeasurable criterion is still reported as
unmeasurable.

**And the tool says what it cannot check.** `hear` is verifiable only
where a voice is installed, the client can play sound, and the item is
already rendered; `speak` needs a microphone and a scorer:

```
vocabulary(50, read): 0 of 50 words mastered (40 in the graph)
vocabulary(50, hear): cannot be checked here -- needs audio (40 in the graph)
```

Reporting *0 of 50* would read as a student who has learned nothing, when
what is true is that nothing here can measure it. `langpop/status` carries
`"verifiable": false` so a client cannot present the tool's limit as the
student's ability. The consequence is that langpop can say *your reading
is at N2 and I cannot certify your listening*, which is true.

### Evidence has tiers

The tutor assigns work it cannot watch, and the student reports back.
Five kinds of evidence, five ceilings, set in one place in `langpop.p`:

| Tier | What it is | Ceiling |
| --- | --- | --- |
| 1 | verified here — we saw the answer and timed it | mastery (0.80) |
| 2 | a reported result — "17 out of 20" | 0.78 |
| 3 | reported compliance — "I did it" | 0.50 |
| 4 | inferred — watched them do something that required it | 0.75 |
| 5 | a machine verdict — they spoke, something measured it | 0.77 |

So compliance cannot reach mastery by arithmetic rather than by good
intentions: twenty "I did it"s leave an item below 0.5. A reported result
carries an item to just below mastery, so one verified check here is
always what settles it. Only tier-1 evidence is measured against a
level's exit criteria.

Accuracy and speed are reported separately and never averaged. A student
who is right slowly has not learned to read a syllabary — recognition is
the thing being taught, and the clock is the only way to tell recognition
from working it out. Every pre-school exit criterion carries a
millisecond budget as well as a threshold.

### Review, and the 28-day period

A mastered item is scheduled, not shelved. It comes back after a day,
three days, a week and four weeks, and is then burned — four consecutive
correct answers across that ladder and the item is done.

Scores reset every 28 days on the student's own clock. The *reading*
resets; the record never does. Exit criteria read **each item once, by
its latest review this period** (or as settled, if it is burned), because
measured over a lifetime, or even over every review of the month, they
report what it cost somebody to learn rather than what they know now. A
slow review a fortnight ago is replaced by the next one. Every item in the
set has to have been reviewed this period, so nothing passes on a sample.

`:status` names the items holding a criterion back:

```
    to work on (slow or missed at the latest review):
      recognise(hiragana): は  つ  か  ん  め wrong  こ wrong  (9 not reviewed yet this period)
```

`:drill` asks exactly those items, now, and says how long each answer took
against the limit:

```
  は    ->   そうです。
  1.4 s -- inside the 2.0 s.
```

**Practice counts for nothing.** It moves no score and no review date:
ten quick repetitions in a minute are not a retrieval after a gap, and the
criteria read reviews only. It is there because speed cannot be practised
blind, and because a review should not be the first time since the last
one that a student sees the kana they were told is slow. The answers are
still in the record, so the minutes show in `:progress`.

The line client has the same `:drill`, and any other client gets it by
sending `practice: true` with `langpop/next`.

With nothing owed today the tutor says which day the next review falls
on, rather than that it has run out of work.

`--day-ms` scales the length of a day for testing. It scales the clock and
nothing else.

The numbers behind all of this, and which of them are still arguable, are
in [docs/langpop-reviews-and-periods.md](docs/langpop-reviews-and-periods.md).

### Exit criteria, and the audit

`--check` proves the graph is **consistent**: no cycle, no dangling
prerequisite, every item on a rung that exists, every item's source
known, every level carrying at least one exit criterion.

A ladder can pass that and still be unclimbable, because consistency says
nothing about whether there is enough to learn.
`exit(ja, n1, kanji(2230, read), 0.80, 2000)` is perfectly consistent
against a graph holding 103 characters. It is simply unreachable.

```sh
./langpop --audit
```

```
  40 exit criteria over 12 ladder levels.

  lang  level      criterion                 have  askable  verdict
  ja    preschool  recognise(hiragana)       69    69       ok
  ja    preschool  skill(mora_count)         1     51       ok
  ja    preschool  vocabulary(50, read)      50    50       ok
  ja    n5         vocabulary(800, read)     823   804      ok
  ja    n5         vocabulary(800, hear)     823   63       unrendered by 737
  ja    n5         kanji(103, read)          103   103      ok
  ja    n1         vocabulary(10000, hear)   6212  98       short by 9902
  en    preschool  sound_contrasts           13    30       ok -- 4 of 13 cannot be asked
  en    preschool  written_confusions        12    24       ok
  en    a1         vocabulary(500, hear)     567   567      ok
  en    b1         coverage(reading, 0.95)   1105  55       short by 40
```

Seven verdicts, because they mean different things to whoever reads them:

| verdict | meaning | whose problem |
| --- | --- | --- |
| `ok` | enough askable content exists to satisfy it | nobody's |
| `thin` | passes on fewer than 3 askable items | the graph's |
| `short` | measurable, content is thin | curation |
| `unrendered` | the content is there and unsaid — run `--audio <level>` | this machine's |
| `no probe` | the item set exists and nothing in it can be asked | a bug |
| `needs audio` | every item in the set is on a channel this build cannot check | this build's |
| `unmeasured` | nothing measures it at all | the design's |

Only `short` is allowed to be large. The others are each a claim the
ladder makes and cannot cash.

`unrendered` is the one that is nobody's fault and everybody's confusion.
The two `hear` lines above differ by one word, and that word is the whole
difference: n5 needs one command, n1 needs 3,846 words that do not exist.
Both read `short` until the audit learned to tell them apart, and `short`
says *curation* — so the report sent a reader looking for words that were
already in the graph. It blocks the rung exactly as `short` does, since
the channel is verifiable and the engine excuses nothing; it is simply not
a hole in the content.

`thin` exists because of Goodhart's law. A criterion measured over one
item is not a measurement, it is an anecdote, and it passes. Three is the
smallest number of items that can disagree with itself.

The `askable` column counts **distinct questions**, not items, because a
skill with a generated probe is one item that can be asked about fifty
words. That cuts both ways, and the second way matters more: when the
material for a skill runs to a single word, the criterion *is* thin, and
counting items would not have said so.

Counts are cumulative, because the criteria are: `kanji(2230)` at N1 means
every character through N1, not 2,230 more of them. So the pool for any
criterion is that level and below.

A second view asks the question a rung at a time, because a rung is left
by meeting **every** criterion on it:

```
  lang  level      criteria  can it be left?
  ja    preschool  7         yes
  ja    n5         3         not yet -- but only for want of running --audio here
  ja    n1         3         not yet -- short
  en    preschool  4         yes
  en    a1         2         yes
  en    b1         3         not yet -- short

  4 of 12 rungs can be left as the graph stands.
```

The verdict names the **worst** blocker, ordered by whose problem it is:
no exit criterion at all is a bug in the ladder, `unmeasured` is a hole in
the design, `short` is curation, `unrendered` is one command on this
machine, and `needs audio` is a limit of this build. `unrendered` sits
below `short` and above `needs audio`, which is right on both sides: it
blocks the rung as surely as `short` does, since the channel is verifiable
and nothing is excused, but it is not a hole in the content.

**A criterion nothing on this machine can measure is excused by name.** The
student moves up, and the tutor says which criterion it could not ask
about. A rung of nothing but excuses does not pass.

`langpop/audit` is the same report on the wire, with `"short_by"`
pre-computed and `"wanted": null` on a criterion that is not a count. No
session is needed — this is a property of the graph, not of anybody's
progress. A client that draws a ladder wants it: showing a student
`kanji(2230)` as a goal they are 0.05% of the way to, when the graph holds
103 characters, reports the tool's emptiness as the student's failure.

### Provenance

Every fact carries where it came from: `own(kana)`, `own(starter_list)`,
`estimate(community)`, `ets(cefr_mapping)`, `jmdict('1302680')`,
`kanjidic2(ucs('65e5'), jlpt(4))`. `--check` fails any item whose source
is `unknown`.

This matters most where a number is an estimate. JLPT has published no
content list since 2010 — the Test Content Specifications were withdrawn,
and the official FAQ says vocabulary and character lists are no longer
released — so the N5 word count is a community estimate and says so. The
*character* counts are not: KANJIDIC2 carries a `<jlpt>` field holding
the pre-2010 four-level exam, and old level 4 is exactly what became N5,
so four of the five character counts are counted from the source and only
N3's is an estimate.

---

## The two pre-schools

Both ladders have a rung below their first official level, and the two
exist for opposite reasons.

**Japanese.** N5 assumes hiragana, some katakana and several hundred
words. So pre-school is index 0, and it teaches the two syllabaries, the
pairs beginners actually confuse (`あ/お`, `シ/ツ`, `ね/れ/わ`), and mora —
because a student who reads every kana and still hears きって as two
beats has not finished.

**English.** A Japanese speaker starts with several thousand words
already half-known, in katakana, and some of them are *wrong*. Those are
not vocabulary to learn but vocabulary to unlearn, which is a different
exercise and gets its own items: マンション is not a mansion, サービス is
not a service, クレーム is not a claim. The same katakana layer that makes
English easier to read makes it harder to hear and harder to use. Beside
those sit the sound contrasts Japanese does not make.

---

## The Japanese content

**The syllabaries.** 138 `kana/5` facts: 46 base kana per script plus 23
voiced ones per script. Dakuten is the base codepoint + 1 and handakuten
the base + 2, which is the second systematic thing about the syllabaries
after katakana being hiragana + 0x60, so these are generated along with
the rest.

```prolog
kana(hi_ga, hiragana, 'が', ga, g).
voiced(hi_ga, hi_ka, dakuten).
```

`voiced/3` is stated once and both consequences are derived from it:

```prolog
requires(V, B) :- voiced(V, B, _).
confusable(B, V, mark(Mark)) :- voiced(V, B, Mark).
```

One mark is one new thing to notice, so the base kana is the prerequisite
and nothing else is. And the pair is confusable because one mark apart is
exactly how a beginner misreads it — か for が is not a wild guess, it is
the mark going unseen — so the tutor diagnoses it as a near miss rather
than as wrong, and can offer the partner as a distractor.

**ぢ and づ are deliberately absent, and it is the only judgement in the
table.** They are not a third and fourth sound: they are alternative
spellings of じ and ず, used where a base kana is reduplicated or
compounded (つづく, ちぢむ), and Hepburn spells each pair identically
because they are the same sound. Two consequences follow. `skill(dakuten)`
is *one mark changes the sound*, and these are the one place where it does
not, so they are not instances of the skill. And `kana.pl` joins katakana
to hiragana on the romaji, so two kana spelled `ji` would make ヂ require
both じ and ぢ — and ジ require ぢ — gating a common character behind a
vanishingly rare one. The charts print the two gaps and the footer says
why, rather than leaving a reader to wonder whether the chart is broken.

**The characters that are not syllables.** っ, ゃ, ゅ, ょ, the small vowels
and ー stand for no mora of their own, so they are not in `kana/5` and
never will be: a gojūon grid has no cell for them, and `type the romaji`
cannot ask about ゃ, because ゃ and や are both `ya`. They are instead
*declared*, and each is covered by a skill about what it does:

```prolog
modifier('ゃ', hiragana, youon).
modifier('っ', hiragana, mora_sokuon).
modifier('ー', katakana, mora_long_vowel).
modifier('_', any,       placeholder).
```

Together with `kana/5` they account for every character of the script,
and checkably so: beside the graph-shape check there is a check that
walks every written form in the graph and reports any character that is
neither a kana nor a declared modifier.

**Mora are asked about by typing.** Producing correct timing needs a
microphone. *Knowing* how many beats a word has is a reading question
with a number for an answer, and the number is computable from the kana:

```
every kana       one beat
small ゃゅょ      no beat -- it joins the kana before it
small っ         one beat, of silence
ん               one beat, which is why it is moraic
ー               one beat
```

The first two are what make it worth asking. **きょう looks like three
characters and is two beats; きって looks like three and is three.**

```
Aoi>
  きょう
  何拍ですか。How many beats?  ->  3
  Not yet. We will come back to it.  It is 2.
```

`probe(Skill, morae(Feature))` says a skill carries a generated question
and names the material the feature picks out — `sokuon`, `youon`,
`moraic_n`, `long_vowel`, `any`. The material is drawn from the graph and
the answer is counted from the kana, so neither is written down anywhere,
and a content build that adds a thousand N5 words adds a thousand mora
questions.

**A skill with a probe is measured over itself; one without is measured
over what it rolls up over:**

```prolog
criterion_item(skill(S), S) :- probe(S, _).
criterion_item(skill(S), I) :- \+ probe(S, _), skill_leaf(S, I).
```

The difference is which thing the question is about. `skill(dakuten)` is
*read the voiced kana*, so reading them is the evidence and the criterion
is measured over the 46 of them. `skill(mora_count)` is *count the
beats*, and reading あ is no evidence of that at all. The roll-up is
transitive and skips skills on the way down, because `mora_sokuon`
requires `mora_count`, which is itself a skill.

**The 50 starter words are kana-only by design**, and they are chosen as
words normally *written* in kana — ちょっと, たくさん — rather than as
common words that happen to be short. A learner meets ちょっと constantly
and will never meet it as 一寸, so teaching it here costs nothing later.
Teaching でんしゃ in kana would be teaching a word that has to be
relearned as 電車 two rungs up.

**N5** holds 103 characters taken from KANJIDIC2 by rule, and 773 words
named in `graph/ja/picks/n5.pl` by hand — 823 counting the fifty at
pre-school, which is what the rung's criterion measures. See [Adding
content from a reference source](#adding-content-from-a-reference-source).

Nineteen of those words are written only in kana — はい, こんにちは,
とても — and have no reading question, because a reading question holds
one form up and asks for another and they have one form. They are counted
in the audit's `have` and not in its `askable`, which is the honest place
for them: a student needs them, and by N5 prompting とても for `totemo`
would test hiragana rather than vocabulary. A katakana loanword is the
opposite case and *is* asked, prompted as the katakana and answered in
romaji, because reading コーヒー as koohii is a genuine exercise that
learners get wrong.

**N4** holds the next 181 characters and the next 749 words — 284 and 1,572
cumulatively, which is what the rung's criteria measure, and both of them
are met. The two halves came from opposite places. The characters needed no
curation: KANJIDIC2's `<jlpt>` field holds the pre-2010 four-level syllabus,
old level 3 is the one that became N4, and 103 + 181 is exactly the 284 the
ladder asks for. The words are a judgment, because JLPT has published no
word list since 2010 and JMdict carries no level marking, so
`graph/ja/picks/n4.pl` names them by hand the way N5's file does and the
ladder's provenance says `estimate(community)`.

**N3** is where picking a word at a time stopped working. The rung asks for
3,750 cumulative, which was 2,236 more words than the graph had, and the
rule that replaced the hand is one sentence: *a bridge-level word is one
that both corpora use*. JMdict's priority marks say a word is common and
gate the pool; the dialogue frequency list says people say it and orders it.
Ordering by the newspaper marks instead put 外相, 安保 and 議席 in the
rung's first three hundred words, which is Diet reporting rather than the
bridge level. Five filters then ran as rules -- the kanji must be taught at
or below N3, the word must not already be in the graph, upstream must mark
it common, it must not be a verb stem, and its spelling must be one
upstream recommends rather than one JMdict tags as a phonetic borrowing or
a rarity -- and 2,800 survivors were read by hand, of which 336 were thrown
out with a reason recorded for each in `graph/ja/picks/n3-rejects.tsv`. The whole argument, including the parts
that are not defensible, is in
[docs/langpop-n3-vocabulary.md](docs/langpop-n3-vocabulary.md).

**N2 is where the corpus had to change**, and that is the most useful thing
the two rungs together taught. 判断, 批判, 段階 and 背景 are *absent* from
the 34,504-form subtitle list — not rare in it, absent — while 捜査 sits at
rank 109. A list built from film and television is a record of what people
say; N2 is the rung at which a learner reads editorials. So at N2 the
newspaper orders the pool and the dialogue count is only the tiebreak, which
is the exact reverse of N3 and the same principle: ask what each corpus is a
measurement *of*. 2,900 rows were read by hand and 724 thrown out — 25%
against N3's 12%, because a newspaper corpus is thick with party names,
ministries and its own shorthand (同省 “the said ministry”, 与野党, 戦況) and
carries a whole sports page besides. The argument is in
[docs/langpop-n2-vocabulary.md](docs/langpop-n2-vocabulary.md).

The characters needed no curation except for the one rung KANJIDIC2 cannot
answer, which is
[docs/langpop-n3-kanji.md](docs/langpop-n3-kanji.md).

**Answers may be typed in Latin letters.** An answer is a *list* of
acceptable spellings, canonical first — about four per item, from the kana
as written, the same folded to hiragana, and the romaji of each. So
`hd(answer)` is what the tutor says when the student is wrong, and that is
the kana: *It is やま*, not *It is yama*.

```
一  ->  ひと          そうです。
山  ->  yama          そうです。
電車 -> densya        そうです。
山  ->  kawa          Not yet.  It is やま.
```

The transliteration is Hepburn with two concessions, both of which a
learner will actually type. **A long vowel may be written once** — がっこう
is `gakkou`, and a student who types `gakko` has answered the question
that was asked. **Kunrei is accepted**, because it is what a Japanese
primary school teaches: `tukue`, `densya`, `tosyokan`.

Two skills, two strictnesses, and the difference is deliberate. がっこう at
pre-school is a reading-the-*kana* exercise, so `gakko` has skipped the う
and is wrong. The same word met as 学校 at N5 is a reading-the-*kanji*
exercise, where the length of the vowel is not what is being asked.

Questions are typed rather than picked, even though the confusable pairs
would make good distractors: typing is a stronger probe, there is no
one-in-four guess in it, and accepting romaji means no Japanese input
method is needed.

---

## The English content

**519 A1 words** in `graph/en/a1.pl` and **550 A2 words** in
`graph/en/a2.pl`, with Japanese glosses, written by hand. A1 is concrete —
family, food, animals, colors, the body, the house — and A2 is what you do
with other people: work, travel, money, health, school, the law, and the
verbs and adjectives for change rather than things. The A2 count is
measured over both files, because a vocabulary criterion counts everything
at or below its rung, so the thousand words A2 asks for are 519 plus 550
plus the pre-school dozen. The glosses are hand-written for a reason worth stating, because the
obvious shortcut does not work: JMdict read backwards — find the entries
whose English gloss is `water`, take their Japanese headwords — returns
水分, お水 and ウォーター and never 水. An exact match on a gloss is not a
translation. A bilingual dictionary is organised to explain Japanese words
in English, and read the other way it finds whichever Japanese word
happens to carry the bare English word as a gloss, which favours archaisms
and transliterated loanwords. Teaching `water` as 水分, which means
*moisture*, is worse than not glossing it at all.

**13 sound contrasts** — the distinctions Japanese does not make, and so
the ones a Japanese speaker has to be taught to hear rather than left to
absorb. `/r/`–`/l/`, `/v/`–`/b/`, `/f/`–`/h/`, `/θ/`–`/s/`, the
consonant-cluster one, final consonants, stress placement, and so on.

A contrast is drilled through a **pair**:

```prolog
pair(s_v_b, 'vote', 'boat').
pair(s_cluster, 'sport', 'support').
```

29 pairs over 8 of the 13 contrasts. The relation is `pair`, not
`minimal_pair`, and the name is the point. `right`/`light` differ in one
phoneme; `sport`/`support` do not — they differ by a whole schwa. They are
a pair *here* because the vowel a Japanese speaker inserts into a
consonant cluster turns the first into the second. A relation called
`minimal_pair` would be a claim about English; this one is a claim about
the learner, which is what the graph is for.

Four contrasts have no pair and are deliberately absent: `s_final`
(*need* against *need-o* is not two words), `s_stress` (**PRE**sent and
pre**SENT** are one spelling, so the question would offer the same option
twice), `s_schwa` and `s_rhythm` (properties of an utterance, not a word).
The audit says so rather than pretending.

**12 written confusions**, which are the reading half of a merge:

```prolog
mix(m_rice,     'rice',     'lice',     s_r_l).
mix(m_presents, 'presents', 'presence', s_ts).
mix(m_coffee,   'coffee',   'copy',     katakana_near).
sense(m_rice, 'rice', 'cooked rice',  '米').
sense(m_rice, 'lice', 'the insects',  'シラミ').
```

The question shows what one of the two words means and offers both
spellings; either side is asked in turn. It needs no speaker and no cached
sound, so a learner with no microphone can finish the rung.

A written confusion is deliberately **not another channel of the contrast
that causes it**. The fourth argument of `mix/4` records the cause and is
not a `requires` edge to it. A contrast is measured by playing a sound,
and a reading answer is no evidence of hearing. Keeping them separate is
what lets the English pre-school rung be finished honestly on a machine
with no voice.

**12 loanword traps** — English words a Japanese speaker already
half-knows in katakana, where the katakana meaning is wrong:

```prolog
trap(t_mansion, 'mansion', 'マンション',
     'a very large house -- the katakana means an apartment building',
     '大邸宅').
```

The English gloss carries the contrast, because a contrast belongs in the
language being learned; the Japanese slot holds Japanese. So the trap is
one card: `mansion`, with マンション above it and 大邸宅 below.

**Syllable counting** is the English mirror of the mora skill. A Japanese
speaker says ドッグ for *dog* — three beats where English has one syllable
— because Japanese cannot end a syllable in a consonant and puts a vowel
there instead. `skill(final_consonants)` is named for that: *ends a word
without adding a vowel*.

```
mansion    2 syllables   vs  マンション     4 beats
slim       1             vs  スマート       4
part-time  2             vs  アルバイト     5
excited    3             vs  ハイテンション 6
```

One syllable per vowel nucleus, counted from the pronunciation. The five
diphthongs are two symbols and one nucleus — counting vowel *symbols*
makes `child` two syllables — and the pairs are exactly the five diphthongs
the importer maps, so this is the inverse of a table that already exists
rather than a guess about English.

The material picks itself: an item with both an English pronunciation and a
katakana one, where the katakana takes more beats. The twelve loanword
traps are exactly that set, which follows from what they were curated for.

A learner who answers four has not guessed. They have read the katakana,
honestly, which is the whole of the katakana problem. So it is recorded as
a near miss rather than as wrong, and the tutor says which count they gave:

```
  mansion
  How many syllables? English, not the katakana.  ->  4
  Almost.  That is the beats in マンション.  The English word has 2.
```

A verdict that only says *no* teaches nothing, because the student already
knows they got it wrong and not why.

---

## Adding content from a reference source

`import.p` fills the rungs above pre-school from published reference data.
Two rules make that safe, and they are the whole arrangement.

**The repository holds curation, never content.** JMdict and KANJIDIC2 are
CC BY-SA 4.0 (EDRDG). Share-alike is reasonable for a dictionary and
unworkable for a tutor, so what the importer writes is a **build
product**: `graph/<lang>/generated/` is gitignored, regenerated on demand,
and carries the source's notice in its own header. What *is* committed is
`graph/<lang>/picks/*.pl` — which entries, at which level, under which
identity — because that is the teaching judgement.

**An identity is never generated.** Word ids are written by the curator,
for the reason given in [An item is not its
spelling](#an-item-is-not-its-spelling). The one exception is a character,
whose id is `k_<codepoint>`, and a codepoint is not anybody's opinion.

```sh
tools/fetch-upstream.sh ~/langpop-upstream

# KANJIDIC2 carries the level, so the selection is a RULE.
# Old level 4 became N5, old level 3 became N4 and old level 1 became N1.
./langpop import --source kanjidic \
    --file ~/langpop-upstream/kanjidic2.xml --level n5 --jlpt 4
./langpop import --source kanjidic \
    --file ~/langpop-upstream/kanjidic2.xml --level n4 --jlpt 3
./langpop import --source kanjidic \
    --file ~/langpop-upstream/kanjidic2.xml --level n1 --jlpt 1

# N3 is the rung the 2010 syllabus added with no old level of its own, so
# old level 2 has to be SPLIT between N3 and N2 -- 366 and 373 characters.
# The rule is school grade first and newspaper frequency only within a
# grade, and it is argued in docs/langpop-n3-kanji.md.  Both halves have
# to be generated together or a character lands at two levels or none.
./langpop import --source kanjidic \
    --file ~/langpop-upstream/kanjidic2.xml --level n3 --jlpt 2 \
    --order grade_freq --take 366
./langpop import --source kanjidic \
    --file ~/langpop-upstream/kanjidic2.xml --level n2 --jlpt 2 \
    --order grade_freq --skip 366

# JMdict does not, so the selection is a PICK LIST
./langpop import --source jmdict \
    --file ~/langpop-upstream/JMdict_e --picks graph/ja/picks/n5.pl
./langpop import --source jmdict \
    --file ~/langpop-upstream/JMdict_e --picks graph/ja/picks/n4.pl

# CMUdict creates no items; it enriches English words already declared
./langpop import --source cmudict \
    --file ~/langpop-upstream/cmudict.dict --lang en --level a1
```

| Source | Licence | Knows | So the selection is |
| --- | --- | --- | --- |
| KANJIDIC2 | CC BY-SA 4.0 | the JLPT level of a character, its school grade and its newspaper rank | a **rule** — `--jlpt 4`, `--jlpt 3`, `--jlpt 1`; and a **split** for N3, `--order grade_freq --take 366` |
| JMdict | CC BY-SA 4.0 | readings and meanings, no level | a **pick list** |
| CMUdict | 2-clause BSD | how an English word is pronounced | **nothing** — it enriches |

### Writing a pick

A pick names an entry one of three ways:

```prolog
pick(w_neko,  ja, n5, word, jmdict_kana('ねこ')).
pick(w_yomu,  ja, n5, word, jmdict_kanji('読む')).
pick(w_yama,  ja, n5, word, jmdict('1302680')).
```

The first two are what a person can write; the third is the escape hatch,
and it is needed more often than it looks. 空 is そら and から and くう, and
a key that names three entries names none of them. **An ambiguous key is an
error with the candidates listed, never a guess:**

```
AMBIGUOUS w_otoko: jmdict_kanji(男) matches 5 entries --
    jmdict('1419990')  男  おとこ/おっこ  man, male
    jmdict('2742850')  男/男の子  おのこ  man, boy
    jmdict('2742870')  雄/男/夫/牡  お  male
    jmdict('2742890')  男  なん  son
    jmdict('2843485')  男  だん  masculine noun
    -- say which, with pick(w_otoko, ..., jmdict('NNNNNNN')).
```

Expect to resolve a good share of a tranche this way; 28 of the first 148
picks came back like that. A tutor that silently taught *chopsticks* for a
pick meaning *bridge* would be wrong in a way nothing downstream could
detect.

Ids are romaji, and Japanese is rich in homophones, so sooner or later a
pick wants an id that is taken. The convention is a short English sense tag
after the romaji: 気 is `w_ki_mind`, because `w_ki` is 木. It is readable in
a journal without a lookup, and the tag is the curator's one word for which
word this is rather than a translation.

**A pre-school word is not re-picked at N5.** みず and 水 are one item,
`w_mizu`, which already exists — and the N5 work for that word is the
character 水, which the character import already made an item in its own
right. Picking it again would mint a second identity for one word and
split a student's record in half. The importer refuses it.

What one import produces:

```prolog
item(w_tanjoubi, word, ja, n5, jmdict('1419110')).
form(w_tanjoubi, kanji, '誕生日').
form(w_tanjoubi, hiragana, 'たんじょうび').
gloss(w_tanjoubi, en, 'birthday').
requires(w_tanjoubi, hiragana_all).
requires(w_tanjoubi, k_751f).          % 生
requires(w_tanjoubi, k_65e5).          % 日
```

誕 gets no edge, because it is not an N5 character — the word is then
taught in kana, which is what a learner does before they meet it.

### What the importer reports

**A level with no content and a level that was never built are not the
same thing.** Both have no items, so each generated file stamps itself,
and the engine treats a missing file as an unbuilt level rather than as an
error:

```prolog
generated(kanjidic2, ja, n5, 103, '2026-10-20T17:41:56Z').
```

**It reads back what it wrote.** `imp_verify` compares what the emitter
meant to emit against what the graph actually holds, and refuses to be
quiet about a difference. A syntax error in a consulted Prolog file is not
fatal — the clause is skipped and loading continues — so without this
check a quoting bug loses facts silently.

**It names what the word list is missing**, which is the question a curator
filling a level actually has, and distinguishes the two answers, because
one is fixable by curation and the other is not:

```
contrasts exercised at a1: 10 of 13
  no word at a1 exercises these -- a gap in the word list:
    s_v_b  vote and boat
  not derivable from a pronunciation, so never emitted:
    s_final  need, not need-o
    s_stress  PREsent and preSENT
    s_rhythm  stress-timed, not mora-timed
```

### Pronunciation implies a contrast

The character edge again, applied to sounds. `library` has an R and an L in
it, so it *is* the /r/–/l/ exercise, and that is a fact about the word
rather than an opinion about teaching:

```prolog
form(e_world, ipa, '/wɜrld/').
requires(e_world, s_r_l).

form(e_street, ipa, '/strit/').
requires(e_street, s_cluster).
```

The rules are deliberately **selective**. A rule for `s_final` — "ends in a
consonant" — was true of 67 of the first 100 words, and an edge that two
items in three carry tells a reader nothing and a planner nothing either.
It is left out, along with `s_stress` (which needs the stress-shifting
*pair*, and one dictionary entry cannot show one) and `s_rhythm` (a
property of a sentence). What remains fires on 2% to 14% of the list.

The minimal-pair rules want *both* phonemes present, since a word with an R
and no L is not the r/l exercise, just a word with an R in it. `ER` counts
as carrying the R, because it is a rhotic vowel and `world` is one of the
hardest words on the list for a Japanese speaker.

No contrast edge is drawn for a written confusion. `requires(m_think,
s_th_un)` would be true of the word and wrong about the teaching order: it
would put the whole written rung behind the listening one, which is the
separation the confusion items exist to maintain.

### Where a frequency corpus is and is not used

The English word list is attested against
[hermitdave/FrequencyWords](https://github.com/hermitdave/FrequencyWords)
(OpenSubtitles). **Attested, not selected.** Every word in `a1.pl` and
`a2.pl` appears in the frequency list, which is a mechanical way of
catching a spelling that is archaic, mistyped or invented — the A2 rows
are 2.96% of that corpus between them. Nearly every one is in CMUdict
too, and the exceptions are worth knowing about: CMUdict has `headache`
but not `toothache` or `stomachache`, so those two words are taught and
read but cannot contribute a pronunciation.

Selection stays a curation question, and the ranks say why: `insect` is
8,551st in film dialogue, `pencil` 5,821st, `vegetable` 7,532nd, and all
three are in every A1 syllabus ever written. Characters in films do not say
*vegetable*; learners do.

**The Japanese words are not attested, and cannot be.** The same corpus
family has a Japanese list, and it is missing 私, 僕, 君, 俺 and 誰 — the
commonest first and second person pronouns and the word for *who* — in
every spelling, while holding 、, 。, あなた and お前. Run as an
attestation check it reports 僕 and 誰 as absent from Japanese. So the N5
words in `graph/ja/picks/n5.pl` are curation and nothing else, the file
says so, and no Japanese coverage figure here should be believed.

---

## Coverage, and the gap report

`coverage(reading, 0.95)` is Nation's measure: *the words you know account
for 95% of the words on the page*. It is arithmetic once the frequency data
exists — sum what the mastered words account for, divide by what the corpus
accounts for. No model, no interpolation, no published table.

A rank cannot do this job. `rank/3` says *where* a word sits; `freq/3` says
*how much of the text it is*, and they are not the same thing. `the` and
the fifty-thousandth word are one rank apart from their neighbours and four
orders of magnitude apart in how much text they cover. So the count comes
across with the rank, the corpus total comes across once, and the engine
divides:

```prolog
rank(e_people, opensubtitles_en, 118).
freq(e_people, opensubtitles_en, 885915).
corpus(opensubtitles_en, 50000, 725119374).
```

**The denominator is the whole corpus**, not the words we happen to teach.
Dividing by our own vocabulary would give a figure that only ever goes up
and would read as progress rather than as coverage.

The scale is named in every fact — `opensubtitles_en`, not `frequency` —
because OpenSubtitles is **dialogue**. Its frequency profile is a good
basis for `coverage(listening, _)` and a proxy for `coverage(reading, _)`,
whose published thresholds come from written corpora. `:status` prints the
scale so the difference is visible rather than averaged away:

```
coverage(reading, 0.95): 14% of running text, over 519 words
                         (opensubtitles_en, need 95%)
```

**What that number says about a word list.** The top 100 words of English
cover 59% of running text. Our 519 A1 words cover 14%. The difference is
that the A1 list is nouns, verbs and adjectives — *people, family, water,
mother* — and coverage lives in function words: `the`, `to`, `a`, `of`,
`and`. That is not a defect in the list, which was curated to be teachable
on day one. It is a fact about what coverage measures. Going from 100 words
to 519 moved coverage from 5.60% to 13.57%: eight points for four hundred
content words, against thirteen pronouns worth fifteen points on their own.
The queue of those is
[docs/langpop-function-words.md](docs/langpop-function-words.md).

### The gap report

"The graph is short 1,800 words" is true and useless. `--gap` inverts the
frequency import: walk the list, drop every word the graph already teaches
**at any level**, and print what is missing ranked by what each word buys —
its share of the corpus, and the coverage the graph would reach if
everything down to that row were added.

```sh
./langpop import --source frequency \
     --gap --file ~/langpop-upstream/en_50k.txt --lang en [--top 40]
```

```
gap: the graph answers 530 of the list's words, and they carry
gap: 13.57% of the corpus

   rank  share   if-added  word
  1      3.97%   17.54%    you
  2      3.74%   21.28%    i
  3      3.14%   24.42%    the

not in the queue, because there is nothing to teach:
  23 tokeniser shards, 6.39% of the corpus -- 's 't 'm don 're 'll ...
```

Each row is annotated with what a curator needs in order to judge it.
English rows say when a token is probably an inflection of a word already
taught (`drinking` → *may be a form of e_drink*); Japanese rows carry the
price tag (`大丈夫` — *needs 2 kanji not in the graph*).

Contraction halves are taken out of the queue and counted under the table,
because *don't* tokenised into `don` and `'t` is two things nobody can
teach and they would otherwise hold the top of the report for ever. The
rule is two closed lists rather than "has an apostrophe": the broader rule
caught `'em`, `'cause` and `'bout`, which are real spoken words at a rank a
curator should see.

**It is a report, not an import.** Adding a word is curation — an id, a
level, a gloss — and nothing here mints any of those. Nothing is written.

Japanese rows need one more thing. The corpus is tokenised, so a verb
arrives without its ending — 話す appears as 話, 分かる as 分か — while the
graph holds the dictionary form. Without stemming, the report lists the
stem of every verb already taught as a gap. Measured on the Japanese list:
3.90% of the corpus credited, 5.16% held by a stem and wrongly called
missing, 9.06% genuinely absent.

**For Japanese, read the annotations and ignore the shares.** The
annotation — *needs 2 kanji not in the graph* — is computed from the graph
and is sound. The `share` and `if-added` columns are computed from a list
that is missing its most frequent words (see above), so they are inflated
by an unknown amount and their ordering is unreliable. The English side is
unaffected.

---

## Teaching aids the student controls

Five aids, each one switchable:

```
Aoi> :aids
    on  slip   one more go when a typed answer looks mistyped
    on  oops   :oops takes back the answer you just gave
    off later  puts a question off until later today
    on  glyph  draw a complicated character big the first time
    on  say    after you answer, I say it aloud
```

`say` plays the item's recording once a reading, counting or choice answer
is in, so a sitting spent reading is also a sitting spent hearing: the
words arrive at the listening half of the rung already familiar. It plays
after the clock has stopped, so it is no hint and costs no speed, and only
recordings already made (`--audio <level>`) are used. `:audio off` silences
it with everything else.

`:aids later off` takes one away. **An aid that cannot be refused is
indistinguishable from a lower standard**, and a learner who suspects they
are leaning on one has no way to find out except to take it away. So they
are the student's to switch, not the tutor's.

They are recorded rather than policed. Every change is logged with its
time, and every journal entry already carries one, so what was available at
any given answer is reconstructible exactly. `:status` names anything
switched off, so a number is never read without knowing which standard
produced it.

### A typing slip is not a wrong answer

A Japanese learner is typing romaji, or fighting an input method they do not
know well, and a slip of the fingers is not a gap in their knowledge.
Recorded as wrong it costs them 0.70 of a belief and teaches the tutor
something false — the probe ends up measuring typing rather than reading.

**Offered, not forgiven.** The first near miss on an item is not recorded at
all; the student gets one more go.

```
一    ->   hto
Typing, I think, not reading.  Once more:
一    ->   hito
そうです。
```

Taking `hto` *as* ひと would credit an answer they never produced. The point
is to let them fix it, not to score it for them.

**Nothing is revealed, because the tolerance is proportional with no floor:**

| answer | length | slips allowed |
| --- | --- | --- |
| `ka` | 2 | **0** |
| `yama` | 4 | 1 |
| `yuubinkyoku` | 11 | 2 |

That zero is the important one. For a two-character answer any edit is a
*different answer* — `ke` is not a slip for `ka`, it is the wrong kana — so
short answers get no tolerance, and with it no hint that they were close.

An exact match wins first, and so does a confusable partner: typing the
other half of a pair the graph records is a knowledge error however few
letters apart the two are. The clock runs from the **first** attempt, so a
deliberate slip cannot buy thinking time.

### Taking an answer back, and putting one off

`:oops` is for what the slip detector cannot catch — an input method that
ate the line, enter hit a word early. It takes back the last answer, puts
the question back in the queue, and restores *every* belief that answer
moved, which is more than one: a correct answer also credits the characters
written inside the word, so undoing it has to undo those too.

```
before:        誕生日=0.0   生=0.0   日=0.0   journal=0
after answer:  誕生日=0.45  生=0.45  日=0.45  journal=3
after :oops    誕生日=0.0   生=0.0   日=0.0   journal=0
```

One answer deep, and only within the session.

`later`, typed at a question, puts it aside. The difference from a skip
matters:

| at a question | means | recorded? |
| --- | --- | --- |
| *enter* | "I do not know" | **yes** — a skip, and it counts in the denominator |
| `later` | "not this one, not now" | no |

Pressing enter is the most informative thing a beginner does. It is what
stops a placement descent, and a student who could raise their accuracy by
answering only what they knew would be measuring the wrong thing. So it
stays recorded.

Neither route re-asks the item immediately:

```
あ   ->  later
後で。Put it aside -- I will bring it back.
い   ->  i        そうです。
う   ->  u        そうです。
え   ->  e        そうです。
  Back to this one.
あ   ->
```

Three questions in between. `:oops` is used *after* the tutor has said what
the answer was, so asking again straight away would measure the echo rather
than the memory. `later` is allowed twice per item, and then the question
has to be answered — without a limit, it is a way never to be wrong about
anything.

### Drawing a complicated character

A terminal cell gives a glyph about twenty pixels of height, and it gives
the same twenty to あ and to 聞. あ is a handful of strokes in the em box;
聞 is fourteen, and at that size the gaps inside 門 fall below one pixel and
are not drawn small but dropped. That makes a wrong answer ambiguous: the
student may not have known the character, or the terminal may not have
drawn it.

So a complicated character is drawn as a picture the first time it is met,
and the rule comes out of the graph rather than out of a list:

- **The stroke count is already there.** KANJIDIC2 carries it and the
  importer keeps it, so "is this too detailed for a terminal cell?" is
  answered from an imported fact.
- **A word takes the worst character written in it.** 電話 is two
  thirteen-stroke characters, and the hardest glyph on the card is what
  decides whether the card is legible.
- **Eight strokes is the line**, which takes in 29 of the 103 N5
  characters and leaves 日, 山 and 口 in the terminal where they are
  perfectly legible.
- **The first meeting only.** Reading 聞 at terminal size is itself a
  skill, and a tutor that draws it big every time is one the student never
  has to learn it from. This is the first time *ever*, counted from the
  journal, not the first time today.
- **The picture goes up before the clock starts**, because every criterion
  carries a response-time floor.

It uses the `glyph` card style — the character alone on a square — rather
than the word card, which carries the reading and the gloss and would give
the answer away.

---

## Placement

> *"A teacher will jump right into 'go ahead and introduce yourself.' A
> true beginner will freeze. If they answer properly, the teacher keeps
> going — 'what day is it today?' — until they work out which section this
> person belongs in."*

The point is not the questions. It is that the teacher **starts above**
where they expect and lets failure locate the student, and that a freeze
ends that line of questioning.

`:place` in the terminal, `langpop/placement.next` on the wire.

**Placement is not a teaching mode.** It is a fast way to populate the
student record, and everything downstream already works off that record:
the chooser takes the lowest belief first, so a correctly placed student
gets their weak spots immediately and skims what they know. Which means
there is no placement state anywhere — `lp_place_next/0` is a pure function
of the evidence already recorded, so a client asks what to ask, answers it
through the ordinary `langpop/answer`, and asks again. A dropped connection
costs the one question in flight.

**One scalar would be the wrong answer.** A learner who knows 500
characters and keeps forgetting katakana is not *at* any single level, and
placing them by one number would either drown them or bore them. So the
search runs per **axis**, and the axes are the exit criteria — a ladder that
adds a criterion gets an axis for free:

```
kanji              : up to n5           <- knows kanji
vocabulary         : up to preschool    <- thin at N5
recognise katakana : below the ladder   <- froze on シ/ツ, ソ/ン
recognise hiragana : up to preschool
skill mora_sokuon  : nothing here I can ask about

teach at: preschool
```

Twenty questions. The level is **derived**, not chosen: the lowest rung
that still has an axis the student has not passed. The characters they
proved they can read sit near mastery in the record, so they are not taught
again.

Four things make it cheap, and each one comes out of the graph rather than
out of a parameter:

- **It samples across a difficulty scale.** Probing 103 characters one at a
  time to find out whether somebody reads characters is absurd; four spread
  along frequency rank locate them — 日, 上, 話, 聞.
- **Where there is no scale, confusable items come first.** A katakana test
  made of ア and ヲ certifies everybody. シ against ツ and ソ against ン is
  where forgetting actually shows, and the graph already records which 18
  pairs those are.
- **A freeze ends an axis**, after two. That is the behaviour the whole
  thing is modelled on, so the loop asks **one** question and looks again.
- **Passing high means nothing below gets asked.** Failing drops one rung
  and asks again. That is the descent.

---

## Things to print

```sh
./langpop --chart hiragana      # also katakana, youon
./langpop --sheet --user bob    # today's work
./langpop --zine --user bob     # the study plan, as a booklet
```

and `:chart`, `:sheet`, `:zine` inside a session. Everything is A4 SVG —
`width="210mm" height="297mm"` with a viewBox in tenths of a millimetre —
so a browser's print comes out on real paper rather than on a 96dpi guess.

### The charts are generated from the graph

A kana chart downloaded from somewhere is a picture of somebody else's
table. It can disagree with ours and nothing would notice, it carries
whatever licence it carries, and it goes stale the moment the graph
changes. A chart drawn from `kana/5` cannot disagree with the tutor,
because it is the same 138 facts the tutor reads.

The grid is derived too. A cell's **column** is the last vowel letter of
its romaji — `ka`→a, `shi`→i, `tsu`→u, `fu`→u — and its **row** is the row
named in the fact. A hand-placed grid would be a second copy of the table,
free to disagree with the first, and it would have quietly filled in the ぢ
and づ cells that are supposed to be empty.

The youon sheet derives its 33 combinations the same way: every kana whose
romaji ends in `i`, bar い itself, crossed with small ゃゅょ. The romaji
comes from the engine's own rule, so the sheet says `sha` and not `shya`.

The modifiers sit in a strip along the foot of the chart, separated by a
rule, labelled with **what each one does** rather than with a reading it
does not have — and each is drawn beside its full-size twin, in grey,
because the difference is the size and nothing else:

```
ヤャ              ユュ              ヨョ              ツッ              ー
joins the one     joins the one     joins the one     a beat of        lengthens
before            before            before            silence          the vowel
```

A learner meets っ in がっこう on day three, so a reference sheet that
leaves it off is a reference with a hole in it.

### Today's sheet reads the journal

```
Today, Sheet Tester                                        2026-10-21

What you worked on
 +  日     day, sun, Japan, counter for days                    900 ms
 +  山     mountain, hill                                      1380 ms
 +  が     ga                                                  1860 ms
 ?  ウ     u                                                   5200 ms
 ~  そ     so                                                  2400 ms
 x  ぬ     nu                                                  3100 ms

Worth another look
ウ カ そ ぬ

Next time
あ  い  う  え  お

+ right  ~ near miss  ? did not know  x wrong.
Drawn from your own answers, on this machine.
```

A sheet of beliefs would show the same thing every day with the numbers
slightly different. A sheet of the **journal** shows the session. One row
per item carrying the outcome that stands — an item got wrong and then got
right prints once, and prints right — in the order the questions were
asked.

The four marks are the four outcomes, and `?` is deliberately not `x`:
saying *I do not know* is the most informative thing a beginner does, and a
sheet that crossed it out would be teaching them not to.

### The booklet

Eight pages from one sheet of A4, printable at any time, because the plan is
a function of the student record and the record is always current.

| page | |
| --- | --- |
| 1 | cover: name, language, level, date |
| 2 | **where you are** — the placement report, axis by axis |
| 3 | **how it is going** — this level's exit criteria, measured |
| 4–5 | what is next, weakest belief first |
| 6 | the ladder, with a mark where you are |
| 7 | worth another look |
| 8 | how to fold it, and what the marks mean |

```
  1. A4 landscape.  Fold in half left-to-right, again, and again:
     eight panels, four columns by two rows.
  2. Unfold.  Fold in half top-to-bottom and cut the centre fold
     across the middle two columns only.
  3. Open, fold lengthwise, push the ends together so the cut opens,
     and collapse into a stack.
```

Which gives the imposition, and it is a consequence of the folding rather
than a design choice:

```
     top row, upside down:   5   4   3   2
     bottom row, upright:    6   7   8   1
```

The cut line spans the middle two columns **only**. A dashed line the full
width would be an instruction to cut the booklet in half.

**The booklet speaks the language the reader can read.** Printing one for a
Japanese speaker learning English is what showed the problem: every heading
on the first draft was in English, which is the one language a beginner
English learner cannot be assumed to read. This is the metalanguage problem
the project started from, turned round — *a question about grammar in
Japanese will be too challenging because the vocabulary used to talk about
grammar exceeds beginner level.*

So the navigation is in the **other** language from the ladder being
climbed:

| | `--lang ja` | `--lang en` |
| --- | --- | --- |
| cover | Study plan | 学習プラン |
| page 2 | Where you are | いまの実力 |
| page 3 | How it is going | とちゅう経過 |
| page 6 | The ladder | レベル表 |
| page 8 | Fold it | おりかた |
| the cut line | cut along here | ここを切る |

**The cover motto is the one exception, and it goes the other way.** A
single phrase in the language being *learned* — がんばって — is a flourish
the student will meet soon and can be proud of reading. Navigation in that
language is a booklet they cannot use.

Page 3 prints the same figures as `:status` and page 2 the same as `:place`,
from the same procedures, because two renderings of one number is one too
many: the paper would drift from the screen and nobody would notice which
was right.

### Cards

```
:card hi_a
{"method":"langpop/card.render","params":{"item":"w_neko"}}
  -> {"item":"w_neko","style":"word","path":"…/cards/w_neko-word.svg",
      "width":640,"height":400,"format":"svg"}
```

The term is the form the student has to recognise, and the line above it is
whatever helps them get there. Which form that is depends on the item:

| Item | Term | Above it |
| --- | --- | --- |
| kana grapheme `hi_a` | あ | `a` |
| starter word `w_gakkou` | がっこう | `gakkou` |
| N5 word `w_yama` | 山 | やま |
| loanword trap `t_mansion` | マンション | `manshon` |
| sound contrast `s_r_l` | `/r/ - /l/` | ラ行では区別されない |
| written confusion `m_rice` | `rice / lice` | 米とシラミ |

The term is the form in the **item's own** language, and the gloss is in
the **learner's** — a Japanese item glossed in English, an English item in
Japanese. A sound contrast has an IPA form and nothing else, so the IPA is
the term, and the line above it is the Japanese gloss, because the point of
the card is the distinction the learner's own language does not make.

Three details that are not decoration: the term shrinks to fit, and the
fitted size is floored rather than rounded, because rounding up is how a
fitted term still overflows by a point or two; a gloss that only repeats
the reading is dropped, because a kana grapheme's English gloss *is* its
romaji; and each font family is quoted, because an unquoted multi-word
family name is not valid CSS and a strict renderer drops the whole list.

Cards are SVG. The text is drawn from the font by the viewer, named as a
family rather than rasterised here, so the output is deterministic and
diffable; it opens on all four platforms with no graphics build; and it
carries its own provenance line. The rule the design asked for survives: *if
the output contains text the student is asked to read, it came from the
font.* Stroke-order animation is the one style SVG cannot do, and it answers
with its own error code so a client can tell "that does not exist yet" from
"you asked wrongly".

In a session the card goes **in the terminal** rather than in a window,
because opening a viewer mid-question takes the focus off the thing the
student is being asked to read. `tools/term-image.py` speaks the kitty
graphics protocol (kitty, ghostty, WezTerm, Konsole) and iTerm2's inline
images, rasterises with whichever of `rsvg-convert`, ImageMagick or
`qlmanage` is installed, and distinguishes its failures in its exit status:

| | |
| --- | --- |
| 0 | drawn |
| 2 | this terminal has no image protocol |
| 3 | no SVG converter installed |
| 4 | the file is unreadable |

`2` is a terminal to name in a one-line hint; `3` is a missing
`rsvg-convert`. Either way it is said once per session, and the character is
still printed, just small.

---

## Sound

Sound arrives in three pieces, and they are three different claims.

### Playing it

```sh
./langpop --audio preschool
./langpop --audio preschool --rate slow
```

```
audio: 188 made, 0 already cached in ~/.langpop/audio/ja/
  8 not said: no_spoken_form
  3 not said: has_blank
audio: listen at ~/.langpop/audio/ja/listen-preschool.html
```

The first audio to exist is **output**, and it carries no verdict. A learner
has little exposure to correct pronunciation, so asking someone to produce a
sound we declined to let them hear is a test of material we never taught.

**The voice is a command, not a dependency.** It is named in
`~/.langpop/audio.conf`:

```json
{"ja": {"cmd":   "kokoro --voice %v --speed %r --text-file %i --out %o",
        "voice": "jf_alpha",
        "model": "kokoro-82m-v1.0",
        "rates": {"slow": "0.7", "normal": "1.0", "fast": "1.3"}}}
```

`%i` is a file holding the text, `%o` the wav to write, `%v` the voice, `%r`
the rate. **The text goes through a file and never onto the command line**:
the words are Japanese and the shell is not, and a quoting bug in a tutor
would be a quoting bug in whatever the shell made of ひらがな.

Nothing is installed, imported or vendored. A machine with no model
configured answers `no voice for ja` and goes on teaching exactly as it did,
which is the state every fresh checkout and every CI run is in. macOS's own
`say -v Kyoko` is a usable way to see the pipeline work before wiring a
teaching voice up — not a teaching voice itself, but something to compare one
against, which is easier than judging a voice in the absolute.

On a Mac, use the **Enhanced** Kyoko if it is installed (System Settings →
Accessibility → Spoken Content → System voice → Manage Voices). It records
two to three times louder than plain Kyoko and is much easier to follow:

```json
{"ja": {"cmd": "/usr/bin/say -v 'Kyoko (Enhanced)' -r %r -f %i -o %o --file-format=WAVE --data-format=LEI16@22050",
        "voice": "KyokoEnhanced", "model": "macos-say",
        "rates": {"slow": "110", "normal": "150", "fast": "190"}}}
```

Changing the voice, its rate or the lengthening leaves the old recordings
on disk, unused. `./langpop --audio-clean` counts them and
`./langpop --audio-clean --yes` removes them; recordings the present
configuration would play are never touched, and neither is anything that
is not a recording.

`voice` is only a label for the recordings' filenames, so keep spaces and
brackets out of it; the real voice name goes in `cmd`. After changing the
voice, run `./langpop --lang ja --audio preschool` again so the recordings
are remade in it. Listening questions are only asked about words that have
a recording.

Don't expect the rate to make much difference. With this voice, 150 instead
of 175 makes a word about 6% longer, and even 90 adds only about 20%. A lone
kana stays at about a tenth of a second at every rate.

**A kana said alone is too short to learn from**, and the voice cannot be
asked for a longer one. So a voice may name a command that lengthens it
afterwards:

```json
        "rates": {"slow": "110", "normal": "150", "fast": "190"},
        "lengthen": {"cmd": "/opt/homebrew/bin/sox %i %o tempo %f 20 8 6", "min_ms": "250"}}}
```

Every one-beat recording shorter than `min_ms` is stretched up to it (the
pitch is kept), each by its own amount, so う and し both come out at about
a quarter of a second. Words are never touched: how long a word takes is
part of what is being taught, and きて against きって is told apart by
nothing else. It needs [SoX](https://sox.sourceforge.net) (`brew install
sox`); without the entry, or if the command fails, the voice's own
recording is used. Run `--audio preschool` again after adding or changing
it, and take the entry out and run it again to go back.

**`model` is declared, not detected**, because an external command cannot be
asked what weights it loaded. The declaration is part of the cache key:

    ~/.langpop/audio/ja/hi_a-Kyoko-slow-3936002.wav

`{name, voice, rate, model, text}` — four of them in the filename and the
text as a hash. The key being the filename means there is no index to keep
in step with the directory: a corrected form writes a new name, and the old
file simply stops being reachable rather than being served to a student as
the reading of a word we have since fixed. Beside each wav is a sidecar JSON
naming the item, the text, the voice, the model and the command that made it.

**Nothing is synthesised inside a question.** `--audio <level>` makes the
files ahead of time; asking only ever reads the cache. 188 items took 89
seconds with `say`, nearly all of it process startup — half a second is not
much, and half a second in the middle of a question is a tutor that feels
broken.

**What has no sound, and why that is right.** Skills are abstractions and
have no utterance. Sentence patterns contain a gap, and a voice would either
read the gap aloud or swallow it, so the student would hear a sentence that
is not the item. Japanese is read from **kana**, never romaji: a voice handed
`gakkou` reads English. English is read from the latin form and **never from
the IPA**, which is a notation rather than a word — a voice handed `/wɜrld/`
says something, and it is not *world*. That last one means a sound contrast
has no sound of its own, which is correct: `/l/` is not something a voice can
pronounce in isolation. It is heard through the words that exercise it, and
the graph already links them.

**The rate is a name, not a number.** Kokoro takes a multiplier where `1.0`
is normal; `say(1)` takes words per minute where `175` is normal; the next
engine will take a percentage. So the scale belongs to the engine and the
name belongs to us. `:rate slow` persists in the profile beside the aids,
because a beginner who has asked for slow should not have to ask again
tomorrow.

And one caveat the tutor states rather than hides. Japanese length is
*contrastive* — きて and きって differ by a beat of silence, and four of the
mora skills exist to teach exactly that. Every TTS engine stretches durations
under a rate change, and none of them promises to stretch a geminate closure
by the same factor as the vowel beside it, so at `0.7` the student may be
hearing a ratio the language does not have:

```
Aoi> :say w_gakkou slow
  ~/.langpop/audio/ja/w_gakkou-Kyoko-slow-4821930.wav  (slow)
  Length is contrastive in this one.  Hear its RHYTHM
  at normal rate -- a slowed voice stretches the beats
  and not always evenly.
```

Slow is the right setting for finding the *segments* in a word and the wrong
one for learning its *rhythm*. Those are two lessons on one item.

### Hearing it

Hearing and producing are not the same problem. Producing a sound needs a
microphone, a phoneme model and a verdict. *Hearing* one needs a speaker.

A listening question plays the word and the student types what they heard.
The grading is exact match on a typed answer, exactly as for reading, so it
needs no new evidence tier — the only machine in it is the one that spoke.

```
Aoi>
  LISTENING.  You will hear one word.  Type it in romaji or kana.
  聞いてください。(Please listen.)   (again = hear it again)
  ->  again
  もう一度。
  Listen.   (again = hear it again)
  ->  neko
  そうです。  ねこ
```

**Every question starts by naming its mode.** A sitting switches between
reading, listening, meaning, counting and pictures every few questions, so
one fixed line in capitals says which it is, what will be shown or played,
and what to type:

```
  READING.  How is this kana said?  Type it in romaji.
  LISTENING.  You will hear one kana.  Type it in romaji (a, ka, shi ...).
  LISTENING.  You will hear ONE of these two words.  Type the number of the one you heard.
  MEANING.  Which word means this?  Type its number.
  COUNTING.  Count the beats in this word, and type the number.
  PICTURE.  Look at the picture.  Type the number of the sentence that describes it.
```

This line is an instruction, so it is always worded the same; the teacher's
own lines vary and never stand in for it. It used to be missing. A student
who reads Japanese saw 「聞いてください。What did you hear?」 above a
listening question and listened for someone saying *kiite kudasai*, when
what was coming was a single kana. A student whose own language is
Japanese (the English track) gets the line in Japanese with the same
sentence in English beneath it, so the two cannot say different things:

```
Mr Hill>
  聞き取り：下の二つの単語のうち、一つを言います。聞こえた方の番号を書いてください。
  LISTENING.  You will hear ONE of these two words.  Type the number of the one you heard.
  Listen.   (again = hear it again)
    1) breeze
    2) breathe
```

Every listening question says how to replay it, beside the question.

If you didn't hear anything, type `again`. The sound plays again and
nothing is marked.

Every recording is played with 0.4 seconds of silence in front of it. A
kana lasts about a fifth of a second, and a speaker or headset that has
been idle for a few seconds takes some time to wake up. Without the
silence, the kana could be over before the speaker was ready, especially
over Bluetooth. The silence is added only to what is played; the stored
recordings are unchanged.

Quiet recordings are also turned up as they are played. The Japanese voice
records at about a third of the English voice's level, and a kana that
short and that quiet can be missed entirely on a laptop speaker. Each
recording is raised until its loudest moment is near full volume. Loud
recordings are never turned down, and no recording is raised more than
eight times, so a nearly silent one does not become hiss. As with the
silence, only what is played changes.

`again` is free and unlimited. The written form appears **after** the
answer, never before: a listening question has nothing to read, and the
glyph is the other half of the item the student has just recognised by ear.

**Hiragana are asked by ear too**, once the student can read them. A kana
has one sound, so the question is the simplest there is: Aoi plays か and
the student types `ka`. This puts listening into the very first Japanese
sittings, not only after whole words have been learned to read. Katakana
are not asked by ear, because ア sounds exactly like あ and the question
would be the same one twice. を isn't either, because it sounds like お
but its answer is `wo`, so a student who heard it correctly would be
marked wrong. No exit criterion counts these answers; they are practice
for the ear.

```
Aoi>
  LISTENING.  You will hear one kana.  Type it in romaji (a, ka, shi ...).
  Listen.   (again = hear it again)
  ->  a
  そうです。  あ
```

**Length is asked by ear too.** Counting beats (COUNTING, いっしょ → 3) is a
reading exercise, much like the JLPT's written questions, where a wrong
reading is often the right one with a beat added or taken away. Hearing
the beat is a separate skill, and the listening paper depends on it:
きて and きって are different words. So each length feature is also a
sound contrast, unlocked once its counting skill is known:

| contrast | pairs |
| --- | --- |
| `l_sokuon` small っ | きて/きって, おと/おっと, さか/さっか, かた/かった |
| `l_long` long vowel | おじさん/おじいさん, ゆき/ゆうき, とり/とおり, くき/くうき |
| `l_moraic_n` ん | みな/みんな, こな/こんな, たに/たんに, きねん/きんえん |

```
Aoi>
  LISTENING.  You will hear ONE of these two words.  Type the number of the one you heard.
  Listen.   (again = hear it again)
    1) きって
    2) きて
```

These are practice for the ear; no exit criterion counts them yet.
おばさん/おばあさん, the textbook pair, is left out because the current voice
says both in the same 660 ms. Run `./langpop --lang ja --audio preschool`
after adding a pair, so its words get recordings.

A sound contrast becomes a two-option question instead, because a contrast
is not a word and there is nothing to type:

```
Mr Hill>
  聞き取り：下の二つの単語のうち、一つを言います。聞こえた方の番号を書いてください。
  LISTENING.  You will hear ONE of these two words.  Type the number of the one you heard.
  Listen.   (again = hear it again)
    1) boat
    2) vote
  ->  1
  Not yet. We will return to it.  It is vote -- /v/ - /b/.
```

There is no typing version of that question. A student who cannot hear /r/
from /l/ cannot type the difference either, and asking them to spell it
would be testing spelling.

Four conditions, all of them load-bearing:

- **A voice must be installed.** Otherwise the criterion goes on saying
  `needs_audio` rather than reporting a listening vocabulary of zero, which
  would read as a student who failed instead of a tutor that cannot ask.
- **The sound must already be cached.** Asking never synthesises.
- **At the normal rate.** A slowed voice is an easier exposure, and for the
  geminate words it is a rhythm the language does not have. Slow is for
  studying; the measurement is at `normal`.
- **It must actually play.** A question that could not be played is **not
  marked at all**. Asking *what did you hear?* of somebody who heard
  nothing, and then filing the answer, would record a failure of this
  machine as a failure of the learner.

**The pool is words the student has already read.** A word leaves the
teaching plan the moment it is mastered on `read`, so a listening question
drawn from the plan could never reach it — but `vocabulary(50, hear)` is
measured over the same fifty words as `vocabulary(50, read)`. So the pool is
words already read-mastered, not yet heard, and with audio cached. Which is
also the right teaching order rather than merely the convenient one:
recognising by ear a word you cannot read is a harder and different task,
and no criterion in the graph asks for it.

One question in four is by ear, and the last one in a level is by ear too —
a ratio rather than *listening once the reading is done*, because otherwise
a student with reading left would never practise listening and the criterion
would only start moving at the very end.

**A sound contrast skips the read-first rule**, because it has nothing to
read: its channels are hear and speak, and it is heard or it is nothing. The
pool requires read-mastery only of items that *can* be read. Before that
distinction, no contrast ever entered the listening pool, the one-in-four
slot served nothing in the English track, and a session's audio stopped the
moment the plan ran out of unseen contrasts — with the two contrasts the
student had just missed parked behind every silent unseen item. Now the slot
brings back the weakest ear first, which is exactly the contrast that was
just got wrong.

### When there is sound, and turning it off

Sound plays in three places:

- **A listening question.** About one question in four is asked by ear. In
  Japanese that is a single hiragana kana (あ, ゆ, が …), so what plays is
  one short syllable and then nothing more. That is the whole question.
- **After an answer.** Once a reading, counting or choice answer is in, the
  item is said once (`:aids say off` stops this).
- **`:say <item>`**, whenever the student asks for it.

A reading question is never read aloud before it is answered.

```
Aoi> :audio off
  Sound off.  No listening questions until :audio on --
  whatever needs your ear waits for it.
```

`:audio off` is for a library, a train or a sleeping house. While it is off,
no listening question is chosen and `:say` declines. Reading carries on as
before. Anything that needs the student's ear waits, unasked, rather than
being marked wrong. The switch is kept in the profile, like `:rate`, so it
is still off tomorrow. `:audio on` turns it back on, and `:audio` says which
it is.

**Waiting is not the same as excused.** A machine with no voice cannot ask
a listening question at all, so the listening half of a level is excused
there and `:status` names it as "not checkable here". A student who has
turned the sound off is on a machine that *can* ask, so the listening half
waits for them: the level is not finished without it, and `:status` says
"listening is waiting".

**A muted speaker is treated the same way.** On a Mac the tutor checks
whether the sound is muted or turned down to nothing before it asks by
ear. If it is, no listening question is asked, nothing is marked, and the
student is told once:

```
  Your sound is muted, or turned right down, so I will not ask
  listening questions -- you would be marked on what you could
  not hear.  Turn it up and they come back.  Reading goes on.
```

The tutor never changes the volume itself. Other systems are not checked;
there, `again` at a listening question is still the remedy.

### Speaking it

`:speak` is the one channel that wants a microphone, and it is **not**
`produce`: producing is composing a sentence, which a pattern item asks
for and a keyboard can answer; speaking is making the sound.

```
Aoi> :speak w_kitte

  Say it: きって
  (enter to record, and hold the small っ)  ->
  The held beat is there: 200 ms of silence against a 130 ms mora.
  (machine verdict, confidence 0.184 -- capped at 0.77, because a
   confident model is still a model)
```

**It checks one thing: whether the held beat is there.** The geminate っ
of きって is a beat of silence, and silence is what a recording's energy
envelope can actually measure. Everything else a teacher might want
scored — vowel quality, pitch accent, whether /r/ came out as /l/ — this
build does not attempt. The calibration behind the one measurement, and
why the obvious plan of counting beats does not work, is in
[DESIGN_NOTES.md](DESIGN_NOTES.md).

**It will sometimes decline a pronunciation that was correct**, and a
student who said the word properly deserves an answer about why. The beat
is measured against the word's own average beat, and the two populations
overlap: しゅっぱつ holds its beat for a full 170 ms, which is right, but its
other beats are long too, so the ratio lands among the words that dropped
it. Rather than guess, the scorer says *I could not tell* and moves no
belief in either direction. Seven of the thirty-nine checks in
`--voicetest` come back that way on this machine's voice, and those words
are where a teacher's ear is worth more than the measurement.

**Some words it declines on principle.** いっしょ is `[iʃːo]` —
the mora is a lengthened `[ʃ]` with energy all the way through, so there
is no silence to time. That is a fact about Japanese, and the engine knows
the following kana, so it says so instead of asking a question it cannot
mark:

```
Aoi> :speak w_issho
  いっしょ holds a fricative rather than a silence -- っ
  before し is a long し, so there is no gap to time.
```

**Check the room before you trust a verdict.** A held beat *is* silence,
so a fan fills in the very thing being measured and the verdict comes
back `wrong` for a learner who did nothing wrong. `:mic` shows what the
scorer sees:

```
Aoi> :mic
  Say anything -- a word, a count to three.  I will show you
  the level and the silences the scorer would see.
  (enter to record)  ->
  peak    -9.8 dBFS  =============---------------------------
  rms    -25.8 dBFS  ==--------------------------------------
  floor  -88.7 dBFS  ----------------------------------------
  heard 0.33 s of 0.37 s recorded
  silences inside it: 100 ms

  ▂▅▆▆▅▄▃    ▁▂██▇▃
         ^^^^^        <- silence the scorer times (longest 100 ms)

  level is good
```

The `^` marks the silence the scorer times, so the difference between
きって and きて is something a student can **see** before anyone argues
about the verdict. Above −35 dBFS on the floor line the meter says `THE
ROOM IS NOISY` rather than letting the scorer blame the student, and
`:speak` shows the meter itself on anything but a clean `right`, because
that is when attribution matters. A microphone that is not working is
reported as such:

```
  heard 0.00 s of 0.40 s recorded
  NOTHING REACHED THE MICROPHONE -- not one non-zero sample.
  Check the input device, the cable, and that the terminal
  has microphone permission.
```

**Both ends are commands**, on the same terms as the voice, and neither is
per-language — a microphone is a microphone, and the scorer is told the
language in the request:

```json
"record":  {"cmd": "rec -S -r 16000 -c 1 -b 16 %o trim 0 %s", "seconds": "2"},
"verdict": {"cmd": "python3 tools/score-morae.py --request %q --out %v"},
"meter":   optional -- defaults to tools/mic-level.py
```

With neither configured, `:speak` says so and records nothing.

**A recording of somebody's voice is the most sensitive thing this project
touches**, so the sample is scratch: written under the data directory,
scored, and deleted, along with the request and verdict files beside it.
Nothing keeps it and nothing uploads it. The only reason it is a file at
all is that the scorer is a separate process.

A machine verdict is its own kind of evidence — the student spoke,
something measured it, and nobody listened — so it is capped at 0.77,
below a teacher's check. `near` from the scorer is not a near miss on
spelling; it is the confidence floor, *I could not tell*, and it moves the
belief in neither direction.

**`:speak` is not wired into the teaching loop.** No criterion on any rung
asks a student to produce a sound, so a tutor that started demanding it
would be grading something the ladder never promised. The capability
exists; the criteria do not. Whether the ladder should declare them, and
at what threshold, is a curation question and an open one —
[docs/langpop-production-criteria.md](docs/langpop-production-criteria.md).

---

## The protocol

`server.p` serves JSON-RPC with line framing — one JSON value per line,
which is what MCP uses over stdio, so an MCP host can speak to it with no
shim. `--port N` for TCP, nothing for stdio.

| Method | |
| --- | --- |
| `langpop/recognise` | is this somebody we know? — before registration |
| `langpop/register` | a student, by username; no password, because this is a local tool |
| `langpop/session.open` / `session.close` | a session is a row, not a process |
| `langpop/plan` | what is ready now, and why that order |
| `langpop/next` | the question — **and not its answer**. With `practice: true`, one of the items `:status` names as slow or missed instead; the reply carries `phase: "practice"` and the `limit_ms` it is held to, and its answer is recorded but moves nothing |
| `langpop/answer` | the judging, which stays on this side |
| `langpop/explain` | the derivation: prerequisites, provenance, belief |
| `langpop/status` | the level's exit criteria, measured. Each measured criterion carries `to_work_on` (the items whose latest review was slow or wrong, with form, outcome and time) and `not_reviewed` |
| `langpop/placement.next` / `placement.report` | find out where they are |
| `langpop/aids` | which helps are on, and switching them |
| `langpop/audit` | which rungs of the ladder are hollow |
| `langpop/card.render` | the item as a picture |
| `langpop/sheet.render` | a page to print: a chart, today, or the booklet |
| `langpop/audio.text` | **what to say**, with nothing about who says it |
| `langpop/audio.say` | the sound file for an item, if one is cached |
| `langpop/audio.fetch` | **the sound itself**, for a client with no disk in common |
| `langpop/image.fetch` | **the photograph itself** — the `see` channel's only method |
| `langpop/assign` / `report` | work to do elsewhere, and what came of it; `again` marks a reply that is a reminder of outstanding work rather than something new |

Three things are deliberately on the server's side of the line, and each one
is a property the design would lose if it moved. One thing is deliberately on
the client's, for the same kind of reason.

**The answer never leaves.** `langpop/next` returns the prompt; the client
cannot tell whether what the student typed was right until `langpop/answer`
says so. A protocol that hands over the answer key is a quiz file, not a
tutor, and no later check of it means anything.

**The clock is the server's.** `langpop/next` starts it, `langpop/answer`
stops it. Every pre-school exit criterion has a millisecond budget, and a
client that could send `latency_ms: 1` would make the speed half of each one
worthless. The reply says which clock was used (`latency_source: "server"`),
and the client's own figure is a fallback for a caller that never asked a
question — a batch import, a test.

The one clock the client *does* own is the sitting: `:time` says how long
this session has run and how many questions were answered in it. That is not
evidence about any item and is sent nowhere — it is the number the server
cannot supply, because the server knows when the session was opened and not
whether the student is still in the chair. When `:status` has been asked and
the schedule suggested a sitting length, the client says so once on reaching
it.

**The sitting clock stops when you leave the keyboard.** A silence longer
than a minute is not counted, from the minute onwards — so a phone call in
the middle of a sitting costs the sitting nothing, and `:time` does not
report an hour and a half for twenty minutes of work. The first minute of
every silence *is* counted, deliberately: thinking about a question is the
study, and a clock that stopped the moment you paused would be measuring
typing speed. When anything has been deducted, `:time` says how much:

```
  20:14 at the keyboard, 38 question(s) answered
    about 31 seconds a question
    (1:06:22 of it away from the keyboard, not counted)
```

The same minutes are kept out of the answer's own time, which is *not* just a
display: every exit criterion has a millisecond budget, and a student who
answered after a half-hour interruption was not slow on the item.

**What the record counts is answers, not minutes present.** The sitting clock
is a display and is written nowhere. The study record — what `:status` reads,
and what the `consistency` method publishes as `minutes` — is reconstructed
from the timestamps of answers in the journal, and no single gap between two
answers is worth more than five minutes. That bound is the point: without it,
*start, go and watch television, come back inside half an hour, answer one
more* bought twenty-nine minutes of study per answer, repeatable all evening.
Five minutes still pays in full for reading why the last answer was wrong,
drawing a card or looking up a glyph, which is what the minutes between two
answers usually are.

So time is bought by answering a question. Sitting with the prompt open earns
nothing, and neither does typing at it.

**The tier is decided from the evidence, not chosen.** A client reports `ok`
or `17/20`; the server decides that the first is tier 3 and the second tier
2. Anything else is refused rather than quietly filed as compliance, because
`"18 out of 20"` written without a slash means a result, and recording it as
"I did it" would throw the number away and cap the item at 0.50 without
saying so.

**What the client can do, the client says.** `session.open` takes a
`capabilities` object, and the reply says what this server made of it:

```json
{"student_id": "bob",
 "capabilities": {"audio": {"play": ["wav"], "tts": ["ja"], "record": true}}}
```

```json
{"session_id": "sess-1", "can_hear": true, ...}
```

A voice here is a **shell command** — `say -v Kyoko -f %i -o %o` in
`~/.langpop/audio.conf` — and a phone, a browser and a Windows application
have no shell to run it in and no `%o` to write it to. So *who can make the
sound* stops being a fact about this machine the moment the client is
somewhere else, and asking the server to guess is how a tutor comes to offer
a question the client cannot ask. It was already offering one: `client.p`
renders `pick` and prints `prompt` for every other shape, and a listening
question's `prompt` is `null` by design — there is nothing to read, that
being the question. Nobody has met it, because a listening question is only
asked about a word already mastered by eye, but it was waiting. The TUI now
declares an empty list of formats and is not offered one.

An **absent** `capabilities` is not an empty one, and the difference carries
the whole design: saying nothing means *do as you did before*, which is what
every caller written before the field existed needs, while
`{"audio": {"play": []}}` means *I am here and I have no speaker*. One
`false` cannot mean both. A field this server does not understand is ignored
rather than refused, because clients arrive later than the servers that serve
them.

`can_hear` is the server's conclusion and not an echo: it folds in whether a
voice is installed here at all, which the client cannot know.

**`audio.text` is the platform-free half of audio** — no voice, no command,
no file, no cache, no rate. Just the text of the item as a mouth would say
it, its script, its beats, and whether its rhythm is the lesson:

```json
{"item": "w_gakkou", "lang": "ja", "text": "がっこう",
 "script": "hiragana", "morae": 4, "timing_sensitive": true}
```

That is a property of the graph, so it is the same answer on every machine
there will ever be — and it is the method a client that synthesises for
itself calls. A browser with `SpeechSynthesisUtterance`, an iOS app with
`AVSpeechSynthesizer`, an Android app with `TextToSpeech` and a Windows app
with the WinRT synthesiser all have a Japanese voice installed already; not
one of them can run `say -v Kyoko -o %o`, and not one should have to be sent
a wav to say a word it can say itself. Client-side synthesis is not the poor
relation here — it is the only option that covers all five platforms. The
`script` is there because the language does not settle it: every platform TTS
is configured by something like a BCP-47 tag, and `ja` with `kanji` means
`SPOKEN_JA` reached its last resort and the reading was missing.

`timing_sensitive` is a warning with a job on this method. Those are the
items whose rhythm *is* the lesson — きて against きって — and a client's own
voice is not the voice the mora scorer was calibrated against. Say them by
all means; do not measure them.

**And `audio.fetch` is the sound itself**, for a client with no disk in
common with the server:

```json
{"item": "w_gakkou", "encoding": "base64", "bytes": 29298,
 "data": "UklGRi...", "path": false,
 "voice": "Kyoko", "model": "macos-say", "rate": "normal",
 "timing_sensitive": true}
```

It is `audio.say` called straight through, plus the bytes, so the two cannot
disagree about rates, caching or what a missing voice means — and every
error `audio.say` can give is this method's error too, with the same code.
Both exist because **the client chooses**, which is the same principle as
`capabilities`: a path costs nothing to hand to a caller on this machine and
names nothing to a caller in a browser. The `path` comes back `false` rather
than absent, because a false member and a missing member are different
statements and this one is a statement: *there is no path for you*.

`-32006` is its own code because the limit is the transport's and not the
graph's: a rendered word is 20–40 KB, the cap is 2 MB of WAV before base64
makes it a third bigger again, and nothing in the graph comes near it. A
client that hits it should fall back to `audio.say` rather than retry.

### Photographs, and the `see` channel

**`image.fetch` is the photograph**, and there is deliberately no
`image.say` beside it:

```json
{"item": "ph_dog_walk", "encoding": "base64", "bytes": 106141,
 "data": "/9j/4AAQ...", "media_type": "image/jpeg", "path": false}
```

The asymmetry with audio is the architecture, not an omission. `audio.say`
exists because a WAV is *rendered* — there is a command to run, a rate to
choose and a cache that may or may not hold it, so a caller on this machine
has a real reason to want the path and skip the base64. A photograph is none
of that: it is committed content in the graph directory, forty seconds of
generation and a human review that cannot be repeated on demand. There is
nothing to say about making one, so the only question is *give it to me*.

A `see` question is TOEIC Part 1 — here is a photograph, which of these four
statements describes it — and it comes back as `look_pick` with the image
path as the stimulus, four statements as the options and a **position** as
the answer. The answer never leaves, as everywhere else. What is different
from a listening question is that the **stimulus does not contain the
answer**: a `hear` question asks *what did you hear*, so naming the sound
names the key, which is why client-side TTS can never serve one. A picture
names nothing, and four sentences about it are still four sentences.

Every statement in the graph has been checked against its photograph by a
vision model that was not shown the prompt — see
[docs/langpop-photographs.md](docs/langpop-photographs.md), where the first
image generated drew *two* dogs for a prompt that asked for one.

**`show` is a sibling of `play`, not a field inside it**, because the two
travel separately: a terminal with a speaker has no canvas and a silent
browser has nothing but. `session.open` answers both:

```json
{"capabilities": {"audio": {"play": []}, "image": {"show": ["jpeg"]}}}
→ {"can_hear": false, "can_see": true, ...}
```

An absent claim is still not an empty one, and that holds per block: a
`capabilities` object carrying only `image` has said nothing about audio and
gets the old behaviour, while `{"image": {"show": []}}` is a client saying
*I am here and I have no screen for this*. The TUI says exactly that —
`tools/term-image.py` exists and could change the answer, but until the
client actually calls it the honest claim is none.

**`l1` rides on `session.open` too** — the protocol's spelling of `--l1`,
naming the language the student reads glosses in, beside the `language` at
register that names the one they are learning. It is optional, sent only
when it was asked for (absent means the engine's two-way flip, exactly as
on the command line), it lives on the session because one server serves a
Japanese reader and an English-glosses learner at once, and a value the
tutor holds no glosses in is refused before a session exists:

```json
{"student_id": "dkords", "l1": "en"}  → {"gloss_language": "en", ...}
{"student_id": "dkords"}              → {"gloss_language": "ja", ...}
{"student_id": "dkords", "l1": "jp"}  → error -32602: no glosses in jp; held: ja en
```

`gloss_language` in the reply is the server's conclusion, like `can_hear`:
what this session's glosses will actually be in, whether that was asked for
or fell out of the flip. The TUI client takes `--l1` and forwards it the
same way. `register` now checks `language` against the ladders it holds for
the same reason `./langpop --lang jp` refuses at the door — the unchecked
value died three procedures later inside the server, as `-32603` on the
wire.

**Why the sound and not the text.** A client that can synthesise cannot be
sent the text instead, however many platform voices it has. A listening
question asks *what did you hear*, so its stimulus **is** its answer, and
`listen_pick` is no better: the options are both words and the answer is
which position the played one is in, so naming the word to speak names the
right position. That collides with *the answer never leaves*, so it is a
permanent limit and not a missing feature. **Client TTS for exposure
(`:say`), server-delivered sound for measurement.**

**The seam that remains.** A `tts` claim is therefore carried and *not
trusted*: it is right for playing a word the student is already looking at,
and can never serve a listening question.

Errors are typed, so a client can tell a mistake it made from a bug in here:
`-32602` invalid params, `-32001` no such session, `-32002` no such student,
`-32003` no such item, `-32004` no such assignment, `-32005` that rendering
style does not exist yet, `-32006` too large to hand over this way.

`client.p` holds no graph, no beliefs and no judgement — 566 lines of asking,
printing and one clock. That is the only honest test of an API: the reference client
has no private door.

### The teacher is allowed to misremember

> *"Ideally we start to 'remember' things, and the teacher would say, ahh, is
> it Bob Smith? No, my mistake, Bob White."*

That is recognition, not lookup.

```
Ah -- Bob White?  (y/n) n
My mistake.  And your name?  Bob Smith
```

The correction is kept, and that wrong guess is never made again. Offering
the nearest name and being corrected is how a person recognises somebody; a
lookup that is either right or empty is not memory.

`langpop/recognise` is the same thing on the wire. It needs no session,
because it happens before registration, and it creates nothing, so a client
may ignore the answer:

```json
-> {"method":"langpop/recognise",
    "params":{"student_id":"bwhite","display_name":"Bob White"}}
<- {"result":{"student_id":"bwhite","known":false,
              "guess":{"student_id":"bsmith","display_name":"Bob Smith",
                       "matched_on":"the name"}}}
```

**A name is not a string.** `Bob Smith` against `Bob White` is three edits
apart — outside any sane tolerance — and yet it is the exact confusion a
person makes, because the two share a given name. So tokens are compared as
well as whole strings, and a close token counts with one added so a
whole-name match still wins. This will sometimes offer the wrong one of two
people sharing a first name, which is the behaviour being modelled rather
than a defect in it: the teacher asks once, is told no, and never asks again.

**A transposition is one typo, not two.** Plain Levenshtein charges two for
`bsmiht` against `bsmith`, which is outside the budget for any short name, so
the single commonest slip a returning student makes would be the one case
that got no guess at all. The distance is Damerau-Levenshtein.

**And the same keystrokes must give the same guess.** Ties break
alphabetically — not because that is the better guess, but because it has to
be the same one every time. A teacher who asks *Bob Smith?* on Monday and
*Yuki Tanaka?* on Tuesday from the same input is not remembering.

---

## Looking at the graph

The tutor reads the graph one item at a time, chosen for one student. That is
the right view for teaching and the wrong one for curating: `check(graph)`
catches the things that are wrong by definition, and everything else is a
judgement, which needs to see the thing. A prerequisite edge pointing
somewhere silly looks exactly like one that does not.

```sh
./langpop dump --html --out /tmp/graph.html
./langpop dump                 # JSON on stdout
./langpop dump --dot | dot -Tsvg -o graph.svg
./langpop dump --text          # a report
./langpop dump --lang ja       # one language
```

`dump.p` starts no session, registers no student and records no evidence, so
what it shows is the shape of the graph and nobody's progress.

`--html` inlines the dump into `viewer/page.html` and writes **one file**
that opens by double-clicking it. That is not a convenience: a browser
refuses `fetch()` of a sibling file under `file://`, so a viewer that loaded
its data separately would need a web server before it showed anybody
anything.

The page lays the graph out in **prerequisite order** — one row per
topological layer, earliest first, which is the order a teacher has to follow
— and shows one item's three relations at a time: what must come first, what
it unlocks, and what it is confused with. Confusable pairs are drawn always
and in a different colour from prerequisites, because the two edge kinds mean
opposite things (*teach after* versus *do not teach together*) and a viewer
that drew them alike would be worse than none.

`--lang` drops an edge unless both ends survive the filter. The English
katakana traps are confusable *with* Japanese kana, so narrowing to `en` has
to drop those pairs rather than half-emit them and leave the viewer with
arrows into nothing.

---

## Commands

| | |
| --- | --- |
| *empty line* | the next thing to learn — weakest belief first, then least asked |
| `:plan` | what is ready now |
| `:why <item>` | the derivation: prerequisites, source, belief |
| `:status` | this level's exit criteria, measured, and which aids are off |
| `:progress` | the last four weeks as sparklines: days studied, minutes, questions, accuracy, speed, and the trend |
| `:drill` | practise the items `:status` names as slow or missed; unscored, and each answer is timed against its limit. `:drill 10` asks ten |
| `:place` | find out where they are, rather than ask |
| `later` | *at a question:* put it off until later this session |
| `:oops` | that answer was an accident — take it back and ask again later |
| `:aids` | which helps are on; `:aids later off` takes one away |
| `:card <item>` | draw it big — in the terminal if it can, else a viewer |
| `:sheet` | today's work, as a page to print |
| `:chart <script>` | hiragana, katakana or youon, on one page |
| `:zine` | the study plan, as a booklet to fold |
| `:say <item>` | hear it said, if a voice is installed; `:say <item> slow` |
| `:rate slow` | listen slower from now on, and it sticks (`slow`/`normal`/`fast`) |
| `:audio off` | no sound at all, and it sticks; `:audio on` to hear again, `:audio` to ask |
| `again` | *at a listening question:* play it once more, free and unlimited |
| `:mic` | check the microphone level, and whether the room is quiet enough |
| `:speak <item>` | say it, and have the held beat timed (needs a microphone) |
| `:assign` | something to do away from the keyboard |
| `:report <n> ok` | done it (tier 3) |
| `:report <n> 17/20` | done it, with a result (tier 2) |
| `:level <name>` | move the goal |
| `:time` | how long this sitting has run, and how many questions were in it |
| `:quit` | stop (every answer is already saved, so Ctrl-C or closing the window loses nothing) |

---

## Repository layout

| | |
| --- | --- |
| `langpop` | the wrapper: finds a Poplog, runs a front end |
| `langpop.p` | the engine and the terminal interface |
| `server.p` / `client.p` | the same engine over JSON-RPC, and a reference client |
| `oracle.p` | a seeded harness that climbs the ladder over the protocol |
| `import.p` | reference-source imports and the gap report |
| `card.p` / `sheet.p` / `audio.p` | the item as a picture, pages to print, sound |
| `dump.p` / `viewer/page.html` | the curator's view |
| `graph/` | the curriculum |
| `personas/` | what each teacher says |
| `tools/` | the kana table generator, the terminal image writer, the scorers, the N3 pool builder |
| `tests/` | the suites |
| `docs/` | the open curation questions |

**The teacher is a data file.** `personas/aoi.json` and `personas/hill.json`
hold a name, a gender, a register and the lines. Nothing about a teacher is
in the code, because what a teacher says is content and a native speaker
should review it. Lines cycle round-robin.

### Tests

```sh
./langpop test                          # every suite
LANGPOP_NO_CONTENT=1 ./langpop test     # as a fresh clone, nothing imported
./langpop oracle --seed 42 --answers 3000
./langpop oracle --place --skill 0.9
```

The suites cover the engine, the protocol, the client's clock, the importer,
the cards, the sheets, the audio and the dump. They pass with the imported
content and without it, and the second case is the one that catches an
assumption about content that happens to be built. `LANGPOP_NO_CONTENT=1`
holds the generated files back at load time rather than moving them, so the
two runs differ by a switch and not by the state of the working tree: 679
checks and 9,741 items with the content, 581 and 1,342 without.

One number worth knowing before you read a failing oracle: the scratch
server runs a 200ms day so that the review ladder actually advances, which
means how far a run gets inside its answer budget depends on how busy the
machine is. The answers a seed gives are deterministic; the distance is
not. Three runs of ja seed 42 at 9,000 answers reached 371, 392 and 412 of
the 800 N5 words. 9,000 is not enough to finish that rung — about 12,500
is.

A fourth run reached 375 after the scheduler stopped scanning the graph
once per question (2.79 s to 0.01 s at N2, `lp_gates_ok` in `langpop.p`),
which is the useful part of the figure: the engine got about thirty times
faster and the distance did not move, because what limits it is the 200ms
day and the review ladder rather than how quickly the questions arrive.

`oracle.p` is a seeded student that climbs the ladder over JSON-RPC,
asserting the engine's invariants at every answer — a belief that moved the
wrong way, an item taught before its prerequisite, a criterion that went
backwards. A failing run prints its seed, and the seed is the bug report.

The protocol suite drives the handler over a `sys_socket_pair` with both ends
in one process, so there are no forks, no ports and no sleeps. It includes a
check that `langpop/next` does not leak the answer anywhere in its reply —
not just in a field called `answer`.

Three checks in the card and dump suites compare **bytes**, because a mangled
encoding parses perfectly and comes out wrong: a JSON round trip cannot tell
あ from mojibake, and the glyphs are the content.


---

## What it costs on disk

Three separate things take space, and only one of them is large. Every
figure below is measured on this machine rather than estimated, and the
method is given so that a different voice can be costed without guessing.

### The graph

The committed column is what is in git; the built column is what an import
writes into `graph/*/generated/`. Both are text, and a level's total is what
that rung adds, not a running sum.

| | level | items | committed | built | level total |
| --- | --- | --- | --- | --- | --- |
| ja | pre-school | 199 | 26 KB | — | **26 KB** |
| ja | N5 | 876 | 60 KB | 192 KB | **252 KB** |
| ja | N4 | 930 | 57 KB | 224 KB | **281 KB** |
| ja | N3 | 2,830 | 177 KB | 782 KB | **958 KB** |
| ja | N2 | 2,549 | 182 KB | 736 KB | **918 KB** |
| ja | N1 | 1,207 | — | 369 KB | **369 KB** |
| en | pre-school | 41 | 16 KB | 2 KB | **18 KB** |
| en | A1 | 555 | 57 KB | 70 KB | **126 KB** |
| en | A2 | 554 | 55 KB | 77 KB | **132 KB** |

Plus 29 KB of `graph/schema.pl`, the two ladders and `graph/resources.pl`,
which belong to no level. **The whole graph, both languages and every rung
built, is 3.0 MB** — 2.8 MB of it Japanese, and 2.3 MB of that the product
of an import rather than something committed. A pick list costs about a
quarter of what it builds: `graph/ja/picks/n3.pl` is 165 KB of reference keys
and becomes 659 KB of items, forms and glosses; N2's 147 KB becomes 611 KB.

### The audio

This is the part that is large, and it is also the part that does not exist
until a student runs `--audio` — which is deliberate, because the files are
theirs. One file per item per rate, plus a small JSON sidecar recording what
was said and by which voice.

| | level | files | this level | cumulative |
| --- | --- | --- | --- | --- |
| ja | pre-school | 188 | 2.8 MB | 2.8 MB |
| ja | N5 | 876 | 20.1 MB | 22.9 MB |
| ja | N4 | 930 | 23.8 MB | 46.6 MB |
| ja | N3 | 2,830 | 74.4 MB | 121.1 MB |
| ja | N2 | 2,549 | 71.6 MB | 192.7 MB |
| ja | N1 | 1,207 | 25.3 MB | **218.0 MB** |
| en | pre-school | 88 | 2.3 MB | 2.3 MB |
| en | A1 | 555 | 14.0 MB | 16.3 MB |
| en | A2 | 550 | 13.9 MB | 30.2 MB |

So **a Japanese learner who renders every rung needs about 218 MB**, and the
whole ladder to N2 — which is as far as the words go — is 193 MB. **An
English test-taker needs 30 MB** for the three rungs that have content.

**The English rows are now measured, not predicted**, and the prediction
held: 1,193 files at a mean of **25.9 KB** against the 25.7 KB the
regression gave, 30.2 MB against 29.4 MB. The R² of 0.48 did not matter
because only the mean was ever used.

One caveat the arithmetic cannot see: `du` says **37 MB** for those same
files. The difference is filesystem block rounding over 1,193 small files,
roughly 5.8 KB of slack apiece — so 30 MB of audio costs 37 MB of disk, and
the Japanese figures carry the same kind of slack.

English pre-school is 82 files for 41 items because a contrast's
drill words are not items: the 13 sound contrasts and 12 written confusions
carry 58 distinct words between them over 30 `pair/3` rows, and each
needs saying.

**Each extra rate is another copy.** `--audio n5 --rate slow` writes a
second file per item beside the first, because a cached file is keyed by
item, voice *and* rate. Rendering all three rates of every Japanese rung is
three times the table above, near 650 MB.

### How those numbers were got, and how to redo them for another voice

`~/.langpop/audio.conf` here renders mono 16-bit PCM at 22.05 kHz, which is
**44,100 bytes of WAV per second of speech** whatever the voice says. The
rest is how long the voice talks.

For Japanese, measured over the 243 files already in
`~/.langpop/audio/ja/`, size is linear in the length of the reading:

```
bytes  =  7,444  +  5,364 x kana        (R2 = 0.92)
```

which is 0.17 s of lead-in and 0.12 s per kana at Kyoko's `normal` 175 wpm.
Multiply through the real readings in the graph and the per-level totals
above come out. A kana is a syllable, so the fit is tight.

The readings come from `lp_audio_text`, which is the procedure `--audio`
hands to the voice, rather than from a reconstruction of what it probably
says — so the *which items* half of the arithmetic is the program's answer
and only the *how many bytes* half is a model. That is also why eleven
Japanese pre-school items and seventeen English ones are missing from the
file counts: they have no spoken form, and the same procedure says so.

For English the same arithmetic does not work — a Latin letter is not a
syllable, and the regression over 40 words rendered with Samantha at the
same settings is R2 = 0.48. What is stable is the mean: **25.7 KB a word**,
between 17.8 KB and 36.7 KB. The English rows used that mean, and now that
all 1,193 are rendered the mean is **25.9 KB** — which is the useful lesson
about a weak fit: a model nobody relied on was replaced by a number that
was right.

To cost a voice of your own, render twenty words with it and take the mean:

```sh
/usr/bin/say -v <voice> -r 175 -f one-word.txt -o out.wav \
    --file-format=WAVE --data-format=LEI16@22050
```

A neural voice at 24 kHz stereo would be roughly three times these numbers;
an MP3 or Opus pipeline, a tenth. Nothing in the project assumes WAV beyond
what the configured command happens to write.

### The sources, which are only needed while building

The reference files are not committed and are not needed to run — only to
import. `tools/fetch-upstream.sh` puts them in `~/langpop-upstream/`:

| | size |
| --- | --- |
| `JMdict_e` | 60 MB (10 MB gzipped) |
| `kanjidic2.xml` | 15 MB (1.4 MB gzipped) |
| `cmudict.dict` | 3.5 MB |
| `en_50k.txt`, `ja_full.txt` | 1 MB together |

**91 MB**, archives included, and every byte of it deletable once the
generated files exist. The repository itself is 9.8 MB with 6.4 MB of that
git history, so a working tree with every rung built and no reference files
is about 12 MB before any audio.

### The student's own files

Small enough to ignore, and listed so that nobody has to wonder.

| | measured |
| --- | --- |
| a profile (`~/.langpop/<student>.json`) | 3.4 KB |
| the journal, per answer | 43 bytes |
| the journal after 196 answers | 8.6 KB |
| a card (`:card`) | 800 bytes |
| a sheet or a zine page (`:sheet`, `:zine`) | 11 KB |

A student who answers two hundred questions a day for a year writes about
3 MB of journal, which is the only file in the project that grows without
bound — and it grows at one line an answer, in a format a shell can read.

**A username is a file name**, so the tutor checks it before using it.
Letters, digits, `-`, `_` and `.` will do, and so will kana or any other
non-Latin script: `ひろし` is filed as `ひろし.json`. A username can be at
most 64 characters, and it cannot be empty, start with a dot, or contain a
space or a slash. Pressing Enter at `Username?` just asks again:

```
Username?    (a username cannot be empty.)
Username?    (letters, digits, - _ and . only in a username.)
```

`--user` gets the same check but stops instead of asking, because a script
has nobody to answer. The server refuses a bad `student_id` on `register`
and `recognise` with `-32602` and the reason, and `session.open` will not
bind one.

---

## Limits

**Type is fitted, not trusted.** A cover line, a heading and a student's own
name are all strings this program does not choose, and two of the three are
translated. Each is measured against the panel and brought down to fit; the
cover line wraps before it shrinks, because two lines at full size read
better than one small one. The suite measures every text element on all eight
pages, in both languages, against the panel it is drawn in — the vertical
version of that check had been passing for a month over an English cover line
that was off the page to the left and the right.

**What this build cannot check.** `speak` needs a microphone and a scorer,
and the scorer that exists measures one thing: whether a geminate beat is
there. `hear` needs a voice installed and the sound already cached. Where
either is missing, the affected criteria report as unmeasurable rather than
as zero.

**What the graph is short of.** Words, now, rather than characters. Every
kanji criterion on the Japanese ladder is met — 103, 284, 650, 1023, 2230 —
because KANJIDIC2 carries the level and the one rung it does not cover is
argued in [docs/langpop-n3-kanji.md](docs/langpop-n3-kanji.md). The word
counts are met through N2 and short only at N1, which wants 3,846 more than
the graph holds; JMdict carries no level, so each of those is a pick list --
hand-written through N4, and from N3 up a ranked pool read by hand, argued
in [docs/langpop-n3-vocabulary.md](docs/langpop-n3-vocabulary.md) and
[docs/langpop-n2-vocabulary.md](docs/langpop-n2-vocabulary.md). `--audit` is
the list. Every listening criterion in both languages needs `--audio` run
once with a voice installed, and that is the largest gap in the project.
After it, the English B1 words. *Coverage* was the
function words, which are now in: `coverage(reading, _)` reads 55% of the
corpus where it read 17% before them, and the 40 points still owed are
thousands of words rather than a rule.

**What the two front ends do not share.** `./langpop` and
`./langpop client` are the same engine, and `:time` is now in both. The
in-process tutor also has `:place`, `:oops`, `:aids`, `:sheet`, `:chart`,
`:zine`, `:say`, `:rate`, `:mic`, `:speak` and `:level`, none of which the
client offers — and that direction is the honest test of the API rather than
an oversight: each is a protocol method the reference client has not been
given a reason to call yet.

**What is deliberately absent.** No model in the teaching loop. No generated
content in the repository. No spaced-repetition scheduling beyond the
four-step ladder described above. Judging is exact match on a string, which
is the correct amount of cleverness for a level where the right answer *is* a
string.

**Open curation questions** are each written up rather than left implicit:

| | |
| --- | --- |
| [langpop-function-words.md](docs/langpop-function-words.md) | 33 function words, the only lever on coverage — **done**, and the decisions recorded |
| [langpop-japanese-tranche.md](docs/langpop-japanese-tranche.md) | how the N5 word rows were argued |
| [langpop-n3-kanji.md](docs/langpop-n3-kanji.md) | which 366 of old level 2's characters are N3, and why school grade beats newspaper frequency |
| [langpop-n3-vocabulary.md](docs/langpop-n3-vocabulary.md) | the rung that was too big to pick a word at a time: why a bridge-level word is one both corpora use -- **done**, 2,464 picks |
| [langpop-n2-vocabulary.md](docs/langpop-n2-vocabulary.md) | the rung where the corpus had to change: why the newspaper orders this one and the subtitles only break ties -- **done**, 2,176 picks |
| [langpop-pronunciation.md](docs/langpop-pronunciation.md) | what a Japanese speaker learning English cannot be asked |
| [langpop-reviews-and-periods.md](docs/langpop-reviews-and-periods.md) | the review intervals and the 28-day period, and which numbers are still arguable |
| [langpop-production-criteria.md](docs/langpop-production-criteria.md) | should the ladder ask a student to speak, and at what threshold |
| [langpop-audio.md](docs/langpop-audio.md) | the plan for the half of audio that measures |
| [langpop-photographs.md](docs/langpop-photographs.md) | TOEIC Part 1 photographs: why the prompt is not the answer key, and what checks the statements |
| [langpop-standalone-and-validation.md](docs/langpop-standalone-and-validation.md) | what running the whole thing has found |

---

This repository was carved out of
[IoTone/poplog](https://github.com/IoTone/poplog) with its history intact: it
grew past what an example is, and it is a program that *uses* Poplog rather
than part of the language.

The one idea the engine rests on is that a Pop-11 procedure can be a Prolog
predicate. `lp_known/2` is defined with `define :prolog`, and the `ready/4`
clause above consults it as if it were a table of facts — so the prerequisite
rule reads evidence recorded seconds ago, in a property table, without
knowing that it is not consulting a database. The graph travels the other way
by the same route: every query in `langpop.p` is a term built with
`prolog_maketerm`, so there are no query strings anywhere.
