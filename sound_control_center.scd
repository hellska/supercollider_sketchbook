(
~image_control_center = NetAddr.new("127.0.0.1",12000);
///////////////////////////// RED
OSCdef.new(\playRed,
	{|msg, time, addr, rport|
		var edur, nextList, scaledValues;
		// fixed event duration
		edur = 10;
		nextList = (edur * msg.size * 100).asInt;
		scaledValues = (msg[1..msg.size-1] / 255 * 80 + 20).midicps;
		~image_control_center.sendMsg('/deltaTred', nextList);
		("Red Array Size: "++msg.size++" - Arrived on time: "++time).postln;
		Pbind(
			\instrument, \particleSin,
			\outBus, 0,
			\dt, Pseq([0.01, 0.1, 0.008], msg.size),
			\maxdt, 3,
			\dur, 10,
//			\freq, Pseq(msg[1..msg.size-1]),
			\freq, Pseq(scaledValues),
			\pan, Pfunc({1.0.rand2})
		).play;
		} , '/red'
);
///////////////////////////// BLUE
OSCdef(\playBlue, {|msg, time, addr, port|
	var scaledValues, nextList, minFrq, cutFrq;
	("Blue Array Size: "++msg.size++" - Arrived on time: "++time).postln;
	nextList = 500000;
	~droneFunc.value(msg);
	~image_control_center.sendMsg('/deltaTblue', nextList) },
	'/blue'
);
///////////////////////////// BLUE


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
	var source, filter, rev, out, fadeIn;
	source = SinOscFB.ar(
		freq:SinOsc.kr(freqOscFreq) * minFreq + deltaFreq,
		feedback:SinOsc.kr(feedbackOscFreq) * feedback
	);
	filter = HPF.ar(RLPF.ar(source, lpCutoffFreq, lpRecQ), hfCutoffFreq);
	rev = FreeVerb.ar(filter, revMix, revRoom, revDamp);
	out = Pan2.ar(rev, SinOsc.kr(panOscFreq) * panMul)
	*
	EnvGen.kr( Env.cutoff );
	fadeIn = Line.kr(start:0,end:amp,dur:20);
	Out.ar(outBus, out * fadeIn)
}).send(s);
/// FUNCTIONS
///////////////////////////// Generate a Chaotic drone that can stand alone
//~droneFunc = Routine{|input|
~droneFunc = {|input|
	var mfrq;
	input = input[1..input.size-1] * 5;
	input.postln;
	mfrq = Pseq(input, inf).asStream;
	d = Prand(input / 255 * 12, inf).asStream;
	input = input * 1.5;
	input.postln;
	c = Pseq(input, inf).asStream;
//	s.sendBundle(0.2, ['/s_new', '\rumbledrone', ~drone = s.nextNodeID, 0, 1],['/n_set', ~drone, \minFreq, f.value, \lpCutoffFreq, c.value, \panOscFreq, 0.001]);
	s.sendBundle(0.2,
		['/s_new', '\rumbledrone', ~drone = s.nextNodeID, 0, 1],
		['/n_set', ~drone,
//			\minFreq, f.value,
			\minFreq, mfrq.value,
			\lpCutoffFreq, c.value,
			\panOscFreq, 0.01,
			\freqOscFreq, d.value
	]);
};
)

d.value.plot(1);
c.size
s.nextNodeID

~drone.set(\minFreq, f.value, \lpCutoffFreq, c.value);
~droneFunc.value([120, 255, 110, 78, 45, 145]);
~drone.nodeID
~image_control_center.sendMsg("/delay", 200);
OSCdef.all;
~image_control_center.sendMsg('/deltaTblue', 200);
~image_control_center.sendMsg('/deltaTred', 200);
s.queryAllNodes
OSCdef('\playBlue').free
~drone.newMsg(g)