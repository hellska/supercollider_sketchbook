SynthDef.new(\droneBlue, {
	|outBus = 0,
	amp = 0.5,
	dur = 10,
	freq = 80|
	var source, out;
	source =

	s.queryAllNodes

///////// DRONE TESTING Ugens
(
	{
		Pan2.ar(
			FreeVerb.ar(
				RLPF.ar(
					SinOscFB.ar(
						Line.kr(40, 60, 1/0.01),
						SinOsc.kr(0.01) * 16),
					80, 1),
				0.7,
				1.8,
				1
			),
			SinOsc.kr(0.05) * 0.5
		)
	}.play(s);
)
///////// L O W  FREQ DRONE (nice)
(
	{
		Pan2.ar(
			FreeVerb.ar(
				HPF.ar(
					RLPF.ar(
						SinOscFB.ar(
							SinOsc.kr(0.001) * 20 + 40,
							SinOsc.kr(0.01) * 16
						),
					80, 1),
					20
				),
				0.7,
				1.8,
				1
			),
			SinOsc.kr(0.05) * 0.5
			) * EnvGen.kr( Env.cutoff() )
	}.play(s);
)
///////// LOW FREQ Drone - fast modulated frequency
(
	{
		Pan2.ar(
			FreeVerb.ar(
				HPF.ar(
					RLPF.ar(
						SinOscFB.ar(
							SinOsc.kr(6) * 20 + 40, // freqOscFreq * minFreq + deltaFreq
							SinOsc.kr(0.01) * 3 // feedback * feedbackOscFreq
						),
						80, // lpCutoffFreq
						1 // recQ - reciprocal of Q (bandwidth / cutoffFreq)
					),
					20 // hfCutoffFreq
				),
				0.7, // revMix
				1.8, // revRoom
				1 // revDamp
			),
			SinOsc.kr(2) * 0.2 // panOscFreq * panMul
		) * EnvGen.kr( Env.cutoff() )
	}.play(s);
)

(
SynthDef.new(\rumbledrone, {
		|outBus = 0,
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
		panMul = 0.2
		envGate = 1|
		var source, filter, rev, out;
		source = SinOscFB.ar(
			freq:SinOsc.kr(freqOscFreq) * minFreq + deltaFreq,
			feedback:SinOsc.kr(feedbackOscFreq) * feedback
		);
		filter = HPF.ar(RLPF.ar(source, lpCutoffFreq, lpRecQ), hfCutoffFreq);
		rev = FreeVerb.ar(filter, revMix, revRoom, revDamp);
		out = Pan2.ar(rev, SinOsc.kr(panOscFreq) * panMul) * EnvGen.kr( Env.cutoff, envGate );
		Out.ar(outBus, out)
}).send(s);
)

x = Synth.new(\rumbledrone);
x.set(\revDamp, 0.1);
// HF setup
x.set(\minFreq, 10000, \lpCutoffFreq, 1800, \panOscFreq, 0.2, \hfCutoffFreq, 800, \freqOscFreq, 0.01);
x.free;
// Slow movement with fast modulation of feedback and freq
x.set(\panOscFreq, 1/8, \freqOscFreq, 60, \feedbackOscFreq, 173);

// that sounds interesting :)
(
~sinta = {
	i = [120, 255, 110, 78, 45, 145] * 5;
	f = Pseq(i, inf).asStream;
	i = i * 1.5;
	c = Pseq(i, inf).asStream;

	x = Synth(\rumbledrone, [\minFreq, f.value, \lpCutoffFreq, c.value, \panOscFreq, 0.001]);
};
)

	~sinta.value;

	x.set(\envGate, 0); // shutdown your drone
	s.queryAllNodes;
//// TO STUDY
Stream
