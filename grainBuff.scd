{ GrainBuf.ar(1,Impulse.kr(10), 0.5, ~playBuff, LFNoise1.kr.range(0.5,2)); }.play;
{ GrainBuf.ar(1,Impulse.kr(10), 0.1, ~playBuff, MouseX.kr.range(0.5,2)); }.play;
{ GrainBuf.ar(1,Impulse.kr(MouseX.kr(0.01,35)), 0.1, ~playBuff, LFNoise1.kr.range(0.5,2)) * 2; }.play;
{ GrainBuf.ar(1,Impulse.kr(10), MouseX.kr(0.01,3), ~playBuff, LFNoise1.kr.range(0.5,2)); }.play;
{ GrainBuf.ar(numChannels:1,trigger:Impulse.kr(10), dur:MouseX.kr(0.01,3), sndbuf:~playBuff,rate: MouseY.kr.range(0.5,2),pos:0); }.play;
s.queryAllNodes;


~grainDur = Bus.control(s,1);
(
var min, max;
min = 0.5;
max = 2;
OSCdef(\graindur, {|msg, time, addr, port|
	~grainDur.set(msg[1] * (max-min) + min);
	(msg[1] * (max-min) + min).postln;
}, '/jXcontrol/Zrotation');
)

(
var minPitch = 0.02, mulPitch;
mulPitch = 2.5;
OSCdef(\pitch, {|msg, time, addr, port|
	~pitchRatio.set(msg[1] * mulPitch + minPitch);
	(msg[1] * mulPitch + minPitch).postln;
}, '/jXcontrol/Zrotation');
)
OSCdef.all.do({|in| in.postln});
OSCdef(\pitch).free;
OSCdef(\graindur).free;
// range 0.1-3
(
SynthDef.new(\granulaSample, {
	|trigga = 10,
	dur = 0.1,
	maxGrains = 512,
	minrate = 1,
	outBus = 0,
	sndBuf,
	gate = 1|
	var env, source, out;
	env = EnvGen.ar( Env.asr(0.01, 1, dur * maxGrains, -3),gate:gate, doneAction: 2);
	source = GrainBuf.ar(2, Impulse.kr(trigga), dur, sndBuf, minrate);
	out = source * env;
	Out.ar(outBus, out)
}).send(s);
)

Env.asr(0.01, 1, 0.1 * 512, -3).plot;
b = Buffer.read(s, "~/x3dLooper/x3dL_default.aiff".standardizePath);
b.play;
x = { Synth(\granulaSample, [\bufNum, b]); }.scopeResponse
x = Synth(\granulaSample, [\bufNum, b, \maxGrains, 5]);
x = Synth(\granulaSample, [\bufNum, b, \maxGrains, 5, \outBus, ~in]);
x.free;
x.set(\gate, -4);
x.set(\trigga, 20);
x.set(\dur, 2.1);
x.set(\outBus, ~in);

x.plot;