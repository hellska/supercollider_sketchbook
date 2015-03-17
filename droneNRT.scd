// NRT first steps

// Step by Step TUTORIAL
// Creare il file dei comandi OSC
// Creare il file con la definizione del synth usando il metodo writeDefFile della classe Synthdef
// lanciare da command line o con metodo unixCmd l'eseguibile scsynth per generare i file audio
// the time in wich the close OSC command (every empty OSC command) is scheduled determines the length of the audio file

// I path relativi costituiscono un problema ... quindi usare path assoluti per tutto!


f = File("/Users/hellska/temp/droneNRT.osc", "w");
c = [ 0.2, [\s_new, \rumbledrone, 1001, 0, 0]].asRawOSC;
f.write(c.size);
f.write(c);
c = [ 0.3, [\n_set, 1001, \minFreq, 300]].asRawOSC;
f.write(c.size);
f.write(c);
c = [ 13.3, [0]].asRawOSC; // this command close the execution of NRT synthesis
f.write(c.size);
f.write(c);

f.close;

"/Applications/SuperCollider/SuperCollider.app/Contents/Resources/scsynth -N /Users/hellska/temp/droneNRT.osc _ /Users/hellska/temp/droneNRTout_1ch.aiff 44100 AIFF int16 -o 1".unixCmd;

(
SynthDef.new("rumbledrone", {
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
	panMul = 0.2,
	buffer|
	var source, filter, rev, out, fadeIn, env, chanFFT;
	env = EnvGen.ar(Env.linen(1, 2, dur, 0.6, \welch), doneAction:2);
	source = SinOscFB.ar(
		freq:SinOsc.kr(freqOscFreq) * deltaFreq + minFreq,
		feedback:SinOsc.kr(feedbackOscFreq) * 2pi
	);
	filter = HPF.ar(RLPF.ar(source, minFreq + deltaFreq, lpRecQ), minFreq);
	rev = FreeVerb.ar(filter, revMix, revRoom, revDamp);
	out = Pan2.ar(rev, SinOsc.kr(panOscFreq) * panMul) * env;
	Out.ar(outBus, out)
}).writeDefFile;
)