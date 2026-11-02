#!/usr/bin/env python3
# draft-picks.py -- the word candidates for a rung, ranked, as TSV.
#
#     ./langpop dump --lang ja > work/ja-dump.json
#     python3 tools/draft-picks.py work [level] [order]
#
# The level is the rung being built (default n3) and it decides one
# thing: which kanji a headword may be written in.  The order is
# `dialogue` (default) or `newspaper`, and it decides which corpus ranks
# the pool -- which is a claim about the RUNG and is argued in
# docs/langpop-n3-vocabulary.md for N3 and docs/langpop-n2-vocabulary.md
# for N2.  Everything else is the same question at every rung.
#
# Two files come out.  work/candidates.tsv is the whole pool, best
# first.  work/cand.tsv is the review list -- the same rows with the
# DUPID ones dropped, and, under `dialogue`, the words no dialogue
# corpus has -- and it is what mkpicks.py reads.  Both are written here
# rather than cut out afterwards by hand, so that a pick file can be
# reproduced from its own recipe.
#
# reads work/ja-dump.json and ~/langpop-upstream/{JMdict_e,ja_full.txt}
# and writes work/candidates.tsv: one candidate a line, best first, as
#
#     band  dialogue-count  headword  reading  id  seq  DUPID?  pos  gloss  nf
#
# `band` is the sort key the N3 rung used and `nf` is the raw Mainichi
# newspaper band, which is NOT the same thing: band falls back to a
# stand-in (25, 30, 31, 32) for a word JMdict marks common without
# giving it a newspaper rank, and a rung that orders BY the newspaper
# has to be able to tell those apart.  See docs/langpop-n2-vocabulary.md.
#
# A DUPID row wants a different id from the row above that took it; the
# curation pass drops them.
#
# WHAT THIS IS NOT.  It is not the pick list.  It is the pool a curator
# reads, in the order a curator should read it: the words JMdict marks
# common, written in kanji the graph teaches at or below N3, that the
# graph does not already teach.  Rejection is still by hand.
import glob, os, re, sys, json
import xml.etree.ElementTree as ET
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from romaji import romaji

WORK  = sys.argv[1] if len(sys.argv) > 1 else '.'
LEVEL = sys.argv[2] if len(sys.argv) > 2 else 'n3'
ORDER = sys.argv[3] if len(sys.argv) > 3 else 'dialogue'
if ORDER not in ('dialogue', 'newspaper'):
    sys.exit('draft-picks: order is dialogue or newspaper, not ' + ORDER)
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
# The rungs at or below the one being built, from the dump's own ladder
# rather than a list written here: a reading question at this rung has to
# be answerable at this rung, and what that means is a fact about the
# ladder.
rungs = {r['level']: r['n'] for r in dump['languages'][0]['ladder']}
if LEVEL not in rungs:
    sys.exit('draft-picks: %s is not a rung of this ladder (%s)'
             % (LEVEL, ', '.join(rungs)))
AT_OR_BELOW = {lv for lv, n in rungs.items() if n <= rungs[LEVEL]}

# WHAT A CURATOR HAS ALREADY REFUSED stays refused.  The graph knows
# what it teaches; only the reject files know what was offered and turned
# down, and the pool asks the same question at every rung -- so without
# this the N2 pool opened with 出来 as しゅったい, 今日 as こんにち and
# 日本, all three thrown out of N3 by hand the day before.  Worse than
# the wasted reading: a word refused as a proper noun at one rung and
# accepted at the next is not a curriculum, it is two opinions.
#
# KEYED BY (id, headword) AND NOT BY id, which cost one word to learn.
# An id is a reading -- w_sousa was 走査, thrown out of N3 as imaging
# jargon -- and 捜査, a different word a learner meets in every news
# bulletin, would have been refused for it without ever being read.
# That is also why the reject files name the headword: a row reading
# `w_sousa register imaging technology` does not say which そうさ its
# writer meant.
#
# THIS RUNG'S OWN REJECTIONS ARE NOT CARRIED, they are subtracted later
# by mkpicks.py, and the difference matters: the hand review reads the
# pool down to a rank, and a row it threw out is a row it READ.  Taking
# the rejections out of the pool itself would slide 336 unread words up
# into the reviewed window, so n3.pl could no longer be reproduced from
# its own recipe -- which is how this was noticed.
#
# A rejection is undone by deleting its row, which is a deliberate act
# and leaves a diff.
refused = set()
for rf in sorted(glob.glob(HERE + '/../graph/ja/picks/*-rejects.tsv')):
    if os.path.basename(rf) == LEVEL + '-rejects.tsv':
        continue
    for line in open(rf, encoding='utf-8'):
        f = line.rstrip('\n').split('\t')
        if len(f) >= 4:
            refused.add((f[0], f[1]))

have_forms, have_ids, kanji_ok = set(), set(), set()
for it in dump['items']:
    have_ids.add(it['id'])
    have_forms.add(it.get('label'))
    for v in (it.get('forms') or {}).values():
        have_forms.add(v)
    if it['kind'] == 'grapheme' and it['level'] in AT_OR_BELOW:
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


def nf_band(pri):
    """The Mainichi newspaper band, 500 words to a band, or None for a
    word the newspaper corpus does not rank at all."""
    best = None
    for t in pri:
        if t.startswith('nf'):
            n = int(t[2:])
            best = n if best is None else min(best, n)
    return best


def band(pri):
    """A rank from JMdict's own priority marks: the nf band if it has one,
    else a coarse stand-in."""
    best = nf_band(pri)
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
        # abbr() HERE TOO.  This filter was written against the short
        # codes and read the expanded text, so it matched nothing and
        # the ateji spellings walked in: JMdict calls 味方, 無茶, 心地
        # and 日和 phonetic borrowings, import.p refuses to teach a
        # tagged spelling, and the four arrived as kana-only items with
        # no reading question at all.  The pool must refuse exactly
        # what the importer refuses -- see import.p's RARE_KANJI.
        if abbr(t.text for t in k.findall('ke_inf')) & SKIP_KTAG:
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
    pri = kpri | set().union(*[r[1] for r in rebs])
    b = band(pri)
    if b is None: continue
    nf = nf_band(pri)
    # an id or a form the graph already has would split a student's
    # beliefs about one word in two, and the importer refuses it.
    if keb in have_forms or reading in have_forms: continue
    rid = romaji(reading)
    if rid is None or 'w_' + rid in have_ids: continue
    if ('w_' + rid, keb) in refused: continue
    if is_stem(keb, reading): continue
    rows.append([-freq.get(keb, 0), b, keb, reading, 'w_' + rid, seq,
                 '; '.join(glosses[:3]), ','.join(sorted(poss)), nf])

# Ranked by the corpus this rung belongs to.  Under `newspaper` the
# dialogue count is only the tiebreak, and a word no dialogue corpus has
# still ranks: 判断, 批判, 段階 and 背景 are absent from a 34,504-form
# subtitle list, and a rung that reads newspapers cannot be built out of
# words people say out loud.
rows.sort()

# WHO OWNS THE ID, decided here and before the rung's own ordering, so
# that it is the same answer at every rung.  An id is a reading, and
# three words read どうし: 同志, 同士 and 同市.  Ranked by dialogue the
# id goes to 同志, which is a word; ranked by the newspaper it goes to
# 同市, "the said city", which is not.  A romaji id that means one word
# while N3 is being built and another while N2 is would make two items
# out of one name, which is the thing this pool exists to prevent -- so
# the dialogue order settles it once, for both rungs.
owned = set()
for r in rows:
    r.append(r[4] in owned)
    owned.add(r[4])

if ORDER == 'newspaper':
    # A SECOND, STABLE sort and not a different key: ties on (band,
    # dialogue) then fall where the dialogue order left them, which is
    # the headword, rather than wherever JMdict happened to list them.
    # A tie-break nobody chose is a boundary nobody can reproduce.
    rows.sort(key=lambda r: (999 if r[8] is None else r[8], r[0]))

review = []
with open(WORK + '/candidates.tsv', 'w', encoding='utf-8') as out:
    for negf, b, keb, reading, rid, seq, gl, pos, nf, dup in rows:
        row = '\t'.join([str(b), str(-negf), keb, reading, rid, seq,
                          'DUPID' if dup else '', pos, gl,
                          '' if nf is None else str(nf)])
        out.write(row + '\n')
        if not dup and (ORDER == 'newspaper' or negf < 0):
            review.append(row)
with open(WORK + '/cand.tsv', 'w', encoding='utf-8') as out:
    out.write(''.join(r + '\n' for r in review))
print(f'{len(rows)} candidates, {len(rows) - len(owned)} sharing an id, '
      f'{len(review)} to review', file=sys.stderr)
