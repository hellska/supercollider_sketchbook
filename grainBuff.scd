~playBuff = Buffer.read(s, "~/x3dLooper/x3dL_default.aiff".standardizePath);
{ GrainBuf.ar(1,Impulse.kr(10), 0.5, ~playBuff, LFNoise1.kr.range(0.5,2)); }.play;
{ GrainBuf.ar(1,Impulse.kr(10), 0.5, ~playBuff, MouseX.kr.range(0.5,20)); }.play;
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
	//(msg[1] * mulPitch + minPitch).postln;
}, '/jXcontrol/Zrotation');
)
OSCdef.all.do({|in| in.postln});
OSCdef(\pitch).free;
OSCdef(\graindur).free;
// range 0.1-3
(
SynthDef.new(\granulaSample, {
	|dur = 0.1,
	maxGrains = 30,
	outBus = 0,
	sndBuf,
	overlap = 0.1,
	amp = 0.7|
	var env, source, out;
	source = GrainBuf.ar(2, Impulse.ar(1/dur-overlap), dur, sndBuf, SinOsc.kr(23)+1/2, maxGrains: maxGrains);
	out = Resonz.ar(source, Saw.kr(0.5)*200+300);
	Out.ar(outBus, out)
}).send(s);
)

Env.asr(0.01, 1, 0.1 * 512, -3).plot;
b = Buffer.read(s, "~/x3dLooper/x3dL_default.aiff".standardizePath);
b.play;
x = { Synth(\granulaSample, [\sndBuf, b]); }.scopeResponse
x = Synth(\granulaSample, [\sndBuf, b]);
x = Synth(\granulaSample, [\bufNum, b, \maxGrains, 5, \outBus, ~in]);
x.free;
x.set(\amp, 1.5);
x.set(\trigga, 20);
x.set(\dur, 2.1);
x.set(\outBus, ~in);
x.set(\minrate, 0.1);
x.map(\minrate, ~grainDur.value);
x.map(\dur, ~pitchRatio);

s.scope;

(
SynthDef(\deldelay, {
	|inBus,
	outBus = 0,
	repeat = 15,
	delaytime|
	var source, out;
	source = In.ar(inBus, 2);
	out = CombC.ar(source,maxdelaytime: delaytime + (delaytime/4) , delaytime: delaytime,decaytime: delaytime * repeat);
//	out = AllpassC.ar(source,maxdelaytime: delaytime, delaytime: delaytime,decaytime: delaytime * repeat);
	Out.ar(outBus, out)
}).send(s);
)
y = Synth(\deldelay,[\delaytime, 0.2], addAction:'addToTail');
y.set(\inBus, ~sampleOut);
y.map(\delaytime, ~grainDur);
y.set(\delaytime, 0.4);
y.set(
~mixer.set(\outBus, 6);
x.free;
s.meter
y.free;
y = Synth(\deldelay,[\delaytime, 0.02, \inBus, ~sampleOut], addAction:'addToTail');
y.map(\delaytime, ~grainDur);

~grainDur = Bus.control(s,1);
(
var minPitch = 0.02, mulPitch;
mulPitch = 0.5;
OSCdef(\pitch, {|msg, time, addr, port|
	~grainDur.set(msg[1] * mulPitch + minPitch);
	//(msg[1] * mulPitch + minPitch).postln;
}, '/jXcontrol/Zrotation');
)