(
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

// one loop segment
SynthDef(\oneLoop, { |out, bufnum, start, time, amp|
    var    sig = PlayBuf.ar(1, bufnum, startPos: start, loop: 0),
        env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp), doneAction: 2);
    Out.ar(out, (sig * env) ! 2)
}).add;

SynthDef(\bell, { |out, accent = 0, amp = 0.1, decayScale = 1|
    var    exc = PinkNoise.ar(amp)
            * Decay2.kr(Impulse.kr(0), 0.01, 0.05),
        sig = Klank.ar(`[
            { ExpRand(400, 1600) } ! 4,
            1 ! 4,
            { ExpRand(0.1, 0.4) } ! 4
        ], exc, freqscale: accent + 1, decayscale: decayScale);
    DetectSilence.ar(sig, doneAction: 2);
    Out.ar(out, sig ! 2)
}).add;
)

(
TempoClock.default.tempo = 0.35953685899971 * 6;

p = Ptpar([
    0, Pbind(
        \instrument, \oneLoop,
        \bufnum, b,
        \amp, 0.4,
        \start, 17841,
        \time, 0.35953685899971.reciprocal,
        \dur, 4
    ),
    0.5, Pn(
        Pfindur(4,
            Pbind(
                \instrument, \bell,
                \accent, Pseq([2, Pn(0, inf)], 1),
                \amp, Pseq([0.3, Pn(0.1, inf)], 1),
                \decayScale, Pseq([6, Pn(1, inf)], 1),
                \dur, Pwrand(#[0.25, 0.5, 0.75, 1], #[2, 3, 1, 1].normalizeSum, inf)
            )
        ),
    inf),
    0.5, Pbind(
        \instrument, \bell,
        \accent, -0.6,
        \amp, 0.2,
        \decayScale, 0.1,
        \dur, 1
    )
], 1).play;
)

p.stop;
p.start;