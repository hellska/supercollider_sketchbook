// send FFT data to processing
(
SynthDef.new(\granulaSample, {
	|trigga = 10,
	dur = 0.1,
	maxGrains = 512,
	minrate = 1,
	outBus = 0,
	sndBuf,
	gate = 1,
	buffer|
	var env, source, out, chan;
	env = EnvGen.ar( Env.asr(0.01, 1, dur * maxGrains, -3),gate:gate, doneAction: 2);
	source = GrainBuf.ar(2, Impulse.kr(trigga), dur, sndBuf, minrate);
	out = source * env;
	chan = FFT(buffer, out);
	Out.ar(outBus, out)
}).send(s);
)
// OTHER RESOURCES NEEDED
OSCdef(\myself, {|msg, time, addr, port| msg.size.postln; msg[1..msg.size-1].postln }, "/testFFT");
~buf = Buffer.alloc(s, 512);
~suono = Synth.new(\granulaSample, [\buffer, ~buf, \outBus, ~in]);
~scnet = NetAddr.new("127.0.0.1", 57120);
~prnet = NetAddr.new("127.0.0.1", 12000);

// This code portion plots the magnitude of the frequency bins
(
~buf.getToFloatArray(action: { |data|
//	var z, x;
	z = data.clump(2).flop;
	// Initially data is in complex form
	z = [Signal.newFrom(z[0]), Signal.newFrom(z[1])];
	y = Array.newFrom(z[0]).normalize(0,1);
	x = Complex(z[0], z[1]);
//	{x.magnitude.plot}.defer;
//	~scnet.sendMsg("/testFFT", *x);
	~scnet.sendMsg("/testFFT", *y);
	~prnet.sendMsg("/testFFT", *y);
});
)


// TESTING
~scnet.sendMsg("/testFFT", *a);
~scnet.sendMsg("/testFFT", *z);

a = [1,2,3,4,5,6];
a.plot;