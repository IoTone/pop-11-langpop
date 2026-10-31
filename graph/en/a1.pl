% graph/en/a1.pl -- A1 English, for a Japanese speaker.
%
% Committed, and hand-written, which needs saying because the Japanese
% side's N5 words are neither (graph/ja/picks/n5.pl + an import).  The
% asymmetry is not an inconsistency; it is what the sources know.
%
% JMdict can be read BACKWARDS -- find the entries whose English gloss is
% 'water' and take their Japanese headwords -- and that was the obvious
% way to get these glosses for free.  It was measured before it was
% built, and it does not work:
%
%     water     -> 水分, お水, ウォーター      and never 水
%     think     -> シンク                     (the katakana loanword)
%     mountain  -> ベルグ, マウンテン, 山       (the first is German)
%     very      -> 迚も                       (an archaic spelling)
%     remember  -> 銘記
%
% Filtering to JMdict's priority-tagged entries and dropping the
% katakana-only ones cleans up the worst of it (mountain -> 山) and still
% leaves water -> 水分, which is "moisture", and very -> 迚も.  An exact
% match on a gloss is not a translation: a bilingual dictionary is
% organised to explain Japanese words in English, and reading it the
% other way finds whichever Japanese word happens to have the bare
% English word as its gloss -- which favours archaisms and transliterated
% loanwords, the latter being exactly what the pre-school level warns
% about.  Teaching 'water' as 水分 is worse than not glossing it.
%
% So the Japanese gloss is ours, typed here.  No licence reaches it, and
% nothing upstream has an opinion about which English words are A1 in the
% first place.  What the importer DOES add to these items is the one
% thing no person should type a hundred times and no human judgment
% improves: the pronunciation, and the sound contrasts it exercises --
% see import.p --source cmudict.
%
% A1 is TOEIC 120-225 (graph/en/ladder.pl).  It was a first tranche of
% 100 words; it is 519 now, in two tranches, and exit(en, a1,
% vocabulary(500, read), ...) is met -- the first English rung to be
% finishable on its content rather than on an excuse.  The next count up
% the ladder is exit(en, a2, vocabulary(1000, read), ...), so this file
% is half of A2 as well and the rows below are not sorted by rung.

item(Id, word, en, a1, own(a1_list)) :- a1(Id, _, _, _).
form(Id, latin, Word) :- a1(Id, Word, _, _).
gloss(Id, en, En) :- a1(Id, _, En, _).
gloss(Id, ja, Ja) :- a1(Id, _, _, Ja).

% a1(Id, Word, GlossEn, GlossJa).

% --- People and family ---------------------------------------------------
a1(e_people,     'people',     'persons, in general',        '人々').
a1(e_family,     'family',     'the people you live with',   '家族').
a1(e_father,     'father',     'a male parent',              '父').
a1(e_mother,     'mother',     'a female parent',            '母').
a1(e_brother,    'brother',    'a male sibling',             '兄弟').
a1(e_sister,     'sister',     'a female sibling',           '姉妹').
a1(e_child,      'child',      'a young person',             '子供').
a1(e_friend,     'friend',     'someone you like and know',  '友達').
a1(e_woman,      'woman',      'an adult female',            '女性').
a1(e_student,    'student',    'someone who studies',        '学生').
a1(e_teacher,    'teacher',    'someone who teaches',        '先生').
a1(e_girl,       'girl',       'a young female',             '女の子').
a1(e_doctor,     'doctor',     'someone who treats illness', '医者').

% --- Places --------------------------------------------------------------
a1(e_house,      'house',      'a building people live in',  '家').
a1(e_school,     'school',     'where students are taught',  '学校').
a1(e_room,       'room',       'a space inside a building',  '部屋').
a1(e_street,     'street',     'a road in a town',           '通り').
a1(e_city,       'city',       'a large town',               '都市').
a1(e_country,    'country',    'a nation',                   '国').
a1(e_world,      'world',      'the earth and everyone on it','世界').
a1(e_station,    'station',    'where trains stop',          '駅').
a1(e_hospital,   'hospital',   'where the ill are treated',  '病院').
a1(e_library,    'library',    'where books are kept',       '図書館').
a1(e_office,     'office',     'where people do office work','事務所').
a1(e_shop,       'shop',       'where things are sold',      '店').
a1(e_restaurant, 'restaurant', 'where meals are sold',       'レストラン').

% --- Things --------------------------------------------------------------
a1(e_water,      'water',      'the liquid we drink',        '水').
a1(e_food,       'food',       'what we eat',                '食べ物').
a1(e_book,       'book',       'pages bound together',       '本').
a1(e_letter,     'letter',     'a written message sent',     '手紙').
a1(e_money,      'money',      'what things are bought with','お金').
a1(e_car,        'car',        'a vehicle you drive',        '車').
a1(e_train,      'train',      'a vehicle on rails',         '電車').
a1(e_table,      'table',      'a flat surface on legs',     'テーブル').
a1(e_door,       'door',       'what you open to go through', 'ドア').
a1(e_window,     'window',     'an opening with glass',      '窓').
a1(e_picture,    'picture',    'a drawing or photograph',    '写真').
a1(e_music,      'music',      'organised sound',            '音楽').
a1(e_phone,      'phone',      'what you call people on',    '電話').
a1(e_number,     'number',     'a quantity in figures',      '数').
a1(e_word,       'word',       'a unit of language',         '単語').
a1(e_problem,    'problem',    'something difficult to solve','問題').
a1(e_question,   'question',   'what you ask',               '質問').
a1(e_answer,     'answer',     'what you reply',             '答え').
a1(e_clothes,    'clothes',    'what you wear',              '服').
a1(e_flower,     'flower',     'the bloom of a plant',       '花').
a1(e_tree,       'tree',       'a tall woody plant',         '木').
a1(e_animal,     'animal',     'a living creature',          '動物').

% --- Time and weather ----------------------------------------------------
a1(e_time,       'time',       'when things happen',         '時間').
a1(e_day,        'day',        'twenty-four hours',          '日').
a1(e_week,       'week',       'seven days',                 '週').
a1(e_month,      'month',      'about thirty days',          '月').
a1(e_year,       'year',       'twelve months',              '年').
a1(e_morning,    'morning',    'the early part of the day',  '朝').
a1(e_night,      'night',      'when it is dark',            '夜').
a1(e_weather,    'weather',    'the state of the air',       '天気').
a1(e_rain,       'rain',       'water falling from the sky',  '雨').
a1(e_snow,       'snow',       'frozen water falling',       '雪').
a1(e_summer,     'summer',     'the hot season',             '夏').
a1(e_winter,     'winter',     'the cold season',            '冬').

% --- Doing ---------------------------------------------------------------
a1(e_eat,        'eat',        'to take in food',            '食べる').
a1(e_drink,      'drink',      'to take in liquid',          '飲む').
a1(e_go,         'go',         'to move away from here',     '行く').
a1(e_come,       'come',       'to move towards here',       '来る').
a1(e_see,        'see',        'to perceive with the eyes',  '見る').
a1(e_listen,     'listen',     'to pay attention to sound',  '聞く').
a1(e_speak,      'speak',      'to say words aloud',         '話す').
a1(e_read,       'read',       'to take in written words',   '読む').
a1(e_write,      'write',      'to put down words',          '書く').
a1(e_learn,      'learn',      'to come to know',            '学ぶ').
a1(e_think,      'think',      'to use the mind',            '考える').
a1(e_know,       'know',       'to have in mind as true',    '知る').
a1(e_want,       'want',       'to wish to have',            '欲しい').
a1(e_make,       'make',       'to bring into being',        '作る').
a1(e_take,       'take',       'to get hold of',             '取る').
a1(e_give,       'give',       'to hand to someone',         'あげる').
a1(e_buy,        'buy',        'to get for money',           '買う').
a1(e_walk,       'walk',       'to go on foot',              '歩く').
a1(e_sleep,      'sleep',      'to rest unconscious',        '寝る').
a1(e_live,       'live',       'to have one\'s home',        '住む').
a1(e_work,       'work',       'to do a job',                '働く').
a1(e_help,       'help',       'to make easier for someone', '助ける').
a1(e_wait,       'wait',       'to stay until something',    '待つ').
a1(e_meet,       'meet',       'to come together with',      '会う').
a1(e_find,       'find',       'to come upon',               '見つける').
a1(e_remember,   'remember',   'to keep in mind',            '覚える').
a1(e_understand, 'understand', 'to grasp the meaning',       '理解する').
a1(e_travel,     'travel',     'to go a long way',           '旅行する').

% --- Describing ----------------------------------------------------------
a1(e_big,        'big',        'of great size',              '大きい').
a1(e_small,      'small',      'of little size',             '小さい').
a1(e_long,       'long',       'of great length',            '長い').
a1(e_new,        'new',        'made or begun recently',     '新しい').
a1(e_good,       'good',       'of a high standard',         '良い').
a1(e_difficult,  'difficult',  'hard to do',                 '難しい').
a1(e_expensive,  'expensive',  'costing a lot',              '高い').
a1(e_beautiful,  'beautiful',  'pleasing to look at',        '美しい').
a1(e_strong,     'strong',     'having great force',         '強い').
a1(e_early,      'early',      'before the usual time',      '早い').
a1(e_busy,       'busy',       'having much to do',          '忙しい').
a1(e_very,       'very',       'to a high degree',           'とても').

% =========================================================================
% THE SECOND TRANCHE (2026-10-31): 419 more words, taking the level to 519.
%
% WHY A SECOND TRANCHE AND NOT A REWRITE of the sections above: the rows
% are append-only so that the first hundred, which have been drilled and
% re-imported twice, keep their ids and their place.  The themes repeat
% below because the theme is how a learner meets them, not how the file
% is laid out.
%
% HOW THESE WERE CHOSEN, and what the frequency list was allowed to
% decide.  Nothing upstream has an opinion about which English words are
% A1 -- the header above says so -- so the pick is ours.  What the
% corpus was used for is ATTESTATION, not selection: every word below
% appears in en_50k.txt (OpenSubtitles, 50,000 entries) and in CMUdict,
% which is a mechanical check that nothing archaic, misspelled or
% invented crept in.  Median rank 983, worst 8551 (`insect`).
%
% That worst rank is the argument for not letting frequency choose.
% `pencil` is rank 5821 and `vegetable` 7532 in film dialogue, and both
% are in every A1 syllabus ever written: characters in films do not say
% "vegetable" and learners do.  A dialogue corpus is a good measure of
% what English sounds like and a bad measure of what a beginner needs.
%
% WHAT IS DELIBERATELY ABSENT.  Not one of the rows in
% docs/langpop-function-words.md is here -- the pronouns, the
% prepositions, the articles, `be`, `do`, `have`.  That tranche is a
% queue awaiting an owner's marks, six of its rows need a decision
% nobody should make alone, and taking them here would be answering
% those questions by writing content.  `what` is in that queue, which is
% why the question words below are the other six.
%
% And four words were dropped for the reason that queue defers `just`,
% `like` and `get`: `back`, `kind`, `well` and `light` carry their rank
% in dialogue on a sense that is not the one a beginner wants (come
% back, kind of, well..., all right).  A gloss that covers the rank
% would not be the word.  `glass` is absent too, because m_glass
% already teaches that spelling as what a window is made of and a
% second row calling it a drinking vessel would make the graph say two
% things about one word.
%
% AND THREE GLOSSES NAME THEIR SENSE because the Japanese word alone was
% already taken: 店舗 for `store` where `shop` has 店, 1時間 for `hour`
% where `time` has 時間, （位置が）高い for `high` where `expensive` has
% 高い.  A learner shown two items whose gloss in their own language is
% the same word has been given no way to tell them apart -- which is
% checkable, and is checked: no two rows in this file share a Japanese
% gloss.

% --- People and family, continued ----------------------------------------
a1(e_man,         'man',         'an adult male',                     '男性').
a1(e_baby,        'baby',        'a very young child',                '赤ちゃん').
a1(e_boy,         'boy',         'a young male',                      '男の子').
a1(e_son,         'son',         'a male child of a parent',          '息子').
a1(e_daughter,    'daughter',    'a female child of a parent',        '娘').
a1(e_husband,     'husband',     'a married man',                     '夫').
a1(e_wife,        'wife',        'a married woman',                   '妻').
a1(e_parent,      'parent',      'a father or a mother',              '親').
a1(e_grandfather, 'grandfather', 'the father of a parent',            '祖父').
a1(e_grandmother, 'grandmother', 'the mother of a parent',            '祖母').
a1(e_uncle,       'uncle',       'the brother of a parent',           'おじ').
a1(e_aunt,        'aunt',        'the sister of a parent',            'おば').
a1(e_cousin,      'cousin',      'the child of an uncle or aunt',     'いとこ').
a1(e_name,        'name',        'what a person is called',           '名前').
a1(e_person,      'person',      'one human being',                   '人').
a1(e_guest,       'guest',       'someone you have invited',          '客').
a1(e_nurse,       'nurse',       'someone who cares for the sick',    '看護師').
a1(e_driver,      'driver',      'someone who drives',                '運転手').
a1(e_farmer,      'farmer',      'someone who grows food',            '農家').
a1(e_singer,      'singer',      'someone who sings',                 '歌手').
a1(e_writer,      'writer',      'someone who writes',                '作家').
a1(e_worker,      'worker',      'someone who works for pay',         '労働者').
a1(e_boss,        'boss',        'the person in charge of you',       '上司').
a1(e_customer,    'customer',    'someone who buys',                  '客・顧客').
a1(e_visitor,     'visitor',     'someone who comes to see you',      '訪問者').
a1(e_king,        'king',        'a male ruler',                      '王').
a1(e_queen,       'queen',       'a female ruler',                    '女王').
a1(e_group,       'group',       'several together',                  '集団・グループ').
a1(e_team,        'team',        'people playing or working as one',  'チーム').

% --- The body ------------------------------------------------------------
a1(e_head,        'head',        'the top of the body',               '頭').
a1(e_face,        'face',        'the front of the head',             '顔').
a1(e_eye,         'eye',         'you see with it',                   '目').
a1(e_ear,         'ear',         'you hear with it',                  '耳').
a1(e_nose,        'nose',        'you smell with it',                 '鼻').
a1(e_mouth,       'mouth',       'you eat and speak with it',         '口').
a1(e_hand,        'hand',        'at the end of the arm',             '手').
a1(e_foot,        'foot',        'at the end of the leg',             '足').
a1(e_leg,         'leg',         'the part you walk on',              '脚').
a1(e_arm,         'arm',         'from the shoulder to the hand',     '腕').
a1(e_hair,        'hair',        'it grows on the head',              '髪').
a1(e_tooth,       'tooth',       'you bite with it',                  '歯').
a1(e_finger,      'finger',      'one of five on a hand',             '指').
a1(e_heart,       'heart',       'it moves the blood',                '心臓').
a1(e_body,        'body',        'the whole of a person',             '体').
a1(e_skin,        'skin',        'the outside of the body',           '肌').
a1(e_stomach,     'stomach',     'where food goes',                   '胃・お腹').
a1(e_knee,        'knee',        'the middle of the leg',             '膝').
a1(e_shoulder,    'shoulder',    'where the arm meets the body',      '肩').
a1(e_blood,       'blood',       'the red liquid inside',             '血').
a1(e_bone,        'bone',        'the hard parts inside',             '骨').
a1(e_voice,       'voice',       'the sound a person makes',          '声').

% --- Food and drink ------------------------------------------------------
a1(e_bread,       'bread',       'baked from flour',                  'パン').
a1(e_rice,        'rice',        'the grain you eat',                 '米・ご飯').
a1(e_meat,        'meat',        'the flesh of an animal',            '肉').
a1(e_fish,        'fish',        'it swims, and you eat it',          '魚').
a1(e_egg,         'egg',         'a bird lays it',                    '卵').
a1(e_milk,        'milk',        'the white drink from a cow',        '牛乳').
a1(e_tea,         'tea',         'a hot drink from leaves',           'お茶').
a1(e_coffee,      'coffee',      'the dark hot drink',                'コーヒー').
a1(e_juice,       'juice',       'the drink from fruit',              'ジュース').
a1(e_sugar,       'sugar',       'it makes things sweet',             '砂糖').
a1(e_salt,        'salt',        'the white seasoning from the sea',  '塩').
a1(e_fruit,       'fruit',       'the sweet part of a plant',         '果物').
a1(e_apple,       'apple',       'a round red or green fruit',        'りんご').
a1(e_orange,      'orange',      'a round citrus fruit',              'オレンジ').
a1(e_banana,      'banana',      'a long yellow fruit',               'バナナ').
a1(e_vegetable,   'vegetable',   'a plant grown to eat',              '野菜').
a1(e_potato,      'potato',      'a vegetable from the ground',       'じゃがいも').
a1(e_tomato,      'tomato',      'a round red vegetable',             'トマト').
a1(e_soup,        'soup',        'a hot liquid food',                 'スープ').
a1(e_cake,        'cake',        'a sweet baked food',                'ケーキ').
a1(e_chocolate,   'chocolate',   'a sweet brown food',                'チョコレート').
a1(e_cheese,      'cheese',      'a food made from milk',             'チーズ').
a1(e_butter,      'butter',      'a soft yellow food from milk',      'バター').
a1(e_breakfast,   'breakfast',   'the first meal of the day',         '朝食').
a1(e_lunch,       'lunch',       'the middle meal of the day',        '昼食').
a1(e_dinner,      'dinner',      'the evening meal',                  '夕食').
a1(e_meal,        'meal',        'food eaten at one time',            '食事').
a1(e_menu,        'menu',        'the list of what you may order',    'メニュー').
a1(e_sandwich,    'sandwich',    'food between two slices of bread',  'サンドイッチ').
a1(e_dessert,     'dessert',     'the sweet course at the end',       'デザート').
a1(e_ice,         'ice',         'frozen water',                      '氷').

% --- Animals -------------------------------------------------------------
a1(e_dog,         'dog',         'the animal that barks',             '犬').
a1(e_cat,         'cat',         'the animal that says meow',         '猫').
a1(e_bird,        'bird',        'it has wings and flies',            '鳥').
a1(e_horse,       'horse',       'you can ride it',                   '馬').
a1(e_cow,         'cow',         'it gives milk',                     '牛').
a1(e_pig,         'pig',         'the pink farm animal',              '豚').
a1(e_sheep,       'sheep',       'it gives wool',                     '羊').
a1(e_mouse,       'mouse',       'a small grey animal',               'ネズミ').
a1(e_rabbit,      'rabbit',      'it has long ears and hops',         'うさぎ').
a1(e_chicken,     'chicken',     'the farm bird',                     '鶏').
a1(e_insect,      'insect',      'a very small animal with six legs', '虫').
a1(e_bear,        'bear',        'a large wild animal',               '熊').
a1(e_lion,        'lion',        'the big cat of Africa',             'ライオン').
a1(e_monkey,      'monkey',      'it climbs and has a tail',          '猿').
a1(e_elephant,    'elephant',    'the biggest land animal',           '象').
a1(e_snake,       'snake',       'a long animal with no legs',        '蛇').
a1(e_frog,        'frog',        'it jumps and lives near water',     'カエル').

% --- Clothes and what you carry ------------------------------------------
a1(e_shirt,       'shirt',       'worn on the upper body',            'シャツ').
a1(e_shoe,        'shoe',        'worn on the foot',                  '靴').
a1(e_hat,         'hat',         'worn on the head',                  '帽子').
a1(e_coat,        'coat',        'worn over everything, outdoors',    'コート').
a1(e_dress,       'dress',       'one garment, top and skirt',        'ワンピース').
a1(e_skirt,       'skirt',       'worn from the waist down',          'スカート').
a1(e_pants,       'pants',       'worn on both legs',                 'ズボン').
a1(e_sock,        'sock',        'worn on the foot, inside a shoe',   '靴下').
a1(e_glove,       'glove',       'worn on the hand',                  '手袋').
a1(e_bag,         'bag',         'you carry things in it',            'かばん').
a1(e_ring,        'ring',        'worn on a finger',                  '指輪').
a1(e_pocket,      'pocket',      'the small bag in clothes',          'ポケット').
a1(e_button,      'button',      'it fastens clothes',                'ボタン').
a1(e_umbrella,    'umbrella',    'it keeps the rain off',             '傘').
a1(e_glasses,     'glasses',     'worn to see better',                '眼鏡').
a1(e_uniform,     'uniform',     'the clothes a job or school asks',  '制服').

% --- Colours -------------------------------------------------------------
% `orange` the fruit has the row above, and the color has none: one
% spelling gets one row, and the fruit is the one a beginner meets first.
% `gray` rather than `grey` because the spelling has to be one CMUdict
% knows: it is the pronunciation source, and --source cmudict looks each
% word up by its latin form, so a spelling it does not carry is a word
% with no IPA and no sound-contrast edges.  That is the rule throughout
% this tranche, and it is why `color` has no u and `autumn` -- which
% CMUdict does carry -- keeps its British self.
a1(e_red,         'red',         'the color of blood',                '赤').
a1(e_blue,        'blue',        'the color of the sky',              '青').
a1(e_green,       'green',       'the color of grass',                '緑').
a1(e_yellow,      'yellow',      'the color of a lemon',              '黄色').
a1(e_white,       'white',       'the color of snow',                 '白').
a1(e_black,       'black',       'the color of night',                '黒').
a1(e_brown,       'brown',       'the color of earth',                '茶色').
a1(e_pink,        'pink',        'pale red',                          'ピンク').
a1(e_gray,        'gray',        'between black and white',           '灰色').
a1(e_color,       'color',       'red, blue, green and the rest',     '色').

% --- Numbers and how much ------------------------------------------------
a1(e_one,         'one',         'the number 1',                      '一').
a1(e_two,         'two',         'the number 2',                      '二').
a1(e_three,       'three',       'the number 3',                      '三').
a1(e_four,        'four',        'the number 4',                      '四').
a1(e_five,        'five',        'the number 5',                      '五').
a1(e_six,         'six',         'the number 6',                      '六').
a1(e_seven,       'seven',       'the number 7',                      '七').
a1(e_eight,       'eight',       'the number 8',                      '八').
a1(e_nine,        'nine',        'the number 9',                      '九').
a1(e_ten,         'ten',         'the number 10',                     '十').
a1(e_hundred,     'hundred',     'the number 100',                    '百').
a1(e_thousand,    'thousand',    'the number 1000',                   '千').
a1(e_first,       'first',       'before all the others',             '最初の').
a1(e_many,        'many',        'a large number of them',            '多くの').
a1(e_few,         'few',         'a small number of them',            '少しの').
a1(e_enough,      'enough',      'as much as is needed',              '十分な').
a1(e_half,        'half',        'one of two equal parts',            '半分').

% --- Time, continued -----------------------------------------------------
a1(e_hour,        'hour',        'sixty minutes',                     '1時間').
a1(e_minute,      'minute',      'sixty seconds',                     '分').
a1(e_today,       'today',       'this day',                          '今日').
a1(e_tomorrow,    'tomorrow',    'the day after this one',            '明日').
a1(e_yesterday,   'yesterday',   'the day before this one',           '昨日').
a1(e_afternoon,   'afternoon',   'after noon, before evening',        '午後').
a1(e_evening,     'evening',     'the end of the day',                '夕方').
a1(e_midnight,    'midnight',    'twelve hours after noon',           '真夜中').
a1(e_spring,      'spring',      'the season after winter',           '春').
a1(e_autumn,      'autumn',      'the season after summer',           '秋').
a1(e_season,      'season',      'one of the four parts of a year',   '季節').
a1(e_birthday,    'birthday',    'the day you were born',             '誕生日').
a1(e_holiday,     'holiday',     'a day with no work',                '休日').
a1(e_weekend,     'weekend',     'Saturday and Sunday',               '週末').
a1(e_clock,       'clock',       'it tells the time',                 '時計').

% --- The sky and the weather, continued ----------------------------------
a1(e_sun,         'sun',         'it lights the day',                 '太陽').
a1(e_wind,        'wind',        'moving air',                        '風').
a1(e_cloud,       'cloud',       'a white shape in the sky',          '雲').
a1(e_storm,       'storm',       'violent wind and rain',             '嵐').
a1(e_sky,         'sky',         'what is above you outdoors',        '空').

% --- Places, continued ---------------------------------------------------
a1(e_park,        'park',        'green ground in a town',            '公園').
a1(e_bank,        'bank',        'it keeps your money',               '銀行').
a1(e_hotel,       'hotel',       'you pay to sleep there',            'ホテル').
a1(e_airport,     'airport',     'where planes arrive and leave',     '空港').
a1(e_museum,      'museum',      'where old or fine things are kept', '博物館').
a1(e_church,      'church',      'a building for Christian prayer',   '教会').
a1(e_market,      'market',      'where things are bought and sold',  '市場').
a1(e_farm,        'farm',        'where food is grown',               '農場').
a1(e_village,     'village',     'a very small town',                 '村').
a1(e_town,        'town',        'smaller than a city',               '町').
a1(e_beach,       'beach',       'the sand beside the sea',           '浜辺').
a1(e_mountain,    'mountain',    'very high ground',                  '山').
a1(e_river,       'river',       'water running to the sea',          '川').
a1(e_sea,         'sea',         'the salt water around the land',    '海').
a1(e_lake,        'lake',        'water with land all round it',      '湖').
a1(e_island,      'island',      'land with water all round it',      '島').
a1(e_forest,      'forest',      'many trees together',               '森').
a1(e_road,        'road',        'cars travel on it',                 '道路').
a1(e_bridge,      'bridge',      'it crosses water',                  '橋').
a1(e_garden,      'garden',      'where flowers are grown',           '庭').
a1(e_kitchen,     'kitchen',     'the room where food is cooked',     '台所').
a1(e_bedroom,     'bedroom',     'the room where you sleep',          '寝室').
a1(e_bathroom,    'bathroom',    'the room where you wash',           '浴室').
a1(e_floor,       'floor',       'what you stand on indoors',         '床').
a1(e_wall,        'wall',        'the side of a room',                '壁').
a1(e_roof,        'roof',        'the top of a building',             '屋根').
a1(e_stairs,      'stairs',      'you climb them inside',             '階段').
a1(e_corner,      'corner',      'where two sides meet',              '角').
a1(e_place,       'place',       'where something is',                '場所').
a1(e_home,        'home',        'where you live',                    '家庭・うち').
a1(e_university,  'university',  'where you study after school',      '大学').
a1(e_college,     'college',     'a school after the age of 18',      '大学・専門学校').
a1(e_class,       'class',       'a lesson, or the students in it',   '授業・クラス').
a1(e_supermarket, 'supermarket', 'a large shop for food',             'スーパー').
a1(e_store,       'store',       'a shop',                            '店舗').
a1(e_factory,     'factory',     'where things are made',             '工場').
a1(e_zoo,         'zoo',         'where wild animals are kept',       '動物園').
a1(e_theater,     'theater',     'where plays are shown',             '劇場').

% --- Things, continued ---------------------------------------------------
a1(e_chair,       'chair',       'you sit on it',                     '椅子').
a1(e_bed,         'bed',         'you sleep on it',                   'ベッド').
a1(e_desk,        'desk',        'a table to work at',                '机').
a1(e_pen,         'pen',         'you write with ink',                'ペン').
a1(e_pencil,      'pencil',      'you write and can rub it out',      '鉛筆').
a1(e_paper,       'paper',       'you write on it',                   '紙').
a1(e_notebook,    'notebook',    'bound paper to write in',           'ノート').
a1(e_computer,    'computer',    'the machine you work on',           'コンピューター').
a1(e_television,  'television',  'you watch programmes on it',        'テレビ').
a1(e_radio,       'radio',       'you listen to it',                  'ラジオ').
a1(e_camera,      'camera',      'you take pictures with it',         'カメラ').
a1(e_box,         'box',         'you keep things in it',             '箱').
a1(e_key,         'key',         'it opens a lock',                   '鍵').
a1(e_map,         'map',         'a drawing of a place',              '地図').
a1(e_newspaper,   'newspaper',   'the daily news on paper',           '新聞').
a1(e_magazine,    'magazine',    'it comes out every week or month',  '雑誌').
a1(e_card,        'card',        'stiff paper, often sent',           'カード').
a1(e_ticket,      'ticket',      'it lets you travel or enter',       '切符').
a1(e_bottle,      'bottle',      'it holds a drink',                  'ボトル・瓶').
a1(e_cup,         'cup',         'you drink from it',                 'カップ').
a1(e_plate,       'plate',       'food is served on it',              '皿').
a1(e_knife,       'knife',       'you cut with it',                   'ナイフ').
a1(e_fork,        'fork',        'you eat with it, with points',      'フォーク').
a1(e_spoon,       'spoon',       'you eat soup with it',              'スプーン').
a1(e_towel,       'towel',       'you dry yourself with it',          'タオル').
a1(e_soap,        'soap',        'you wash with it',                  '石鹸').
a1(e_brush,       'brush',       'for the hair or the teeth',         'ブラシ').
a1(e_mirror,      'mirror',      'you see yourself in it',            '鏡').
a1(e_lamp,        'lamp',        'it gives light',                    'ランプ').
a1(e_bicycle,     'bicycle',     'two wheels, and you pedal',         '自転車').
a1(e_bus,         'bus',         'many people ride it on roads',      'バス').
a1(e_plane,       'plane',       'it flies',                          '飛行機').
a1(e_boat,        'boat',        'a small one, with oars',            'ボート').
a1(e_ship,        'ship',        'a big one, that crosses seas',      '大型船').
a1(e_taxi,        'taxi',        'a car you pay to ride in',          'タクシー').
a1(e_machine,     'machine',     'it does work by itself',            '機械').
a1(e_tool,        'tool',        'you work with your hands on it',    '道具').
a1(e_toy,         'toy',         'a child plays with it',             'おもちゃ').
a1(e_ball,        'ball',        'round, and you throw it',           'ボール').
a1(e_game,        'game',        'something played for fun',          'ゲーム・試合').
a1(e_gift,        'gift',        'something given',                   '贈り物').
a1(e_medicine,    'medicine',    'you take it when ill',              '薬').
a1(e_stamp,       'stamp',       'it pays for a letter',              '切手').
a1(e_wallet,      'wallet',      'you keep money in it',              '財布').

% --- Doing, continued ----------------------------------------------------
a1(e_open,        'open',        'to make a way in',                  '開ける').
a1(e_close,       'close',       'to shut',                           '閉める').
a1(e_start,       'start',       'to begin something',                '始める').
a1(e_stop,        'stop',        'to cease moving or doing',          '止まる・止める').
a1(e_run,         'run',         'to move fast on foot',              '走る').
a1(e_swim,        'swim',        'to move through water',             '泳ぐ').
a1(e_jump,        'jump',        'to push off the ground',            '跳ぶ').
a1(e_sit,         'sit',         'to rest on a seat',                 '座る').
a1(e_stand,       'stand',       'to be on your feet',                '立つ').
a1(e_play,        'play',        'to take part in a game',            '遊ぶ・する').
a1(e_sing,        'sing',        'to make music with the voice',      '歌う').
a1(e_dance,       'dance',       'to move to music',                  '踊る').
a1(e_laugh,       'laugh',       'to make the sound of being amused', '笑う').
a1(e_cry,         'cry',         'to weep',                           '泣く').
a1(e_smile,       'smile',       'to show pleasure with the mouth',   '微笑む').
a1(e_wash,        'wash',        'to clean with water',               '洗う').
a1(e_clean,       'clean',       'to take the dirt off',              '掃除する').
a1(e_cook,        'cook',        'to make food with heat',            '料理する').
a1(e_cut,         'cut',         'to divide it with a knife',         '切る').
a1(e_carry,       'carry',       'to take with you as you go',        '運ぶ').
a1(e_bring,       'bring',       'to come with something',            '持ってくる').
a1(e_send,        'send',        'to make something go to someone',   '送る').
a1(e_call,        'call',        'to telephone, or to name',          '呼ぶ・電話する').
a1(e_ask,         'ask',         'to put a question',                 '尋ねる').
a1(e_tell,        'tell',        'to say to somebody',                '伝える').
a1(e_say,         'say',         'to put into words',                 '言う').
a1(e_show,        'show',        'to let somebody see',               '見せる').
a1(e_use,         'use',         'to put to work',                    '使う').
a1(e_need,        'need',        'to have to have',                   '必要とする').
a1(e_love,        'love',        'to care for very much',             '愛する').
a1(e_feel,        'feel',        'to have a feeling or a touch',      '感じる').
a1(e_hear,        'hear',        'to take in a sound',                '聞こえる').
a1(e_look,        'look',        'to turn the eyes towards',          '目を向ける').
a1(e_watch,       'watch',       'to look at for a while',            '見る・観る').
a1(e_wear,        'wear',        'to have clothes on',                '着る').
a1(e_put,         'put',         'to move it to a place',             '置く').
a1(e_try,         'try',         'to make an attempt',                '試す').
a1(e_begin,       'begin',       'to start',                          '始まる').
a1(e_finish,      'finish',      'to bring to an end',                '終える').
a1(e_forget,      'forget',      'to fail to remember',               '忘れる').
a1(e_choose,      'choose',      'to take one of several',            '選ぶ').
a1(e_decide,      'decide',      'to make up your mind',              '決める').
a1(e_build,       'build',       'to put up a building',              '建てる').
a1(e_break,       'break',       'to make it come apart',             '壊す').
a1(e_lose,        'lose',        'to no longer have',                 '失う・負ける').
a1(e_win,         'win',         'to come first',                     '勝つ').
a1(e_fall,        'fall',        'to go down without meaning to',     '落ちる・転ぶ').
a1(e_fly,         'fly',         'to move through the air',           '飛ぶ').
a1(e_drive,       'drive',       'to make a car go',                  '運転する').
a1(e_ride,        'ride',        'to sit on something that moves',    '乗る').
a1(e_push,        'push',        'to move it away from you',          '押す').
a1(e_pull,        'pull',        'to move it towards you',            '引く').
a1(e_throw,       'throw',       'to send it through the air',        '投げる').
a1(e_catch,       'catch',       'to take hold of something moving',  '捕まえる').
a1(e_hold,        'hold',        'to keep in the hand',               '持つ').
a1(e_touch,       'touch',       'to put a hand on',                  '触る').
a1(e_turn,        'turn',        'to change direction',               '曲がる・回す').
a1(e_move,        'move',        'to change place',                   '動く・移動する').
a1(e_change,      'change',      'to make or become different',       '変える').
a1(e_happen,      'happen',      'to take place',                     '起こる').
a1(e_become,      'become',      'to come to be',                     'なる').
a1(e_stay,        'stay',        'to remain in a place',              '滞在する').
a1(e_leave,       'leave',       'to go away from',                   '去る').
a1(e_return,      'return',      'to come or go back',                '戻る').
a1(e_enter,       'enter',       'to go in',                          '入る').
a1(e_visit,       'visit',       'to go and see',                     '訪ねる').
a1(e_invite,      'invite',      'to ask somebody to come',           '招待する').
a1(e_thank,       'thank',       'to say you are grateful',           '感謝する').
a1(e_borrow,      'borrow',      'to take and give back later',       '借りる').
a1(e_lend,        'lend',        'to give and have back later',       '貸す').
a1(e_pay,         'pay',         'to give money for',                 '払う').
a1(e_sell,        'sell',        'to give for money',                 '売る').
a1(e_cost,        'cost',        'to be priced at',                   '費用がかかる').
a1(e_count,       'count',       'to say the numbers of them',        '数える').
a1(e_draw,        'draw',        'to make a picture with lines',      '描く').
a1(e_paint,       'paint',       'to put colour on',                  '塗る').
a1(e_teach,       'teach',       'to help somebody learn',            '教える').
a1(e_study,       'study',       'to work at learning',               '勉強する').
a1(e_practice,    'practice',    'to do it again to get better',      '練習する').
a1(e_repeat,      'repeat',      'to say or do again',                '繰り返す').
a1(e_explain,     'explain',     'to make clear',                     '説明する').
a1(e_spell,       'spell',       'to say the letters in order',       '綴る').
a1(e_worry,       'worry',       'to be anxious',                     '心配する').
a1(e_hope,        'hope',        'to want and expect',                '望む').
a1(e_wish,        'wish',        'to want what may not be',           '願う').
a1(e_dream,       'dream',       'to see things while asleep',        '夢を見る').
a1(e_rest,        'rest',        'to stop and recover',               '休む').
a1(e_hurry,       'hurry',       'to go quickly',                     '急ぐ').
a1(e_wake,        'wake',        'to stop sleeping',                  '起きる').
a1(e_smell,       'smell',       'to take in through the nose',       '匂いを嗅ぐ').
a1(e_taste,       'taste',       'to take in with the tongue',        '味わう').

% --- Describing, continued -----------------------------------------------
a1(e_old,         'old',         'having lived a long time',          '古い・年を取った').
a1(e_young,       'young',       'not having lived long',             '若い').
a1(e_tall,        'tall',        'of great height',                   '背が高い').
a1(e_short,       'short',       'not long, or not tall',             '短い・背が低い').
a1(e_heavy,       'heavy',       'weighing a lot',                    '重い').
a1(e_fast,        'fast',        'moving quickly',                    '速い').
a1(e_slow,        'slow',        'not fast',                          '遅い').
a1(e_hot,         'hot',         'of a high temperature',             '熱い・暑い').
a1(e_cold,        'cold',        'of a low temperature',              '寒い・冷たい').
a1(e_warm,        'warm',        'pleasantly hot',                    '暖かい').
a1(e_cool,        'cool',        'pleasantly cold',                   '涼しい').
a1(e_dirty,       'dirty',       'not clean',                         '汚い').
a1(e_happy,       'happy',       'feeling pleased',                   '幸せな').
a1(e_sad,         'sad',         'feeling unhappy',                   '悲しい').
a1(e_angry,       'angry',       'feeling strong displeasure',        '怒った').
a1(e_tired,       'tired',       'needing rest',                      '疲れた').
a1(e_hungry,      'hungry',      'needing food',                      'お腹が空いた').
a1(e_thirsty,     'thirsty',     'needing a drink',                   '喉が渇いた').
a1(e_sick,        'sick',        'not well',                          '病気の').
a1(e_quiet,       'quiet',       'making little sound',               '静かな').
a1(e_loud,        'loud',        'making much sound',                 'うるさい').
a1(e_easy,        'easy',        'not hard to do',                    '簡単な').
a1(e_cheap,       'cheap',       'costing little',                    '安い').
a1(e_rich,        'rich',        'having much money',                 '裕福な').
a1(e_poor,        'poor',        'having little money',               '貧しい').
a1(e_nice,        'nice',        'pleasant',                          '素敵な').
a1(e_bad,         'bad',         'of a low standard',                 '悪い').
a1(e_wrong,       'wrong',       'not correct',                       '間違った').
a1(e_full,        'full',        'holding as much as it can',         'いっぱいの').
a1(e_empty,       'empty',       'holding nothing',                   '空の').
a1(e_high,        'high',        'far above the ground',              '（位置が）高い').
a1(e_low,         'low',         'near the ground',                   '低い').
a1(e_deep,        'deep',        'going far down',                    '深い').
a1(e_wide,        'wide',        'far from side to side',             '広い').
a1(e_narrow,      'narrow',      'not wide',                          '狭い').
a1(e_thick,       'thick',       'far through',                       '厚い').
a1(e_thin,        'thin',        'not thick, or not fat',             '薄い・細い').
a1(e_soft,        'soft',        'it gives when pressed',             '柔らかい').
a1(e_wet,         'wet',         'covered in liquid',                 '濡れた').
a1(e_dry,         'dry',         'not wet',                           '乾いた').
a1(e_sweet,       'sweet',       'tasting of sugar',                  '甘い').
a1(e_delicious,   'delicious',   'tasting very good',                 'おいしい').
a1(e_famous,      'famous',      'known to many',                     '有名な').
a1(e_important,   'important',   'mattering a great deal',            '重要な').
a1(e_interesting, 'interesting', 'holding the attention',             '面白い').
a1(e_dangerous,   'dangerous',   'likely to cause harm',              '危険な').
a1(e_safe,        'safe',        'not in danger',                     '安全な').
a1(e_different,   'different',   'not the same',                      '違う').
a1(e_same,        'same',        'not different',                     '同じ').
a1(e_ready,       'ready',       'prepared',                          '準備ができた').
a1(e_true,        'true',        'agreeing with the facts',           '本当の').
a1(e_strange,     'strange',     'unusual',                           '奇妙な').
a1(e_lucky,       'lucky',       'having good fortune',               '幸運な').
a1(e_lonely,      'lonely',      'unhappy at being alone',            '寂しい').
a1(e_afraid,      'afraid',      'feeling fear',                      '怖い').
a1(e_careful,     'careful',     'taking care',                       '注意深い').
a1(e_polite,      'polite',      'showing good manners',              '礼儀正しい').
a1(e_honest,      'honest',      'telling the truth',                 '正直な').
a1(e_friendly,    'friendly',    'kind and open to others',           '友好的な').
a1(e_funny,       'funny',       'making you laugh',                  'おかしい').
a1(e_serious,     'serious',     'not joking, or grave',              '真剣な').
a1(e_simple,      'simple',      'not complicated',                   '単純な').
a1(e_special,     'special',     'not ordinary',                      '特別な').
a1(e_favorite,    'favorite',    'liked best of all',                 'お気に入りの').
a1(e_wonderful,   'wonderful',   'very good indeed',                  '素晴らしい').
a1(e_terrible,    'terrible',    'very bad indeed',                   'ひどい').

% --- How, and how often --------------------------------------------------
a1(e_always,      'always',      'every time',                        'いつも').
a1(e_never,       'never',       'at no time',                        '決して〜ない').
a1(e_sometimes,   'sometimes',   'at some times',                     '時々').
a1(e_often,       'often',       'many times',                        'よく').
a1(e_usually,     'usually',     'most of the time',                  '普通は').
a1(e_again,       'again',       'one more time',                     'もう一度').
a1(e_soon,        'soon',        'in a short time',                   'すぐに').
a1(e_together,    'together',    'with each other',                   '一緒に').
a1(e_slowly,      'slowly',      'at a low speed',                    'ゆっくり').
a1(e_quickly,     'quickly',     'at a high speed',                   '速く').
a1(e_almost,      'almost',      'very nearly',                       'ほとんど').
a1(e_finally,     'finally',     'after a long wait',                 'ついに').

% --- Asking ---------------------------------------------------------------
% Six of the seven.  `what` is in the function-word queue
% (docs/langpop-function-words.md, Group C) and is left there, which is
% why the set below has a hole in it: these six are plain translations
% and `what` sits in a group whose other rows need a decision.
a1(e_who,         'who',         'asking which person',               '誰').
a1(e_where,       'where',       'asking which place',                'どこ').
a1(e_when,        'when',        'asking which time',                 'いつ').
a1(e_why,         'why',         'asking the reason',                 'なぜ').
a1(e_how,         'how',         'asking in what way',                'どう・どうやって').
a1(e_which,       'which',       'asking which of them',              'どちら').
