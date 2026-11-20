# Getting started: learning Japanese

A short run guide for a student (or their teacher) sitting down for the
first time. The teacher on this track is Aoi. Everything here works on a
fresh clone; the [README](README.md) has the detail behind each step.

## 1. Install

```sh
git clone https://github.com/IoTone/pop-11-langpop
cd pop-11-langpop
./langpop --deps
```

`--deps` lists what this machine has. Only Poplog is required; the
[README](README.md#installing) says how to get one. Sound is optional but
worth having, and is step 2.

## 2. Make the sound (once)

Listening questions are only asked about things that already have a sound
file, so make the first rung's before the first lesson:

```sh
./langpop --audio preschool
```

This needs a voice named in `~/.langpop/audio.conf`. On a Mac with the
Kyoko voice installed (System Settings → Accessibility → Spoken Content):

```json
{"ja": {"cmd": "/usr/bin/say -v Kyoko -r %r -f %i -o %o --file-format=WAVE --data-format=LEI16@22050",
        "voice": "Kyoko", "model": "macos-say",
        "rates": {"slow": "110", "normal": "150", "fast": "190"}}}
```

With no voice the tutor still teaches reading; it says listening "cannot
be checked here" and carries on. Run `--audio n5`, `--audio n4` and so on
as you reach each level.

## 3. Start

```sh
./langpop --user sam
```

Pick any short name for `--user`; it is the name of your record, and the
same name brings you back tomorrow. Aoi asks three things:

1. **Your name.**
2. **What you are learning for** — a test (JLPT), a trip, talking with
   people, or reading. This changes what holds a level shut and how much
   is asked by ear. A trip also adds 38 travel phrases, heard from the
   first sitting.
3. **Whether you have studied Japanese before.**
   - `1` (or enter) starts at the beginning: hiragana.
   - `2` runs a short interview, about 20 to 40 questions, and places you
     on the ladder. Press enter for anything you do not know; that tells
     Aoi more than a guess. What you are placed above is taken as known
     and comes back as reviews over the following weeks.

## 4. A sitting

```
Aoi 0:00>
  READING.  How is this kana said?  Type it in romaji.
  あ    ->
```

- **Enter** at the prompt asks the next question.
- **Enter** at a question means "I do not know", which is an answer.
- `later` puts a question off; `again` replays a listening question.
- `:oops` takes back a typing slip.
- `:status` shows what this level still wants from you.
- `:plan` shows what is ready next; `:why <item>` says why.
- `:chart hiragana` prints the table on one page.
- `:audio off` for a train or a library; `:audio on` to hear again.
- `:quit` stops. Every answer is saved as you give it.

Being asked something again a day after getting it right is the review
schedule working. The gap widens each time you are right.

## 5. Coming back

```sh
./langpop --user sam
```

Reviews that have come due are asked first, then new material. If the
level turns out too easy, `:place` runs the interview at any time, and
`:goal` changes what you are learning for.

## 6. Going past the first fifty words

A fresh clone holds the kana, fifty words and the travel phrases — the
first several weeks. The N5 to N2 words and characters are imported from
two free dictionary files; the eight commands are in the README under
[From scratch, as a Japanese learner](README.md#from-scratch-as-a-japanese-learner).

## The ladder

`preschool` (hiragana, katakana, how sounds are counted, 50 words) →
`n5` → `n4` → `n3` → `n2` → `n1`. A trip needs nothing past N5.
