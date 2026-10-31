% graph/ja/picks/n5.pl -- which words are N5, and who they are.
%
% This file is the CURATION, and it is the part of an import that is ours.
% It holds no Japanese that upstream wrote: a pick is an identity, a level
% and a lookup key, and import.p fetches the forms and
% the glosses from JMdict at build time so that upstream's share-alike
% stays on upstream's layer.  That is the whole arrangement -- see
% import.p's header, and graph/ja/generated/.gitignore.
%
% WHY A PICK LIST AT ALL.  JLPT has published no content list since 2010
% (graph/ja/ladder.pl says so at more length), and JMdict carries no level
% marking of any kind.  So unlike the N5 kanji -- which come straight out
% of KANJIDIC2's <jlpt> field, because old level 4 is exactly what became
% N5 -- "which words are N5" is a judgment nobody upstream has made, and
% a human has to make it here.  These are therefore an ESTIMATE, and
% graph/ja/ladder.pl's provenance(exit(ja, n5, _), estimate(community))
% already says so for the counts they are measured against.
%
%   pick(Id, Lang, Level, Kind, Key).
%
% The key names an upstream entry one of three ways:
%
%   jmdict_kanji('山')     the entry whose kanji headword is 山
%   jmdict_kana('きっぷ')   the entry whose reading is きっぷ
%   jmdict('1518850')     that entry, by sequence number
%
% The first two are what a person can actually write.  The third is the
% escape hatch, and it is needed more often than it looks: 空 is そら and
% から and くう, and a key that names three entries names none of them.
% The importer REFUSES an ambiguous key and prints the candidates with
% their glosses, which is how the jmdict(...) keys below were arrived at.
%
% WHAT IS NOT HERE.  The forty words at pre-school (graph/ja/items.pl) are
% N5 words too, and they are deliberately not re-picked.  An item is its
% identity and not its spelling, so みず and 水 are one item, w_mizu, which
% already exists -- and the N5 work for that word is the CHARACTER 水,
% which the kanji import already made an item in its own right.  Picking
% it again would mint a second identity for one word and split a student's
% beliefs in half without telling anybody.  import.p refuses that too.
%
% HOMOPHONES.  The ids are romaji and Japanese is rich in homophones, so
% sooner or later a pick wants an id that is taken.  The convention: a
% short English sense tag after the romaji -- 気 is w_ki_mind, because
% w_ki is 木.  Readable in a journal without a lookup, and the tag is
% the curator's one word for which word this is, not a translation.
%
% THE SIZE OF IT.  This was a first tranche of a few over 160 picks; it is
% 773 now, in three, and exit(ja, n5, vocabulary(800, read), ...) is met --
% 823 words counting the fifty at pre-school, 804 of them askable.  What
% is left on the rung is the listening half, and that is a build step
% rather than curation: the words are here, and `--audio n5` is what
% makes them hearable.

% --- The world ------------------------------------------------------------
pick(w_yama,       ja, n5, word, jmdict('1302680')).
pick(w_kawa, ja, n5, word, jmdict_kanji('川')).
pick(w_umi,        ja, n5, word, jmdict_kanji('海')).
pick(w_sora, ja, n5, word, jmdict('1245290')).
pick(w_hana, ja, n5, word, jmdict_kanji('花')).
pick(w_ki, ja, n5, word, jmdict('1534520')).
pick(w_ishi, ja, n5, word, jmdict('1382440')).
pick(w_ame, ja, n5, word, jmdict_kanji('雨')).
pick(w_yuki,       ja, n5, word, jmdict_kanji('雪')).
pick(w_kaze, ja, n5, word, jmdict('1499720')).
pick(w_tenki,      ja, n5, word, jmdict_kanji('天気')).
pick(w_hi, ja, n5, word, jmdict('1463770')).

% --- Time -----------------------------------------------------------------
pick(w_jikan,      ja, n5, word, jmdict_kanji('時間')).
pick(w_tokei,      ja, n5, word, jmdict_kanji('時計')).
pick(w_mainichi,   ja, n5, word, jmdict_kanji('毎日')).
pick(w_kinou,      ja, n5, word, jmdict_kanji('昨日')).
pick(w_gozen,      ja, n5, word, jmdict_kanji('午前')).
pick(w_gogo,       ja, n5, word, jmdict_kanji('午後')).
pick(w_kotoshi,    ja, n5, word, jmdict_kanji('今年')).
pick(w_rainen,     ja, n5, word, jmdict_kanji('来年')).
pick(w_kyonen,     ja, n5, word, jmdict_kanji('去年')).
pick(w_konshuu,    ja, n5, word, jmdict_kanji('今週')).
pick(w_raishuu,    ja, n5, word, jmdict_kanji('来週')).
pick(w_senshuu,    ja, n5, word, jmdict_kanji('先週')).
pick(w_tanjoubi,   ja, n5, word, jmdict_kanji('誕生日')).

% --- Places ---------------------------------------------------------------
pick(w_eki, ja, n5, word, jmdict_kanji('駅')).
pick(w_mise, ja, n5, word, jmdict('1582120')).
pick(w_michi, ja, n5, word, jmdict('1454080')).
pick(w_mado,       ja, n5, word, jmdict_kanji('窓')).
pick(w_heya,       ja, n5, word, jmdict_kanji('部屋')).
pick(w_daidokoro,  ja, n5, word, jmdict_kanji('台所')).
pick(w_genkan,     ja, n5, word, jmdict_kanji('玄関')).
pick(w_kaidan,     ja, n5, word, jmdict_kanji('階段')).
pick(w_kuni, ja, n5, word, jmdict_kanji('国')).
pick(w_machi, ja, n5, word, jmdict('1603990')).
pick(w_mura, ja, n5, word, jmdict_kanji('村')).
pick(w_kaisha,     ja, n5, word, jmdict_kanji('会社')).
pick(w_ginkou,     ja, n5, word, jmdict_kanji('銀行')).
pick(w_byouin,     ja, n5, word, jmdict_kanji('病院')).
pick(w_toshokan,   ja, n5, word, jmdict_kanji('図書館')).
pick(w_yuubinkyoku,ja, n5, word, jmdict_kanji('郵便局')).
pick(w_daigaku,    ja, n5, word, jmdict_kanji('大学')).

% --- Getting about --------------------------------------------------------
pick(w_densha,     ja, n5, word, jmdict_kanji('電車')).
pick(w_jitensha,   ja, n5, word, jmdict_kanji('自転車')).
pick(w_hikouki,    ja, n5, word, jmdict_kanji('飛行機')).
pick(w_kippu,      ja, n5, word, jmdict_kanji('切符')).
pick(w_denwa,      ja, n5, word, jmdict_kanji('電話')).
pick(w_tegami,     ja, n5, word, jmdict_kanji('手紙')).
pick(w_shinbun,    ja, n5, word, jmdict_kanji('新聞')).
pick(w_shashin,    ja, n5, word, jmdict_kanji('写真')).

% --- Doing things ---------------------------------------------------------
pick(w_ongaku,     ja, n5, word, jmdict_kanji('音楽')).
pick(w_eiga,       ja, n5, word, jmdict_kanji('映画')).
pick(w_ryouri,     ja, n5, word, jmdict_kanji('料理')).
pick(w_shigoto,    ja, n5, word, jmdict_kanji('仕事')).
pick(w_yasumi, ja, n5, word, jmdict_kanji('休み')).
pick(w_ryokou,     ja, n5, word, jmdict_kanji('旅行')).
pick(w_yakusoku,   ja, n5, word, jmdict_kanji('約束')).
pick(w_renshuu,    ja, n5, word, jmdict_kanji('練習')).
pick(w_shukudai,   ja, n5, word, jmdict_kanji('宿題')).
pick(w_shiken,     ja, n5, word, jmdict_kanji('試験')).
pick(w_imi,        ja, n5, word, jmdict_kanji('意味')).
pick(w_shitsumon,  ja, n5, word, jmdict_kanji('質問')).
pick(w_mondai,     ja, n5, word, jmdict_kanji('問題')).

% --- Eating ---------------------------------------------------------------
pick(w_yasai,      ja, n5, word, jmdict_kanji('野菜')).
pick(w_kudamono,   ja, n5, word, jmdict_kanji('果物')).
pick(w_niku, ja, n5, word, jmdict('1463520')).
pick(w_tamago, ja, n5, word, jmdict('1549140')).
pick(w_kome, ja, n5, word, jmdict('1508750')).
pick(w_shio, ja, n5, word, jmdict('1576630')).
pick(w_satou,      ja, n5, word, jmdict_kanji('砂糖')).
pick(w_gyuunyuu,   ja, n5, word, jmdict_kanji('牛乳')).
pick(w_ocha,       ja, n5, word, jmdict_kanji('お茶')).
pick(w_asagohan,   ja, n5, word, jmdict_kanji('朝御飯')).
pick(w_hirugohan,  ja, n5, word, jmdict_kanji('昼御飯')).
pick(w_bangohan,   ja, n5, word, jmdict_kanji('晩御飯')).

% --- Things you carry -----------------------------------------------------
pick(w_saifu,      ja, n5, word, jmdict_kanji('財布')).
pick(w_kaban, ja, n5, word, jmdict_kanji('鞄')).
pick(w_kutsu, ja, n5, word, jmdict_kanji('靴')).
pick(w_fuku, ja, n5, word, jmdict('1500940')).
pick(w_boushi,     ja, n5, word, jmdict_kanji('帽子')).
pick(w_megane, ja, n5, word, jmdict('1577670')).
pick(w_kasa, ja, n5, word, jmdict('1301940')).
pick(w_kagi, ja, n5, word, jmdict('1260490')).
pick(w_kami, ja, n5, word, jmdict('1311530')).
pick(w_enpitsu,    ja, n5, word, jmdict_kanji('鉛筆')).
pick(w_jisho,      ja, n5, word, jmdict_kanji('辞書')).
pick(w_zasshi,     ja, n5, word, jmdict_kanji('雑誌')).
pick(w_chizu,      ja, n5, word, jmdict_kanji('地図')).

% --- People ---------------------------------------------------------------
pick(w_kazoku,     ja, n5, word, jmdict_kanji('家族')).
pick(w_chichi, ja, n5, word, jmdict('1497610')).
pick(w_haha, ja, n5, word, jmdict('1514990')).
pick(w_ani, ja, n5, word, jmdict('1249900')).
pick(w_ane, ja, n5, word, jmdict('1307630')).
pick(w_otouto, ja, n5, word, jmdict('1581930')).
pick(w_imouto, ja, n5, word, jmdict('1524590')).
pick(w_kodomo,     ja, n5, word, jmdict_kanji('子供')).
pick(w_otoko, ja, n5, word, jmdict('1419990')).
pick(w_onna, ja, n5, word, jmdict('1344930')).

% --- Verbs ----------------------------------------------------------------
pick(w_kaku, ja, n5, word, jmdict_kanji('書く')).
pick(w_yomu,       ja, n5, word, jmdict_kanji('読む')).
pick(w_kiku, ja, n5, word, jmdict_kanji('聞く')).
pick(w_hanasu,     ja, n5, word, jmdict_kanji('話す')).
pick(w_au, ja, n5, word, jmdict_kanji('会う')).
pick(w_kau,        ja, n5, word, jmdict_kanji('買う')).
pick(w_uru,        ja, n5, word, jmdict_kanji('売る')).
pick(w_tsukau, ja, n5, word, jmdict_kanji('使う')).
pick(w_tsukuru, ja, n5, word, jmdict_kanji('作る')).
pick(w_matsu,      ja, n5, word, jmdict_kanji('待つ')).
pick(w_motsu,      ja, n5, word, jmdict_kanji('持つ')).
pick(w_aruku,      ja, n5, word, jmdict_kanji('歩く')).
pick(w_hashiru,    ja, n5, word, jmdict_kanji('走る')).
pick(w_yasumu,     ja, n5, word, jmdict_kanji('休む')).
pick(w_hataraku, ja, n5, word, jmdict_kanji('働く')).
pick(w_oshieru,    ja, n5, word, jmdict_kanji('教える')).
pick(w_oboeru,     ja, n5, word, jmdict_kanji('覚える')).
pick(w_wasureru,   ja, n5, word, jmdict_kanji('忘れる')).
pick(w_hajimaru,   ja, n5, word, jmdict_kanji('始まる')).
pick(w_owaru, ja, n5, word, jmdict_kanji('終わる')).
pick(w_hairu, ja, n5, word, jmdict('1465590')).
pick(w_deru, ja, n5, word, jmdict_kanji('出る')).
pick(w_kaeru, ja, n5, word, jmdict_kanji('帰る')).
pick(w_neru, ja, n5, word, jmdict_kanji('寝る')).
pick(w_okiru,      ja, n5, word, jmdict_kanji('起きる')).
pick(w_wakaru, ja, n5, word, jmdict_kanji('分かる')).
pick(w_shiru, ja, n5, word, jmdict_kanji('知る')).
pick(w_sumu, ja, n5, word, jmdict_kanji('住む')).
pick(w_noru, ja, n5, word, jmdict_kanji('乗る')).
pick(w_oriru, ja, n5, word, jmdict_kanji('降りる')).

% --- Adjectives -----------------------------------------------------------
pick(w_nagai,      ja, n5, word, jmdict_kanji('長い')).
pick(w_mijikai,    ja, n5, word, jmdict_kanji('短い')).
pick(w_tsuyoi,     ja, n5, word, jmdict('1236070')).
pick(w_yowai,      ja, n5, word, jmdict_kanji('弱い')).
pick(w_hayai, ja, n5, word, jmdict_kanji('早い')).
pick(w_osoi,       ja, n5, word, jmdict_kanji('遅い')).
pick(w_akarui,     ja, n5, word, jmdict_kanji('明るい')).
pick(w_kurai, ja, n5, word, jmdict_kanji('暗い')).
pick(w_hiroi,      ja, n5, word, jmdict_kanji('広い')).
pick(w_semai,      ja, n5, word, jmdict_kanji('狭い')).
pick(w_omoi, ja, n5, word, jmdict_kanji('重い')).
pick(w_karui, ja, n5, word, jmdict_kanji('軽い')).
pick(w_muzukashii, ja, n5, word, jmdict_kanji('難しい')).
pick(w_kantan,     ja, n5, word, jmdict_kanji('簡単')).
pick(w_shizuka,    ja, n5, word, jmdict_kanji('静か')).
pick(w_nigiyaka,   ja, n5, word, jmdict_kanji('賑やか')).
pick(w_kirei, ja, n5, word, jmdict_kanji('綺麗')).
pick(w_genki,      ja, n5, word, jmdict_kanji('元気')).
pick(w_yuumei,     ja, n5, word, jmdict_kanji('有名')).
pick(w_benri,      ja, n5, word, jmdict_kanji('便利')).

% --- Prerequisites a human has to state -----------------------------------
% The importer already draws two kinds of edge on its own: every imported
% word needs the kana, and a word written with a kanji the graph holds
% needs that kanji (import.p's imp_kanji_reqs -- 本 is in 日本, and that
% is not an opinion).  What it cannot work out is teaching ORDER between
% words, so the few that matter are stated here.
%
% These are the antonym pairs, where the second word of each is introduced
% AS the negation of the first and is close to meaningless before it.  It
% is the same judgment graph/ja/kana.pl makes about dakuten: か before が,
% because the second is the first with a mark on it.
pick_requires(w_mijikai, w_nagai).
pick_requires(w_yowai,   w_tsuyoi).
pick_requires(w_osoi,    w_hayai).
pick_requires(w_kurai,   w_akarui).
pick_requires(w_semai,   w_hiroi).
pick_requires(w_karui,   w_omoi).
pick_requires(w_uru,     w_kau).
pick_requires(w_owaru,   w_hajimaru).
pick_requires(w_oriru,   w_noru).
pick_requires(w_deru,    w_hairu).

% Meals are one pattern with the time of day changed, and the pattern is
% worth more than the three words: a student who has 朝御飯 gets the other
% two for the price of the time word.
pick_requires(w_hirugohan, w_asagohan).
pick_requires(w_bangohan,  w_asagohan).

% --- The frequency tranche of 2026-10-30 -----------------------------------
% From import.p --source frequency --gap against ja_full.txt
% (OpenSubtitles, 34,504 entries), marked in docs/langpop-japanese-tranche.md.
% Shares are of all dialogue tokens; together these carry ~14.6%.
%
% あなた and お前 are both here and both real, but the choice between
% them is a register lesson the vocabulary rows cannot teach -- a
% politeness pattern item is flagged in the tranche doc and not yet built.

pick(w_nani,     ja, n5, word, jmdict('1577100')).      % 何 なに     2.67%
pick(w_anata,    ja, n5, word, jmdict('1223615')).      % 貴方 あなた  1.61%
pick(w_iu,       ja, n5, word, jmdict_kanji('言う')).   %            1.40%
pick(w_koto,     ja, n5, word, jmdict('1313580')).      % 事 こと     0.89%
pick(w_kanojo,   ja, n5, word, jmdict_kanji('彼女')).   %            0.87%
pick(w_omae,     ja, n5, word, jmdict_kanji('お前')).   %            0.83%
pick(w_toki,     ja, n5, word, jmdict('1315840')).      % 時 とき     0.51%
pick(w_shinu,    ja, n5, word, jmdict_kanji('死ぬ')).   %            0.51%
pick(w_korosu,   ja, n5, word, jmdict_kanji('殺す')).   %            0.47%
pick(w_mae,      ja, n5, word, jmdict('1392580')).      % 前 まえ     0.47%
pick(w_naka,     ja, n5, word, jmdict('1423310')).      % 中 なか     0.47%
pick(w_hitsuyou, ja, n5, word, jmdict_kanji('必要')).   %            0.43%
pick(w_ki_mind,  ja, n5, word, jmdict('1221520')).      % 気 き       0.42%
pick(w_daijoubu, ja, n5, word, jmdict('1414150')).      % 大丈夫      0.40%
pick(w_jibun,    ja, n5, word, jmdict_kanji('自分')).   %            0.39%
pick(w_hontou,   ja, n5, word, jmdict_kanji('本当')).   %            0.37%
pick(w_ichi,     ja, n5, word, jmdict('1160790')).      % 一 いち     0.37%
pick(w_nai,      ja, n5, word, jmdict_kanji('無い')).   %            0.35%
pick(w_arigatou, ja, n5, word, jmdict_kana('ありがとう')). %         0.35%
pick(w_toshi,    ja, n5, word, jmdict('1468060')).      % 年 とし     0.33%
pick(w_ato,      ja, n5, word, jmdict('1269320')).      % 後 あと     0.28%
pick(w_dekiru,   ja, n5, word, jmdict_kanji('出来る')). %            0.28%

% --- The second tranche, 2026-10-31 ---------------------------------------
% The rung asks for vocabulary(800) and held 220 counting pre-school.  These
% are the 580 that finish it.
%
% WHAT CHOSE THEM.  A beginner syllabus, not a frequency list.  The order of
% the sections is roughly the order a first-year course moves through -- the
% people in the room, the body, what is on the table, what is outside the
% window -- because a vocabulary list that is not grouped is a vocabulary
% list nobody can teach from.
%
% AND NOT ATTESTED, which graph/en/a1.pl's words are.  The English list is
% checked against a frequency corpus after it is curated -- the corpus
% chooses nothing, but it confirms that a spelling is current English.  The
% same check was run here and cannot be trusted: hermitdave's 2018 Japanese
% list is missing 私, 僕, 君, 俺 and 誰 in every spelling while holding 、,
% 。, あなた and お前, so it called 僕 and 誰 absent from Japanese.  These
% words are therefore curation and nothing else, and the same fact is why
% no Japanese coverage figure in this repository should be believed.  See
% DESIGN_NOTES.md.
%
% WHAT IS NOT HERE.  Grammar.  A particle is not a word a student reads and
% glosses -- は, を, の, が, に, で, から, まで, と, も, や, か do their work
% in a pattern, and the three pattern items in graph/ja/items.pl are where
% that belongs.  Nor the copula, nor the auxiliary endings: ます, です, ない,
% たい, ている are conjugation, and an item whose form is a suffix cannot be
% asked as a word.  Counters are here only where they are also read on their
% own (円, 歳, 回, 番); 枚 and 匹 and 冊 are patterns waiting for a pattern
% item to need them.
%
% HOMOPHONES.  Japanese has many and a first-year list meets most of them.
% The header's convention applies: a sense tag after the romaji, the
% curator's one word for which word this is.  Three sets below are worth
% naming because a learner meets both halves in the same term --
%
%   w_hana      花    w_hana_nose   鼻
%   w_kami      紙    w_kami_hair   髪
%   w_atsui     暑い  w_atsui_thick 厚い   (and 熱い is w_atsui_touch)
%
% 速い IS NOT ONE OF THEM, and the attempt is worth recording.  A pick
% w_hayai_fast keyed on 速い was written here, to sit beside w_hayai for
% 早い -- and JMdict holds 早い and 速い as ONE entry, 1404975, with two
% kanji headwords and the reading はやい.  So both picks resolved to the
% same entry and the importer, which emits the first headword, produced
% two items with identical forms and an identical gloss.  A student would
% have met the same question under two names and both would have counted.
%
% The entry is right and the pick was wrong: to JMdict this is one word
% spelled two ways, not two words.  Teaching 速い as its own item needs
% the importer to emit a word's SECOND kanji form, which it does not, so
% the row is gone rather than half-built.  import.p refuses the shape now
% -- two picks on one entry is a collision, reported with both ids.

% --- People, continued ----------------------------------------------------
pick(w_watashi,    ja, n5, word, jmdict('1311110')). % 私 わたし
pick(w_boku,       ja, n5, word, jmdict('1521400')). % 僕 ぼく
pick(w_kare,       ja, n5, word, jmdict('1483070')). % 彼 かれ
pick(w_kimi,       ja, n5, word, jmdict('1247250')). % 君/公 きみ
pick(w_minasan,    ja, n5, word, jmdict_kanji('皆さん')).
pick(w_sofu,       ja, n5, word, jmdict_kanji('祖父')).
pick(w_sobo,       ja, n5, word, jmdict_kanji('祖母')).
pick(w_ryoushin,   ja, n5, word, jmdict_kanji('両親')).
pick(w_kyoudai,    ja, n5, word, jmdict('1249960')). % 兄弟 きょうだい
pick(w_shimai,     ja, n5, word, jmdict_kanji('姉妹')).
pick(w_otousan,    ja, n5, word, jmdict_kanji('お父さん')).
pick(w_okaasan,    ja, n5, word, jmdict_kanji('お母さん')).
pick(w_oniisan,    ja, n5, word, jmdict_kanji('お兄さん')).
pick(w_oneesan,    ja, n5, word, jmdict_kanji('お姉さん')).
pick(w_ojisan,     ja, n5, word, jmdict_kana('おじさん')).
pick(w_obasan,     ja, n5, word, jmdict('2261500')). % 伯母さん おばさん -- aunt
pick(w_musuko,     ja, n5, word, jmdict_kanji('息子')).
pick(w_musume,     ja, n5, word, jmdict('1531190')). % 娘 むすめ
pick(w_akachan,    ja, n5, word, jmdict_kanji('赤ちゃん')).
pick(w_otona,      ja, n5, word, jmdict('1414170')). % 大人 おとな
pick(w_okusan,     ja, n5, word, jmdict_kanji('奥さん')).
pick(w_shujin,     ja, n5, word, jmdict('1579780')). % 主人 しゅじん
pick(w_otokonoko,  ja, n5, word, jmdict('1420010')). % 男の子/男のコ おとこのこ
pick(w_onnanoko,   ja, n5, word, jmdict('1344970')). % 女の子/女のコ/オンナの子/女のこ おんなのこ
pick(w_hitori,     ja, n5, word, jmdict_kanji('一人')).
pick(w_futari,     ja, n5, word, jmdict_kanji('二人')).
pick(w_oozei,      ja, n5, word, jmdict('1414220')). % 大勢/大ぜい おおぜい
pick(w_tonari,     ja, n5, word, jmdict_kanji('隣')).
pick(w_okyakusan,  ja, n5, word, jmdict_kanji('お客さん')).
pick(w_isha,       ja, n5, word, jmdict_kanji('医者')).
pick(w_kangoshi,   ja, n5, word, jmdict_kanji('看護師')).
pick(w_keisatsu,   ja, n5, word, jmdict_kanji('警察')).
pick(w_untenshu,   ja, n5, word, jmdict_kanji('運転手')).
pick(w_tenin,      ja, n5, word, jmdict_kanji('店員')).
pick(w_shachou,    ja, n5, word, jmdict_kanji('社長')).
pick(w_kaishain,   ja, n5, word, jmdict_kanji('会社員')).
pick(w_ryuugakusei,ja, n5, word, jmdict_kanji('留学生')).
pick(w_gaikokujin, ja, n5, word, jmdict_kanji('外国人')).
pick(w_wakai,      ja, n5, word, jmdict_kanji('若い')).

% --- The body -------------------------------------------------------------
pick(w_karada,     ja, n5, word, jmdict('1409140')). % 体/身体/躯/躰/體/軀 からだ
pick(w_kao,        ja, n5, word, jmdict('1217730')). % 顔/貌/顏 かお
pick(w_mimi,       ja, n5, word, jmdict_kanji('耳')).
pick(w_hana_nose,  ja, n5, word, jmdict_kanji('鼻')).
pick(w_ha,         ja, n5, word, jmdict('1313000')). % 歯/齒 は
pick(w_kubi,       ja, n5, word, jmdict('1592270')). % 首/頸/頚/馘 くび
pick(w_kata_shoulder, ja, n5, word, jmdict_kanji('肩')).
pick(w_ude,        ja, n5, word, jmdict('1562850')). % 腕 うで
pick(w_yubi,       ja, n5, word, jmdict('1309650')). % 指 ゆび
pick(w_ashi,       ja, n5, word, jmdict('1404630')). % 足/脚/肢 あし
pick(w_senaka,     ja, n5, word, jmdict('1472800')). % 背中/背なか せなか
pick(w_kami_hair,  ja, n5, word, jmdict('1477950')). % 髪/髮 かみ
pick(w_koe,        ja, n5, word, jmdict('1380440')). % 声/聲 こえ
pick(w_kokoro,     ja, n5, word, jmdict('1360480')). % 心 こころ
pick(w_chi,        ja, n5, word, jmdict_kanji('血')).
pick(w_byouki,     ja, n5, word, jmdict('1490230')). % 病気/病氣 びょうき
pick(w_kega,       ja, n5, word, jmdict_kanji('怪我')).
pick(w_kusuri,     ja, n5, word, jmdict('1538160')). % 薬 くすり
pick(w_netsu,      ja, n5, word, jmdict('1467710')). % 熱 ねつ
pick(w_kaze_cold,  ja, n5, word, jmdict_kanji('風邪')).
pick(w_itai,       ja, n5, word, jmdict_kanji('痛い')).

% --- Food and drink -------------------------------------------------------
pick(w_gohan,      ja, n5, word, jmdict('1270590')). % ご飯/御飯 ごはん
pick(w_tabemono,   ja, n5, word, jmdict_kanji('食べ物')).
pick(w_nomimono,   ja, n5, word, jmdict_kanji('飲み物')).
pick(w_pan,        ja, n5, word, jmdict('1103090')). % パン -- bread
pick(w_koohii,     ja, n5, word, jmdict_kana('コーヒー')).
pick(w_koucha,     ja, n5, word, jmdict_kanji('紅茶')).
pick(w_juusu,      ja, n5, word, jmdict('1065950')). % ジュース -- juice
pick(w_biiru,      ja, n5, word, jmdict('2796520')). % ビール ビール
pick(w_osake,      ja, n5, word, jmdict_kanji('お酒')).
pick(w_koori,      ja, n5, word, jmdict('1488840')). % 氷/凍り こおり
pick(w_bentou,     ja, n5, word, jmdict_kanji('弁当')).
pick(w_sushi,      ja, n5, word, jmdict_kanji('寿司')).
pick(w_sashimi,    ja, n5, word, jmdict_kanji('刺身')).
pick(w_tempura,    ja, n5, word, jmdict_kanji('天麩羅')).
pick(w_soba,       ja, n5, word, jmdict_kanji('蕎麦')).
pick(w_udon,       ja, n5, word, jmdict('1574470')). % 饂飩 うどん
pick(w_raamen,     ja, n5, word, jmdict('2207500')). % ラーメン ラーメン
pick(w_karee,      ja, n5, word, jmdict_kana('カレー')).
pick(w_sarada,     ja, n5, word, jmdict_kana('サラダ')).
pick(w_suupu,      ja, n5, word, jmdict_kana('スープ')).
pick(w_keeki,      ja, n5, word, jmdict_kana('ケーキ')).
pick(w_aisukuriimu,ja, n5, word, jmdict_kana('アイスクリーム')).
pick(w_okashi,     ja, n5, word, jmdict_kanji('お菓子')).
pick(w_ame_candy,  ja, n5, word, jmdict('1153520')). % 飴 あめ
pick(w_chokoreeto, ja, n5, word, jmdict_kana('チョコレート')).
pick(w_ringo,      ja, n5, word, jmdict('1555480')). % 林檎 りんご
pick(w_mikan,      ja, n5, word, jmdict_kanji('蜜柑')).
pick(w_banana,     ja, n5, word, jmdict_kana('バナナ')).
pick(w_ichigo,     ja, n5, word, jmdict_kanji('苺')).
pick(w_suika,      ja, n5, word, jmdict_kanji('西瓜')).
pick(w_budou,      ja, n5, word, jmdict_kanji('葡萄')).
pick(w_momo,       ja, n5, word, jmdict_kanji('桃')).
pick(w_nashi,      ja, n5, word, jmdict_kanji('梨')).
pick(w_tomato,     ja, n5, word, jmdict_kana('トマト')).
pick(w_ninjin,     ja, n5, word, jmdict_kanji('人参')).
pick(w_jagaimo,    ja, n5, word, jmdict_kanji('じゃが芋')).
pick(w_tamanegi,   ja, n5, word, jmdict_kanji('玉葱')).
pick(w_kyuuri,     ja, n5, word, jmdict_kanji('胡瓜')).
pick(w_kyabetsu,   ja, n5, word, jmdict_kana('キャベツ')).
pick(w_daikon,     ja, n5, word, jmdict('1413730')). % 大根 だいこん
pick(w_toufu,      ja, n5, word, jmdict_kanji('豆腐')).
pick(w_nattou,     ja, n5, word, jmdict_kanji('納豆')).
pick(w_miso,       ja, n5, word, jmdict_kanji('味噌')).
pick(w_shouyu,     ja, n5, word, jmdict_kanji('醤油')).
pick(w_bataa,      ja, n5, word, jmdict_kana('バター')).
pick(w_chiizu,     ja, n5, word, jmdict_kana('チーズ')).
pick(w_gyuuniku,   ja, n5, word, jmdict_kanji('牛肉')).
pick(w_butaniku,   ja, n5, word, jmdict_kanji('豚肉')).
pick(w_toriniku,   ja, n5, word, jmdict_kanji('鶏肉')).
pick(w_amai,       ja, n5, word, jmdict('1213400')). % 甘い あまい
pick(w_karai,      ja, n5, word, jmdict('1365850')). % 辛い からい
pick(w_nigai,      ja, n5, word, jmdict_kanji('苦い')).
pick(w_tsumetai,   ja, n5, word, jmdict_kanji('冷たい')).
pick(w_atsui_touch,ja, n5, word, jmdict_kanji('熱い')).

% --- At the table ---------------------------------------------------------
pick(w_hashi_chopsticks, ja, n5, word, jmdict_kanji('箸')).
pick(w_fooku,      ja, n5, word, jmdict('1110110')). % フォーク -- fork
pick(w_naifu,      ja, n5, word, jmdict_kana('ナイフ')).
pick(w_supuun,     ja, n5, word, jmdict_kana('スプーン')).
pick(w_koppu,      ja, n5, word, jmdict('2846389')). % コップ コップ
pick(w_chawan,     ja, n5, word, jmdict_kanji('茶碗')).
pick(w_sara,       ja, n5, word, jmdict_kanji('皿')).
pick(w_nabe,       ja, n5, word, jmdict_kanji('鍋')).
pick(w_reizouko,   ja, n5, word, jmdict_kanji('冷蔵庫')).

% --- Animals --------------------------------------------------------------
pick(w_doubutsu,   ja, n5, word, jmdict_kanji('動物')).
pick(w_uma,        ja, n5, word, jmdict_kanji('馬')).
pick(w_ushi,       ja, n5, word, jmdict('1231490')). % 牛 うし
pick(w_buta,       ja, n5, word, jmdict('1457390')). % 豚/豕 ぶた
pick(w_hitsuji,    ja, n5, word, jmdict_kanji('羊')).
pick(w_niwatori,   ja, n5, word, jmdict('1252990')). % 鶏/鷄/雞 にわとり
pick(w_mushi,      ja, n5, word, jmdict_kanji('虫')).
pick(w_kuma,       ja, n5, word, jmdict_kanji('熊')).
pick(w_saru,       ja, n5, word, jmdict('1177390')). % 猿/猨 さる
pick(w_zou,        ja, n5, word, jmdict('1351830')). % 象 ぞう
pick(w_usagi,      ja, n5, word, jmdict_kanji('兎')).
pick(w_nezumi,     ja, n5, word, jmdict('1397840')). % 鼠 ネズミ
pick(w_hebi,       ja, n5, word, jmdict_kanji('蛇')).
pick(w_kaeru_frog, ja, n5, word, jmdict('1577460')). % 蛙/蛤/蝦 かえる

% --- Clothes --------------------------------------------------------------
pick(w_youfuku,    ja, n5, word, jmdict_kanji('洋服')).
pick(w_kimono,     ja, n5, word, jmdict('1423240')). % 着物/著物 きもの
pick(w_shatsu,     ja, n5, word, jmdict_kana('シャツ')).
pick(w_zubon,      ja, n5, word, jmdict_kana('ズボン')).
pick(w_sukaato,    ja, n5, word, jmdict_kana('スカート')).
pick(w_uwagi,      ja, n5, word, jmdict_kanji('上着')).
pick(w_kooto,      ja, n5, word, jmdict('1049000')). % コート -- coat
pick(w_seetaa,     ja, n5, word, jmdict_kana('セーター')).
pick(w_nekutai,    ja, n5, word, jmdict_kana('ネクタイ')).
pick(w_kutsushita, ja, n5, word, jmdict_kanji('靴下')).
pick(w_tebukuro,   ja, n5, word, jmdict_kanji('手袋')).
pick(w_yubiwa,     ja, n5, word, jmdict_kanji('指輪')).
pick(w_botan,      ja, n5, word, jmdict('1123880')). % ボタン -- button
pick(w_poketto,    ja, n5, word, jmdict_kana('ポケット')).

% --- Colours --------------------------------------------------------------
pick(w_iro,        ja, n5, word, jmdict('1357600')). % 色 いろ
pick(w_aka,        ja, n5, word, jmdict_kanji('赤')).
pick(w_ao,         ja, n5, word, jmdict_kanji('青')).
pick(w_shiro,      ja, n5, word, jmdict('1474900')). % 白 しろ
pick(w_kuro,       ja, n5, word, jmdict_kanji('黒')).
pick(w_kiiro,      ja, n5, word, jmdict_kanji('黄色')).
pick(w_midori,     ja, n5, word, jmdict_kanji('緑')).
pick(w_chairo,     ja, n5, word, jmdict_kanji('茶色')).
pick(w_murasaki,   ja, n5, word, jmdict_kanji('紫')).
pick(w_haiiro,     ja, n5, word, jmdict_kanji('灰色')).

% --- Numbers --------------------------------------------------------------
pick(w_ni,         ja, n5, word, jmdict('1461140')). % 二/２/弐/弍/貳/貮 に
pick(w_san,        ja, n5, word, jmdict('2747950')). % 三 サン
pick(w_yon,        ja, n5, word, jmdict('1579470')). % 四/４/肆 よん
pick(w_go,         ja, n5, word, jmdict('1268060')). % 五/５/伍 ご
pick(w_roku,       ja, n5, word, jmdict('1585310')). % 六/６/陸 ろく
pick(w_nana,       ja, n5, word, jmdict('1319210')). % 七/７/漆/柒 なな
pick(w_hachi,      ja, n5, word, jmdict('1583090')). % 八/８/捌 はち
pick(w_kyuu,       ja, n5, word, jmdict('1578150')). % 九/９/玖 きゅう
pick(w_juu,        ja, n5, word, jmdict('1579840')). % 十/１０/拾/什/一〇 じゅう
pick(w_hyaku,      ja, n5, word, jmdict('1488000')). % 百/１００/陌/佰/一〇〇 ひゃく
pick(w_sen_thousand, ja, n5, word, jmdict_kanji('千')).
pick(w_man,        ja, n5, word, jmdict('1584460')). % 万/萬 まん
pick(w_hanbun,     ja, n5, word, jmdict('1479890')). % 半分 はんぶん
pick(w_ikutsu,     ja, n5, word, jmdict_kanji('幾つ')).
pick(w_ikura,      ja, n5, word, jmdict_kanji('幾ら')).
pick(w_bangou,     ja, n5, word, jmdict_kanji('番号')).
pick(w_en_yen,     ja, n5, word, jmdict('1175570')). % 円/圓 えん
pick(w_sai,        ja, n5, word, jmdict('1294940')). % 歳/才 さい
pick(w_kai_times,  ja, n5, word, jmdict_kanji('回')).
pick(w_ooi,        ja, n5, word, jmdict_kanji('多い')).
pick(w_sukunai,    ja, n5, word, jmdict_kanji('少ない')).
pick(w_sukoshi,    ja, n5, word, jmdict_kanji('少し')).

% --- Time, continued ------------------------------------------------------
pick(w_ima,        ja, n5, word, jmdict('1288850')). % 今 いま
pick(w_asatte,     ja, n5, word, jmdict_kanji('明後日')).
pick(w_ototoi,     ja, n5, word, jmdict_kanji('一昨日')).
pick(w_kesa,       ja, n5, word, jmdict_kanji('今朝')).
pick(w_konban,     ja, n5, word, jmdict_kanji('今晩')).
pick(w_konya,      ja, n5, word, jmdict_kanji('今夜')).
pick(w_yuugata,    ja, n5, word, jmdict_kanji('夕方')).
pick(w_hiru,       ja, n5, word, jmdict_kanji('昼')).
pick(w_maiasa,     ja, n5, word, jmdict_kanji('毎朝')).
pick(w_maiban,     ja, n5, word, jmdict_kanji('毎晩')).
pick(w_maishuu,    ja, n5, word, jmdict_kanji('毎週')).
pick(w_maitsuki,   ja, n5, word, jmdict_kanji('毎月')).
pick(w_maitoshi,   ja, n5, word, jmdict_kanji('毎年')).
pick(w_shuumatsu,  ja, n5, word, jmdict_kanji('週末')).
pick(w_youbi,      ja, n5, word, jmdict_kanji('曜日')).
pick(w_getsuyoubi, ja, n5, word, jmdict_kanji('月曜日')).
pick(w_kayoubi,    ja, n5, word, jmdict_kanji('火曜日')).
pick(w_suiyoubi,   ja, n5, word, jmdict_kanji('水曜日')).
pick(w_mokuyoubi,  ja, n5, word, jmdict_kanji('木曜日')).
pick(w_kinyoubi,   ja, n5, word, jmdict_kanji('金曜日')).
pick(w_doyoubi,    ja, n5, word, jmdict_kanji('土曜日')).
pick(w_nichiyoubi, ja, n5, word, jmdict_kanji('日曜日')).
pick(w_fun,        ja, n5, word, jmdict('1502840')). % 分 ふん
pick(w_byou,       ja, n5, word, jmdict_kanji('秒')).
pick(w_raigetsu,   ja, n5, word, jmdict_kanji('来月')).
pick(w_sengetsu,   ja, n5, word, jmdict_kanji('先月')).
pick(w_kongetsu,   ja, n5, word, jmdict_kanji('今月')).
pick(w_saikin,     ja, n5, word, jmdict_kanji('最近')).
pick(w_mukashi,    ja, n5, word, jmdict_kanji('昔')).
pick(w_kondo,      ja, n5, word, jmdict_kanji('今度')).
pick(w_tsugi,      ja, n5, word, jmdict('1316380')). % 次 つぎ
pick(w_saisho,     ja, n5, word, jmdict_kanji('最初')).
pick(w_saigo,      ja, n5, word, jmdict_kanji('最後')).
pick(w_owari,      ja, n5, word, jmdict_kanji('終わり')).
pick(w_aida,       ja, n5, word, jmdict('1215230')). % 間 あいだ
pick(w_koro,       ja, n5, word, jmdict('1579080')). % 頃/比 ころ

% --- Sky and weather ------------------------------------------------------
pick(w_taiyou,     ja, n5, word, jmdict_kanji('太陽')).
pick(w_tsuki,      ja, n5, word, jmdict('1255430')). % 月 つき
pick(w_hoshi,      ja, n5, word, jmdict('1376310')). % 星 ほし
pick(w_kumo,       ja, n5, word, jmdict_kanji('雲')).
pick(w_kaminari,   ja, n5, word, jmdict('1585060')). % 雷 かみなり
pick(w_taifuu,     ja, n5, word, jmdict_kanji('台風')).
pick(w_hare,       ja, n5, word, jmdict_kanji('晴れ')).
pick(w_kumori,     ja, n5, word, jmdict_kanji('曇り')).
pick(w_atatakai,   ja, n5, word, jmdict_kanji('暖かい')).
pick(w_suzushii,   ja, n5, word, jmdict_kanji('涼しい')).
pick(w_kisetsu,    ja, n5, word, jmdict_kanji('季節')).
pick(w_haru,       ja, n5, word, jmdict_kanji('春')).
pick(w_natsu,      ja, n5, word, jmdict('1191320')). % 夏 なつ
pick(w_aki,        ja, n5, word, jmdict('1332650')). % 秋 あき
pick(w_fuyu,       ja, n5, word, jmdict_kanji('冬')).

% --- Places, continued ----------------------------------------------------
pick(w_tokoro,     ja, n5, word, jmdict('1343100')). % 所/処/處 ところ
pick(w_basho,      ja, n5, word, jmdict_kanji('場所')).
pick(w_niwa,       ja, n5, word, jmdict_kanji('庭')).
pick(w_mon,        ja, n5, word, jmdict('1584800')). % 門 もん
pick(w_kabe,       ja, n5, word, jmdict_kanji('壁')).
pick(w_yuka,       ja, n5, word, jmdict('1349380')). % 床/牀 ゆか
pick(w_furo,       ja, n5, word, jmdict_kanji('風呂')).
pick(w_otearai,    ja, n5, word, jmdict_kanji('お手洗い')).
pick(w_toire,      ja, n5, word, jmdict_kana('トイレ')).
pick(w_ima_room,   ja, n5, word, jmdict_kanji('居間')).
pick(w_tatemono,   ja, n5, word, jmdict_kanji('建物')).
pick(w_biru,       ja, n5, word, jmdict('1106010')). % ビル -- building
pick(w_apaato,     ja, n5, word, jmdict_kana('アパート')).
pick(w_manshon,    ja, n5, word, jmdict_kana('マンション')).
pick(w_hoteru,     ja, n5, word, jmdict_kana('ホテル')).
pick(w_ryokan,     ja, n5, word, jmdict_kanji('旅館')).
pick(w_resutoran,  ja, n5, word, jmdict_kana('レストラン')).
pick(w_kissaten,   ja, n5, word, jmdict_kanji('喫茶店')).
pick(w_shokudou,   ja, n5, word, jmdict('1358550')). % 食堂 しょくどう
pick(w_ichiba,     ja, n5, word, jmdict('1308300')). % 市場/市庭 いちば
pick(w_depaato,    ja, n5, word, jmdict_kana('デパート')).
pick(w_suupaa,     ja, n5, word, jmdict_kana('スーパー')).
pick(w_konbini,    ja, n5, word, jmdict_kana('コンビニ')).
pick(w_honya,      ja, n5, word, jmdict('1522240')). % 本屋 ほんや
pick(w_yaoya,      ja, n5, word, jmdict_kanji('八百屋')).
pick(w_nikuya,     ja, n5, word, jmdict_kanji('肉屋')).
pick(w_panya,      ja, n5, word, jmdict_kanji('パン屋')).
pick(w_hanaya,     ja, n5, word, jmdict_kanji('花屋')).
pick(w_kyoushitsu, ja, n5, word, jmdict_kanji('教室')).
pick(w_jimusho,    ja, n5, word, jmdict_kanji('事務所')).
pick(w_koujou,     ja, n5, word, jmdict_kanji('工場')).
pick(w_kuukou,     ja, n5, word, jmdict_kanji('空港')).
pick(w_minato,     ja, n5, word, jmdict('1279990')). % 港/湊 みなと
pick(w_kouen,      ja, n5, word, jmdict_kanji('公園')).
pick(w_doubutsuen, ja, n5, word, jmdict_kanji('動物園')).
pick(w_eigakan,    ja, n5, word, jmdict_kanji('映画館')).
pick(w_bijutsukan, ja, n5, word, jmdict_kanji('美術館')).
pick(w_hakubutsukan, ja, n5, word, jmdict_kanji('博物館')).
pick(w_jinja,      ja, n5, word, jmdict_kanji('神社')).
pick(w_otera,      ja, n5, word, jmdict_kanji('お寺')).
pick(w_kyoukai,    ja, n5, word, jmdict_kanji('教会')).
pick(w_kousaten,   ja, n5, word, jmdict_kanji('交差点')).
pick(w_hashi_bridge, ja, n5, word, jmdict('1237410')). % 橋 はし
pick(w_kado,       ja, n5, word, jmdict('1206110')). % 角 かど
pick(w_shingou,    ja, n5, word, jmdict_kanji('信号')).
pick(w_toori,      ja, n5, word, jmdict('1432920')). % 通り とおり
pick(w_shi_city,   ja, n5, word, jmdict('1308090')). % 市 し
pick(w_ken,        ja, n5, word, jmdict('1258810')). % 県/縣 けん
pick(w_gaikoku,    ja, n5, word, jmdict_kanji('外国')).
pick(w_inaka,      ja, n5, word, jmdict('1442750')). % 田舎/田舍 いなか
pick(w_sekai,      ja, n5, word, jmdict_kanji('世界')).

% --- Where a thing is -----------------------------------------------------
pick(w_ue,         ja, n5, word, jmdict('1352130')). % 上 うえ
pick(w_shita,      ja, n5, word, jmdict('1184140')). % 下 した
pick(w_ushiro,     ja, n5, word, jmdict_kanji('後ろ')).
pick(w_migi,       ja, n5, word, jmdict_kanji('右')).
pick(w_hidari,     ja, n5, word, jmdict('1290800')). % 左 ひだり
pick(w_soto,       ja, n5, word, jmdict('1203250')). % 外 そと
pick(w_yoko,       ja, n5, word, jmdict_kanji('横')).
pick(w_chikaku,    ja, n5, word, jmdict_kanji('近く')).
pick(w_mukou,      ja, n5, word, jmdict_kanji('向こう')).
pick(w_higashi,    ja, n5, word, jmdict('1447440')). % 東 ひがし
pick(w_nishi,      ja, n5, word, jmdict('1380840')). % 西 にし
pick(w_minami,     ja, n5, word, jmdict('1459870')). % 南 みなみ
pick(w_kita,       ja, n5, word, jmdict('1520670')). % 北 きた
pick(w_tooi,       ja, n5, word, jmdict_kanji('遠い')).
pick(w_chikai,     ja, n5, word, jmdict_kanji('近い')).

% --- Getting about, continued ---------------------------------------------
pick(w_chikatetsu, ja, n5, word, jmdict_kanji('地下鉄')).
pick(w_basu,       ja, n5, word, jmdict('1098390')). % バス -- bus
pick(w_takushii,   ja, n5, word, jmdict_kana('タクシー')).
pick(w_fune,       ja, n5, word, jmdict('1602800')). % 船/舟/槽 ふね
pick(w_shinkansen, ja, n5, word, jmdict_kanji('新幹線')).
pick(w_nimotsu,    ja, n5, word, jmdict_kanji('荷物')).
pick(w_unten,      ja, n5, word, jmdict_kanji('運転')).
pick(w_sanpo,      ja, n5, word, jmdict_kanji('散歩')).
pick(w_yoyaku,     ja, n5, word, jmdict_kanji('予約')).
pick(w_annai,      ja, n5, word, jmdict_kanji('案内')).
pick(w_shuppatsu,  ja, n5, word, jmdict_kanji('出発')).

% --- Things, continued ----------------------------------------------------
pick(w_mono,       ja, n5, word, jmdict('1502390')). % 物 もの
pick(w_tana,       ja, n5, word, jmdict_kanji('棚')).
pick(w_doa,        ja, n5, word, jmdict_kana('ドア')).
pick(w_denki,      ja, n5, word, jmdict_kanji('電気')).
pick(w_terebi,     ja, n5, word, jmdict_kana('テレビ')).
pick(w_rajio,      ja, n5, word, jmdict_kana('ラジオ')).
pick(w_sentakuki,  ja, n5, word, jmdict_kanji('洗濯機')).
pick(w_erebeetaa,  ja, n5, word, jmdict_kana('エレベーター')).
pick(w_kamera,     ja, n5, word, jmdict_kana('カメラ')).
pick(w_pasokon,    ja, n5, word, jmdict_kana('パソコン')).
pick(w_keitai,     ja, n5, word, jmdict_kanji('携帯')).
pick(w_meeru,      ja, n5, word, jmdict('1132620')). % メール -- email
pick(w_hagaki,     ja, n5, word, jmdict_kanji('葉書')).
pick(w_fuutou,     ja, n5, word, jmdict_kanji('封筒')).
pick(w_kyoukasho,  ja, n5, word, jmdict_kanji('教科書')).
pick(w_nooto,      ja, n5, word, jmdict_kana('ノート')).
pick(w_pen,        ja, n5, word, jmdict('1121380')). % ペン ペン
pick(w_boorupen,   ja, n5, word, jmdict_kana('ボールペン')).
pick(w_keshigomu,  ja, n5, word, jmdict_kanji('消しゴム')).
pick(w_hako,       ja, n5, word, jmdict_kanji('箱')).
pick(w_fukuro,     ja, n5, word, jmdict('1411070')). % 袋/嚢 ふくろ
pick(w_bin,        ja, n5, word, jmdict('1491120')). % 瓶/壜/罎 びん
pick(w_okane,      ja, n5, word, jmdict_kanji('お金')).
pick(w_nedan,      ja, n5, word, jmdict_kanji('値段')).
pick(w_kikai,      ja, n5, word, jmdict_kanji('機械')).
pick(w_sekken,     ja, n5, word, jmdict_kanji('石鹸')).
pick(w_taoru,      ja, n5, word, jmdict_kana('タオル')).
pick(w_hankachi,   ja, n5, word, jmdict_kana('ハンカチ')).
pick(w_futon,      ja, n5, word, jmdict_kanji('布団')).
pick(w_beddo,      ja, n5, word, jmdict_kana('ベッド')).
pick(w_kagami,     ja, n5, word, jmdict('1238550')). % 鏡 かがみ
pick(w_e_picture,  ja, n5, word, jmdict_kanji('絵')).
pick(w_oto,        ja, n5, word, jmdict('1576900')). % 音 おと
pick(w_uta,        ja, n5, word, jmdict_kanji('歌')).
pick(w_kusa,       ja, n5, word, jmdict('1401910')). % 草/艸 くさ

% --- Doing, continued -----------------------------------------------------
pick(w_akeru,      ja, n5, word, jmdict('1202450')). % 開ける/空ける/明ける あける
pick(w_shimeru,    ja, n5, word, jmdict_kanji('閉める')).
pick(w_ageru,      ja, n5, word, jmdict_kanji('上げる')).
pick(w_kasu,       ja, n5, word, jmdict_kanji('貸す')).
pick(w_kariru,     ja, n5, word, jmdict_kanji('借りる')).
pick(w_kaesu,      ja, n5, word, jmdict_kanji('返す')).
pick(w_harau,      ja, n5, word, jmdict_kanji('払う')).
pick(w_okuru,      ja, n5, word, jmdict_kanji('送る')).
pick(w_oku,        ja, n5, word, jmdict_kanji('置く')).
pick(w_toru,       ja, n5, word, jmdict_kanji('取る')).
pick(w_watasu,     ja, n5, word, jmdict_kanji('渡す')).
pick(w_wataru,     ja, n5, word, jmdict_kanji('渡る')).
pick(w_magaru,     ja, n5, word, jmdict_kanji('曲がる')).
pick(w_tomaru,     ja, n5, word, jmdict('1310620')). % 止まる/留まる/停まる/駐まる/止る/留る とまる
pick(w_tomeru,     ja, n5, word, jmdict('1310670')). % 止める/留める/停める とめる
pick(w_ugoku,      ja, n5, word, jmdict_kanji('動く')).
pick(w_oyogu,      ja, n5, word, jmdict_kanji('泳ぐ')).
pick(w_tobu,       ja, n5, word, jmdict_kanji('飛ぶ')).
pick(w_noboru,     ja, n5, word, jmdict_kanji('登る')).
pick(w_furu,       ja, n5, word, jmdict('1282790')). % 降る ふる
pick(w_ochiru,     ja, n5, word, jmdict_kanji('落ちる')).
pick(w_tatsu,      ja, n5, word, jmdict_kanji('立つ')).
pick(w_suwaru,     ja, n5, word, jmdict_kanji('座る')).
pick(w_abiru,      ja, n5, word, jmdict_kanji('浴びる')).
pick(w_arau,       ja, n5, word, jmdict_kanji('洗う')).
pick(w_migaku,     ja, n5, word, jmdict_kanji('磨く')).
pick(w_souji,      ja, n5, word, jmdict_kanji('掃除')).
pick(w_sentaku,    ja, n5, word, jmdict_kanji('洗濯')).
pick(w_naosu,      ja, n5, word, jmdict_kanji('直す')).
pick(w_kowareru,   ja, n5, word, jmdict_kanji('壊れる')).
pick(w_kesu,       ja, n5, word, jmdict_kanji('消す')).
pick(w_tsukeru,    ja, n5, word, jmdict_kanji('付ける')).
pick(w_kiru_wear,  ja, n5, word, jmdict_kanji('着る')).
pick(w_nugu,       ja, n5, word, jmdict_kanji('脱ぐ')).
pick(w_haku,       ja, n5, word, jmdict_kanji('履く')).
pick(w_hakobu,     ja, n5, word, jmdict_kanji('運ぶ')).
pick(w_ireru,      ja, n5, word, jmdict_kanji('入れる')).
pick(w_dasu,       ja, n5, word, jmdict_kanji('出す')).
pick(w_hajimeru,   ja, n5, word, jmdict_kanji('始める')).
pick(w_sagasu,     ja, n5, word, jmdict_kanji('探す')).
pick(w_mitsukeru,  ja, n5, word, jmdict_kanji('見つける')).
pick(w_miseru,     ja, n5, word, jmdict_kanji('見せる')).
pick(w_narau,      ja, n5, word, jmdict_kanji('習う')).
pick(w_kangaeru,   ja, n5, word, jmdict_kanji('考える')).
pick(w_omou,       ja, n5, word, jmdict_kanji('思う')).
pick(w_komaru,     ja, n5, word, jmdict_kanji('困る')).
pick(w_shinpai,    ja, n5, word, jmdict_kanji('心配')).
pick(w_warau,      ja, n5, word, jmdict_kanji('笑う')).
pick(w_naku,       ja, n5, word, jmdict_kanji('泣く')).
pick(w_okoru,      ja, n5, word, jmdict('1445690')). % 怒る おこる
pick(w_tsukareru,  ja, n5, word, jmdict_kanji('疲れる')).
pick(w_asobu,      ja, n5, word, jmdict('1542160')). % 遊ぶ あそぶ
pick(w_utau,       ja, n5, word, jmdict_kanji('歌う')).
pick(w_odoru,      ja, n5, word, jmdict_kanji('踊る')).
pick(w_osu,        ja, n5, word, jmdict_kanji('押す')).
pick(w_hiku,       ja, n5, word, jmdict_kanji('引く')).
pick(w_kiru_cut,   ja, n5, word, jmdict_kanji('切る')).
pick(w_narabu,     ja, n5, word, jmdict_kanji('並ぶ')).
pick(w_erabu,      ja, n5, word, jmdict_kanji('選ぶ')).
pick(w_kimeru,     ja, n5, word, jmdict_kanji('決める')).
pick(w_iru_need,   ja, n5, word, jmdict_kanji('要る')).
pick(w_aru,        ja, n5, word, jmdict_kanji('有る')).
pick(w_naru,       ja, n5, word, jmdict_kanji('成る')).
pick(w_umareru,    ja, n5, word, jmdict_kanji('生まれる')).
pick(w_tsuku,      ja, n5, word, jmdict('1422970')). % 着く つく
pick(w_yobu,       ja, n5, word, jmdict_kanji('呼ぶ')).
pick(w_kotaeru,    ja, n5, word, jmdict_kanji('答える')).
pick(w_henji,      ja, n5, word, jmdict_kanji('返事')).
pick(w_tetsudau,   ja, n5, word, jmdict_kanji('手伝う')).
pick(w_tasukeru,   ja, n5, word, jmdict_kanji('助ける')).
pick(w_tanomu,     ja, n5, word, jmdict_kanji('頼む')).
pick(w_kikoeru,    ja, n5, word, jmdict_kanji('聞こえる')).
pick(w_mieru,      ja, n5, word, jmdict('1259140')). % 見える/視える みえる
pick(w_chigau,     ja, n5, word, jmdict('1158880')). % 違う ちがう
pick(w_benkyou,    ja, n5, word, jmdict_kanji('勉強')).
pick(w_setsumei,   ja, n5, word, jmdict_kanji('説明')).
pick(w_junbi,      ja, n5, word, jmdict_kanji('準備')).
pick(w_chuui,      ja, n5, word, jmdict_kanji('注意')).
pick(w_hantai,     ja, n5, word, jmdict_kanji('反対')).

% --- Describing, continued ------------------------------------------------
pick(w_hikui,      ja, n5, word, jmdict_kanji('低い')).
pick(w_futoi,      ja, n5, word, jmdict_kanji('太い')).
pick(w_hosoi,      ja, n5, word, jmdict('1295510')). % 細い ほそい
pick(w_atsui_thick,ja, n5, word, jmdict_kanji('厚い')).
pick(w_usui,       ja, n5, word, jmdict_kanji('薄い')).
pick(w_isogashii,  ja, n5, word, jmdict('1519290')). % 忙しい/忙がしい いそがしい
pick(w_hima,       ja, n5, word, jmdict('1577280')). % 暇/閑 ひま
pick(w_tanoshii,   ja, n5, word, jmdict_kanji('楽しい')).
pick(w_omoshiroi,  ja, n5, word, jmdict_kanji('面白い')).
pick(w_tsumaranai, ja, n5, word, jmdict_kana('つまらない')).
pick(w_ureshii,    ja, n5, word, jmdict_kanji('嬉しい')).
pick(w_kanashii,   ja, n5, word, jmdict_kanji('悲しい')).
pick(w_sabishii,   ja, n5, word, jmdict_kanji('寂しい')).
pick(w_kowai,      ja, n5, word, jmdict_kanji('怖い')).
pick(w_kitanai,    ja, n5, word, jmdict_kanji('汚い')).
pick(w_fuben,      ja, n5, word, jmdict('1494860')). % 不便 ふべん
pick(w_yasashii_easy, ja, n5, word, jmdict_kanji('易しい')).
pick(w_yasashii_kind, ja, n5, word, jmdict_kanji('優しい')).
pick(w_shinsetsu,  ja, n5, word, jmdict_kanji('親切')).
pick(w_taisetsu,   ja, n5, word, jmdict('1414340')). % 大切 たいせつ
pick(w_daiji,      ja, n5, word, jmdict('1413940')). % 大事 だいじ
pick(w_taihen,     ja, n5, word, jmdict_kanji('大変')).
pick(w_abunai,     ja, n5, word, jmdict_kanji('危ない')).
pick(w_anzen,      ja, n5, word, jmdict_kanji('安全')).
pick(w_jouzu,      ja, n5, word, jmdict('1353320')). % 上手 じょうず
pick(w_heta,       ja, n5, word, jmdict('1185200')). % 下手 へた
pick(w_suki,       ja, n5, word, jmdict('1277450')). % 好き すき
pick(w_kirai,      ja, n5, word, jmdict('1257240')). % 嫌い きらい
pick(w_hoshii,     ja, n5, word, jmdict_kanji('欲しい')).
pick(w_onaji,      ja, n5, word, jmdict_kanji('同じ')).
pick(w_iroiro,     ja, n5, word, jmdict_kanji('色々')).
pick(w_uso,        ja, n5, word, jmdict_kanji('嘘')).
pick(w_hen,        ja, n5, word, jmdict_kanji('変')).
pick(w_futsuu,     ja, n5, word, jmdict_kanji('普通')).
pick(w_tokubetsu,  ja, n5, word, jmdict_kanji('特別')).
pick(w_juubun,     ja, n5, word, jmdict('1335080')). % 十分/充分 じゅうぶん
pick(w_marui,      ja, n5, word, jmdict_kanji('丸い')).
pick(w_massugu,    ja, n5, word, jmdict_kanji('真っ直ぐ')).
pick(w_nemui,      ja, n5, word, jmdict_kanji('眠い')).

% --- How, and how often ---------------------------------------------------
pick(w_totemo,     ja, n5, word, jmdict_kana('とても')).
pick(w_yoku,       ja, n5, word, jmdict('1605870')). % 良く -- well
pick(w_amari,      ja, n5, word, jmdict_kanji('余り')).
pick(w_zenzen,     ja, n5, word, jmdict_kanji('全然')).
pick(w_tokidoki,   ja, n5, word, jmdict_kanji('時々')).
pick(w_itsumo,     ja, n5, word, jmdict_kanji('何時も')).
pick(w_mata,       ja, n5, word, jmdict_kanji('又')).
pick(w_mada,       ja, n5, word, jmdict_kanji('未だ')).
pick(w_mou,        ja, n5, word, jmdict('1012480')). % もう もう
pick(w_sugu,       ja, n5, word, jmdict_kanji('直ぐ')).
pick(w_daitai,     ja, n5, word, jmdict_kanji('大体')).
pick(w_tabun,      ja, n5, word, jmdict_kanji('多分')).
pick(w_kanarazu,   ja, n5, word, jmdict_kanji('必ず')).
pick(w_hajimete,   ja, n5, word, jmdict_kanji('初めて')).

% --- Asking ---------------------------------------------------------------
pick(w_dare,       ja, n5, word, jmdict_kanji('誰')).
pick(w_itsu,       ja, n5, word, jmdict('1188760')). % 何時 いつ
pick(w_doko,       ja, n5, word, jmdict_kanji('何処')).
pick(w_naze,       ja, n5, word, jmdict('1577120')). % 何故 なぜ
pick(w_dou,        ja, n5, word, jmdict('2255350')). % どう どう
pick(w_dore,       ja, n5, word, jmdict_kana('どれ')).
pick(w_dochira,    ja, n5, word, jmdict_kana('どちら')).

% --- Saying things to people ----------------------------------------------
pick(w_sumimasen,  ja, n5, word, jmdict_kanji('済みません')).
pick(w_onegai,     ja, n5, word, jmdict_kanji('お願い')).
pick(w_gomen,      ja, n5, word, jmdict_kanji('御免')).
pick(w_sayounara,  ja, n5, word, jmdict_kana('さようなら')).
pick(w_konnichiwa, ja, n5, word, jmdict_kana('こんにちは')).
pick(w_ohayou,     ja, n5, word, jmdict_kanji('お早う')).
pick(w_konbanwa,   ja, n5, word, jmdict_kana('こんばんは')).
pick(w_douzo,      ja, n5, word, jmdict_kana('どうぞ')).
pick(w_doumo,      ja, n5, word, jmdict_kana('どうも')).
pick(w_moshimoshi, ja, n5, word, jmdict_kana('もしもし')).
pick(w_itadakimasu,ja, n5, word, jmdict_kana('いただきます')).
pick(w_gochisousama, ja, n5, word, jmdict_kanji('御馳走様')).
pick(w_hai,        ja, n5, word, jmdict('1010080')). % はい はい
pick(w_iie,        ja, n5, word, jmdict_kana('いいえ')).

% --- School, and talking about language -----------------------------------
% 平仮名 and 片仮名 are words here as well as scripts.  The SKILLS that roll
% up over the syllabaries are hiragana_all and katakana_all in
% graph/ja/kana.pl; these are the nouns a student reads on a worksheet.
pick(w_jugyou,     ja, n5, word, jmdict_kanji('授業')).
pick(w_natsuyasumi,ja, n5, word, jmdict_kanji('夏休み')).
pick(w_kotoba,     ja, n5, word, jmdict_kanji('言葉')).
pick(w_ji,         ja, n5, word, jmdict('1315130')). % 字 じ
pick(w_kanji,      ja, n5, word, jmdict_kanji('漢字')).
pick(w_hiragana,   ja, n5, word, jmdict_kanji('平仮名')).
pick(w_katakana,   ja, n5, word, jmdict_kanji('片仮名')).
pick(w_eigo,       ja, n5, word, jmdict_kanji('英語')).
pick(w_nihongo,    ja, n5, word, jmdict_kanji('日本語')).
pick(w_hatsuon,    ja, n5, word, jmdict_kanji('発音')).
pick(w_bun,        ja, n5, word, jmdict('1505090')). % 文 ぶん
pick(w_bunpou,     ja, n5, word, jmdict_kanji('文法')).
pick(w_tango,      ja, n5, word, jmdict_kanji('単語')).
pick(w_kotae,      ja, n5, word, jmdict('1449530')). % 答え/答/応え/報え こたえ
pick(w_kokuban,    ja, n5, word, jmdict_kanji('黒板')).
pick(w_ten,        ja, n5, word, jmdict('1441390')). % 点 てん
pick(w_sotsugyou,  ja, n5, word, jmdict_kanji('卒業')).
pick(w_nyuugaku,   ja, n5, word, jmdict_kanji('入学')).
pick(w_sakubun,    ja, n5, word, jmdict('1297960')). % 作文 さくぶん
pick(w_ryuugaku,   ja, n5, word, jmdict_kanji('留学')).

% --- Sport, and what people do for pleasure -------------------------------
pick(w_undou,      ja, n5, word, jmdict_kanji('運動')).
pick(w_shiai,      ja, n5, word, jmdict_kanji('試合')).
pick(w_yakyuu,     ja, n5, word, jmdict_kanji('野球')).
pick(w_sakkaa,     ja, n5, word, jmdict('1056700')). % サッカー soccer
pick(w_tenisu,     ja, n5, word, jmdict_kana('テニス')).
pick(w_suiei,      ja, n5, word, jmdict_kanji('水泳')).
pick(w_supootsu,   ja, n5, word, jmdict_kana('スポーツ')).
pick(w_shumi,      ja, n5, word, jmdict_kanji('趣味')).
pick(w_gitaa,      ja, n5, word, jmdict_kana('ギター')).
pick(w_piano,      ja, n5, word, jmdict_kana('ピアノ')).
pick(w_manga,      ja, n5, word, jmdict_kanji('漫画')).
pick(w_geemu,      ja, n5, word, jmdict_kana('ゲーム')).
pick(w_shousetsu,  ja, n5, word, jmdict_kanji('小説')).

% --- Arrangements ---------------------------------------------------------
pick(w_kaigi,      ja, n5, word, jmdict_kanji('会議')).
pick(w_youji,      ja, n5, word, jmdict_kanji('用事')).
pick(w_kaimono,    ja, n5, word, jmdict_kanji('買い物')).
pick(w_chuumon,    ja, n5, word, jmdict('1426650')). % 注文/註文 ちゅうもん
pick(w_seki,       ja, n5, word, jmdict('1382250')). % 席 せき
pick(w_yotei,      ja, n5, word, jmdict_kanji('予定')).
pick(w_kekkon,     ja, n5, word, jmdict_kanji('結婚')).
pick(w_aisatsu,    ja, n5, word, jmdict_kanji('挨拶')).
pick(w_matsuri,    ja, n5, word, jmdict_kanji('祭り')).
pick(w_shougatsu,  ja, n5, word, jmdict_kanji('正月')).

% --- Out of doors ---------------------------------------------------------
pick(w_mori,       ja, n5, word, jmdict_kanji('森')).
pick(w_ike,        ja, n5, word, jmdict_kanji('池')).
pick(w_mizuumi,    ja, n5, word, jmdict('1267280')). % 湖 みずうみ
pick(w_shima,      ja, n5, word, jmdict('1446760')). % 島/嶋 しま
pick(w_suna,       ja, n5, word, jmdict_kanji('砂')).
pick(w_tsuchi,     ja, n5, word, jmdict('1445270')). % 土/地 つち
pick(w_kuuki,      ja, n5, word, jmdict_kanji('空気')).
pick(w_hi_fire,    ja, n5, word, jmdict('1193610')). % 火 ひ
pick(w_hikari,     ja, n5, word, jmdict_kanji('光')).
pick(w_hanabi,     ja, n5, word, jmdict_kanji('花火')).
pick(w_ha_leaf,    ja, n5, word, jmdict('1546550')). % 葉 は

% --- Things that are not things -------------------------------------------
pick(w_riyuu,      ja, n5, word, jmdict_kanji('理由')).
pick(w_hanashi,    ja, n5, word, jmdict('1600900')). % 話/話し/咄/噺 はなし
pick(w_yume,       ja, n5, word, jmdict_kanji('夢')).
pick(w_kimochi,    ja, n5, word, jmdict_kanji('気持ち')).
pick(w_iken,       ja, n5, word, jmdict_kanji('意見')).
pick(w_kyoumi,     ja, n5, word, jmdict_kanji('興味')).
pick(w_ichiban,    ja, n5, word, jmdict('1165970')). % 一番/１番 いちばん
pick(w_hoka,       ja, n5, word, jmdict('1203260')). % 他/外 ほか
pick(w_kata_person,ja, n5, word, jmdict('1516925')). % 方 かた
pick(w_ryouhou,    ja, n5, word, jmdict_kanji('両方')).
pick(w_jidousha,   ja, n5, word, jmdict_kanji('自動車')).

% --- Doing, the last of it ------------------------------------------------
pick(w_okureru,    ja, n5, word, jmdict_kanji('遅れる')).
pick(w_isogu,      ja, n5, word, jmdict_kanji('急ぐ')).
pick(w_ikiru,      ja, n5, word, jmdict_kanji('生きる')).
pick(w_saku,       ja, n5, word, jmdict_kanji('咲く')).
pick(w_fuku_blow,  ja, n5, word, jmdict_kanji('吹く')).
pick(w_naru_sound, ja, n5, word, jmdict_kanji('鳴る')).
pick(w_futoru,     ja, n5, word, jmdict_kanji('太る')).
pick(w_yaseru,     ja, n5, word, jmdict_kanji('痩せる')).
pick(w_morau,      ja, n5, word, jmdict_kanji('貰う')).
pick(w_kureru,     ja, n5, word, jmdict_kanji('呉れる')).
pick(w_tsuzuku,    ja, n5, word, jmdict_kanji('続く')).
pick(w_yamu,       ja, n5, word, jmdict_kanji('止む')).
pick(w_omoidasu,   ja, n5, word, jmdict_kanji('思い出す')).
pick(w_machigaeru, ja, n5, word, jmdict_kanji('間違える')).
pick(w_tateru,     ja, n5, word, jmdict_kanji('建てる')).
pick(w_hiraku,     ja, n5, word, jmdict('1202440')). % 開く ひらく

% --- Around a building, and around a subject ------------------------------
% These twenty-three were added last, after --audit showed the criterion
% measured over what can be ASKED rather than over what the graph holds:
% a word written only in kana has no reading question at N5 (see the note
% at the foot of this file), so a list that is long enough on paper can
% still be short in the lesson.
pick(w_kaiwa,      ja, n5, word, jmdict_kanji('会話')).
pick(w_seito,      ja, n5, word, jmdict_kanji('生徒')).
pick(w_taishikan,  ja, n5, word, jmdict_kanji('大使館')).
pick(w_kouban,     ja, n5, word, jmdict_kanji('交番')).
pick(w_kai_floor,  ja, n5, word, jmdict('1203020')). % 階 かい
pick(w_okujou,     ja, n5, word, jmdict_kanji('屋上')).
pick(w_chika,      ja, n5, word, jmdict('1420840')). % 地下 ちか
pick(w_uketsuke,   ja, n5, word, jmdict_kanji('受付')).
pick(w_iriguchi,   ja, n5, word, jmdict_kanji('入口')).
pick(w_deguchi,    ja, n5, word, jmdict_kanji('出口')).
pick(w_bangumi,    ja, n5, word, jmdict_kanji('番組')).
pick(w_bunka,      ja, n5, word, jmdict_kanji('文化')).
pick(w_rekishi,    ja, n5, word, jmdict_kanji('歴史')).
pick(w_kagaku,     ja, n5, word, jmdict_kanji('科学')).
pick(w_suugaku,    ja, n5, word, jmdict_kanji('数学')).
pick(w_kenkyuu,    ja, n5, word, jmdict_kanji('研究')).
pick(w_juusho,     ja, n5, word, jmdict_kanji('住所')).
pick(w_baai,       ja, n5, word, jmdict('1355810')). % 場合 ばあい
pick(w_keiken,     ja, n5, word, jmdict_kanji('経験')).
pick(w_fukushuu,   ja, n5, word, jmdict_kanji('復習')).
pick(w_kozutsumi,  ja, n5, word, jmdict_kanji('小包')).
pick(w_yuubin,     ja, n5, word, jmdict_kanji('郵便')).
pick(w_onsen,      ja, n5, word, jmdict_kanji('温泉')).

% --- The order inside the tranche -----------------------------------------
% The same judgment the first tranche's pairs record: the second word of
% each is introduced AS the other side of the first, and a student who
% meets it cold is being asked to hold a distinction they have one half of.
pick_requires(w_shimeru,   w_akeru).
pick_requires(w_hikui,     w_takai).
pick_requires(w_hosoi,     w_futoi).
pick_requires(w_usui,      w_atsui_thick).
pick_requires(w_sukunai,   w_ooi).
pick_requires(w_heta,      w_jouzu).
pick_requires(w_kirai,     w_suki).
pick_requires(w_fuben,     w_benri).
pick_requires(w_deguchi,   w_iriguchi).
pick_requires(w_yaseru,    w_futoru).
pick_requires(w_nugu,      w_kiru_wear).
pick_requires(w_kaesu,     w_kariru).
pick_requires(w_sotsugyou, w_nyuugaku).

% --- A WORD WRITTEN ONLY IN KANA, and why it cannot be asked --------------
% Nineteen of the words above have no reading question, and --audit counts
% them in `have` and not in `askable`:
%
%   はい  いいえ  こんにちは  こんばんは  さようなら  もしもし  どうぞ
%   どうも  いただきます  とても  もう  いつ  くれる  つまらない  ...
%
% A reading question works by holding one form up and asking for another,
% so it needs two: 山 prompts and やま answers.  These words have one.
% The katakana loanwords are in the same position and ARE asked anyway,
% because reading コーヒー as koohii is a real exercise that a learner gets
% wrong -- see lp_question's loanword branch.  Doing the same for とても
% would be different in kind: by N5 the student has hiragana, so prompting
% とても and accepting `totemo` is a free mark, and a criterion padded with
% free marks measures less than it did before.
%
% So they stay here, unasked.  They are words a student must have -- a
% vocabulary list for a beginner without はい and すみません would be a
% worse list -- and what this build cannot do is ask about them by typing.
% That is the same shape of gap as the four sound contrasts with no pair in
% graph/en/items.pl, and it is reported the same way rather than papered
% over: the honest probe for one of these is a question about MEANING, and
% a meaning question needs a distractor the graph does not yet choose.
