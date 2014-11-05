// Synapse communication messages
OSCFunc.new({|msg, time, addr, port| \unmatching.postln; msg[1].postln }, '/torso', recvPort:12347);
OSCFunc.new({|msg, time, addr, port| msg[1].postln }, '/righthand_pos_body', recvPort:12347);

m = NetAddr("127.0.0.1", 12346);
m.sendMsg("/righthand_trackjointpos", 1);

(
~hand = Routine.new({
	var lag, addr;
	lag = 2;
	addr = NetAddr("127.0.0.1", 12346);
	inf.do({
		"messaggio!!!".postln;
		addr.sendMsg("/righthand_trackjointpos", 1);
		2.wait;
	});
});
)

// Use a Tasks to loop sending a message to Synapse

// Activate right hand position traking
t = Task({ {"messagio!!!".postln; m.sendMsg("/righthand_trackjointpos", 1); 2.wait; }.loop });
~hand.value
loop
t.start;
t.stop;

// simple oscillator
(
SynthDef.new(\synosc, {
	|outBus = 0,
	amp = 0.5,
	freq = 220,
	cutoff = 180|
	var source, out;
	source = LFNoise1.ar(freq);
	out = Resonz.ar(source, cutoff) * amp;
	Out.ar(outBus, out)
}).send(s);
// { Formlet.ar(Blip.ar(800,numharm:250,mul:0.1),2290,0.05,10000, ) * 0.3}.play;
SynthDef.new(\synoscForm, {
	|outBus = 0,
	amp = 0.5,
	freq = 220,
	numh = 200,
	cutoff = 180|
	var source, out;
	source = Blip.ar(freq, numh, 0.1);
	out = Formlet.ar(source, cutoff, 0.1, 1000) * amp;
	DetectSilence.ar(out, doneAction:2);
	Out.ar(outBus, out)
}).send(s);

)

Resonz.ar(

~synXIn = Bus.control(s, 1);
~synYIn = Bus.control(s, 1);
(
OSCFunc.new({|msg, time, addr, port|
	var mapMsg2;
		//(msg[2]).postln;
		if (msg[2]<0){
			mapMsg2 = msg[2] * -1;
		} {
			mapMsg2 = msg[2];
		};
	mapMsg2 = mapMsg2 / 700 * 200 + 120;
	mapMsg2.postln;
	~synXIn.set(msg[1]/700*60+200);
	~synYIn.set(mapMsg2);
	},
	'/righthand_pos_body', recvPort:12347);
)
t.start;
x = Synth.new(\synosc);
y = Synth.new(\synoscForm);
y.map(\freq, ~synXIn);
	x.set(\freq, 500);
	a = [200,300,400,500,800.1000];
	q = Prand(a, inf).asStream;
	y.map(\cutoff, ~synYIn);
	y.set(\cutoff, 120);
	x.set(\cutoff, a.value);