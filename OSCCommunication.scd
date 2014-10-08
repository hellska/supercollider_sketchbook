// send test message to Processing OSC address space
// adressed to image_control_center sketch
(
m = NetAddr.new("127.0.0.1",12000);
m.sendMsg("/delay", 23456);
)

(
OSCdef.new(\red, {|msg, time, addr, rport| ("Red Array Size: "++msg.size).postln } , '/red');
OSCdef.new(\green, {|msg, time, addr, port| ("Green Array Size: "++msg.size).postln }, '/green');
OSCdef.new(\blue, {|msg, time, addr, port| ("Blue Array Size: "++msg.size).postln }, '/blue');
)

(
// TESTING LOOPBACK MESSAGES
n = NetAddr.new("127.0.0.1", 57120);
n.sendMsg("/ciao", 234.54);
n.sendMsg("/column", 234.54);
)

OSCdef(\input).enable;
OSCdef(\input).disable;
OSCdef.all.do({|in, index| in.postln });
// clean all OSC responder from sclang
OSCdef.freeAll;

OSCFunc.new({|msg, time, addr, recvPort| ("Ciao sono io: "++msg[1]).postln }, '/col');
OSCFunc.new({|msg, time, addr, recvPort| ("Ciao sono io: "++msg[1]).postln }, '/column');


// play sequence of notes with frequencies from red color in pixels received from processing
(
OSCdef.new(\playRed,
	{|msg, time, addr, rport|
		var synthSel;
		synthSel = [ "Sin", "Form" ];
		("Red Array Size: "++msg.size).postln;
		// select the playing synth randomly only once and use the same till the end of the array
		Pbind(\instrument, \particle++synthSel[2.rand], \outBus, 0, \dt, 0.001, \maxdt, 3, \dur, 3,
		\freq, Pseq(msg)).play;
		} , '/red');
)
(
OSCdef.new(\playRed,
	{|msg, time, addr, rport|
		var synthSel;
		synthSel = [ "Sin", "Form" ];
		("Red Array Size: "++msg.size).postln;
		// select the playing synth randomly on each event
		Pbind(\instrument, Prand([\particleSin, \particleForm], inf),
			\outBus, 0,
			\dt, 0.001,
			\maxdt, 3,
			\dur, 3,
			\freq, Pseq(msg),
			\pan, Pfunc({1.0.rand2})
		).play;
		} , '/red');
)
(
OSCdef.new(\playRed,
	{|msg, time, addr, rport|
		var synthSel;
		synthSel = [ "Sin", "Form" ];
		("Red Array Size: "++msg.size).postln;
		// select the playing synth randomly on each event
		Pbind(\instrument, \particleSin,
			\outBus, 0,
			\dt, 0.001,
			\maxdt, 3,
			\dur, 3,
			\freq, Pseq(msg),
			\pan, Pfunc({1.0.rand2})
		).play;
		} , '/red');
)
