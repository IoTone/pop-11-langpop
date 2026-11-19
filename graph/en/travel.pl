% graph/en/travel.pl -- what a trip abroad needs said and understood, for
% a Japanese speaker.
%
% The mirror of graph/ja/travel.pl: see its header for why a phrase is
% its own kind, why it is asked by meaning, and why only a student whose
% goal is `travel` is offered one.
%
% At A1, the first rung with words on it.  The Japanese gloss is ours,
% typed here, as the A1 glosses are.  Some are what the traveller says
% and some are what is said to them ('Cash or card?').
%
% NOT REVIEWED by a native speaker of Japanese at the time of writing.

item(Id, phrase, en, a1, own(travel_list)) :- travel_en(Id, _, _, _).
form(Id, latin, Text) :- travel_en(Id, _, Text, _).
gloss(Id, ja, Ja) :- travel_en(Id, _, _, Ja).
situation(Id, Sit) :- travel_en(Id, Sit, _, _).

% travel_en(Id, Situation, Text, GlossJa).

% --- Getting by -----------------------------------------------------------
travel_en(et_excuse,     basics, 'Excuse me.',                       'すみません').
travel_en(et_thanks,     basics, 'Thank you very much.',             'ありがとうございます').
travel_en(et_again,      basics, 'Could you say that again?',        'もう一度言ってください').
travel_en(et_slowly,     basics, 'Could you speak more slowly?',     'もっとゆっくり話してください').
travel_en(et_understand, basics, 'I do not understand.',             'わかりません').
travel_en(et_japanese,   basics, 'Does anyone speak Japanese?',      '日本語を話せる人はいますか').

% --- The bathroom, and finding things -------------------------------------
travel_en(et_bathroom,   street, 'Where is the bathroom?',           'トイレはどこですか').
travel_en(et_station,    street, 'Where is the station?',            '駅はどこですか').
travel_en(et_right,      street, 'Turn right at the corner.',        '角を右に曲がってください').
travel_en(et_left,       street, 'Turn left at the light.',          '信号を左に曲がってください').
travel_en(et_straight,   street, 'Go straight ahead.',               'まっすぐ行ってください').
travel_en(et_far,        street, 'Is it far from here?',             'ここから遠いですか').

% --- Trains ---------------------------------------------------------------
travel_en(et_platform,   train,  'Which platform is it?',            '何番線ですか').
travel_en(et_platform3,  train,  'It leaves from platform three.',   '三番線から出ます').
travel_en(et_ticket,     train,  'One ticket to London, please.',    'ロンドンまで切符を一枚ください').
travel_en(et_airport,    train,  'Does this train go to the airport?', 'この電車は空港に行きますか').
travel_en(et_change,     train,  'Where do I change trains?',        'どこで乗り換えますか').
travel_en(et_next,       train,  'What time is the next train?',     '次の電車は何時ですか').

% --- The hotel ------------------------------------------------------------
travel_en(et_checkin,    hotel,  'I would like to check in.',        'チェックインをお願いします').
travel_en(et_reserve,    hotel,  'I have a reservation.',            '予約があります').
travel_en(et_passport,   hotel,  'May I see your passport?',         'パスポートを見せていただけますか').
travel_en(et_key,        hotel,  'Could I have the room key?',       '部屋の鍵をください').
travel_en(et_breakfast,  hotel,  'What time is breakfast?',          '朝食は何時ですか').
travel_en(et_checkout,   hotel,  'What time is check-out?',          'チェックアウトは何時ですか').

% --- Eating ---------------------------------------------------------------
travel_en(et_table,      food,   'A table for two, please.',         '二人です').
travel_en(et_menu,       food,   'Could I see the menu?',            'メニューを見せてください').
travel_en(et_this,       food,   'I will have this one.',            'これをください').
travel_en(et_water,      food,   'Could I have some water?',         '水をください').
travel_en(et_bill,       food,   'Could I have the bill?',           'お会計をお願いします').
travel_en(et_togo,       food,   'For here or to go?',               '店内ですか、お持ち帰りですか').

% --- Paying ---------------------------------------------------------------
travel_en(et_howmuch,    shop,   'How much is this?',                'これはいくらですか').
travel_en(et_card,       shop,   'Can I pay by card?',               'カードで払えますか').
travel_en(et_cashcard,   shop,   'Cash or card?',                    '現金ですか、カードですか').
travel_en(et_bag,        shop,   'Do you need a bag?',               '袋はいりますか').

% --- When it goes wrong ---------------------------------------------------
travel_en(et_help,       help,   'Please help me.',                  '助けてください').
travel_en(et_hospital,   help,   'Where is the hospital?',           '病院はどこですか').
travel_en(et_lost,       help,   'I have lost my passport.',         'パスポートをなくしました').
travel_en(et_police,     help,   'Please call the police.',          '警察を呼んでください').
