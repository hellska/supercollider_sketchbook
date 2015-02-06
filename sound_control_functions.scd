/// net address to Processing sketch


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

OSCdef(\playBlue, {|msg, time, addr, port|
	var scaledValues, nextList, minFrq, cutFrq;
//	("Blue Array Size: "++msg.size++" - Arrived on time: "++time).postln;
	nextList = 500000;
	~droneFunc.value(msg,time);
	~image_control_center.sendMsg('/deltaTblue', nextList) },
	'/blue'
);

OSCdef(\playGreen, {|msg,time,addr,port|
//	msg[1..msg.size-1].postln;
	~greenFunc.value(msg[1..msg.size-1], time)
}, "/green");

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

