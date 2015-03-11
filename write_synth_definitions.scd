(
SynthDef.new(\particleSin, {
	arg
	freq = 220,
	amp = 0.3,
	gate = 1,
	outBus = 0,
	att = 0.01,
	dur = 1,
	tone1 = 4,
	tone2 = 7,
	maxdt = 0.5,
	dt = 0.3,
	dtstart = 0.3,
	pan = 0,
	decay;
	var source, out, env, dtline;
	decay = dur * 3;
	dtline = Line.kr(dtstart, dt, decay);
	env = EnvGen.kr(Env.perc(att, dur - att, amp),gate);
	source = Mix.ar(SinOsc.ar([freq, freq * (2**(tone1/12)), freq * (2**(tone2/12))]) * env);
	out = source + CombC.ar(source, maxdt, dtline, decay);
	out = Pan2.ar(out, pan) * amp;
	DetectSilence.ar(out, doneAction: 2);
	Out.ar(outBus, out)
}).writeDefFile("/Applications/SuperCollider/SuperCollider.app/Contents/Resources/synthdefs/".standardizePath, true);
)
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
	gate = 1,
	numharm = 200,
	hpfreq = 1200, // range 1200-3000
	hprq = 0.01,
	posstart = 0,
	posmul = 2,
	posadd = -1,
	revmix = 0.33,
	revroom = 0.5,
	revHFdamp = 0|
	var source, sourcerate, filter, pan, rev, env, envshape;
	envshape = Env.sine(dur:dur);
//	env = EnvGen.ar(envshape,gate,doneAction:2);
	sourcerate = LFNoise2.kr(freq:tnoisefreq,mul:tnoisemul,add:tnoiseadd) *
	Dust.kr(density:tduskdens) *
	SinOsc.kr(freq:tsinfreq);
	source = Blip.ar(freq:sourcerate,numharm:numharm,mul:amp);
	filter = RHPF.ar(in:source,freq:hpfreq,rq:hprq);
	pan = Pan2.ar(in:filter,pos:SinOsc.kr(freq:1/dur,phase:posstart,mul:posmul,add:posadd));
	rev = FreeVerb.ar(in:pan,mix:revmix,room:revroom,damp:revHFdamp);
	Out.ar(bus:out,channelsArray:rev * EnvGen.kr(Env.asr(0.1, 0.3, 1.3),gate,doneAction:2))
}).writeDefFile("/Applications/SuperCollider/SuperCollider.app/Contents/Resources/synthdefs/".standardizePath, true);
)

x = Synth(\particleSin); // , [\dur, 100]);
x.set(\gate, -4);
x = Synth(\greenGlitch); //, [\dur, 100]);
SynthDef.writeDefFile(\particleSin, ".", true);
x = Synth(\rumbledrone);

(
SynthDef(\synthDefTest, { arg out, gate=1, freq=440;
	// doneAction: 2 frees the synth when EnvGen is done
	Out.ar(out, SinOsc.ar(freq) * EnvGen.kr(Env.asr(0.1, 0.3, 1.3), gate, doneAction:2));
}).store; // use store for compatibility with pattern example below
)

x = Synth(\synthDefTest); // out defaults to zero, if no default arg is given.
x.set(\gate, -5);

"/Volumes/Macintosh HD/hellska/supercollider_sketchbook/sound_control_synths.scd".standardizePath.load;
