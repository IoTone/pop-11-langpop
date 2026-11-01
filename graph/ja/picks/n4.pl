% graph/ja/picks/n4.pl -- which words are N4, and who they are.
%
% The same arrangement as graph/ja/picks/n5.pl, and that file's header is
% the one to read first: a pick is an identity, a level and a lookup key,
% import.p fetches the forms and the glosses from JMdict at build time,
% and no Japanese that upstream wrote is committed here.
%
% WHAT IS A JUDGMENT AND WHAT IS COUNTED.  The two halves of this rung
% came from opposite places, and the difference is worth being exact
% about:
%
%   the kanji needed NO curation.  KANJIDIC2's <jlpt> field holds the
%   pre-2010 four-level syllabus, old level 3 is the one that became N4,
%   and counting it gives 181 characters -- which with N5's 103 is
%   exactly the 284 that graph/ja/ladder.pl already asks for.  One
%   import command, and the criterion was met.
%
%   the words are an ESTIMATE, because JLPT has published no word list
%   since 2010 and JMdict carries no level marking.  So "which 1500
%   words are N4" is a teaching claim a human has to make, and
%   provenance(exit(ja, _, vocabulary(_, _), _, _), estimate(community))
%   in the ladder says so.
%
% THE COUNT.  749 picks here, and the criterion is cumulative: with
% n5.pl's 773 and the fifty at pre-school that is 1572 words at N4
% against exit(ja, n4, vocabulary(1500, read)).  The margin is not
% padding -- it is there because a pick can fail to be ASKABLE (a word
% with no kanji form asks no reading question), and the audit counts
% questions rather than rows.
%
% HOW THEY ARE KEYED.  629 by kanji headword, 54 by kana reading -- the
% loanwords and the words a learner only ever sees in kana -- and 66 by
% sequence number, which is the escape hatch for a key that names more
% than one entry.  The importer REFUSES an ambiguous key and prints the
% candidates with their glosses; 詩 is a headword of both うた and the
% poem, 虹 of both the rainbow and 二次 ('second'), and a key that names
% two entries names neither.
%
% WHAT WAS VALIDATED BEFORE ANY OF THIS WAS WRITTEN.  Every row below was
% checked against JMdict as data first: that the key resolves to exactly
% one entry, that the entry's reading is the romaji the id claims, and
% that neither the id nor any form of the word is already in the graph.
% That last one did most of the work -- 276 drafted picks turned out to
% be words the graph already teaches, and 49 more were a second spelling
% of one.  Minting a fresh identity for a word a student has beliefs
% about would split those beliefs in half and nothing downstream could
% tell, which is why import.p refuses it too.
%
% The reading check earned its place as well: it caught 90 ids whose
% romaji was not the word's reading, most of them mine -- 住宅 is
% juutaku and not jutaku, 掃除機 is soujiki, 底面 is teimen and not
% sokomen -- and an id that misreads its own word is a lie a journal
% repeats forever.
%
% NO `_suru` IN AN ID.  An early draft wrote 連絡 as w_renraku_suru,
% and that is a claim about grammar rather than an identity: 連絡 is a
% noun whichever way it is used, and する belongs to the pattern layer
% that is not built yet.  Stripping the suffix also exposed the reason
% it was there -- several of those nouns were already picked at N5, and
% the suffix had been hiding the collision.
%
% HOMOPHONES.  n5.pl's convention continues: a short English sense tag
% after the romaji when the romaji is taken.  Two arrived here --
% w_dentou_lamp, because w_dentou is 伝統, and w_hirou_fatigue, because
% w_hirou is 拾う.
%
% TWELVE WORDS HAVE NO KANJI.  JMdict tags a kanji headword it does not
% recommend, and when every spelling of a word is tagged the importer
% emits no kanji form at all -- 頑張る, 素晴らしい, 仕舞う and nine more
% are marked below.  That is the right answer and not a gap: those words
% are written in kana, and the kana is the whole of their orthography.
%
% WHAT IS NOT HERE.  No grammar: the ～たら and ～ば conditionals, the
% passive, the causative and keigo are all N4 and all of them are
% PATTERNS, which this graph can hold (item/5 takes a pattern kind) and
% has only three of.  No counters.  No register: 言う beside おっしゃる
% is a politeness axis and docs/langpop-function-words.md's argument
% applies to it -- it wants a pattern over an item, not another word.
% And the listening half of the rung is not curation at all: the words
% are here, and `--audio n4` is what makes them hearable.

% --- Doing, and the pairs that differ by one kana ------------------------------
pick(w_sageru,             ja, n4, word, jmdict_kanji('下げる')).
pick(w_shimaru,            ja, n4, word, jmdict_kanji('閉まる')).
pick(w_atsumaru,           ja, n4, word, jmdict_kanji('集まる')).
pick(w_atsumeru,           ja, n4, word, jmdict_kanji('集める')).
pick(w_kazoeru,            ja, n4, word, jmdict_kanji('数える')).
pick(w_kawaru,             ja, n4, word, jmdict_kanji('変わる')).
pick(w_naoru,              ja, n4, word, jmdict_kanji('直る')).
pick(w_tsutaeru,           ja, n4, word, jmdict_kanji('伝える')).
pick(w_tsutsumu,           ja, n4, word, jmdict('1584060')).  % つつむ to wrap up, to pack, to bundle
pick(w_todokeru,           ja, n4, word, jmdict_kanji('届ける')).
pick(w_todoku,             ja, n4, word, jmdict_kanji('届く')).
pick(w_mukaeru,            ja, n4, word, jmdict_kanji('迎える')).
pick(w_tsuzukeru,          ja, n4, word, jmdict_kanji('続ける')).
pick(w_ugokasu,            ja, n4, word, jmdict_kanji('動かす')).
pick(w_shiraberu,          ja, n4, word, jmdict_kanji('調べる')).
pick(w_kuraberu,           ja, n4, word, jmdict_kanji('比べる')).
pick(w_kimaru,             ja, n4, word, jmdict_kanji('決まる')).
pick(w_mitsukaru,          ja, n4, word, jmdict_kanji('見つかる')).
pick(w_wakasu,             ja, n4, word, jmdict_kanji('沸かす')).
pick(w_nieru,              ja, n4, word, jmdict_kanji('煮える')).
pick(w_yaku_bake,          ja, n4, word, jmdict_kanji('焼く')).
pick(w_mazeru,             ja, n4, word, jmdict_kanji('混ぜる')).
pick(w_naraberu,           ja, n4, word, jmdict_kanji('並べる')).
pick(w_kazaru,             ja, n4, word, jmdict_kanji('飾る')).
pick(w_katazukeru,         ja, n4, word, jmdict_kanji('片付ける')).
pick(w_suteru,             ja, n4, word, jmdict_kanji('捨てる')).
pick(w_hirou,              ja, n4, word, jmdict_kanji('拾う')).
pick(w_azukeru,            ja, n4, word, jmdict_kanji('預ける')).
pick(w_tamaru,             ja, n4, word, jmdict_kanji('貯まる')).
pick(w_ukeru,              ja, n4, word, jmdict_kanji('受ける')).
pick(w_torikaeru,          ja, n4, word, jmdict_kanji('取り替える')).
pick(w_shinjiru,           ja, n4, word, jmdict_kanji('信じる')).
pick(w_kanjiru,            ja, n4, word, jmdict_kanji('感じる')).
pick(w_odoroku,            ja, n4, word, jmdict_kanji('驚く')).
pick(w_kawaigaru,          ja, n4, word, jmdict_kanji('可愛がる')).
pick(w_nayamu,             ja, n4, word, jmdict_kanji('悩む')).
pick(w_yorokobu,           ja, n4, word, jmdict_kanji('喜ぶ')).
pick(w_akogareru,          ja, n4, word, jmdict_kanji('憧れる')).
pick(w_ganbaru,            ja, n4, word, jmdict_kanji('頑張る')).  % kana: every kanji spelling of it is tagged rare
pick(w_shikaru,            ja, n4, word, jmdict_kanji('叱る')).
pick(w_homeru,             ja, n4, word, jmdict_kanji('褒める')).
pick(w_ayamaru,            ja, n4, word, jmdict_kanji('謝る')).
pick(w_sasou,              ja, n4, word, jmdict_kanji('誘う')).
pick(w_shoukai,            ja, n4, word, jmdict_kanji('紹介')).
pick(w_soudan,             ja, n4, word, jmdict_kanji('相談')).
pick(w_renraku,            ja, n4, word, jmdict_kanji('連絡')).
pick(w_houkoku,            ja, n4, word, jmdict_kanji('報告')).
pick(w_hanashikakeru,      ja, n4, word, jmdict_kanji('話し掛ける')).
pick(w_sakebu,             ja, n4, word, jmdict_kanji('叫ぶ')).
pick(w_damaru,             ja, n4, word, jmdict_kanji('黙る')).
pick(w_tsubuyaku,          ja, n4, word, jmdict_kanji('呟く')).
pick(w_narasu,             ja, n4, word, jmdict_kanji('鳴らす')).
pick(w_nagameru,           ja, n4, word, jmdict_kanji('眺める')).
pick(w_miokuru,            ja, n4, word, jmdict_kanji('見送る')).
pick(w_tsureru,            ja, n4, word, jmdict_kanji('連れる')).
pick(w_norikaeru,          ja, n4, word, jmdict_kanji('乗り換える')).
pick(w_koeru,              ja, n4, word, jmdict_kanji('越える')).
pick(w_susumu,             ja, n4, word, jmdict('1365980')).  % すすむ to advance (spatially), to go forw
pick(w_modoru,             ja, n4, word, jmdict('1535880')).  % もどる to turn back (e.g. half-way)
pick(w_sagaru,             ja, n4, word, jmdict_kanji('下がる')).
pick(w_korobu,             ja, n4, word, jmdict_kanji('転ぶ')).
pick(w_taoreru,            ja, n4, word, jmdict_kanji('倒れる')).
pick(w_okosu,              ja, n4, word, jmdict_kanji('起こす')).
pick(w_nemuru,             ja, n4, word, jmdict_kanji('眠る')).
pick(w_mottekuru,          ja, n4, word, jmdict_kanji('持って来る')).
pick(w_nageru,             ja, n4, word, jmdict_kanji('投げる')).
pick(w_utsu,               ja, n4, word, jmdict('1408810')).  % うつ to hit, to strike, to knock
pick(w_keru,               ja, n4, word, jmdict_kanji('蹴る')).
pick(w_tataku,             ja, n4, word, jmdict('1416170')).  % たたく to strike, to hit, to beat
pick(w_kowasu,             ja, n4, word, jmdict_kanji('壊す')).
pick(w_wareru,             ja, n4, word, jmdict_kanji('割れる')).
pick(w_waru,               ja, n4, word, jmdict_kanji('割る')).
pick(w_yabureru,           ja, n4, word, jmdict('1471210')).  % やぶれる to get torn, to tear, to rip
pick(w_kireru,             ja, n4, word, jmdict_kanji('切れる')).
pick(w_kaburu,             ja, n4, word, jmdict('1484330')).  % かぶる to put on (one's head), to wear, t
pick(w_hazusu,             ja, n4, word, jmdict_kanji('外す')).
pick(w_nareru,             ja, n4, word, jmdict_kanji('慣れる')).
pick(w_tazuneru,           ja, n4, word, jmdict_kanji('訪ねる')).
pick(w_otozureru,          ja, n4, word, jmdict_kanji('訪れる')).
pick(w_hikkosu,            ja, n4, word, jmdict_kanji('引っ越す')).
pick(w_kayou,              ja, n4, word, jmdict_kanji('通う')).
pick(w_maniau,             ja, n4, word, jmdict_kanji('間に合う')).
pick(w_yameru_quit,        ja, n4, word, jmdict_kanji('辞める')).
pick(w_tsutomeru,          ja, n4, word, jmdict_kanji('勤める')).
pick(w_atsukau,            ja, n4, word, jmdict_kanji('扱う')).
pick(w_shiraseru,          ja, n4, word, jmdict_kanji('知らせる')).
pick(w_mamoru,             ja, n4, word, jmdict_kanji('守る')).
pick(w_nusumu,             ja, n4, word, jmdict_kanji('盗む')).
pick(w_ushinau,            ja, n4, word, jmdict_kanji('失う')).
pick(w_nakusu,             ja, n4, word, jmdict_kanji('無くす')).
pick(w_otosu,              ja, n4, word, jmdict_kanji('落とす')).
pick(w_ukabu,              ja, n4, word, jmdict_kanji('浮かぶ')).
pick(w_shizumu,            ja, n4, word, jmdict_kanji('沈む')).
pick(w_nagareru,           ja, n4, word, jmdict_kanji('流れる')).
pick(w_hareru,             ja, n4, word, jmdict_kanji('晴れる')).
pick(w_kumoru,             ja, n4, word, jmdict_kanji('曇る')).
pick(w_hikaru,             ja, n4, word, jmdict_kanji('光る')).
pick(w_moeru,              ja, n4, word, jmdict_kanji('燃える')).
pick(w_kieru,              ja, n4, word, jmdict_kanji('消える')).
pick(w_sodateru,           ja, n4, word, jmdict_kanji('育てる')).
pick(w_sodatsu,            ja, n4, word, jmdict_kanji('育つ')).
pick(w_umu,                ja, n4, word, jmdict_kanji('産む')).
pick(w_fueru,              ja, n4, word, jmdict_kanji('増える')).
pick(w_herasu,             ja, n4, word, jmdict_kanji('減らす')).
pick(w_heru_decrease,      ja, n4, word, jmdict_kanji('減る')).
pick(w_fukureru,           ja, n4, word, jmdict_kanji('膨れる')).
pick(w_nobiru,             ja, n4, word, jmdict_kanji('伸びる')).
pick(w_chijimu,            ja, n4, word, jmdict_kanji('縮む')).
pick(w_nobasu,             ja, n4, word, jmdict_kanji('伸ばす')).
pick(w_kasanaru,           ja, n4, word, jmdict('1335800')).  % かさなる to be piled up, to lie on top of o
pick(w_tsumoru,            ja, n4, word, jmdict_kanji('積もる')).
pick(w_yaru,               ja, n4, word, jmdict('1012980')).  %  
pick(w_shimau,             ja, n4, word, jmdict_kanji('仕舞う')).  % kana: every kanji spelling of it is tagged rare
pick(w_sonaeru,            ja, n4, word, jmdict_kanji('備える')).
pick(w_youi,               ja, n4, word, jmdict_kanji('用意')).
pick(w_sanka,              ja, n4, word, jmdict_kanji('参加')).
pick(w_shusseki,           ja, n4, word, jmdict_kanji('出席')).
pick(w_kesseki,            ja, n4, word, jmdict_kanji('欠席')).
pick(w_kansei,             ja, n4, word, jmdict_kanji('完成')).
pick(w_kaishi,             ja, n4, word, jmdict_kanji('開始')).
pick(w_shuuryou,           ja, n4, word, jmdict_kanji('終了')).
pick(w_kaiketsu,           ja, n4, word, jmdict_kanji('解決')).
pick(w_sansei,             ja, n4, word, jmdict_kanji('賛成')).
pick(w_kettei,             ja, n4, word, jmdict_kanji('決定')).
pick(w_hensou,             ja, n4, word, jmdict_kanji('返送')).
pick(w_kakunin,            ja, n4, word, jmdict_kanji('確認')).
pick(w_sewa,               ja, n4, word, jmdict_kanji('世話')).
pick(w_kansha,             ja, n4, word, jmdict_kanji('感謝')).
pick(w_manzoku,            ja, n4, word, jmdict_kanji('満足')).
pick(w_kitai,              ja, n4, word, jmdict_kanji('期待')).
pick(w_kinchou,            ja, n4, word, jmdict_kanji('緊張')).
pick(w_enryo,              ja, n4, word, jmdict_kanji('遠慮')).
pick(w_gaman,              ja, n4, word, jmdict_kanji('我慢')).
pick(w_kyouryoku,          ja, n4, word, jmdict_kanji('協力')).
pick(w_riyou,              ja, n4, word, jmdict_kanji('利用')).
pick(w_shiyou,             ja, n4, word, jmdict_kanji('使用')).
pick(w_shokuji,            ja, n4, word, jmdict_kanji('食事')).
pick(w_kyouiku,            ja, n4, word, jmdict_kanji('教育')).
pick(w_goukaku,            ja, n4, word, jmdict_kanji('合格')).
pick(w_shuushoku,          ja, n4, word, jmdict_kanji('就職')).
pick(w_taishoku,           ja, n4, word, jmdict_kanji('退職')).
pick(w_zangyou,            ja, n4, word, jmdict_kanji('残業')).
pick(w_shucchou,           ja, n4, word, jmdict_kanji('出張')).
pick(w_seikatsu,           ja, n4, word, jmdict_kanji('生活')).

% --- Describing ----------------------------------------------------------------
pick(w_utsukushii,         ja, n4, word, jmdict_kanji('美しい')).
pick(w_kibishii,           ja, n4, word, jmdict('1262530')).  % きびしい severe, strict, rigid
pick(w_hazukashii,         ja, n4, word, jmdict_kanji('恥ずかしい')).
pick(w_urayamashii,        ja, n4, word, jmdict_kanji('羨ましい')).
pick(w_kuyashii,           ja, n4, word, jmdict_kanji('悔しい')).
pick(w_natsukashii,        ja, n4, word, jmdict_kanji('懐かしい')).
pick(w_mezurashii,         ja, n4, word, jmdict_kanji('珍しい')).
pick(w_kuwashii,           ja, n4, word, jmdict_kanji('詳しい')).
pick(w_tadashii,           ja, n4, word, jmdict_kanji('正しい')).
pick(w_okashii,            ja, n4, word, jmdict_kana('おかしい')).
pick(w_subarashii,         ja, n4, word, jmdict_kanji('素晴らしい')).  % kana: every kanji spelling of it is tagged rare
pick(w_osoroshii,          ja, n4, word, jmdict_kanji('恐ろしい')).
pick(w_komakai,            ja, n4, word, jmdict_kanji('細かい')).
pick(w_arai,               ja, n4, word, jmdict_kanji('粗い')).
pick(w_katai,              ja, n4, word, jmdict_kanji('硬い')).
pick(w_yawarakai,          ja, n4, word, jmdict_kanji('柔らかい')).
pick(w_fukai,              ja, n4, word, jmdict_kanji('深い')).
pick(w_asai,               ja, n4, word, jmdict_kanji('浅い')).
pick(w_shikakui,           ja, n4, word, jmdict_kanji('四角い')).
pick(w_mazui,              ja, n4, word, jmdict_kana('まずい')).
pick(w_suppai,             ja, n4, word, jmdict_kanji('酸っぱい')).
pick(w_shoppai,            ja, n4, word, jmdict_kanji('塩っぱい')).
pick(w_koi_strong,         ja, n4, word, jmdict_kanji('濃い')).
pick(w_kashikoi,           ja, n4, word, jmdict_kanji('賢い')).
pick(w_kitsui,             ja, n4, word, jmdict_kana('きつい')).
pick(w_mendokusai,         ja, n4, word, jmdict_kanji('面倒臭い')).
pick(w_kusai,              ja, n4, word, jmdict('1333150')).  % くさい stinking, smelly
pick(w_shoujiki,           ja, n4, word, jmdict_kanji('正直')).
pick(w_majime,             ja, n4, word, jmdict('1364360')).  %  
pick(w_rippa,              ja, n4, word, jmdict_kanji('立派')).
pick(w_fukuzatsu,          ja, n4, word, jmdict_kanji('複雑')).
pick(w_tanjun,             ja, n4, word, jmdict_kanji('単純')).
pick(w_juuyou,             ja, n4, word, jmdict_kanji('重要')).
pick(w_tekitou,            ja, n4, word, jmdict_kanji('適当')).
pick(w_jiyuu,              ja, n4, word, jmdict_kanji('自由')).
pick(w_kiken,              ja, n4, word, jmdict_kanji('危険')).
pick(w_seikaku_exact,      ja, n4, word, jmdict_kanji('正確')).
pick(w_meikaku,            ja, n4, word, jmdict_kanji('明確')).
pick(w_zannen,             ja, n4, word, jmdict_kanji('残念')).
pick(w_ippan,              ja, n4, word, jmdict_kanji('一般')).
pick(w_tashika,            ja, n4, word, jmdict_kanji('確か')).
pick(w_akiraka,            ja, n4, word, jmdict_kanji('明らか')).
pick(w_hakkiri,            ja, n4, word, jmdict_kana('はっきり')).
pick(w_rakuchin,           ja, n4, word, jmdict_kanji('楽ちん')).
pick(w_iya,                ja, n4, word, jmdict_kanji('嫌')).
pick(w_kekkou,             ja, n4, word, jmdict_kanji('結構')).
pick(w_dame,               ja, n4, word, jmdict_kanji('駄目')).
pick(w_muri,               ja, n4, word, jmdict_kanji('無理')).
pick(w_toku,               ja, n4, word, jmdict('1454490')).  % とく profit, advantage, benefit
pick(w_son,                ja, n4, word, jmdict_kanji('損')).
pick(w_heiki,              ja, n4, word, jmdict_kanji('平気')).
pick(w_wakamono,           ja, n4, word, jmdict_kanji('若者')).

% --- People, and what they are to each other -----------------------------------
pick(w_shimin,             ja, n4, word, jmdict_kanji('市民')).
pick(w_kokumin,            ja, n4, word, jmdict('1287070')).  % こくみん people (of a country), nation, cit
pick(w_jinkou,             ja, n4, word, jmdict_kanji('人口')).
pick(w_shakai,             ja, n4, word, jmdict_kanji('社会')).
pick(w_seiji,              ja, n4, word, jmdict_kanji('政治')).
pick(w_keizai,             ja, n4, word, jmdict_kanji('経済')).
pick(w_shuukyou,           ja, n4, word, jmdict_kanji('宗教')).
pick(w_houritsu,           ja, n4, word, jmdict_kanji('法律')).
pick(w_kisoku,             ja, n4, word, jmdict_kanji('規則')).
pick(w_sensou,             ja, n4, word, jmdict_kanji('戦争')).
pick(w_heiwa,              ja, n4, word, jmdict('1508070')).  % へいわ peace, harmony
pick(w_kenri,              ja, n4, word, jmdict_kanji('権利')).
pick(w_gimu,               ja, n4, word, jmdict_kanji('義務')).
pick(w_sekinin,            ja, n4, word, jmdict_kanji('責任')).
pick(w_kankei,             ja, n4, word, jmdict_kanji('関係')).
pick(w_shuukan,            ja, n4, word, jmdict_kanji('習慣')).
pick(w_dentou,             ja, n4, word, jmdict_kanji('伝統')).
pick(w_gijutsu,            ja, n4, word, jmdict_kanji('技術')).
pick(w_igaku,              ja, n4, word, jmdict_kanji('医学')).
pick(w_sangyou,            ja, n4, word, jmdict_kanji('産業')).
pick(w_nougyou,            ja, n4, word, jmdict_kanji('農業')).
pick(w_buchou,             ja, n4, word, jmdict_kanji('部長')).
pick(w_kachou,             ja, n4, word, jmdict_kanji('課長')).
pick(w_douryou,            ja, n4, word, jmdict_kanji('同僚')).
pick(w_joushi,             ja, n4, word, jmdict_kanji('上司')).
pick(w_buka,               ja, n4, word, jmdict_kanji('部下')).
pick(w_shain,              ja, n4, word, jmdict_kanji('社員')).
pick(w_kokyaku,            ja, n4, word, jmdict_kanji('顧客')).
pick(w_keikan,             ja, n4, word, jmdict_kanji('警官')).
pick(w_shoubousha,         ja, n4, word, jmdict_kanji('消防車')).
pick(w_bengoshi,           ja, n4, word, jmdict_kanji('弁護士')).
pick(w_haisha,             ja, n4, word, jmdict_kanji('歯医者')).
pick(w_kyoushi,            ja, n4, word, jmdict_kanji('教師')).
pick(w_kyouju,             ja, n4, word, jmdict_kanji('教授')).
pick(w_gakusha,            ja, n4, word, jmdict_kanji('学者')).
pick(w_kashu,              ja, n4, word, jmdict_kanji('歌手')).
pick(w_haiyuu,             ja, n4, word, jmdict_kanji('俳優')).
pick(w_senshu,             ja, n4, word, jmdict_kanji('選手')).
pick(w_kantoku,            ja, n4, word, jmdict_kanji('監督')).
pick(w_sakka,              ja, n4, word, jmdict_kanji('作家')).
pick(w_gaka,               ja, n4, word, jmdict_kanji('画家')).
pick(w_ongakuka,           ja, n4, word, jmdict_kanji('音楽家')).
pick(w_kenchikuka,         ja, n4, word, jmdict_kanji('建築家')).
pick(w_nouka,              ja, n4, word, jmdict_kanji('農家')).
pick(w_ryoushi,            ja, n4, word, jmdict_kanji('漁師')).
pick(w_daiku,              ja, n4, word, jmdict_kanji('大工')).
pick(w_biyoushi,           ja, n4, word, jmdict_kanji('美容師')).
pick(w_shufu,              ja, n4, word, jmdict_kanji('主婦')).
pick(w_shounen,            ja, n4, word, jmdict_kanji('少年')).
pick(w_shoujo,             ja, n4, word, jmdict('1580290')).  % しょうじょ girl (usu. between 7 and 17), youn
pick(w_seinen,             ja, n4, word, jmdict_kanji('青年')).
pick(w_roujin,             ja, n4, word, jmdict_kanji('老人')).
pick(w_fuufu,              ja, n4, word, jmdict('1583640')).  % ふうふ married couple, husband and wife, 
pick(w_tsuma,              ja, n4, word, jmdict('1294330')).  % つま wife
pick(w_otto,               ja, n4, word, jmdict('1496480')).  % おっと husband
pick(w_mago,               ja, n4, word, jmdict('1406230')).  % まご grandchild
pick(w_oji,                ja, n4, word, jmdict('1607070')).  % おじ uncle
pick(w_oba,                ja, n4, word, jmdict_kanji('叔母')).
pick(w_shinseki,           ja, n4, word, jmdict_kanji('親戚')).
pick(w_nakama,             ja, n4, word, jmdict('1425790')).  % なかま companion, fellow, friend
pick(w_shiriai,            ja, n4, word, jmdict_kanji('知り合い')).
pick(w_koibito,            ja, n4, word, jmdict_kanji('恋人')).
pick(w_kareshi,            ja, n4, word, jmdict_kanji('彼氏')).
pick(w_aite,               ja, n4, word, jmdict_kanji('相手')).
pick(w_dareka,             ja, n4, word, jmdict_kanji('誰か')).

% --- Work, school and paper ----------------------------------------------------
pick(w_shokuba,            ja, n4, word, jmdict_kanji('職場')).
pick(w_kaigishitsu,        ja, n4, word, jmdict_kanji('会議室')).
pick(w_shorui,             ja, n4, word, jmdict_kanji('書類')).
pick(w_hyou,               ja, n4, word, jmdict('1489350')).  % ひょう table, chart, list
pick(w_gurafu,             ja, n4, word, jmdict_kana('グラフ')).
pick(w_houkokusho,         ja, n4, word, jmdict_kanji('報告書')).
pick(w_keikaku,            ja, n4, word, jmdict_kanji('計画')).
pick(w_mokuteki,           ja, n4, word, jmdict_kanji('目的')).
pick(w_kekka,              ja, n4, word, jmdict_kanji('結果')).
pick(w_genin,              ja, n4, word, jmdict_kanji('原因')).
pick(w_kadai,              ja, n4, word, jmdict_kanji('課題')).
pick(w_houhou,             ja, n4, word, jmdict_kanji('方法')).
pick(w_naiyou,             ja, n4, word, jmdict_kanji('内容')).
pick(w_jouhou,             ja, n4, word, jmdict_kanji('情報')).
pick(w_chishiki,           ja, n4, word, jmdict_kanji('知識')).
pick(w_ishiki,             ja, n4, word, jmdict_kanji('意識')).
pick(w_kioku,              ja, n4, word, jmdict_kanji('記憶')).
pick(w_chuumoku,           ja, n4, word, jmdict_kanji('注目')).
pick(w_hanbai,             ja, n4, word, jmdict_kanji('販売')).
pick(w_eigyou,             ja, n4, word, jmdict_kanji('営業')).
pick(w_kyuuryou,           ja, n4, word, jmdict_kanji('給料')).
pick(w_shuunyuu,           ja, n4, word, jmdict_kanji('収入')).
pick(w_hiyou,              ja, n4, word, jmdict_kanji('費用')).
pick(w_yosan,              ja, n4, word, jmdict_kanji('予算')).
pick(w_zeikin,             ja, n4, word, jmdict_kanji('税金')).
pick(w_ryoushuusho,        ja, n4, word, jmdict_kanji('領収書')).
pick(w_seikyuusho,         ja, n4, word, jmdict_kanji('請求書')).
pick(w_keiyaku,            ja, n4, word, jmdict_kanji('契約')).
pick(w_youshi,             ja, n4, word, jmdict_kanji('用紙')).
pick(w_insatsu,            ja, n4, word, jmdict_kanji('印刷')).
pick(w_kopii,              ja, n4, word, jmdict_kana('コピー')).
pick(w_fakkusu,            ja, n4, word, jmdict_kana('ファックス')).
pick(w_denwabangou,        ja, n4, word, jmdict_kanji('電話番号')).
pick(w_shimei,             ja, n4, word, jmdict_kanji('氏名')).
pick(w_shomei,             ja, n4, word, jmdict_kanji('署名')).
pick(w_hanko,              ja, n4, word, jmdict_kanji('判子')).  % kana: every kanji spelling of it is tagged rare
pick(w_meishi,             ja, n4, word, jmdict_kanji('名刺')).
pick(w_bumon,              ja, n4, word, jmdict_kanji('部門')).
pick(w_kijitsu,            ja, n4, word, jmdict_kanji('期日')).
pick(w_kigen,              ja, n4, word, jmdict_kanji('期限')).
pick(w_nittei,             ja, n4, word, jmdict_kanji('日程')).
pick(w_jikanwari,          ja, n4, word, jmdict_kanji('時間割')).
pick(w_kyuujitsu,          ja, n4, word, jmdict_kanji('休日')).
pick(w_renkyuu,            ja, n4, word, jmdict_kanji('連休')).
pick(w_kyuuka,             ja, n4, word, jmdict_kanji('休暇')).
pick(w_tesuto,             ja, n4, word, jmdict_kana('テスト')).
pick(w_seiseki,            ja, n4, word, jmdict_kanji('成績')).
pick(w_tensuu,             ja, n4, word, jmdict_kanji('点数')).
pick(w_gakki,              ja, n4, word, jmdict_kanji('学期')).
pick(w_kougi,              ja, n4, word, jmdict_kanji('講義')).
pick(w_ronbun,             ja, n4, word, jmdict_kanji('論文')).
pick(w_tsuuyaku,           ja, n4, word, jmdict_kanji('通訳')).
pick(w_honyaku,            ja, n4, word, jmdict_kanji('翻訳')).
pick(w_gaikokugo,          ja, n4, word, jmdict_kanji('外国語')).
pick(w_eikaiwa,            ja, n4, word, jmdict_kanji('英会話')).
pick(w_gakureki,           ja, n4, word, jmdict_kanji('学歴')).
pick(w_senmon,             ja, n4, word, jmdict_kanji('専門')).
pick(w_gakubu,             ja, n4, word, jmdict_kanji('学部')).
pick(w_daigakuin,          ja, n4, word, jmdict_kanji('大学院')).
pick(w_kenkyuushitsu,      ja, n4, word, jmdict_kanji('研究室')).
pick(w_bunbougu,           ja, n4, word, jmdict_kanji('文房具')).
pick(w_jougi,              ja, n4, word, jmdict_kanji('定規')).
pick(w_hasami,             ja, n4, word, jmdict('1573820')).  % はさみ scissors, shears, clippers
pick(w_nori,               ja, n4, word, jmdict_kanji('糊')).
pick(w_shimekiri,          ja, n4, word, jmdict_kanji('締め切り')).

% --- Travel, the road, and what goes wrong on it -------------------------------
pick(w_zaseki,             ja, n4, word, jmdict_kanji('座席')).
pick(w_touchaku,           ja, n4, word, jmdict_kanji('到着')).
pick(w_norikae,            ja, n4, word, jmdict_kanji('乗り換え')).
pick(w_katamichi,          ja, n4, word, jmdict_kanji('片道')).
pick(w_oufuku,             ja, n4, word, jmdict_kanji('往復')).
pick(w_shiteiseki,         ja, n4, word, jmdict_kanji('指定席')).
pick(w_jiyuuseki,          ja, n4, word, jmdict_kanji('自由席')).
pick(w_unchin,             ja, n4, word, jmdict_kanji('運賃')).
pick(w_jikokuhyou,         ja, n4, word, jmdict_kanji('時刻表')).
pick(w_kaisatsuguchi,      ja, n4, word, jmdict_kanji('改札口')).
pick(w_shuuten,            ja, n4, word, jmdict_kanji('終点')).
pick(w_tochuu,             ja, n4, word, jmdict_kanji('途中')).
pick(w_keiro,              ja, n4, word, jmdict_kanji('経路')).
pick(w_hyoushiki,          ja, n4, word, jmdict_kanji('標識')).
pick(w_oudanhodou,         ja, n4, word, jmdict_kanji('横断歩道')).
pick(w_hodou,              ja, n4, word, jmdict_kanji('歩道')).
pick(w_shadou,             ja, n4, word, jmdict_kanji('車道')).
pick(w_tsuuro,             ja, n4, word, jmdict_kanji('通路')).
pick(w_douro,              ja, n4, word, jmdict_kanji('道路')).
pick(w_juutai,             ja, n4, word, jmdict_kanji('渋滞')).
pick(w_kousoku,            ja, n4, word, jmdict_kanji('高速')).
pick(w_chuushajou,         ja, n4, word, jmdict_kanji('駐車場')).
pick(w_gasorin,            ja, n4, word, jmdict_kana('ガソリン')).
pick(w_takushiinoriba,     ja, n4, word, jmdict_kanji('タクシー乗り場')).
pick(w_basutei,            ja, n4, word, jmdict_kanji('バス停')).
pick(w_kyuukou,            ja, n4, word, jmdict_kanji('急行')).
pick(w_tokkyuu,            ja, n4, word, jmdict_kanji('特急')).
pick(w_ressha,             ja, n4, word, jmdict_kanji('列車')).
pick(w_senro,              ja, n4, word, jmdict_kanji('線路')).
pick(w_funabin,            ja, n4, word, jmdict_kanji('船便')).
pick(w_kyakusen,           ja, n4, word, jmdict_kanji('客船')).
pick(w_shukuhaku,          ja, n4, word, jmdict_kanji('宿泊')).
pick(w_furonto,            ja, n4, word, jmdict_kana('フロント')).
pick(w_suutsukeesu,        ja, n4, word, jmdict_kana('スーツケース')).
pick(w_pasupooto,          ja, n4, word, jmdict_kana('パスポート')).
pick(w_biza,               ja, n4, word, jmdict('1104720')).  % ビザ visa
pick(w_kokusai,            ja, n4, word, jmdict_kanji('国際')).
pick(w_kokunai,            ja, n4, word, jmdict_kanji('国内')).
pick(w_kaigai,             ja, n4, word, jmdict_kanji('海外')).
pick(w_kankou,             ja, n4, word, jmdict_kanji('観光')).
pick(w_meisho,             ja, n4, word, jmdict('1531600')).  % めいしょ famous place, noted place, place o
pick(w_omiyage,            ja, n4, word, jmdict_kanji('お土産')).
pick(w_kinen,              ja, n4, word, jmdict_kanji('記念')).
pick(w_annaijo,            ja, n4, word, jmdict_kanji('案内所')).
pick(w_tsuaa,              ja, n4, word, jmdict_kana('ツアー')).
pick(w_gaido,              ja, n4, word, jmdict_kana('ガイド')).
pick(w_tenkou,             ja, n4, word, jmdict_kanji('天候')).
pick(w_kion,               ja, n4, word, jmdict_kanji('気温')).
pick(w_yohou,              ja, n4, word, jmdict_kanji('予報')).
pick(w_jishin,             ja, n4, word, jmdict('1421210')).  % じしん earthquake
pick(w_kaji,               ja, n4, word, jmdict_kanji('火事')).
pick(w_jiko,               ja, n4, word, jmdict_kanji('事故')).
pick(w_kikenbutsu,         ja, n4, word, jmdict_kanji('危険物')).
pick(w_hijouguchi,         ja, n4, word, jmdict_kanji('非常口')).
pick(w_kyuukyuusha,        ja, n4, word, jmdict_kanji('救急車')).
pick(w_sougoubyouin,       ja, n4, word, jmdict_kanji('総合病院')).

% --- The home, the street and the town -----------------------------------------
pick(w_juutaku,            ja, n4, word, jmdict_kanji('住宅')).
pick(w_ikkodate,           ja, n4, word, jmdict_kanji('一戸建て')).
pick(w_yachin,             ja, n4, word, jmdict_kanji('家賃')).
pick(w_ooya,               ja, n4, word, jmdict('1413140')).  % おおや landlord, landlady
pick(w_rouka,              ja, n4, word, jmdict_kanji('廊下')).
pick(w_tenjou,             ja, n4, word, jmdict_kanji('天井')).
pick(w_yane,               ja, n4, word, jmdict_kanji('屋根')).
pick(w_hashira,            ja, n4, word, jmdict('1426480')).  % はしら pillar, post
pick(w_oshiire,            ja, n4, word, jmdict_kanji('押し入れ')).
pick(w_hikidashi,          ja, n4, word, jmdict_kanji('引き出し')).
pick(w_sofa,               ja, n4, word, jmdict_kana('ソファー')).
pick(w_kaaten,             ja, n4, word, jmdict_kana('カーテン')).
pick(w_juutan,             ja, n4, word, jmdict_kanji('絨毯')).
pick(w_tatami,             ja, n4, word, jmdict('1356750')).  % たたみ tatami mat
pick(w_makura,             ja, n4, word, jmdict_kanji('枕')).
pick(w_moufu,              ja, n4, word, jmdict_kanji('毛布')).
pick(w_shiitsu,            ja, n4, word, jmdict_kana('シーツ')).
pick(w_dengen,             ja, n4, word, jmdict_kanji('電源')).
pick(w_dentou_lamp,        ja, n4, word, jmdict_kanji('電灯')).
pick(w_konsento,           ja, n4, word, jmdict_kana('コンセント')).
pick(w_denkyuu,            ja, n4, word, jmdict_kanji('電球')).
pick(w_danbou,             ja, n4, word, jmdict_kanji('暖房')).
pick(w_reibou,             ja, n4, word, jmdict_kanji('冷房')).
pick(w_eakon,              ja, n4, word, jmdict_kana('エアコン')).
pick(w_senpuuki,           ja, n4, word, jmdict_kanji('扇風機')).
pick(w_sutoobu,            ja, n4, word, jmdict_kana('ストーブ')).
pick(w_soujiki,            ja, n4, word, jmdict_kanji('掃除機')).
pick(w_denshirenji,        ja, n4, word, jmdict_kanji('電子レンジ')).
pick(w_suihanki,           ja, n4, word, jmdict_kanji('炊飯器')).
pick(w_yakan,              ja, n4, word, jmdict_kanji('薬缶')).
pick(w_furaipan,           ja, n4, word, jmdict_kana('フライパン')).
pick(w_houchou,            ja, n4, word, jmdict_kanji('包丁')).
pick(w_manaita,            ja, n4, word, jmdict_kanji('まな板')).
pick(w_shokki,             ja, n4, word, jmdict_kanji('食器')).
pick(w_osara,              ja, n4, word, jmdict_kanji('お皿')).
pick(w_gurasu,             ja, n4, word, jmdict('1046430')).  % グラス glass (drinking vessel)
pick(w_gomibako,           ja, n4, word, jmdict_kanji('ゴミ箱')).
pick(w_gomi,               ja, n4, word, jmdict_kana('ゴミ')).
pick(w_sentakumono,        ja, n4, word, jmdict_kanji('洗濯物')).
pick(w_haburashi,          ja, n4, word, jmdict_kanji('歯ブラシ')).
pick(w_hamigaki,           ja, n4, word, jmdict_kanji('歯磨き')).
pick(w_shanpuu,            ja, n4, word, jmdict_kana('シャンプー')).
pick(w_kushi,              ja, n4, word, jmdict_kanji('櫛')).
pick(w_kamisori,           ja, n4, word, jmdict_kanji('剃刀')).
pick(w_furoba,             ja, n4, word, jmdict_kanji('風呂場')).
pick(w_yokushitsu,         ja, n4, word, jmdict_kanji('浴室')).
pick(w_senmendai,          ja, n4, word, jmdict_kanji('洗面台')).
pick(w_suidou,             ja, n4, word, jmdict_kanji('水道')).
pick(w_jaguchi,            ja, n4, word, jmdict_kanji('蛇口')).
pick(w_haisuikan,          ja, n4, word, jmdict_kanji('排水管')).
pick(w_teien,              ja, n4, word, jmdict_kanji('庭園')).
pick(w_kadan,              ja, n4, word, jmdict_kanji('花壇')).
pick(w_shokubutsu,         ja, n4, word, jmdict_kanji('植物')).
pick(w_ueki,               ja, n4, word, jmdict_kanji('植木')).
pick(w_hei,                ja, n4, word, jmdict_kanji('塀')).
pick(w_shako,              ja, n4, word, jmdict_kanji('車庫')).
pick(w_yuubinbako,         ja, n4, word, jmdict_kanji('郵便箱')).
pick(w_hyousatsu,          ja, n4, word, jmdict_kanji('表札')).
pick(w_kinjo,              ja, n4, word, jmdict_kanji('近所')).
pick(w_chiiki,             ja, n4, word, jmdict_kanji('地域')).
pick(w_juutakugai,         ja, n4, word, jmdict_kanji('住宅街')).
pick(w_shougakkou,         ja, n4, word, jmdict_kanji('小学校')).
pick(w_chuugakkou,         ja, n4, word, jmdict_kanji('中学校')).
pick(w_koukou,             ja, n4, word, jmdict_kanji('高校')).
pick(w_yakkyoku,           ja, n4, word, jmdict_kanji('薬局')).
pick(w_hyakkaten,          ja, n4, word, jmdict_kanji('百貨店')).
pick(w_shoutengai,         ja, n4, word, jmdict_kanji('商店街')).
pick(w_hiroba,             ja, n4, word, jmdict_kanji('広場')).
pick(w_gekijou,            ja, n4, word, jmdict_kanji('劇場')).
pick(w_taiikukan,          ja, n4, word, jmdict_kanji('体育館')).
pick(w_puuru,              ja, n4, word, jmdict_kana('プール')).
pick(w_undoujou,           ja, n4, word, jmdict_kanji('運動場')).
pick(w_kouminkan,          ja, n4, word, jmdict_kanji('公民館')).
pick(w_yakusho,            ja, n4, word, jmdict('1538020')).  % やくしょ government office, public office
pick(w_keisatsusho,        ja, n4, word, jmdict_kanji('警察署')).
pick(w_shoubousho,         ja, n4, word, jmdict_kanji('消防署')).
pick(w_ekimae,             ja, n4, word, jmdict_kanji('駅前')).

% --- The body, being ill, and what is on the table -----------------------------
pick(w_kenkou,             ja, n4, word, jmdict_kanji('健康')).
pick(w_kazegusuri,         ja, n4, word, jmdict_kanji('風邪薬')).
pick(w_hanamizu,           ja, n4, word, jmdict_kanji('鼻水')).
pick(w_itami,              ja, n4, word, jmdict_kanji('痛み')).
pick(w_yakedo,             ja, n4, word, jmdict('1577310')).  % やけど burn, scald
pick(w_arerugii,           ja, n4, word, jmdict_kana('アレルギー')).
pick(w_kafunshou,          ja, n4, word, jmdict_kanji('花粉症')).
pick(w_mushiba,            ja, n4, word, jmdict_kanji('虫歯')).
pick(w_shujutsu,           ja, n4, word, jmdict_kanji('手術')).
pick(w_chuusha,            ja, n4, word, jmdict_kanji('注射')).
pick(w_shohousen,          ja, n4, word, jmdict_kanji('処方箋')).
pick(w_taion,              ja, n4, word, jmdict_kanji('体温')).
pick(w_ketsuatsu,          ja, n4, word, jmdict_kanji('血圧')).
pick(w_ketsueki,           ja, n4, word, jmdict_kanji('血液')).
pick(w_shinzou,            ja, n4, word, jmdict_kanji('心臓')).
pick(w_i_stomach,          ja, n4, word, jmdict_kanji('胃')).
pick(w_chou,               ja, n4, word, jmdict('1428960')).  % ちょう intestine, bowel
pick(w_kanzou,             ja, n4, word, jmdict_kanji('肝臓')).
pick(w_hone,               ja, n4, word, jmdict('1288550')).  % ほね bone
pick(w_kinniku,            ja, n4, word, jmdict('1241810')).  % きんにく muscle
pick(w_hifu,               ja, n4, word, jmdict_kanji('皮膚')).
pick(w_kamigata,           ja, n4, word, jmdict_kanji('髪型')).
pick(w_mayu,               ja, n4, word, jmdict_kanji('眉')).
pick(w_matsuge,            ja, n4, word, jmdict_kanji('睫毛')).
pick(w_mabuta,             ja, n4, word, jmdict('1569920')).  % まぶた eyelid
pick(w_kuchibiru,          ja, n4, word, jmdict_kanji('唇')).
pick(w_nodo,               ja, n4, word, jmdict('1600280')).  % のど throat
pick(w_koshi,              ja, n4, word, jmdict('1288340')).  % こし lower back, waist, hips
pick(w_hiza,               ja, n4, word, jmdict_kanji('膝')).
pick(w_hiji,               ja, n4, word, jmdict_kanji('肘')).
pick(w_tekubi,             ja, n4, word, jmdict_kanji('手首')).
pick(w_yubisaki,           ja, n4, word, jmdict_kanji('指先')).
pick(w_tsume,              ja, n4, word, jmdict_kanji('爪')).
pick(w_kakato,             ja, n4, word, jmdict_kanji('踵')).
pick(w_shinchou,           ja, n4, word, jmdict_kanji('身長')).
pick(w_taijuu,             ja, n4, word, jmdict_kanji('体重')).
pick(w_shokuyoku,          ja, n4, word, jmdict_kanji('食欲')).
pick(w_eiyou,              ja, n4, word, jmdict_kanji('栄養')).
pick(w_shokuhin,           ja, n4, word, jmdict_kanji('食品')).
pick(w_zairyou,            ja, n4, word, jmdict_kanji('材料')).
pick(w_choumiryou,         ja, n4, word, jmdict_kanji('調味料')).
pick(w_su,                 ja, n4, word, jmdict_kanji('酢')).
pick(w_abura,              ja, n4, word, jmdict_kanji('油')).
pick(w_koshou,             ja, n4, word, jmdict_kanji('胡椒')).
pick(w_komugi,             ja, n4, word, jmdict_kanji('小麦')).
pick(w_komugiko,           ja, n4, word, jmdict_kanji('小麦粉')).
pick(w_tamagoyaki,         ja, n4, word, jmdict_kanji('卵焼き')).
pick(w_ebi,                ja, n4, word, jmdict_kanji('海老')).
pick(w_kani,               ja, n4, word, jmdict_kanji('蟹')).
pick(w_wakame,             ja, n4, word, jmdict_kanji('若布')).
pick(w_hourensou,          ja, n4, word, jmdict_kanji('ほうれん草')).
pick(w_nasu,               ja, n4, word, jmdict_kanji('茄子')).
pick(w_piiman,             ja, n4, word, jmdict_kana('ピーマン')).
pick(w_kinoko,             ja, n4, word, jmdict_kanji('茸')).
pick(w_orenji,             ja, n4, word, jmdict_kana('オレンジ')).
pick(w_remon,              ja, n4, word, jmdict_kana('レモン')).
pick(w_dezaato,            ja, n4, word, jmdict('1082850')).  % デザート dessert
pick(w_senbei,             ja, n4, word, jmdict_kanji('煎餅')).
pick(w_wagashi,            ja, n4, word, jmdict_kanji('和菓子')).
pick(w_menyuu,             ja, n4, word, jmdict_kana('メニュー')).
pick(w_teishoku,           ja, n4, word, jmdict_kanji('定食')).
pick(w_donburi,            ja, n4, word, jmdict_kanji('丼')).
pick(w_supageti,           ja, n4, word, jmdict_kana('スパゲッティ')).
pick(w_ryokucha,           ja, n4, word, jmdict_kanji('緑茶')).
pick(w_namabiiru,          ja, n4, word, jmdict_kanji('生ビール')).
pick(w_wain,               ja, n4, word, jmdict_kana('ワイン')).
pick(w_nihonshu,           ja, n4, word, jmdict_kanji('日本酒')).

% --- What cannot be pointed at -------------------------------------------------
pick(w_kibun,              ja, n4, word, jmdict_kanji('気分')).
pick(w_kanjou,             ja, n4, word, jmdict_kanji('感情')).
pick(w_kangae,             ja, n4, word, jmdict_kanji('考え')).
pick(w_kangaekata,         ja, n4, word, jmdict_kanji('考え方')).
pick(w_kibou,              ja, n4, word, jmdict_kanji('希望')).
pick(w_mokuhyou,           ja, n4, word, jmdict('1535650')).  % もくひょう goal, target, aim
pick(w_yoshuu,             ja, n4, word, jmdict_kanji('予習')).
pick(w_doryoku,            ja, n4, word, jmdict_kanji('努力')).
pick(w_jishin_confidence,  ja, n4, word, jmdict_kanji('自信')).
pick(w_yuuki,              ja, n4, word, jmdict_kanji('勇気')).
pick(w_shinrai,            ja, n4, word, jmdict_kanji('信頼')).
pick(w_himitsu,            ja, n4, word, jmdict_kanji('秘密')).
pick(w_jijitsu,            ja, n4, word, jmdict_kanji('事実')).
pick(w_shinjitsu,          ja, n4, word, jmdict_kanji('真実')).
pick(w_gokai,              ja, n4, word, jmdict_kanji('誤解')).
pick(w_machigai,           ja, n4, word, jmdict_kanji('間違い')).
pick(w_shippai,            ja, n4, word, jmdict_kanji('失敗')).
pick(w_seikou,             ja, n4, word, jmdict_kanji('成功')).
pick(w_kouun,              ja, n4, word, jmdict_kanji('幸運')).
pick(w_fukou,              ja, n4, word, jmdict_kanji('不幸')).
pick(w_koufuku,            ja, n4, word, jmdict_kanji('幸福')).
pick(w_shiawase,           ja, n4, word, jmdict_kanji('幸せ')).
pick(w_anshin,             ja, n4, word, jmdict('1153890')).  % あんしん peace of mind, relief, (sense of) 
pick(w_fuan,               ja, n4, word, jmdict_kanji('不安')).
pick(w_osore,              ja, n4, word, jmdict_kanji('恐れ')).
pick(w_kanashimi,          ja, n4, word, jmdict_kanji('悲しみ')).
pick(w_ikari,              ja, n4, word, jmdict_kanji('怒り')).
pick(w_odoroki,            ja, n4, word, jmdict_kanji('驚き')).
pick(w_kanshin,            ja, n4, word, jmdict_kanji('関心')).
pick(w_kangeki,            ja, n4, word, jmdict_kanji('感激')).
pick(w_omoide,             ja, n4, word, jmdict_kanji('思い出')).
pick(w_kinenbi,            ja, n4, word, jmdict_kanji('記念日')).
pick(w_tanoshimi,          ja, n4, word, jmdict_kanji('楽しみ')).
pick(w_asobi,              ja, n4, word, jmdict('1542070')).  % あそび play, playing, game
pick(w_yoka,               ja, n4, word, jmdict_kanji('余暇')).
pick(w_kyuusoku,           ja, n4, word, jmdict_kanji('休息')).
pick(w_hirou_fatigue,      ja, n4, word, jmdict_kanji('疲労')).
pick(w_chikara,            ja, n4, word, jmdict('1554820')).  % ちから force, strength, might
pick(w_nouryoku,           ja, n4, word, jmdict('1470370')).  % のうりょく ability, faculty
pick(w_sainou,             ja, n4, word, jmdict_kanji('才能')).
pick(w_seichou,            ja, n4, word, jmdict_kanji('成長')).
pick(w_hattatsu,           ja, n4, word, jmdict_kanji('発達')).
pick(w_henka,              ja, n4, word, jmdict('1510890')).  % へんか change, variation, alteration
pick(w_shinpo,             ja, n4, word, jmdict_kanji('進歩')).
pick(w_hatten,             ja, n4, word, jmdict_kanji('発展')).
pick(w_kaizen,             ja, n4, word, jmdict_kanji('改善')).
pick(w_eikyou,             ja, n4, word, jmdict_kanji('影響')).
pick(w_kankyou,            ja, n4, word, jmdict_kanji('環境')).
pick(w_shizen,             ja, n4, word, jmdict('1318090')).  % しぜん nature
pick(w_chikyuu,            ja, n4, word, jmdict_kanji('地球')).
pick(w_uchuu,              ja, n4, word, jmdict_kanji('宇宙')).
pick(w_kage,               ja, n4, word, jmdict_kanji('影')).
pick(w_souon,              ja, n4, word, jmdict_kanji('騒音')).
pick(w_nioi,               ja, n4, word, jmdict_kanji('匂い')).
pick(w_aji,                ja, n4, word, jmdict('1526960')).  % あじ flavor, flavour, taste
pick(w_kanshoku,           ja, n4, word, jmdict_kanji('感触')).
pick(w_katachi,            ja, n4, word, jmdict('1250220')).  % かたち (physical) form, shape, figure
pick(w_moyou,              ja, n4, word, jmdict_kanji('模様')).
pick(w_shurui,             ja, n4, word, jmdict_kanji('種類')).
pick(w_bubun,              ja, n4, word, jmdict_kanji('部分')).
pick(w_zentai,             ja, n4, word, jmdict_kanji('全体')).
pick(w_ryou,               ja, n4, word, jmdict('1554640')).  % りょう quantity, amount, volume
pick(w_kazu,               ja, n4, word, jmdict('1580820')).  % かず number, amount
pick(w_wariai,             ja, n4, word, jmdict_kanji('割合')).
pick(w_bai,                ja, n4, word, jmdict_kanji('倍')).
pick(w_ijou,               ja, n4, word, jmdict_kanji('以上')).
pick(w_ika,                ja, n4, word, jmdict_kanji('以下')).
pick(w_izen,               ja, n4, word, jmdict_kanji('以前')).
pick(w_igo,                ja, n4, word, jmdict_kanji('以後')).
pick(w_shourai,            ja, n4, word, jmdict_kanji('将来')).
pick(w_kako,               ja, n4, word, jmdict_kanji('過去')).
pick(w_genzai,             ja, n4, word, jmdict_kanji('現在')).
pick(w_mirai,              ja, n4, word, jmdict_kanji('未来')).
pick(w_jidai,              ja, n4, word, jmdict_kanji('時代')).
pick(w_sedai,              ja, n4, word, jmdict_kanji('世代')).
pick(w_junban,             ja, n4, word, jmdict_kanji('順番')).
pick(w_katahou,            ja, n4, word, jmdict_kanji('片方')).
pick(w_mawari,             ja, n4, word, jmdict_kanji('周り')).
pick(w_tooku,              ja, n4, word, jmdict_kanji('遠く')).
pick(w_hantaigawa,         ja, n4, word, jmdict_kanji('反対側')).
pick(w_hidarigawa,         ja, n4, word, jmdict_kanji('左側')).
pick(w_migigawa,           ja, n4, word, jmdict_kanji('右側')).
pick(w_ryougawa,           ja, n4, word, jmdict_kanji('両側')).
pick(w_mannaka,            ja, n4, word, jmdict_kanji('真ん中')).
pick(w_chuushin,           ja, n4, word, jmdict('1424550')).  % ちゅうしん center, centre, middle
pick(w_chuuou,             ja, n4, word, jmdict_kanji('中央')).
pick(w_ura,                ja, n4, word, jmdict('1550190')).  % うら opposite side, bottom, other side

% --- The small words that carry the argument -----------------------------------
pick(w_zettai,             ja, n4, word, jmdict_kanji('絶対')).
pick(w_osoraku,            ja, n4, word, jmdict_kanji('恐らく')).
pick(w_mochiron,           ja, n4, word, jmdict_kanji('勿論')).
pick(w_hontouni,           ja, n4, word, jmdict_kanji('本当に')).
pick(w_jitsuha,            ja, n4, word, jmdict_kanji('実は')).
pick(w_tashikani,          ja, n4, word, jmdict_kanji('確かに')).
pick(w_tatoeba,            ja, n4, word, jmdict_kanji('例えば')).
pick(w_tsumari,            ja, n4, word, jmdict_kanji('詰まり')).
pick(w_yousuruni,          ja, n4, word, jmdict_kanji('要するに')).
pick(w_sate,               ja, n4, word, jmdict_kana('さて')).
pick(w_tokorode,           ja, n4, word, jmdict_kana('ところで')).
pick(w_shikashi,           ja, n4, word, jmdict_kanji('然し')).  % kana: every kanji spelling of it is tagged rare
pick(w_keredo,             ja, n4, word, jmdict_kana('けれども')).
pick(w_sorede,             ja, n4, word, jmdict_kana('それで')).
pick(w_dakara,             ja, n4, word, jmdict_kana('だから')).
pick(w_nazenara,           ja, n4, word, jmdict_kanji('何故なら')).
pick(w_soshite,            ja, n4, word, jmdict_kana('そして')).
pick(w_sorekara,           ja, n4, word, jmdict_kana('それから')).
pick(w_mazu,               ja, n4, word, jmdict_kanji('先ず')).
pick(w_tsuideni,           ja, n4, word, jmdict_kanji('序でに')).  % kana: every kanji spelling of it is tagged rare
pick(w_shikamo,            ja, n4, word, jmdict_kana('しかも')).
pick(w_sorenara,           ja, n4, word, jmdict_kana('それなら')).
pick(w_mataha,             ja, n4, word, jmdict_kanji('又は')).
pick(w_soretomo,           ja, n4, word, jmdict_kana('それとも')).
pick(w_tsuini,             ja, n4, word, jmdict_kanji('遂に')).
pick(w_yatto,              ja, n4, word, jmdict_kana('やっと')).
pick(w_mousukoshi,         ja, n4, word, jmdict_kanji('もう少し')).
pick(w_zuibun,             ja, n4, word, jmdict_kanji('随分')).
pick(w_kanari,             ja, n4, word, jmdict_kanji('可成り')).  % kana: every kanji spelling of it is tagged rare
pick(w_nakanaka,           ja, n4, word, jmdict_kanji('中々')).
pick(w_sukunakutomo,       ja, n4, word, jmdict_kanji('少なくとも')).
pick(w_hotondo,            ja, n4, word, jmdict_kanji('殆ど')).
pick(w_mattaku,            ja, n4, word, jmdict_kanji('全く')).
pick(w_sonnani,            ja, n4, word, jmdict_kana('そんなに')).
pick(w_shoushou,           ja, n4, word, jmdict_kanji('少々')).
pick(w_sukoshizutsu,       ja, n4, word, jmdict_kanji('少しずつ')).
pick(w_dandan,             ja, n4, word, jmdict('1597350')).  % だんだん gradually, by degrees, little by l
pick(w_jojoni,             ja, n4, word, jmdict_kanji('徐々に')).
pick(w_kyuuni,             ja, n4, word, jmdict_kanji('急に')).
pick(w_totsuzen,           ja, n4, word, jmdict_kanji('突然')).
pick(w_ikinari,            ja, n4, word, jmdict_kana('いきなり')).
pick(w_suguni,             ja, n4, word, jmdict_kanji('直ぐに')).
pick(w_sassoku,            ja, n4, word, jmdict_kanji('早速')).
pick(w_yagate,             ja, n4, word, jmdict_kana('やがて')).
pick(w_mouichido,          ja, n4, word, jmdict_kanji('もう一度')).
pick(w_futatabi,           ja, n4, word, jmdict_kanji('再び')).
pick(w_tabitabi,           ja, n4, word, jmdict('1597160')).  % たびたび often, again and again, over and o
pick(w_tsuneni,            ja, n4, word, jmdict_kanji('常に')).
pick(w_zutto,              ja, n4, word, jmdict_kana('ずっと')).
pick(w_imasara,            ja, n4, word, jmdict_kanji('今更')).
pick(w_ichiou,             ja, n4, word, jmdict_kanji('一応')).
pick(w_toriaezu,           ja, n4, word, jmdict_kanji('取り敢えず')).
pick(w_tonikaku,           ja, n4, word, jmdict_kana('とにかく')).
pick(w_yahari,             ja, n4, word, jmdict_kanji('矢張り')).  % kana: every kanji spelling of it is tagged rare
pick(w_douyara,            ja, n4, word, jmdict_kana('どうやら')).
pick(w_doushitemo,         ja, n4, word, jmdict_kana('どうしても')).
pick(w_nantoka,            ja, n4, word, jmdict_kanji('何とか')).
pick(w_nandaka,            ja, n4, word, jmdict_kanji('何だか')).
pick(w_naruhodo,           ja, n4, word, jmdict_kanji('成る程')).
pick(w_sasuga,             ja, n4, word, jmdict_kanji('流石')).
pick(w_shikkari,           ja, n4, word, jmdict_kana('しっかり')).
pick(w_chanto,             ja, n4, word, jmdict_kana('ちゃんと')).
pick(w_kichinto,           ja, n4, word, jmdict_kana('きちんと')).
pick(w_wazawaza,           ja, n4, word, jmdict_kanji('態々')).  % kana: every kanji spelling of it is tagged rare
pick(w_wazato,             ja, n4, word, jmdict_kanji('態と')).  % kana: every kanji spelling of it is tagged rare
pick(w_ukkari,             ja, n4, word, jmdict_kana('うっかり')).
pick(w_omowazu,            ja, n4, word, jmdict_kanji('思わず')).
pick(w_tatoe,              ja, n4, word, jmdict_kanji('例え')).
pick(w_moshimo,            ja, n4, word, jmdict_kanji('若しも')).  % kana: every kanji spelling of it is tagged rare
pick(w_manichi,            ja, n4, word, jmdict_kanji('万一')).
pick(w_hyottoshite,        ja, n4, word, jmdict_kana('ひょっとして')).
pick(w_douka,              ja, n4, word, jmdict('1632200')).  %  
pick(w_zehi,               ja, n4, word, jmdict_kanji('是非')).
pick(w_dekirudake,         ja, n4, word, jmdict_kanji('出来るだけ')).
pick(w_seizei,             ja, n4, word, jmdict_kanji('精々')).
pick(w_tagaini,            ja, n4, word, jmdict_kanji('互いに')).
pick(w_betsubetsu,         ja, n4, word, jmdict_kanji('別々')).
pick(w_jibunde,            ja, n4, word, jmdict_kanji('自分で')).
pick(w_hitoride,           ja, n4, word, jmdict_kanji('独りで')).
pick(w_junbanni,           ja, n4, word, jmdict_kanji('順番に')).
pick(w_tsugitsugi,         ja, n4, word, jmdict_kanji('次々')).
pick(w_ichiichi,           ja, n4, word, jmdict_kanji('一々')).
pick(w_subete,             ja, n4, word, jmdict_kanji('全て')).
pick(w_sorezore,           ja, n4, word, jmdict_kanji('夫々')).  % kana: every kanji spelling of it is tagged rare
pick(w_sonohoka,           ja, n4, word, jmdict_kanji('その他')).
pick(w_igai,               ja, n4, word, jmdict_kanji('以外')).
pick(w_tokuni,             ja, n4, word, jmdict_kanji('特に')).
pick(w_omoni,              ja, n4, word, jmdict_kanji('主に')).
pick(w_jissai,             ja, n4, word, jmdict_kanji('実際')).
pick(w_ippanni,            ja, n4, word, jmdict_kanji('一般に')).
pick(w_toujitsu,           ja, n4, word, jmdict_kanji('当日')).
pick(w_tousho,             ja, n4, word, jmdict_kanji('当初')).
pick(w_saishuu,            ja, n4, word, jmdict_kanji('最終')).
pick(w_saikou,             ja, n4, word, jmdict_kanji('最高')).
pick(w_saitei,             ja, n4, word, jmdict_kanji('最低')).

% --- The country, the weather, and the page ------------------------------------
pick(w_seifu,              ja, n4, word, jmdict_kanji('政府')).
pick(w_shushou,            ja, n4, word, jmdict_kanji('首相')).
pick(w_senkyo,             ja, n4, word, jmdict_kanji('選挙')).
pick(w_housou,             ja, n4, word, jmdict_kanji('放送')).
pick(w_koukoku,            ja, n4, word, jmdict_kanji('広告')).
pick(w_ehon,               ja, n4, word, jmdict_kanji('絵本')).
pick(w_hyougen,            ja, n4, word, jmdict_kanji('表現')).
pick(w_happyou,            ja, n4, word, jmdict_kanji('発表')).
pick(w_kansou,             ja, n4, word, jmdict_kanji('感想')).
pick(w_inshou,             ja, n4, word, jmdict_kanji('印象')).
pick(w_hyouka,             ja, n4, word, jmdict_kanji('評価')).
pick(w_hikaku,             ja, n4, word, jmdict_kanji('比較')).
pick(w_jouken,             ja, n4, word, jmdict_kanji('条件')).
pick(w_joutai,             ja, n4, word, jmdict_kanji('状態')).
pick(w_joukyou,            ja, n4, word, jmdict_kanji('状況')).
pick(w_yousu,              ja, n4, word, jmdict_kanji('様子')).
pick(w_tsugou,             ja, n4, word, jmdict_kanji('都合')).
pick(w_chihou,             ja, n4, word, jmdict('1421450')).  % ちほう district, region, area
pick(w_hayashi,            ja, n4, word, jmdict_kanji('林')).
pick(w_hatake,             ja, n4, word, jmdict_kanji('畑')).
pick(w_bokujou,            ja, n4, word, jmdict_kanji('牧場')).
pick(w_michijun,           ja, n4, word, jmdict_kanji('道順')).
pick(w_kousa,              ja, n4, word, jmdict_kanji('交差')).
pick(w_mokuzai,            ja, n4, word, jmdict_kanji('木材')).
pick(w_kinzoku,            ja, n4, word, jmdict_kanji('金属')).
pick(w_doukutsu,           ja, n4, word, jmdict_kanji('洞窟')).
pick(w_sabaku,             ja, n4, word, jmdict_kanji('砂漠')).
pick(w_kaigan,             ja, n4, word, jmdict_kanji('海岸')).
pick(w_hamabe,             ja, n4, word, jmdict_kanji('浜辺')).
pick(w_nami,               ja, n4, word, jmdict('1470970')).  % なみ wave, billow, ripple
pick(w_sunahama,           ja, n4, word, jmdict_kanji('砂浜')).
pick(w_niji,               ja, n4, word, jmdict('1463740')).  % にじ rainbow
pick(w_hoshizora,          ja, n4, word, jmdict_kanji('星空')).
pick(w_mangetsu,           ja, n4, word, jmdict_kanji('満月')).
pick(w_hoo,                ja, n4, word, jmdict('1584160')).  % ほお cheek (of the face)
pick(w_hoomu,              ja, n4, word, jmdict('1121740')).  % ホーム platform
pick(w_hyoumen,            ja, n4, word, jmdict('1489880')).  % ひょうめん surface, face
pick(w_jiten,              ja, n4, word, jmdict('1595270')).  % じてん dictionary, lexicon
pick(w_sonoue,             ja, n4, word, jmdict('1006880')).  % そのうえ in addition, furthermore
pick(w_sudeni,             ja, n4, word, jmdict('1220310')).  % すでに already
pick(w_suicchi,            ja, n4, word, jmdict('1067210')).  % スイッチ switch
