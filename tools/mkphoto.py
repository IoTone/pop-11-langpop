#!/usr/bin/env python3
"""mkphoto.py -- draw a photograph, then find out what is actually in it.

The content tool for langpop's `see` channel: TOEIC Part 1 asks a student
to pick the statement that describes a photograph, and this makes the
photographs and -- the part that matters -- checks the statements against
them.

Standard library plus two external programs: ollama, for both halves, and
ImageMagick (or sips) to resize.

    mkphoto.py draw     --id ph_dog_walk --prompt "A person walking a dog"
    mkphoto.py describe --photo photos/en/ph_dog_walk.jpg
    mkphoto.py check    --photo photos/en/ph_dog_walk.jpg --statements s.json

THE PROMPT IS NOT THE ANSWER KEY.  This is the whole reason the tool
exists, and it was found on the first image ever generated here.  Asked
for "A person walking a dog, realistic photograph", x/z-image-turbo drew
a person walking TWO dogs, one on a leash and one loose.  The picture is
good -- better than the request, even, since two dogs with one leashed is
a richer Part 1 photo than one dog -- but an item written from the prompt
would have keyed "A woman is walking a dog" as correct, and marked the
student who counted wrong.

Part 1's distractors are precisely about number, action and state, so
this is not a tolerable margin of error.  It is the failure mode.  The
prompt is therefore treated as a REQUEST and discarded the moment the
file exists; from then on the image is the only authority on itself.

HOW THE GATE WORKS.  `check` takes the statements a human wrote and puts
each one, alone, to a vision model that has not been told which answer is
wanted and has not seen the prompt.  Statements listed under "true" must
come back true; statements under "false" must come back false.  Any
disagreement is an exit code, not a warning, because a distractor that is
accidentally true of the photo is a question with two right answers and
no way for a student to tell.

IT REJECTS AMBIGUOUS DISTRACTORS TOO, which was not the intention and is
the more useful half.  The first distractor ever put through it --
"A woman is walking a dog", against the two-dog photo -- came back TRUE,
with the reason "the woman is walking multiple dogs, so the statement
that she is walking a dog (at least one) is accurate".  That is correct,
and the distractor was mine.  A Part 1 distractor has to be plainly
false; one that survives on a reading of "at least one" is a second right
answer wearing a disguise.

So a disagreement is not an argument to be settled.  On the office photo
the checker insists, twice running and in different words, that both
women are holding papers, where the second woman's hands look to me like
they are out of frame.  One of us is misreading a 640px jpeg -- and it
does not matter which, because a statement two careful readers cannot
agree on is unfit to be an option whichever way it resolves.  The rule is
drop the statement, never adjudicate it.

WHAT TO TRUST, AND WHAT NOT TO.  `describe` is unconstrained and will
confabulate: it is the mode that produced the hands.  `check` is one
constrained TRUE/FALSE about one statement, and over both photos so far
it has not once been wrong about a count, an absence, or a posture.  So
`describe` is a DRAFTING AID a human reads before writing statements, and
`check` is the gate.  Neither is an oracle about the world; the gate only
ever tests whether a statement is PLAIN.  A human still confirms the
item.  What this removes is the review burden of the loud failures, not
the review.

One statement per call, deliberately.  A model handed four statements and
told one is right will balance them -- it answers the multiple-choice
question instead of looking at the picture, which is the student's job
and not the checker's.  Asked singly, with no indication that any other
statement exists, it has nothing to balance against.

The model is also shown THE DELIVERED FILE, not the master render: a
640px JPEG is what the student will see, and a detail that survives at
1024px lossless and dissolves at 640/q80 is a detail the question must
not turn on.

FORMAT, measured on the dog photo (1024x1024 PNG master, 2,213,706 bytes):

    640px jpeg q70      81,297        640px png8    216,469
    640px webp q80      93,846        640px gif     307,318
    640px jpeg q80     106,141

Palette formats are the WORST here, by a factor of nearly four, which is
the opposite of what one expects from "small web-safe GIF".  GIF and PNG8
win on flat-colour graphics -- diagrams, logos, screenshots -- by
replacing a continuous-tone field with an index.  A photograph IS a
continuous-tone field: quantising it to 256 colours spends bytes encoding
dither noise that JPEG never has to represent at all.  WebP's edge over
JPEG is real but small, and not worth asking every future client to
decode a third format for.

So: JPEG, 640px, q80, about 100 KB.  That is under the 2 MB the fetch
methods will send, with room for a photo that compresses worse than this
one, and it leaves the quality margin wide enough that the checker is
reading the same picture the student gets.
"""

import argparse
import base64
import json
import os
import shutil
import subprocess
import sys
import time
import urllib.request

OLLAMA = os.environ.get('OLLAMA_HOST', 'http://localhost:11434')
DRAW_MODEL = os.environ.get('LANGPOP_DRAW_MODEL', 'x/z-image-turbo')
SEE_MODEL = os.environ.get('LANGPOP_SEE_MODEL', 'qwen3-vl:8b')
EDGE = 640
QUALITY = 80


def ollama(payload, timeout=900):
    req = urllib.request.Request(
        OLLAMA + '/api/generate',
        json.dumps(payload).encode(),
        {'Content-Type': 'application/json'})
    with urllib.request.urlopen(req, timeout=timeout) as f:
        return json.load(f)['response']


def ask_about(photo, prompt, timeout=900):
    """Put one question to the vision model about one image."""
    with open(photo, 'rb') as f:
        img = base64.b64encode(f.read()).decode()
    return ollama({'model': SEE_MODEL, 'prompt': prompt, 'images': [img],
                   'stream': False, 'think': False}, timeout).strip()


def resize(src, dst):
    """To the delivered size and format.  ImageMagick, or sips on a Mac."""
    if shutil.which('magick'):
        cmd = ['magick', src, '-resize', '%dx%d' % (EDGE, EDGE),
               '-quality', str(QUALITY), dst]
    elif shutil.which('sips'):
        cmd = ['sips', '-Z', str(EDGE), '-s', 'format', 'jpeg',
               '-s', 'formatOptions', str(QUALITY), src, '--out', dst]
    else:
        sys.exit('mkphoto: need ImageMagick (magick) or sips to resize')
    subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL)


def cmd_draw(args):
    """Request an image.  What comes back is then an open question."""
    out = os.path.abspath(args.out)
    os.makedirs(os.path.dirname(out) or '.', exist_ok=True)
    scratch = out + '.master.png'

    t = time.time()
    # The image model answers on /api/generate like any other, and writes
    # its PNG where ollama is run, so it is run somewhere disposable.
    work = os.path.dirname(scratch)
    before = set(os.listdir(work))
    subprocess.run(['ollama', 'run', DRAW_MODEL, args.prompt],
                   cwd=work, check=True,
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    made = [f for f in os.listdir(work)
            if f not in before and f.lower().endswith('.png')]
    if len(made) != 1:
        sys.exit('mkphoto: expected one new png, got %r' % (made,))
    os.replace(os.path.join(work, made[0]), scratch)
    drew = time.time() - t

    resize(scratch, out)
    if not args.keep_master:
        os.remove(scratch)

    print(json.dumps({'id': args.id, 'photo': out,
                      'bytes': os.path.getsize(out),
                      'requested': args.prompt,
                      'drew_seconds': round(drew, 1),
                      'model': DRAW_MODEL}, indent=2))


DESCRIBE = ("Describe exactly what is visible in this photograph. "
            "State how many people and how many animals there are, what "
            "each one is doing, and what objects are present. Be literal "
            "and specific. Do not speculate about anything you cannot see.")


def cmd_describe(args):
    """What the picture actually shows -- the source for the statements."""
    print(ask_about(args.photo, DESCRIBE))


# No mention that this is one of several, and no hint which way to lean.
VERDICT = ("Look at this photograph. Is the following statement a true "
           "description of it?\n\nStatement: %s\n\nAnswer with exactly one "
           "word, TRUE or FALSE, then on a second line give your reason in "
           "one short sentence.")


def verdict(photo, statement):
    raw = ask_about(photo, VERDICT % statement)
    head = raw.split('\n', 1)
    word = head[0].strip().strip('*.').upper()
    why = head[1].strip() if len(head) > 1 else ''
    if word.startswith('TRUE'):
        return True, why
    if word.startswith('FALSE'):
        return False, why
    return None, raw


def cmd_check(args):
    """The gate.  Every statement, true and false, against the image."""
    with open(args.statements) as f:
        spec = json.load(f)
    photo = args.photo or spec['photo']

    bad = 0
    for want, key in ((True, 'true'), (False, 'false')):
        for s in spec.get(key, []):
            got, why = verdict(photo, s)
            ok = got is want
            if not ok:
                bad += 1
            print('%-5s want=%-5s got=%-5s  %s' %
                  ('ok' if ok else 'WRONG', want, got, s))
            if not ok:
                print('        the model says: %s' % why)

    print('\n%s: %d statement(s) disagree with the photograph'
          % (spec.get('id', photo), bad) if bad else
          '\n%s: every statement agrees with the photograph'
          % spec.get('id', photo))
    return 1 if bad else 0


def main():
    p = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    sub = p.add_subparsers(dest='cmd', required=True)

    d = sub.add_parser('draw', help='request a photograph')
    d.add_argument('--id', required=True)
    d.add_argument('--prompt', required=True)
    d.add_argument('--out', required=True, help='the delivered jpeg')
    d.add_argument('--keep-master', action='store_true',
                   help='keep the 1024px png beside it')

    s = sub.add_parser('describe', help='say what is in a photograph')
    s.add_argument('--photo', required=True)

    c = sub.add_parser('check', help='test statements against a photograph')
    c.add_argument('--statements', required=True)
    c.add_argument('--photo')

    args = p.parse_args()
    sys.exit({'draw': cmd_draw, 'describe': cmd_describe,
              'check': cmd_check}[args.cmd](args) or 0)


if __name__ == '__main__':
    main()
