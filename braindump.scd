(
SynthDef.new(\particle, {
	arg
	freq = 220,
	amp = 0.3,
	outBus = 0,
	att = 0.04,
	dur = 3,
	tone1 = 4,
	tone2 = 7;
	var source, out, env;
	source = SinOsc.ar(freq) + SinOsc.ar(freq * (2**(tone1/12))) + SinOsc.ar(freq * (2**(tone2/12)));
	source = source * amp;
	env = Env.perc(att, dur - att);
	out = source * EnvGen.kr(env, doneAction:2);
	Out.ar(outBus, out)
}).add;
)

// create new synth direct on te server
s.sendMsg("/s_new", "\particle" ,s.nextNodeID, 0, 1);
// create the synt and set arguments for the specific synth
s.sendBundle(0.05, ["/s_new", "\particle" ,a = s.nextNodeID, 0, 1], ["/n_set", a, \outBus, 1]);

// create the synth and the corresponding object (cpu overhead required)
x = Synth.new(\particle, [\amp, 1, \outBus, 1]);

s.queryAllNodes;
s.meter

SampleDur.ir.postln

// plus delay
(
SynthDef.new(\particle, {
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
	decay = 6;
	var source, out, env;
	env = Env.perc(att, dur - att, amp);
	source = (SinOsc.ar(freq) + SinOsc.ar(freq * (2**(tone1/12))) + SinOsc.ar(freq * (2**(tone2/12))) ) * EnvGen.kr(env);
	out = source + CombC.ar(source, maxdt, dt, decay);
	DetectSilence.ar(out, doneAction: 2);
	Out.ar(outBus, out)
}).add;
)

s.sendBundle(0.05, ["/s_new", "\particle" ,a = s.nextNodeID, 0, 1], ["/n_set", a, \outBus, 1, \dt, 0.5, \maxdt, 1]);

{ DetectSilence.ar( CombC.ar( SinOsc.ar() * EnvGen.kr(Env.perc), 1, 0.2, 3), doneAction:2) }.play;