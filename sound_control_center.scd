(
~image_control_center = NetAddr.new("127.0.0.1",12000);
///////////////////////////// RED
OSCdef.new(\playRed,
	{|msg, time, addr, rport|
		var edur, nextList, scaledValues;
		// fixed event duration
		edur = 10;
		nextList = (edur * msg.size * 100).asInt;
		scaledValues = (msg[1..msg.size-1] / 255 * 80 + 50).midicps;
		~image_control_center.sendMsg('/deltaTred', nextList);
		("Red Array Size: "++msg.size++" - Arrived on time: "++time).postln;
		scaledValues.postln;
		Pbind(
			\instrument, \particleSin,
			\outBus, 0,
			\dt, Pseq([0.01, 0.1, 0.008], msg.size),
			\maxdt, 3,
			\dur, 10,
			\freq, Pseq(scaledValues),
			\pan, Pfunc({1.0.rand2})
		).play;
		} , '/red'
);
///////////////////////////// BLUE
OSCdef(\playBlue, {|msg, time, addr, port|
	var scaledValues, nextList, minFrq, cutFrq;
//	("Blue Array Size: "++msg.size++" - Arrived on time: "++time).postln;
	nextList = 500000;
	~droneFunc.value(msg,time);
	~image_control_center.sendMsg('/deltaTblue', nextList) },
	'/blue'
);
///////////////////////////// RED Synth
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
	source = Mix.ar(SinOsc.ar([freq, freq * (2**(tone1/12)), freq * (2**(tone2/12))]) * EnvGen.kr(env));
	out = source + CombC.ar(source, maxdt, dtline, decay);
	out = Pan2.ar(out, pan) * amp;
	DetectSilence.ar(out, doneAction: 2);
	Out.ar(outBus, out)
}).add;
///////////////////////////// L O W F R E Q   D R O N E (blue)
SynthDef.new(\rumbledrone, {
	|outBus = 0,
	amp = 0.5,
	dur = 100000,
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
	source = SinOscFB.ar(
		freq:SinOsc.kr(freqOscFreq) * minFreq + deltaFreq,
		feedback:SinOsc.kr(feedbackOscFreq) * feedback
	);
	env = Line.kr(start:1,end:0,dur:dur,doneAction:2);
	filter = HPF.ar(RLPF.ar(source, lpCutoffFreq, lpRecQ), hfCutoffFreq);
	rev = FreeVerb.ar(filter, revMix, revRoom, revDamp);
	out = Pan2.ar(rev, SinOsc.kr(panOscFreq) * panMul)
	*
	env;
//	EnvGen.kr( Env.cutoff );
	fadeIn = Line.kr(start:0,end:amp,dur:20);
	Out.ar(outBus, out * fadeIn)
}).send(s);
///////////////////////////// Generate a Chaotic drone that can stand alone
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
			\minFreq, mfrq.value,
			\lpCutoffFreq, c.value,
			\panOscFreq, 0.01,
			\freqOscFreq, d.value
	]);
};
////////////////////////// GREEN Controlled Synth
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
////////////////////////// GREEN Receiver OSC Function to Control Synth
OSCdef(\green, {|msg,time,addr,port|
//	msg[1..msg.size-1].postln;
	~greenFunc.value(msg[1..msg.size-1], time)
}, "/green");

~greenFunc = {|inList, time|
	var myList,postart,delta;
	myList = inList / 255 * 80 + 40;
	postart = 1.0.rand*2-1;
	("Green Array Size: "++inList.size++" - Arrived on time: "++time).postln;
	myList.postln;
	s.sendBundle(0.5,
		["/s_new", \greenGlitch, ~gglitch = s.nextNodeID, 0, 1],
		["/n_set", ~gglitch,
			\hpfreq, myList.midicps,
			\posstart, postart,
			\dur, 15.rand+15,
	]);
	delta = 30000.rand+15000;
	~image_control_center.sendMsg('/deltaTgreen', delta);
};

~bufDrumkit = SoundFile.collectIntoBuffers(path: "/Volumes/ssdData/Industrial-autoprodotti/*".standardizePath);
OSCdef(\flickerIn,
	{|msg, addr, time, port|
		// random play
//		{ Pan2.ar(PlayBuf.ar(1, ~bufDrumkit[rand(~bufDrumkit.size-1)].bufnum, doneAction: 2), rand(2)-1) }.play;
		// play received sound
		{ Pan2.ar(PlayBuf.ar(1, ~bufDrumkit[msg[1]].bufnum, doneAction: 2), rand(2)-1, 0.3) }.play;
//		msg[1].postln;
	},
	'/flicker');
)


// test communication with processing sketch
~image_control_center.sendMsg('/deltaTblue', 200);
~image_control_center.sendMsg('/deltaTred', 200);
~image_control_center.sendMsg('/deltaTgreen', 20000);

~bufDrumkit.size;

s.queryAllNodes