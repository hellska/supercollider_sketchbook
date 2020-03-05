SynthDef.new(\drone, {
	|outBus = 0,
	amp = 1,
	dur = 10,
	minFreq = 40,
	deltaFreq = 20,
	freqOscFreq = 6,
	feedback = 3,
	feedbackOscFreq = 0.3,
	lpRecQ = 1,
	revMix = 0.7,
	revRoom = 0.8,
	revDamp = 1,
	panOscFreq = 2,
	panMul = 0.2|
	var source, filter, rev, out, fadeIn, env, chanFFT;
	env = EnvGen.ar(Env.linen(1, 2, dur, 0.6, \welch), doneAction:2);
	source = SinOscFB.ar(
		freq:SinOsc.kr(freqOscFreq) * deltaFreq + minFreq,
		feedback:SinOsc.kr(feedbackOscFreq) * pi
	);
	filter = HPF.ar(RLPF.ar(source, minFreq + deltaFreq, lpRecQ), minFreq);
	rev = FreeVerb.ar(filter, revMix, revRoom, revDamp);
	out = Pan2.ar(rev, SinOsc.kr(panOscFreq) * panMul) * env;
	Out.ar(outBus, out)
}).send(s);
~rumbledrone = {|status|
	MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
	// change this variable to select the correct synth
	~synth = '\drone';
	~attenv = Env.adsr(attackTime:0.01,decayTime:0.5,sustainLevel:0.5,releaseTime:1,peakLevel:1,curve:-3).asStream;
	~mul = 0.3;
	~pmul = 0.5;
	~dur = 600;

	~noteOn = {arg src, chan, num, vel;
		var pitch, velo;
		pitch = num; //.midicps;
		velo = (vel / 127.0) * 1.5;
		//Synth(~synth, [\minFreq, pitch.midicps, \dur, ~dur]);
		Synth(~synth, [\minFreq, pitch.midicps, \dur, ~dur, \feedbackOscFreq, 3, \freqOscFreq, 12 ]);
	};
	MIDIIn.addFuncTo(\noteOn, ~noteOn);
};
MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
MIDIClient.init;
MIDIIn.connectAll;
~rumbledrone.value();