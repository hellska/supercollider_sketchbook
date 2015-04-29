///// Granulator
SynthDef.new(\granulaHell, {
	|dur = 0.1,
	ratio = 60,
	speed = 2,
	maxGrains = 512,
	outBus = 0,
	sndBuf,
	rate = 23,
	amp = 0.7,
	gate = 1|
	var env, source, out, rad;
	env = Linen.kr(gate, 0.1, 1, 4, 2) * amp;
	source = GrainBuf.ar(1, Impulse.ar(ratio / 60), dur, sndBuf, speed, SinOsc.kr(rate), maxGrains: maxGrains);
//	out = Pan2.ar(Resonz.ar(source, Saw.kr(0.5)*200+300),0);
	out = Pan2.ar(source,0);
	Out.ar(outBus, out * env)
}).send(s);