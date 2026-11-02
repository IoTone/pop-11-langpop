#!/usr/bin/env python3
# mkpicks.py -- turn the reviewed pool into graph/ja/picks/n3.pl.
#
#     python3 tools/mkpicks.py work 2800 > graph/ja/picks/n3.pl
#
# work/cand.tsv is draft-picks.py's output with the DUPID rows and the
# words no dialogue corpus has dropped; the number is how far down that
# ranking the hand review reached.  graph/ja/picks/n3-rejects.tsv is
# what the review threw out, and tools/n3-header.txt is the header.
#
# The key is the kanji headword where that headword names exactly one
# JMdict entry, and the sequence number where it names more than one --
# import.p refuses an ambiguous key, and rightly, since a key that names
# two entries names neither.
import os, re, sys
import xml.etree.ElementTree as ET
HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
UP   = os.environ.get('LANGPOP_UPSTREAM',
                      os.path.expanduser('~/langpop-upstream'))
WORK  = sys.argv[1] if len(sys.argv) > 1 else '.'
LIMIT = int(sys.argv[2]) if len(sys.argv) > 2 else 2800

kebcount = {}
for ev, el in ET.iterparse(UP + '/JMdict_e', events=('end',)):
    if el.tag == 'entry':
        for k in el.findall('k_ele'):
            kb = k.findtext('keb')
            kebcount[kb] = kebcount.get(kb, 0) + 1
        el.clear()

rejected = {}
for line in open(REPO + '/graph/ja/picks/n3-rejects.tsv',
                 encoding='utf-8'):
    p = line.rstrip('\n').split('\t')
    if len(p) >= 3: rejected[p[0]] = (p[1], p[2])

rows, n = [], 0
for i, line in enumerate(open(WORK + '/cand.tsv', encoding='utf-8'), 1):
    if i > LIMIT: break
    b, f, keb, reading, rid, seq, dup, pos, gl = line.rstrip('\n').split('\t')
    if rid in rejected: continue
    rows.append((rid, keb, reading, seq, gl))

out = sys.stdout
out.write(open(HERE + '/n3-header.txt', encoding='utf-8').read()
          .replace('@COUNT@', str(len(rows)))
          .replace('@REJECTS@', str(len(rejected)))
          .replace('@REVIEWED@', str(LIMIT)))
w = max(len(r[0]) for r in rows)
byseq = 0
for rid, keb, reading, seq, gl in rows:
    if kebcount.get(keb, 0) == 1:
        key = "jmdict_kanji('%s')" % keb
        out.write('pick(%s ja, n3, word, %s).\n' % ((rid + ',').ljust(w + 2), key))
    else:
        byseq += 1
        out.write("pick(%s ja, n3, word, jmdict('%s')).  %% %s %s\n"
                  % ((rid + ',').ljust(w + 2), seq, reading, gl[:48]))
print(len(rows), 'picks,', byseq, 'keyed by sequence number,',
      len(rejected), 'rejected', file=sys.stderr)
