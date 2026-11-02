# romaji.py -- kana to the romaji this project's ids are written in.
# Hepburn with long vowels doubled (soujiki, juutaku), which is what
# graph/ja/picks/*.pl already does.
BASE = {
 'あ':'a','い':'i','う':'u','え':'e','お':'o',
 'か':'ka','き':'ki','く':'ku','け':'ke','こ':'ko',
 'が':'ga','ぎ':'gi','ぐ':'gu','げ':'ge','ご':'go',
 'さ':'sa','し':'shi','す':'su','せ':'se','そ':'so',
 'ざ':'za','じ':'ji','ず':'zu','ぜ':'ze','ぞ':'zo',
 'た':'ta','ち':'chi','つ':'tsu','て':'te','と':'to',
 'だ':'da','ぢ':'ji','づ':'zu','で':'de','ど':'do',
 'な':'na','に':'ni','ぬ':'nu','ね':'ne','の':'no',
 'は':'ha','ひ':'hi','ふ':'fu','へ':'he','ほ':'ho',
 'ば':'ba','び':'bi','ぶ':'bu','べ':'be','ぼ':'bo',
 'ぱ':'pa','ぴ':'pi','ぷ':'pu','ぺ':'pe','ぽ':'po',
 'ま':'ma','み':'mi','む':'mu','め':'me','も':'mo',
 'や':'ya','ゆ':'yu','よ':'yo',
 'ら':'ra','り':'ri','る':'ru','れ':'re','ろ':'ro',
 'わ':'wa','ゐ':'i','ゑ':'e','を':'o','ん':'n',
 'ゔ':'vu',
}
YOON = {
 'きゃ':'kya','きゅ':'kyu','きょ':'kyo','ぎゃ':'gya','ぎゅ':'gyu','ぎょ':'gyo',
 'しゃ':'sha','しゅ':'shu','しょ':'sho','じゃ':'ja','じゅ':'ju','じょ':'jo',
 'ちゃ':'cha','ちゅ':'chu','ちょ':'cho','ぢゃ':'ja','ぢゅ':'ju','ぢょ':'jo',
 'にゃ':'nya','にゅ':'nyu','にょ':'nyo','ひゃ':'hya','ひゅ':'hyu','ひょ':'hyo',
 'びゃ':'bya','びゅ':'byu','びょ':'byo','ぴゃ':'pya','ぴゅ':'pyu','ぴょ':'pyo',
 'みゃ':'mya','みゅ':'myu','みょ':'myo','りゃ':'rya','りゅ':'ryu','りょ':'ryo',
 'ふぁ':'fa','ふぃ':'fi','ふぇ':'fe','ふぉ':'fo','うぃ':'wi','うぇ':'we',
 'てぃ':'ti','でぃ':'di','とぅ':'tu','どぅ':'du','ちぇ':'che','しぇ':'she',
 'じぇ':'je','つぁ':'tsa','つぇ':'tse','つぉ':'tso','ゔぁ':'va','ゔぃ':'vi',
 'きぇ':'kye','ぎぇ':'gye','ひぇ':'hye','ゐぇ':'we',
}
def kata2hira(s):
    out = []
    for ch in s:
        o = ord(ch)
        if 0x30A1 <= o <= 0x30F6: out.append(chr(o - 0x60))
        elif ch == 'ー': out.append('ー')
        else: out.append(ch)
    return ''.join(out)

def romaji(kana):
    """None when the reading holds something this table cannot spell."""
    s = kata2hira(kana)
    out = []
    i = 0
    while i < len(s):
        two = s[i:i+2]
        ch = s[i]
        if two in YOON:
            out.append(YOON[two]); i += 2; continue
        if ch == 'っ':
            # geminate: double the next consonant, and sh/ch/ts take their first
            nxt = s[i+1:i+3]
            r = YOON.get(nxt) or BASE.get(s[i+1:i+2])
            if not r: return None
            # the first letter of the romaji, doubled: zasshi, kippu,
            # and suicchi -- which is how graph/ja/picks/n4.pl spells it.
            out.append(r[0])
            i += 1; continue
        if ch == 'ー':
            if not out or not out[-1] or out[-1][-1] not in 'aiueo': return None
            out.append(out[-1][-1]); i += 1; continue
        if ch in BASE:
            out.append(BASE[ch]); i += 1; continue
        if ch in 'ぁぃぅぇぉゃゅょ':  # a small kana this table did not pair
            return None
        return None
    return ''.join(out)
