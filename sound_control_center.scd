(
~image_control_center = NetAddr.new("127.0.0.1",12000);
///////////////////////////// RED
OSCdef.new(\playRed,
	{|msg, time, addr, rport|
		var edur, nextList;
		// fixed event duration
		edur = 10;
		nextList = (edur * msg.size * 100).asInt;
		~image_control_center.sendMsg('/deltaTred', nextList);
		("Red Array Size: "++msg.size++" - Arrived on time: "++time).postln;
		Pbind(
			\instrument, \particleSin,
			\outBus, 0,
			\dt, Pseq([0.01, 0.1, 0.008], msg.size),
			\maxdt, 3,
			\dur, 10,
			\freq, Pseq(msg),
			\pan, Pfunc({1.0.rand2})
		).play;
		} , '/red');

///////////////////////////// BLUE
OSCdef(\playBlue, {|msg, time, addr, port|
	var scaledValues, nextList;
	("Blue Array Size: "++msg.size++" - Arrived on time: "++time).postln;
	nextList = 50000;
	scaledValues = ((msg / 256) * 40) + 40; // frequency range from 40 to 80 Hz
//	scaledValues.postln;
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
	out = Pan2.ar(out, pan);
	DetectSilence.ar(out, doneAction: 2);
	Out.ar(outBus, out)
}).add;
)

~image_control_center.sendMsg("/delay", 200);
OSCdef.all;