#!/usr/bin/env python3
"""score-morae.py -- did the geminate get its beat?

The verdict command for langpop's `speak` channel, Stage 1 of
docs/langpop-audio.md.  Reads a JSON request, writes a JSON
verdict, and uses the Python standard library and nothing else:

    score-morae.py --request req.json --out verdict.json

WHAT IT MEASURES, AND WHAT IT DOES NOT.  The plan this implements said
"beat boundaries, a duration per mora, a comparison against a count the
graph already computes".  The first half of that is wrong, and measuring
it is how we found out: an energy envelope finds VOICED RUNS, not beats.
がっこう comes back as two runs -- が, then っこう -- because こ and う are
one continuous voiced stretch with nothing between them to detect.  No
amount of threshold tuning produces four.

What the envelope does see is SILENCE, and one Japanese mora is made of
silence: the geminate っ is a held closure.  So this scores the question
`mora_sokuon` asks -- is the beat there? -- and declines the rest.

Measured over 188 words from one TTS voice, with the engine's own
lp_morae/1 for ground truth:

    geminate stops (っk, っt, っp)   6 of 6   gap/mora 1.33 - 1.55
    geminate fricative (っし)        1        gap/mora 0.00
    no geminate                    181       gap/mora 0.00 - 0.90

The measure is the ratio of the longest internal silence to the word's
mean mora length, so it is normalised by the speaker's own rate and
needs no calibration utterance.

TWO EDGES, NOT ONE THRESHOLD, and the reason is that the 181 words above
are REAL words.  A learner who drops the beat is not saying another real
word -- they are saying きぷ for きっぷ -- and a voice rendering that
degeminated form puts its own transition where the beat was.  Scored over
the sixteen held-beat words of `--voicetest`, those renders run:

    the beat as written     16     gap/mora 0.99 - 1.56
    the beat dropped        16     gap/mora 0.00 - 1.27

which OVERLAP, so no single threshold separates them.  しゅっぱつ holds its
beat for 170ms against a 172ms mora -- phonetically right, ratio 0.99 --
because its other morae are long; きぷ, two morae of 63ms each, shows an
ordinary 80ms transition as 1.27 of a mora, because deleting a mora
shortens the word and shrinks the denominator.

So the band between the edges is declined rather than guessed:

    ratio >= CREDIT_RATIO   the beat is there
    ratio <  REFUSE_RATIO   the beat is missing
    between                 `near`, which moves nothing

1.30 and 0.95 are set OUTSIDE both measured populations: every dropped
beat observed falls below 1.30 and every credited one at or above 1.31.
A single 1.1 with a symmetric 15% band gave the same verdicts on this
set, but put きぷ at 1.27 within a rounding error of the top edge -- and
one millisecond the other way is a dropped beat CREDITED, which is the
one outcome this scorer must never produce.

っ BEFORE A FRICATIVE IS NOT A SILENCE.  いっしょ is [iʃːo]: the mora is
a lengthened [ʃ], which has energy all the way through.  The gap is
0ms and no threshold will find it, which is a fact about Japanese and
not a defect here.  The engine knows the following kana, so it declines
to ask rather than asking and abstaining -- but if one arrives anyway
the verdict is `near`, which in langpop's tier 5 means `I could not
tell` and moves the belief in neither direction.
"""
import argparse
import array
import json
import sys
import wave

FRAME_MS = 10
FLOOR_FRAC = 0.12          # of the peak; below this is silence
CREDIT_RATIO = 1.30        # at or above: the held beat is there
REFUSE_RATIO = 0.95        # below: it is missing
MIN_VOICE_MS = 80          # shorter than this is not an utterance


def envelope(path, frame_ms=FRAME_MS):
    """RMS per frame, plus the frame size actually used."""
    with wave.open(path, 'rb') as w:
        if w.getsampwidth() != 2:
            raise ValueError('want 16-bit PCM, got %d bytes' % w.getsampwidth())
        rate, frames, channels = w.getframerate(), w.getnframes(), w.getnchannels()
        raw = array.array('h', w.readframes(frames))
    if channels > 1:
        raw = array.array('h', raw[0::channels])
    step = max(1, (rate * frame_ms) // 1000)
    env = []
    for i in range(0, max(0, len(raw) - step), step):
        acc = 0
        for sample in raw[i:i + step]:
            acc += sample * sample
        env.append((acc / step) ** 0.5)
    return env, frame_ms


def measure(path):
    """Total voiced span, the gaps inside it, in milliseconds."""
    env, frame_ms = envelope(path)
    if not env:
        return 0, []
    peak = max(env)
    if peak <= 0:
        return 0, []
    floor = peak * FLOOR_FRAC
    voiced = [i for i, v in enumerate(env) if v >= floor]
    if not voiced:
        return 0, []
    first, last = voiced[0], voiced[-1]
    total = (last - first + 1) * frame_ms
    gaps, run = [], 0
    for i in range(first, last + 1):
        if env[i] < floor:
            run += 1
        elif run:
            gaps.append(run * frame_ms)
            run = 0
    if run:
        gaps.append(run * frame_ms)
    return total, gaps


def score(sample, morae, detectable):
    """(outcome, confidence, detail) for one recording."""
    total, gaps = measure(sample)
    if total < MIN_VOICE_MS:
        return 'near', 0.0, 'I could not hear anything to measure.'
    if not morae or morae < 2:
        return 'near', 0.0, 'Nothing to time in a single beat.'
    if not detectable:
        return ('near', 0.0,
                'That one holds a fricative rather than a silence, '
                'so I cannot time it.')
    mora_ms = total / morae
    longest = max(gaps) if gaps else 0
    ratio = longest / mora_ms
    outcome, confidence = verdict(ratio)
    if outcome == 'right':
        return (outcome, confidence,
                'The held beat is there: %d ms of silence against a %d ms '
                'mora.' % (longest, round(mora_ms)))
    if outcome == 'wrong':
        return (outcome, confidence,
                'The held beat is missing or too short: %d ms of silence '
                'where it wants about %d ms.' % (longest, round(mora_ms)))
    return (outcome, confidence,
            'That was borderline -- %d ms of silence where a beat is '
            'about %d ms.' % (longest, round(mora_ms)))


def verdict(ratio):
    """(outcome, confidence) for one gap-to-mora ratio.

    Separate from score so that the edges can be tested without a wav
    file: --selftest below puts every ratio measured by --voicetest
    through it, which is the only regression test the bands have.
    """
    # Confidence is distance from the edge, not a probability: it is
    # there so the engine can refuse a verdict it should not act on.
    if ratio >= CREDIT_RATIO:
        return 'right', min(1.0, (ratio - CREDIT_RATIO) / CREDIT_RATIO)
    if ratio < REFUSE_RATIO:
        return 'wrong', min(1.0, (REFUSE_RATIO - ratio) / REFUSE_RATIO)
    return 'near', 0.0


# Every ratio --voicetest measured from Kyoko at the normal rate, as
# (word, ratio).  HELD is the word said correctly and DROPPED is the
# same word with the beat deleted, which is what a learner does.
HELD = [
    ('gakkou', 1.48), ('kitte', 1.54), ('chotto', 1.36), ('yukkuri', 1.56),
    ('ippai', 1.44), ('motto', 1.33), ('kippu', 1.55), ('nattou', 1.52),
    ('koppu', 1.45), ('poketto', 1.36), ('asatte', 1.34), ('shuppatsu', 0.99),
    ('sekken', 1.33), ('beddo', 1.31), ('sakkaa', 1.24), ('kekkon', 1.50),
]
DROPPED = [
    ('gakou', 1.04), ('kite', 0.00), ('choto', 1.00), ('yukuri', 0.87),
    ('ipai', 0.82), ('moto', 1.13), ('kipu', 1.27), ('natou', 0.76),
    ('kopu', 1.13), ('poketo', 0.87), ('asate', 0.83), ('shupatsu', 0.74),
    ('seken', 0.69), ('bedo', 0.36), ('sakaa', 0.92), ('kekon', 0.89),
]


def selftest():
    """The two outcomes that must never happen, over measured ratios."""
    bad = []
    for word, ratio in DROPPED:
        if verdict(ratio)[0] == 'right':
            bad.append('%s at %.2f was CREDITED a beat it does not have'
                       % (word, ratio))
    for word, ratio in HELD:
        if verdict(ratio)[0] == 'wrong':
            bad.append('%s at %.2f was marked WRONG with the beat there'
                       % (word, ratio))
    credited = sum(1 for _, r in HELD if verdict(r)[0] == 'right')
    if credited * 2 < len(HELD):
        bad.append('only %d of %d held beats credited: safe and useless'
                   % (credited, len(HELD)))
    # The margin is the point of two edges rather than one threshold: the
    # highest dropped ratio must not sit within rounding of the top edge,
    # which is where a single 1.1 with a symmetric band had left it.
    worst = max(r for _, r in DROPPED)
    if CREDIT_RATIO - worst < 0.02:
        bad.append('the highest dropped ratio %.2f is within %.3f of the '
                   'credit edge %.2f' % (worst, CREDIT_RATIO - worst,
                                         CREDIT_RATIO))
    for line in bad:
        print('score-morae selftest: %s' % line)
    print('score-morae selftest: %d checks, %s'
          % (len(HELD) + len(DROPPED) + 2,
             'ALL PASS' if not bad else '%d FAILED' % len(bad)))
    return 0 if not bad else 1


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--request')
    ap.add_argument('--out')
    ap.add_argument('--selftest', action='store_true')
    args = ap.parse_args()
    if args.selftest:
        return selftest()
    if not args.request or not args.out:
        ap.error('--request and --out are required')
    with open(args.request, encoding='utf-8') as fh:
        req = json.load(fh)
    try:
        # 'no' and not False: a JSON false is dropped by some generators
        # -- langpop's own among them -- so the request carries the fact
        # positively and anything that is not an explicit 'no' is taken
        # as measurable.
        outcome, confidence, detail = score(
            req['sample'], req.get('expect'),
            str(req.get('detectable', 'yes')).lower() != 'no')
    except Exception as exc:                      # noqa: BLE001
        # A scorer that raises is a tutor that crashes mid-question, so
        # every failure becomes the verdict that means "I could not tell".
        outcome, confidence, detail = 'near', 0.0, 'I could not read that: %s' % exc
    result = {'outcome': outcome, 'confidence': round(confidence, 3),
              'detail': detail, 'task': req.get('task'),
              'item': req.get('item')}
    with open(args.out, 'w', encoding='utf-8') as fh:
        json.dump(result, fh, ensure_ascii=False)
        fh.write('\n')


if __name__ == '__main__':
    sys.exit(main() or 0)
