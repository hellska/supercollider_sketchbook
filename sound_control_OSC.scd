// outgoing messages to processing sketch
~image_control_center = NetAddr.new("127.0.0.1",12000);
// OSC dispatcher receive incoming messages and deliver to the right function

OSCdef(\playRedNote, {|msg, addr, time, port|
	var freq;
	freq = (msg[1]/255) * 260 + 40; // map RGB value(0-255) to range 40-300
	~playRedNote.value(freq);
	("RED: "++freq).postln },
"/redNote");

OSCdef(\playGreen, {|msg, addr, time, port|
	~greenFunc.value(msg[1]);
	("GREEN: "++msg[1]).postln },
"/green");
OSCdef(\playBlue, {|msg, addr, time, port|
	~blueFunc.value(msg[1]);
	("BLUE: "++msg[1]).postln },
"/blue");

~playRedNote = {|freq|
	s.sendBundle(0.2,
		['/s_new', '\rumbledrone', ~drone = s.nextNodeID, 0, 1],
		['/n_set', ~drone, \minFreq, freq,
	]);
};


// Test OSC for incoming messages
~ciao = NetAddr.new("127.0.0.1", NetAddr.langPort);
~ciao.sendMsg('/blue', 324);

~playRedNote.value(100);