#!/usr/bin/env python3
# draft-picks.py -- the N3 word candidates, ranked, as TSV.
#
#     ./langpop dump --lang ja > work/ja-dump.json
#     python3 tools/draft-picks.py work
#
# reads work/ja-dump.json and ~/langpop-upstream/{JMdict_e,ja_full.txt}
# and writes work/candidates.tsv: one candidate a line, best first, as
#
#     band  dialogue-count  headword  reading  id  seq  DUPID?  pos  gloss
#
# A DUPID row wants a different id from the row above that took it; the
# curation pass drops them.
#
# WHAT THIS IS NOT.  It is not the pick list.  It is the pool a curator
# reads, in the order a curator should read it: the words JMdict marks
# common, written in kanji the graph teaches at or below N3, that the
# graph does not already teach.  Rejection is still by hand.
import os, re, sys, json
import xml.etree.ElementTree as ET
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from romaji import romaji

WORK = sys.argv[1] if len(sys.argv) > 1 else '.'
UP   = os.environ.get('LANGPOP_UPSTREAM',
                      os.path.expanduser('~/langpop-upstream'))

# ---- what the graph already holds ------------------------------------
# From the graph's OWN DUMP, not a regex over its source.  items.pl
# derives its fifty starters through starter/4 rules rather than writing
# form/3 facts, so a scan of the text misses every one of them -- which
# is how 学校 reached the top of a first draft of this pool while
# w_gakkou had been an item since the first week.
#
#     ./langpop dump --lang ja > ja-dump.json
#
# The dump prints the Prolog banner on stdout first, so the JSON starts
# at the first brace.
raw  = open(WORK + '/ja-dump.json', encoding='utf-8').read()
dump = json.loads(raw[raw.index('{'):])
have_forms, have_ids, kanji_ok = set(), set(), set()
for it in dump['items']:
    have_ids.add(it['id'])
    have_forms.add(it.get('label'))
    for v in (it.get('forms') or {}).values():
        have_forms.add(v)
    if it['kind'] == 'grapheme' and it['level'] in ('n5', 'n4', 'n3'):
        k = (it.get('forms') or {}).get('kanji')
        if k:
            kanji_ok.add(k)

# ---- the subtitle frequency list, as a tiebreak -----------------------
freq = {}
for line in open(UP + '/ja_full.txt', encoding='utf-8'):
    p = line.split()
    if len(p) == 2:
        freq[p[0]] = int(p[1])

# ---- JMdict's own abbreviations, recovered ---------------------------
# ElementTree EXPANDS the DTD entities, so <pos>&v1;</pos> arrives as the
# text "Ichidan verb" and every test written against 'v1' or 'exp' or
# 'arch' quietly matched nothing.  The DTD is in the file's own header,
# so the expansion is reversible.
ENT = {}
with open(UP + '/JMdict_e', encoding='utf-8') as f:
    for line in f:
        m = re.match(r'<!ENTITY (\S+) "(.*)">', line)
        if m: ENT[m.group(2)] = m.group(1)
        if line.startswith('<JMdict'): break


def abbr(texts):
    """The tag texts as JMdict's abbreviations, unknown text kept as-is."""
    return {ENT.get(t, t) for t in texts}


SKIP_MISC = {'arch', 'rare', 'obs', 'obsc', 'vulg', 'derog', 'sl', 'X',
             'joc', 'dated', 'hist', 'poet', 'm-sl', 'net-sl', 'proverb',
             'id', 'litf', 'form', 'col', 'fem', 'male', 'chn', 'hon',
             'hum', 'pol', 'sens', 'uk'}
SKIP_POS  = {'exp', 'pn', 'int', 'prt', 'aux', 'aux-v', 'aux-adj',
             'cop', 'ctr', 'num', 'unc', 'pref', 'suf'}
SKIP_KTAG = {'iK', 'ateji', 'oK', 'rK', 'sK', 'ik'}


def band(pri):
    """A rank from JMdict's own priority marks: the nf band if it has one
    (Mainichi newspaper, 500 words to a band), else a coarse stand-in."""
    best = None
    for t in pri:
        if t.startswith('nf'):
            n = int(t[2:])
            best = n if best is None else min(best, n)
    if best is not None:
        return best
    if 'ichi1' in pri or 'spec1' in pri or 'news1' in pri: return 25
    if 'ichi2' in pri or 'spec2' in pri or 'news2' in pri: return 30
    if 'gai1' in pri: return 31
    if 'gai2' in pri: return 32
    return None


# ---- the verbs and adjectives, so a STEM can be recognised ----------
# 出来 reaches the top of a dialogue-ordered pool because the segmenter
# counted every 出来る, and 面白 because of 面白い.  A stem is not a word
# to teach -- the verb is -- and its frequency is the verb's, borrowed.
VADJ = set()
for ev, el in ET.iterparse(UP + '/JMdict_e', events=('end',)):
    if el.tag != 'entry':
        continue
    pos = {p.text for s_ in el.findall('sense') for p in s_.findall('pos')}
    pos = abbr(pos)
    if any(p.startswith('v') or p == 'adj-i' for p in pos):
        for k in el.findall('k_ele'):
            for r in el.findall('r_ele'):
                VADJ.add((k.findtext('keb'), r.findtext('reb')))
    el.clear()


# A STEM is the word plus a verb or adjective ending, and nothing else.
# Anything longer is a different word: 人間らしい begins with 人間 and
# ends in い, and a first draft of this rule threw 人間 out of the pool
# for it -- along with 女性, 理解 and every other word some adjective
# happens to be built on.
TAILS = {'る', 'う', 'く', 'ぐ', 'す', 'つ', 'ぬ', 'ぶ', 'む', 'い',
         'える', 'いる', 'ける', 'じる', 'ずる', 'れる'}


def is_stem(keb, reading):
    for vk, vr in VADJ:
        if not vk or not vr or not vk.startswith(keb): continue
        tail = vk[len(keb):]
        if tail in TAILS and vr[len(reading):] == tail \
           and vr.startswith(reading):
            return True
    return False


rows = []
for ev, el in ET.iterparse(UP + '/JMdict_e', events=('end',)):
    if el.tag != 'entry':
        continue
    seq = el.findtext('ent_seq')
    kebs = []
    for k in el.findall('k_ele'):
        if {t.text for t in k.findall('ke_inf')} & SKIP_KTAG:
            continue
        kebs.append((k.findtext('keb'), {p.text for p in k.findall('ke_pri')}))
    rebs = [(r.findtext('reb'), {p.text for p in r.findall('re_pri')},
             r.find('re_nokanji') is not None,
             [x.text for x in r.findall('re_restr')])
            for r in el.findall('r_ele')]
    poss, miscs, glosses = set(), set(), []
    for s in el.findall('sense'):
        poss  |= abbr(p.text for p in s.findall('pos'))
        miscs |= abbr(m.text for m in s.findall('misc'))
        glosses += [g.text for g in s.findall('gloss')
                    if g.text and g.get('g_type') in (None, 'lit')]
    el.clear()
    if not kebs or not rebs or not glosses: continue
    if miscs & SKIP_MISC: continue
    if poss and poss <= SKIP_POS: continue
    keb, kpri = kebs[0]
    # every character either a kanji the student has, or kana
    if any(c not in kanji_ok and not (0x3040 <= ord(c) <= 0x30FF) for c in keb):
        continue
    # the reading that carries the priority marks, not merely the first:
    # 生物 lists なまもの ahead of せいぶつ, and the first-wins rule taught
    # the word as "raw food".
    reading, best = None, -1
    for reb, rpri, nok, restr in rebs:
        if nok: continue
        if restr and keb not in restr: continue
        score = len(rpri)
        if score > best:
            reading, best = reb, score
    if reading is None: continue
    b = band(kpri | set().union(*[r[1] for r in rebs]))
    if b is None: continue
    # an id or a form the graph already has would split a student's
    # beliefs about one word in two, and the importer refuses it.
    if keb in have_forms or reading in have_forms: continue
    rid = romaji(reading)
    if rid is None or 'w_' + rid in have_ids: continue
    if is_stem(keb, reading): continue
    rows.append((-freq.get(keb, 0), b, keb, reading, 'w_' + rid, seq,
                 '; '.join(glosses[:3]), ','.join(sorted(poss))))

rows.sort()
seen = set()
with open(WORK + '/candidates.tsv', 'w', encoding='utf-8') as out:
    for nf, b, keb, reading, rid, seq, gl, pos in rows:
        dup = rid in seen
        seen.add(rid)
        out.write('\t'.join([str(b), str(-nf), keb, reading, rid, seq,
                             'DUPID' if dup else '', pos, gl]) + '\n')
print(f'{len(rows)} candidates, {len(rows) - len(seen)} sharing an id',
      file=sys.stderr)
