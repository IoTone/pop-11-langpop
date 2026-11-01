% graph/en/a2.pl -- A2 English, for a Japanese speaker.
%
% Committed and hand-written, for the reason graph/en/a1.pl gives at
% length: a bilingual dictionary read backwards does not produce a
% translation, so the Japanese gloss on every row below was typed. No
% licence reaches this file, and nothing upstream has an opinion about
% which English words are A2.
%
% A2 is TOEIC 225-550 (graph/en/ladder.pl). The count it has to meet is
% exit(en, a2, vocabulary(1000, read), ...), and that count is
% CUMULATIVE -- a2 is measured over everything at or below it, so the 519
% words of a1.pl are already in the denominator and this file holds the
% rest. 550 rows, which takes the total past the thousand with a margin
% for whatever a later reading of a row removes.
%
% WHAT CHOSE THESE WORDS. A1 is concrete: family, food, animals, colors,
% the body, the house. What A2 adds is the vocabulary of doing something
% with other people -- work, travel, money, health, school, the law -- and
% the verbs and adjectives that describe change rather than things. 185
% of the 550 rows are verbs and the last section is 70 adjectives and
% adverbs, which is the shape of the difference: a learner who knows only
% A1 can name what is in the room and cannot say what happened to it.
%
% AND ATTESTED, WHICH IS NOT THE SAME AS SELECTED. Curation chooses the
% words; hermitdave/FrequencyWords confirms they are current English.
% 550 of 550 appear in en_50k.txt and together they are 2.96% of that
% corpus. The corpus never chose a word here -- see DESIGN_NOTES.md for
% what happened when the same check was tried in Japanese, where the list
% is missing the most frequent words in the language and can attest
% nothing at all.
%
% TWO WORDS WERE ALREADY TAUGHT, AND TAUGHT BETTER. 'service' and
% 'excited' were written here and removed: graph/en/items.pl holds both
% as KATAKANA TRAPS, t_service and t_tension, and a trap is the stronger
% lesson. The gloss written here for 'service' was サービス -- which is
% precisely the misunderstanding the trap exists to correct, since a
% Japanese サービス is something given free. A plain vocabulary row would
% have taught the error the rung below is there to undo. So: before
% adding a word, check it is not a trap or a written confusion already.
%
% THREE THINGS THE CHECKS CAUGHT, all worth knowing before adding a row.
% A word may not share a JAPANESE gloss with any other item: 'require'
% was written 必要とする, which is already A1's 'need', and two items a
% learner is given no way to tell apart is the one error this content
% cannot recover from (tests/test_langpop.p checks it). And the house
% spelling is American -- a1.pl has color, favorite and theater, and a
% TOEIC candidate meets American English -- so organisation, realise,
% neighbour, licence and nine others were written the wrong way round
% here first.
%
% WHAT IS NOT HERE. No grammar: the articles, the auxiliaries, the
% prepositions as a system and the irregular past are patterns and
% function words, not vocabulary, and docs/langpop-function-words.md is
% where that argument is held open. No phrasal verbs, which are the
% obvious next tranche and want their own decision about identity -- is
% 'put off' an item, or a pattern over 'put'?

item(Id, word, en, a2, own(a2_list)) :- a2(Id, _, _, _).
form(Id, latin, Word) :- a2(Id, Word, _, _).
gloss(Id, en, En) :- a2(Id, _, En, _).
gloss(Id, ja, Ja) :- a2(Id, _, _, Ja).

% a2(Id, Word, GlossEn, GlossJa).

% --- Work and the office -----------------------------------------------
a2(e_company,      'company',      'a business organization',             '会社').
a2(e_meeting,      'meeting',      'people gathering to discuss',         '会議').
a2(e_manager,      'manager',      'someone who runs a team',             '管理者').
a2(e_employee,     'employee',     'someone who works for a company',     '従業員').
a2(e_salary,       'salary',       'money paid for a job',                '給料').
a2(e_contract,     'contract',     'a written agreement',                 '契約').
a2(e_report,       'report',       'a written account of work',           '報告書').
a2(e_schedule,     'schedule',     'a plan of times',                     '予定表').
a2(e_project,      'project',      'a piece of planned work',             '企画').
a2(e_client,       'client',       'someone who buys a service',          '顧客').
a2(e_department,   'department',   'one part of an organization',         '部門').
a2(e_interview,    'interview',    'a formal meeting about a job',        '面接').
a2(e_apply,        'apply',        'to ask formally for a job',           '応募する').
a2(e_hire,         'hire',         'to take someone on to work',          '雇う').
a2(e_resign,       'resign',       'to give up a job',                    '辞職する').
a2(e_promote,      'promote',      'to raise to a higher post',           '昇進させる').
a2(e_colleague,    'colleague',    'someone you work with',               '同僚').
a2(e_staff,        'staff',        'the people employed somewhere',       '職員').
a2(e_business,     'business',     'buying and selling',                  '商売').
a2(e_industry,     'industry',     'making things in quantity',           '産業').
a2(e_product,      'product',      'a thing made to sell',                '製品').
a2(e_assistance,   'assistance',   'help given to a user',                '支援').
a2(e_task,         'task',         'a piece of work to do',               '作業').
a2(e_deadline,     'deadline',     'the latest time allowed',             '締め切り').
a2(e_overtime,     'overtime',     'hours worked beyond normal',          '残業').
a2(e_raise,        'raise',        'an increase in pay',                  '昇給').
a2(e_profit,       'profit',       'money gained in trade',               '利益').
a2(e_loss,         'loss',         'money lost in trade',                 '損失').
a2(e_budget,       'budget',       'a plan for spending',                 '予算').
a2(e_invoice,      'invoice',      'a bill for goods',                    '請求書').
a2(e_signature,    'signature',    'your name written by you',            '署名').
a2(e_document,     'document',     'a formal paper',                      '文書').
a2(e_file,         'file',         'papers kept together',                '書類入れ').
a2(e_copy,         'copy',         'a second one made the same',          '複製').
a2(e_print,        'print',        'to put words on paper',               '印刷する').
a2(e_deliver,      'deliver',      'to take goods to someone',            '配達する').
a2(e_production,   'production',   'the making of goods',                 '生産').
a2(e_quality,      'quality',      'how good a thing is',                 '品質').
a2(e_quantity,     'quantity',     'how much there is',                   '数量').
a2(e_purchase,     'purchase',     'to buy, formally',                    '購入する').
a2(e_supply,       'supply',       'to provide what is needed',           '供給する').
a2(e_demand,       'demand',       'how much buyers want',                '需要').
a2(e_competition,  'competition',  'trying to do better than others',     '競争').
a2(e_advertise,    'advertise',    'to tell the public about goods',      '宣伝する').
a2(e_brand,        'brand',        'a maker\'s name on goods',            '銘柄').
a2(e_branch,       'branch',       'one office of a company',             '支店').
a2(e_headquarters, 'headquarters', 'the main office',                     '本社').
a2(e_conference,   'conference',   'a large formal meeting',              '会合').
a2(e_presentation, 'presentation', 'a talk given to others',              '発表').
a2(e_appointment,  'appointment',  'an arranged time to meet',            '約束の時間').
a2(e_secretary,    'secretary',    'someone who handles office work',     '秘書').
a2(e_union,        'union',        'an organization of workers',          '組合').
a2(e_career,       'career',       'a working life',                      '経歴').
a2(e_retire,       'retire',       'to stop working for good',            '退職する').

% --- Travel and getting there ------------------------------------------
a2(e_flight,       'flight',       'a journey by plane',                  '空の便').
a2(e_passport,     'passport',     'a document for travel abroad',        '旅券').
a2(e_luggage,      'luggage',      'the bags you travel with',            '荷物').
a2(e_reservation,  'reservation',  'a place kept for you',                '予約').
a2(e_delay,        'delay',        'being later than planned',            '遅れ').
a2(e_arrival,      'arrival',      'coming in',                           '到着').
a2(e_departure,    'departure',    'going out',                           '出発').
a2(e_journey,      'journey',      'the going from one place to another', '旅').
a2(e_trip,         'trip',         'a short journey and back',            '旅行').
a2(e_tour,         'tour',         'a journey round several places',      '周遊').
a2(e_abroad,       'abroad',       'in another country',                  '海外').
a2(e_border,       'border',       'the line between two countries',      '国境').
a2(e_customs,      'customs',      'the check on goods at a border',      '税関').
a2(e_gate,         'gate',         'a way in or out',                     '門').
a2(e_platform,     'platform',     'where you board a train',             '乗降場').
a2(e_route,        'route',        'the way taken',                       '経路').
a2(e_distance,     'distance',     'how far it is',                       '距離').
a2(e_direction,    'direction',    'the way something faces',             '方向').
a2(e_speed,        'speed',        'how fast something goes',             '速度').
a2(e_traffic,      'traffic',      'vehicles on the road',                '交通').
a2(e_accident,     'accident',     'something bad happening by chance',   '事故').
a2(e_license,      'license',      'official permission to do something', '免許').
a2(e_fuel,         'fuel',         'what an engine burns',                '燃料').
a2(e_engine,       'engine',       'the part that makes a machine go',    '発動機').
a2(e_wheel,        'wheel',        'a round part that turns',             '車輪').
a2(e_seat,         'seat',         'a place to sit',                      '座席').
a2(e_belt,         'belt',         'a strap worn round you',              '帯').
a2(e_cross,        'cross',        'to go from one side to the other',    '渡る').
a2(e_arrive,       'arrive',       'to reach a place',                    '着く').
a2(e_depart,       'depart',       'to set off',                          '出立する').
a2(e_board,        'board',        'to get on a plane or ship',           '搭乗する').
a2(e_land,         'land',         'to come down to the ground',          '着陸する').
a2(e_sail,         'sail',         'to travel by water',                  '航海する').
a2(e_ferry,        'ferry',        'a boat that crosses regularly',       '渡し船').
a2(e_harbor,       'harbor',       'where ships are kept safe',           '港').
a2(e_airline,      'airline',      'a company that flies planes',         '航空会社').
a2(e_tourist,      'tourist',      'someone travelling for pleasure',     '観光客').
a2(e_guide,        'guide',        'someone who shows the way',           '案内人').
a2(e_signpost,     'signpost',     'a sign showing the way',              '道標').
a2(e_suitcase,     'suitcase',     'a case for clothes',                  '旅行かばん').
a2(e_hostel,       'hostel',       'cheap lodging for travellers',        '簡易宿泊所').
a2(e_fare,         'fare',         'the price of a ride',                 '運賃').
a2(e_timetable,    'timetable',    'a list of departure times',           '時刻表').
a2(e_crowd,        'crowd',        'many people together',                '群衆').
a2(e_queue,        'queue',        'a line of people waiting',            '行列').

% --- Health and the body -----------------------------------------------
a2(e_headache,     'headache',     'a pain in the head',                  '頭痛').
a2(e_fever,        'fever',        'a body too hot from illness',         '熱').
a2(e_cough,        'cough',        'to push air out noisily',             '咳をする').
a2(e_pain,         'pain',         'the feeling of being hurt',           '痛み').
a2(e_injury,       'injury',       'harm done to the body',               'けが').
a2(e_treatment,    'treatment',    'what is done to cure',                '治療').
a2(e_pill,         'pill',         'medicine in a small round form',      '錠剤').
a2(e_pharmacy,     'pharmacy',     'a shop that sells medicine',          '薬局').
a2(e_dentist,      'dentist',      'a doctor for teeth',                  '歯医者').
a2(e_exercise,     'exercise',     'moving the body to stay well',        '運動').
a2(e_diet,         'diet',         'what a person eats',                  '食事内容').
a2(e_healthy,      'healthy',      'in good health',                      '健康な').
a2(e_illness,      'illness',      'being unwell',                        '病気').
a2(e_patient,      'patient',      'someone being treated',               '患者').
a2(e_operation,    'operation',    'cutting to cure',                     '手術').
a2(e_examination,  'examination',  'a careful looking at',                '検査').
a2(e_breathe,      'breathe',      'to take air in and out',              '呼吸する').
a2(e_swallow,      'swallow',      'to take down the throat',             '飲み込む').
a2(e_recover,      'recover',      'to get well again',                   '回復する').
a2(e_cure,         'cure',         'to make well',                        '治す').
a2(e_wound,        'wound',        'a cut in the flesh',                  '傷').
a2(e_bandage,      'bandage',      'cloth wrapped round a wound',         '包帯').
a2(e_ambulance,    'ambulance',    'a vehicle for the sick',              '救急車').
a2(e_clinic,       'clinic',       'a small place for treatment',         '診療所').
a2(e_care,         'care',         'looking after someone',               '世話').
a2(e_muscle,       'muscle',       'flesh that moves a limb',             '筋肉').
a2(e_fracture,     'fracture',     'a broken bone',                       '骨折').
a2(e_toothache,    'toothache',    'a pain in a tooth',                   '歯痛').
a2(e_stomachache,  'stomachache',  'a pain in the belly',                 '腹痛').
a2(e_sneeze,       'sneeze',       'to blow air out of the nose',         'くしゃみをする').
a2(e_sleepy,       'sleepy',       'wanting to sleep',                    '眠い').
a2(e_weight,       'weight',       'how heavy someone is',                '体重').
a2(e_height,       'height',       'how tall someone is',                 '身長').
a2(e_pulse,        'pulse',        'the beat of the heart felt',          '脈').
a2(e_allergy,      'allergy',      'a bad reaction to something',         'アレルギー').
a2(e_infection,    'infection',    'illness passed on',                   '感染').
a2(e_vaccine,      'vaccine',      'a medicine that prevents illness',    'ワクチン').
a2(e_hygiene,      'hygiene',      'keeping clean to stay well',          '衛生').
a2(e_poison,       'poison',       'something that harms if taken in',    '毒').
a2(e_smoke,        'smoke',        'to breathe in tobacco',               '喫煙する').

% --- Money and shopping ------------------------------------------------
a2(e_price,        'price',        'what a thing costs',                  '値段').
a2(e_discount,     'discount',     'money taken off a price',             '割引').
a2(e_receipt,      'receipt',      'a paper showing you paid',            '領収書').
a2(e_refund,       'refund',       'money given back',                    '払い戻し').
a2(e_cash,         'cash',         'notes and coins',                     '現金').
a2(e_credit,       'credit',       'buying now and paying later',         '信用取引').
a2(e_coin,         'coin',         'money made of metal',                 '硬貨').
a2(e_save,         'save',         'to keep money for later',             '貯める').
a2(e_spend,        'spend',        'to pay money out',                    '費やす').
a2(e_afford,       'afford',       'to have enough money for',            '余裕がある').
a2(e_loan,         'loan',         'money lent for a time',               '融資').
a2(e_debt,         'debt',         'money owed',                          '借金').
a2(e_interest,     'interest',     'money paid for a loan',               '利子').
a2(e_tax,          'tax',          'money paid to the state',             '税金').
a2(e_account,      'account',      'a record of money at a bank',         '口座').
a2(e_exchange,     'exchange',     'to give one thing for another',       '交換する').
a2(e_rate,         'rate',         'a price set per unit',                '相場').
a2(e_value,        'value',        'what a thing is worth',               '価値').
a2(e_bargain,      'bargain',      'a thing bought cheaply',              '買い得').
a2(e_sale,         'sale',         'selling at lower prices',             '特売').
a2(e_total,        'total',        'the whole amount',                    '合計').
a2(e_amount,       'amount',       'how much of something',               '額').
a2(e_expense,      'expense',      'money that must be paid out',         '経費').
a2(e_wealth,       'wealth',       'having a great deal',                 '富').
a2(e_poverty,      'poverty',      'having very little',                  '貧困').
a2(e_insurance,    'insurance',    'paying against future loss',          '保険').
a2(e_invest,       'invest',       'to put money to work',                '投資する').
a2(e_wage,         'wage',         'money paid by the hour',              '賃金').
a2(e_cashier,      'cashier',      'someone who takes payment',           '会計係').
a2(e_basket,       'basket',       'a container to carry goods',          'かご').
a2(e_shelf,        'shelf',        'a board for putting things on',       '棚').
a2(e_label,        'label',        'a small paper naming a thing',        '札').
a2(e_package,      'package',      'a thing wrapped for sending',         '小包').
a2(e_wrap,         'wrap',         'to cover in paper',                   '包む').
a2(e_weigh,        'weigh',        'to find how heavy',                   '量る').
a2(e_select,       'select',       'to pick out',                         '選択する').
a2(e_complain,     'complain',     'to say you are not satisfied',        '苦情を言う').
a2(e_guarantee,    'guarantee',    'a promise that goods are good',       '保証').

% --- School and study --------------------------------------------------
a2(e_lesson,       'lesson',       'one period of teaching',              '授業').
a2(e_exam,         'exam',         'a formal test',                       '試験').
a2(e_homework,     'homework',     'work set to do at home',              '宿題').
a2(e_subject,      'subject',      'a thing studied',                     '科目').
a2(e_degree,       'degree',       'a qualification from a university',   '学位').
a2(e_course,       'course',       'a series of lessons',                 '課程').
a2(e_grade,        'grade',        'a mark for work',                     '成績').
a2(e_research,     'research',     'careful study to find out',           '研究').
a2(e_essay,        'essay',        'a piece of writing on a subject',     '小論文').
a2(e_notes,        'notes',        'what you write while listening',      '覚書').
a2(e_textbook,     'textbook',     'a book used for study',               '教科書').
a2(e_dictionary,   'dictionary',   'a book of word meanings',             '辞書').
a2(e_translate,    'translate',    'to put into another language',        '翻訳する').
a2(e_pronounce,    'pronounce',    'to say a word\'s sounds',             '発音する').
a2(e_grammar,      'grammar',      'the rules of a language',             '文法').
a2(e_sentence,     'sentence',     'a complete group of words',           '文').
a2(e_meaning,      'meaning',      'what something says',                 '意味').
a2(e_example,      'example',      'one case that shows the rest',        '例').
a2(e_mistake,      'mistake',      'something done wrong',                '間違い').
a2(e_correct,      'correct',      'right, with no error',                '正しい').
a2(e_review,       'review',       'to study again before a test',        '復習する').
a2(e_memorize,     'memorize',     'to learn by heart',                   '暗記する').
a2(e_attend,       'attend',       'to be present at',                    '出席する').
a2(e_absent,       'absent',       'not present',                         '欠席の').
a2(e_graduate,     'graduate',     'to finish a course of study',         '卒業する').
a2(e_scholarship,  'scholarship',  'money given to a student',            '奨学金').
a2(e_knowledge,    'knowledge',    'what a person knows',                 '知識').
a2(e_skill,        'skill',        'something you can do well',           '技能').
a2(e_ability,      'ability',      'the power to do something',           '能力').
a2(e_effort,       'effort',       'hard trying',                         '努力').
a2(e_progress,     'progress',     'moving forward',                      '進歩').
a2(e_result,       'result',       'what comes out of something',         '結果').
a2(e_certificate,  'certificate',  'a paper proving something',           '証明書').
a2(e_level,        'level',        'how high or advanced',                '水準').

% --- The home and the neighborhood ------------------------------------
a2(e_furniture,    'furniture',    'tables, chairs and the like',         '家具').
a2(e_curtain,      'curtain',      'cloth hung at a window',              'カーテン').
a2(e_carpet,       'carpet',       'thick cloth on a floor',              'じゅうたん').
a2(e_ceiling,      'ceiling',      'the top inside a room',               '天井').
a2(e_basement,     'basement',     'a room below the ground',             '地下室').
a2(e_garage,       'garage',       'where a car is kept',                 '車庫').
a2(e_yard,         'yard',         'open ground by a house',              '庭先').
a2(e_rent,         'rent',         'money paid to use a home',            '家賃').
a2(e_neighbor,     'neighbor',     'someone living next to you',          '隣人').
a2(e_apartment,    'apartment',    'a home inside a larger building',     '共同住宅').
a2(e_landlord,     'landlord',     'the owner who rents it out',          '大家').
a2(e_tenant,       'tenant',       'someone who rents a home',            '借家人').
a2(e_leak,         'leak',         'water coming through',                '漏れ').
a2(e_electricity,  'electricity',  'the power in the wires',              '電気').
a2(e_gas,          'gas',          'fuel that burns in a pipe',           'ガス').
a2(e_heating,      'heating',      'keeping a room warm',                 '暖房').
a2(e_cooling,      'cooling',      'keeping a room cool',                 '冷房').
a2(e_lock,         'lock',         'a fastening opened by a key',         '錠').
a2(e_switch,       'switch',       'what turns power on and off',         'スイッチ').
a2(e_faucet,       'faucet',       'what water comes out of',             '蛇口').
a2(e_drawer,       'drawer',       'a box that slides in a desk',         '引き出し').
a2(e_cupboard,     'cupboard',     'a closed shelf for storing',          '戸棚').
a2(e_blanket,      'blanket',      'a thick cover for a bed',             '毛布').
a2(e_pillow,       'pillow',       'what the head rests on',              '枕').
a2(e_sheet,        'sheet',        'a thin cloth on a bed',               '敷布').
a2(e_vacuum,       'vacuum',       'to clean with suction',               '掃除機をかける').
a2(e_garbage,      'garbage',      'what is thrown away',                 'ごみ').
a2(e_repair,       'repair',       'to make a broken thing work',         '修理する').
a2(e_builder,      'builder',      'someone who makes houses',            '建築業者').
a2(e_address,      'address',      'where a building is',                 '住所').
a2(e_district,     'district',     'one part of a town',                  '地区').
a2(e_suburb,       'suburb',       'housing outside the centre',          '郊外').
a2(e_fence,        'fence',        'a barrier round ground',              '柵').
a2(e_doorbell,     'doorbell',     'what a visitor presses',              '呼び鈴').

% --- Society, law and government ---------------------------------------
a2(e_government,   'government',   'those who run a country',             '政府').
a2(e_law,          'law',          'a rule the state enforces',           '法律').
a2(e_politics,     'politics',     'the running of a country',            '政治').
a2(e_culture,      'culture',      'a people\'s way of living',           '文化').
a2(e_history,      'history',      'what happened before',                '歴史').
a2(e_religion,     'religion',     'belief in something higher',          '宗教').
a2(e_society,      'society',      'people living together',              '社会').
a2(e_community,    'community',    'the people of one place',             '地域社会').
a2(e_population,   'population',   'how many people live somewhere',      '人口').
a2(e_citizen,      'citizen',      'a member of a country',               '市民').
a2(e_election,     'election',     'choosing by voting',                  '選挙').
a2(e_vote,         'vote',         'to choose in an election',            '投票する').
a2(e_court,        'court',        'where law is decided',                '裁判所').
a2(e_judge,        'judge',        'who decides in a court',              '裁判官').
a2(e_lawyer,       'lawyer',       'someone trained in law',              '弁護士').
a2(e_crime,        'crime',        'an act against the law',              '犯罪').
a2(e_police,       'police',       'those who enforce the law',           '警察').
a2(e_prison,       'prison',       'where the guilty are kept',           '刑務所').
a2(e_punish,       'punish',       'to make someone suffer for wrong',    '罰する').
a2(e_rule,         'rule',         'a statement of what is allowed',      '規則').
a2(e_right,        'right',        'what a person may justly claim',      '権利').
a2(e_duty,         'duty',         'what a person must do',               '義務').
a2(e_freedom,      'freedom',      'being able to choose',                '自由').
a2(e_peace,        'peace',        'the absence of war',                  '平和').
a2(e_war,          'war',          'fighting between countries',          '戦争').
a2(e_army,         'army',         'a country\'s soldiers',               '軍隊').
a2(e_soldier,      'soldier',      'a member of an army',                 '兵士').
a2(e_leader,       'leader',       'someone others follow',               '指導者').
a2(e_organization, 'organization', 'a group with a purpose',              '組織').
a2(e_member,       'member',       'one of a group',                      '会員').
a2(e_public,       'public',       'the people in general',               '公衆').
a2(e_private,      'private',      'belonging to one person',             '私的な').
a2(e_official,     'official',     'done by those in charge',             '公式の').
a2(e_permit,       'permit',       'to allow formally',                   '許可する').
a2(e_forbid,       'forbid',       'to say it must not be done',          '禁じる').
a2(e_register,     'register',     'to put on an official list',          '登録する').
a2(e_tradition,    'tradition',    'what has long been done',             '伝統').
a2(e_custom,       'custom',       'what people usually do',              '慣習').
a2(e_charity,      'charity',      'giving to those in need',             '慈善').
a2(e_volunteer,    'volunteer',    'someone who helps unpaid',            '志願者').

% --- Feelings and character --------------------------------------------
a2(e_nervous,      'nervous',      'worried about what is coming',        '不安な').
a2(e_confident,    'confident',    'sure of yourself',                    '自信のある').
a2(e_proud,        'proud',        'pleased with what you did',           '誇らしい').
a2(e_jealous,      'jealous',      'unhappy at another\'s good',          '嫉妬した').
a2(e_generous,     'generous',     'willing to give',                     '気前のよい').
a2(e_shy,          'shy',          'uneasy with people',                  '内気な').
a2(e_calm,         'calm',         'not excited',                         '落ち着いた').
a2(e_brave,        'brave',        'able to face danger',                 '勇敢な').
a2(e_selfish,      'selfish',      'thinking only of yourself',           '利己的な').
a2(e_tolerant,     'tolerant',     'willing to put up with',              '寛容な').
a2(e_cheerful,     'cheerful',     'bright in spirits',                   '快活な').
a2(e_solemn,       'solemn',       'grave in manner',                     '厳粛な').
a2(e_gentle,       'gentle',       'soft in manner',                      '穏やかな').
a2(e_rude,         'rude',         'not polite',                          '無礼な').
a2(e_clever,       'clever',       'quick to understand',                 '賢い').
a2(e_stupid,       'stupid',       'slow to understand',                  '愚かな').
a2(e_lazy,         'lazy',         'unwilling to work',                   '怠惰な').
a2(e_diligent,     'diligent',     'working with care',                   '勤勉な').
a2(e_curious,      'curious',      'wanting to know',                     '好奇心の強い').
a2(e_careless,     'careless',     'not taking care',                     '軽率な').
a2(e_anxious,      'anxious',      'troubled in mind',                    '心配な').
a2(e_relieved,     'relieved',     'free of worry at last',               '安心した').
a2(e_disappointed, 'disappointed', 'let down by what happened',           '失望した').
a2(e_embarrassed,  'embarrassed',  'made uncomfortable before others',    '恥ずかしい').
a2(e_bored,        'bored',        'tired of having nothing to do',       '退屈した').
a2(e_surprised,    'surprised',    'struck by the unexpected',            '驚いた').
a2(e_satisfied,    'satisfied',    'content with what you got',           '満足した').
a2(e_grateful,     'grateful',     'feeling thanks',                      '感謝している').
a2(e_guilty,       'guilty',       'feeling you did wrong',               '罪の意識がある').
a2(e_hopeful,      'hopeful',      'expecting good',                      '希望に満ちた').
a2(e_mood,         'mood',         'how a person feels now',              '機嫌').
a2(e_feeling,      'feeling',      'what is felt inside',                 '感情').
a2(e_character,    'character',    'what a person is like',               '性格').
a2(e_attitude,     'attitude',     'how a person takes things',           '態度').
a2(e_behavior,     'behavior',     'how a person acts',                   '行動').
a2(e_habit,        'habit',        'something done without thinking',     '習慣').
a2(e_opinion,      'opinion',      'what a person thinks',                '意見').
a2(e_belief,       'belief',       'what a person holds true',            '信念').
a2(e_doubt,        'doubt',        'not being sure',                      '疑い').
a2(e_fear,         'fear',         'the feeling of danger',               '恐れ').
a2(e_anger,        'anger',        'the feeling of being wronged',        '怒り').
a2(e_joy,          'joy',          'great gladness',                      '喜び').
a2(e_sorrow,       'sorrow',       'deep sadness',                        '悲しみ').
a2(e_pity,         'pity',         'sorrow for another',                  '哀れみ').

% --- Talking and agreeing ----------------------------------------------
a2(e_message,      'message',      'words sent to someone',               '伝言').
a2(e_email,        'email',        'a letter sent by computer',           '電子メール').
a2(e_conversation, 'conversation', 'talking between people',              '会話').
a2(e_discuss,      'discuss',      'to talk a thing over',                '話し合う').
a2(e_suggest,      'suggest',      'to put forward an idea',              '提案する').
a2(e_advise,       'advise',       'to say what should be done',          '助言する').
a2(e_agree,        'agree',        'to think the same',                   '同意する').
a2(e_disagree,     'disagree',     'to think otherwise',                  '反対する').
a2(e_argue,        'argue',        'to disagree in words',                '言い争う').
a2(e_apologize,    'apologize',    'to say you are sorry',                '謝る').
a2(e_promise,      'promise',      'to say you will surely do',           '約束する').
a2(e_refuse,       'refuse',       'to say you will not',                 '断る').
a2(e_accept,       'accept',       'to take what is offered',             '受け入れる').
a2(e_admit,        'admit',        'to say a thing is true',              '認める').
a2(e_deny,         'deny',         'to say a thing is not so',            '否定する').
a2(e_mention,      'mention',      'to say in passing',                   '言及する').
a2(e_describe,     'describe',     'to say what a thing is like',         '描写する').
a2(e_announce,     'announce',     'to make publicly known',              '発表する').
a2(e_warn,         'warn',         'to tell of danger coming',            '警告する').
a2(e_remind,       'remind',       'to make someone remember',            '思い出させる').
a2(e_protest,      'protest',      'to speak against',                    '抗議する').
a2(e_praise,       'praise',       'to say good of someone',              'ほめる').
a2(e_blame,        'blame',        'to say it is someone\'s fault',       '非難する').
a2(e_greet,        'greet',        'to say hello to',                     '挨拶する').
a2(e_introduce,    'introduce',    'to make two people known',            '紹介する').
a2(e_whisper,      'whisper',      'to speak very quietly',               'ささやく').
a2(e_shout,        'shout',        'to speak very loudly',                '叫ぶ').
a2(e_reply,        'reply',        'to answer',                           '返答する').
a2(e_request,      'request',      'to ask for politely',                 '依頼する').
a2(e_command,      'command',      'to tell with authority',              '命令する').
a2(e_inform,       'inform',       'to tell what is known',               '知らせる').
a2(e_interpret,    'interpret',    'to turn speech into another tongue',  '通訳する').
a2(e_joke,         'joke',         'something said to amuse',             '冗談').
a2(e_rumor,        'rumor',        'what is said without proof',          '噂').
a2(e_news,         'news',         'what has just happened',              '知らせ').
a2(e_advice,       'advice',       'what someone says you should do',     '助言').
a2(e_permission,   'permission',   'being allowed',                       '許可').
a2(e_invitation,   'invitation',   'being asked to come',                 '招待').
a2(e_reason,       'reason',       'why a thing is so',                   '理由').

% --- Doing: action and change ------------------------------------------
a2(e_achieve,      'achieve',      'to succeed in doing',                 '達成する').
a2(e_allow,        'allow',        'to let happen',                       '許す').
a2(e_appear,       'appear',       'to come into sight',                  '現れる').
a2(e_disappear,    'disappear',    'to go out of sight',                  '消える').
a2(e_arrange,      'arrange',      'to put in order',                     '手配する').
a2(e_avoid,        'avoid',        'to keep away from',                   '避ける').
a2(e_believe,      'believe',      'to hold to be true',                  '信じる').
a2(e_belong,       'belong',       'to be the property of',               '属する').
a2(e_cause,        'cause',        'to make happen',                      '引き起こす').
a2(e_compare,      'compare',      'to look at two together',             '比較する').
a2(e_complete,     'complete',     'to bring to an end',                  '完成する').
a2(e_consider,     'consider',     'to think over',                       '考慮する').
a2(e_continue,     'continue',     'to go on',                            '続ける').
a2(e_control,      'control',      'to direct and limit',                 '制御する').
a2(e_create,       'create',       'to bring into being',                 '創造する').
a2(e_destroy,      'destroy',      'to break beyond repair',              '破壊する').
a2(e_develop,      'develop',      'to grow or make grow',                '発展する').
a2(e_die,          'die',          'to stop living',                      '死ぬ').
a2(e_discover,     'discover',     'to find what was unknown',            '発見する').
a2(e_divide,       'divide',       'to separate into parts',              '分ける').
a2(e_earn,         'earn',         'to get by working',                   '稼ぐ').
a2(e_encourage,    'encourage',    'to give heart to',                    '励ます').
a2(e_enjoy,        'enjoy',        'to take pleasure in',                 '楽しむ').
a2(e_examine,      'examine',      'to look at closely',                  '調べる').
a2(e_exist,        'exist',        'to be, at all',                       '存在する').
a2(e_expect,       'expect',       'to think it will happen',             '予期する').
a2(e_fail,         'fail',         'not to succeed',                      '失敗する').
a2(e_fill,         'fill',         'to make full',                        '満たす').
a2(e_fit,          'fit',          'to be the right size',                '合う').
a2(e_fix,          'fix',          'to fasten firmly',                    '固定する').
a2(e_follow,       'follow',       'to go after',                         '従う').
a2(e_hate,         'hate',         'to dislike strongly',                 '憎む').
a2(e_hide,         'hide',         'to put out of sight',                 '隠す').
a2(e_hit,          'hit',          'to strike',                           '打つ').
a2(e_hurt,         'hurt',         'to cause pain to',                    '傷つける').
a2(e_improve,      'improve',      'to make better',                      '改善する').
a2(e_include,      'include',      'to have as a part',                   '含む').
a2(e_increase,     'increase',     'to become more',                      '増える').
a2(e_decrease,     'decrease',     'to become less',                      '減る').
a2(e_join,         'join',         'to put together',                     '結合する').
a2(e_keep,         'keep',         'to go on having',                     '保つ').
a2(e_kick,         'kick',         'to strike with the foot',             '蹴る').
a2(e_kill,         'kill',         'to cause to die',                     '殺す').
a2(e_knock,        'knock',        'to strike to be heard',               'ノックする').
a2(e_lead,         'lead',         'to go in front of',                   '導く').
a2(e_lift,         'lift',         'to raise up',                         '持ち上げる').
a2(e_manage,       'manage',       'to succeed in handling',              'やり遂げる').
a2(e_measure,      'measure',      'to find the size of',                 '測る').
a2(e_mind,         'mind',         'to object to',                        '気にする').
a2(e_miss,         'miss',         'to fail to catch',                    '乗り遅れる').
a2(e_notice,       'notice',       'to become aware of',                  '気づく').
a2(e_offer,        'offer',        'to hold out for taking',              '申し出る').
a2(e_own,          'own',          'to have as property',                 '所有する').
a2(e_pass,         'pass',         'to go by',                            '通り過ぎる').
a2(e_perform,      'perform',      'to carry out before others',          '演じる').
a2(e_pick,         'pick',         'to take up with the fingers',         '摘む').
a2(e_plan,         'plan',         'to decide beforehand',                '計画する').
a2(e_prefer,       'prefer',       'to like better',                      '好む').
a2(e_prepare,      'prepare',      'to get ready',                        '準備する').
a2(e_prevent,      'prevent',      'to stop from happening',              '防ぐ').
a2(e_produce,      'produce',      'to bring forth',                      '作り出す').
a2(e_protect,      'protect',      'to keep from harm',                   '守る').
a2(e_prove,        'prove',        'to show beyond doubt',                '証明する').
a2(e_provide,      'provide',      'to give what is needed',              '提供する').
a2(e_realize,      'realize',      'to come to understand',               '悟る').
a2(e_receive,      'receive',      'to be given',                         '受け取る').
a2(e_recognize,    'recognize',    'to know again',                       '見分ける').
a2(e_recommend,    'recommend',    'to speak in favour of',               '推薦する').
a2(e_reduce,       'reduce',       'to make smaller',                     '縮小する').
a2(e_regret,       'regret',       'to be sorry about',                   '後悔する').
a2(e_relax,        'relax',        'to become less tense',                'くつろぐ').
a2(e_remove,       'remove',       'to take away',                        '取り除く').
a2(e_require,      'require',      'to need of necessity',                '要求する').
a2(e_rise,         'rise',         'to go up',                            '上がる').
a2(e_search,       'search',       'to look carefully for',               '捜す').
a2(e_seem,         'seem',         'to give the impression',              '思われる').
a2(e_separate,     'separate',     'to keep apart',                       '引き離す').
a2(e_share,        'share',        'to have in common',                   '分かち合う').
a2(e_sign,         'sign',         'to write your name on',               '署名する').
a2(e_solve,        'solve',        'to find the answer to',               '解決する').
a2(e_sort,         'sort',         'to put into kinds',                   '分類する').
a2(e_spread,       'spread',       'to open out wide',                    '広げる').
a2(e_steal,        'steal',        'to take what is not yours',           '盗む').
a2(e_succeed,      'succeed',      'to do what was tried',                '成功する').
a2(e_suffer,       'suffer',       'to undergo something bad',            '苦しむ').
a2(e_support,      'support',      'to hold up or back',                  '支える').
a2(e_suppose,      'suppose',      'to take to be so',                    '推測する').
a2(e_surprise,     'surprise',     'to come upon unexpectedly',           '驚かす').
a2(e_survive,      'survive',      'to live through',                     '生き残る').
a2(e_tie,          'tie',          'to fasten with a cord',               '結ぶ').
a2(e_treat,        'treat',        'to deal with',                        '扱う').
a2(e_trust,        'trust',        'to rely on',                          '信頼する').
a2(e_unite,        'unite',        'to make one',                         '一体化する').
a2(e_waste,        'waste',        'to use without gain',                 '無駄にする').
a2(e_welcome,      'welcome',      'to receive gladly',                   '歓迎する').
a2(e_wonder,       'wonder',       'to ask yourself',                     '不思議に思う').
a2(e_attack,       'attack',       'to set upon',                         '攻撃する').
a2(e_defend,       'defend',       'to keep off attack',                  '防御する').
a2(e_escape,       'escape',       'to get away',                         '逃げる').
a2(e_hang,         'hang',         'to fasten from above',                '吊る').
a2(e_pour,         'pour',         'to make flow out',                    '注ぐ').
a2(e_press,        'press',        'to push steadily',                    '押しつける').
a2(e_shake,        'shake',        'to move quickly to and fro',          '振る').
a2(e_stretch,      'stretch',      'to pull out longer',                  '伸ばす').
a2(e_bend,         'bend',         'to make curved',                      '曲げる').
a2(e_burn,         'burn',         'to be on fire',                       '燃える').
a2(e_freeze,       'freeze',       'to turn to ice',                      '凍る').
a2(e_melt,         'melt',         'to turn to liquid',                   '溶ける').
a2(e_float,        'float',        'to stay on the surface',              '浮く').
a2(e_sink,         'sink',         'to go under',                         '沈む').
a2(e_grow,         'grow',         'to become bigger',                    '成長する').
a2(e_shrink,       'shrink',       'to become smaller',                   '縮む').

% --- Describing --------------------------------------------------------
a2(e_ancient,      'ancient',      'very old indeed',                     '古代の').
a2(e_modern,       'modern',       'of the present time',                 '現代の').
a2(e_common,       'common',       'found often',                         '一般的な').
a2(e_rare,         'rare',         'found seldom',                        'まれな').
a2(e_usual,        'usual',        'as it normally is',                   '普通の').
a2(e_unusual,      'unusual',      'not as it normally is',               '異常な').
a2(e_possible,     'possible',     'able to happen',                      '可能な').
a2(e_impossible,   'impossible',   'not able to happen',                  '不可能な').
a2(e_necessary,    'necessary',    'that must be',                        '必要な').
a2(e_useful,       'useful',       'of good use',                         '役に立つ').
a2(e_useless,      'useless',      'of no use',                           '無益な').
a2(e_similar,      'similar',      'much the same',                       '類似した').
a2(e_opposite,     'opposite',     'as different as can be',              '正反対の').
a2(e_equal,        'equal',        'the same in amount',                  '等しい').
a2(e_main,         'main',         'the most important',                  '主要な').
a2(e_extra,        'extra',        'more than is needed',                 '余分な').
a2(e_whole,        'whole',        'all of it',                           '全体の').
a2(e_single,       'single',       'only one',                            '単一の').
a2(e_double,       'double',       'twice as much',                       '二倍の').
a2(e_several,      'several',      'more than two, not many',             'いくつかの').
a2(e_certain,      'certain',      'known for sure',                      '確実な').
a2(e_probable,     'probable',     'likely to be so',                     'ありそうな').
a2(e_obvious,      'obvious',      'easy to see',                         '明白な').
a2(e_strict,       'strict',       'allowing no slack',                   '厳しい').
a2(e_fair,         'fair',         'treating all alike',                  '公平な').
a2(e_unfair,       'unfair',       'not treating all alike',              '不公平な').
a2(e_complicated,  'complicated',  'made of many parts',                  '複雑な').
a2(e_smooth,       'smooth',       'with no roughness',                   '滑らかな').
a2(e_rough,        'rough',        'not smooth',                          '粗い').
a2(e_sharp,        'sharp',        'with a fine edge',                    '鋭い').
a2(e_blunt,        'blunt',        'with no fine edge',                   '鈍い').
a2(e_tight,        'tight',        'fitting with no room',                'きつい').
a2(e_loose,        'loose',        'not held firmly',                     'ゆるい').
a2(e_flat,         'flat',         'level, with no rise',                 '平らな').
a2(e_steep,        'steep',        'rising sharply',                      '険しい').
a2(e_straight,     'straight',     'with no bend',                        '直線の').
a2(e_curved,       'curved',       'bent in a smooth line',               '湾曲した').
a2(e_hollow,       'hollow',       'empty inside',                        '中空の').
a2(e_solid,        'solid',        'firm all through',                    '固体の').
a2(e_liquid,       'liquid',       'able to flow',                        '液体の').
a2(e_bright,       'bright',       'giving much light',                   '明るい').
a2(e_dark,         'dark',         'with little light',                   '暗い').
a2(e_silent,       'silent',       'making no sound',                     '静寂な').
a2(e_noisy,        'noisy',        'making much sound',                   '騒がしい').
a2(e_fresh,        'fresh',        'newly made or picked',                '新鮮な').
a2(e_stale,        'stale',        'no longer fresh',                     '古くなった').
a2(e_sour,         'sour',         'sharp in taste',                      '酸っぱい').
a2(e_bitter,       'bitter',       'harsh in taste',                      '苦い').
a2(e_salty,        'salty',        'tasting of salt',                     '塩辛い').
a2(e_spicy,        'spicy',        'hot with spice',                      '辛い').
a2(e_nearly,       'nearly',       'not quite',                           'ほぼ').
a2(e_hardly,       'hardly',       'almost not at all',                   'ほとんど…ない').
a2(e_perhaps,      'perhaps',      'it may be so',                        'おそらく').
a2(e_certainly,    'certainly',    'without doubt',                       '確かに').
a2(e_suddenly,     'suddenly',     'all at once',                         '突然').
a2(e_gradually,    'gradually',    'little by little',                    '次第に').
a2(e_recently,     'recently',     'not long ago',                        '最近').
a2(e_immediately,  'immediately',  'at once',                             '直ちに').
a2(e_meanwhile,    'meanwhile',    'while that went on',                  'その間に').
a2(e_instead,      'instead',      'in place of it',                      '代わりに').
a2(e_besides,      'besides',      'as well as that',                     'その上').
a2(e_however,      'however',      'but, all the same',                   'しかしながら').
a2(e_therefore,    'therefore',    'for that reason',                     'それゆえ').
a2(e_although,     'although',     'even though',                         'だけれども').
a2(e_unless,       'unless',       'if not',                              'でなければ').
a2(e_during,       'during',       'all through that time',               'の間').
a2(e_towards,      'towards',      'in the direction of',                 'の方へ').
a2(e_without,      'without',      'not having',                          'なしで').
a2(e_among,        'among',        'in the middle of many',               'の中で').
a2(e_beyond,       'beyond',       'further than',                        'を越えて').
