% graph/ja/travel.pl -- what a trip to Japan needs said and understood.
%
% Hand-written, like the starter words, and for the same reason: no
% source we can use publishes "the forty sentences of a week in Kyoto".
% The list came from a native speaker's description of the goal -- the
% bathroom, the hotel desk, the platform -- and was filled out along the
% same line: asking, paying, eating, and getting help.
%
% A PHRASE IS ITS OWN KIND, not a word.  vocabulary(N, Channel) counts
% words, and forty sentences added to that count would be forty words a
% student never learned.  A phrase is asked whole and answered by
% meaning: here it is, which of these does it say.  Some are things the
% traveller says and some are things said TO them (げんきんだけです),
% because half of asking for a platform is understanding the answer.
%
% ONLY UNDER :goal travel.  The engine leaves these out of everybody
% else's plan (lp_plan in langpop.p), so the exam student's ladder is
% what it was.
%
% Kana only, because pre-school is the kana rung: every phrase needs the
% hiragana, and the ones with a loanword in them need the katakana too.
% The `hiragana` form of those holds both scripts.  It is the sentence
% as it is written without kanji, and the voice reads it the same.
%
% NOT REVIEWED by a native speaker at the time of writing.

item(Id, phrase, ja, preschool, own(travel_list)) :- travel_ja(Id, _, _, _).
form(Id, hiragana, Kana) :- travel_ja(Id, _, Kana, _).
gloss(Id, en, En) :- travel_ja(Id, _, _, En).
situation(Id, Sit) :- travel_ja(Id, Sit, _, _).
requires(Id, hiragana_all) :- travel_ja(Id, _, _, _).
requires(Id, katakana_all) :- travel_ja_kata(Id).

% travel_ja(Id, Situation, Kana, GlossEn).

% --- Getting by -----------------------------------------------------------
travel_ja(t_sumimasen,   basics, 'すみません',               'Excuse me').
travel_ja(t_arigatou,    basics, 'ありがとうございます',     'Thank you').
travel_ja(t_onegai,      basics, 'おねがいします',           'Yes, please').
travel_ja(t_wakarimasen, basics, 'わかりません',             'I do not understand').
travel_ja(t_eigo,        basics, 'えいごをはなせますか',     'Do you speak English?').
travel_ja(t_mouichido,   basics, 'もういちどおねがいします', 'Once more, please').
travel_ja(t_yukkuri,     basics, 'ゆっくりおねがいします',   'Slowly, please').

% --- The bathroom, and finding things -------------------------------------
travel_ja(t_toire,       street, 'トイレはどこですか',       'Where is the bathroom?').
travel_ja(t_eki_doko,    street, 'えきはどこですか',         'Where is the station?').
travel_ja(t_migi,        street, 'みぎにまがってください',   'Please turn right').
travel_ja(t_hidari,      street, 'ひだりにまがってください', 'Please turn left').
travel_ja(t_massugu,     street, 'まっすぐいってください',   'Please go straight on').
travel_ja(t_chikai,      street, 'ここからちかいですか',     'Is it near here?').

% --- Trains ---------------------------------------------------------------
travel_ja(t_nanbansen,   train,  'なんばんせんですか',       'Which platform is it?').
travel_ja(t_sanbansen,   train,  'さんばんせんです',         'It is platform three').
travel_ja(t_kippu,       train,  'きっぷをいちまいください', 'One ticket, please').
travel_ja(t_kyouto_iku,  train,  'このでんしゃはきょうとにいきますか',
                                                             'Does this train go to Kyoto?').
travel_ja(t_tsugi,       train,  'つぎのえきはどこですか',   'What is the next station?').
travel_ja(t_norikae,     train,  'のりかえはどこですか',     'Where do I change trains?').

% --- The hotel ------------------------------------------------------------
travel_ja(t_checkin,     hotel,  'チェックインをおねがいします', 'I would like to check in').
travel_ja(t_yoyaku,      hotel,  'よやくがあります',         'I have a reservation').
travel_ja(t_kagi,        hotel,  'へやのかぎをください',     'The room key, please').
travel_ja(t_asagohan,    hotel,  'あさごはんはなんじですか', 'What time is breakfast?').
travel_ja(t_checkout,    hotel,  'チェックアウトはなんじですか', 'What time is check-out?').

% --- Eating ---------------------------------------------------------------
travel_ja(t_futari,      food,   'ふたりです',               'There are two of us').
travel_ja(t_menu,        food,   'メニューをください',       'The menu, please').
travel_ja(t_kore,        food,   'これをください',           'This one, please').
travel_ja(t_mizu,        food,   'みずをください',           'Water, please').
travel_ja(t_okaikei,     food,   'おかいけいをおねがいします', 'The bill, please').
travel_ja(t_oishikatta,  food,   'おいしかったです',         'That was delicious').

% --- Paying ---------------------------------------------------------------
travel_ja(t_ikura,       shop,   'いくらですか',             'How much is it?').
travel_ja(t_card,        shop,   'カードはつかえますか',     'Can I pay by card?').
travel_ja(t_genkin,      shop,   'げんきんだけです',         'Cash only').
travel_ja(t_fukuro,      shop,   'ふくろはいりますか',       'Do you need a bag?').

% --- When it goes wrong ---------------------------------------------------
travel_ja(t_tasukete,    help,   'たすけてください',         'Please help me').
travel_ja(t_byouin,      help,   'びょういんはどこですか',   'Where is the hospital?').
travel_ja(t_passport,    help,   'パスポートをなくしました', 'I have lost my passport').
travel_ja(t_keisatsu,    help,   'けいさつをよんでください', 'Please call the police').

travel_ja_kata(t_toire).
travel_ja_kata(t_checkin).
travel_ja_kata(t_checkout).
travel_ja_kata(t_menu).
travel_ja_kata(t_card).
travel_ja_kata(t_passport).
