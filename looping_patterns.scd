(
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
// sample reader
SynthDef(\oneLoop, { |out, bufnum, start, time, amp|
    var    sig = PlayBuf.ar(1, bufnum, startPos: start, loop: 0),
        env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp), doneAction: 2);
    Out.ar(out, (sig * env) ! 2)
}).add;
~huhubuf = Buffer.read(s, "/home/hellska/soundAndSamples/samples/loops/ueaaaauaueua.wav");
)


~looplength = ~huhubuf.numFrames / ~huhubuf.sampleRate;
~looptempo = ~looplength / 2;
~loops.do{|me| me.path.postln };
~huhubuf.play;

~huhubuf = Buffer.read(s, "/home/hellska/soundAndSamples/samples/loops/ueaaaauaueua.wav");
~looplength = ~huhubuf.numFrames / ~huhubuf.sampleRate;
~looplength.postln
~looptempo = ~looplength;

TempoClock.default.beats
TempoClock.default.tempo

TempoClock.default.tempo = 60/~looplength;
TempoClock.default.tempo = 2.59;
TempoClock.default.tempo = 4;
TempoClock.default.tempo = 0.9;
TempoClock.default.tempo = 0.02;
TempoClock.default.tempo = 1;
TempoClock.default.tempo = ~looplength;
// non alterabile ... una volta avviato
(
~pattern1 = Pbind(\instrument, \oneLoop,
	\bufnum, ~huhubuf,
	\amp, 0.4,
	\start, 0,
	\time, ~looplength,
	\dur, ~looptempo).play;
)
~pattern1.play;
~pattern1.stop;
(
~pattern1.stream = Pbind(\instrument, \oneLoop,
	\bufnum, ~huhubuf,
	\amp, 0.4,
	\start, 0,
	\time, ~looplength,
	\dur, ~looptempo).asStream;
)

(
~smashbro = Ptpar([
	0, Pbind(\instrument, \oneLoop,
		\bufnum, ~huhubuf,
		\amp, 0.4,
		\start, 0,
		\time, ~looplength,
		\dur, ~looptempo),
	0, Pn(
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
], 1).play
)

(
~adding = Pbind(
		\instrument, \bell,
		\accent, Pseq([2, Pn(0, inf)], 1),
		\amp, Pseq([0.01, Pn(0.04, inf)], 1),
		\decayScale, Pseq([6, Pn(1, inf)], 1),
		\dur, 4 /16
	).play
)

(
~startseq = Pseq([
	0*~huhubuf.numFrames,
	0.3*~huhubuf.numFrames,
	0.5*~huhubuf.numFrames,
	0.1*~huhubuf.numFrames,
	0.134*~huhubuf.numFrames,
	0.9*~huhubuf.numFrames,
	0.32*~huhubuf.numFrames,
	0.76*~huhubuf.numFrames,
	0*~huhubuf.numFrames,
	0.63*~huhubuf.numFrames,
	0.57*~huhubuf.numFrames,
	0.13*~huhubuf.numFrames,
	0.134*~huhubuf.numFrames,
	0.09*~huhubuf.numFrames,
	0.33333*~huhubuf.numFrames,
	0.85*~huhubuf.numFrames
], inf);
)

(
~pattern1 = Pbind(\instrument, \oneLoop,
	\bufnum, ~huhubuf,
	\amp, 0.4,
	\start, ~startseq,
	\time, Prand([0.1, 0,13, 0.15, 0.18], inf),
	\dur, 4/32).play;
)

~pattern1.stop;
~huhubuf.numFrames;
~adding.stop;
~adding.play;

(
~smashbro = Ptpar([
	0, Pbind(\instrument, \oneLoop,
		\bufnum, ~huhubuf,
		\amp, 0.4,
		\start, 0,
		\time, ~looplength,
		\dur, ~looplength),
	0, Pn(
		Pfindur(4,
			Pbind(
				\instrument, \bell,
				\dur, ~looplength / 14 )
		),

		inf),
], 1).play
)
~looplength
Pn(	Pfindur(~looplength * 2, Pbind(\instrument, \bell, \dur, ~looplength / 14 )), 1).play;
(
Pn( Pfindur(~looplength, Pbind(\instrument, \oneLoop,
	\bufnum, ~huhubuf,
	\amp, 0.4,
	\start, 2345,
	\time, ~looplength / 12,
	\dur, ~looplength / 12)), 1).play
)

~lenghtList = Array.geom(12, ~looplength / 12, ~looplength)
Pseq

(
Pn( Pfindur(~looplength, Pbind(\instrument, \oneLoop,
	\bufnum, ~huhubuf,
	\amp, 0.4,
	\start, 0,
	\time, Pseq(~lenghtList),
	\dur, ~looplength / 12)), 4).play
)

~huhubuf.numFrames
~starList = Array.interpolation(12, 0, ~huhubuf.numFrames - (~huhubuf.numFrames/12));


//// Finally ueeaaauuueeeoaoao
TempoClock.default.tempo = 1;
(
Pn( Pfindur(~looplength, Pbind(\instrument, \oneLoop,
	\bufnum, ~huhubuf,
	\amp, 0.4,
	\start, Pseq(~starList),
	\time, 0.2,
	\dur, ~looplength / 12)), inf).play
)
(
Pn( Pfindur(~looplength, Pbind(\instrument, \oneLoop,
	\bufnum, ~huhubuf,
	\amp, 0.4,
	\start, Prand(~starList),
	\time, 0.2,
	\dur, ~looplength / 12)), inf).play
)

Prand

~tempList = ~starList.scramble;
~tempList = ~starList
(
~myPattern = Pn( Pfindur(~looplength, Pbind(\instrument, \oneLoop,
	\bufnum, ~huhubuf,
	\amp, 0.4,
	\start, ~startListProxy,
	\time, ~timeProxy,
	\dur, ~looplength / 12)), inf).play
)
~myPattern.stop;
~myPattern.start;


// set pattern values
~timeProxy = PatternProxy(0.4);
~startListProxy = PatternProxy(Pseq(~tempList, 1));
~accentProxy = PatternProxy(Pseq([24, 12, 0], inf));
// change values on the fly
~startListProxy.source = Pseq(~tempList, 1);
~timeProxy.source = 0.6;


(
~myPattern = Ptpar([
	0, Pn( Pfindur(~looplength, Pbind(\instrument, \oneLoop,
	\bufnum, ~buffProxy,
	\amp, 0.2,
	\start, ~startListProxy,
	\time, ~timeProxy,
	\dur, ~looplengthProxy / 12)), 3),
	0, Pn( Pfindur(~looplength, Pbind( \instrument, \bell,
		\accent, ~accentProxy,
		\amp, Prand([0, 0.09, 0.09], inf),
		\dur, ~looplengthProxy / 12 )), 4)
], inf).play
)

(
~setPatternValues = {
	~huhubuf = Buffer.read(s, "/home/hellska/soundAndSamples/samples/loops/ueaaaauaueua.wav");
	~looplength = ~huhubuf.numFrames / ~huhubuf.sampleRate;
	~starList = Array.interpolation(12, 0, ~huhubuf.numFrames - (~huhubuf.numFrames/12));
	~tempList = ~starList; // used in order to sramble startlist values
	// set pattern values
	~buffProxy = PatternProxy(~huhubuf);
	~timeProxy = PatternProxy(0.4);
	~startListProxy = PatternProxy(Pseq(~tempList, inf));
	~accentProxy = PatternProxy(Pseq([24, 12, 0], inf));
};
~resetPatternValues = {|buf, time, startlist, acccentlist|
	~looplength = ~huhubuf.numFrames / ~huhubuf.sampleRate;
	~starList = Array.interpolation(12, 0, ~huhubuf.numFrames - (~huhubuf.numFrames/12));
	~tempList = ~starList; // used in order to sramble startlist values
	// set pattern values
	~buffProxy.source = ~huhubuf;
	~timeProxy.source = 0.4;
	~startListProxy.source = Pseq(~tempList, inf);
	~accentProxy.source = Pseq([24, 12, 0], inf);
};
)
~looplengthProxy = PatternProxy(~looplength);
~resetPatternValues.value();
~looplengthProxy.source = ~looplength;

~huhubuf = Buffer.read(s, "/home/hellska/soundAndSamples/samples/loops/ueaaaauaueua.wav");
// every time you change buffer to sync to the new sound
~setPatternValues.value();

~myPattern.start;
~myPattern.stop;
~huhubuf = Buffer.read(s, "/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/92_viti02.wav".standardizePath);
~huhubuf = Buffer.read(s, "/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/97_viti07.wav")
~huhubuf = Buffer.read(s, "/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/8_barrel04.wav".standardizePath);
~huhubuf = Buffer.read(s, "/home/hellska/soundAndSamples/samples/loops/ueaaaauaueua.wav");
~huhubuf = Buffer.read(s, "/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/90_tappo_cisterna.wav");
~buffProxy.source = ~huhubuf;

~huhubuf = Buffer.read(s, "/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/96_viti06.wav");

(
~myPattern = Ptpar([
	0, Pn( Pfindur(~looplength, Pbind(\instrument, \oneLoop,
		\bufnum, ~buffProxy,
		\amp, 0.2,
		\start, ~startListProxy,
		\time, ~timeProxy,
		\dur, ~looplengthProxy / 12)), 3)], inf).play;
)
~myPattern.stop;

// sync two separate Pbind

Quant

(
~basePat = Pn( Pfindur(~looplength, Pbind(\instrument, \oneLoop,
	\bufnum, ~buffProxy,
	\amp, 0.2,
	\start, ~startListProxy,
	\time, ~timeProxy,
	\dur, ~looplength / 12)), 4);
)
(
~layer2pat = Pn( Pfindur(~looplength, Pbind( \instrument, \oneLoop,
	\bufnum, ~buffProxy,
	\amp, Pseq([0.1, 0.2, 0.1, 0], inf),
	\start, 23465,
	\time, ~timeProxy,
	\dur, ~looplength / 12 )), 4);
)

~tempo = TempoClock.default;
~quant = 1; // whole beat

(
~time = ~quant.nextTimeOnGrid(~tempo);
~my1pat = ~basePat.play(quant: ~quant);
)
(
~time2 = (~tempo.beats - ~time).roundUp(~looplength) + ~time;
~my2pat = ~layer2pat.play(quant: ~time2 - ~tempo.baseBarBeat);
)
~tempo.baseBarBeat

// routine to set vriables
(
~tempo = TempoClock.default;
~quant = 1; // whole beat
)
(
~delayedFunc.reset;
~time = ~quant.nextTimeOnGrid(~tempo).postln;
~delayedFunc.play(quant: ~time + 3);
)