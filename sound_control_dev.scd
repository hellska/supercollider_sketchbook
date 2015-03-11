
(
SynthDef.new(\greenGlitch, {
	|out = 0,
	dur = 15
	tnoisefreq = 0.3,
	tnoisemul = 100,
	tnoiseadd = 3500,
	tduskdens = 250,
	tsinfreq = 9, // preferred range 0.01 - 10
	amp = 0.3,
	numharm = 200,
	hpfreq = 1200, // range 1200-3000
	posstart = 0,
	revmix = 0.33,
	revroom = 0.5,
	revHFdamp = 0,
	buffer|
	var source, sourcerate, filter, pan, rev, env, envshape, chanFFT;
	envshape = Env.sine(dur:dur);
	env = EnvGen.ar(envshape,doneAction:2);

	sourcerate = LFNoise2.kr(freq:tnoisefreq,mul:tnoisemul,add:tnoiseadd) *
	Dust.kr(density:tduskdens) *
	SinOsc.kr(freq:tsinfreq);

	source = Blip.ar(freq:sourcerate,numharm:numharm,mul:amp);

	filter = RHPF.ar(in:source,freq:hpfreq,rq:0.01);
	pan = Pan2.ar(in:filter,pos:SinOsc.kr(freq:1/dur,phase:posstart * pi));
	rev = FreeVerb.ar(in:pan,damp:revHFdamp);
	chanFFT = FFT(buffer, rev);
	Out.ar(bus:out,channelsArray:rev * env)
}).send(s);
)
h = Synth.new(\greenGlitch, [\hpfreq, 40, \buffer, ~glitchFFTbuf]);

Pan2.ar(in:filter,pos:SinOsc.kr(freq:1/dur,phase:posstart,mul:posmul,add:posadd)) * env;

	posstart = 0,
	posmul = 2,
	posadd = -1,

h = Synth.new(\greenGlitch, [\hpfreq, 80, \buffer, ~glitchFFTbuf, \posstart, 1, \revroom, 0.7]);
h = Synth.new(\greenGlitch, [\hpfreq, 800, \buffer, ~glitchFFTbuf, \posstart, 1.5, \revroom, 0.7]);

{ SinOsc.kr(freq:1/15,phase:,mul:2,add:-1) }.plot(15);
{ SinOsc.kr(freq:1/15,phase:1pi,add:-1) }.plot(15);
{ SinOsc.kr(freq:1/15,phase:1.5 * pi) }.plot(15);

{ SinOsc.kr(1) * SinOsc.kr(2) }.plot(1);

	tnoisefreq = 0.3,

h = Synth.new(\greenGlitch, [\hpfreq, 40, \buffer, ~glitchFFTbuf, \posstart, 0, \tduskdens, 3000]);
h = Synth.new(\greenGlitch, [\hpfreq, 40, \buffer, ~glitchFFTbuf, \posstart, 0, \tduskdens, 30]);
h = Synth.new(\greenGlitch, [\hpfreq, 40, \buffer, ~glitchFFTbuf, \posstart, 0, \tduskdens, 60]);
h = Synth.new(\greenGlitch, [\hpfreq, 40, \buffer, ~glitchFFTbuf, \posstart, 0, \tduskdens, 3000]);

(
h = Synth.new(\greenGlitch, [\hpfreq, 40, \buffer, ~glitchFFTbuf, \posstart, 0, \tduskdens, 200, \tsinfreq, 10]);
h = Synth.new(\greenGlitch, [\hpfreq, 80, \buffer, ~glitchFFTbuf, \posstart, 0, \tduskdens, 2, \tsinfreq, 6]);
h = Synth.new(\greenGlitch, [\hpfreq, 160, \buffer, ~glitchFFTbuf, \posstart, 0, \tduskdens, 10, \tsinfreq, 9]);
)
LFNoise2.kr(freq:tnoisefreq,mul:tnoisemul,add:tnoiseadd)

	tnoisemul = 100,
	tnoiseadd = 3500,

{ LFNoise2.kr(freq:0.3) }.plot(1/0.3);

h = Synth.new(\greenGlitch, [\hpfreq, 160, \buffer, ~glitchFFTbuf, \posstart, 0, \tduskdens, 10, \tsinfreq, 90, \tnoiseadd, 3500 ]);

(
var tnoisefreq, tnoisemul, tnoiseadd, tduskdens, tsinfreq;
tnoisefreq = 0.3;
tnoisemul = 100;
tnoiseadd = 3500;
tduskdens = 250;    // CHANGE THE DENSSITY OF glitch
tsinfreq = 9; // preferred range 0.01 - 10 -- CHANGES THE RITHM
{ LFNoise2.kr(freq:tnoisefreq,mul:tnoisemul,add:tnoiseadd) *
	Dust.kr(density:tduskdens) *
	SinOsc.kr(freq:tsinfreq)
}.plot(1/tnoisefreq);
)

(
var tnoisefreq, tnoisemul, tnoiseadd, tduskdens, tsinfreq;
tnoisefreq = 0.3;
tnoisemul = 100;
tnoiseadd = 3500;
tduskdens = 10;
tsinfreq = 9; // preferred range 0.01 - 10
{ LFNoise2.kr(freq:tnoisefreq,mul:tnoisemul,add:tnoiseadd) *
	Dust.kr(density:tduskdens) *
	SinOsc.kr(freq:tsinfreq)
}.plot(1/tnoisefreq);
)

(
var tnoisefreq, tnoisemul, tnoiseadd, tduskdens, tsinfreq;
tnoisefreq = 0.3;
tnoisemul = 100;
tnoiseadd = 3500;
tduskdens = 10;
tsinfreq = 9; // preferred range 0.01 - 10
{ LFNoise2.kr(freq:tnoisefreq,mul:tnoisemul,add:tnoiseadd) *
	SinOsc.kr(freq:tsinfreq)
}.plot(1/tnoisefreq);
)

(
var tnoisefreq, tnoisemul, tnoiseadd, tduskdens, tsinfreq;
tnoisefreq = 0.3;
tnoisemul = 100;
tnoiseadd = 3500;
tduskdens = 10;
tsinfreq = 9; // preferred range 0.01 - 10
{ LFNoise2.kr(freq:tnoisefreq,mul:tnoisemul,add:tnoiseadd) *
	Dust.kr(density:tduskdens)
}.plot(1/tnoisefreq);
)

FreqScope.new;

Synth.new(\particleSin, [\freq, 1200, \buffer, ~particFFTbuf, \dur, 10, \amp, 1/10])

200/1000
0.3/0.3