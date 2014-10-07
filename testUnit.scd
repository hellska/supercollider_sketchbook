// test unit :: everything first instrument
(
SynthDef.new(\coins, {
	|outBus,amp=0.5,freqa=340,curve= -3,ph=0,rel = 0.3|
	var source1, source2, out, env;
	env = Env.perc(releaseTime:rel,curve:curve);
	source1 = SinOsc.ar(freqa,ph) * EnvGen.kr(env, doneAction:2);
	source2 = Saw.ar(freqa) * EnvGen.kr(env, doneAction:2)
	out = Mix.ar([source1, source2]) * amp;
	Out.ar(outBus, out)
}).add;
)

Synth.new(\coins, [\curve, -7, \freqa, 700] );

a.set(\freqa,150);
s.queryAllNodes;


	Env.perc(curve:3).plot;

Saw.ar