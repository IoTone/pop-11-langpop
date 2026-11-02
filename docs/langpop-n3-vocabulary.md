# N3 vocabulary: a bridge-level word is one that both corpora use

*Written 2026-11-01, while filling `exit(ja, n3, vocabulary(3750, read))`.*

N5 and N4 were picked a word at a time. `graph/ja/picks/n5.pl` is 773 rows
and `n4.pl` is 749, and every row in both is a judgment somebody made with
the entry in front of them. N3 asks for 3,750 cumulative. That is 2,236 more
words than the graph had, and nobody reads four thousand dictionary entries
without a principle — not carefully, and not twice the same way.

So this rung needed a rule. The rule is one sentence:

> **A bridge-level word is one that both corpora use.**

Two corpora, because the project has two and they disagree in a way that
turns out to be exactly the distinction N3 needs.

## The two corpora, and what each one knows

**JMdict's priority marks.** Every entry can carry `news1`/`news2`,
`ichi1`/`ichi2`, `spec1`/`spec2`, `gai1`/`gai2` and `nf01`–`nf48`. The `nf`
bands are the Mainichi Shimbun frequency corpus in blocks of 500 words, so
they are a published ranking of a real corpus — and that corpus is a
**newspaper**.

**The dialogue list.** `~/langpop-upstream/ja_full.txt` is the
OpenSubtitles frequency list the English side already uses: 34,504 surface
forms counted in film and television **speech**.

Neither is a syllabus. JMdict carries no level marking at all, which is why
`provenance(exit(ja, _, vocabulary(_, _), _, _), estimate(community))` has
been in the ladder since it was written.

## Why the newspaper cannot be the order

The first pool was ranked by `nf` band, newspaper first. Here is what the
rung's opening three hundred words looked like:

> 議員, 当局, 外相, 安保, 地検, 議席, 税制, 支局, 書記, 五輪, 日米, 連立,
> 比例, 定数, 国会, 総会, 決議, 行政, 情勢, 政界 …

That is Diet reporting. It is excellent Japanese and every word in it is
common — in a newspaper. A learner who meets 議員 before 友人 is being
taught somebody else's vocabulary, and the words a bridge-level student
actually needs were only reaching the list where the dialogue count happened
to rescue them.

Ranked by dialogue instead, the same pool opens:

> 人間, 人生, 女性, 事件, 可能, 全員, 理解, 友人, 父親, 母親, 記録, 行動,
> 調査, 発見, 夕食, 親友, 不思議, 大好き, 小屋, 人形 …

The newspaper marks still do real work. They are the **gate** — a word
upstream does not mark common at all is not in the pool. They are just not
the **order**.

This is the same shape as the N3 kanji decision one file over
(`docs/langpop-n3-kanji.md`): there, school grade was the curriculum and
`<freq>` was the newspaper, and the curriculum came first. Here the
newspaper is the one that knows the word exists and the dialogue is the one
that knows a person says it.

## What ran as a rule

Five filters are mechanical and took the pool from 218,951 JMdict entries
to 4,495 candidates:

1. **The headword is written in kanji the graph teaches at or below N3.**
   650 characters. A reading question at this rung has to be answerable at
   this rung.
2. **The word is not already in the graph**, under any form or any id. This
   one matters more than it sounds: minting a fresh identity for a word a
   student already has beliefs about splits those beliefs in half and
   nothing downstream can tell. `import.p` refuses it too.
3. **JMdict marks it common** (any priority mark, and none of the
   `arch`/`rare`/`obs`/`vulg`/`uk` senses).
4. **The headword is not a verb or adjective stem.** The dialogue list
   counted every 出来る as 出来 and every 面白い as 面白, so stems arrive
   at the very top of a dialogue ranking carrying the verb's frequency.
   A stem is not a word to teach; the verb is.
5. **The spelling is one upstream recommends** — not tagged `ateji`,
   `rK`, `oK`, `iK` or `sK`. This filter is not really this file's; it is
   `import.p`'s, which refuses to *teach* a tagged spelling and is right
   to (JMdict gives コーヒー the headword 珈琲 and とても the headword
   迚も). The pool has to refuse the same words the importer refuses, or
   a pick arrives as something other than what it claimed — see below.

Then the 4,495 were read by hand in rank order, as far as rank 2,800, and
336 of them thrown out.

## What was judgment

| rejected | why | examples |
| --- | --- | --- |
| 242 | **register** — real words belonging to a trade | 令状, 判事, 皮質, 動議, 常務, 旅団 |
| 30 | **stem** the mechanical rule missed, because the okurigana is not a verb ending | 教え, 始まり, 動き, 読み |
| 23 | **proper noun** — a country, city, island or organisation | 日本, 東京, 北京, 国連 |
| 15 | **homophone** — two readings of one headword, where one should be taught | 生物 as せいぶつ not なまもの |
| 11 | **rare** — a sense or reading upstream marks common that a learner will not meet | 客人 as きゃくじん |
| 7 | **fragment** — half of a longer word | 百聞, 商工, 不老, 先住 |
| 3 | **alternate reading** of a word the graph already teaches | 今日 is きょう, not こんにち |
| 5 | one each: a suffix (気味), a numeral (八つ), a mis-glossed entry (羽目), a segmentation artefact (半田), and one orthography — バラ色, whose kanji spelling 薔薇色 uses characters this rung does not teach |

**Register did almost all the work**, and the reason is the corpus. A
subtitle list built from police procedurals and hospital drama is generous
with 令状, 検事, 皮質 and 服役 — those words really are spoken, often, by
actors playing detectives. They are not what a bridge-level learner needs
next. That is a judgment, so it is written down one row at a time in
`graph/ja/picks/n3-rejects.tsv`, with a reason beside each id: a rejection
nobody can see is a rejection nobody can argue with.

## The bit that is not defensible, and is not meant to be

The boundary is at rank 2,800 of a dialogue frequency list. The word there
is not harder than the word at 2,801; it is rarer in a particular pile of
subtitles. The 2,464 picks are a *rung*, not a syllabus, and if a teacher
wants the line drawn at 3,200 that is one number in one command:

```
./langpop dump --lang ja > work/ja-dump.json
python3 tools/draft-picks.py work
# curate: drop the DUPID rows and the words no dialogue corpus has
python3 tools/mkpicks.py work 3200 > graph/ja/picks/n3.pl
./langpop import --source jmdict --file ~/langpop-upstream/JMdict_e \
    --picks graph/ja/picks/n3.pl
```

## What it moved

| | before | after |
| --- | --- | --- |
| items in the graph | 5,101 | 7,565 |
| askable Japanese words | 1,514 | 3,978 |
| `exit(ja, n3, vocabulary(3750, read))` | short by 2,236 | **ok**, with 228 to spare |
| `exit(ja, n2, vocabulary(6000, read))` | short by 4,486 | short by 2,022 |
| `exit(ja, n3, vocabulary(3750, hear))` | short by 2,236 | short by 3,652 — there is no audio |
| `./langpop --check` | 61 s | 402 s |

## The four that were not askable

The first version of this file said: *four of the 2,466 picks are not
askable for `read`, which is what the margin is for*. That was true and it
was the bug announcing itself. A margin absorbing exactly four items is not
a margin doing its job; it is four items that should not be there.

They were 味方, 無茶, 心地 and 日和, and JMdict tags every one of them
`ateji` — kanji chosen for sound rather than meaning. `import.p` will not
teach a tagged spelling, so it emitted no kanji form for any of them, and
four Japanese words arrived written in kana at the rung whose whole
selection rule is *written in kanji the student already has*. A reading
question holds one form up and asks for another; with one form there is no
question, and nothing said that a kana-only N3 word is a contradiction in
terms.

The pool was supposed to have refused them: filter 5 above existed from the
first draft. It compared JMdict's short tag codes against the expanded
entity text and so matched nothing, which is the third time one bug has
done that (`DESIGN_NOTES.md`, and finding 20 in
`docs/langpop-standalone-and-validation.md`). The rule is one `abbr()` call
now, and `tests/test_langpop.p` asserts what it promises: every N3 word has
a kanji form and a reading.

The obvious next question is why `import.p` does not refuse this by itself,
since it is the program that drops the form. Because it cannot tell the two
cases apart without knowing more than it reads. An entry with kanji
headwords and no teachable one is 味方, which should not be here; it is also
とても, whose only spelling 迚も is tagged `rK` and which is a word every
beginner needs, written in kana. What separates them is JMdict's `uk` sense
tag — *usually written using kana alone* — which the pool reads and the
importer does not. So the rule lives where the knowledge is, and the test
states the consequence. 味方 and 心地 are words worth teaching, in a
rung whose reading questions can be answered — not this one.

The last row is a real cost and not yet explained. The graph grew by a
factor of 1.48 and the audit got 6.6 times slower, which is the signature of
something quadratic rather than something merely large — the same smell as
the `reaches/2` blow-up that `docs/langpop-standalone-and-validation.md`
records, and the next thing to measure.

The `hear` half of every Japanese rung is still zero askable without
`--audio`, and that remains the student's own job: the recordings are theirs
and nothing in this project keeps or uploads one.
