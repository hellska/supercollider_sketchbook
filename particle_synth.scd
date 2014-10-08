// Creates chords using 3 oscillator
// You can control the chords using tone1 and tone2

(
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
	decay;
	var source, out, env, dtline;
	decay = dur * 3;
	dtline = Line.kr(dtstart, dt, decay);
	env = Env.perc(att, dur - att, amp);
	source = (SinOsc.ar(freq) + SinOsc.ar(freq * (2**(tone1/12))) + SinOsc.ar(freq * (2**(tone2/12))) ) * EnvGen.kr(env);
	out = source + CombC.ar(source, maxdt, dtline, decay);
	out = Pan2.ar(out, pan);
	DetectSilence.ar(out, doneAction: 2);
	Out.ar(outBus, out)
}).add;

// min dur permitted to hear the delay is 0.23
SynthDef.new(\particleForm, {
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
	decay = 3,
	startb = -1,
	endb = 1;
	var source, out, env, dtline;
	dtline = Line.kr(dtstart, dt, decay);
	env = Env.perc(att, dur - att, amp);
	source = (Formant.ar(freq) + Formant.ar(freq * (2**(tone1/12))) + Formant.ar(freq * (2**(tone2/12))) ) * EnvGen.kr(env);
	out = source + CombC.ar(source, maxdt, dtline, decay);
	out = Pan2.ar(out, Line.kr(startb,endb,decay));
	DetectSilence.ar(out, doneAction: 2);
	Out.ar(outBus, out)
}).add;
)

// synth test
s.sendBundle(0.05, ["/s_new", "\particleForm" ,a = s.nextNodeID, 0, 1], ["/n_set", a, \outBus, 0, \dt, 0.001, \maxdt, 3, \dur, 23, \decay, 12, \startb, 1, \endb, -0.5, \freq, 80]);
s.sendBundle(0.05, ["/s_new", "\particleSin" ,a = s.nextNodeID, 0, 1], ["/n_set", a, \outBus, 0, \dt, 0.001, \maxdt, 3, \dur, 5, \freq, 60]);
