# N2 vocabulary: the rung where the corpus has to change

*2026-11-02. Companion to [langpop-n3-vocabulary.md](langpop-n3-vocabulary.md),
which should be read first: it sets out the pool, the five mechanical
filters and the reason a rung this size needs a rule instead of a
word-by-word list.*

N3's rule was **a bridge-level word is one that BOTH corpora use** — JMdict's
priority marks gate the pool, a subtitle frequency list orders it. Applying
the same rule at N2 produces a rung that cannot be defended, and the reason
is worth more than the rung.

## The measurement that settled it

The dialogue list (`ja_full.txt`, 34,504 surface forms from OpenSubtitles)
was asked about six words a newspaper reader meets constantly:

| word | gloss | dialogue rank |
| --- | --- | --- |
| 判断 | judgment | **absent** |
| 批判 | criticism | **absent** |
| 段階 | stage, phase | **absent** |
| 背景 | background | **absent** |
| 程度 | degree, extent | 1,021 |
| 捜査 | criminal investigation | **109** (4,939 occurrences) |

Not rare in the list. Absent from it. Meanwhile 捜査 — a word a learner
needs mainly to follow a police procedural — is in the top hundred and a
half.

That is not a defect in the corpus. A list built from film and television
subtitles is an excellent record of what people **say**, and 判断する is a
thing people write. N2 is the rung at which a learner reads editorials, so
the gate that served N3 would have refused 判断 and admitted 殺人: the wrong
rung's vocabulary, in both directions at once.

**So at N2 the Mainichi band orders the pool and the dialogue count becomes
the tiebreak** — the exact reverse of N3, and for the same reason N3 put the
newspaper second. The question was never which corpus is better. It is which
corpus is a measurement of this rung.

## What each order opens with

Ranked by dialogue, the N2 pool begins:

> 捜査, 殺人, 犯人, 了解, 武器, 存在, 装置, 移動, 精神, 価値, 非常, 警備,
> 治療, 許可, 爆発, 個人, 警部, 警告, 自殺, 混乱 …

Ranked by the newspaper:

> 捜査, 個人, 回復, 違反, 程度, 自宅, 候補, 訪問, 役割, 舞台, 拡大, 構造,
> 基準, 政権, 平均, 改革, 輸入, 不況, 大幅, 論議 …

The first list is a drama; the second is a rung. Both of them need the same
hand pass afterwards, because the newspaper corpus is thick with its own
junk — party names, ministries, numerals, and a sports page.

## What ran as a rule

The five filters are N3's, with one number moved: a headword may use any of
the **1,023** kanji the graph teaches at or below N2 (650 through N3, plus
N2's 373). 218,951 JMdict entries give 10,005 candidates, 9,490 of them
with an id of their own.

Two rules were added to the pool while building this rung, and both were
found by a word going wrong.

**A rejection is carried forward.** The graph knows what it teaches; only
the reject files know what was offered and refused. Without carry-forward the
N2 pool opened with 出来 as しゅったい, 今日 as こんにち and 日本 — all three
thrown out of N3 by hand the day before. The waste of reading is the small
part: a word refused as a proper noun at one rung and accepted at the next is
not a curriculum, it is two opinions.

**A rejection is keyed by (id, headword), not by id.** The first version
keyed on the id alone and silently cost this rung 捜査, because `w_sousa` had
already been refused at N3 — as 走査, raster scanning. That is also why the
reject files now name the headword in a column of their own: a row reading
`w_sousa register imaging technology` does not say which そうさ its writer
meant.

**And an id belongs to whichever word the DIALOGUE order ranks first, at
every rung.** Three words read どうし: 同志, 同士 and 同市. Ranked by
dialogue the id goes to 同志, which is a word; ranked by the newspaper it
goes to 同市, "the said city", which is journalese. The ranking a rung is
built with cannot be allowed to decide what a name means, or `w_doushi` would
be one word while N3 is built and another while N2 is — and that is the
identity-splitting the pool exists to prevent, arriving by the back door.

## What was judgment

2,900 rows were read by hand in rank order and 724 thrown out — 25%, against
12% at N3, which is the newspaper's bias showing up as work.

| rejected | why | examples |
| --- | --- | --- |
| 402 | **register** — and at this rung the trade is usually journalism itself | 同省, 与野党, 党利, 戦況, 打率, 安打, 地検 |
| 95 | **proper noun** — the newspaper corpus is thick with them | 自民党, 外務省, 北海道, 台湾, 日本銀行 |
| 69 | **rare** — formal, literary or archaic | 人心, 万国, 学徒, 宿駅 |
| 34 | **artefact** — two words the segmenter joined | 高品質, 現段階, 新聞記事, 深刻化 |
| 25 | **numeral** | 十二, 三枚, 数万, 一億 |
| 17 | **fragment** — half of a longer word | 人文, 国勢, 多面, 三次, 清涼 |
| 9 | **stem** — a nominalised verb | 示し, 戻り, 盗み, 磨き |
| 13 | one or two each: a suffix (越し, 抜き), an expression (何か, 中でも), an alternate reading (留保 for 保留), a homophone (裏面, twice over), a mis-glossed entry (手取り) |

**Journalese did most of the work**, and it is a different thing from N3's
trade register. 同省, 同県, 同夜, 同地, 両党, 党内, 与野党 are not words a
learner needs; they are a newspaper's own shorthand for things it has already
named, and a subtitle corpus has nothing like them. The sports page accounts
for about forty rows on its own — 打率, 安打, 代打, 完投, 四死球, 初球 — and
the sumo calendar for a dozen more.

The one judgment I want to flag as mine rather than the rule's: political and
economic vocabulary stayed. 政権, 与党, 野党, 法案, 財政, 貿易, 選挙,
改革, 不況 are all picks, and at N3 I rejected their cousins as Diet
reporting. That is not inconsistency, it is the rung: N2 is where reading a
newspaper is the point, so the newspaper's subject matter is the syllabus.
What gets refused is its *shorthand*, not its *topics*.

## The bit that is not defensible, and is not meant to be

The review stopped at rank 2,900 of 9,490, once the rung was met. The
remaining 6,590 rows are not junk; they are ordered by a newspaper's opinion
of words a learner has yet to meet, and reading further would be reading
past the question. The boundary is a budget, not a claim, and moving it is
one number in one command:

```
./langpop dump --lang ja > work/ja-dump.json
python3 tools/draft-picks.py work n2 newspaper
python3 tools/mkpicks.py work 3400 n2 > graph/ja/picks/n2.pl
./langpop import --source jmdict --file ~/langpop-upstream/JMdict_e \
    --picks graph/ja/picks/n2.pl
```

## What it moved

| | before | after |
| --- | --- | --- |
| items in the graph | 7,565 | 9,741 |
| askable Japanese words | 3,978 | 6,154 |
| `exit(ja, n2, vocabulary(6000, read))` | short by 2,022 | **ok**, with 154 to spare |
| `exit(ja, n1, vocabulary(10000, read))` | short by 6,021 | short by 3,846 |
| criteria met | 20 | 21 |
| `./langpop --check` | 5.6 s | 10.5 s |

Every Japanese **reading** criterion on the ladder is now met except N1's,
and N1 wants 3,846 more words than the graph holds. The `hear` half of all
six rungs is still 98 askable out of 6,154, which is the audio build and
remains the student's own: the recordings are theirs.

The last row is the one to watch. The graph grew by a factor of 1.29 and the
integrity report by 1.87 — superlinear again, but two orders of magnitude
away from the 402 seconds that finding 24 in
[langpop-standalone-and-validation.md](langpop-standalone-and-validation.md)
describes, and now dominated by the parts of the check that were never the
problem.
