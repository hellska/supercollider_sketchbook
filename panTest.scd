(
SynthDef.new(\pantest, {
	|freq = 220,
	amp = 0.3,
	pan = 0,
	outBus = 0|
	var source;
	source = Pan2.ar(SinOsc.ar(freq:freq,mul:amp),pan);
	Out.ar(outBus, source)
}).send(s);
)

a = Synth(\pantest);
x = Pbind(\instrument, \pantest, \freq, [220, 222], \pan, 0);
x.play;
x.stop;

y = Pbind(\instrument, \pantest, \delta, 4);
y.play;
y.stop;

s.queryAllNodes;

OffsetOut

(
SynthDef.new(\ratest, {
	|out = 0,
	amp = 0.3,
	dur = 5,
	freq = 20,
	harm = 200|
	var source, filter, env, envshape;
	source = LPF.ar(Blip.ar(freq,numharm:harm,mul:amp),20000);
	envshape = Env.triangle(dur:dur);
	env = EnvGen.ar(envshape,doneAction:2);
	Out.ar(out, source * env)
}).send(s)
)
x = Synth(\ratest, [\harm, 100,]);

x.set(\freq, 45);
x.set(\harm, 20);

a = Pseq([3,13,23,33,43,53,63,73],10).asStream;
b = Prand([340,230,123],inf).asStream;

x.set(\freq, a.value);
a.next;
x.set(\freq, b.value);
b.next;

f = Pbind(\instrument, \ratest, \freq, b.value).play;
e = Pbind(\instrument, \ratest, \freq, a.value).play;
g = Pbind(\instrument, \ratest, \freq, Pseq([3,12,24],inf),\dur, Pseq([6,3,5],inf)).play;
g.stop;

f.stop;
f.play
e.play;
e.reset;
e.stop;

Env.circle([0, 1, 0], [0.01, 0.5, 0.2]).plot

s.prepareForRecord;
s.record;
s.volume.gui;
s.stopRecording;
s.queryAllNodes;