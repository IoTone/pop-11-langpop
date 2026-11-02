% graph/ja/picks/n3.pl -- which words are N3, and who they are.
%
% The same arrangement as graph/ja/picks/n5.pl, and that file's header is
% the one to read first: a pick is an identity, a level and a lookup key,
% import.p fetches the forms and the glosses from JMdict at build time,
% and no Japanese that upstream wrote is committed here.
%
% WHY THIS RUNG NEEDED A RULE OF ITS OWN.  N5 and N4 are small enough to
% pick a word at a time.  N3 asks for 3750 cumulative, which is 2236 more
% than the graph had, and nobody reads four thousand dictionary entries
% without a principle.  The principle is in docs/langpop-n3-vocabulary.md
% and it is one sentence: a bridge-level word is one that BOTH corpora
% use.  JMdict's own priority marks say a word is common; the dialogue
% frequency list says people say it; a word needs the first to enter the
% pool at all and the second to be ranked in it.
%
% WHAT THAT RULED OUT, AND WHY IT MATTERED.  Ordering by the newspaper
% marks alone -- JMdict's nf bands, which come from the Mainichi corpus
% -- put 外相, 安保, 議席, 地検 and 連立 in the first three hundred
% words of the rung.  That is Diet reporting, not the bridge level, and
% a learner who meets 議員 before 友人 is being taught somebody else's
% vocabulary.  Ranking by dialogue instead puts 友人, 父親, 母親, 理解,
% 人生 and 夕食 where they belong.  The newspaper marks still do real
% work -- they are the gate -- but they are no longer the order.
%
% WHAT WAS MECHANICAL AND WHAT WAS JUDGMENT.  Five filters are rules and
% ran without me: the headword must be written in kanji the graph
% teaches at or below N3 (650 characters, so a reading question at this
% rung is answerable at this rung); the word must not already be in the
% graph under any form or id; JMdict must mark it common; the headword
% must not be a verb or adjective STEM, which the pool is full of
% because the segmenter counted every 出来る as 出来 and every 面白い as
% 面白 -- a stem is not a word to teach, the verb is, and its frequency
% is the verb's, borrowed; and the spelling must be one upstream
% recommends, which means NOT tagged ateji, rarely used, out-dated,
% irregular or search-only.
%
% That last filter is import.p's rule as much as this file's, and the
% two have to agree.  The importer refuses to teach a tagged spelling,
% so a pick whose only kanji spelling is tagged arrives as a word
% written in kana with no reading question at all.  Four did -- 味方,
% 無茶, 心地 and 日和, phonetic borrowings every one by JMdict's
% reckoning -- because this file's filter was written against the short
% tag codes and read the expanded text, and so matched nothing.  The
% test suite now asserts what it was supposed to guarantee: every N3
% word has a kanji form and a reading.
%
% Then 2800 survivors were read by hand, in rank order, and
% 336 of them thrown out.  The reasons, in the order they cost the
% most rows:
%
%     242  register   the word is real but belongs to a trade: legal
%                     offices, military organisation, clinical medicine,
%                     parliamentary procedure, corporate titles.  A
%                     subtitle corpus of police and hospital drama is
%                     generous with 令状 and 皮質.
%      30  stem       a nominalised verb the mechanical rule missed,
%                     because its okurigana is not a verb ending: 教え,
%                     始まり, 動き, 読み.
%      23  proper     a country, city, island or organisation.  A name
%                     is not vocabulary; JMnedict is where names live.
%      15  homophone  two readings of one headword, where the graph
%                     should teach one of them: 生物 as せいぶつ and not
%                     なまもの, 寒気 as さむけ and not かんき.
%      11  rare       a reading or sense upstream marks common that a
%                     learner will not meet: 客人 as きゃくじん.
%       7  fragment   half of a longer word: 百聞, 商工, 不老, 先住.
%       3  alt-read   the formal reading of a word the graph already
%                     teaches: 今日 is きょう here, not こんにち.
%
% The rejections are kept, with their reasons, in n3-rejects.tsv beside
% this file -- a rejection is a judgment, and a judgment nobody
% can see is a judgment nobody can argue with.
%
% THE COUNT.  2464 picks here.  With n5.pl's 773, n4.pl's 749 and the
% fifty at pre-school that is the 3750 the ladder asks for, plus a
% margin, because a pick can fail to be ASKABLE and the audit counts
% questions rather than rows.
%
% The margin is also the place a bug hides.  The four ateji picks above
% showed up as exactly four unaskable rows, which is small enough to
% write off as what a margin is for -- and that is what happened for a
% day.  A margin explains a gap it did not cause; a gap it did cause is
% four picks that should not be there.
%
% WHAT THIS IS NOT.  Not a published list.  JLPT has published no word
% list since 2010 and JMdict carries no level marking, so
% provenance(exit(ja, _, vocabulary(_, _), _, _), estimate(community))
% in the ladder says what this is: a teaching claim, made by a person,
% from two corpora that were counting something else.  The boundary is
% not meaningful at any one word -- the word at rank 2800 is not harder
% than the word at rank 2801, it is just rarer in the data.
%
pick(w_ningen,          ja, n3, word, jmdict('1366770')).  % にんげん human being; human; person
pick(w_jinsei,          ja, n3, word, jmdict_kanji('人生')).
pick(w_josei,           ja, n3, word, jmdict_kanji('女性')).
pick(w_jiken,           ja, n3, word, jmdict_kanji('事件')).
pick(w_kanou,           ja, n3, word, jmdict_kanji('可能')).
pick(w_zenin,           ja, n3, word, jmdict_kanji('全員')).
pick(w_rikai,           ja, n3, word, jmdict_kanji('理解')).
pick(w_yuujin,          ja, n3, word, jmdict_kanji('友人')).
pick(w_chichioya,       ja, n3, word, jmdict_kanji('父親')).
pick(w_ooku,            ja, n3, word, jmdict_kanji('多く')).
pick(w_meirei,          ja, n3, word, jmdict_kanji('命令')).
pick(w_hahaoya,         ja, n3, word, jmdict_kanji('母親')).
pick(w_kiroku,          ja, n3, word, jmdict_kanji('記録')).
pick(w_koudou,          ja, n3, word, jmdict_kanji('行動')).
pick(w_ookina,          ja, n3, word, jmdict_kanji('大きな')).
pick(w_chousa,          ja, n3, word, jmdict_kanji('調査')).
pick(w_hakken,          ja, n3, word, jmdict_kanji('発見')).
pick(w_hikou,           ja, n3, word, jmdict('1485450')).  % ひこう flight; flying; aviation
pick(w_shitai,          ja, n3, word, jmdict_kanji('死体')).
pick(w_fumei,           ja, n3, word, jmdict_kanji('不明')).
pick(w_shinyou,         ja, n3, word, jmdict_kanji('信用')).
pick(w_torihiki,        ja, n3, word, jmdict_kanji('取引')).
pick(w_genba,           ja, n3, word, jmdict_kanji('現場')).
pick(w_renchuu,         ja, n3, word, jmdict_kanji('連中')).
pick(w_kanzen,          ja, n3, word, jmdict_kanji('完全')).
pick(w_mottomo,         ja, n3, word, jmdict_kanji('最も')).
pick(w_jinbutsu,        ja, n3, word, jmdict_kanji('人物')).
pick(w_kesshite,        ja, n3, word, jmdict_kanji('決して')).
pick(w_konkai,          ja, n3, word, jmdict_kanji('今回')).
pick(w_honmono,         ja, n3, word, jmdict_kanji('本物')).
pick(w_nenkan,          ja, n3, word, jmdict_kanji('年間')).
pick(w_honki,           ja, n3, word, jmdict_kanji('本気')).
pick(w_ninmu,           ja, n3, word, jmdict_kanji('任務')).
pick(w_sakusen,         ja, n3, word, jmdict_kanji('作戦')).
pick(w_chiisana,        ja, n3, word, jmdict_kanji('小さな')).
pick(w_tatakai,         ja, n3, word, jmdict_kanji('戦い')).
pick(w_genjitsu,        ja, n3, word, jmdict_kanji('現実')).
pick(w_choushi,         ja, n3, word, jmdict_kanji('調子')).
pick(w_touzen,          ja, n3, word, jmdict_kanji('当然')).
pick(w_kensa,           ja, n3, word, jmdict_kanji('検査')).
pick(w_kawari,          ja, n3, word, jmdict('1590770')).  % かわり substitute; replacement; substituting
pick(w_unmei,           ja, n3, word, jmdict_kanji('運命')).
pick(w_ichibu,          ja, n3, word, jmdict_kanji('一部')).
pick(w_yuushoku,        ja, n3, word, jmdict('1542730')).  % ゆうしょく evening meal; dinner
pick(w_shihai,          ja, n3, word, jmdict_kanji('支配')).
pick(w_yukue,           ja, n3, word, jmdict('1282180')).  % ゆくえ (one's) whereabouts; destination; where one is h
pick(w_jinrui,          ja, n3, word, jmdict_kanji('人類')).
pick(w_youkyuu,         ja, n3, word, jmdict_kanji('要求')).
pick(w_shiji,           ja, n3, word, jmdict_kanji('指示')).
pick(w_nanimono,        ja, n3, word, jmdict_kanji('何者')).
pick(w_kanri,           ja, n3, word, jmdict_kanji('管理')).
pick(w_katte,           ja, n3, word, jmdict_kanji('勝手')).
pick(w_hannou,          ja, n3, word, jmdict_kanji('反応')).
pick(w_joou,            ja, n3, word, jmdict_kanji('女王')).
pick(w_daisuki,         ja, n3, word, jmdict_kanji('大好き')).
pick(w_kekkyoku,        ja, n3, word, jmdict_kanji('結局')).
pick(w_shirei,          ja, n3, word, jmdict_kanji('司令')).
pick(w_kaihou,          ja, n3, word, jmdict_kanji('解放')).
pick(w_jimu,            ja, n3, word, jmdict_kanji('事務')).
pick(w_irai,            ja, n3, word, jmdict_kanji('以来')).
pick(w_tsuushin,        ja, n3, word, jmdict_kanji('通信')).
pick(w_shuuchuu,        ja, n3, word, jmdict_kanji('集中')).
pick(w_zenkai,          ja, n3, word, jmdict_kanji('前回')).
pick(w_tenshi,          ja, n3, word, jmdict_kanji('天使')).
pick(w_shouri,          ja, n3, word, jmdict_kanji('勝利')).
pick(w_kakushin,        ja, n3, word, jmdict_kanji('確信')).
pick(w_jikken,          ja, n3, word, jmdict_kanji('実験')).
pick(w_jikkou,          ja, n3, word, jmdict_kanji('実行')).
pick(w_shidai,          ja, n3, word, jmdict_kanji('次第')).
pick(w_inai,            ja, n3, word, jmdict_kanji('以内')).
pick(w_ouji,            ja, n3, word, jmdict_kanji('王子')).
pick(w_doui,            ja, n3, word, jmdict_kanji('同意')).
pick(w_isshou,          ja, n3, word, jmdict_kanji('一生')).
pick(w_houkou,          ja, n3, word, jmdict_kanji('方向')).
pick(w_shinkei,         ja, n3, word, jmdict_kanji('神経')).
pick(w_shinyuu,         ja, n3, word, jmdict_kanji('親友')).
pick(w_fushigi,         ja, n3, word, jmdict_kanji('不思議')).
pick(w_monogatari,      ja, n3, word, jmdict_kanji('物語')).
pick(w_tanin,           ja, n3, word, jmdict_kanji('他人')).
pick(w_saidai,          ja, n3, word, jmdict_kanji('最大')).
pick(w_kiji,            ja, n3, word, jmdict_kanji('記事')).
pick(w_guai,            ja, n3, word, jmdict_kanji('具合')).
pick(w_shoyuu,          ja, n3, word, jmdict_kanji('所有')).
pick(w_outou,           ja, n3, word, jmdict_kanji('応答')).
pick(w_shikin,          ja, n3, word, jmdict_kanji('資金')).
pick(w_antei,           ja, n3, word, jmdict_kanji('安定')).
pick(w_kanemochi,       ja, n3, word, jmdict_kanji('金持ち')).
pick(w_kakuho,          ja, n3, word, jmdict_kanji('確保')).
pick(w_shoutai,         ja, n3, word, jmdict_kanji('正体')).
pick(w_hassei,          ja, n3, word, jmdict_kanji('発生')).
pick(w_tachiba,         ja, n3, word, jmdict('1551710')).  % たちば position; situation; viewpoint
pick(w_kakujitsu,       ja, n3, word, jmdict_kanji('確実')).
pick(w_tochi,           ja, n3, word, jmdict_kanji('土地')).
pick(w_tegakari,        ja, n3, word, jmdict_kanji('手がかり')).
pick(w_kagen,           ja, n3, word, jmdict_kanji('加減')).
pick(w_douyou,          ja, n3, word, jmdict_kanji('同様')).
pick(w_shintai,         ja, n3, word, jmdict('2830705')).  % しんたい body; physical system; (the) person
pick(w_musen,           ja, n3, word, jmdict_kanji('無線')).
pick(w_kidou,           ja, n3, word, jmdict_kanji('起動')).
pick(w_settoku,         ja, n3, word, jmdict_kanji('説得')).
pick(w_tokutei,         ja, n3, word, jmdict_kanji('特定')).
pick(w_hyouteki,        ja, n3, word, jmdict_kanji('標的')).
pick(w_kouei,           ja, n3, word, jmdict_kanji('光栄')).
pick(w_honbu,           ja, n3, word, jmdict_kanji('本部')).
pick(w_dainashi,        ja, n3, word, jmdict_kanji('台無し')).
pick(w_shusshin,        ja, n3, word, jmdict_kanji('出身')).
pick(w_taishita,        ja, n3, word, jmdict_kanji('大した')).
pick(w_yosou,           ja, n3, word, jmdict_kanji('予想')).
pick(w_seimei,          ja, n3, word, jmdict_kanji('生命')).
pick(w_sagyou,          ja, n3, word, jmdict_kanji('作業')).
pick(w_tehai,           ja, n3, word, jmdict_kanji('手配')).
pick(w_kinko,           ja, n3, word, jmdict('1242850')).  % きんこ safe; strongbox; cashbox
pick(w_naibu,           ja, n3, word, jmdict_kanji('内部')).
pick(w_shokuryou,       ja, n3, word, jmdict_kanji('食料')).
pick(w_tokui,           ja, n3, word, jmdict_kanji('得意')).
pick(w_shiwaza,         ja, n3, word, jmdict_kanji('仕業')).
pick(w_taiki,           ja, n3, word, jmdict_kanji('待機')).
pick(w_kaihatsu,        ja, n3, word, jmdict_kanji('開発')).
pick(w_jijou,           ja, n3, word, jmdict_kanji('事情')).
pick(w_kokka,           ja, n3, word, jmdict_kanji('国家')).
pick(w_taishi,          ja, n3, word, jmdict_kanji('大使')).
pick(w_kikan,           ja, n3, word, jmdict('1220870')).  % きかん engine; agency; organisation
pick(w_seibutsu,        ja, n3, word, jmdict('1379430')).  % せいぶつ living thing; organism; creature
pick(w_tensai,          ja, n3, word, jmdict_kanji('天才')).
pick(w_hitojichi,       ja, n3, word, jmdict_kanji('人質')).
pick(w_shouki,          ja, n3, word, jmdict('1580850')).  % しょうき sanity; consciousness; soberness
pick(w_chuushi,         ja, n3, word, jmdict_kanji('中止')).
pick(w_genkin,          ja, n3, word, jmdict_kanji('現金')).
pick(w_shimatsu,        ja, n3, word, jmdict_kanji('始末')).
pick(w_kanren,          ja, n3, word, jmdict_kanji('関連')).
pick(w_oukoku,          ja, n3, word, jmdict_kanji('王国')).
pick(w_shinpu,          ja, n3, word, jmdict_kanji('神父')).
pick(w_jiki,            ja, n3, word, jmdict_kanji('時期')).
pick(w_busshitsu,       ja, n3, word, jmdict('1502560')).  % ぶっしつ material; substance; matter
pick(w_sekkei,          ja, n3, word, jmdict_kanji('設計')).
pick(w_dekigoto,        ja, n3, word, jmdict_kanji('出来事')).
pick(w_tairyou,         ja, n3, word, jmdict_kanji('大量')).
pick(w_tsuuhou,         ja, n3, word, jmdict_kanji('通報')).
pick(w_angou,           ja, n3, word, jmdict_kanji('暗号')).
pick(w_ningyou,         ja, n3, word, jmdict('1367120')).  % にんぎょう doll; puppet; marionette
pick(w_chakuriku,       ja, n3, word, jmdict_kanji('着陸')).
pick(w_jimoto,          ja, n3, word, jmdict_kanji('地元')).
pick(w_iin,             ja, n3, word, jmdict_kanji('委員')).
pick(w_kisha,           ja, n3, word, jmdict_kanji('記者')).
pick(w_kongo,           ja, n3, word, jmdict_kanji('今後')).
pick(w_densetsu,        ja, n3, word, jmdict_kanji('伝説')).
pick(w_mizukara,        ja, n3, word, jmdict('1317340')).  % みずから oneself; oneself; for oneself
pick(w_shisha,          ja, n3, word, jmdict_kanji('死者')).
pick(w_mimoto,          ja, n3, word, jmdict_kanji('身元')).
pick(w_douji,           ja, n3, word, jmdict_kanji('同時')).
pick(w_ketsudan,        ja, n3, word, jmdict_kanji('決断')).
pick(w_toushi,          ja, n3, word, jmdict_kanji('投資')).
pick(w_ippou,           ja, n3, word, jmdict('1166510')).  % いっぽう one (esp. of two); the other; one way
pick(w_hokan,           ja, n3, word, jmdict_kanji('保管')).
pick(w_junchou,         ja, n3, word, jmdict_kanji('順調')).
pick(w_dougu,           ja, n3, word, jmdict_kanji('道具')).
pick(w_choushoku,       ja, n3, word, jmdict('1428390')).  % ちょうしょく breakfast
pick(w_douki,           ja, n3, word, jmdict_kanji('動機')).
pick(w_shidou,          ja, n3, word, jmdict_kanji('指導')).
pick(w_tengoku,         ja, n3, word, jmdict_kanji('天国')).
pick(w_daihyou,         ja, n3, word, jmdict_kanji('代表')).
pick(w_chijou,          ja, n3, word, jmdict_kanji('地上')).
pick(w_tedasuke,        ja, n3, word, jmdict_kanji('手助け')).
pick(w_jidou,           ja, n3, word, jmdict_kanji('自動')).
pick(w_keiei,           ja, n3, word, jmdict_kanji('経営')).
pick(w_dengon,          ja, n3, word, jmdict('1582180')).  % でんごん (verbal) message; word (from someone)
pick(w_sakuhin,         ja, n3, word, jmdict_kanji('作品')).
pick(w_yonaka,          ja, n3, word, jmdict('1536930')).  % よなか middle of the night; dead of night
pick(w_fusoku,          ja, n3, word, jmdict_kanji('不足')).
pick(w_taiou,           ja, n3, word, jmdict_kanji('対応')).
pick(w_tetsudai,        ja, n3, word, jmdict_kanji('手伝い')).
pick(w_soushin,         ja, n3, word, jmdict_kanji('送信')).
pick(w_kokkyou,         ja, n3, word, jmdict_kanji('国境')).
pick(w_geijutsu,        ja, n3, word, jmdict_kanji('芸術')).
pick(w_shiryou,         ja, n3, word, jmdict_kanji('資料')).
pick(w_seitou,          ja, n3, word, jmdict_kanji('正当')).
pick(w_nendai,          ja, n3, word, jmdict_kanji('年代')).
pick(w_tannaru,         ja, n3, word, jmdict_kanji('単なる')).
pick(w_kankaku,         ja, n3, word, jmdict_kanji('感覚')).
pick(w_haichi,          ja, n3, word, jmdict_kanji('配置')).
pick(w_kokuhaku,        ja, n3, word, jmdict_kanji('告白')).
pick(w_kinyou,          ja, n3, word, jmdict_kanji('金曜')).
pick(w_noujou,          ja, n3, word, jmdict_kanji('農場')).
pick(w_chiku,           ja, n3, word, jmdict_kanji('地区')).
pick(w_katei,           ja, n3, word, jmdict_kanji('家庭')).
pick(w_shutoku,         ja, n3, word, jmdict('1327070')).  % しゅとく obtaining (a qualification, right, object, etc.)
pick(w_kansatsu,        ja, n3, word, jmdict_kanji('観察')).
pick(w_taikin,          ja, n3, word, jmdict_kanji('大金')).
pick(w_sokudo,          ja, n3, word, jmdict_kanji('速度')).
pick(w_suuji,           ja, n3, word, jmdict_kanji('数字')).
pick(w_nakami,          ja, n3, word, jmdict('1599430')).  % なかみ contents; interior; filling
pick(w_seken,           ja, n3, word, jmdict_kanji('世間')).
pick(w_funou,           ja, n3, word, jmdict_kanji('不能')).
pick(w_gaishutsu,       ja, n3, word, jmdict_kanji('外出')).
pick(w_ryoute,          ja, n3, word, jmdict('1553660')).  % りょうて both hands; both arms; ten
pick(w_kyouyuu,         ja, n3, word, jmdict_kanji('共有')).
pick(w_touroku,         ja, n3, word, jmdict_kanji('登録')).
pick(w_hossa,           ja, n3, word, jmdict_kanji('発作')).
pick(w_shuudan,         ja, n3, word, jmdict_kanji('集団')).
pick(w_nanbyaku,        ja, n3, word, jmdict_kanji('何百')).
pick(w_nanigoto,        ja, n3, word, jmdict_kanji('何事')).
pick(w_soutou,          ja, n3, word, jmdict_kanji('相当')).
pick(w_zenryoku,        ja, n3, word, jmdict_kanji('全力')).
pick(w_keisan,          ja, n3, word, jmdict_kanji('計算')).
pick(w_fuman,           ja, n3, word, jmdict_kanji('不満')).
pick(w_dairi,           ja, n3, word, jmdict_kanji('代理')).
pick(w_renzoku,         ja, n3, word, jmdict_kanji('連続')).
pick(w_hitokoto,        ja, n3, word, jmdict_kanji('一言')).
pick(w_saishin,         ja, n3, word, jmdict_kanji('最新')).
pick(w_ninki,           ja, n3, word, jmdict('1367010')).  % にんき popularity; public favor; condition (e.g. market
pick(w_tsuujou,         ja, n3, word, jmdict_kanji('通常')).
pick(w_joshu,           ja, n3, word, jmdict('1344650')).  % じょしゅ assistant; helper; assistant (to a professor)
pick(w_ichizoku,        ja, n3, word, jmdict_kanji('一族')).
pick(w_ayamachi,        ja, n3, word, jmdict_kanji('過ち')).
pick(w_minkan,          ja, n3, word, jmdict_kanji('民間')).
pick(w_shinkou,         ja, n3, word, jmdict_kanji('進行')).
pick(w_bijin,           ja, n3, word, jmdict_kanji('美人')).
pick(w_kyoutsuu,        ja, n3, word, jmdict_kanji('共通')).
pick(w_aizu,            ja, n3, word, jmdict_kanji('合図')).
pick(w_jigyou,          ja, n3, word, jmdict_kanji('事業')).
pick(w_touji,           ja, n3, word, jmdict_kanji('当時')).
pick(w_kyousei,         ja, n3, word, jmdict_kanji('強制')).
pick(w_kouhei,          ja, n3, word, jmdict('1274640')).  % こうへい fair; impartial; just
pick(w_koushiki,        ja, n3, word, jmdict_kanji('公式')).
pick(w_monogoto,        ja, n3, word, jmdict_kanji('物事')).
pick(w_tanni,           ja, n3, word, jmdict_kanji('単に')).
pick(w_jimen,           ja, n3, word, jmdict_kanji('地面')).
pick(w_kyoudou,         ja, n3, word, jmdict('1591660')).  % きょうどう cooperation; collaboration; association
pick(w_taiken,          ja, n3, word, jmdict_kanji('体験')).
pick(w_mibun,           ja, n3, word, jmdict_kanji('身分')).
pick(w_shuukai,         ja, n3, word, jmdict_kanji('集会')).
pick(w_sharyou,         ja, n3, word, jmdict_kanji('車両')).
pick(w_shikaku,         ja, n3, word, jmdict_kanji('資格')).
pick(w_haitatsu,        ja, n3, word, jmdict_kanji('配達')).
pick(w_nyuushu,         ja, n3, word, jmdict_kanji('入手')).
pick(w_juudai,          ja, n3, word, jmdict_kanji('重大')).
pick(w_seijou,          ja, n3, word, jmdict_kanji('正常')).
pick(w_tsuuka,          ja, n3, word, jmdict_kanji('通過')).
pick(w_gunjin,          ja, n3, word, jmdict_kanji('軍人')).
pick(w_chousei,         ja, n3, word, jmdict_kanji('調整')).
pick(w_fuyou,           ja, n3, word, jmdict_kanji('不要')).
pick(w_hisshi,          ja, n3, word, jmdict_kanji('必死')).
pick(w_fusei,           ja, n3, word, jmdict_kanji('不正')).
pick(w_yakubutsu,       ja, n3, word, jmdict_kanji('薬物')).
pick(w_youken,          ja, n3, word, jmdict_kanji('用件')).
pick(w_akka,            ja, n3, word, jmdict_kanji('悪化')).
pick(w_okizari,         ja, n3, word, jmdict_kanji('置き去り')).
pick(w_seifuku,         ja, n3, word, jmdict_kanji('制服')).
pick(w_mujin,           ja, n3, word, jmdict_kanji('無人')).
pick(w_settei,          ja, n3, word, jmdict_kanji('設定')).
pick(w_henshin,         ja, n3, word, jmdict_kanji('変身')).
pick(w_seikai,          ja, n3, word, jmdict_kanji('正解')).
pick(w_kousaku,         ja, n3, word, jmdict_kanji('工作')).
pick(w_ichiin,          ja, n3, word, jmdict_kanji('一員')).
pick(w_joshi,           ja, n3, word, jmdict('1345140')).  % じょし woman; girl
pick(w_denshi,          ja, n3, word, jmdict_kanji('電子')).
pick(w_ichiji,          ja, n3, word, jmdict('1576100')).  % いちじ one o'clock; once; at one time
pick(w_jitsugen,        ja, n3, word, jmdict_kanji('実現')).
pick(w_doyou,           ja, n3, word, jmdict_kanji('土曜')).
pick(w_shuzoku,         ja, n3, word, jmdict_kanji('種族')).
pick(w_ikimono,         ja, n3, word, jmdict_kanji('生き物')).
pick(w_bijutsu,         ja, n3, word, jmdict_kanji('美術')).
pick(w_koutsuu,         ja, n3, word, jmdict_kanji('交通')).
pick(w_shinri,          ja, n3, word, jmdict_kanji('心理')).
pick(w_sayou,           ja, n3, word, jmdict_kanji('作用')).
pick(w_zenshin,         ja, n3, word, jmdict_kanji('前進')).
pick(w_tsuzuki,         ja, n3, word, jmdict_kanji('続き')).
pick(w_kokuou,          ja, n3, word, jmdict_kanji('国王')).
pick(w_geka,            ja, n3, word, jmdict_kanji('外科')).
pick(w_jogen,           ja, n3, word, jmdict_kanji('助言')).
pick(w_tosho,           ja, n3, word, jmdict_kanji('図書')).
pick(w_youjin,          ja, n3, word, jmdict_kanji('用心')).
pick(w_koukai,          ja, n3, word, jmdict_kanji('公開')).
pick(w_risou,           ja, n3, word, jmdict_kanji('理想')).
pick(w_getsuyou,        ja, n3, word, jmdict_kanji('月曜')).
pick(w_tensou,          ja, n3, word, jmdict_kanji('転送')).
pick(w_joukyaku,        ja, n3, word, jmdict_kanji('乗客')).
pick(w_honnin,          ja, n3, word, jmdict_kanji('本人')).
pick(w_houdou,          ja, n3, word, jmdict_kanji('報道')).
pick(w_shoumen,         ja, n3, word, jmdict('1378030')).  % しょうめん front; frontage; facade
pick(w_hasshin,         ja, n3, word, jmdict_kanji('発信')).
pick(w_menkai,          ja, n3, word, jmdict_kanji('面会')).
pick(w_kokoroatari,     ja, n3, word, jmdict_kanji('心当たり')).
pick(w_nanzen,          ja, n3, word, jmdict_kanji('何千')).
pick(w_shouhin,         ja, n3, word, jmdict_kanji('商品')).
pick(w_shokuin,         ja, n3, word, jmdict_kanji('職員')).
pick(w_kentou,          ja, n3, word, jmdict_kanji('見当')).
pick(w_seishiki,        ja, n3, word, jmdict_kanji('正式')).
pick(w_issai,           ja, n3, word, jmdict_kanji('一切')).
pick(w_oujo,            ja, n3, word, jmdict_kanji('王女')).
pick(w_tadachini,       ja, n3, word, jmdict_kanji('直ちに')).
pick(w_yononaka,        ja, n3, word, jmdict_kanji('世の中')).
pick(w_shinka,          ja, n3, word, jmdict_kanji('進化')).
pick(w_shinin,          ja, n3, word, jmdict_kanji('死人')).
pick(w_hokubu,          ja, n3, word, jmdict_kanji('北部')).
pick(w_shukufuku,       ja, n3, word, jmdict_kanji('祝福')).
pick(w_doujou,          ja, n3, word, jmdict_kanji('同情')).
pick(w_wadai,           ja, n3, word, jmdict_kanji('話題')).
pick(w_kouchou,         ja, n3, word, jmdict_kanji('校長')).
pick(w_sadou,           ja, n3, word, jmdict_kanji('作動')).
pick(w_tsuika,          ja, n3, word, jmdict_kanji('追加')).
pick(w_kensetsu,        ja, n3, word, jmdict_kanji('建設')).
pick(w_seika,           ja, n3, word, jmdict_kanji('成果')).
pick(w_suuhyaku,        ja, n3, word, jmdict_kanji('数百')).
pick(w_hatsugen,        ja, n3, word, jmdict_kanji('発言')).
pick(w_nigate,          ja, n3, word, jmdict_kanji('苦手')).
pick(w_atarimae,        ja, n3, word, jmdict_kanji('当たり前')).
pick(w_deban,           ja, n3, word, jmdict_kanji('出番')).
pick(w_gutai,           ja, n3, word, jmdict_kanji('具体')).
pick(w_chokumen,        ja, n3, word, jmdict('1431540')).  % ちょくめん confrontation; to face; to confront
pick(w_waraigoe,        ja, n3, word, jmdict_kanji('笑い声')).
pick(w_shuuhen,         ja, n3, word, jmdict_kanji('周辺')).
pick(w_koudo,           ja, n3, word, jmdict_kanji('高度')).
pick(w_taikai,          ja, n3, word, jmdict_kanji('大会')).
pick(w_nichiyou,        ja, n3, word, jmdict_kanji('日曜')).
pick(w_saichuu,         ja, n3, word, jmdict('1579210')).  % さいちゅう (in) the middle of; (in) the midst of; (in) the 
pick(w_nyuuin,          ja, n3, word, jmdict_kanji('入院')).
pick(w_shinnen,         ja, n3, word, jmdict_kanji('信念')).
pick(w_shisan,          ja, n3, word, jmdict_kanji('資産')).
pick(w_seiri,           ja, n3, word, jmdict_kanji('整理')).
pick(w_kandou,          ja, n3, word, jmdict_kanji('感動')).
pick(w_chuushoku,       ja, n3, word, jmdict('1602330')).  % ちゅうしょく lunch; midday meal
pick(w_saisei,          ja, n3, word, jmdict_kanji('再生')).
pick(w_kodai,           ja, n3, word, jmdict_kanji('古代')).
pick(w_hikigane,        ja, n3, word, jmdict_kanji('引き金')).
pick(w_yakume,          ja, n3, word, jmdict_kanji('役目')).
pick(w_ichidou,         ja, n3, word, jmdict_kanji('一同')).
pick(w_hantoshi,        ja, n3, word, jmdict_kanji('半年')).
pick(w_tassei,          ja, n3, word, jmdict_kanji('達成')).
pick(w_douzen,          ja, n3, word, jmdict_kanji('同然')).
pick(w_akunin,          ja, n3, word, jmdict_kanji('悪人')).
pick(w_jushin,          ja, n3, word, jmdict_kanji('受信')).
pick(w_senjou,          ja, n3, word, jmdict('1390320')).  % せんじょう battlefield; battleground
pick(w_butsuri,         ja, n3, word, jmdict_kanji('物理')).
pick(w_jakuten,         ja, n3, word, jmdict_kanji('弱点')).
pick(w_koukyuu,         ja, n3, word, jmdict_kanji('高級')).
pick(w_shunin,          ja, n3, word, jmdict_kanji('主任')).
pick(w_tejun,           ja, n3, word, jmdict_kanji('手順')).
pick(w_denryoku,        ja, n3, word, jmdict_kanji('電力')).
pick(w_shigo,           ja, n3, word, jmdict_kanji('死後')).
pick(w_shinjin,         ja, n3, word, jmdict_kanji('新人')).
pick(w_chiten,          ja, n3, word, jmdict_kanji('地点')).
pick(w_hatsuden,        ja, n3, word, jmdict_kanji('発電')).
pick(w_juuji,           ja, n3, word, jmdict_kanji('十字')).
pick(w_aijou,           ja, n3, word, jmdict_kanji('愛情')).
pick(w_kaidoku,         ja, n3, word, jmdict_kanji('解読')).
pick(w_juumin,          ja, n3, word, jmdict_kanji('住民')).
pick(w_kyouka,          ja, n3, word, jmdict_kanji('強化')).
pick(w_tetsuzuki,       ja, n3, word, jmdict_kanji('手続き')).
pick(w_chokuzen,        ja, n3, word, jmdict_kanji('直前')).
pick(w_shinai,          ja, n3, word, jmdict_kanji('親愛')).
pick(w_kyousou,         ja, n3, word, jmdict_kanji('競争')).
pick(w_ippo,            ja, n3, word, jmdict_kanji('一歩')).
pick(w_shoubou,         ja, n3, word, jmdict_kanji('消防')).
pick(w_muyou,           ja, n3, word, jmdict_kanji('無用')).
pick(w_kouhyou,         ja, n3, word, jmdict_kanji('公表')).
pick(w_oomono,          ja, n3, word, jmdict_kanji('大物')).
pick(w_rokuon,          ja, n3, word, jmdict_kanji('録音')).
pick(w_nikutai,         ja, n3, word, jmdict_kanji('肉体')).
pick(w_uchigawa,        ja, n3, word, jmdict_kanji('内側')).
pick(w_fuhou,           ja, n3, word, jmdict_kanji('不法')).
pick(w_yuujou,          ja, n3, word, jmdict_kanji('友情')).
pick(w_yaruki,          ja, n3, word, jmdict_kanji('やる気')).
pick(w_jitai,           ja, n3, word, jmdict_kanji('自体')).
pick(w_yobi,            ja, n3, word, jmdict_kanji('予備')).
pick(w_bunya,           ja, n3, word, jmdict_kanji('分野')).
pick(w_ougon,           ja, n3, word, jmdict('1181860')).  % おうごん gold (Au); golden; prosperous
pick(w_rikou,           ja, n3, word, jmdict_kanji('利口')).
pick(w_buhin,           ja, n3, word, jmdict_kanji('部品')).
pick(w_kaikei,          ja, n3, word, jmdict_kanji('会計')).
pick(w_toujou,          ja, n3, word, jmdict_kanji('登場')).
pick(w_honjitsu,        ja, n3, word, jmdict_kanji('本日')).
pick(w_bainin,          ja, n3, word, jmdict_kanji('売人')).
pick(w_saikai,          ja, n3, word, jmdict_kanji('再開')).
pick(w_chii,            ja, n3, word, jmdict_kanji('地位')).
pick(w_deai,            ja, n3, word, jmdict_kanji('出会い')).
pick(w_oogoe,           ja, n3, word, jmdict_kanji('大声')).
pick(w_tashou,          ja, n3, word, jmdict_kanji('多少')).
pick(w_naganen,         ja, n3, word, jmdict_kanji('長年')).
pick(w_suusen,          ja, n3, word, jmdict_kanji('数千')).
pick(w_deiri,           ja, n3, word, jmdict_kanji('出入り')).
pick(w_bunsho,          ja, n3, word, jmdict_kanji('文書')).
pick(w_yogen,           ja, n3, word, jmdict('1584920')).  % よげん prediction; prophecy; prognostication
pick(w_tsukiai,         ja, n3, word, jmdict_kanji('付き合い')).
pick(w_senjitsu,        ja, n3, word, jmdict_kanji('先日')).
pick(w_tsuihou,         ja, n3, word, jmdict_kanji('追放')).
pick(w_mochinushi,      ja, n3, word, jmdict_kanji('持ち主')).
pick(w_shousha,         ja, n3, word, jmdict_kanji('勝者')).
pick(w_muryou,          ja, n3, word, jmdict_kanji('無料')).
pick(w_meihaku,         ja, n3, word, jmdict('1000220')).  % めいはく obvious; clear; plain
pick(w_gouhou,          ja, n3, word, jmdict_kanji('合法')).
pick(w_shokugyou,       ja, n3, word, jmdict_kanji('職業')).
pick(w_shitagi,         ja, n3, word, jmdict_kanji('下着')).
pick(w_onsei,           ja, n3, word, jmdict('1183880')).  % おんせい voice; speech; phone (as opposed to a phoneme)
pick(w_bakemono,        ja, n3, word, jmdict_kanji('化け物')).
pick(w_shiten,          ja, n3, word, jmdict_kanji('支店')).
pick(w_saikyou,         ja, n3, word, jmdict_kanji('最強')).
pick(w_kaimei,          ja, n3, word, jmdict_kanji('解明')).
pick(w_kaiken,          ja, n3, word, jmdict_kanji('会見')).
pick(w_kuukan,          ja, n3, word, jmdict('1245450')).  % くうかん space; room; airspace
pick(w_doukou,          ja, n3, word, jmdict('1452340')).  % どうこう accompanying (someone); going with; travelling t
pick(w_jihaku,          ja, n3, word, jmdict_kanji('自白')).
pick(w_mokuyou,         ja, n3, word, jmdict_kanji('木曜')).
pick(w_gaikou,          ja, n3, word, jmdict_kanji('外交')).
pick(w_tasuu,           ja, n3, word, jmdict_kanji('多数')).
pick(w_hyouji,          ja, n3, word, jmdict_kanji('表示')).
pick(w_genshi,          ja, n3, word, jmdict_kanji('原子')).
pick(w_honmyou,         ja, n3, word, jmdict_kanji('本名')).
pick(w_hizuke,          ja, n3, word, jmdict_kanji('日付')).
pick(w_warumono,        ja, n3, word, jmdict_kanji('悪者')).
pick(w_gengo,           ja, n3, word, jmdict_kanji('言語')).
pick(w_ketsumatsu,      ja, n3, word, jmdict_kanji('結末')).
pick(w_ikisaki,         ja, n3, word, jmdict_kanji('行き先')).
pick(w_kamotsu,         ja, n3, word, jmdict_kanji('貨物')).
pick(w_kuugun,          ja, n3, word, jmdict_kanji('空軍')).
pick(w_tsuuwa,          ja, n3, word, jmdict_kanji('通話')).
pick(w_taisei,          ja, n3, word, jmdict_kanji('体制')).
pick(w_eikou,           ja, n3, word, jmdict_kanji('栄光')).
pick(w_kasoku,          ja, n3, word, jmdict_kanji('加速')).
pick(w_minshu,          ja, n3, word, jmdict_kanji('民主')).
pick(w_koutai,          ja, n3, word, jmdict_kanji('交代')).
pick(w_furi,            ja, n3, word, jmdict_kanji('不利')).
pick(w_rikugun,         ja, n3, word, jmdict_kanji('陸軍')).
pick(w_kenshutsu,       ja, n3, word, jmdict_kanji('検出')).
pick(w_hanketsu,        ja, n3, word, jmdict_kanji('判決')).
pick(w_kenkai,          ja, n3, word, jmdict_kanji('見解')).
pick(w_shuugou,         ja, n3, word, jmdict_kanji('集合')).
pick(w_shoji,           ja, n3, word, jmdict_kanji('所持')).
pick(w_gyoukai,         ja, n3, word, jmdict_kanji('業界')).
pick(w_secchi,          ja, n3, word, jmdict_kanji('設置')).
pick(w_choutatsu,       ja, n3, word, jmdict_kanji('調達')).
pick(w_jounetsu,        ja, n3, word, jmdict_kanji('情熱')).
pick(w_iji,             ja, n3, word, jmdict_kanji('意地')).
pick(w_houteki,         ja, n3, word, jmdict_kanji('法的')).
pick(w_honnou,          ja, n3, word, jmdict_kanji('本能')).
pick(w_henjin,          ja, n3, word, jmdict_kanji('変人')).
pick(w_juuryoku,        ja, n3, word, jmdict_kanji('重力')).
pick(w_hakujou,         ja, n3, word, jmdict_kanji('白状')).
pick(w_chakushin,       ja, n3, word, jmdict_kanji('着信')).
pick(w_reigai,          ja, n3, word, jmdict_kanji('例外')).
pick(w_gouryuu,         ja, n3, word, jmdict_kanji('合流')).
pick(w_honrai,          ja, n3, word, jmdict_kanji('本来')).
pick(w_baibai,          ja, n3, word, jmdict('1474050')).  % ばいばい trade; buying and selling; trafficking (e.g. of 
pick(w_chokkan,         ja, n3, word, jmdict_kanji('直感')).
pick(w_banchi,          ja, n3, word, jmdict_kanji('番地')).
pick(w_isshu,           ja, n3, word, jmdict_kanji('一種')).
pick(w_chokugo,         ja, n3, word, jmdict_kanji('直後')).
pick(w_dantai,          ja, n3, word, jmdict_kanji('団体')).
pick(w_nichijou,        ja, n3, word, jmdict_kanji('日常')).
pick(w_ninzuu,          ja, n3, word, jmdict('1580700')).  % にんずう the number of people; many people; a large numbe
pick(w_kouka,           ja, n3, word, jmdict_kanji('高価')).
pick(w_yuunou,          ja, n3, word, jmdict_kanji('有能')).
pick(w_yuuri,           ja, n3, word, jmdict_kanji('有利')).
pick(w_hoji,            ja, n3, word, jmdict_kanji('保持')).
pick(w_rengou,          ja, n3, word, jmdict_kanji('連合')).
pick(w_seiteki,         ja, n3, word, jmdict_kanji('性的')).
pick(w_yokan,           ja, n3, word, jmdict_kanji('予感')).
pick(w_mukougawa,       ja, n3, word, jmdict_kanji('向こう側')).
pick(w_fukin,           ja, n3, word, jmdict_kanji('付近')).
pick(w_kaisen,          ja, n3, word, jmdict_kanji('回線')).
pick(w_jigen,           ja, n3, word, jmdict_kanji('次元')).
pick(w_soutei,          ja, n3, word, jmdict_kanji('想定')).
pick(w_shussho,         ja, n3, word, jmdict('1580030')).  % しゅっしょ source; origin; provenance
pick(w_senjutsu,        ja, n3, word, jmdict_kanji('戦術')).
pick(w_jikai,           ja, n3, word, jmdict_kanji('次回')).
pick(w_warugi,          ja, n3, word, jmdict('1151560')).  % わるぎ ill will; malice; evil intent
pick(w_sabetsu,         ja, n3, word, jmdict_kanji('差別')).
pick(w_chuudan,         ja, n3, word, jmdict_kanji('中断')).
pick(w_zenka,           ja, n3, word, jmdict_kanji('前科')).
pick(w_ikka,            ja, n3, word, jmdict_kanji('一家')).
pick(w_chitai,          ja, n3, word, jmdict_kanji('地帯')).
pick(w_hyoujou,         ja, n3, word, jmdict_kanji('表情')).
pick(w_hanashiai,       ja, n3, word, jmdict_kanji('話し合い')).
pick(w_shokumu,         ja, n3, word, jmdict_kanji('職務')).
pick(w_shutsudou,       ja, n3, word, jmdict_kanji('出動')).
pick(w_kesshin,         ja, n3, word, jmdict_kanji('決心')).
pick(w_shuzai,          ja, n3, word, jmdict_kanji('取材')).
pick(w_shonichi,        ja, n3, word, jmdict('1342980')).  % しょにち first day; opening day
pick(w_oogesa,          ja, n3, word, jmdict_kanji('大げさ')).
pick(w_sakusei,         ja, n3, word, jmdict_kanji('作成')).
pick(w_kaiten,          ja, n3, word, jmdict_kanji('回転')).
pick(w_chisei,          ja, n3, word, jmdict_kanji('知性')).
pick(w_genchi,          ja, n3, word, jmdict_kanji('現地')).
pick(w_muryoku,         ja, n3, word, jmdict_kanji('無力')).
pick(w_nikki,           ja, n3, word, jmdict_kanji('日記')).
pick(w_fuun,            ja, n3, word, jmdict_kanji('不運')).
pick(w_sekkyou,         ja, n3, word, jmdict_kanji('説教')).
pick(w_seisan,          ja, n3, word, jmdict('1378990')).  % せいさん production; manufacture
pick(w_betsujin,        ja, n3, word, jmdict_kanji('別人')).
pick(w_kogitte,         ja, n3, word, jmdict_kanji('小切手')).
pick(w_joudeki,         ja, n3, word, jmdict_kanji('上出来')).
pick(w_goui,            ja, n3, word, jmdict_kanji('合意')).
pick(w_ondo,            ja, n3, word, jmdict_kanji('温度')).
pick(w_sanshou,         ja, n3, word, jmdict_kanji('参照')).
pick(w_aijin,           ja, n3, word, jmdict_kanji('愛人')).
pick(w_burei,           ja, n3, word, jmdict('1531060')).  % ぶれい rudeness; impoliteness; discourtesy
pick(w_ryoukin,         ja, n3, word, jmdict_kanji('料金')).
pick(w_genjou,          ja, n3, word, jmdict_kanji('現状')).
pick(w_ketsui,          ja, n3, word, jmdict_kanji('決意')).
pick(w_teguchi,         ja, n3, word, jmdict_kanji('手口')).
pick(w_jinkaku,         ja, n3, word, jmdict_kanji('人格')).
pick(w_rokuga,          ja, n3, word, jmdict_kanji('録画')).
pick(w_maikai,          ja, n3, word, jmdict_kanji('毎回')).
pick(w_gouri,           ja, n3, word, jmdict_kanji('合理')).
pick(w_tetsudou,        ja, n3, word, jmdict_kanji('鉄道')).
pick(w_honshitsu,       ja, n3, word, jmdict_kanji('本質')).
pick(w_kyoutei,         ja, n3, word, jmdict_kanji('協定')).
pick(w_shoki,           ja, n3, word, jmdict_kanji('初期')).
pick(w_sensha,          ja, n3, word, jmdict_kanji('戦車')).
pick(w_muki,            ja, n3, word, jmdict_kanji('向き')).
pick(w_basha,           ja, n3, word, jmdict('1471780')).  % ばしゃ coach (horse-drawn); carriage; wagon
pick(w_gaibu,           ja, n3, word, jmdict_kanji('外部')).
pick(w_ashimoto,        ja, n3, word, jmdict_kanji('足元')).
pick(w_kasei,           ja, n3, word, jmdict_kanji('火星')).
pick(w_dousa,           ja, n3, word, jmdict_kanji('動作')).
pick(w_zouka,           ja, n3, word, jmdict_kanji('増加')).
pick(w_unei,            ja, n3, word, jmdict_kanji('運営')).
pick(w_sairyou,         ja, n3, word, jmdict_kanji('最良')).
pick(w_shuyou,          ja, n3, word, jmdict_kanji('主要')).
pick(w_danjo,           ja, n3, word, jmdict('1420110')).  % だんじょ men and women; man and woman; both sexes
pick(w_toshiue,         ja, n3, word, jmdict_kanji('年上')).
pick(w_roji,            ja, n3, word, jmdict_kanji('路地')).
pick(w_jitsuzai,        ja, n3, word, jmdict_kanji('実在')).
pick(w_souzoku,         ja, n3, word, jmdict_kanji('相続')).
pick(w_shoukyo,         ja, n3, word, jmdict_kanji('消去')).
pick(w_zenkoku,         ja, n3, word, jmdict_kanji('全国')).
pick(w_houchi,          ja, n3, word, jmdict_kanji('放置')).
pick(w_gendai,          ja, n3, word, jmdict('1263810')).  % げんだい present age; present day; contemporary
pick(w_teika,           ja, n3, word, jmdict_kanji('低下')).
pick(w_douga,           ja, n3, word, jmdict_kanji('動画')).
pick(w_kumiai,          ja, n3, word, jmdict_kanji('組合')).
pick(w_ikinokori,       ja, n3, word, jmdict_kanji('生き残り')).
pick(w_kiraku,          ja, n3, word, jmdict_kanji('気楽')).
pick(w_honshin,         ja, n3, word, jmdict_kanji('本心')).
pick(w_chiteki,         ja, n3, word, jmdict_kanji('知的')).
pick(w_seiritsu,        ja, n3, word, jmdict_kanji('成立')).
pick(w_sentou,          ja, n3, word, jmdict_kanji('先頭')).
pick(w_jinin,           ja, n3, word, jmdict_kanji('人員')).
pick(w_denchi,          ja, n3, word, jmdict_kanji('電池')).
pick(w_suujuu,          ja, n3, word, jmdict_kanji('数十')).
pick(w_shuto,           ja, n3, word, jmdict_kanji('首都')).
pick(w_tsuuchi,         ja, n3, word, jmdict_kanji('通知')).
pick(w_danshi,          ja, n3, word, jmdict_kanji('男子')).
pick(w_gamen,           ja, n3, word, jmdict_kanji('画面')).
pick(w_saiai,           ja, n3, word, jmdict_kanji('最愛')).
pick(w_kiki,            ja, n3, word, jmdict_kanji('機器')).
pick(w_ryuukou,         ja, n3, word, jmdict('1585110')).  % りゅうこう fashion; trend; vogue
pick(w_zensen,          ja, n3, word, jmdict_kanji('前線')).
pick(w_busshi,          ja, n3, word, jmdict_kanji('物資')).
pick(w_joukyuu,         ja, n3, word, jmdict_kanji('上級')).
pick(w_saigen,          ja, n3, word, jmdict_kanji('再現')).
pick(w_zenpou,          ja, n3, word, jmdict('1394010')).  % ぜんぽう ahead; forward; (in) front
pick(w_tsukuribanashi,  ja, n3, word, jmdict_kanji('作り話')).
pick(w_seido,           ja, n3, word, jmdict_kanji('制度')).
pick(w_kankyaku,        ja, n3, word, jmdict_kanji('観客')).
pick(w_kagu,            ja, n3, word, jmdict_kanji('家具')).
pick(w_kukaku,          ja, n3, word, jmdict_kanji('区画')).
pick(w_kousui,          ja, n3, word, jmdict('1283060')).  % こうすい perfume; scent
pick(w_saiken,          ja, n3, word, jmdict('1292590')).  % さいけん rebuilding; reconstruction; rehabilitation
pick(w_yasuraka,        ja, n3, word, jmdict_kanji('安らか')).
pick(w_gyousha,         ja, n3, word, jmdict_kanji('業者')).
pick(w_sankou,          ja, n3, word, jmdict_kanji('参考')).
pick(w_taisen,          ja, n3, word, jmdict_kanji('大戦')).
pick(w_fuzai,           ja, n3, word, jmdict_kanji('不在')).
pick(w_tema,            ja, n3, word, jmdict_kanji('手間')).
pick(w_kairo,           ja, n3, word, jmdict_kanji('回路')).
pick(w_kakaku,          ja, n3, word, jmdict_kanji('価格')).
pick(w_kaijou,          ja, n3, word, jmdict_kanji('会場')).
pick(w_gyoumu,          ja, n3, word, jmdict_kanji('業務')).
pick(w_shussan,         ja, n3, word, jmdict_kanji('出産')).
pick(w_setsuyaku,       ja, n3, word, jmdict_kanji('節約')).
pick(w_kuusou,          ja, n3, word, jmdict_kanji('空想')).
pick(w_koinu,           ja, n3, word, jmdict_kanji('子犬')).
pick(w_enzetsu,         ja, n3, word, jmdict_kanji('演説')).
pick(w_kaikyuu,         ja, n3, word, jmdict_kanji('階級')).
pick(w_deshi,           ja, n3, word, jmdict_kanji('弟子')).
pick(w_sotogawa,        ja, n3, word, jmdict_kanji('外側')).
pick(w_setsubi,         ja, n3, word, jmdict_kanji('設備')).
pick(w_bokoku,          ja, n3, word, jmdict_kanji('母国')).
pick(w_megami,          ja, n3, word, jmdict('1345210')).  % めがみ goddess
pick(w_keika,           ja, n3, word, jmdict_kanji('経過')).
pick(w_kujou,           ja, n3, word, jmdict_kanji('苦情')).
pick(w_kaisan,          ja, n3, word, jmdict_kanji('解散')).
pick(w_jizen,           ja, n3, word, jmdict_kanji('事前')).
pick(w_nanbu,           ja, n3, word, jmdict_kanji('南部')).
pick(w_kousei,          ja, n3, word, jmdict_kanji('公正')).
pick(w_danketsu,        ja, n3, word, jmdict_kanji('団結')).
pick(w_doukan,          ja, n3, word, jmdict_kanji('同感')).
pick(w_kaichou,         ja, n3, word, jmdict_kanji('会長')).
pick(w_shoumei,         ja, n3, word, jmdict_kanji('照明')).
pick(w_shinwa,          ja, n3, word, jmdict_kanji('神話')).
pick(w_kobito,          ja, n3, word, jmdict('2860036')).  % こびと little person (in folklore and fantasy, e.g. fai
pick(w_furyou,          ja, n3, word, jmdict_kanji('不良')).
pick(w_gousei,          ja, n3, word, jmdict_kanji('合成')).
pick(w_chinou,          ja, n3, word, jmdict_kanji('知能')).
pick(w_mitooshi,        ja, n3, word, jmdict_kanji('見通し')).
pick(w_kaiga,           ja, n3, word, jmdict_kanji('絵画')).
pick(w_kouhou,          ja, n3, word, jmdict('1270100')).  % こうほう rear; back; behind
pick(w_kichou,          ja, n3, word, jmdict_kanji('機長')).
pick(w_nyuuryoku,       ja, n3, word, jmdict_kanji('入力')).
pick(w_kecchaku,        ja, n3, word, jmdict_kanji('決着')).
pick(w_karappo,         ja, n3, word, jmdict_kanji('空っぽ')).
pick(w_komori,          ja, n3, word, jmdict_kanji('子守')).
pick(w_ikki,            ja, n3, word, jmdict_kanji('一気')).
pick(w_shutsuen,        ja, n3, word, jmdict_kanji('出演')).
pick(w_shinya,          ja, n3, word, jmdict_kanji('深夜')).
pick(w_migite,          ja, n3, word, jmdict('1171120')).  % みぎて right hand; right-hand side; right-hand directio
pick(w_bamen,           ja, n3, word, jmdict_kanji('場面')).
pick(w_bunshi,          ja, n3, word, jmdict_kanji('分子')).
pick(w_soukin,          ja, n3, word, jmdict_kanji('送金')).
pick(w_seiryoku,        ja, n3, word, jmdict_kanji('勢力')).
pick(w_tainai,          ja, n3, word, jmdict_kanji('体内')).
pick(w_houka,           ja, n3, word, jmdict_kanji('放火')).
pick(w_kuimono,         ja, n3, word, jmdict_kanji('食い物')).
pick(w_kakudo,          ja, n3, word, jmdict_kanji('角度')).
pick(w_buzoku,          ja, n3, word, jmdict_kanji('部族')).
pick(w_tsuuyou,         ja, n3, word, jmdict_kanji('通用')).
pick(w_koukyou,         ja, n3, word, jmdict_kanji('公共')).
pick(w_yobou,           ja, n3, word, jmdict_kanji('予防')).
pick(w_kougaku,         ja, n3, word, jmdict_kanji('工学')).
pick(w_yakusha,         ja, n3, word, jmdict_kanji('役者')).
pick(w_yashin,          ja, n3, word, jmdict_kanji('野心')).
pick(w_yakuin,          ja, n3, word, jmdict_kanji('役員')).
pick(w_saido,           ja, n3, word, jmdict_kanji('再度')).
pick(w_ketten,          ja, n3, word, jmdict_kanji('欠点')).
pick(w_gaiken,          ja, n3, word, jmdict_kanji('外見')).
pick(w_risei,           ja, n3, word, jmdict_kanji('理性')).
pick(w_tenka,           ja, n3, word, jmdict('1441440')).  % てんか ignition; lighting; firing
pick(w_youten,          ja, n3, word, jmdict_kanji('要点')).
pick(w_meian,           ja, n3, word, jmdict_kanji('名案')).
pick(w_shitsugyou,      ja, n3, word, jmdict_kanji('失業')).
pick(w_hansei,          ja, n3, word, jmdict_kanji('反省')).
pick(w_kokugai,         ja, n3, word, jmdict_kanji('国外')).
pick(w_shitaku,         ja, n3, word, jmdict_kanji('支度')).
pick(w_gesui,           ja, n3, word, jmdict('1185510')).  % げすい drainage; ditch; gutter
pick(w_shinro,          ja, n3, word, jmdict_kanji('進路')).
pick(w_miuchi,          ja, n3, word, jmdict_kanji('身内')).
pick(w_nakanaori,       ja, n3, word, jmdict_kanji('仲直り')).
pick(w_kaigou,          ja, n3, word, jmdict_kanji('会合')).
pick(w_hiruma,          ja, n3, word, jmdict_kanji('昼間')).
pick(w_kubetsu,         ja, n3, word, jmdict_kanji('区別')).
pick(w_nanjuu,          ja, n3, word, jmdict_kanji('何十')).
pick(w_kyuukyoku,       ja, n3, word, jmdict_kanji('究極')).
pick(w_shisai,          ja, n3, word, jmdict_kanji('司祭')).
pick(w_minzoku,         ja, n3, word, jmdict_kanji('民族')).
pick(w_maemuki,         ja, n3, word, jmdict_kanji('前向き')).
pick(w_ichiryuu,        ja, n3, word, jmdict_kanji('一流')).
pick(w_suiyou,          ja, n3, word, jmdict_kanji('水曜')).
pick(w_koubu,           ja, n3, word, jmdict_kanji('後部')).
pick(w_oyayubi,         ja, n3, word, jmdict_kanji('親指')).
pick(w_kaoiro,          ja, n3, word, jmdict_kanji('顔色')).
pick(w_mashita,         ja, n3, word, jmdict_kanji('真下')).
pick(w_fujimi,          ja, n3, word, jmdict_kanji('不死身')).
pick(w_bunrui,          ja, n3, word, jmdict_kanji('分類')).
pick(w_meisei,          ja, n3, word, jmdict_kanji('名声')).
pick(w_joutou,          ja, n3, word, jmdict_kanji('上等')).
pick(w_myouchou,        ja, n3, word, jmdict('1532540')).  % みょうちょう tomorrow morning
pick(w_jinzai,          ja, n3, word, jmdict_kanji('人材')).
pick(w_koukei,          ja, n3, word, jmdict_kanji('光景')).
pick(w_koushin,         ja, n3, word, jmdict_kanji('交信')).
pick(w_ketsugou,        ja, n3, word, jmdict_kanji('結合')).
pick(w_jousen,          ja, n3, word, jmdict_kanji('乗船')).
pick(w_setsuritsu,      ja, n3, word, jmdict_kanji('設立')).
pick(w_kaitai,          ja, n3, word, jmdict_kanji('解体')).
pick(w_rakushou,        ja, n3, word, jmdict_kanji('楽勝')).
pick(w_dokusho,         ja, n3, word, jmdict_kanji('読書')).
pick(w_kokudo,          ja, n3, word, jmdict_kanji('国土')).
pick(w_kyoukun,         ja, n3, word, jmdict_kanji('教訓')).
pick(w_chouri,          ja, n3, word, jmdict_kanji('調理')).
pick(w_jouhin,          ja, n3, word, jmdict('1354230')).  % じょうひん elegant; refined; polished
pick(w_joukuu,          ja, n3, word, jmdict_kanji('上空')).
pick(w_youki,           ja, n3, word, jmdict_kanji('容器')).
pick(w_shozai,          ja, n3, word, jmdict_kanji('所在')).
pick(w_dangen,          ja, n3, word, jmdict_kanji('断言')).
pick(w_taimen,          ja, n3, word, jmdict('1410270')).  % たいめん meeting face-to-face; seeing in person; facing (
pick(w_joukan,          ja, n3, word, jmdict_kanji('上官')).
pick(w_ouke,            ja, n3, word, jmdict_kanji('王家')).
pick(w_kyoukan,         ja, n3, word, jmdict_kanji('教官')).
pick(w_keshiki,         ja, n3, word, jmdict_kanji('景色')).
pick(w_bunkai,          ja, n3, word, jmdict_kanji('分解')).
pick(w_shinpin,         ja, n3, word, jmdict_kanji('新品')).
pick(w_buttai,          ja, n3, word, jmdict('1502680')).  % ぶったい object; body; solid
pick(w_shakou,          ja, n3, word, jmdict_kanji('社交')).
pick(w_kanchi,          ja, n3, word, jmdict_kanji('感知')).
pick(w_kesshou,         ja, n3, word, jmdict_kanji('決勝')).
pick(w_ichiren,         ja, n3, word, jmdict_kanji('一連')).
pick(w_gakushuu,        ja, n3, word, jmdict_kanji('学習')).
pick(w_mukai,           ja, n3, word, jmdict_kanji('向かい')).
pick(w_hatsudou,        ja, n3, word, jmdict_kanji('発動')).
pick(w_nyuukoku,        ja, n3, word, jmdict_kanji('入国')).
pick(w_jikaku,          ja, n3, word, jmdict_kanji('自覚')).
pick(w_meate,           ja, n3, word, jmdict_kanji('目当て')).
pick(w_bijo,            ja, n3, word, jmdict('1486490')).  % びじょ beautiful woman
pick(w_youbou,          ja, n3, word, jmdict_kanji('要望')).
pick(w_kehai,           ja, n3, word, jmdict_kanji('気配')).
pick(w_chikamichi,      ja, n3, word, jmdict_kanji('近道')).
pick(w_shitei,          ja, n3, word, jmdict_kanji('指定')).
pick(w_shuushin,        ja, n3, word, jmdict_kanji('終身')).
pick(w_bukimi,          ja, n3, word, jmdict_kanji('不気味')).
pick(w_shusse,          ja, n3, word, jmdict_kanji('出世')).
pick(w_seishi,          ja, n3, word, jmdict('1379060')).  % せいし life and death; life or death; samsara (cycle of
pick(w_anchi,           ja, n3, word, jmdict('1154090')).  % あんち enshrinement; installation (of an image)
pick(w_tairitsu,        ja, n3, word, jmdict_kanji('対立')).
pick(w_chouki,          ja, n3, word, jmdict_kanji('長期')).
pick(w_teiki,           ja, n3, word, jmdict_kanji('定期')).
pick(w_kuuchuu,         ja, n3, word, jmdict_kanji('空中')).
pick(w_shokunin,        ja, n3, word, jmdict_kanji('職人')).
pick(w_shokumotsu,      ja, n3, word, jmdict('1358620')).  % しょくもつ food; foodstuff
pick(w_teire,           ja, n3, word, jmdict_kanji('手入れ')).
pick(w_yoki,            ja, n3, word, jmdict_kanji('予期')).
pick(w_ashidome,        ja, n3, word, jmdict_kanji('足止め')).
pick(w_keiyu,           ja, n3, word, jmdict_kanji('経由')).
pick(w_chakuyou,        ja, n3, word, jmdict_kanji('着用')).
pick(w_sakaba,          ja, n3, word, jmdict_kanji('酒場')).
pick(w_munou,           ja, n3, word, jmdict_kanji('無能')).
pick(w_zenmen,          ja, n3, word, jmdict_kanji('全面')).
pick(w_kouji,           ja, n3, word, jmdict_kanji('工事')).
pick(w_chijin,          ja, n3, word, jmdict_kanji('知人')).
pick(w_honne,           ja, n3, word, jmdict_kanji('本音')).
pick(w_taichou,         ja, n3, word, jmdict_kanji('体調')).
pick(w_jouriku,         ja, n3, word, jmdict_kanji('上陸')).
pick(w_yakuhin,         ja, n3, word, jmdict_kanji('薬品')).
pick(w_rakka,           ja, n3, word, jmdict_kanji('落下')).
pick(w_zokkou,          ja, n3, word, jmdict_kanji('続行')).
pick(w_hakkou,          ja, n3, word, jmdict_kanji('発行')).
pick(w_ooini,           ja, n3, word, jmdict_kanji('大いに')).
pick(w_yakunin,         ja, n3, word, jmdict_kanji('役人')).
pick(w_kairyou,         ja, n3, word, jmdict_kanji('改良')).
pick(w_houshutsu,       ja, n3, word, jmdict_kanji('放出')).
pick(w_shudou,          ja, n3, word, jmdict_kanji('手動')).
pick(w_koubutsu,        ja, n3, word, jmdict_kanji('好物')).
pick(w_jitsuryoku,      ja, n3, word, jmdict_kanji('実力')).
pick(w_yuuryoku,        ja, n3, word, jmdict_kanji('有力')).
pick(w_sumai,           ja, n3, word, jmdict_kanji('住まい')).
pick(w_nasake,          ja, n3, word, jmdict_kanji('情け')).
pick(w_sokumen,         ja, n3, word, jmdict_kanji('側面')).
pick(w_jintai,          ja, n3, word, jmdict('1368670')).  % じんたい human body
pick(w_shutsugen,       ja, n3, word, jmdict_kanji('出現')).
pick(w_jisshuu,         ja, n3, word, jmdict_kanji('実習')).
pick(w_kyouyou,         ja, n3, word, jmdict_kanji('強要')).
pick(w_shinnyuu,        ja, n3, word, jmdict_kanji('進入')).
pick(w_mochiba,         ja, n3, word, jmdict_kanji('持ち場')).
pick(w_kisei,           ja, n3, word, jmdict_kanji('規制')).
pick(w_tairiku,         ja, n3, word, jmdict_kanji('大陸')).
pick(w_daichi,          ja, n3, word, jmdict_kanji('大地')).
pick(w_seitai,          ja, n3, word, jmdict_kanji('生体')).
pick(w_miyage,          ja, n3, word, jmdict('1445360')).  % みやげ local specialty or souvenir bought as a gift whi
pick(w_shison,          ja, n3, word, jmdict_kanji('子孫')).
pick(w_inyou,           ja, n3, word, jmdict_kanji('引用')).
pick(w_hitome,          ja, n3, word, jmdict('1166950')).  % ひとめ glance; look; glimpse
pick(w_nagaiki,         ja, n3, word, jmdict_kanji('長生き')).
pick(w_taiketsu,        ja, n3, word, jmdict_kanji('対決')).
pick(w_shuyaku,         ja, n3, word, jmdict_kanji('主役')).
pick(w_byoudou,         ja, n3, word, jmdict_kanji('平等')).
pick(w_bunshou,         ja, n3, word, jmdict_kanji('文章')).
pick(w_jishu,           ja, n3, word, jmdict_kanji('自首')).
pick(w_hondai,          ja, n3, word, jmdict_kanji('本題')).
pick(w_rojou,           ja, n3, word, jmdict('1612340')).  % ろじょう on the road; on the street; in the street
pick(w_bukken,          ja, n3, word, jmdict_kanji('物件')).
pick(w_ninmei,          ja, n3, word, jmdict_kanji('任命')).
pick(w_kibarashi,       ja, n3, word, jmdict_kanji('気晴らし')).
pick(w_taihan,          ja, n3, word, jmdict_kanji('大半')).
pick(w_saishou,         ja, n3, word, jmdict_kanji('最小')).
pick(w_meichuu,         ja, n3, word, jmdict_kanji('命中')).
pick(w_kiyou,           ja, n3, word, jmdict_kanji('器用')).
pick(w_seisaku,         ja, n3, word, jmdict_kanji('制作')).
pick(w_enshutsu,        ja, n3, word, jmdict_kanji('演出')).
pick(w_shiritsu,        ja, n3, word, jmdict_kanji('私立')).
pick(w_kitei,           ja, n3, word, jmdict_kanji('規定')).
pick(w_shutsuryoku,     ja, n3, word, jmdict_kanji('出力')).
pick(w_hidarite,        ja, n3, word, jmdict('1290900')).  % ひだりて left hand; left-hand side; left-hand direction
pick(w_midoriiro,       ja, n3, word, jmdict_kanji('緑色')).
pick(w_sashizu,         ja, n3, word, jmdict_kanji('指図')).
pick(w_seibi,           ja, n3, word, jmdict_kanji('整備')).
pick(w_taiiku,          ja, n3, word, jmdict_kanji('体育')).
pick(w_toubu,           ja, n3, word, jmdict_kanji('頭部')).
pick(w_kotori,          ja, n3, word, jmdict_kanji('小鳥')).
pick(w_soukyuu,         ja, n3, word, jmdict_kanji('早急')).
pick(w_enshuu,          ja, n3, word, jmdict_kanji('演習')).
pick(w_sankaku,         ja, n3, word, jmdict_kanji('三角')).
pick(w_warukuchi,       ja, n3, word, jmdict('1575730')).  % わるくち (verbal) abuse; speaking ill of people; bad-mout
pick(w_tejina,          ja, n3, word, jmdict_kanji('手品')).
pick(w_shousuu,         ja, n3, word, jmdict_kanji('少数')).
pick(w_teate,           ja, n3, word, jmdict_kanji('手当')).
pick(w_tsuukou,         ja, n3, word, jmdict_kanji('通行')).
pick(w_kenmon,          ja, n3, word, jmdict_kanji('検問')).
pick(w_byounin,         ja, n3, word, jmdict_kanji('病人')).
pick(w_rakugaki,        ja, n3, word, jmdict_kanji('落書き')).
pick(w_dousei,          ja, n3, word, jmdict_kanji('同性')).
pick(w_gattai,          ja, n3, word, jmdict_kanji('合体')).
pick(w_issen,           ja, n3, word, jmdict_kanji('一線')).
pick(w_hokusei,         ja, n3, word, jmdict_kanji('北西')).
pick(w_daihon,          ja, n3, word, jmdict_kanji('台本')).
pick(w_koujitsu,        ja, n3, word, jmdict_kanji('口実')).
pick(w_kinyuu,          ja, n3, word, jmdict_kanji('記入')).
pick(w_betsumei,        ja, n3, word, jmdict_kanji('別名')).
pick(w_mangaichi,       ja, n3, word, jmdict_kanji('万が一')).
pick(w_ouzoku,          ja, n3, word, jmdict_kanji('王族')).
pick(w_sakihodo,        ja, n3, word, jmdict_kanji('先ほど')).
pick(w_kouryuu,         ja, n3, word, jmdict_kanji('交流')).
pick(w_banzen,          ja, n3, word, jmdict_kanji('万全')).
pick(w_iibun,           ja, n3, word, jmdict_kanji('言い分')).
pick(w_yasuragi,        ja, n3, word, jmdict_kanji('安らぎ')).
pick(w_kyoudan,         ja, n3, word, jmdict_kanji('教団')).
pick(w_monooto,         ja, n3, word, jmdict_kanji('物音')).
pick(w_chuugaku,        ja, n3, word, jmdict_kanji('中学')).
pick(w_oyako,           ja, n3, word, jmdict_kanji('親子')).
pick(w_jisoku,          ja, n3, word, jmdict_kanji('時速')).
pick(w_tenken,          ja, n3, word, jmdict_kanji('点検')).
pick(w_bunbetsu,        ja, n3, word, jmdict('1504200')).  % ぶんべつ separation (e.g. of rubbish when recycling); cla
pick(w_rakuen,          ja, n3, word, jmdict_kanji('楽園')).
pick(w_chuunyuu,        ja, n3, word, jmdict_kanji('注入')).
pick(w_kaiin,           ja, n3, word, jmdict_kanji('会員')).
pick(w_jinji,           ja, n3, word, jmdict('1367870')).  % じんじ human affairs; mundane matters; things human
pick(w_nenkin,          ja, n3, word, jmdict_kanji('年金')).
pick(w_danchou,         ja, n3, word, jmdict_kanji('団長')).
pick(w_keisei,          ja, n3, word, jmdict_kanji('形成')).
pick(w_kakutei,         ja, n3, word, jmdict_kanji('確定')).
pick(w_kaite,           ja, n3, word, jmdict_kanji('買い手')).
pick(w_ashikubi,        ja, n3, word, jmdict_kanji('足首')).
pick(w_haisen,          ja, n3, word, jmdict_kanji('配線')).
pick(w_honshou,         ja, n3, word, jmdict_kanji('本性')).
pick(w_mugai,           ja, n3, word, jmdict_kanji('無害')).
pick(w_kuchidashi,      ja, n3, word, jmdict_kanji('口出し')).
pick(w_kaitou,          ja, n3, word, jmdict_kanji('回答')).
pick(w_genshou,         ja, n3, word, jmdict_kanji('減少')).
pick(w_daikin,          ja, n3, word, jmdict_kanji('代金')).
pick(w_jikka,           ja, n3, word, jmdict_kanji('実家')).
pick(w_seishitsu,       ja, n3, word, jmdict_kanji('性質')).
pick(w_hiyake,          ja, n3, word, jmdict_kanji('日焼け')).
pick(w_nishigawa,       ja, n3, word, jmdict_kanji('西側')).
pick(w_kain,            ja, n3, word, jmdict_kanji('下院')).
pick(w_seibu,           ja, n3, word, jmdict_kanji('西部')).
pick(w_jiin,            ja, n3, word, jmdict_kanji('寺院')).
pick(w_kayaku,          ja, n3, word, jmdict_kanji('火薬')).
pick(w_senshi,          ja, n3, word, jmdict_kanji('戦死')).
pick(w_akuji,           ja, n3, word, jmdict_kanji('悪事')).
pick(w_shougo,          ja, n3, word, jmdict_kanji('正午')).
pick(w_ichiya,          ja, n3, word, jmdict_kanji('一夜')).
pick(w_tehon,           ja, n3, word, jmdict_kanji('手本')).
pick(w_gehin,           ja, n3, word, jmdict_kanji('下品')).
pick(w_kaika,           ja, n3, word, jmdict_kanji('階下')).
pick(w_kouhan,          ja, n3, word, jmdict_kanji('後半')).
pick(w_tokai,           ja, n3, word, jmdict_kanji('都会')).
pick(w_kannen,          ja, n3, word, jmdict_kanji('観念')).
pick(w_muchi,           ja, n3, word, jmdict_kanji('無知')).
pick(w_kidori,          ja, n3, word, jmdict_kanji('気取り')).
pick(w_noumin,          ja, n3, word, jmdict_kanji('農民')).
pick(w_kenzen,          ja, n3, word, jmdict_kanji('健全')).
pick(w_kachime,         ja, n3, word, jmdict_kanji('勝ち目')).
pick(w_ichimi,          ja, n3, word, jmdict('1166800')).  % いちみ clan; partisans; conspirators
pick(w_kougyou,         ja, n3, word, jmdict_kanji('工業')).
pick(w_shouhi,          ja, n3, word, jmdict_kanji('消費')).
pick(w_biyou,           ja, n3, word, jmdict_kanji('美容')).
pick(w_senin,           ja, n3, word, jmdict_kanji('船員')).
pick(w_aisou,           ja, n3, word, jmdict_kanji('愛想')).
pick(w_anji,            ja, n3, word, jmdict_kanji('暗示')).
pick(w_hokutou,         ja, n3, word, jmdict_kanji('北東')).
pick(w_seibun,          ja, n3, word, jmdict_kanji('成分')).
pick(w_yougo,           ja, n3, word, jmdict_kanji('用語')).
pick(w_suichuu,         ja, n3, word, jmdict_kanji('水中')).
pick(w_musuu,           ja, n3, word, jmdict_kanji('無数')).
pick(w_tani,            ja, n3, word, jmdict_kanji('単位')).
pick(w_shusshi,         ja, n3, word, jmdict_kanji('出資')).
pick(w_medama,          ja, n3, word, jmdict_kanji('目玉')).
pick(w_fukaketsu,       ja, n3, word, jmdict_kanji('不可欠')).
pick(w_saijou,          ja, n3, word, jmdict_kanji('最上')).
pick(w_kimagure,        ja, n3, word, jmdict_kanji('気まぐれ')).
pick(w_douitsu,         ja, n3, word, jmdict_kanji('同一')).
pick(w_tairyoku,        ja, n3, word, jmdict_kanji('体力')).
pick(w_kengaku,         ja, n3, word, jmdict_kanji('見学')).
pick(w_nakigoe,         ja, n3, word, jmdict_kanji('鳴き声')).
pick(w_yarinaoshi,      ja, n3, word, jmdict_kanji('やり直し')).
pick(w_kakuchi,         ja, n3, word, jmdict_kanji('各地')).
pick(w_aratamete,       ja, n3, word, jmdict_kanji('改めて')).
pick(w_fukakai,         ja, n3, word, jmdict_kanji('不可解')).
pick(w_ryoudo,          ja, n3, word, jmdict_kanji('領土')).
pick(w_kikin,           ja, n3, word, jmdict_kanji('基金')).
pick(w_ichimen,         ja, n3, word, jmdict_kanji('一面')).
pick(w_nini,            ja, n3, word, jmdict_kanji('任意')).
pick(w_teashi,          ja, n3, word, jmdict_kanji('手足')).
pick(w_temoto,          ja, n3, word, jmdict_kanji('手元')).
pick(w_kizai,           ja, n3, word, jmdict_kanji('機材')).
pick(w_kansetsu,        ja, n3, word, jmdict_kanji('関節')).
pick(w_kappatsu,        ja, n3, word, jmdict_kanji('活発')).
pick(w_kousen,          ja, n3, word, jmdict_kanji('光線')).
pick(w_shoshin,         ja, n3, word, jmdict('1342850')).  % しょしん one's original intention; one's initial enthusia
pick(w_anoyo,           ja, n3, word, jmdict_kanji('あの世')).
pick(w_oomukashi,       ja, n3, word, jmdict_kanji('大昔')).
pick(w_gakuen,          ja, n3, word, jmdict_kanji('学園')).
pick(w_minamigawa,      ja, n3, word, jmdict_kanji('南側')).
pick(w_sharin,          ja, n3, word, jmdict_kanji('車輪')).
pick(w_oui,             ja, n3, word, jmdict_kanji('王位')).
pick(w_tatsujin,        ja, n3, word, jmdict_kanji('達人')).
pick(w_sougou,          ja, n3, word, jmdict_kanji('総合')).
pick(w_chuukan,         ja, n3, word, jmdict('1423680')).  % ちゅうかん middle; midway; halfway
pick(w_zaiko,           ja, n3, word, jmdict_kanji('在庫')).
pick(w_kaseki,          ja, n3, word, jmdict_kanji('化石')).
pick(w_kyuusen,         ja, n3, word, jmdict_kanji('休戦')).
pick(w_shukumei,        ja, n3, word, jmdict_kanji('宿命')).
pick(w_muriyari,        ja, n3, word, jmdict_kanji('無理やり')).
pick(w_kunshu,          ja, n3, word, jmdict_kanji('君主')).
pick(w_houmen,          ja, n3, word, jmdict_kanji('方面')).
pick(w_gouin,           ja, n3, word, jmdict_kanji('強引')).
pick(w_shinzoku,        ja, n3, word, jmdict('1365270')).  % しんぞく relative; relation; kin
pick(w_dentatsu,        ja, n3, word, jmdict_kanji('伝達')).
pick(w_raikyaku,        ja, n3, word, jmdict_kanji('来客')).
pick(w_kinka,           ja, n3, word, jmdict_kanji('金貨')).
pick(w_douryoku,        ja, n3, word, jmdict_kanji('動力')).
pick(w_muhou,           ja, n3, word, jmdict_kanji('無法')).
pick(w_dourui,          ja, n3, word, jmdict_kanji('同類')).
pick(w_ittei,           ja, n3, word, jmdict('1164950')).  % いってい to fix; to settle; to standardize
pick(w_kakuritsu,       ja, n3, word, jmdict_kanji('確立')).
pick(w_nariyuki,        ja, n3, word, jmdict_kanji('成り行き')).
pick(w_adana,           ja, n3, word, jmdict_kanji('あだ名')).
pick(w_tsumasaki,       ja, n3, word, jmdict_kanji('つま先')).
pick(w_fui,             ja, n3, word, jmdict_kanji('不意')).
pick(w_bannin,          ja, n3, word, jmdict_kanji('番人')).
pick(w_douten,          ja, n3, word, jmdict_kanji('動転')).
pick(w_shikumi,         ja, n3, word, jmdict_kanji('仕組み')).
pick(w_futou,           ja, n3, word, jmdict_kanji('不当')).
pick(w_nansei,          ja, n3, word, jmdict_kanji('南西')).
pick(w_konpon,          ja, n3, word, jmdict('2848289')).  % こんぽん root; source; origin
pick(w_jiriki,          ja, n3, word, jmdict_kanji('自力')).
pick(w_hitokuchi,       ja, n3, word, jmdict_kanji('一口')).
pick(w_kakuji,          ja, n3, word, jmdict_kanji('各自')).
pick(w_douri,           ja, n3, word, jmdict_kanji('道理')).
pick(w_tesaki,          ja, n3, word, jmdict_kanji('手先')).
pick(w_kyougi,          ja, n3, word, jmdict_kanji('協議')).
pick(w_keihi,           ja, n3, word, jmdict_kanji('経費')).
pick(w_gensoku,         ja, n3, word, jmdict_kanji('減速')).
pick(w_jikkan,          ja, n3, word, jmdict_kanji('実感')).
pick(w_sumiyaka,        ja, n3, word, jmdict_kanji('速やか')).
pick(w_yuugai,          ja, n3, word, jmdict_kanji('有害')).
pick(w_murabito,        ja, n3, word, jmdict_kanji('村人')).
pick(w_denryuu,         ja, n3, word, jmdict_kanji('電流')).
pick(w_fukuyou,         ja, n3, word, jmdict_kanji('服用')).
pick(w_mukuchi,         ja, n3, word, jmdict('1529940')).  % むくち taciturn; reticent; quiet
pick(w_tesuu,           ja, n3, word, jmdict_kanji('手数')).
pick(w_hitoribocchi,    ja, n3, word, jmdict_kanji('一人ぼっち')).
pick(w_chuuritsu,       ja, n3, word, jmdict('1425540')).  % ちゅうりつ neutrality
pick(w_denpou,          ja, n3, word, jmdict_kanji('電報')).
pick(w_daiyaku,         ja, n3, word, jmdict_kanji('代役')).
pick(w_mendan,          ja, n3, word, jmdict_kanji('面談')).
pick(w_asameshi,        ja, n3, word, jmdict_kanji('朝飯')).
pick(w_umaretsuki,      ja, n3, word, jmdict_kanji('生まれつき')).
pick(w_juni,            ja, n3, word, jmdict_kanji('順位')).
pick(w_douseki,         ja, n3, word, jmdict_kanji('同席')).
pick(w_zenrei,          ja, n3, word, jmdict_kanji('前例')).
pick(w_ouyou,           ja, n3, word, jmdict_kanji('応用')).
pick(w_ryuuketsu,       ja, n3, word, jmdict_kanji('流血')).
pick(w_oudan,           ja, n3, word, jmdict_kanji('横断')).
pick(w_kousai,          ja, n3, word, jmdict_kanji('交際')).
pick(w_banji,           ja, n3, word, jmdict_kanji('万事')).
pick(w_chian,           ja, n3, word, jmdict('1316840')).  % ちあん public order; public peace; public security
pick(w_hinshitsu,       ja, n3, word, jmdict_kanji('品質')).
pick(w_shukkoku,        ja, n3, word, jmdict_kanji('出国')).
pick(w_nikkou,          ja, n3, word, jmdict_kanji('日光')).
pick(w_hitomae,         ja, n3, word, jmdict('1368490')).  % ひとまえ presence of other people; (in) public; (in) fron
pick(w_shuuketsu,       ja, n3, word, jmdict_kanji('終結')).
pick(w_shusshou,        ja, n3, word, jmdict_kanji('出生')).
pick(w_hondo,           ja, n3, word, jmdict_kanji('本土')).
pick(w_yuubou,          ja, n3, word, jmdict_kanji('有望')).
pick(w_chichuu,         ja, n3, word, jmdict_kanji('地中')).
pick(w_ashioto,         ja, n3, word, jmdict_kanji('足音')).
pick(w_saisoku,         ja, n3, word, jmdict_kanji('最速')).
pick(w_yuusha,          ja, n3, word, jmdict_kanji('勇者')).
pick(w_tanki,           ja, n3, word, jmdict_kanji('短気')).
pick(w_tokuten,         ja, n3, word, jmdict_kanji('得点')).
pick(w_tounyuu,         ja, n3, word, jmdict_kanji('投入')).
pick(w_mudan,           ja, n3, word, jmdict_kanji('無断')).
pick(w_doukyuu,         ja, n3, word, jmdict_kanji('同級')).
pick(w_sentai,          ja, n3, word, jmdict_kanji('船体')).
pick(w_migawari,        ja, n3, word, jmdict_kanji('身代わり')).
pick(w_hitoiki,         ja, n3, word, jmdict_kanji('一息')).
pick(w_kanden,          ja, n3, word, jmdict_kanji('感電')).
pick(w_jouyaku,         ja, n3, word, jmdict_kanji('条約')).
pick(w_shutsujou,       ja, n3, word, jmdict('1339220')).  % しゅつじょう participation (in a tournament, match, race, etc
pick(w_tousen,          ja, n3, word, jmdict_kanji('当選')).
pick(w_unyou,           ja, n3, word, jmdict_kanji('運用')).
pick(w_sakkyoku,        ja, n3, word, jmdict_kanji('作曲')).
pick(w_hansuu,          ja, n3, word, jmdict_kanji('半数')).
pick(w_toubun,          ja, n3, word, jmdict_kanji('当分')).
pick(w_jirei,           ja, n3, word, jmdict_kanji('事例')).
pick(w_shousoku,        ja, n3, word, jmdict_kanji('消息')).
pick(w_tehajime,        ja, n3, word, jmdict_kanji('手始め')).
pick(w_kaishou,         ja, n3, word, jmdict_kanji('解消')).
pick(w_keishiki,        ja, n3, word, jmdict_kanji('形式')).
pick(w_shinsaku,        ja, n3, word, jmdict_kanji('新作')).
pick(w_zengo,           ja, n3, word, jmdict('1392910')).  % ぜんご front and rear; front and back; before and behin
pick(w_seijin,          ja, n3, word, jmdict_kanji('成人')).
pick(w_koudai,          ja, n3, word, jmdict_kanji('広大')).
pick(w_rakkan,          ja, n3, word, jmdict_kanji('楽観')).
pick(w_mizugi,          ja, n3, word, jmdict_kanji('水着')).
pick(w_henkei,          ja, n3, word, jmdict_kanji('変形')).
pick(w_norimono,        ja, n3, word, jmdict_kanji('乗り物')).
pick(w_yasumono,        ja, n3, word, jmdict_kanji('安物')).
pick(w_bungaku,         ja, n3, word, jmdict_kanji('文学')).
pick(w_hassou,          ja, n3, word, jmdict_kanji('発想')).
pick(w_souchou,         ja, n3, word, jmdict_kanji('早朝')).
pick(w_seinou,          ja, n3, word, jmdict_kanji('性能')).
pick(w_nantou,          ja, n3, word, jmdict_kanji('南東')).
pick(w_kenbutsu,        ja, n3, word, jmdict('1260000')).  % けんぶつ sightseeing; watching; viewing
pick(w_jousha,          ja, n3, word, jmdict_kanji('乗車')).
pick(w_shuutoku,        ja, n3, word, jmdict_kanji('習得')).
pick(w_shoushitsu,      ja, n3, word, jmdict_kanji('消失')).
pick(w_keiki,           ja, n3, word, jmdict_kanji('景気')).
pick(w_zenjitsu,        ja, n3, word, jmdict_kanji('前日')).
pick(w_nyuujou,         ja, n3, word, jmdict_kanji('入場')).
pick(w_zaijuu,          ja, n3, word, jmdict_kanji('在住')).
pick(w_tezukuri,        ja, n3, word, jmdict_kanji('手作り')).
pick(w_chouwa,          ja, n3, word, jmdict_kanji('調和')).
pick(w_saibu,           ja, n3, word, jmdict_kanji('細部')).
pick(w_oushitsu,        ja, n3, word, jmdict_kanji('王室')).
pick(w_oootoko,         ja, n3, word, jmdict_kanji('大男')).
pick(w_shuhou,          ja, n3, word, jmdict_kanji('手法')).
pick(w_gakuchou,        ja, n3, word, jmdict_kanji('学長')).
pick(w_ogawa,           ja, n3, word, jmdict_kanji('小川')).
pick(w_ryuushutsu,      ja, n3, word, jmdict_kanji('流出')).
pick(w_riten,           ja, n3, word, jmdict_kanji('利点')).
pick(w_oodoori,         ja, n3, word, jmdict_kanji('大通り')).
pick(w_ryousha,         ja, n3, word, jmdict_kanji('両者')).
pick(w_kigu,            ja, n3, word, jmdict_kanji('器具')).
pick(w_utagoe,          ja, n3, word, jmdict_kanji('歌声')).
pick(w_hitsuzen,        ja, n3, word, jmdict_kanji('必然')).
pick(w_machinaka,       ja, n3, word, jmdict('1611620')).  % まちなか downtown
pick(w_kimae,           ja, n3, word, jmdict_kanji('気前')).
pick(w_yokodori,        ja, n3, word, jmdict_kanji('横取り')).
pick(w_hantei,          ja, n3, word, jmdict_kanji('判定')).
pick(w_shikai,          ja, n3, word, jmdict_kanji('司会')).
pick(w_jinmei,          ja, n3, word, jmdict_kanji('人命')).
pick(w_nobanashi,       ja, n3, word, jmdict_kanji('野放し')).
pick(w_sendou,          ja, n3, word, jmdict_kanji('先導')).
pick(w_oote,            ja, n3, word, jmdict('1414010')).  % おおて major company; big company; front castle gate
pick(w_souki,           ja, n3, word, jmdict_kanji('早期')).
pick(w_uriage,          ja, n3, word, jmdict_kanji('売り上げ')).
pick(w_dokusha,         ja, n3, word, jmdict_kanji('読者')).
pick(w_ouja,            ja, n3, word, jmdict_kanji('王者')).
pick(w_chuuko,          ja, n3, word, jmdict_kanji('中古')).
pick(w_touka,           ja, n3, word, jmdict_kanji('投下')).
pick(w_kyoubai,         ja, n3, word, jmdict_kanji('競売')).
pick(w_suihei,          ja, n3, word, jmdict_kanji('水平')).
pick(w_jisan,           ja, n3, word, jmdict_kanji('持参')).
pick(w_hinode,          ja, n3, word, jmdict_kanji('日の出')).
pick(w_souou,           ja, n3, word, jmdict_kanji('相応')).
pick(w_gakui,           ja, n3, word, jmdict_kanji('学位')).
pick(w_hoshu,           ja, n3, word, jmdict_kanji('保守')).
pick(w_jindou,          ja, n3, word, jmdict_kanji('人道')).
pick(w_sakumotsu,       ja, n3, word, jmdict('1297950')).  % さくもつ crop; crops; (agricultural) produce
pick(w_chokkou,         ja, n3, word, jmdict_kanji('直行')).
pick(w_ganmen,          ja, n3, word, jmdict_kanji('顔面')).
pick(w_hakka,           ja, n3, word, jmdict_kanji('発火')).
pick(w_shibutsu,        ja, n3, word, jmdict_kanji('私物')).
pick(w_shihon,          ja, n3, word, jmdict_kanji('資本')).
pick(w_kazan,           ja, n3, word, jmdict_kanji('火山')).
pick(w_sekitan,         ja, n3, word, jmdict_kanji('石炭')).
pick(w_sacchi,          ja, n3, word, jmdict_kanji('察知')).
pick(w_hinata,          ja, n3, word, jmdict('1464050')).  % ひなた sunny place; in the sun
pick(w_kinshin,         ja, n3, word, jmdict_kanji('近親')).
pick(w_kakkoku,         ja, n3, word, jmdict_kanji('各国')).
pick(w_kounin,          ja, n3, word, jmdict_kanji('後任')).
pick(w_jiritsu,         ja, n3, word, jmdict_kanji('自立')).
pick(w_kyakkan,         ja, n3, word, jmdict_kanji('客観')).
pick(w_suibun,          ja, n3, word, jmdict_kanji('水分')).
pick(w_hyouhon,         ja, n3, word, jmdict_kanji('標本')).
pick(w_toudai,          ja, n3, word, jmdict_kanji('灯台')).
pick(w_hayaoki,         ja, n3, word, jmdict_kanji('早起き')).
pick(w_byouteki,        ja, n3, word, jmdict_kanji('病的')).
pick(w_yodooshi,        ja, n3, word, jmdict_kanji('夜通し')).
pick(w_goukei,          ja, n3, word, jmdict_kanji('合計')).
pick(w_shikyuu,         ja, n3, word, jmdict_kanji('支給')).
pick(w_tokuyuu,         ja, n3, word, jmdict_kanji('特有')).
pick(w_byoushitsu,      ja, n3, word, jmdict_kanji('病室')).
pick(w_shinjou,         ja, n3, word, jmdict_kanji('信条')).
pick(w_haikan,          ja, n3, word, jmdict_kanji('配管')).
pick(w_haisou,          ja, n3, word, jmdict_kanji('配送')).
pick(w_benjo,           ja, n3, word, jmdict('1512520')).  % べんじょ toilet; lavatory; water closet
pick(w_kiritsu,         ja, n3, word, jmdict_kanji('起立')).
pick(w_raise,           ja, n3, word, jmdict_kanji('来世')).
pick(w_toumen,          ja, n3, word, jmdict_kanji('当面')).
pick(w_kikou,           ja, n3, word, jmdict_kanji('気候')).
pick(w_yochi,           ja, n3, word, jmdict_kanji('予知')).
pick(w_jouryuu,         ja, n3, word, jmdict_kanji('上流')).
pick(w_zeikan,          ja, n3, word, jmdict_kanji('税関')).
pick(w_ouryou,          ja, n3, word, jmdict_kanji('横領')).
pick(w_massaki,         ja, n3, word, jmdict_kanji('真っ先')).
pick(w_ochitsuki,       ja, n3, word, jmdict_kanji('落ち着き')).
pick(w_toshitsuki,      ja, n3, word, jmdict_kanji('年月')).
pick(w_honi,            ja, n3, word, jmdict_kanji('本意')).
pick(w_taigun,          ja, n3, word, jmdict_kanji('大群')).
pick(w_onpa,            ja, n3, word, jmdict_kanji('音波')).
pick(w_katami,          ja, n3, word, jmdict_kanji('形見')).
pick(w_rakudai,         ja, n3, word, jmdict_kanji('落第')).
pick(w_hakushi,         ja, n3, word, jmdict_kanji('白紙')).
pick(w_koumu,           ja, n3, word, jmdict_kanji('公務')).
pick(w_sahou,           ja, n3, word, jmdict_kanji('作法')).
pick(w_nikushoku,       ja, n3, word, jmdict_kanji('肉食')).
pick(w_jikuu,           ja, n3, word, jmdict_kanji('時空')).
pick(w_noufu,           ja, n3, word, jmdict_kanji('農夫')).
pick(w_dounyuu,         ja, n3, word, jmdict_kanji('導入')).
pick(w_seishun,         ja, n3, word, jmdict_kanji('青春')).
pick(w_ittai,           ja, n3, word, jmdict_kanji('一帯')).
pick(w_jizoku,          ja, n3, word, jmdict_kanji('持続')).
pick(w_tsuukoku,        ja, n3, word, jmdict_kanji('通告')).
pick(w_tadai,           ja, n3, word, jmdict_kanji('多大')).
pick(w_yurai,           ja, n3, word, jmdict_kanji('由来')).
pick(w_nakaniwa,        ja, n3, word, jmdict_kanji('中庭')).
pick(w_heisei,          ja, n3, word, jmdict_kanji('平静')).
pick(w_seiretsu,        ja, n3, word, jmdict_kanji('整列')).
pick(w_heihou,          ja, n3, word, jmdict_kanji('平方')).
pick(w_fuukei,          ja, n3, word, jmdict_kanji('風景')).
pick(w_juuryou,         ja, n3, word, jmdict_kanji('重量')).
pick(w_hikan,           ja, n3, word, jmdict_kanji('悲観')).
pick(w_sougen,          ja, n3, word, jmdict_kanji('草原')).
pick(w_taryou,          ja, n3, word, jmdict_kanji('多量')).
pick(w_geshuku,         ja, n3, word, jmdict_kanji('下宿')).
pick(w_tegiwa,          ja, n3, word, jmdict_kanji('手際')).
pick(w_mihon,           ja, n3, word, jmdict_kanji('見本')).
pick(w_kinpen,          ja, n3, word, jmdict_kanji('近辺')).
pick(w_moushibun,       ja, n3, word, jmdict_kanji('申し分')).
pick(w_fuhei,           ja, n3, word, jmdict_kanji('不平')).
pick(w_kiryuu,          ja, n3, word, jmdict_kanji('気流')).
pick(w_chougou,         ja, n3, word, jmdict_kanji('調合')).
pick(w_reisen,          ja, n3, word, jmdict_kanji('冷戦')).
pick(w_rosen,           ja, n3, word, jmdict_kanji('路線')).
pick(w_genri,           ja, n3, word, jmdict_kanji('原理')).
pick(w_shuen,           ja, n3, word, jmdict_kanji('主演')).
pick(w_genryou,         ja, n3, word, jmdict_kanji('原料')).
pick(w_chuunen,         ja, n3, word, jmdict_kanji('中年')).
pick(w_urimono,         ja, n3, word, jmdict_kanji('売り物')).
pick(w_kashitsu,        ja, n3, word, jmdict_kanji('過失')).
pick(w_uketori,         ja, n3, word, jmdict_kanji('受け取り')).
pick(w_ashidori,        ja, n3, word, jmdict('1404830')).  % あしどり gait; walk; stride
pick(w_shinmai,         ja, n3, word, jmdict_kanji('新米')).
pick(w_hikitori,        ja, n3, word, jmdict_kanji('引き取り')).
pick(w_seisei,          ja, n3, word, jmdict('1379180')).  % せいせい creation; generation; formation
pick(w_oteage,          ja, n3, word, jmdict_kanji('お手上げ')).
pick(w_chakuchi,        ja, n3, word, jmdict_kanji('着地')).
pick(w_tsuuki,          ja, n3, word, jmdict_kanji('通気')).
pick(w_joutatsu,        ja, n3, word, jmdict_kanji('上達')).
pick(w_taiwa,           ja, n3, word, jmdict_kanji('対話')).
pick(w_hatsubai,        ja, n3, word, jmdict_kanji('発売')).
pick(w_shitsunai,       ja, n3, word, jmdict_kanji('室内')).
pick(w_ooguchi,         ja, n3, word, jmdict_kanji('大口')).
pick(w_katsuyou,        ja, n3, word, jmdict_kanji('活用')).
pick(w_shingaku,        ja, n3, word, jmdict_kanji('進学')).
pick(w_nakaba,          ja, n3, word, jmdict_kanji('半ば')).
pick(w_shinrui,         ja, n3, word, jmdict_kanji('親類')).
pick(w_manin,           ja, n3, word, jmdict_kanji('満員')).
pick(w_jisei,           ja, n3, word, jmdict_kanji('自制')).
pick(w_densen,          ja, n3, word, jmdict_kanji('電線')).
pick(w_miugoki,         ja, n3, word, jmdict_kanji('身動き')).
pick(w_toribun,         ja, n3, word, jmdict_kanji('取り分')).
pick(w_namaiki,         ja, n3, word, jmdict_kanji('生意気')).
pick(w_shuunen,         ja, n3, word, jmdict_kanji('周年')).
pick(w_kokuritsu,       ja, n3, word, jmdict_kanji('国立')).
pick(w_makki,           ja, n3, word, jmdict('1604040')).  % まっき last years; closing years; last days
pick(w_tokushuu,        ja, n3, word, jmdict_kanji('特集')).
pick(w_sokuhou,         ja, n3, word, jmdict_kanji('速報')).
pick(w_saihatsu,        ja, n3, word, jmdict_kanji('再発')).
pick(w_shanai,          ja, n3, word, jmdict_kanji('車内')).
pick(w_ippen,           ja, n3, word, jmdict_kanji('一変')).
pick(w_higashigawa,     ja, n3, word, jmdict_kanji('東側')).
pick(w_tokusei,         ja, n3, word, jmdict_kanji('特性')).
pick(w_keiri,           ja, n3, word, jmdict_kanji('経理')).
pick(w_gendou,          ja, n3, word, jmdict_kanji('言動')).
pick(w_tenchou,         ja, n3, word, jmdict_kanji('店長')).
pick(w_kaisui,          ja, n3, word, jmdict_kanji('海水')).
pick(w_jouren,          ja, n3, word, jmdict_kanji('常連')).
pick(w_yokoku,          ja, n3, word, jmdict_kanji('予告')).
pick(w_taika,           ja, n3, word, jmdict_kanji('対価')).
pick(w_kosodate,        ja, n3, word, jmdict_kanji('子育て')).
pick(w_kinai,           ja, n3, word, jmdict_kanji('機内')).
pick(w_ansei,           ja, n3, word, jmdict_kanji('安静')).
pick(w_ninsou,          ja, n3, word, jmdict_kanji('人相')).
pick(w_zenretsu,        ja, n3, word, jmdict_kanji('前列')).
pick(w_yosen,           ja, n3, word, jmdict_kanji('予選')).
pick(w_hendou,          ja, n3, word, jmdict_kanji('変動')).
pick(w_keiba,           ja, n3, word, jmdict('1234210')).  % けいば horse racing
pick(w_jinteki,         ja, n3, word, jmdict_kanji('人的')).
pick(w_kouki,           ja, n3, word, jmdict_kanji('好機')).
pick(w_gakunen,         ja, n3, word, jmdict_kanji('学年')).
pick(w_tokiori,         ja, n3, word, jmdict_kanji('時折')).
pick(w_shishitsu,       ja, n3, word, jmdict_kanji('資質')).
pick(w_gakuhi,          ja, n3, word, jmdict_kanji('学費')).
pick(w_tassha,          ja, n3, word, jmdict_kanji('達者')).
pick(w_kyouchou,        ja, n3, word, jmdict_kanji('強調')).
pick(w_onryou,          ja, n3, word, jmdict_kanji('音量')).
pick(w_senmen,          ja, n3, word, jmdict_kanji('洗面')).
pick(w_joryoku,         ja, n3, word, jmdict_kanji('助力')).
pick(w_minarai,         ja, n3, word, jmdict_kanji('見習い')).
pick(w_nendo,           ja, n3, word, jmdict_kanji('年度')).
pick(w_hyoumei,         ja, n3, word, jmdict_kanji('表明')).
pick(w_kaisuu,          ja, n3, word, jmdict_kanji('回数')).
pick(w_tenshu,          ja, n3, word, jmdict_kanji('店主')).
pick(w_sanbutsu,        ja, n3, word, jmdict_kanji('産物')).
pick(w_karate,          ja, n3, word, jmdict_kanji('空手')).
pick(w_fudan,           ja, n3, word, jmdict_kanji('不断')).
pick(w_ooatari,         ja, n3, word, jmdict_kanji('大当たり')).
pick(w_kougu,           ja, n3, word, jmdict_kanji('工具')).
pick(w_shisshin,        ja, n3, word, jmdict_kanji('失神')).
pick(w_hatsumimi,       ja, n3, word, jmdict_kanji('初耳')).
pick(w_kuchidome,       ja, n3, word, jmdict_kanji('口止め')).
pick(w_riji,            ja, n3, word, jmdict_kanji('理事')).
pick(w_joui,            ja, n3, word, jmdict_kanji('上位')).
pick(w_senkou,          ja, n3, word, jmdict_kanji('選考')).
pick(w_shinki,          ja, n3, word, jmdict_kanji('新規')).
pick(w_gunyou,          ja, n3, word, jmdict_kanji('軍用')).
pick(w_mumei,           ja, n3, word, jmdict_kanji('無名')).
pick(w_hakuchou,        ja, n3, word, jmdict('1475330')).  % はくちょう swan (Cygnus spp.); white bird
pick(w_chousetsu,       ja, n3, word, jmdict_kanji('調節')).
pick(w_keijou,          ja, n3, word, jmdict_kanji('形状')).
pick(w_sansuu,          ja, n3, word, jmdict_kanji('算数')).
pick(w_ichidan,         ja, n3, word, jmdict_kanji('一団')).
pick(w_heikou,          ja, n3, word, jmdict_kanji('平行')).
pick(w_butteki,         ja, n3, word, jmdict_kanji('物的')).
pick(w_maue,            ja, n3, word, jmdict_kanji('真上')).
pick(w_chihei,          ja, n3, word, jmdict_kanji('地平')).
pick(w_mawarimichi,     ja, n3, word, jmdict_kanji('回り道')).
pick(w_ikou,            ja, n3, word, jmdict_kanji('意向')).
pick(w_houshiki,        ja, n3, word, jmdict_kanji('方式')).
pick(w_jisshitsu,       ja, n3, word, jmdict_kanji('実質')).
pick(w_honkaku,         ja, n3, word, jmdict_kanji('本格')).
pick(w_meijin,          ja, n3, word, jmdict('1531680')).  % めいじん master; expert; Meijin (professional title)
pick(w_gyouji,          ja, n3, word, jmdict_kanji('行事')).
pick(w_dakai,           ja, n3, word, jmdict_kanji('打開')).
pick(w_suimen,          ja, n3, word, jmdict_kanji('水面')).
pick(w_taitou,          ja, n3, word, jmdict_kanji('対等')).
pick(w_byoujou,         ja, n3, word, jmdict_kanji('病状')).
pick(w_chokusen,        ja, n3, word, jmdict_kanji('直線')).
pick(w_naimen,          ja, n3, word, jmdict('1459290')).  % ないめん inside; interior; (within) one's mind
pick(w_jisa,            ja, n3, word, jmdict_kanji('時差')).
pick(w_bannou,          ja, n3, word, jmdict_kanji('万能')).
pick(w_okunai,          ja, n3, word, jmdict_kanji('屋内')).
pick(w_kenzai,          ja, n3, word, jmdict_kanji('健在')).
pick(w_atomawashi,      ja, n3, word, jmdict_kanji('後回し')).
pick(w_hanshin,         ja, n3, word, jmdict('1479480')).  % はんしん half the body; half length
pick(w_taishite,        ja, n3, word, jmdict_kanji('大して')).
pick(w_mokuba,          ja, n3, word, jmdict('1534820')).  % もくば wooden horse; rocking horse; vaulting horse
pick(w_maido,           ja, n3, word, jmdict_kanji('毎度')).
pick(w_ningyo,          ja, n3, word, jmdict_kanji('人魚')).
pick(w_kawarimono,      ja, n3, word, jmdict_kanji('変わり者')).
pick(w_iiarasoi,        ja, n3, word, jmdict_kanji('言い争い')).
pick(w_hitokui,         ja, n3, word, jmdict_kanji('人食い')).
pick(w_honsha,          ja, n3, word, jmdict_kanji('本社')).
pick(w_nicchuu,         ja, n3, word, jmdict('1464250')).  % にっちゅう daytime; during the day; Japan and China
pick(w_kakou,           ja, n3, word, jmdict_kanji('加工')).
pick(w_zenya,           ja, n3, word, jmdict_kanji('前夜')).
pick(w_dannen,          ja, n3, word, jmdict_kanji('断念')).
pick(w_tenshoku,        ja, n3, word, jmdict_kanji('転職')).
pick(w_shiyuu,          ja, n3, word, jmdict_kanji('私有')).
pick(w_kyokuin,         ja, n3, word, jmdict_kanji('局員')).
pick(w_doutou,          ja, n3, word, jmdict_kanji('同等')).
pick(w_kuuchou,         ja, n3, word, jmdict_kanji('空調')).
pick(w_jihatsu,         ja, n3, word, jmdict_kanji('自発')).
pick(w_iyaku,           ja, n3, word, jmdict_kanji('医薬')).
pick(w_yabou,           ja, n3, word, jmdict_kanji('野望')).
pick(w_yamawake,        ja, n3, word, jmdict_kanji('山分け')).
pick(w_ichido,          ja, n3, word, jmdict_kanji('一度')).
pick(w_tayou,           ja, n3, word, jmdict_kanji('多様')).
pick(w_geneki,          ja, n3, word, jmdict_kanji('現役')).
pick(w_kanten,          ja, n3, word, jmdict_kanji('観点')).
pick(w_mokuzen,         ja, n3, word, jmdict('1535540')).  % もくぜん before one's very eyes; under one's nose; immine
pick(w_shiteki,         ja, n3, word, jmdict('1311330')).  % してき private; personal
pick(w_kuuhaku,         ja, n3, word, jmdict_kanji('空白')).
pick(w_hakkaku,         ja, n3, word, jmdict_kanji('発覚')).
pick(w_bokou,           ja, n3, word, jmdict_kanji('母校')).
pick(w_chihyou,         ja, n3, word, jmdict_kanji('地表')).
pick(w_gaikan,          ja, n3, word, jmdict_kanji('外観')).
pick(w_kyakushitsu,     ja, n3, word, jmdict_kanji('客室')).
pick(w_taikaku,         ja, n3, word, jmdict_kanji('体格')).
pick(w_nouen,           ja, n3, word, jmdict_kanji('農園')).
pick(w_fuka,            ja, n3, word, jmdict_kanji('不可')).
pick(w_chakushu,        ja, n3, word, jmdict_kanji('着手')).
pick(w_kiniro,          ja, n3, word, jmdict_kanji('金色')).
pick(w_kessha,          ja, n3, word, jmdict_kanji('結社')).
pick(w_kousho,          ja, n3, word, jmdict_kanji('高所')).
pick(w_joushuu,         ja, n3, word, jmdict_kanji('常習')).
pick(w_kyuuyou,         ja, n3, word, jmdict_kanji('急用')).
pick(w_soutai,          ja, n3, word, jmdict('1401110')).  % そうたい relativity; relative; facing (e.g. a problem)
pick(w_ippuku,          ja, n3, word, jmdict_kanji('一服')).
pick(w_goujou,          ja, n3, word, jmdict_kanji('強情')).
pick(w_gyousei,         ja, n3, word, jmdict_kanji('行政')).
pick(w_hoyuu,           ja, n3, word, jmdict_kanji('保有')).
pick(w_sakusha,         ja, n3, word, jmdict_kanji('作者')).
pick(w_nankyoku,        ja, n3, word, jmdict_kanji('南極')).
pick(w_manten,          ja, n3, word, jmdict_kanji('満点')).
pick(w_shomen,          ja, n3, word, jmdict_kanji('書面')).
pick(w_zujou,           ja, n3, word, jmdict_kanji('頭上')).
pick(w_jouba,           ja, n3, word, jmdict_kanji('乗馬')).
pick(w_henshitsu,       ja, n3, word, jmdict_kanji('変質')).
pick(w_houi,            ja, n3, word, jmdict_kanji('方位')).
pick(w_tentou,          ja, n3, word, jmdict_kanji('点灯')).
pick(w_rakuchaku,       ja, n3, word, jmdict_kanji('落着')).
pick(w_shoutou,         ja, n3, word, jmdict_kanji('消灯')).
pick(w_chakuseki,       ja, n3, word, jmdict_kanji('着席')).
pick(w_kaisetsu,        ja, n3, word, jmdict_kanji('解説')).
pick(w_jouge,           ja, n3, word, jmdict('1352710')).  % じょうげ top and bottom; high and low; above and below
pick(w_zandaka,         ja, n3, word, jmdict_kanji('残高')).
pick(w_senji,           ja, n3, word, jmdict_kanji('戦時')).
pick(w_kyuumei,         ja, n3, word, jmdict_kanji('究明')).
pick(w_chiri,           ja, n3, word, jmdict_kanji('地理')).
pick(w_kajitsu,         ja, n3, word, jmdict_kanji('果実')).
pick(w_kigou,           ja, n3, word, jmdict_kanji('記号')).
pick(w_komono,          ja, n3, word, jmdict_kanji('小物')).
pick(w_akuyaku,         ja, n3, word, jmdict_kanji('悪役')).
pick(w_yanushi,         ja, n3, word, jmdict_kanji('家主')).
pick(w_onaidoshi,       ja, n3, word, jmdict_kanji('同い年')).
pick(w_funanori,        ja, n3, word, jmdict_kanji('船乗り')).
pick(w_hoken,           ja, n3, word, jmdict_kanji('保健')).
pick(w_jitsuyou,        ja, n3, word, jmdict_kanji('実用')).
pick(w_zendo,           ja, n3, word, jmdict_kanji('全土')).
pick(w_rittai,          ja, n3, word, jmdict_kanji('立体')).
pick(w_kukyou,          ja, n3, word, jmdict_kanji('苦境')).
pick(w_kiai,            ja, n3, word, jmdict_kanji('気合')).
pick(w_omotemuki,       ja, n3, word, jmdict_kanji('表向き')).
pick(w_shouryou,        ja, n3, word, jmdict_kanji('少量')).
pick(w_tegaki,          ja, n3, word, jmdict('1327830')).  % てがき handwriting; handwritten; hand-drawn
pick(w_shinnin,         ja, n3, word, jmdict_kanji('新任')).
pick(w_uchiwa,          ja, n3, word, jmdict('1459540')).  % うちわ family circle; one's circle (of friends, co-work
pick(w_hassha,          ja, n3, word, jmdict_kanji('発車')).
pick(w_iinari,          ja, n3, word, jmdict_kanji('言いなり')).
pick(w_kouhai,          ja, n3, word, jmdict_kanji('交配')).
pick(w_tewake,          ja, n3, word, jmdict_kanji('手分け')).
pick(w_kigakari,        ja, n3, word, jmdict_kanji('気がかり')).
pick(w_jimon,           ja, n3, word, jmdict_kanji('自問')).
pick(w_seiai,           ja, n3, word, jmdict_kanji('性愛')).
pick(w_zenhan,          ja, n3, word, jmdict_kanji('前半')).
pick(w_hatashite,       ja, n3, word, jmdict_kanji('果たして')).
pick(w_jikoku,          ja, n3, word, jmdict_kanji('自国')).
pick(w_jouei,           ja, n3, word, jmdict_kanji('上映')).
pick(w_seisoku,         ja, n3, word, jmdict_kanji('生息')).
pick(w_zoudai,          ja, n3, word, jmdict_kanji('増大')).
pick(w_shinsha,         ja, n3, word, jmdict_kanji('新車')).
pick(w_shoudan,         ja, n3, word, jmdict_kanji('商談')).
pick(w_shouka,          ja, n3, word, jmdict_kanji('消火')).
pick(w_kouzen,          ja, n3, word, jmdict_kanji('公然')).
pick(w_yuuyou,          ja, n3, word, jmdict_kanji('有用')).
pick(w_kaizan,          ja, n3, word, jmdict_kanji('改ざん')).
pick(w_bihin,           ja, n3, word, jmdict_kanji('備品')).
pick(w_tearai,          ja, n3, word, jmdict_kanji('手洗い')).
pick(w_nenshou,         ja, n3, word, jmdict_kanji('年少')).
pick(w_hitorihitori,    ja, n3, word, jmdict_kanji('一人一人')).
pick(w_sokuryoku,       ja, n3, word, jmdict_kanji('速力')).
pick(w_shinshutsu,      ja, n3, word, jmdict_kanji('進出')).
pick(w_gidai,           ja, n3, word, jmdict_kanji('議題')).
pick(w_kuchou,          ja, n3, word, jmdict_kanji('口調')).
pick(w_seiki,           ja, n3, word, jmdict_kanji('正規')).
pick(w_jitsugyou,       ja, n3, word, jmdict_kanji('実業')).
pick(w_seibetsu,        ja, n3, word, jmdict_kanji('性別')).
pick(w_bunsan,          ja, n3, word, jmdict_kanji('分散')).
pick(w_suigin,          ja, n3, word, jmdict_kanji('水銀')).
pick(w_kyoudo,          ja, n3, word, jmdict_kanji('強度')).
pick(w_shinjuu,         ja, n3, word, jmdict('1360840')).  % しんじゅう double suicide; lovers' suicide; group suicide
pick(w_kokorogamae,     ja, n3, word, jmdict_kanji('心構え')).
pick(w_meimei,          ja, n3, word, jmdict_kanji('命名')).
pick(w_hidariashi,      ja, n3, word, jmdict_kanji('左足')).
pick(w_aoiro,           ja, n3, word, jmdict_kanji('青色')).
pick(w_ryuusei,         ja, n3, word, jmdict_kanji('流星')).
pick(w_hidarikiki,      ja, n3, word, jmdict_kanji('左利き')).
pick(w_betsumono,       ja, n3, word, jmdict_kanji('別物')).
pick(w_hatoba,          ja, n3, word, jmdict_kanji('波止場')).
pick(w_aozora,          ja, n3, word, jmdict_kanji('青空')).
pick(w_mokusei,         ja, n3, word, jmdict_kanji('木星')).
pick(w_haishin,         ja, n3, word, jmdict_kanji('配信')).
pick(w_angai,           ja, n3, word, jmdict_kanji('案外')).
pick(w_okiba,           ja, n3, word, jmdict_kanji('置き場')).
pick(w_kingyo,          ja, n3, word, jmdict_kanji('金魚')).
pick(w_otokomae,        ja, n3, word, jmdict_kanji('男前')).
pick(w_migiashi,        ja, n3, word, jmdict_kanji('右足')).
pick(w_joi,             ja, n3, word, jmdict_kanji('女医')).
pick(w_raijou,          ja, n3, word, jmdict_kanji('来場')).
pick(w_yamazumi,        ja, n3, word, jmdict_kanji('山積み')).
pick(w_ryouchi,         ja, n3, word, jmdict_kanji('領地')).
pick(w_hozen,           ja, n3, word, jmdict_kanji('保全')).
pick(w_shougyou,        ja, n3, word, jmdict_kanji('商業')).
pick(w_torikeshi,       ja, n3, word, jmdict_kanji('取り消し')).
pick(w_miokuri,         ja, n3, word, jmdict_kanji('見送り')).
pick(w_niban,           ja, n3, word, jmdict_kanji('二番')).
pick(w_mugon,           ja, n3, word, jmdict('1529860')).  % むごん silence (not speaking); muteness
pick(w_gyouretsu,       ja, n3, word, jmdict_kanji('行列')).
pick(w_kyuusui,         ja, n3, word, jmdict_kanji('給水')).
pick(w_hanei,           ja, n3, word, jmdict_kanji('反映')).
pick(w_shinamono,       ja, n3, word, jmdict_kanji('品物')).
pick(w_yozora,          ja, n3, word, jmdict_kanji('夜空')).
pick(w_hairetsu,        ja, n3, word, jmdict_kanji('配列')).
pick(w_rikigaku,        ja, n3, word, jmdict_kanji('力学')).
pick(w_getsumen,        ja, n3, word, jmdict_kanji('月面')).
pick(w_ireba,           ja, n3, word, jmdict_kanji('入れ歯')).
pick(w_mesen,           ja, n3, word, jmdict_kanji('目線')).
pick(w_fuchaku,         ja, n3, word, jmdict_kanji('付着')).
pick(w_toomawari,       ja, n3, word, jmdict_kanji('遠回り')).
pick(w_yaei,            ja, n3, word, jmdict_kanji('野営')).
pick(w_akuyou,          ja, n3, word, jmdict_kanji('悪用')).
pick(w_zenshou,         ja, n3, word, jmdict_kanji('全焼')).
pick(w_rikujou,         ja, n3, word, jmdict_kanji('陸上')).
pick(w_kyouin,          ja, n3, word, jmdict_kanji('教員')).
pick(w_toukou,          ja, n3, word, jmdict_kanji('登校')).
pick(w_shudai,          ja, n3, word, jmdict_kanji('主題')).
pick(w_joubu,           ja, n3, word, jmdict_kanji('上部')).
pick(w_jakusha,         ja, n3, word, jmdict_kanji('弱者')).
pick(w_karyoku,         ja, n3, word, jmdict_kanji('火力')).
pick(w_kyouko,          ja, n3, word, jmdict_kanji('強固')).
pick(w_daimei,          ja, n3, word, jmdict_kanji('題名')).
pick(w_nagashi,         ja, n3, word, jmdict_kanji('流し')).
pick(w_tenmon,          ja, n3, word, jmdict('1440260')).  % てんもん astronomy
pick(w_hannichi,        ja, n3, word, jmdict_kanji('半日')).
pick(w_toshishita,      ja, n3, word, jmdict_kanji('年下')).
pick(w_nyuukin,         ja, n3, word, jmdict_kanji('入金')).
pick(w_bui,             ja, n3, word, jmdict_kanji('部位')).
pick(w_dantei,          ja, n3, word, jmdict_kanji('断定')).
pick(w_kuchisaki,       ja, n3, word, jmdict_kanji('口先')).
pick(w_nohara,          ja, n3, word, jmdict_kanji('野原')).
pick(w_taiko,           ja, n3, word, jmdict_kanji('太古')).
pick(w_michizure,       ja, n3, word, jmdict_kanji('道連れ')).
pick(w_shitagokoro,     ja, n3, word, jmdict_kanji('下心')).
pick(w_naisen,          ja, n3, word, jmdict_kanji('内戦')).
pick(w_goudou,          ja, n3, word, jmdict_kanji('合同')).
pick(w_ryuutsuu,        ja, n3, word, jmdict_kanji('流通')).
pick(w_geinou,          ja, n3, word, jmdict_kanji('芸能')).
pick(w_koutou,          ja, n3, word, jmdict_kanji('高等')).
pick(w_rigai,           ja, n3, word, jmdict_kanji('利害')).
pick(w_ikiiki,          ja, n3, word, jmdict_kanji('生き生き')).
pick(w_douchou,         ja, n3, word, jmdict_kanji('同調')).
pick(w_mikaku,          ja, n3, word, jmdict_kanji('味覚')).
pick(w_kishou,          ja, n3, word, jmdict_kanji('希少')).
pick(w_goukin,          ja, n3, word, jmdict_kanji('合金')).
pick(w_chishitsu,       ja, n3, word, jmdict('1421130')).  % ちしつ geological features
pick(w_isshin,          ja, n3, word, jmdict_kanji('一心')).
pick(w_arisama,         ja, n3, word, jmdict_kanji('有様')).
pick(w_noriki,          ja, n3, word, jmdict_kanji('乗り気')).
pick(w_jitsuwa,         ja, n3, word, jmdict_kanji('実話')).
pick(w_tokuchuu,        ja, n3, word, jmdict_kanji('特注')).
pick(w_hassan,          ja, n3, word, jmdict_kanji('発散')).
pick(w_houjin,          ja, n3, word, jmdict_kanji('法人')).
pick(w_gakkai,          ja, n3, word, jmdict_kanji('学会')).
pick(w_junji,           ja, n3, word, jmdict_kanji('順次')).
pick(w_kimete,          ja, n3, word, jmdict_kanji('決め手')).
pick(w_jittai,          ja, n3, word, jmdict('1321350')).  % じったい substance; essence; entity
pick(w_meiun,           ja, n3, word, jmdict_kanji('命運')).
pick(w_ichininmae,      ja, n3, word, jmdict_kanji('一人前')).
pick(w_dougyou,         ja, n3, word, jmdict_kanji('同業')).
pick(w_tenchi,          ja, n3, word, jmdict_kanji('天地')).
pick(w_kouten,          ja, n3, word, jmdict_kanji('好転')).
pick(w_sanretsu,        ja, n3, word, jmdict_kanji('参列')).
pick(w_zumen,           ja, n3, word, jmdict_kanji('図面')).
pick(w_kagyou,          ja, n3, word, jmdict('1191840')).  % かぎょう family business; family trade; one's occupation
pick(w_sakaya,          ja, n3, word, jmdict_kanji('酒屋')).
pick(w_yoken,           ja, n3, word, jmdict_kanji('予見')).
pick(w_manbiki,         ja, n3, word, jmdict_kanji('万引き')).
pick(w_henpin,          ja, n3, word, jmdict_kanji('返品')).
pick(w_kyuutai,         ja, n3, word, jmdict_kanji('球体')).
pick(w_shindo,          ja, n3, word, jmdict_kanji('深度')).
pick(w_menzen,          ja, n3, word, jmdict_kanji('面前')).
pick(w_ansoku,          ja, n3, word, jmdict_kanji('安息')).
pick(w_necchuu,         ja, n3, word, jmdict_kanji('熱中')).
pick(w_chokushin,       ja, n3, word, jmdict_kanji('直進')).
pick(w_uchiki,          ja, n3, word, jmdict_kanji('内気')).
pick(w_shotoku,         ja, n3, word, jmdict_kanji('所得')).
pick(w_fushin,          ja, n3, word, jmdict_kanji('不信')).
pick(w_senshin,         ja, n3, word, jmdict_kanji('先進')).
pick(w_ikusei,          ja, n3, word, jmdict_kanji('育成')).
pick(w_hacchuu,         ja, n3, word, jmdict_kanji('発注')).
pick(w_saisen,          ja, n3, word, jmdict_kanji('再選')).
pick(w_danchi,          ja, n3, word, jmdict_kanji('団地')).
pick(w_jihyou,          ja, n3, word, jmdict_kanji('辞表')).
pick(w_handou,          ja, n3, word, jmdict_kanji('反動')).
pick(w_itoguchi,        ja, n3, word, jmdict_kanji('糸口')).
pick(w_senketsu,        ja, n3, word, jmdict_kanji('先決')).
pick(w_kiryoku,         ja, n3, word, jmdict_kanji('気力')).
pick(w_oukyuu,          ja, n3, word, jmdict_kanji('応急')).
pick(w_juudo,           ja, n3, word, jmdict_kanji('重度')).
pick(w_fukami,          ja, n3, word, jmdict_kanji('深み')).
pick(w_tedate,          ja, n3, word, jmdict_kanji('手立て')).
pick(w_byouyomi,        ja, n3, word, jmdict_kanji('秒読み')).
pick(w_nyuukai,         ja, n3, word, jmdict('1465790')).  % にゅうかい admission (to a society, club, etc.); joining; e
pick(w_kuchigotae,      ja, n3, word, jmdict_kanji('口答え')).
pick(w_ikigai,          ja, n3, word, jmdict_kanji('生きがい')).
pick(w_genjuumin,       ja, n3, word, jmdict_kanji('原住民')).
pick(w_ichiri,          ja, n3, word, jmdict_kanji('一理')).
pick(w_muichimon,       ja, n3, word, jmdict_kanji('無一文')).
pick(w_kousou,          ja, n3, word, jmdict_kanji('構想')).
pick(w_kouteki,         ja, n3, word, jmdict_kanji('公的')).
pick(w_senshutsu,       ja, n3, word, jmdict_kanji('選出')).
pick(w_omomi,           ja, n3, word, jmdict_kanji('重み')).
pick(w_fuchou,          ja, n3, word, jmdict_kanji('不調')).
pick(w_kiyaku,          ja, n3, word, jmdict_kanji('規約')).
pick(w_bunpai,          ja, n3, word, jmdict_kanji('分配')).
pick(w_yakushoku,       ja, n3, word, jmdict_kanji('役職')).
pick(w_chikei,          ja, n3, word, jmdict_kanji('地形')).
pick(w_temochi,         ja, n3, word, jmdict_kanji('手持ち')).
pick(w_jouyou,          ja, n3, word, jmdict_kanji('常用')).
pick(w_menboku,         ja, n3, word, jmdict_kanji('面目')).
pick(w_shuchuu,         ja, n3, word, jmdict_kanji('手中')).
pick(w_hiruyasumi,      ja, n3, word, jmdict_kanji('昼休み')).
pick(w_miai,            ja, n3, word, jmdict_kanji('見合い')).
pick(w_shinpen,         ja, n3, word, jmdict_kanji('身辺')).
pick(w_iwayama,         ja, n3, word, jmdict_kanji('岩山')).
pick(w_tasha,           ja, n3, word, jmdict_kanji('他者')).
pick(w_nafuda,          ja, n3, word, jmdict_kanji('名札')).
pick(w_rensou,          ja, n3, word, jmdict_kanji('連想')).
pick(w_iigakari,        ja, n3, word, jmdict_kanji('言いがかり')).
pick(w_ryuuzan,         ja, n3, word, jmdict_kanji('流産')).
pick(w_hanbetsu,        ja, n3, word, jmdict_kanji('判別')).
pick(w_shingen,         ja, n3, word, jmdict_kanji('進言')).
pick(w_inochigake,      ja, n3, word, jmdict_kanji('命がけ')).
pick(w_oowarai,         ja, n3, word, jmdict_kanji('大笑い')).
pick(w_jousei,          ja, n3, word, jmdict_kanji('情勢')).
pick(w_kyokumen,        ja, n3, word, jmdict_kanji('局面')).
pick(w_seiyou,          ja, n3, word, jmdict_kanji('西洋')).
pick(w_unsou,           ja, n3, word, jmdict_kanji('運送')).
pick(w_tekikaku,        ja, n3, word, jmdict_kanji('的確')).
pick(w_oshiego,         ja, n3, word, jmdict_kanji('教え子')).
pick(w_shasen,          ja, n3, word, jmdict_kanji('車線')).
pick(w_renketsu,        ja, n3, word, jmdict_kanji('連結')).
pick(w_fuhen,           ja, n3, word, jmdict_kanji('不変')).
pick(w_kyougou,         ja, n3, word, jmdict_kanji('競合')).
pick(w_seimon,          ja, n3, word, jmdict_kanji('正門')).
pick(w_ochido,          ja, n3, word, jmdict_kanji('落ち度')).
pick(w_tokudai,         ja, n3, word, jmdict_kanji('特大')).
pick(w_monooki,         ja, n3, word, jmdict_kanji('物置')).
pick(w_kinsei,          ja, n3, word, jmdict('1243010')).  % きんせい Venus (planet)
pick(w_tenkuu,          ja, n3, word, jmdict_kanji('天空')).
pick(w_mimawari,        ja, n3, word, jmdict_kanji('見回り')).
pick(w_migatte,         ja, n3, word, jmdict_kanji('身勝手')).
pick(w_daika,           ja, n3, word, jmdict_kanji('代価')).
pick(w_shijuu,          ja, n3, word, jmdict_kanji('始終')).
pick(w_nyuushitsu,      ja, n3, word, jmdict_kanji('入室')).
pick(w_sengo,           ja, n3, word, jmdict_kanji('戦後')).
pick(w_shinsei,         ja, n3, word, jmdict_kanji('新生')).
pick(w_mushoku,         ja, n3, word, jmdict_kanji('無職')).
pick(w_hoiku,           ja, n3, word, jmdict('1513290')).  % ほいく nurturing; rearing; childcare
pick(w_rentai,          ja, n3, word, jmdict_kanji('連帯')).
pick(w_inryou,          ja, n3, word, jmdict('1169990')).  % いんりょう beverage; drink
pick(w_katsuryoku,      ja, n3, word, jmdict_kanji('活力')).
pick(w_hokou,           ja, n3, word, jmdict('1514370')).  % ほこう walking; walk
pick(w_jisaku,          ja, n3, word, jmdict_kanji('自作')).
pick(w_ryouashi,        ja, n3, word, jmdict_kanji('両足')).
pick(w_sairai,          ja, n3, word, jmdict_kanji('再来')).
pick(w_kanetsu,         ja, n3, word, jmdict_kanji('加熱')).
pick(w_zenchou,         ja, n3, word, jmdict_kanji('前兆')).
pick(w_hitorikko,       ja, n3, word, jmdict_kanji('一人っ子')).
pick(w_senyuu,          ja, n3, word, jmdict_kanji('戦友')).
pick(w_bunshin,         ja, n3, word, jmdict_kanji('分身')).
pick(w_kinomi,          ja, n3, word, jmdict_kanji('木の実')).
pick(w_tebiki,          ja, n3, word, jmdict_kanji('手引き')).
pick(w_suketto,         ja, n3, word, jmdict_kanji('助っ人')).
pick(w_kofuu,           ja, n3, word, jmdict_kanji('古風')).
pick(w_shichiya,        ja, n3, word, jmdict_kanji('質屋')).
pick(w_nenchou,         ja, n3, word, jmdict_kanji('年長')).
pick(w_neniri,          ja, n3, word, jmdict_kanji('念入り')).
pick(w_junnou,          ja, n3, word, jmdict_kanji('順応')).
pick(w_banken,          ja, n3, word, jmdict_kanji('番犬')).
pick(w_migikiki,        ja, n3, word, jmdict_kanji('右利き')).
pick(w_genkou,          ja, n3, word, jmdict_kanji('現行')).
pick(w_shouten,         ja, n3, word, jmdict_kanji('商店')).
pick(w_ryuudou,         ja, n3, word, jmdict_kanji('流動')).
pick(w_zoukyou,         ja, n3, word, jmdict_kanji('増強')).
pick(w_tsuyomi,         ja, n3, word, jmdict_kanji('強み')).
pick(w_shotei,          ja, n3, word, jmdict_kanji('所定')).
pick(w_suijou,          ja, n3, word, jmdict('1371640')).  % すいじょう on the water; aquatic; waterside
pick(w_jakutai,         ja, n3, word, jmdict_kanji('弱体')).
pick(w_jikyuu,          ja, n3, word, jmdict_kanji('時給')).
pick(w_shinkyoku,       ja, n3, word, jmdict_kanji('新曲')).
pick(w_demae,           ja, n3, word, jmdict_kanji('出前')).
pick(w_mondou,          ja, n3, word, jmdict_kanji('問答')).
pick(w_kounetsu,        ja, n3, word, jmdict_kanji('高熱')).
pick(w_kouken,          ja, n3, word, jmdict_kanji('後見')).
pick(w_dekiagari,       ja, n3, word, jmdict_kanji('出来上がり')).
pick(w_kyokudo,         ja, n3, word, jmdict_kanji('極度')).
pick(w_kando,           ja, n3, word, jmdict_kanji('感度')).
pick(w_denshin,         ja, n3, word, jmdict_kanji('電信')).
pick(w_gunshuu,         ja, n3, word, jmdict_kanji('群集')).
pick(w_dango,           ja, n3, word, jmdict_kanji('団子')).
pick(w_anraku,          ja, n3, word, jmdict_kanji('安楽')).
pick(w_futate,          ja, n3, word, jmdict_kanji('二手')).
pick(w_nanboku,         ja, n3, word, jmdict_kanji('南北')).
pick(w_daikou,          ja, n3, word, jmdict_kanji('代行')).
pick(w_kouritsu,        ja, n3, word, jmdict_kanji('公立')).
pick(w_shisuu,          ja, n3, word, jmdict_kanji('指数')).
pick(w_hontai,          ja, n3, word, jmdict_kanji('本体')).
pick(w_kesshuu,         ja, n3, word, jmdict_kanji('結集')).
pick(w_buin,            ja, n3, word, jmdict_kanji('部員')).
pick(w_aikou,           ja, n3, word, jmdict_kanji('愛好')).
pick(w_shukujitsu,      ja, n3, word, jmdict_kanji('祝日')).
pick(w_kokuchi,         ja, n3, word, jmdict_kanji('告知')).
pick(w_teijuu,          ja, n3, word, jmdict_kanji('定住')).
pick(w_irui,            ja, n3, word, jmdict_kanji('衣類')).
pick(w_sansen,          ja, n3, word, jmdict_kanji('参戦')).
pick(w_senbetsu,        ja, n3, word, jmdict_kanji('選別')).
pick(w_gojitsu,         ja, n3, word, jmdict_kanji('後日')).
pick(w_fuumi,           ja, n3, word, jmdict_kanji('風味')).
pick(w_hatsuan,         ja, n3, word, jmdict_kanji('発案')).
pick(w_rouryoku,        ja, n3, word, jmdict_kanji('労力')).
pick(w_touban,          ja, n3, word, jmdict_kanji('当番')).
pick(w_shoho,           ja, n3, word, jmdict_kanji('初歩')).
pick(w_meigen,          ja, n3, word, jmdict_kanji('名言')).
pick(w_namami,          ja, n3, word, jmdict('1379160')).  % なまみ living flesh; flesh and blood; living (human)
pick(w_fukuin,          ja, n3, word, jmdict_kanji('福音')).
pick(w_hakuchuu,        ja, n3, word, jmdict_kanji('白昼')).
pick(w_shousan,         ja, n3, word, jmdict_kanji('勝算')).
pick(w_henshoku,        ja, n3, word, jmdict_kanji('変色')).
pick(w_jinan,           ja, n3, word, jmdict_kanji('次男')).
pick(w_haika,           ja, n3, word, jmdict_kanji('配下')).
pick(w_yadoya,          ja, n3, word, jmdict_kanji('宿屋')).
pick(w_takami,          ja, n3, word, jmdict_kanji('高み')).
pick(w_metsuki,         ja, n3, word, jmdict_kanji('目つき')).
pick(w_kaishin,         ja, n3, word, jmdict_kanji('改心')).
pick(w_kanyuu,          ja, n3, word, jmdict_kanji('加入')).
pick(w_gensaku,         ja, n3, word, jmdict_kanji('原作')).
pick(w_shuukei,         ja, n3, word, jmdict_kanji('集計')).
pick(w_zenyou,          ja, n3, word, jmdict_kanji('全容')).
pick(w_youshiki,        ja, n3, word, jmdict_kanji('様式')).
pick(w_tanitsu,         ja, n3, word, jmdict('1417100')).  % たんいつ single; simple; sole
pick(w_seizen,          ja, n3, word, jmdict_kanji('生前')).
pick(w_nenpai,          ja, n3, word, jmdict_kanji('年配')).
pick(w_youryou,         ja, n3, word, jmdict_kanji('要領')).
pick(w_fuhatsu,         ja, n3, word, jmdict_kanji('不発')).
pick(w_suiro,           ja, n3, word, jmdict_kanji('水路')).
pick(w_jitsubutsu,      ja, n3, word, jmdict('1321430')).  % じつぶつ real thing; original; actual
pick(w_yowaki,          ja, n3, word, jmdict_kanji('弱気')).
pick(w_tanima,          ja, n3, word, jmdict_kanji('谷間')).
pick(w_heieki,          ja, n3, word, jmdict_kanji('兵役')).
pick(w_kyokusen,        ja, n3, word, jmdict_kanji('曲線')).
pick(w_oyabun,          ja, n3, word, jmdict_kanji('親分')).
pick(w_inochitori,      ja, n3, word, jmdict_kanji('命取り')).
pick(w_ooisogi,         ja, n3, word, jmdict_kanji('大急ぎ')).
pick(w_shichaku,        ja, n3, word, jmdict_kanji('試着')).
pick(w_urite,           ja, n3, word, jmdict_kanji('売り手')).
pick(w_hoshin,          ja, n3, word, jmdict_kanji('保身')).
pick(w_anki,            ja, n3, word, jmdict_kanji('暗記')).
pick(w_minari,          ja, n3, word, jmdict_kanji('身なり')).
pick(w_tsukibito,       ja, n3, word, jmdict_kanji('付き人')).
pick(w_minaoshi,        ja, n3, word, jmdict_kanji('見直し')).
pick(w_taisa,           ja, n3, word, jmdict_kanji('大差')).
pick(w_kamoku,          ja, n3, word, jmdict_kanji('科目')).
pick(w_nissuu,          ja, n3, word, jmdict_kanji('日数')).
pick(w_tenraku,         ja, n3, word, jmdict_kanji('転落')).
pick(w_hougen,          ja, n3, word, jmdict_kanji('方言')).
pick(w_shomotsu,        ja, n3, word, jmdict_kanji('書物')).
pick(w_shuuki,          ja, n3, word, jmdict_kanji('周期')).
pick(w_magiwa,          ja, n3, word, jmdict_kanji('間際')).
pick(w_ryouritsu,       ja, n3, word, jmdict_kanji('両立')).
pick(w_satei,           ja, n3, word, jmdict_kanji('査定')).
pick(w_hibana,          ja, n3, word, jmdict_kanji('火花')).
pick(w_mokuroku,        ja, n3, word, jmdict_kanji('目録')).
pick(w_shitsuryou,      ja, n3, word, jmdict_kanji('質量')).
pick(w_haguruma,        ja, n3, word, jmdict_kanji('歯車')).
pick(w_eichi,           ja, n3, word, jmdict_kanji('英知')).
pick(w_touchoku,        ja, n3, word, jmdict_kanji('当直')).
pick(w_akiya,           ja, n3, word, jmdict_kanji('空き家')).
pick(w_utsubyou,        ja, n3, word, jmdict_kanji('うつ病')).
pick(w_heigen,          ja, n3, word, jmdict_kanji('平原')).
pick(w_tabibito,        ja, n3, word, jmdict('1553210')).  % たびびと traveller; traveler; wayfarer
pick(w_gaikai,          ja, n3, word, jmdict_kanji('外界')).
pick(w_kihin,           ja, n3, word, jmdict_kanji('気品')).
pick(w_zensai,          ja, n3, word, jmdict_kanji('前菜')).
pick(w_hiroma,          ja, n3, word, jmdict_kanji('広間')).
pick(w_fukairi,         ja, n3, word, jmdict_kanji('深入り')).
pick(w_hanpatsu,        ja, n3, word, jmdict_kanji('反発')).
pick(w_tounan,          ja, n3, word, jmdict_kanji('東南')).
pick(w_idai,            ja, n3, word, jmdict_kanji('医大')).
pick(w_kyuushin,        ja, n3, word, jmdict_kanji('急進')).
pick(w_houei,           ja, n3, word, jmdict_kanji('放映')).
pick(w_gaishoku,        ja, n3, word, jmdict_kanji('外食')).
pick(w_shuuchi,         ja, n3, word, jmdict_kanji('周知')).
pick(w_nyuuyoku,        ja, n3, word, jmdict_kanji('入浴')).
pick(w_yuuai,           ja, n3, word, jmdict_kanji('友愛')).
pick(w_naishin,         ja, n3, word, jmdict_kanji('内心')).
pick(w_aichaku,         ja, n3, word, jmdict('1575680')).  % あいちゃく attachment (esp. to things); love; affection
pick(w_henjou,          ja, n3, word, jmdict_kanji('返上')).
pick(w_romen,           ja, n3, word, jmdict_kanji('路面')).
pick(w_oriai,           ja, n3, word, jmdict_kanji('折り合い')).
pick(w_kyuushi,         ja, n3, word, jmdict_kanji('休止')).
pick(w_nyuunen,         ja, n3, word, jmdict_kanji('入念')).
pick(w_hanten,          ja, n3, word, jmdict_kanji('反転')).
pick(w_shinkai,         ja, n3, word, jmdict_kanji('深海')).
pick(w_kousatsu,        ja, n3, word, jmdict_kanji('考察')).
pick(w_kogoe,           ja, n3, word, jmdict_kanji('小声')).
pick(w_ookisa,          ja, n3, word, jmdict_kanji('大きさ')).
pick(w_toukyuu,         ja, n3, word, jmdict_kanji('等級')).
pick(w_shitami,         ja, n3, word, jmdict_kanji('下見')).
pick(w_kairyuu,         ja, n3, word, jmdict_kanji('海流')).
pick(w_kigyou,          ja, n3, word, jmdict_kanji('起業')).
pick(w_fukugyou,        ja, n3, word, jmdict_kanji('副業')).
pick(w_kogoto,          ja, n3, word, jmdict_kanji('小言')).
pick(w_inryoku,         ja, n3, word, jmdict_kanji('引力')).
pick(w_toorisugari,     ja, n3, word, jmdict_kanji('通りすがり')).
pick(w_nenmatsu,        ja, n3, word, jmdict_kanji('年末')).
pick(w_genten,          ja, n3, word, jmdict_kanji('原点')).
pick(w_jouen,           ja, n3, word, jmdict_kanji('上演')).
pick(w_takoku,          ja, n3, word, jmdict_kanji('他国')).
pick(w_hongoku,         ja, n3, word, jmdict_kanji('本国')).
pick(w_kyuuzou,         ja, n3, word, jmdict_kanji('急増')).
pick(w_shashu,          ja, n3, word, jmdict_kanji('車種')).
pick(w_aima,            ja, n3, word, jmdict_kanji('合間')).
pick(w_gakumon,         ja, n3, word, jmdict_kanji('学問')).
pick(w_douwa,           ja, n3, word, jmdict_kanji('童話')).
pick(w_yagai,           ja, n3, word, jmdict_kanji('野外')).
pick(w_meshita,         ja, n3, word, jmdict('1535320')).  % めした subordinate; subordinates; inferior
pick(w_okugai,          ja, n3, word, jmdict('1182680')).  % おくがい outdoors; outside
pick(w_kakki,           ja, n3, word, jmdict_kanji('活気')).
pick(w_kuubo,           ja, n3, word, jmdict_kanji('空母')).
pick(w_jizai,           ja, n3, word, jmdict_kanji('自在')).
pick(w_unkou,           ja, n3, word, jmdict_kanji('運行')).
pick(w_tentai,          ja, n3, word, jmdict_kanji('天体')).
pick(w_minomawari,      ja, n3, word, jmdict_kanji('身の回り')).
pick(w_heimen,          ja, n3, word, jmdict_kanji('平面')).
pick(w_saitan,          ja, n3, word, jmdict_kanji('最短')).
pick(w_nidai,           ja, n3, word, jmdict_kanji('荷台')).
pick(w_hyouzan,         ja, n3, word, jmdict_kanji('氷山')).
pick(w_mochidashi,      ja, n3, word, jmdict_kanji('持ち出し')).
pick(w_shinkuu,         ja, n3, word, jmdict_kanji('真空')).
pick(w_kishu,           ja, n3, word, jmdict_kanji('機首')).
pick(w_haruyasumi,      ja, n3, word, jmdict_kanji('春休み')).
pick(w_shokuzai,        ja, n3, word, jmdict_kanji('食材')).
pick(w_fumou,           ja, n3, word, jmdict_kanji('不毛')).
pick(w_douzoku,         ja, n3, word, jmdict_kanji('同族')).
pick(w_benki,           ja, n3, word, jmdict_kanji('便器')).
pick(w_douchuu,         ja, n3, word, jmdict('1770610')).  % どうちゅう journey; trip; travels
pick(w_keshin,          ja, n3, word, jmdict_kanji('化身')).
pick(w_nagatsuzuki,     ja, n3, word, jmdict_kanji('長続き')).
pick(w_jichi,           ja, n3, word, jmdict_kanji('自治')).
pick(w_tozan,           ja, n3, word, jmdict_kanji('登山')).
pick(w_ryokaku,         ja, n3, word, jmdict_kanji('旅客')).
pick(w_akushitsu,       ja, n3, word, jmdict_kanji('悪質')).
pick(w_shizai,          ja, n3, word, jmdict_kanji('資材')).
pick(w_kyoufuu,         ja, n3, word, jmdict_kanji('強風')).
pick(w_kousha,          ja, n3, word, jmdict_kanji('後者')).
pick(w_kounai,          ja, n3, word, jmdict_kanji('構内')).
pick(w_hongyou,         ja, n3, word, jmdict_kanji('本業')).
pick(w_kaigyou,         ja, n3, word, jmdict_kanji('開業')).
pick(w_jigo,            ja, n3, word, jmdict_kanji('事後')).
pick(w_rikiryou,        ja, n3, word, jmdict_kanji('力量')).
pick(w_issetsu,         ja, n3, word, jmdict('1576220')).  % いっせつ one passage; one paragraph; one stanza
pick(w_takadai,         ja, n3, word, jmdict_kanji('高台')).
pick(w_samuke,          ja, n3, word, jmdict('1210410')).  % さむけ chill; the shivers; shivering fit
pick(w_mochikaeri,      ja, n3, word, jmdict_kanji('持ち帰り')).
pick(w_kouyuu,          ja, n3, word, jmdict_kanji('交友')).
pick(w_gakuya,          ja, n3, word, jmdict_kanji('楽屋')).
pick(w_tokkun,          ja, n3, word, jmdict_kanji('特訓')).
pick(w_monoii,          ja, n3, word, jmdict_kanji('物言い')).
pick(w_jicchi,          ja, n3, word, jmdict_kanji('実地')).
pick(w_kyoumei,         ja, n3, word, jmdict_kanji('共鳴')).
pick(w_chikadou,        ja, n3, word, jmdict_kanji('地下道')).
pick(w_yuuhi,           ja, n3, word, jmdict_kanji('夕日')).
pick(w_yomikaki,        ja, n3, word, jmdict_kanji('読み書き')).
pick(w_heizen,          ja, n3, word, jmdict_kanji('平然')).
pick(w_seibyou,         ja, n3, word, jmdict_kanji('性病')).
pick(w_akujo,           ja, n3, word, jmdict_kanji('悪女')).
pick(w_shussha,         ja, n3, word, jmdict_kanji('出社')).
pick(w_shinzan,         ja, n3, word, jmdict_kanji('新参')).
pick(w_yashoku,         ja, n3, word, jmdict_kanji('夜食')).
pick(w_shoubun,         ja, n3, word, jmdict_kanji('性分')).
pick(w_ousen,           ja, n3, word, jmdict_kanji('応戦')).
pick(w_chakusui,        ja, n3, word, jmdict_kanji('着水')).
pick(w_juken,           ja, n3, word, jmdict_kanji('受験')).
pick(w_choujo,          ja, n3, word, jmdict_kanji('長女')).
pick(w_chakujitsu,      ja, n3, word, jmdict_kanji('着実')).
pick(w_shodai,          ja, n3, word, jmdict_kanji('初代')).
pick(w_shinkyou,        ja, n3, word, jmdict_kanji('心境')).
pick(w_jinsen,          ja, n3, word, jmdict_kanji('人選')).
pick(w_nikushin,        ja, n3, word, jmdict_kanji('肉親')).
pick(w_nyuumon,         ja, n3, word, jmdict_kanji('入門')).
pick(w_dodai,           ja, n3, word, jmdict_kanji('土台')).
pick(w_kyouda,          ja, n3, word, jmdict_kanji('強打')).
pick(w_genni,           ja, n3, word, jmdict_kanji('現に')).
pick(w_kyuushoku,       ja, n3, word, jmdict_kanji('休職')).
pick(w_kaichuu,         ja, n3, word, jmdict_kanji('海中')).
pick(w_ashiba,          ja, n3, word, jmdict_kanji('足場')).
pick(w_mizen,           ja, n3, word, jmdict_kanji('未然')).
pick(w_hankan,          ja, n3, word, jmdict_kanji('反感')).
pick(w_souryoku,        ja, n3, word, jmdict_kanji('総力')).
pick(w_tenaoshi,        ja, n3, word, jmdict_kanji('手直し')).
pick(w_kirikuchi,       ja, n3, word, jmdict_kanji('切り口')).
pick(w_zukei,           ja, n3, word, jmdict_kanji('図形')).
pick(w_nikka,           ja, n3, word, jmdict_kanji('日課')).
pick(w_isshiki,         ja, n3, word, jmdict_kanji('一式')).
pick(w_giniro,          ja, n3, word, jmdict_kanji('銀色')).
pick(w_guni,            ja, n3, word, jmdict_kanji('軍医')).
pick(w_bokokugo,        ja, n3, word, jmdict_kanji('母国語')).
pick(w_shiomizu,        ja, n3, word, jmdict_kanji('塩水')).
pick(w_suushiki,        ja, n3, word, jmdict_kanji('数式')).
pick(w_mimimoto,        ja, n3, word, jmdict_kanji('耳元')).
pick(w_saishoku,        ja, n3, word, jmdict_kanji('菜食')).
pick(w_soukai,          ja, n3, word, jmdict_kanji('総会')).
pick(w_gesha,           ja, n3, word, jmdict_kanji('下車')).
pick(w_rinen,           ja, n3, word, jmdict_kanji('理念')).
pick(w_kufuu,           ja, n3, word, jmdict('1278220')).  % くふう devising (a way); contriving; inventing
pick(w_ikuji,           ja, n3, word, jmdict_kanji('育児')).
pick(w_inshoku,         ja, n3, word, jmdict_kanji('飲食')).
pick(w_gakujutsu,       ja, n3, word, jmdict_kanji('学術')).
pick(w_kokugo,          ja, n3, word, jmdict_kanji('国語')).
pick(w_rishi,           ja, n3, word, jmdict_kanji('利子')).
pick(w_koyuu,           ja, n3, word, jmdict_kanji('固有')).
pick(w_ooame,           ja, n3, word, jmdict_kanji('大雨')).
pick(w_sonchou,         ja, n3, word, jmdict_kanji('村長')).
pick(w_kessen,          ja, n3, word, jmdict_kanji('決戦')).
pick(w_kouon,           ja, n3, word, jmdict_kanji('高温')).
pick(w_karyuu,          ja, n3, word, jmdict_kanji('下流')).
pick(w_ouchou,          ja, n3, word, jmdict_kanji('王朝')).
pick(w_akichi,          ja, n3, word, jmdict_kanji('空き地')).
pick(w_fubi,            ja, n3, word, jmdict_kanji('不備')).
pick(w_aiken,           ja, n3, word, jmdict_kanji('愛犬')).
pick(w_kuchiburi,       ja, n3, word, jmdict_kanji('口ぶり')).
pick(w_meishu,          ja, n3, word, jmdict_kanji('名手')).
pick(w_shirokuro,       ja, n3, word, jmdict_kanji('白黒')).
pick(w_ichigan,         ja, n3, word, jmdict_kanji('一丸')).
pick(w_daiyou,          ja, n3, word, jmdict_kanji('代用')).
pick(w_hatsunetsu,      ja, n3, word, jmdict_kanji('発熱')).
pick(w_kaishoku,        ja, n3, word, jmdict_kanji('会食')).
pick(w_sekishoku,       ja, n3, word, jmdict_kanji('赤色')).
pick(w_hitoyasumi,      ja, n3, word, jmdict_kanji('一休み')).
pick(w_yamanobori,      ja, n3, word, jmdict_kanji('山登り')).
pick(w_yukute,          ja, n3, word, jmdict_kanji('行く手')).
pick(w_shukan,          ja, n3, word, jmdict_kanji('主観')).
pick(w_kyousha,         ja, n3, word, jmdict('1506210')).  % きょうしゃ strong person; the strong; the powerful
pick(w_mujou,           ja, n3, word, jmdict_kanji('無情')).
pick(w_ishikoro,        ja, n3, word, jmdict_kanji('石ころ')).
pick(w_muni,            ja, n3, word, jmdict_kanji('無二')).
pick(w_araimono,        ja, n3, word, jmdict_kanji('洗い物')).
pick(w_souba,           ja, n3, word, jmdict_kanji('相場')).
pick(w_nyuusha,         ja, n3, word, jmdict_kanji('入社')).
pick(w_kyuusei,         ja, n3, word, jmdict_kanji('急性')).
pick(w_toshin,          ja, n3, word, jmdict_kanji('都心')).
pick(w_seishounen,      ja, n3, word, jmdict_kanji('青少年')).
pick(w_hinshu,          ja, n3, word, jmdict_kanji('品種')).
pick(w_kougei,          ja, n3, word, jmdict_kanji('工芸')).
pick(w_kyuujin,         ja, n3, word, jmdict_kanji('求人')).
pick(w_nichiji,         ja, n3, word, jmdict_kanji('日時')).
pick(w_gairai,          ja, n3, word, jmdict_kanji('外来')).
pick(w_kaoku,           ja, n3, word, jmdict_kanji('家屋')).
pick(w_kyuuraku,        ja, n3, word, jmdict_kanji('急落')).
pick(w_enkei,           ja, n3, word, jmdict_kanji('円形')).
pick(w_shatai,          ja, n3, word, jmdict_kanji('車体')).
pick(w_kaiki,           ja, n3, word, jmdict_kanji('回帰')).
pick(w_kenchi,          ja, n3, word, jmdict_kanji('見地')).
pick(w_rendou,          ja, n3, word, jmdict_kanji('連動')).
pick(w_kakariin,        ja, n3, word, jmdict_kanji('係員')).
pick(w_kakuyaku,        ja, n3, word, jmdict_kanji('確約')).
pick(w_musubitsuki,     ja, n3, word, jmdict_kanji('結びつき')).
pick(w_senken,          ja, n3, word, jmdict_kanji('先見')).
pick(w_oitachi,         ja, n3, word, jmdict_kanji('生い立ち')).
pick(w_henkyou,         ja, n3, word, jmdict_kanji('辺境')).
pick(w_shishoku,        ja, n3, word, jmdict_kanji('試食')).
pick(w_nanishiro,       ja, n3, word, jmdict_kanji('何しろ')).
pick(w_ichinichi,       ja, n3, word, jmdict('1576260')).  % いちにち one day; all day (long); the whole day
pick(w_koishi,          ja, n3, word, jmdict_kanji('小石')).
pick(w_oome,            ja, n3, word, jmdict_kanji('多め')).
pick(w_maifun,          ja, n3, word, jmdict_kanji('毎分')).
pick(w_massao,          ja, n3, word, jmdict_kanji('真っ青')).
pick(w_yasei,           ja, n3, word, jmdict_kanji('野性')).
pick(w_fuugawari,       ja, n3, word, jmdict_kanji('風変わり')).
pick(w_shisho,          ja, n3, word, jmdict_kanji('司書')).
pick(w_jouji,           ja, n3, word, jmdict_kanji('情事')).
pick(w_toorimichi,      ja, n3, word, jmdict_kanji('通り道')).
pick(w_kesshi,          ja, n3, word, jmdict_kanji('決死')).
pick(w_shijou,          ja, n3, word, jmdict_kanji('私情')).
pick(w_keishoku,        ja, n3, word, jmdict_kanji('軽食')).
pick(w_hanauta,         ja, n3, word, jmdict_kanji('鼻歌')).
pick(w_sakimawari,      ja, n3, word, jmdict_kanji('先回り')).
pick(w_ryoukoku,        ja, n3, word, jmdict_kanji('両国')).
pick(w_geraku,          ja, n3, word, jmdict_kanji('下落')).
pick(w_meimoku,         ja, n3, word, jmdict_kanji('名目')).
pick(w_tsuyoki,         ja, n3, word, jmdict('1236230')).  % つよき confident; assured; self-assured
pick(w_ichigyou,        ja, n3, word, jmdict('1576020')).  % いちぎょう (one) line; (one) row
pick(w_seiyaku,         ja, n3, word, jmdict_kanji('制約')).
pick(w_fuusoku,         ja, n3, word, jmdict_kanji('風速')).
pick(w_shitamachi,      ja, n3, word, jmdict_kanji('下町')).
pick(w_seigo,           ja, n3, word, jmdict_kanji('生後')).
pick(w_nanpou,          ja, n3, word, jmdict_kanji('南方')).
pick(w_ookata,          ja, n3, word, jmdict_kanji('大方')).
pick(w_hacchaku,        ja, n3, word, jmdict_kanji('発着')).
pick(w_kaiyaku,         ja, n3, word, jmdict_kanji('解約')).
pick(w_engei,           ja, n3, word, jmdict_kanji('園芸')).
pick(w_aikotoba,        ja, n3, word, jmdict_kanji('合言葉')).
pick(w_shokuniku,       ja, n3, word, jmdict_kanji('食肉')).
pick(w_kakubetsu,       ja, n3, word, jmdict_kanji('格別')).
pick(w_iroke,           ja, n3, word, jmdict_kanji('色気')).
pick(w_keiryou,         ja, n3, word, jmdict_kanji('計量')).
pick(w_asobiba,         ja, n3, word, jmdict_kanji('遊び場')).
pick(w_kyoushoku,       ja, n3, word, jmdict_kanji('教職')).
pick(w_buntsuu,         ja, n3, word, jmdict_kanji('文通')).
pick(w_okimono,         ja, n3, word, jmdict_kanji('置物')).
pick(w_burui,           ja, n3, word, jmdict_kanji('部類')).
pick(w_teikuu,          ja, n3, word, jmdict_kanji('低空')).
pick(w_atamakin,        ja, n3, word, jmdict_kanji('頭金')).
pick(w_futashika,       ja, n3, word, jmdict_kanji('不確か')).
pick(w_dosei,           ja, n3, word, jmdict_kanji('土星')).
pick(w_soyokaze,        ja, n3, word, jmdict_kanji('そよ風')).
pick(w_hankyuu,         ja, n3, word, jmdict_kanji('半球')).
pick(w_gokujou,         ja, n3, word, jmdict_kanji('極上')).
pick(w_kyuuai,          ja, n3, word, jmdict_kanji('求愛')).
pick(w_tazei,           ja, n3, word, jmdict_kanji('多勢')).
pick(w_ketsugi,         ja, n3, word, jmdict_kanji('決議')).
pick(w_koumin,          ja, n3, word, jmdict('1274750')).  % こうみん citizen; civics (school subject)
pick(w_shishutsu,       ja, n3, word, jmdict_kanji('支出')).
pick(w_kyuujou,         ja, n3, word, jmdict_kanji('球場')).
pick(w_shikyo,          ja, n3, word, jmdict_kanji('死去')).
pick(w_shuusen,         ja, n3, word, jmdict_kanji('終戦')).
pick(w_chuubu,          ja, n3, word, jmdict_kanji('中部')).
pick(w_uriba,           ja, n3, word, jmdict_kanji('売り場')).
pick(w_kyuugyou,        ja, n3, word, jmdict_kanji('休業')).
pick(w_nouchi,          ja, n3, word, jmdict_kanji('農地')).
pick(w_kouan,           ja, n3, word, jmdict_kanji('公安')).
pick(w_fufuku,          ja, n3, word, jmdict_kanji('不服')).
pick(w_shushi,          ja, n3, word, jmdict('1328830')).  % しゅし seed; pit
pick(w_kusen,           ja, n3, word, jmdict_kanji('苦戦')).
pick(w_shuppin,         ja, n3, word, jmdict_kanji('出品')).
pick(w_ajiwai,          ja, n3, word, jmdict_kanji('味わい')).
pick(w_ritsuan,         ja, n3, word, jmdict_kanji('立案')).
pick(w_baiten,          ja, n3, word, jmdict_kanji('売店')).
pick(w_shichuu,         ja, n3, word, jmdict_kanji('支柱')).
pick(w_shuukin,         ja, n3, word, jmdict_kanji('集金')).
pick(w_washitsu,        ja, n3, word, jmdict_kanji('和室')).
pick(w_shikijou,        ja, n3, word, jmdict_kanji('式場')).
pick(w_senpou,          ja, n3, word, jmdict('1388600')).  % せんぽう other party; other side; ahead
pick(w_touten,          ja, n3, word, jmdict_kanji('当店')).
pick(w_kakugen,         ja, n3, word, jmdict_kanji('格言')).
pick(w_rikuchi,         ja, n3, word, jmdict_kanji('陸地')).
pick(w_nomikai,         ja, n3, word, jmdict_kanji('飲み会')).
pick(w_kiban,           ja, n3, word, jmdict_kanji('基板')).
pick(w_youyaku,         ja, n3, word, jmdict_kanji('要約')).
pick(w_juubyou,         ja, n3, word, jmdict_kanji('重病')).
pick(w_nisan,           ja, n3, word, jmdict_kanji('二三')).
pick(w_dasan,           ja, n3, word, jmdict_kanji('打算')).
pick(w_otte,            ja, n3, word, jmdict_kanji('追っ手')).
pick(w_imadoki,         ja, n3, word, jmdict('1289180')).  % いまどき these days; nowadays; today
pick(w_chokketsu,       ja, n3, word, jmdict_kanji('直結')).
pick(w_nyuubu,          ja, n3, word, jmdict_kanji('入部')).
pick(w_rakuten,         ja, n3, word, jmdict('1207440')).  % らくてん optimism
pick(w_ginka,           ja, n3, word, jmdict_kanji('銀貨')).
pick(w_matohazure,      ja, n3, word, jmdict_kanji('的外れ')).
pick(w_tsukaimono,      ja, n3, word, jmdict_kanji('使い物')).
pick(w_keido,           ja, n3, word, jmdict_kanji('経度')).
pick(w_kouyaku,         ja, n3, word, jmdict_kanji('公約')).
pick(w_jitsumu,         ja, n3, word, jmdict_kanji('実務')).
pick(w_kaden,           ja, n3, word, jmdict('1192380')).  % かでん household (electrical) appliances; home applianc
pick(w_mitei,           ja, n3, word, jmdict_kanji('未定')).
pick(w_hougaku,         ja, n3, word, jmdict_kanji('法学')).
pick(w_danwa,           ja, n3, word, jmdict_kanji('談話')).
pick(w_rougo,           ja, n3, word, jmdict_kanji('老後')).
pick(w_kikaku,          ja, n3, word, jmdict_kanji('規格')).
pick(w_meimon,          ja, n3, word, jmdict_kanji('名門')).
pick(w_nekki,           ja, n3, word, jmdict('1467810')).  % ねっき heat; hot air; enthusiasm
pick(w_tahou,           ja, n3, word, jmdict_kanji('他方')).
pick(w_tachiagari,      ja, n3, word, jmdict_kanji('立ち上がり')).
pick(w_nyuudan,         ja, n3, word, jmdict_kanji('入団')).
pick(w_jimichi,         ja, n3, word, jmdict_kanji('地道')).
pick(w_danin,           ja, n3, word, jmdict_kanji('団員')).
pick(w_kyoukou,         ja, n3, word, jmdict_kanji('強行')).
pick(w_ryohi,           ja, n3, word, jmdict_kanji('旅費')).
pick(w_suishin,         ja, n3, word, jmdict_kanji('水深')).
pick(w_sekki,           ja, n3, word, jmdict_kanji('石器')).
pick(w_taishou,         ja, n3, word, jmdict_kanji('対照')).
pick(w_enogu,           ja, n3, word, jmdict_kanji('絵の具')).
pick(w_iimawashi,       ja, n3, word, jmdict_kanji('言い回し')).
pick(w_doushitsu,       ja, n3, word, jmdict_kanji('同室')).
pick(w_ajitsuke,        ja, n3, word, jmdict_kanji('味付け')).
pick(w_kakyuu,          ja, n3, word, jmdict_kanji('下級')).
pick(w_ennai,           ja, n3, word, jmdict_kanji('園内')).
pick(w_sadaka,          ja, n3, word, jmdict_kanji('定か')).
pick(w_hachou,          ja, n3, word, jmdict_kanji('波長')).
pick(w_miseba,          ja, n3, word, jmdict_kanji('見せ場')).
pick(w_gekkou,          ja, n3, word, jmdict_kanji('月光')).
pick(w_kimama,          ja, n3, word, jmdict_kanji('気まま')).
pick(w_yakou,           ja, n3, word, jmdict('1584820')).  % やこう night travel; walking around at night; night tra
pick(w_annojou,         ja, n3, word, jmdict_kanji('案の定')).
pick(w_mizutamari,      ja, n3, word, jmdict_kanji('水たまり')).
pick(w_nomiya,          ja, n3, word, jmdict_kanji('飲み屋')).
pick(w_kannou,          ja, n3, word, jmdict_kanji('官能')).
pick(w_tokubai,         ja, n3, word, jmdict_kanji('特売')).
pick(w_hitogomi,        ja, n3, word, jmdict_kanji('人ごみ')).
pick(w_daian,           ja, n3, word, jmdict_kanji('代案')).
pick(w_tokka,           ja, n3, word, jmdict_kanji('特化')).
pick(w_hirui,           ja, n3, word, jmdict_kanji('比類')).
pick(w_kyokugei,        ja, n3, word, jmdict_kanji('曲芸')).
pick(w_yokou,           ja, n3, word, jmdict_kanji('予行')).
pick(w_henkin,          ja, n3, word, jmdict_kanji('返金')).
pick(w_onsoku,          ja, n3, word, jmdict_kanji('音速')).
pick(w_monoshiri,       ja, n3, word, jmdict_kanji('物知り')).
pick(w_kinri,           ja, n3, word, jmdict_kanji('金利')).
pick(w_taishitsu,       ja, n3, word, jmdict_kanji('体質')).
pick(w_nyuushi,         ja, n3, word, jmdict_kanji('入試')).
pick(w_nouyaku,         ja, n3, word, jmdict_kanji('農薬')).
pick(w_kokudou,         ja, n3, word, jmdict_kanji('国道')).
pick(w_sakiyuki,        ja, n3, word, jmdict_kanji('先行き')).
pick(w_sentei,          ja, n3, word, jmdict_kanji('選定')).
pick(w_juryou,          ja, n3, word, jmdict('1330080')).  % じゅりょう receipt (of a letter, money, etc.); acceptance; 
pick(w_kansen,          ja, n3, word, jmdict_kanji('観戦')).
pick(w_zensha,          ja, n3, word, jmdict_kanji('前者')).
pick(w_zouin,           ja, n3, word, jmdict_kanji('増員')).
pick(w_shoken,          ja, n3, word, jmdict_kanji('所見')).
pick(w_chikazuki,       ja, n3, word, jmdict_kanji('近づき')).
pick(w_tahatsu,         ja, n3, word, jmdict_kanji('多発')).
pick(w_nenjuu,          ja, n3, word, jmdict('1469000')).  % ねんじゅう whole year; all year round; throughout the year
pick(w_kaien,           ja, n3, word, jmdict_kanji('開演')).
pick(w_kanbai,          ja, n3, word, jmdict_kanji('完売')).
pick(w_seikyuu,         ja, n3, word, jmdict_kanji('性急')).
pick(w_koutei,          ja, n3, word, jmdict_kanji('校庭')).
pick(w_bigaku,          ja, n3, word, jmdict_kanji('美学')).
pick(w_geimei,          ja, n3, word, jmdict_kanji('芸名')).
pick(w_gakudan,         ja, n3, word, jmdict_kanji('楽団')).
pick(w_bousui,          ja, n3, word, jmdict_kanji('防水')).
pick(w_fuushuu,         ja, n3, word, jmdict_kanji('風習')).
pick(w_koyubi,          ja, n3, word, jmdict_kanji('小指')).
pick(w_hini,            ja, n3, word, jmdict_kanji('品位')).
pick(w_byoujaku,        ja, n3, word, jmdict_kanji('病弱')).
pick(w_tekichuu,        ja, n3, word, jmdict_kanji('的中')).
pick(w_hakunetsu,       ja, n3, word, jmdict_kanji('白熱')).
pick(w_kaihen,          ja, n3, word, jmdict_kanji('改変')).
pick(w_maibyou,         ja, n3, word, jmdict_kanji('毎秒')).
pick(w_oomaka,          ja, n3, word, jmdict_kanji('大まか')).
pick(w_chakunin,        ja, n3, word, jmdict_kanji('着任')).
pick(w_tedama,          ja, n3, word, jmdict_kanji('手玉')).
pick(w_naikou,          ja, n3, word, jmdict_kanji('内向')).
pick(w_norainu,         ja, n3, word, jmdict_kanji('野良犬')).
pick(w_genyu,           ja, n3, word, jmdict_kanji('原油')).
pick(w_jisha,           ja, n3, word, jmdict_kanji('自社')).
pick(w_shuryuu,         ja, n3, word, jmdict_kanji('主流')).
pick(w_kinnen,          ja, n3, word, jmdict_kanji('近年')).
pick(w_yuuryou,         ja, n3, word, jmdict_kanji('有料')).
pick(w_kassen,          ja, n3, word, jmdict_kanji('合戦')).
pick(w_tatemae,         ja, n3, word, jmdict_kanji('建前')).
pick(w_kenkoku,         ja, n3, word, jmdict_kanji('建国')).
pick(w_shamei,          ja, n3, word, jmdict_kanji('社名')).
pick(w_nyuusho,         ja, n3, word, jmdict_kanji('入所')).
pick(w_nairiku,         ja, n3, word, jmdict_kanji('内陸')).
pick(w_ketsubetsu,      ja, n3, word, jmdict_kanji('決別')).
pick(w_kaimen,          ja, n3, word, jmdict_kanji('海面')).
pick(w_jinushi,         ja, n3, word, jmdict_kanji('地主')).
pick(w_hizashi,         ja, n3, word, jmdict_kanji('日差し')).
pick(w_oime,            ja, n3, word, jmdict_kanji('負い目')).
pick(w_chourui,         ja, n3, word, jmdict_kanji('鳥類')).
pick(w_uwanose,         ja, n3, word, jmdict_kanji('上乗せ')).
pick(w_shachuu,         ja, n3, word, jmdict_kanji('車中')).
pick(w_tenbai,          ja, n3, word, jmdict_kanji('転売')).
pick(w_shigai,          ja, n3, word, jmdict_kanji('市外')).
pick(w_gakugyou,        ja, n3, word, jmdict_kanji('学業')).
pick(w_mukashibanashi,  ja, n3, word, jmdict_kanji('昔話')).
pick(w_zaimoku,         ja, n3, word, jmdict_kanji('材木')).
pick(w_shikou,          ja, n3, word, jmdict_kanji('試行')).
pick(w_hayakuchi,       ja, n3, word, jmdict_kanji('早口')).
pick(w_tokushitsu,      ja, n3, word, jmdict_kanji('特質')).
pick(w_yomimono,        ja, n3, word, jmdict_kanji('読み物')).
pick(w_tegotae,         ja, n3, word, jmdict_kanji('手応え')).
pick(w_tsukihi,         ja, n3, word, jmdict('1255780')).  % つきひ time; years; days
pick(w_machihazure,     ja, n3, word, jmdict_kanji('町外れ')).
pick(w_kuchikazu,       ja, n3, word, jmdict('1578670')).  % くちかず number of words a person speaks; number of depen
pick(w_shiki,           ja, n3, word, jmdict_kanji('死期')).
pick(w_joushitsu,       ja, n3, word, jmdict_kanji('上質')).
pick(w_hahakata,        ja, n3, word, jmdict_kanji('母方')).
pick(w_zengen,          ja, n3, word, jmdict_kanji('前言')).
pick(w_soukan,          ja, n3, word, jmdict_kanji('相関')).
pick(w_komichi,         ja, n3, word, jmdict_kanji('小道')).
pick(w_hondou,          ja, n3, word, jmdict_kanji('本道')).
pick(w_anjuu,           ja, n3, word, jmdict_kanji('安住')).
pick(w_fukashigi,       ja, n3, word, jmdict_kanji('不可思議')).
pick(w_houkei,          ja, n3, word, jmdict_kanji('方形')).
pick(w_matsuro,         ja, n3, word, jmdict_kanji('末路')).
pick(w_hensuu,          ja, n3, word, jmdict_kanji('変数')).
pick(w_monozuki,        ja, n3, word, jmdict_kanji('物好き')).
pick(w_hirei,           ja, n3, word, jmdict_kanji('比例')).
pick(w_kessan,          ja, n3, word, jmdict_kanji('決算')).
pick(w_tanshin,         ja, n3, word, jmdict_kanji('単身')).
pick(w_kaihi,           ja, n3, word, jmdict_kanji('会費')).
pick(w_iryou,           ja, n3, word, jmdict_kanji('衣料')).
pick(w_heijitsu,        ja, n3, word, jmdict_kanji('平日')).
pick(w_meisaku,         ja, n3, word, jmdict_kanji('名作')).
pick(w_senka,           ja, n3, word, jmdict_kanji('戦火')).
pick(w_ainori,          ja, n3, word, jmdict_kanji('相乗り')).
pick(w_teichaku,        ja, n3, word, jmdict_kanji('定着')).
pick(w_nemawashi,       ja, n3, word, jmdict_kanji('根回し')).
pick(w_shotou,          ja, n3, word, jmdict_kanji('初頭')).
pick(w_saiko,           ja, n3, word, jmdict_kanji('最古')).
pick(w_yuukyuu,         ja, n3, word, jmdict_kanji('有給')).
pick(w_shoushi,         ja, n3, word, jmdict_kanji('焼死')).
pick(w_hitode,          ja, n3, word, jmdict_kanji('人出')).
pick(w_senrei,          ja, n3, word, jmdict_kanji('先例')).
pick(w_danzen,          ja, n3, word, jmdict_kanji('断然')).
pick(w_geisha,          ja, n3, word, jmdict_kanji('芸者')).
pick(w_kazamuki,        ja, n3, word, jmdict_kanji('風向き')).
pick(w_nyuukou,         ja, n3, word, jmdict_kanji('入港')).
pick(w_juyou,           ja, n3, word, jmdict_kanji('受容')).
pick(w_kikyuu,          ja, n3, word, jmdict_kanji('気球')).
pick(w_ketsujou,        ja, n3, word, jmdict_kanji('欠場')).
pick(w_bouon,           ja, n3, word, jmdict_kanji('防音')).
pick(w_honshoku,        ja, n3, word, jmdict_kanji('本職')).
pick(w_arate,           ja, n3, word, jmdict_kanji('新手')).
pick(w_shokugo,         ja, n3, word, jmdict_kanji('食後')).
pick(w_ninotsugi,       ja, n3, word, jmdict_kanji('二の次')).
pick(w_kakushu,         ja, n3, word, jmdict_kanji('各種')).
pick(w_tensei,          ja, n3, word, jmdict_kanji('天性')).
pick(w_kyuuhen,         ja, n3, word, jmdict_kanji('急変')).
pick(w_yukusue,         ja, n3, word, jmdict_kanji('行く末')).
pick(w_chuusei,         ja, n3, word, jmdict_kanji('中性')).
pick(w_gougai,          ja, n3, word, jmdict_kanji('号外')).
pick(w_shishu,          ja, n3, word, jmdict_kanji('死守')).
pick(w_fumuki,          ja, n3, word, jmdict_kanji('不向き')).
pick(w_komochi,         ja, n3, word, jmdict_kanji('子持ち')).
pick(w_kusachi,         ja, n3, word, jmdict_kanji('草地')).
pick(w_yukiki,          ja, n3, word, jmdict_kanji('行き来')).
pick(w_toguchi,         ja, n3, word, jmdict('1267000')).  % とぐち door; doorway
pick(w_gaten,           ja, n3, word, jmdict('1578950')).  % がてん consent; assent; understanding
pick(w_kanamono,        ja, n3, word, jmdict_kanji('金物')).
pick(w_etoku,           ja, n3, word, jmdict_kanji('会得')).
pick(w_monoshizuka,     ja, n3, word, jmdict_kanji('物静か')).
pick(w_shoushin,        ja, n3, word, jmdict_kanji('小心')).
pick(w_kumen,           ja, n3, word, jmdict_kanji('工面')).
pick(w_unsei,           ja, n3, word, jmdict_kanji('運勢')).
pick(w_maeoki,          ja, n3, word, jmdict_kanji('前置き')).
pick(w_shogyou,         ja, n3, word, jmdict_kanji('所業')).
pick(w_dousha,          ja, n3, word, jmdict_kanji('同社')).
pick(w_tonai,           ja, n3, word, jmdict_kanji('都内')).
pick(w_senzen,          ja, n3, word, jmdict_kanji('戦前')).
pick(w_kensuu,          ja, n3, word, jmdict_kanji('件数')).
pick(w_ryoumen,         ja, n3, word, jmdict('1554030')).  % りょうめん both sides; two sides; double-sided
pick(w_botai,           ja, n3, word, jmdict_kanji('母体')).
pick(w_saichou,         ja, n3, word, jmdict_kanji('最長')).
pick(w_renda,           ja, n3, word, jmdict_kanji('連打')).
pick(w_shinshin,        ja, n3, word, jmdict_kanji('心身')).
pick(w_kubun,           ja, n3, word, jmdict_kanji('区分')).
pick(w_touhou,          ja, n3, word, jmdict_kanji('東方')).
pick(w_makkou,          ja, n3, word, jmdict_kanji('真っ向')).
pick(w_kuuseki,         ja, n3, word, jmdict_kanji('空席')).
pick(w_nensuu,          ja, n3, word, jmdict_kanji('年数')).
pick(w_suii,            ja, n3, word, jmdict_kanji('水位')).
pick(w_ichidai,         ja, n3, word, jmdict_kanji('一大')).
pick(w_jitsurei,        ja, n3, word, jmdict_kanji('実例')).
pick(w_ryoushitsu,      ja, n3, word, jmdict_kanji('良質')).
pick(w_enbun,           ja, n3, word, jmdict_kanji('塩分')).
pick(w_jifu,            ja, n3, word, jmdict_kanji('自負')).
pick(w_neiro,           ja, n3, word, jmdict_kanji('音色')).
pick(w_shitashimi,      ja, n3, word, jmdict_kanji('親しみ')).
pick(w_zenkou,          ja, n3, word, jmdict_kanji('全校')).
pick(w_kanketsu,        ja, n3, word, jmdict_kanji('完結')).
pick(w_nagori,          ja, n3, word, jmdict_kanji('名残')).
pick(w_jitsuen,         ja, n3, word, jmdict_kanji('実演')).
pick(w_genpon,          ja, n3, word, jmdict_kanji('原本')).
pick(w_hitorimusuko,    ja, n3, word, jmdict_kanji('一人息子')).
pick(w_naijou,          ja, n3, word, jmdict_kanji('内情')).
pick(w_kyougaku,        ja, n3, word, jmdict_kanji('共学')).
pick(w_shissoku,        ja, n3, word, jmdict_kanji('失速')).
pick(w_kikitori,        ja, n3, word, jmdict_kanji('聞き取り')).
pick(w_korai,           ja, n3, word, jmdict_kanji('古来')).
pick(w_gokuraku,        ja, n3, word, jmdict_kanji('極楽')).
pick(w_seikan,          ja, n3, word, jmdict_kanji('静観')).
pick(w_tsumini,         ja, n3, word, jmdict_kanji('積み荷')).
pick(w_daiichi,         ja, n3, word, jmdict_kanji('第一')).
pick(w_taijin,          ja, n3, word, jmdict_kanji('対人')).
pick(w_kiro,            ja, n3, word, jmdict_kanji('帰路')).
pick(w_busshoku,        ja, n3, word, jmdict_kanji('物色')).
pick(w_kyuuyuu,         ja, n3, word, jmdict_kanji('級友')).
pick(w_hougai,          ja, n3, word, jmdict_kanji('法外')).
pick(w_sosei,           ja, n3, word, jmdict_kanji('組成')).
pick(w_seirai,          ja, n3, word, jmdict_kanji('生来')).
pick(w_nakayubi,        ja, n3, word, jmdict_kanji('中指')).
pick(w_hatarakimono,    ja, n3, word, jmdict_kanji('働き者')).
pick(w_chitei,          ja, n3, word, jmdict_kanji('地底')).
pick(w_nagareboshi,     ja, n3, word, jmdict_kanji('流れ星')).
pick(w_kiyoraka,        ja, n3, word, jmdict_kanji('清らか')).
pick(w_mushin,          ja, n3, word, jmdict_kanji('無心')).
pick(w_honmou,          ja, n3, word, jmdict_kanji('本望')).
pick(w_jishuu,          ja, n3, word, jmdict_kanji('自習')).
pick(w_maeba,           ja, n3, word, jmdict_kanji('前歯')).
pick(w_chiryoku,        ja, n3, word, jmdict_kanji('知力')).
pick(w_manjou,          ja, n3, word, jmdict_kanji('満場')).
pick(w_ketsuzoku,       ja, n3, word, jmdict_kanji('血族')).
pick(w_torikumi,        ja, n3, word, jmdict_kanji('取り組み')).
pick(w_shoten,          ja, n3, word, jmdict_kanji('書店')).
pick(w_menseki,         ja, n3, word, jmdict_kanji('面積')).
pick(w_shumoku,         ja, n3, word, jmdict_kanji('種目')).
pick(w_tennai,          ja, n3, word, jmdict_kanji('店内')).
pick(w_kazuooku,        ja, n3, word, jmdict_kanji('数多く')).
pick(w_nengan,          ja, n3, word, jmdict_kanji('念願')).
pick(w_karou,           ja, n3, word, jmdict_kanji('過労')).
pick(w_konki,           ja, n3, word, jmdict_kanji('今期')).
pick(w_taidan,          ja, n3, word, jmdict_kanji('対談')).
pick(w_jitsumei,        ja, n3, word, jmdict_kanji('実名')).
pick(w_outai,           ja, n3, word, jmdict_kanji('応対')).
pick(w_shuwa,           ja, n3, word, jmdict_kanji('手話')).
pick(w_meiki,           ja, n3, word, jmdict_kanji('明記')).
pick(w_hikiai,          ja, n3, word, jmdict_kanji('引き合い')).
pick(w_buppin,          ja, n3, word, jmdict_kanji('物品')).
pick(w_seriai,          ja, n3, word, jmdict_kanji('競り合い')).
pick(w_kiten,           ja, n3, word, jmdict_kanji('起点')).
pick(w_jibyou,          ja, n3, word, jmdict_kanji('持病')).
pick(w_hikki,           ja, n3, word, jmdict_kanji('筆記')).
pick(w_tenshin,         ja, n3, word, jmdict_kanji('転身')).
pick(w_oozora,          ja, n3, word, jmdict_kanji('大空')).
pick(w_gansho,          ja, n3, word, jmdict_kanji('願書')).
pick(w_shokuen,         ja, n3, word, jmdict_kanji('食塩')).
pick(w_koumyou,         ja, n3, word, jmdict_kanji('光明')).
pick(w_chaya,           ja, n3, word, jmdict_kanji('茶屋')).
pick(w_minamiguchi,     ja, n3, word, jmdict_kanji('南口')).
pick(w_heichi,          ja, n3, word, jmdict_kanji('平地')).
pick(w_kimatsu,         ja, n3, word, jmdict_kanji('期末')).
pick(w_shuusei,         ja, n3, word, jmdict_kanji('習性')).
pick(w_dote,            ja, n3, word, jmdict_kanji('土手')).
pick(w_ihyou,           ja, n3, word, jmdict_kanji('意表')).
pick(w_aiyou,           ja, n3, word, jmdict_kanji('愛用')).
pick(w_nisshoku,        ja, n3, word, jmdict_kanji('日食')).
pick(w_youkou,          ja, n3, word, jmdict_kanji('陽光')).
pick(w_shiokuri,        ja, n3, word, jmdict_kanji('仕送り')).
pick(w_raiten,          ja, n3, word, jmdict_kanji('来店')).
pick(w_katou,           ja, n3, word, jmdict('1186030')).  % かとう inferior; base; vulgar
pick(w_fushiawase,      ja, n3, word, jmdict_kanji('不幸せ')).
pick(w_migiue,          ja, n3, word, jmdict_kanji('右上')).
pick(w_teiban,          ja, n3, word, jmdict('1638070')).  % ていばん standard item; usual thing; (a) classic
pick(w_bukatsu,         ja, n3, word, jmdict_kanji('部活')).
pick(w_sanryuu,         ja, n3, word, jmdict('1301840')).  % さんりゅう third-rate; third-class
pick(w_shingetsu,       ja, n3, word, jmdict_kanji('新月')).
pick(w_fujitsu,         ja, n3, word, jmdict_kanji('不実')).
pick(w_gaiki,           ja, n3, word, jmdict_kanji('外気')).
pick(w_tabidachi,       ja, n3, word, jmdict_kanji('旅立ち')).
pick(w_yowane,          ja, n3, word, jmdict('1324670')).  % よわね feeble complaint; whine
pick(w_hosomi,          ja, n3, word, jmdict_kanji('細身')).
pick(w_mikiki,          ja, n3, word, jmdict_kanji('見聞き')).
pick(w_soushoku,        ja, n3, word, jmdict_kanji('草食')).
pick(w_kagai,           ja, n3, word, jmdict_kanji('課外')).
pick(w_ieji,            ja, n3, word, jmdict_kanji('家路')).
pick(w_nojuku,          ja, n3, word, jmdict_kanji('野宿')).
pick(w_kigokochi,       ja, n3, word, jmdict_kanji('着心地')).
pick(w_kyokushou,       ja, n3, word, jmdict_kanji('極小')).
pick(w_choumi,          ja, n3, word, jmdict_kanji('調味')).
pick(w_tomogui,         ja, n3, word, jmdict_kanji('共食い')).
pick(w_monban,          ja, n3, word, jmdict_kanji('門番')).
pick(w_boin,            ja, n3, word, jmdict_kanji('母音')).
pick(w_tsukurimono,     ja, n3, word, jmdict_kanji('作り物')).
pick(w_daisoreta,       ja, n3, word, jmdict_kanji('大それた')).
pick(w_inka,            ja, n3, word, jmdict_kanji('引火')).
pick(w_karimono,        ja, n3, word, jmdict_kanji('借り物')).
pick(w_doujitsu,        ja, n3, word, jmdict_kanji('同日')).
pick(w_toushu,          ja, n3, word, jmdict_kanji('投手')).
pick(w_senpatsu,        ja, n3, word, jmdict_kanji('先発')).
pick(w_naigai,          ja, n3, word, jmdict_kanji('内外')).
pick(w_bukka,           ja, n3, word, jmdict_kanji('物価')).
pick(w_renshou,         ja, n3, word, jmdict_kanji('連勝')).
pick(w_shui,            ja, n3, word, jmdict_kanji('首位')).
pick(w_kougai,          ja, n3, word, jmdict_kanji('公害')).
pick(w_juuten,          ja, n3, word, jmdict_kanji('重点')).
pick(w_shihyou,         ja, n3, word, jmdict_kanji('指標')).
pick(w_kouzu,           ja, n3, word, jmdict_kanji('構図')).
pick(w_shuujitsu,       ja, n3, word, jmdict('1332980')).  % しゅうじつ all day; for a whole day
pick(w_kojima,          ja, n3, word, jmdict_kanji('小島')).
pick(w_nentou,          ja, n3, word, jmdict_kanji('念頭')).
pick(w_hadome,          ja, n3, word, jmdict_kanji('歯止め')).
pick(w_naitei,          ja, n3, word, jmdict_kanji('内定')).
pick(w_rika,            ja, n3, word, jmdict_kanji('理科')).
pick(w_kyakuseki,       ja, n3, word, jmdict_kanji('客席')).
pick(w_naika,           ja, n3, word, jmdict_kanji('内科')).
pick(w_gakuryoku,       ja, n3, word, jmdict_kanji('学力')).
pick(w_yasuuri,         ja, n3, word, jmdict_kanji('安売り')).
pick(w_genbutsu,        ja, n3, word, jmdict_kanji('現物')).
pick(w_daishou,         ja, n3, word, jmdict_kanji('大小')).
pick(w_gekkyuu,         ja, n3, word, jmdict_kanji('月給')).
pick(w_enmoku,          ja, n3, word, jmdict_kanji('演目')).
pick(w_shuuyaku,        ja, n3, word, jmdict_kanji('集約')).
pick(w_shiagari,        ja, n3, word, jmdict_kanji('仕上がり')).
pick(w_hatsubyou,       ja, n3, word, jmdict_kanji('発病')).
pick(w_kouchi,          ja, n3, word, jmdict_kanji('高地')).
pick(w_hantsuki,        ja, n3, word, jmdict_kanji('半月')).
pick(w_tenmongaku,      ja, n3, word, jmdict_kanji('天文学')).
pick(w_hidane,          ja, n3, word, jmdict_kanji('火種')).
pick(w_ryousan,         ja, n3, word, jmdict_kanji('量産')).
pick(w_muzan,           ja, n3, word, jmdict_kanji('無残')).
pick(w_kaisou,          ja, n3, word, jmdict_kanji('回想')).
pick(w_senshou,         ja, n3, word, jmdict_kanji('戦勝')).
pick(w_suiryoku,        ja, n3, word, jmdict_kanji('水力')).
pick(w_yasuagari,       ja, n3, word, jmdict_kanji('安上がり')).
pick(w_ganseki,         ja, n3, word, jmdict_kanji('岩石')).
pick(w_sanshutsu,       ja, n3, word, jmdict_kanji('算出')).
pick(w_oukou,           ja, n3, word, jmdict_kanji('横行')).
pick(w_mukiryoku,       ja, n3, word, jmdict_kanji('無気力')).
pick(w_hatsuiku,        ja, n3, word, jmdict_kanji('発育')).
pick(w_binjou,          ja, n3, word, jmdict_kanji('便乗')).
pick(w_shingai,         ja, n3, word, jmdict_kanji('心外')).
pick(w_renpatsu,        ja, n3, word, jmdict_kanji('連発')).
pick(w_takaraka,        ja, n3, word, jmdict_kanji('高らか')).
pick(w_itten,           ja, n3, word, jmdict_kanji('一転')).
pick(w_taigen,          ja, n3, word, jmdict_kanji('体現')).
pick(w_kyakuma,         ja, n3, word, jmdict_kanji('客間')).
pick(w_hikikomori,      ja, n3, word, jmdict_kanji('引きこもり')).
pick(w_suekko,          ja, n3, word, jmdict_kanji('末っ子')).
pick(w_gokan,           ja, n3, word, jmdict_kanji('五感')).
pick(w_gense,           ja, n3, word, jmdict('1263790')).  % げんせ this world; this life; current epoch (i.e. the H
pick(w_tansho,          ja, n3, word, jmdict_kanji('短所')).
pick(w_taigai,          ja, n3, word, jmdict_kanji('体外')).
pick(w_tachibanashi,    ja, n3, word, jmdict_kanji('立ち話')).
pick(w_shitsugen,       ja, n3, word, jmdict_kanji('失言')).
pick(w_chikaramochi,    ja, n3, word, jmdict_kanji('力持ち')).
pick(w_judou,           ja, n3, word, jmdict_kanji('受動')).
pick(w_shinbu,          ja, n3, word, jmdict_kanji('深部')).
pick(w_shinmi,          ja, n3, word, jmdict_kanji('親身')).
pick(w_niryuu,          ja, n3, word, jmdict_kanji('二流')).
pick(w_chakusou,        ja, n3, word, jmdict_kanji('着想')).
pick(w_mukaigawa,       ja, n3, word, jmdict_kanji('向かい側')).
pick(w_honbun,          ja, n3, word, jmdict_kanji('本分')).
pick(w_wakaremichi,     ja, n3, word, jmdict_kanji('分かれ道')).
pick(w_netsubyou,       ja, n3, word, jmdict_kanji('熱病')).
pick(w_kiryou,          ja, n3, word, jmdict_kanji('器量')).
pick(w_kichi,           ja, n3, word, jmdict_kanji('機知')).
pick(w_tenkai,          ja, n3, word, jmdict_kanji('転回')).
pick(w_shitashirabe,    ja, n3, word, jmdict_kanji('下調べ')).
pick(w_zennen,          ja, n3, word, jmdict_kanji('前年')).
pick(w_shuryoku,        ja, n3, word, jmdict_kanji('主力')).
pick(w_sannyuu,         ja, n3, word, jmdict_kanji('参入')).
pick(w_daisotsu,        ja, n3, word, jmdict_kanji('大卒')).
pick(w_sakiokuri,       ja, n3, word, jmdict_kanji('先送り')).
pick(w_shosen,          ja, n3, word, jmdict_kanji('初戦')).
pick(w_doboku,          ja, n3, word, jmdict_kanji('土木')).
pick(w_keshiin,         ja, n3, word, jmdict_kanji('消印')).
pick(w_heiya,           ja, n3, word, jmdict_kanji('平野')).
pick(w_busuu,           ja, n3, word, jmdict_kanji('部数')).
pick(w_shoen,           ja, n3, word, jmdict_kanji('初演')).
pick(w_taisaku,         ja, n3, word, jmdict_kanji('大作')).
pick(w_hidori,          ja, n3, word, jmdict_kanji('日取り')).
pick(w_tenji,           ja, n3, word, jmdict_kanji('点字')).
pick(w_kyouen,          ja, n3, word, jmdict_kanji('共演')).
pick(w_kouzoku,         ja, n3, word, jmdict_kanji('後続')).
pick(w_keihin,          ja, n3, word, jmdict_kanji('景品')).
pick(w_shouhyou,        ja, n3, word, jmdict_kanji('商標')).
pick(w_amamizu,         ja, n3, word, jmdict_kanji('雨水')).
pick(w_meikyoku,        ja, n3, word, jmdict_kanji('名曲')).
pick(w_heijou,          ja, n3, word, jmdict_kanji('平常')).
pick(w_kyuumu,          ja, n3, word, jmdict_kanji('急務')).
pick(w_kyoutou,         ja, n3, word, jmdict_kanji('教頭')).
pick(w_issoku,          ja, n3, word, jmdict('1164400')).  % いっそく a pair (of shoes or socks)
pick(w_kyoushuu,        ja, n3, word, jmdict_kanji('教習')).
pick(w_setsudo,         ja, n3, word, jmdict_kanji('節度')).
pick(w_iroai,           ja, n3, word, jmdict_kanji('色合い')).
pick(w_juunibun,        ja, n3, word, jmdict_kanji('十二分')).
pick(w_ekiin,           ja, n3, word, jmdict_kanji('駅員')).
pick(w_kotai,           ja, n3, word, jmdict_kanji('固体')).
pick(w_saiki,           ja, n3, word, jmdict_kanji('再起')).
pick(w_furugi,          ja, n3, word, jmdict_kanji('古着')).
pick(w_meinichi,        ja, n3, word, jmdict_kanji('命日')).
pick(w_bosei,           ja, n3, word, jmdict_kanji('母性')).
pick(w_gaiyou,          ja, n3, word, jmdict_kanji('外洋')).
pick(w_kanagu,          ja, n3, word, jmdict_kanji('金具')).
pick(w_nagamochi,       ja, n3, word, jmdict_kanji('長持ち')).
pick(w_outen,           ja, n3, word, jmdict_kanji('横転')).
pick(w_monogokoro,      ja, n3, word, jmdict('1502610')).  % ものごころ awareness of things around one; ability to under
pick(w_tokuhitsu,       ja, n3, word, jmdict_kanji('特筆')).
pick(w_byousoku,        ja, n3, word, jmdict_kanji('秒速')).
pick(w_mukyuu,          ja, n3, word, jmdict_kanji('無給')).
pick(w_tsukanoma,       ja, n3, word, jmdict_kanji('つかの間')).
pick(w_shinagire,       ja, n3, word, jmdict_kanji('品切れ')).
pick(w_tashu,           ja, n3, word, jmdict_kanji('多種')).
pick(w_kanka,           ja, n3, word, jmdict_kanji('感化')).
pick(w_shuugyou,        ja, n3, word, jmdict_kanji('終業')).
pick(w_norigokochi,     ja, n3, word, jmdict_kanji('乗り心地')).
pick(w_junpuu,          ja, n3, word, jmdict_kanji('順風')).
pick(w_fudou,           ja, n3, word, jmdict_kanji('不同')).
pick(w_tabiji,          ja, n3, word, jmdict_kanji('旅路')).
pick(w_senkyoku,        ja, n3, word, jmdict_kanji('選曲')).
pick(w_noriba,          ja, n3, word, jmdict_kanji('乗り場')).
pick(w_kaneme,          ja, n3, word, jmdict('1243260')).  % かねめ valuable; high-priced; precious
pick(w_tetsujin,        ja, n3, word, jmdict_kanji('鉄人')).
pick(w_suigyuu,         ja, n3, word, jmdict_kanji('水牛')).
pick(w_miseban,         ja, n3, word, jmdict_kanji('店番')).
pick(w_shoyou,          ja, n3, word, jmdict_kanji('所用')).
pick(w_hadou,           ja, n3, word, jmdict_kanji('波動')).
pick(w_senten,          ja, n3, word, jmdict_kanji('先天')).
pick(w_ukemochi,        ja, n3, word, jmdict_kanji('受け持ち')).
pick(w_miketsu,         ja, n3, word, jmdict_kanji('未決')).
pick(w_kenbun,          ja, n3, word, jmdict_kanji('検分')).
pick(w_shitamuki,       ja, n3, word, jmdict_kanji('下向き')).
pick(w_ryoubun,         ja, n3, word, jmdict_kanji('領分')).
pick(w_gekai,           ja, n3, word, jmdict('1184620')).  % げかい the earth below; the ground below; this world (a
pick(w_oyadama,         ja, n3, word, jmdict_kanji('親玉')).
pick(w_kaomuke,         ja, n3, word, jmdict_kanji('顔向け')).
pick(w_kaisei,          ja, n3, word, jmdict_kanji('改正')).
pick(w_nichiya,         ja, n3, word, jmdict_kanji('日夜')).
pick(w_touzai,          ja, n3, word, jmdict_kanji('東西')).
pick(w_dasha,           ja, n3, word, jmdict_kanji('打者')).
pick(w_nijuu,           ja, n3, word, jmdict_kanji('二重')).
pick(w_gakka,           ja, n3, word, jmdict_kanji('学科')).
pick(w_kukan,           ja, n3, word, jmdict_kanji('区間')).
pick(w_shimen,          ja, n3, word, jmdict_kanji('紙面')).
pick(w_gakkyuu,         ja, n3, word, jmdict_kanji('学級')).
pick(w_yuusuu,          ja, n3, word, jmdict_kanji('有数')).
pick(w_ricchi,          ja, n3, word, jmdict_kanji('立地')).
pick(w_shokuyou,        ja, n3, word, jmdict_kanji('食用')).
pick(w_kougen,          ja, n3, word, jmdict_kanji('高原')).
pick(w_meibutsu,        ja, n3, word, jmdict_kanji('名物')).
pick(w_kakyoku,         ja, n3, word, jmdict_kanji('歌曲')).
pick(w_ichinin,         ja, n3, word, jmdict_kanji('一任')).
pick(w_chimei,          ja, n3, word, jmdict_kanji('地名')).
pick(w_kikubari,        ja, n3, word, jmdict_kanji('気配り')).
pick(w_getsumatsu,      ja, n3, word, jmdict_kanji('月末')).
pick(w_suion,           ja, n3, word, jmdict_kanji('水温')).
pick(w_issei,           ja, n3, word, jmdict('1576180')).  % いっせい generation; lifetime; the age
pick(w_ketsuin,         ja, n3, word, jmdict_kanji('欠員')).
pick(w_mizumashi,       ja, n3, word, jmdict_kanji('水増し')).
pick(w_munen,           ja, n3, word, jmdict_kanji('無念')).
pick(w_hakuba,          ja, n3, word, jmdict('1841490')).  % はくば white horse; unrefined sake
pick(w_kyouchi,         ja, n3, word, jmdict_kanji('境地')).
pick(w_shokuhi,         ja, n3, word, jmdict_kanji('食費')).
pick(w_yamamichi,       ja, n3, word, jmdict_kanji('山道')).
pick(w_shiroiro,        ja, n3, word, jmdict_kanji('白色')).
pick(w_seihou,          ja, n3, word, jmdict_kanji('西方')).
pick(w_tsukaimichi,     ja, n3, word, jmdict_kanji('使い道')).
pick(w_henyou,          ja, n3, word, jmdict_kanji('変容')).
pick(w_denchuu,         ja, n3, word, jmdict_kanji('電柱')).
pick(w_kika,            ja, n3, word, jmdict_kanji('帰化')).
pick(w_gyoson,          ja, n3, word, jmdict_kanji('漁村')).
pick(w_fuuryoku,        ja, n3, word, jmdict_kanji('風力')).
pick(w_tabisaki,        ja, n3, word, jmdict_kanji('旅先')).
pick(w_gakushou,        ja, n3, word, jmdict_kanji('楽章')).
pick(w_hinome,          ja, n3, word, jmdict_kanji('日の目')).
pick(w_funaka,          ja, n3, word, jmdict_kanji('不仲')).
pick(w_shuryou,         ja, n3, word, jmdict_kanji('首領')).
pick(w_migishita,       ja, n3, word, jmdict_kanji('右下')).
pick(w_atoaji,          ja, n3, word, jmdict_kanji('後味')).
pick(w_shousen,         ja, n3, word, jmdict_kanji('商船')).
pick(w_oonami,          ja, n3, word, jmdict_kanji('大波')).
pick(w_genjuusho,       ja, n3, word, jmdict_kanji('現住所')).
pick(w_torihazushi,     ja, n3, word, jmdict_kanji('取り外し')).
pick(w_jinetsu,         ja, n3, word, jmdict_kanji('地熱')).
pick(w_kisaku,          ja, n3, word, jmdict_kanji('気さく')).
pick(w_chakushoku,      ja, n3, word, jmdict_kanji('着色')).
pick(w_aisha,           ja, n3, word, jmdict_kanji('愛車')).
pick(w_oomugi,          ja, n3, word, jmdict_kanji('大麦')).
pick(w_kazashimo,       ja, n3, word, jmdict_kanji('風下')).
pick(w_kosui,           ja, n3, word, jmdict_kanji('湖水')).
pick(w_tejika,          ja, n3, word, jmdict_kanji('手近')).
pick(w_tabenokoshi,     ja, n3, word, jmdict_kanji('食べ残し')).
pick(w_ryousei,         ja, n3, word, jmdict_kanji('両性')).
pick(w_kashoku,         ja, n3, word, jmdict_kanji('過食')).
pick(w_yaken,           ja, n3, word, jmdict('1537350')).  % やけん stray dog; ownerless dog
pick(w_hirate,          ja, n3, word, jmdict_kanji('平手')).
pick(w_kanpuku,         ja, n3, word, jmdict_kanji('感服')).
pick(w_hitotoori,       ja, n3, word, jmdict_kanji('一通り')).
pick(w_hashirigaki,     ja, n3, word, jmdict_kanji('走り書き')).
pick(w_suitei,          ja, n3, word, jmdict('1649920')).  % すいてい bottom of the water; bottom of the sea; river bo
pick(w_otoshimono,      ja, n3, word, jmdict_kanji('落し物')).
pick(w_shuki,           ja, n3, word, jmdict_kanji('酒気')).
pick(w_banbutsu,        ja, n3, word, jmdict_kanji('万物')).
pick(w_wakemae,         ja, n3, word, jmdict_kanji('分け前')).
pick(w_kakinaoshi,      ja, n3, word, jmdict_kanji('書き直し')).
pick(w_tesou,           ja, n3, word, jmdict_kanji('手相')).
pick(w_tokutou,         ja, n3, word, jmdict_kanji('特等')).
pick(w_jiji,            ja, n3, word, jmdict_kanji('時事')).
pick(w_kaikan,          ja, n3, word, jmdict_kanji('会館')).
pick(w_genpatsu,        ja, n3, word, jmdict_kanji('原発')).
pick(w_takaku,          ja, n3, word, jmdict_kanji('多角')).
pick(w_teiin,           ja, n3, word, jmdict_kanji('定員')).
pick(w_chuuki,          ja, n3, word, jmdict_kanji('中期')).
pick(w_fubo,            ja, n3, word, jmdict_kanji('父母')).
pick(w_yuden,           ja, n3, word, jmdict_kanji('油田')).
pick(w_kashitsuke,      ja, n3, word, jmdict_kanji('貸付')).
pick(w_hyoukou,         ja, n3, word, jmdict_kanji('標高')).
pick(w_yodan,           ja, n3, word, jmdict_kanji('予断')).
pick(w_tsuugaku,        ja, n3, word, jmdict_kanji('通学')).
pick(w_doai,            ja, n3, word, jmdict_kanji('度合い')).
pick(w_butsuryuu,       ja, n3, word, jmdict_kanji('物流')).
pick(w_shuuseki,        ja, n3, word, jmdict_kanji('集積')).
pick(w_kugiri,          ja, n3, word, jmdict_kanji('区切り')).
pick(w_seigou,          ja, n3, word, jmdict_kanji('整合')).
pick(w_honba,           ja, n3, word, jmdict_kanji('本場')).
pick(w_shokai,          ja, n3, word, jmdict_kanji('初回')).
pick(w_kakuyasu,        ja, n3, word, jmdict_kanji('格安')).
pick(w_jiden,           ja, n3, word, jmdict_kanji('自伝')).
