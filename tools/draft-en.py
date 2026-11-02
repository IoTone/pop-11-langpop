#!/usr/bin/env python3
# draft-en.py -- the English candidate pool for a rung, ranked, as TSV.
#
#     ./langpop dump --lang en > work/en-dump.json
#     python3 tools/draft-en.py work
#
# reads work/en-dump.json and ~/langpop-upstream/en_50k.txt and writes
# work/en-cand.tsv: one candidate a line, most frequent first, as
#
#     rank  occurrences  word  why-it-might-not-be-a-word
#
# The last column is empty for a clean candidate and otherwise names the
# doubt, so that a curator reads the pool with the mechanical suspicions
# already attached rather than having to spot them.
#
# WHAT THIS IS NOT.  Not the word list.  graph/en/a1.pl and a2.pl are
# written by hand because the JAPANESE GLOSS is ours -- no licence
# reaches it, and no bilingual dictionary is read the wrong way round to
# make it (see a1.pl's header).  This only decides what to read.
#
# THE THREE DISEASES OF A FREQUENCY LIST, which the Japanese rungs met
# first and which are the same here in a third dialect:
#
#   its tokenizer       don, hasn, didn, isn, ve, ll, re -- halves of
#                       contractions, and `bleep` and `groaning`, which
#                       are subtitle stage directions
#   its proper nouns    michael, george, europe, smith
#   its own register    OpenSubtitles is film and television, so
#                       murderer, evidence, kidding, goodbye
#
# and one that is English's own:
#
#   its inflections     works, needed, watching, trees, doctors -- the
#                       list counts surface forms and the graph teaches
#                       lemmas, so a plural of a word already taught is
#                       not a new word.  This is the same defect that
#                       made the N3 Japanese pool need a stem rule.
import json, os, re, sys

WORK = sys.argv[1] if len(sys.argv) > 1 else '.'
UP   = os.environ.get('LANGPOP_UPSTREAM',
                      os.path.expanduser('~/langpop-upstream'))

raw  = open(WORK + '/en-dump.json', encoding='utf-8').read()
dump = json.loads(raw[raw.index('{'):])
have = set()
for it in dump['items']:
    if it.get('label'): have.add(str(it['label']).lower())
    for v in (it.get('forms') or {}).values():
        have.add(str(v).lower())

# A halved contraction, an interjection the corpus spells out, or a
# stage direction.  Named rather than guessed: every one of these is in
# the top 1,500 of en_50k.
FRAGMENT = {'don', 'doesn', 'didn', 'isn', 'aren', 'wasn', 'weren',
            'hasn', 'haven', 'hadn', 'won', 'wouldn', 'couldn',
            'shouldn', 'can', 'cannot', 'ain', 'ya', 'gonna', 'gotta',
            'wanna', 'kinda', 'lemme', 'gimme', 'll', 've', 're', 'em',
            'ta', 'da', 'oh', 'ah', 'eh', 'uh', 'huh', 'hmm', 'mm',
            'ooh', 'aah', 'ugh', 'hey', 'yeah', 'yep', 'nope', 'okay',
            'ok', 'wow', 'oops', 'shh', 'bleep', 'groaning', 'sighs',
            'laughs', 'chuckles', 'grunts', 'gasps', 'whispering'}

# ENGLISH'S IRREGULARS, which no suffix rule reaches.  Without this the
# clean half of the pool opens with been, were, got, going, made,
# thought, does, doing, done, has, had -- eleven rows that are the verbs
# a learner met at A1, and him, her and his, which are he and she.
#
# The table is the forms, not the paradigm: what is wanted is "is this a
# form of a word already taught", and the lemma beside it is only there
# so the column can say which.
IRREGULAR = {
    'am': 'be', 'is': 'be', 'are': 'be', 'was': 'be', 'were': 'be',
    'been': 'be', 'being': 'be',
    'has': 'have', 'had': 'have', 'having': 'have',
    'does': 'do', 'did': 'do', 'doing': 'do', 'done': 'do',
    'goes': 'go', 'went': 'go', 'gone': 'go', 'going': 'go',
    'gets': 'get', 'got': 'get', 'gotten': 'get', 'getting': 'get',
    'makes': 'make', 'made': 'make', 'making': 'make',
    'thinks': 'think', 'thought': 'think', 'thinking': 'think',
    'says': 'say', 'said': 'say', 'saying': 'say',
    'comes': 'come', 'came': 'come', 'coming': 'come',
    'takes': 'take', 'took': 'take', 'taken': 'take', 'taking': 'take',
    'sees': 'see', 'saw': 'see', 'seen': 'see', 'seeing': 'see',
    'knows': 'know', 'knew': 'know', 'known': 'know',
    'gives': 'give', 'gave': 'give', 'given': 'give', 'giving': 'give',
    'finds': 'find', 'found': 'find', 'finding': 'find',
    'tells': 'tell', 'told': 'tell', 'telling': 'tell',
    'feels': 'feel', 'felt': 'feel', 'feeling': 'feel',
    'leaves': 'leave', 'left': 'leave', 'leaving': 'leave',
    'puts': 'put', 'putting': 'put',
    'means': 'mean', 'meant': 'mean', 'meaning': 'mean',
    'keeps': 'keep', 'kept': 'keep', 'keeping': 'keep',
    'lets': 'let', 'letting': 'let',
    'begins': 'begin', 'began': 'begin', 'begun': 'begin',
    'brings': 'bring', 'brought': 'bring',
    'buys': 'buy', 'bought': 'buy', 'buying': 'buy',
    'eats': 'eat', 'ate': 'eat', 'eaten': 'eat', 'eating': 'eat',
    'drinks': 'drink', 'drank': 'drink', 'drunk': 'drink',
    'runs': 'run', 'ran': 'run', 'running': 'run',
    'writes': 'write', 'wrote': 'write', 'written': 'write',
    'reads': 'read', 'reading': 'read',
    'speaks': 'speak', 'spoke': 'speak', 'spoken': 'speak',
    'stands': 'stand', 'stood': 'stand', 'standing': 'stand',
    'sits': 'sit', 'sat': 'sit', 'sitting': 'sit',
    'sleeps': 'sleep', 'slept': 'sleep', 'sleeping': 'sleep',
    'meets': 'meet', 'met': 'meet', 'meeting': 'meet',
    'pays': 'pay', 'paid': 'pay', 'paying': 'pay',
    'sends': 'send', 'sent': 'send', 'sending': 'send',
    'wears': 'wear', 'wore': 'wear', 'worn': 'wear',
    'wins': 'win', 'won': 'win', 'winning': 'win',
    'loses': 'lose', 'lost': 'lose', 'losing': 'lose',
    'teaches': 'teach', 'taught': 'teach',
    'understands': 'understand', 'understood': 'understand',
    'children': 'child', 'people': 'person', 'men': 'man',
    'women': 'woman', 'feet': 'foot', 'teeth': 'tooth',
    'mice': 'mouse', 'lives': 'life', 'knives': 'knife',
    'wives': 'wife', 'leaves': 'leaf',
    # he, she and they, which are the same question one part of speech
    # over: a case form of a pronoun already taught is not a new word.
    'him': 'he', 'his': 'he', 'himself': 'he',
    'her': 'she', 'hers': 'she', 'herself': 'she',
    'them': 'they', 'their': 'they', 'theirs': 'they',
    'themselves': 'they', 'us': 'we', 'our': 'we', 'ours': 'we',
    'me': 'i', 'my': 'i', 'mine': 'i', 'myself': 'i',
    'your': 'you', 'yours': 'you', 'yourself': 'you',
    'its': 'it', 'itself': 'it',
}


# Could this be a form of something the graph already teaches?  Crude on
# purpose: it suggests, and the column says so, because `building` is a
# word in its own right and `works` is not.
def inflection_of(w):
    if w in IRREGULAR and IRREGULAR[w] in have:
        return IRREGULAR[w]
    for stem in (
            w[:-1],                       # trees   -> tree
            w[:-2],                       # watches -> watch
            w[:-1] + 'e',                 # smiles  -> smile (via -s)
            w[:-3],                       # needed  -> need
            w[:-3] + 'e',                 # decided -> decide
            w[:-4],                       # watching-> watch
            w[:-4] + 'e',                 # writing -> write
            w[:-2] + 'y',                 # studies -> study
            w[:-3] + 'y',                 # studied -> study
            w[:-2],                       # bigger  -> big
            w[:-1] * 1 if False else w,   # (placeholder, never hit)
    ):
        if len(stem) >= 3 and stem != w and stem in have:
            return stem
    return None

rows = []
for rank, line in enumerate(open(UP + '/en_50k.txt', encoding='utf-8'), 1):
    parts = line.split()
    if len(parts) != 2:
        continue
    w, n = parts[0], int(parts[1])
    if not re.fullmatch(r"[a-z][a-z'-]+", w) or len(w) < 3:
        continue
    if w in have:
        continue
    why = ''
    if "'" in w:
        why = 'apostrophe'
    elif w in FRAGMENT:
        why = 'fragment'
    else:
        stem = inflection_of(w)
        if stem:
            why = 'inflection? ' + stem
    rows.append((rank, n, w, why))

with open(WORK + '/en-cand.tsv', 'w', encoding='utf-8') as out:
    for rank, n, w, why in rows:
        out.write('%d\t%d\t%s\t%s\n' % (rank, n, w, why))
clean = sum(1 for r in rows if not r[3])
print('%d candidates, %d of them with no mechanical doubt'
      % (len(rows), clean), file=sys.stderr)
