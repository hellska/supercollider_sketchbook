(
// outgoing messages to processing sketch
~image_control_center = NetAddr.new("127.0.0.1",12000);
// Buffers for FFT analysis
~glitchFFTbuf = Buffer.alloc(s, 512);
~droneFFTbuf = Buffer.alloc(s, 512);
~particFFTbuf = Buffer.alloc(s, 512);

// OSC dispatcher receive incoming messages and deliver to the right function
OSCdef(\playRedNote, {|msg, addr, time, port|
	var freq;
	freq = (msg[1]/255) * 260 + 40; // map RGB value(0-255) to range 40-300
	~playRedNote.value(freq); },
//	("RED: "++freq).postln },
	"/redNote"
);
OSCdef(\playGreenNote, {|msg, addr, time, port|
	var freq;
	freq = (msg[1]/255) * 900 + 300; // map RGB value(0-255) to range 300-1200
	~playGreenNote.value(freq); },
//	("GREEN: "++freq).postln },
	"/greenNote"
);
OSCdef(\playBlueNote, {|msg, addr, time, port|
	var freq;
	freq = (msg[1]/255) * 3800 + 1200; // map RGB value(0-255) to range 1200-5000
	~playBlueNote.value(freq); },
//	("BLUE: "++freq).postln },
	"/blueNote"
);

~playRedNote = {|freq|
	~drone = Synth.new(\rumbledrone, [\minFreq, freq, \buffer, ~droneFFTbuf]);
	~droneFFTbuf.getToFloatArray(action: { |data|
		var x, z;
		z = data.clump(2).flop;
		z = [Signal.newFrom(z[0]), Signal.newFrom(z[1])];
		x = Array.newFrom(z[0]).normalize(0,1);
		~image_control_center.sendMsg("/redFFT", *x);
	});
};
~playGreenNote = {|freq|
	var posRadians, glitchDensity;
	posRadians = 2.0.rand;
	glitchDensity = 1000.rand + 1;
	~glitch = Synth.new(\greenGlitch, [\hpfreq, freq, \buffer, ~glitchFFTbuf, \posstart, posRadians, \tduskdens, glitchDensity])
	.onFree({ nil });
	~glitchFFTbuf.getToFloatArray(action: { |data|
		var x, z;
		z = data.clump(2).flop;
		x = Array.newFrom(z[0]).normalize(0,1);
		~image_control_center.sendMsg("/greenFFT", *x);
	});
};
~playBlueNote = {|freq|
	var delta, dur;
	delta = 10000.rand + 1000;
	dur = delta / 1000.0;
	~partic = Synth.new(\particleSin, [\freq, freq, \buffer, ~particFFTbuf, \dur, dur, \amp, 0.3/dur])
	.onFree({~image_control_center.sendMsg('/deltaTblue', delta) });
	~particFFTbuf.getToFloatArray(action: { |data|
		var x, z;
		z = data.clump(2).flop;
		//  Initially data is in complex form
		x = Array.newFrom(z[0]).normalize(0,1);
		~image_control_center.sendMsg("/blueFFT", *x);
	});
};
)