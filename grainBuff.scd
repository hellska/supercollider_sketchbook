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
	(msg[1] * mulPitch + minPitch).postln;
}, '/jXcontrol/Zrotation');
)
OSCdef.all.do({|in| in.postln});
OSCdef(\pitch).free;
OSCdef(\graindur).free;
// range 0.1-3
(
SynthDef.new(\granulaSample, {
	|dur = 0.1,
	ratio = 1,
	maxGrains = 30,
	outBus = 0,
	sndBuf,
	overlap = 0.1,
	amp = 0.7|
	var env, source, out;
	source = GrainBuf.ar(2, Impulse.ar(ratio/dur-overlap), dur, sndBuf, SinOsc.kr(23)+1/2, maxGrains: maxGrains);
	out = Resonz.ar(source, Saw.kr(0.5)*200+300);
	Out.ar(outBus, out)
}).send(s);
)

~bufDrumkit = SoundFile.collectIntoBuffers(path: "/Volumes/ssdData/Industrial-autoprodotti/*".standardizePath);


x = Synth(\granulaSample, [\sndBuf, ~bufDrumkit[1]]);
x.free;

a[0] = Synth(\granulaSample, [\sndBuf, ~bufDrumkit[1]]);
a = Synth(\granulaSample, [\sndBuf, ~bufDrumkit[5]]);
b = Synth(\granulaSample, [\sndBuf, ~bufDrumkit[9]]);

Env.asr(0.01, 1, 0.1 * 512, -3).plot;
b = Buffer.read(s, "~/x3dLooper/x3dL_default.aiff".standardizePath);
b.play;
x = { Synth(\granulaSample, [\sndBuf, b]); }.scopeResponse
x = Synth(\granulaSample, [\sndBuf, b]);
x = Synth(\granulaSample, [\bufNum, b, \maxGrains, 5, \outBus, ~in]);
x.free;
x.set(\ratio, 4.0);
x.set(\trigga, 20);
x.set(\dur, 0.3);
x.set(\dur, 0.4);
x.set(\outBus, ~in);
x.set(\minrate, 1.5);
x.map(\minrate, ~grainDur.value);
x.map(\dur, ~pitchRatio);
x.set(\sndBuf, ~bufDrumkit[45]);

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
	// out = AllpassC.ar(source,maxdelaytime: delaytime, delaytime: delaytime,decaytime: delaytime * repeat);
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
s.meter;
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

(
SynthDef.new(\granulaHell, {
	|dur = 0.1,
	ratio = 60,
	maxGrains = 512,
	outBus = 0,
	sndBuf,
	rate = 23,
	amp = 0.7,
	gate = 1|
	var env, source, out, rad;
	env = Linen.kr(gate, 0.1, 1, 4, 2) * amp;
	source = GrainBuf.ar(1, Impulse.ar(ratio / 60), dur, sndBuf, SinOsc.kr(rate), maxGrains: maxGrains);
//	source = GrainBuf.ar(1, SinOsc.ar(ratio), dur, sndBuf, SinOsc.kr(23)+1/2, maxGrains: maxGrains);
	out = Resonz.ar(source, Saw.kr(0.5)*200+300);
	Out.ar(outBus, source * env)
}).send(s);
)


a = Synth(\granulaSample, [\sndBuf, ~bufDrumkit[rand(~bufDrumkit.size-1), \dur, 0,3]], ~grainGroup, \addToHead);

	a.set(\ratio, 2120);
	a.set(\dur, 0.12);

(
a = Array.fill(3, {
	Synth(\granulaSample, [\sndBuf, ~bufDrumkit[rand(~bufDrumkit.size-1), \dur, 0,3]], ~grainGroup, \addToHead);
});
)

// Aggiunge un gruppo ed una serie di Synth ad un Array
~grainGroupTic = Group.new;
~grainArTic = Array.new(10);
// use this as many times as you want
~grainArTic.add(Synth(\granulaSample, [\sndBuf, ~bufDrumkit[rand(~bufDrumkit.size-1)]], ~grainGroupTic, \addToHead));
~grainArTic.add(Synth(\granulaSample, [\sndBuf, ~bufDrumkit[rand(~bufDrumkit.size-1)], \ratio, 100], ~grainGroupTic, \addToHead));
~grainArTic.add(Synth(\granulaSample, [\sndBuf, ~bufDrumkit[rand(~bufDrumkit.size-1)], \ratio, 360], ~grainGroupTic, \addToHead));
~grainArTic.add(Synth(\granulaSample, [\sndBuf, ~bufDrumkit[rand(~bufDrumkit.size-1)], \ratio, 500], ~grainGroupTic, \addToHead));
~grainArTic.add(Synth(\granulaSample, [\sndBuf, ~bufDrumkit[rand(~bufDrumkit.size-1)], \ratio, 600], ~grainGroupTic, \addToHead));
~grainArTic.add(Synth(\granulaSample, [\sndBuf, ~bufDrumkit[rand(~bufDrumkit.size-1)], \ratio, 8000], ~grainGroupTic, \addToHead));
~grainArTic.add(Synth(\granulaSample, [\sndBuf, ~bufDrumkit[rand(~bufDrumkit.size-1)], \ratio, 10000], ~grainGroupTic, \addToHead));
// check the array size
~grainArTic.size;
// remove first element
~grainArTic.removeAt(4).set(\gate, 0);
// set the grain output
~grainArTic[0].set(\gate, 0);
// pass ratio in bpm
~grainArTic[0].set(\ratio, 220);
// print all elements
~grainArTic.do({|el, idx| idx.post; " ".post; el.postln });

s.queryAllNodes;

~grainGroupTic.set(\ratio, 60);
~grainGroupTic.set(\ratio, 80);
~grainGroupTic.set(\ratio, 120);
~grainGroupTic.set(\ratio, 270);
~grainGroupTic.set(\ratio, 330);
~grainGroupTic.set(\ratio, 420);
~grainGroupTic.set(\ratio, 720);

~grainGroup.set(\gate, 0);

(
SynthDef(\glitch, {
	|amp = 0.9,
	freq = 80,
	rfreq = 60,
	rate = 60|
	var source, out;
	source = (SinOsc.ar(freq) + LFNoise2.ar(freq, 0.3)) * Pulse.ar(rate/60, 0.5);
	out = Resonz.ar(source, rfreq);
	Out.ar(0, out * amp)
}).send(s);
)

	a.set(\rate, 55);

a.set(\freq, 60.midicps);
b = Synth(\glitch,[\freq, 80] );
c = Synth(\glitch,[\freq, 110] );
c.set(\rfreq, 80);


~ticGaber[0].play;

a = Synth(\glitch, [\freq, 60.midicps, \rate, 60] );
b = Synth(\glitch, [\freq, 60.midicps, \rate, 30] );
~ticGaber[1].play;
~ticGaber[2].play;
