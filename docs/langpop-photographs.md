# Photographs for langpop: the `see` channel

**Status:** built. The content pipeline, the `see` channel and
`langpop/image.fetch` all ship; two photographs are in the tree. What is
*not* built is an exit criterion, which is the one decision in here that
is not mine to make — see §6. Written as the pipeline was measured,
2026-11-03.

Companion to `docs/langpop-audio.md`. The arguments rhyme — a photograph
is a *stimulus*, which is what a WAV is — and where they rhyme this
document points at that one rather than repeating it.

## 1. Why a photograph at all

TOEIC Listening & Reading is 200 questions in seven parts, and this
project currently addresses one of them structurally:

| TOEIC part | langpop |
| --- | --- |
| 5 — incomplete sentences | four `pattern` items, literal cloze (`'I ___ seen it'`) |
| 1 — photographs | **nothing, and it needs images** |
| 2 — question–response | nothing; the `hear` channel asks one word |
| 3, 4 — conversations, talks | nothing; no discourse, no multi-turn audio |
| 6, 7 — text completion, passages | nothing; no passages |

Part 1 is the smallest part of the test — six questions of two hundred —
and by far the most expensive content here. It earns its place for a
different reason: it is the only part that was *impossible* rather than
merely absent. Everything else on that list is a curation problem. This
one needed a picture to exist, and now a picture costs forty seconds on
a laptop.

**What this does not do is make langpop a TOEIC trainer.** The ladder
says it plainly — *"TOEIC has no syllabus to teach to"* — and TOEIC
enters as a reported band, not a rung. A `see` channel is a channel,
measured like the others.

## 2. The finding: the prompt is not the answer key

The first image ever generated here was from a prompt supplied verbatim:

```
ollama run x/z-image-turbo "A person walking a dog, realistic photograph"
```

It drew a person walking **two dogs**, one on a leash and one loose.

The picture is good. It is *better than the request* — two dogs with one
leashed is a richer Part 1 photo than one dog. But Part 1's distractors
are precisely about number, action and state: *"The woman is walking a
dog"* against *"The woman is walking two dogs"* against *"The dogs are
on leashes"* is the actual shape of that part. An item keyed from the
prompt would have marked the student who counted correctly as wrong.

So the prompt is a **request**, and it is discarded the moment the file
exists. From then on the image is the only authority on itself. This is
the same discipline the rest of the project runs on — measure the
artifact, do not trust the intent that produced it — and it is why
`tools/mkphoto.py` exists rather than a one-line shell alias.

It is not a fluke of one prompt. The second photograph asked for two
office workers *"one holding a stack of papers"* and drew two women both
apparently holding papers.

## 3. The gate, and its two jobs

`mkphoto.py check` puts each statement, **alone**, to a vision model that
has not seen the prompt and has not been told which answer is wanted.
Statements under `"true"` must come back true; statements under `"false"`
must come back false; any disagreement is an exit code.

One statement per call is deliberate. A model handed four statements and
told one is right will *balance* them — it answers the multiple-choice
question instead of looking at the picture, which is the student's job
and not the checker's.

**Job one is catching a wrong key.** Expected, and it works.

**Job two was not intended and is the more useful half: it rejects
ambiguous distractors.** The first distractor ever put through it was
mine, and it failed:

```
WRONG want=False got=True   A woman is walking a dog.
        the model says: The woman is walking multiple dogs, so the
        statement that she is walking a dog (at least one) is accurate.
```

That reading is correct and the distractor was bad. A Part 1 distractor
has to be plainly false; one that survives on *"at least one"* is a
second right answer wearing a disguise.

**A disagreement is therefore not an argument to be settled.** On the
office photo the checker insists, twice running and in different words,
that both women hold papers, where the second woman's hands look to a
human reader like they are out of frame. One of the two readers is
misreading a 640px JPEG — and *it does not matter which*, because a
statement two careful readers cannot agree on is unfit to be an option
whichever way it resolves. The rule is **drop the statement, never
adjudicate it**.

### What to trust

`describe` is unconstrained and will confabulate — it is the mode that
produced the hands. `check` is one constrained TRUE/FALSE about one
statement, and over both photographs so far it has not once been wrong
about a count, an absence or a posture.

So **`describe` is a drafting aid** a human reads before writing
statements, and **`check` is the gate**. Neither is an oracle about the
world; the gate only ever tests whether a statement is *plain*. A human
still confirms every item. What this removes is the review burden of the
loud failures, not the review.

The checker is shown **the delivered file**, not the master render. A
detail that survives at 1024px lossless and dissolves at 640/q80 is a
detail the question must not turn on.

## 4. Format: the palette intuition is backwards

"Use a small web-palette GIF" is the natural instinct and it is wrong for
this content. Measured on the dog photograph, master 1024×1024 PNG at
2,213,706 bytes:

| format at 640px | bytes |
| --- | --- |
| JPEG q70 | 81,297 |
| WebP q80 | 93,846 |
| **JPEG q80** | **106,141** |
| PNG8, 256 colours | 216,469 |
| GIF, 256 colours | 307,318 |

Palette formats are the **worst** here, by nearly four to one. GIF and
PNG8 win on flat-colour graphics — diagrams, logos, screenshots — by
replacing a continuous-tone field with an index. A photograph *is* a
continuous-tone field: quantising it to 256 colours spends bytes encoding
dither noise that JPEG never has to represent at all. WebP's edge over
JPEG is real but small, and not worth asking every future client to
decode a third format for.

**JPEG, 640px, q80, about 100 KB.** Comfortably under the 2 MB the fetch
methods will send, with room for a photograph that compresses worse than
these two, and quality margin wide enough that the checker reads the same
picture the student gets.

Note the raw master would *not* have fitted: 2,213,706 bytes is over
`AUDIO_FETCH_MAX` (2,097,152) by 116 KB. The first image generated here
failed the cap, which is how the resize step came to be part of the tool
rather than advice in a README.

## 5. Photographs are kept, where sound is cached

This is the one place the analogy with audio breaks, and it changes the
architecture.

A WAV is **25.9 KB, deterministic, and regenerable from its text
forever**, so `~/.langpop/audio/` is a cache that can be deleted without
losing anything. A photograph is a **one-off**: forty seconds of
generation, a human review, and no way to get the same image back from
the same prompt. It has to be *kept*.

So photographs are committed content under `graph/en/photos/`, beside the
JSON that records which statements were checked against them and with
what. Nothing about them renders on demand, which makes the engine side
much simpler than `audio.p`: no render command, no rates, no voice
configuration — just *is there a file for this item, and what are its
bytes*. All generation lives in `tools/`.

A corollary worth stating: generated images have **no corpus attribution
problem at all**. Cleaner provenance than JMdict or OpenSubtitles.

## 6. What shipped, and what is left

The `see` channel is built. Item kind `photo`, channel `[see]`,
`lp_can_see()` gated on the client's `show` claim exactly as
`lp_can_hear()` is gated on `play`, `lp_see_question` producing
`look_pick`, and `langpop/image.fetch` carrying the bytes. The answer is
a position, so it never leaves; and unlike a listening question the
stimulus does not contain it, which is what lets the picture be handed
over at all.

Three things fell out of building it that were not in the plan:

- **`lp_read_bytes` and `lp_base64` left `audio.p`.** Nothing about
  reading a file as bytes or spelling them in base64 is about *sound*,
  and a photograph reaching into the audio file for its encoder would
  have been a lie about the architecture. They sit under both channels
  now, in `langpop.p`.
- **`check(graph)` caught the new kind immediately**, with
  `item_without_form` for both photographs — correctly, since a photo
  has no written form. The exemption is paid for rather than taken:
  `photo_without_file`, `photo_without_key` and
  `photo_short_of_distractors` now demand of a photo what `form/3`
  demands of everything else. An item kind that carries its content
  outside the graph has to be checked for carrying it.
- **The protocol suite cannot round-trip a photograph.** `test_langpop_server.p`
  is one process talking to itself over a `sys_socket_pair`, so the
  handler writes the whole reply before anything reads it; 141 KB of
  base64 exceeds the socket buffer and the suite hangs with no output at
  all. `audio.fetch` escapes it only because a word is 20 KB of WAV.
  That is a limit of the harness, not the method — verified over a real
  socket between two processes: 106,141 bytes out, byte-identical,
  `path: false`. The payload assertions call the method directly and the
  error cases still go over the wire.

### Left

- **A faithful Part 1 needs both channels.** On the real test the four
  statements are **spoken, not printed** — the paper in front of the
  candidate has only the photograph. So a faithful item is an image plus
  four WAVs with the position as the answer, which is exactly the shape
  `lp_pair_question` already builds. The printed-statement version that
  ships now is a legitimate easier variant, and is what a paper book's
  answer key looks like. It would be the first item in the graph needing
  `see` *and* `hear` together.
- **More than two photographs.** Forty seconds and a review each.
- **An exit criterion, which is not mine to invent.** Content with no
  criterion is unmeasured content; the audit would not report it at all.
  What a photograph set has to be worth belongs on the ladder beside the
  vocabulary counts, and those are already flagged
  `provenance(..., estimate(community))`.
