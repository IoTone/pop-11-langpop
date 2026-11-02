# N3 kanji: the one rung the source cannot answer

*Written 2026-11-01, while filling `exit(ja, n3, kanji(650, read))`.*

Every other kanji count on the Japanese ladder is read off a field.
KANJIDIC2 carries `<jlpt>`, the pre-2010 four-level syllabus, and the old
levels map onto the new ones exactly:

| old level | characters | cumulative | new rung | criterion |
| --- | --- | --- | --- | --- |
| 4 | 103 | 103 | N5 | `kanji(103, read)` |
| 3 | 181 | 284 | N4 | `kanji(284, read)` |
| 2 | 739 | 1023 | N2 | `kanji(1023, read)` |
| 1 | 1207 | 2230 | N1 | `kanji(2230, read)` |

The cumulative column *is* the ladder's numbers. Nothing was fitted to make
that true: `graph/ja/ladder.pl` took the counts from the published syllabus
and the import reads the same field, which is why N5 and N4 came out exact
to the character.

N3 is the rung that was inserted in 2010 with no old equivalent, and
`provenance(exit(ja, n3, kanji(_, _), _, _), estimate(community))` has said
so since the ladder was written. Its 650 is cumulative, 284 of which is
already taught, so the question is **which 366 of old level 2's 739
characters belong at N3, and which 373 stay at N2**.

No upstream field answers that. What follows is a decision, and it is
recorded here so that the next person can disagree with it in one command
rather than by reading the data.

## What can be ranked

All 739 old-level-2 characters carry a `<freq>` — the newspaper frequency
rank, 1 to 2501 — so a frequency ordering is total and has no ties to break.
They also carry `<grade>`, the year of Japanese school in which the
character is taught:

| grade | 1 | 2 | 3 | 4 | 5 | 8 |
| --- | --- | --- | --- | --- | --- | --- |
| characters | 8 | 38 | 122 | 142 | 160 | 160 |
| cumulative | 8 | 46 | 168 | 310 | 470 | 739 |

Grade 8 is secondary school; 579 of the 739 are *kyōiku* kanji, taught in
elementary school. 366 falls between grade 4 (310) and grade 5 (470), so
grade alone does not land on the number either.

## The two candidate rules, and what separates them

**By frequency.** The 366 most frequent. Simple, exact, and the boundary is
clean — 換 at rank 687 is in, 久 at 688 is out, with no tie across it.

**By grade, then frequency.** All of grades 1 to 4, which is 310 characters,
then the 56 most frequent of grade 5. Frequency is used only where the
syllabus is silent, which is inside a single school year.

Both are reproducible one-liners. They disagree about 118 characters, and
the disagreement is not noise — it is a difference of kind:

| | |
| --- | --- |
| only under **grade, then frequency** | 令 仲 倍 億 兆 列 刷 努 勇 包 卒 司 君 固 坂 城 塩 季 孫 宿 寺 岩 希 帯 幸 底 庫 庭 康 徒 息 悲 才 折 拾 散 昔 星 晴 曲 札 束 板 柱 栄 械 植 欠 歯 毛 氷 油 波 泣 泳 浅 浴 清 温 湖 湯 漁 灯 炭 焼 照 熱 玉 畑 皮 皿 礼 祝 祭 秒 章 童 笑 筆 等 箱 節 糸 級 絵 緑 練 群 羽 老 臣 船 芸 草 荷 虫 血 衣 覚 角 訓 貝 貨 輪 遊 酒 陸 陽 雪 雲 静 順 願 香 鳴 麦 黄 鼻 |
| only under **frequency** | 与 並 亡 介 余 供 修 個 値 優 党 処 券 割 劇 効 危 収 史 否 含 呼 因 型 域 婦 存 宅 寄 専 将 展 師 幅 座 張 彼 復 批 技 担 拡 捕 捜 授 採 接 換 故 旧 易 権 欧 武 歳 歴 段 殺 河 況 済 渡 湾 準 独 率 環 異 疑 療 破 禁 移 程 突 編 脳 舞 航 般 若 蔵 被 装 補 製 訪 評 認 論 諸 講 識 警 象 財 販 責 貿 賞 超 輸 込 迎 述 退 逆 造 違 適 針 降 限 除 難 非 革 額 |

Snow, cloud, lake, hot water, sake, ship, tooth, nose, blood against
political party, trade, police, prosecution, criticism, rights. The
frequency ranking is a *newspaper* ranking, and a newspaper is not a day in
somebody's life. Its top of old level 2 reads 政議連対部党内相定選 — politics,
parliamentary debate, party, minister, election — and those are genuinely
the characters a Japanese newspaper uses most. They are not what a learner
at the bridge level meets most.

So: **grade, then frequency**, which is what `--order grade_freq` means. The
school grade is a published curriculum ordering written by people deciding
what to teach a beginner first, which is the same question, asked of the
same characters, by somebody with better standing to answer it than a
corpus.

The split is written into every item it produced:

```prolog
item(k_96ea, grapheme, ja, n3, kanjidic2(ucs('96ea'), jlpt(2), split(grade_freq, 366))).
```

`jlpt(2)` is a fact about upstream; `split(grade_freq, 366)` is this
decision, sitting next to it, and present on both halves because the same
decision made both.

## What this is not

It is not a published N3 kanji list, because there is no published N3 kanji
list — that is the whole reason this file exists. Schools and textbook
publishers each have one and they do not agree with each other.

It is not an N3 *word* list. `vocabulary(3750, read)` is short by 2236 and
is a separate problem with a separate source: JMdict carries no level
marking, so that tranche is a hand-written pick list in the manner of
`graph/ja/picks/n4.pl`, and the characters landing here do not choose the
words.

It does not claim the boundary is meaningful at the character. 条 is in at
grade 5 frequency 363 and 独 is out at 365, and nothing about either
character makes that the right place to stop; the ladder asked for 650 and
650 is where the count ran out. A learner who meets 独 a month early has
suffered nothing.

To disagree, change the rule rather than the data:

```sh
./langpop import --source kanjidic --file kanjidic2.xml \
    --level n3 --jlpt 2 --order freq --take 366
./langpop import --source kanjidic --file kanjidic2.xml \
    --level n2 --jlpt 2 --order freq --skip 366
```

Both halves have to be regenerated together, or a character ends up at two
levels or at none.
