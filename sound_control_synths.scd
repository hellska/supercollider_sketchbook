// Synth Definition for ImageControlCenter -> soundControlCenter
(
///// RED Synth
SynthDef.new(\particleSin, {
	arg
	freq = 220,
	amp = 0.3,
	outBus = 0,
	att = 0.01,
	dur = 1,
	tone1 = 4,
	tone2 = 7,
	maxdt = 0.5,
	dt = 0.3,
	dtstart = 0.3,
	pan = 0,
	decay, buffer;
	var source, out, env, dtline, chanFFT;
	decay = dur * 3;
	dtline = Line.kr(dtstart, dt, decay);
	env = Env.perc(att, dur - att, amp);
	source = Mix.ar(SinOsc.ar([freq, freq * (2**(tone1/12)), freq * (2**(tone2/12))]) * EnvGen.kr(env));
	out = source + CombC.ar(source, maxdt, dtline, decay);
	out = Pan2.ar(out, pan) * amp;
	chanFFT = FFT(buffer, out);
	DetectSilence.ar(out, doneAction: 2);
	Out.ar(outBus, out)
}).add;
///// G R E E N
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
///// B L U E ///////////////////////////// L O W F R E Q   D R O N E (blue)
SynthDef.new(\rumbledrone, {
	|outBus = 0,
	amp = 1,
	dur = 10,
	minFreq = 40,
	deltaFreq = 20,
	freqOscFreq = 6,
	feedback = 3,
	feedbackOscFreq = 0.3,
	lpRecQ = 1,
	revMix = 0.7,
	revRoom = 0.8,
	revDamp = 1,
	panOscFreq = 2,
	panMul = 0.2,
	buffer|
	var source, filter, rev, out, fadeIn, env, chanFFT;
	env = EnvGen.ar(Env.linen(1, 2, dur, 0.6, \welch), doneAction:2);
	source = SinOscFB.ar(
		freq:SinOsc.kr(freqOscFreq) * deltaFreq + minFreq,
		feedback:SinOsc.kr(feedbackOscFreq) * pi
	);
	filter = HPF.ar(RLPF.ar(source, minFreq + deltaFreq, lpRecQ), minFreq);
	rev = FreeVerb.ar(filter, revMix, revRoom, revDamp);
	out = Pan2.ar(rev, SinOsc.kr(panOscFreq) * panMul) * env;
	chanFFT = FFT(buffer, out);
	Out.ar(outBus, out)
}).send(s);
)
