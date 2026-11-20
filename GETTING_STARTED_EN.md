# Getting started: learning English

A short run guide for a student (or their teacher) sitting down for the
first time. The teacher on this track is Mr Hill. The track is written
for a student who reads Japanese: meanings are given in Japanese, and the
first rung is the sounds Japanese does not have. Everything here works on
a fresh clone; the [README](README.md) has the detail behind each step.

## 1. Install

```sh
git clone https://github.com/IoTone/pop-11-langpop
cd pop-11-langpop
./langpop --deps
```

`--deps` lists what this machine has. Only Poplog is required; the
[README](README.md#installing) says how to get one. Sound matters more on
this track than on the Japanese one, and is step 2.

## 2. Make the sound (once)

The first rung is pronunciation — r and l, v and b, final consonants,
katakana readings of English words — and most of it can only be asked by
ear. Listening questions are only asked about things that already have a
sound file, so make them before the first lesson:

```sh
./langpop --lang en --audio preschool
./langpop --lang en --audio a1
./langpop --lang en --audio a2
```

This needs a voice named in `~/.langpop/audio.conf`. On a Mac:

```json
{"en": {"cmd": "/usr/bin/say -v Samantha -r %r -f %i -o %o --file-format=WAVE --data-format=LEI16@22050",
        "voice": "Samantha", "model": "macos-say",
        "rates": {"slow": "110", "normal": "175", "fast": "220"}}}
```

All three rungs together are about 1,200 files and 37 MB. With no voice
the tutor still teaches the words; it says listening "cannot be checked
here" and carries on.

## 3. Start

```sh
./langpop --user yuki --lang en
```

Pick any short name for `--user`; it is the name of your record. Use
`--lang en` the first time; after that the tutor remembers. Mr Hill asks
three things:

1. **Your name.**
2. **What you are learning for** — a test (TOEIC), a trip, talking with
   people, or reading. This changes what holds a level shut and how much
   is asked by ear. A trip also adds 38 travel phrases.
3. **Whether you have studied English before.**
   - `1` (or enter) starts at the beginning.
   - `2` runs a short interview, usually 4 to 12 questions, and places
     you at A1 or A2. Press enter for anything you do not know; that
     tells Mr Hill more than a guess. The words below your level are
     taken as known and come back as reviews over the following weeks.

**Placement does not skip pronunciation.** The interview measures
vocabulary, which says nothing about r and l. A student placed at A2 gets
A2 words with the pre-school sound work running alongside.

## 4. A sitting

```
  意味：この単語の意味はどれですか。番号を書いてください。
  MEANING.  What does this word mean?  Type the number.
  price
    1) 会社
    2) 値段
    3) 会議
    4) 管理者
  ->
```

- **Enter** at the prompt asks the next question.
- **Enter** at a question means "I do not know", which is an answer.
- `later` puts a question off; `again` replays a listening question.
- `:oops` takes back a typing slip.
- `:status` shows what this level still wants from you.
- `:plan` shows what is ready next; `:why <item>` says why.
- `:rate slow` plays everything slower from now on.
- `:audio off` for a train or a library; `:audio on` to hear again.
- `:quit` stops. Every answer is saved as you give it.

Being asked something again a day after getting it right is the review
schedule working. The gap widens each time you are right.

## 5. Coming back

```sh
./langpop --user yuki
```

Reviews that have come due are asked first, then new material. If the
level turns out too easy, `:place` runs the interview at any time, and
`:goal` changes what you are learning for.

## For a student who does not read Japanese

```sh
./langpop --user sam --lang en --l1 en
```

`--l1 en` gives the meanings in English instead of Japanese. The first
rung is still the sounds a Japanese speaker finds hard.

## The ladder

`preschool` (sounds, and twelve loanwords that mean something else in
English) → `a1` (519 words) → `a2` (550 more). A trip needs nothing past
A2. Nothing has to be imported: all of it is in a fresh clone.
