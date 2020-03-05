(
SynthDef(\imitational, {
	|outBus = 0,
	amp = 1,
	inBus = 0,
	lpf = 20,
	gate = 1,
	att = 0.01,
	rel 0.1|
	var source, env, ampli, pitch, hasFreq, out;
	env = EnvGen.ar(Env.asr(att,rel),gate,doneAction:2);
	source = SoundIn.ar(inBus) * env;
	// # pitch, hasFreq = Pitch.kr(source, ampThreshold: 0.02, median: 7);
	// ampli pitch
	// out = SinOsc.ar(pitch + 1);
	Out.ar(outBus, source)
}).send(s);

SynthDef(\livein, {|inBus=0, outBus=0, amp=1, nch = 1|
	var source;
	source = In.ar(inBus, 1); // fixed number of channels
	Out.ar(outBus, source)
}).send(s)
)
(
SynthDef("pitchFollow1",{
    var in, amp, freq, hasFreq, out;
    in = Mix.new(SoundIn.ar([0,1]));
    amp = Amplitude.kr(in, 0.05, 0.05);
    # freq, hasFreq = Pitch.kr(in, ampThreshold: 0.02, median: 7);
    //freq = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
    out = Mix.new(VarSaw.ar(freq * [0.5,1,2], 0, LFNoise1.kr(0.3,0.1,0.1), amp));
    6.do({
        out = AllpassN.ar(out, 0.040, [0.040.rand,0.040.rand], 2)
    });
    Out.ar(0,out)
}).play(s);
)
(
~imiSoundGroup = Group.new(s);
~imi = Synth(\imitational,[\inBus, ~imiLivein],~imiSoundGroup);
)
~imiLivein = Bus.audio(s, 1);
~imiIn = Synth(\livein, [\outBus, ~imiLivein],~imiSoundGroup);
~imiIn = Synth(\livein, [\outBus, 0],~imiSoundGroup);
s.meter;
s.queryAllNodes
~imiIn.free

~imi.free
~imiIn.set(\outBus,0);
~imi.set(\inBus,0);
Pitch

(
SynthDef(\imitational,{|inBus=0,gate=1|
	var env, in, amp, freq, hasFreq, out;
	env = EnvGen.ar(Env.asr(0.02,1),gate,doneAction:2);
	    in = Mix.new(SoundIn.ar(inBus)) * env;
	    amp = Amplitude.kr(in, 0.05, 0.05);
	    # freq, hasFreq = Pitch.kr(in, ampThreshold: 0.01, median: 7);
	    //freq = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
	    out = Mix.new(SinOsc.ar(freq / 2,mul: amp));
	    6.do({
		        out = AllpassN.ar(out, 0.040, [0.040.rand,0.040.rand], 2)
	    });
	    Out.ar(0,out)
}).send(s)
)

~imi = Synth(\imitational, [\inBus, 1]);
~imi.set(\gate, 0);

(
SynthDef(\imitatioDist,{|inBus=0,gate=1,bits=16,cutoff=440,dec=2,outBus=0|
	var env, in, amp, freq, hasFreq, out;
	env = EnvGen.ar(Env.asr(0.02,0.3),gate,doneAction:2);
	   in = Mix.new(SoundIn.ar(inBus)) * env;
	    amp = Amplitude.kr(in, 0.05, 0.05);
	    # freq, hasFreq = Pitch.kr(in, ampThreshold: 0.01, median: 7);
	    //freq = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
//	    out = Mix.new(SinOsc.ar(freq / 2,mul: amp));
//	out = Decimator.ar(in,bits).dup;
	out = Disintegrator.ar(in,0.5,amp);// + Mix.new(SinOsc.ar(freq / 2,mul: amp));
	out = LPF.ar(Compander.ar(out),cutoff);
	    3.do({
		        out = AllpassN.ar(out, 0.040, [0.040.rand,0.040.rand], dec)
	    });
	    Out.ar(outBus,out)
}).send(s)
)
s.queryAllNodes;
~aimi = Synth(\imitatioDist);
~aimi.set(\inBus, 1);
~aimi.free;
~aimi.set(\cutoff,5660);
~aimi.set(\outBus, ~delayBus);
~aimi.set(\gate, 0);
~aimi.set(\dec, 5);