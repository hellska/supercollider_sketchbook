s.quit

s.scope;
s.meter;
s.makeGui; // show local server gui
s.postln;
Server.all;
Server.local;
Server.internal;
Server.allRunningServers;
s.boot;
Server.supernova;
s.dumpOSC(1); // Dump all Incoming messages sent to server
s.dumpOSC(0);
s.freqscope;

s.meter

s.queryAllNodes;
s.plotTree; // queryAllNodes gui

s.prepareForRecord;
s.record;
s.pauseRecording;
s.record;
s.stopRecording;


NetAdd.langPort;

{ Resonz.ar(Blip.ar(16,numharm:250),400,bwr:1,mul:0.3) }.play;
{ Resonz.ar(Blip.ar(800,numharm:250,mul:0.1),2290,mul:0.3)}.play;
{ Formlet.ar(Blip.ar(16,numharm:250),freq:400,attacktime:0.01,decaytime:0.1,mul:0.3) }.play;
{ Formlet.ar(Blip.ar(800,numharm:250,mul:0.1),freq:2290,attacktime:0.05,decaytime:10000,mul:0.3 )}.play;




(
SynthDef.new(\oscilStream, {
	|outBus = 0,
	amp = 0.5,
	freq = 220,
	dur = 1|
	var source, out;
	source = SinOsc.ar(freq);
	out = source * amp;
	Out.ar(outBus, out)
}).send(s);
)

Synth(\oscilStream);

(
SynthDef.new(\reAson, {
	|out = 0,
	amp = 0.3,
	length = 1.5,
	rate = 16,
	numharm = 250,
	pan = 0,
	reson = 500,
	bwr = 1|
	var source, aout, eshape, env, panpot;
	eshape = Env.triangle(dur:length,level:amp);
	env = EnvGen.ar(envelope:eshape,doneAction:2);
	source = Blip.ar(freq:rate,numharm:numharm);
	panpot = Pan2.ar(in:source,pos:pan);
	aout = Resonz.ar(in:panpot,freq:reson,bwr:bwr);
	Out.ar(out, aout * env)
}).send(s);
)


x = Synth.new(\reAson);
x = Synth.new(\reAson,[\rate, 25]);
x = Synth.new(\reAson,[\rate, 25, \numharm, 500]);
x = Synth.new(\reAson,[\rate, 25, \numharm, 500, \pos, 1.2]);
x = Synth.new(\reAson,[\rate, 25, \numharm, 500, \pos, 1.2, \reson, 200]);
x = Synth.new(\reAson,[\rate, 25, \numharm, 70, \pos, 0, \reson, 300, \bwr, 0.03, \amp, 1.5]);
a = Pseq([1,2,3,4,5,6,7,8,9,10]-5/10,30).asStream;
x = Synth.new(\reAson,[\rate, 50, \numharm, 70, \pos, -1, \reson, 1500, \bwr, 0.03, \amp, 1.5]);

p = Pbind(\instrument, \reAson, \rate, Pseq([10,20,40,80,160,320,640,1280],30), \numharm, 70, \pan, a.value, \reson, 1500, \bwr, 1.03, \amp, 0.5, \delta, Prand([1,2,3,4,5],inf)).play;

c = Pbind(\instrument, \reAson, \pan, 0, \rate, 3000, \numharm, 70, \reson, 1500, \bwr, 0.03, \amp, 1.5).play;
p.stop;
p.start;

Pseq([10,20,40,80,160,320,640,1280],30)

p = Pbind(\instrument, \reAson, \rate, 50, \numharm, 70, \pan, Pseq([1,0,-1],3), \reson, 100, \bwr, 0.03, \amp, 1.5).play;
p.stop;
p.start;
p = Pbind(\instrument, \reAson, \pan, Pfunc({1.0.rand2})).play;
p = Pbind(\instrument, \reAson, \pan, Pseq([-1,0,1],inf)).play;

p = Pbind(\instrument, \reAson).play;
p = Pbind(\instrument, \reAson, \rate, 100).play;
c = Synth(\reAson, [\rate, 100]);
p = Pbind(\instrument, \reAson, \brw, 1.2).play;

s.queryAllNodes;

Env.triangle(dur:1.5,level:0.3).plot(1);
Pseq([1,2,3,4,5,6,7,8,9,10]-5/10,30).plot;

Pbind(\instrument, \reAson, \rate, 50, \numharm, 70, \pan, Pseq([1,0,-1],3), \reson, 1000, \bwr, 0.03, \amp, 1.5).play;
Pbind(\instrument, \reAson, \rate, 1000).play;
c = Synth(\reAson, [\rate, 1000]);

FreqScope.new(400, 200, 0);

x = { RLPF.ar(in:SawDPW.ar(800),freq:5000,rq:1,mul:0.3) };
x.play;
x.stop;

{ HighShelf.ar(SawDPW.ar(800),freq:1200,shelfslope:0.3,dbgain:-6,mul:0.3) }.play
{ HighShelf.ar(LFNoise0.ar(3000),freq:2800,shelfslope:1,dbgain:0,mul:0.1) }.play
{ HighShelf.ar(LFNoise1.ar(3000),freq:2800,shelfslope:1,dbgain:0,mul:0.1) }.play
{ HighShelf.ar(LFNoise2.ar(3000),freq:2800,shelfslope:1,dbgain:0,mul:0.1) }.play

// filters
{RHPF.ar(Blip.ar(freq:Line.kr(15.midicps,30.midicps,7.3),numharm:50),freq:760,rq:0.1,mul:0.3) }.play;
{RHPF.ar(ClipNoise.ar(mul:0.2)+SinOscFB.ar(freq:1300,feedback:0.2),freq:MouseX.kr(300,5000,1),rq:1,mul:0.3) * EnvGen.ar(Env.perc(),doneAction:2) }.play;


{ RHPF.ar(Pulse.ar(MouseX.kr(10,1000),width:1),freq:1000,rq:MouseY.kr(0.1,10),mul:0.2) }.play
{ Pulse.ar(MouseX.kr(10,100),width:0.02,mul:0.3) }.play

// High Freq Glitch Sound
(
{
FreeVerb.ar(
	Pan2.ar(
	    RHPF.ar(
			Blip.ar(
				LFNoise2.kr(freq:0.3,mul:100,add:3500)
				*
				Dust.kr(density:250)
				*
				SinOsc.kr(
					//MouseX.kr(0.01,10)
					0.06
				),
				numharm:2000,
				mul:0.3,
				add:0
			),
			//MouseY.kr(1200,3000,1),
			45.midicps,
			//rq:MouseX.kr(1,0.01),
			0.01,
		),
		SinOsc.kr(0.5,Rand(-1,1),2,-1) // calculate freq 1/dur
	),
mix:0.33,
room:0.5,
damp:MouseX.kr(0,1)
)
}.play;
)

s.prepareForRecord;
s.record;
s.stopRecording;

s.meter;

69.midicps.postln; // A 440
69.118.midicps.postln; // A 443
FreqScope.new(512,300,0);

// Play with RHPF Frequency - Min Freq 400 - use midicps to give harmonic spectra to the sound
// Move the reverb damp to sligtly change timbre
// created with envelope --- test crossfading from a synth to the next one and test the possibilities
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
	numharm = 200,
	hpfreq = 1200, // range 1200-3000
	hprq = 0.01,
//	posfreq = 1 / dur
	posstart = 0,
	posmul = 2,
	posadd = -1,
	revmix = 0.33,
	revroom = 0.5,
	revHFdamp = 0|
	var source, sourcerate, filter, pan, rev, env, envshape;
	envshape = Env.sine(dur:dur);
	env = EnvGen.ar(envshape,doneAction:2);
	sourcerate = LFNoise2.kr(freq:tnoisefreq,mul:tnoisemul,add:tnoiseadd) *
	Dust.kr(density:tduskdens) *
	SinOsc.kr(freq:tsinfreq);
	source = Blip.ar(freq:sourcerate,numharm:numharm,mul:amp);
	filter = RHPF.ar(in:source,freq:hpfreq,rq:hprq);
	pan = Pan2.ar(in:filter,pos:SinOsc.kr(freq:1/dur,phase:posstart,mul:posmul,add:posadd)) * env;
	rev = FreeVerb.ar(in:pan,mix:revmix,room:revroom,damp:revHFdamp);
	Out.ar(bus:out,channelsArray:rev)
}).send(s);


OSCdef(\green, {|msg,time,addr,port|
	msg[1..msg.size-1].postln;
	~greenFunc.value(msg[1..msg.size-1])
}, "/green");

~greenFunc = {|inList|
	var myList,postart;
	myList = inList / 255 * 80 + 40;
	postart = 1.0.rand*2-1;
//	Synth(\greenGlitch, [\hpfreq, b.midicps, \posstart, a, \dur, c]);
	s.sendBundle(0.5,
		["/s_new", \greenGlitch, ~gglitch = s.nextNodeID, 0, 1],
		["/n_set", ~gglitch,
			\hpfreq, inList.midicps,
			\posstart, postart,
			\dur, 15.rand+15,
	]);
}
)

(
a = 1.0.rand*2-1;
b = 80.rand+40;
c = 15.rand+15;
("Next position: "++a++" - next freq: "++b++" - next dur: "++c).postln;
x = Synth(\greenGlitch, [\hpfreq, b.midicps, \posstart, a, \dur, c]);
)

FreqScope.new;
s.queryAllNodes;
s.volume.gui;

(
///////////////////////////// L O W F R E Q   D R O N E (blue) With Long ENV
SynthDef.new(\rumbledrone, {
	|outBus = 0,
	amp = 0.5,
	dur = 60, // in seconds
	minFreq = 40,
	deltaFreq = 20,
	freqOscFreq = 6,
	feedback = 3,
	feedbackOscFreq = 0.01,
	lpCutoffFreq = 80,
	lpRecQ = 1,
	hfCutoffFreq = 20,
	revMix = 0.7,
	revRoom = 0.8,
	revDamp = 1,
	panOscFreq = 2,
	panMul = 0.2|
	var source, filter, rev, out, fadeIn, env;
	fadeIn = XLine.kr(start:0.1,end:amp,dur:0.1);
	env = Line.ar(start:1,end:0,dur:dur,doneAction:2);
	source = SinOscFB.ar(
		freq:SinOsc.kr(freqOscFreq) * minFreq + deltaFreq,
		feedback:SinOsc.kr(feedbackOscFreq) * feedback
	) * fadeIn;

	filter = HPF.ar(RLPF.ar(source, lpCutoffFreq, lpRecQ), hfCutoffFreq);
	rev = FreeVerb.ar(filter, revMix, revRoom, revDamp);
	out = Pan2.ar(rev, SinOsc.kr(panOscFreq) * panMul);
//	EnvGen.kr( Env.cutoff );

	Out.ar(outBus, out * env)
}).send(s);
/// FUNCTIONS
///////////////////////////// Generate a Chaotic drone that can stand alone
//~droneFunc = Routine{|input|
~droneFunc = {|input,time|
	var mfrq;
	input = input[1..input.size-1] * 5;
	mfrq = Pseq(input + 50, inf).asStream;
	d = Prand(input / 255 * 12 + 1, inf).asStream;
	input = input * 1.5;
//	input.postln;
	c = Pseq(input + 50, inf).asStream;
	("Blue Array Size: "++input.size++" - Arrived on time: "++time).postln;
	input.postln;
	mfrq.value.postln;
	s.sendBundle(0.2,
		['/s_new', '\rumbledrone', ~drone = s.nextNodeID, 0, 1],
		['/n_set', ~drone,
			\minFreq, 50,
			\lpCutoffFreq, 60,
			\panOscFreq, 0.01,
			\freqOscFreq, c.value
	]);
};
)
~droneFunc.value(['/ciao', 70], 34567);
~droneFunc.value(['/ciao', 0], 34567);
s.queryAllNodes;
s.sendMsg(['/n_set', ~drone, \minFreq, 220]);
s.plotTree;

{ XLine.kr(start:0.001,end:0.5,dur:0.1) }.plot(0.1);
{ Line.ar(start:1,end:0,dur:60,doneAction:2) }.plot(60);

Env.linen(attackTime:0.01,sustainTime:1,releaseTime:1,level:1,curve:\lin).test.plot;
Env.linen(attackTime:0.01,sustainTime:1,releaseTime:1,level:1,curve:\welch).test.plot;
Env.linen(attackTime:0.01,sustainTime:1,releaseTime:1,level:1,curve:\exp).test.plot;
Env.linen(attackTime:0.01,sustainTime:1,releaseTime:1,level:1,curve:\exp).test.plot;