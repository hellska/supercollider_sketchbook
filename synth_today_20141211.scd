(
SynthDef.new(\tenMinutesSound, {
	|outBus=0,
	frq=120,
	amp=0.5,
	att=0.01,
	dec=0.3,
	suslev=0.5,
	dur=3,
	crv= -3,
	ph=0,
	den=120|
	var source, env, filter, out;
	env = EnvGen.ar(
		Env.adsr(
			attackTime:att,
			decayTime:dec,
			sustainLevel:suslev,
			releaseTime:dur,
			peakLevel:amp,
			curve:crv),
		doneAction:2);
	source = LFSaw.ar(freq:frq,iphase:ph) * Dust2.ar(density:den);

	out = source * env;
	Out.ar(outBus, out)
}).send(s);
)

(
SynthDef.new(\tenMinutesSound, {
	|outBus=0,
	frq=120,
	amp=0.5,
	att=0.01,
	dec=0.3,
	suslev=0.5,
	dur=3,
	crv= -3,
	ph=0,
	den=120|
	var source, env, filter, out;
	env = EnvGen.ar(
		Env.perc(
			attackTime:att,
			releaseTime:dur,
			level:amp,
			curve:crv),
		doneAction:2);
	source = LFSaw.ar(freq:frq,iphase:ph) * Dust2.ar(density:den,mul:2);

	out = source * env;
	Out.ar(outBus, out)
}).send(s);
)

s.boot;
Synth(\tenMinutesSound);

{ SawDPW.ar(120,0) * PulseDPW.ar(4,0.01) }.play;
{ LFSaw.ar(120) }.play;
{ LFNoise2.ar(200) * PulseDPW.ar(4,0.1,0.5)}.play;
{ LFNoise2.ar(200) * Pulse.ar(SinOsc.kr(0.2)* 10 + 5,0.3,0.5) }.play;
(
Env.adsr(
		attackTime:0.01,
		decayTime:0.3,
		sustainLevel:0.5,
		releaseTime:3,
		peakLevel:0.5,
		curve:-3).test.plot;
)