//// simple drum machine
(
SynthDef(\sampleplayer, { |out, bufnum, start, time, amp, seqgate|
    var sig = PlayBuf.ar(1, bufnum, startPos: start, loop: 0),
        env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp), doneAction: 2);
    Out.ar(out, (sig * env * seqgate) ! 2)
}).add;
SynthDef.new(\reverb, {|inBus, outBus, mix=0.33, room=0.5, damp=0.5|
	var source, out;
	source = In.ar(inBus, 4);
	out = FreeVerb.ar(source, mix, room, damp);
	Out.ar(outBus, out)
}).send(s);

~drumOut = Bus.audio(s, 4);

~totalSteps = 16;
~tempArray = Array.fill(~totalSteps, 0);

~arr1 = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0];
~arr2 = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0];
~arr3 = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0];
~arr4 = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1];

~seq1Proxy = PatternProxy(Pseq(~arr1, inf));
~seq2Proxy = PatternProxy(Pseq(~arr2, inf));
~seq3Proxy = PatternProxy(Pseq(~arr3, inf));
~seq4Proxy = PatternProxy(Pseq(~arr4, inf));

/*
~seq1 = Pseq(~arr1, inf);
~seq2 = Pseq(~arr2, inf);
~seq3 = Pseq(~arr3, inf);
~seq4 = Pseq(~arr4, inf);
*/

~start1proxy = PatternProxy(0);
~start2proxy = PatternProxy(0);
~start3proxy = PatternProxy(0);
~start4proxy = PatternProxy(0);

~amp1Proxy = PatternProxy(0.2);
~amp2Proxy = PatternProxy(0.2);
~amp3Proxy = PatternProxy(0.2);
~amp4Proxy = PatternProxy(0.2);

/* bind the bpm to semiminima measure - da studiare meglio come meccanismo
~defBPM = 60 / 80 / (~totalSteps / 8);
~stepProxy = PatternProxy(~defBPM);
~setBPM = {|bpm| ~stepProxy.source = 60 / bpm / (~totalSteps / 8)};
*/

// bpm per tic of the sequencer (default)
~defBPM = 60 / 60 ;
~stepProxy = PatternProxy(~defBPM);
~setBPM = {|bpm| ~stepProxy.source = 60 / bpm };
~outProxy = PatternProxy(0);

// funzione per cambiare pattern
~setPattern = {|pat, seq|
	pat.postln;
	if (pat==1) { ~seq1Proxy.source = Pseq(seq, inf); };
	if (pat==2) { ~seq2Proxy.source = Pseq(seq, inf); };
	if (pat==3) { ~seq3Proxy.source = Pseq(seq, inf); };
	if (pat==4) { ~seq4Proxy.source = Pseq(seq, inf); };
	if (pat==0) { "SET ALL EQUALS".postln;
			~seq1Proxy.source = Pseq(seq, inf);
			~seq2Proxy.source = Pseq(seq, inf);
			~seq3Proxy.source = Pseq(seq, inf);
			~seq4Proxy.source = Pseq(seq, inf); };
};


// Pn( Plazy { ~step_sequencer_seqs[id] })

~buff1 = Buffer.read(s, "/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/12_barrel09.wav".standardizePath, action: { ~time1proxy = PatternProxy(~buff1.duration); ~buff1Proxy = PatternProxy(~buff1); ~pat1 = Pbind(\instrument, \sampleplayer,
	\bufnum, ~buff1Proxy,
	\out, ~outProxy,
	\start, ~start1proxy,
	\amp, ~amp1Proxy,
	\seqgate, ~seq1Proxy, // Pn( Plazy { ~seq1 }),
	\time, ~time1proxy,
	\dur, ~stepProxy);});
~buff2 = Buffer.read(s, "/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/15_cisterna02.wav".standardizePath, action: { ~time2proxy = PatternProxy(~buff2.duration); ~buff2Proxy = PatternProxy(~buff2); ~pat2 = Pbind(\instrument, \sampleplayer,
	\bufnum, ~buff2Proxy,
	\out, ~outProxy,
	\start, ~start1proxy,
	\amp, ~amp1Proxy,
	\seqgate, ~seq2Proxy, // Pn( Plazy { ~seq2 }),
	\time, ~time2proxy,
	\dur, ~stepProxy);});
~buff3 = Buffer.read(s, "/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/42_low_bar01.wav".standardizePath, action: { ~time3proxy = PatternProxy(~buff3.duration); ~buff3Proxy = PatternProxy(~buff3); ~pat3 = Pbind(\instrument, \sampleplayer,
	\bufnum, ~buff3Proxy,
	\out, ~outProxy,
	\start, ~start1proxy,
	\amp, ~amp1Proxy,
	\seqgate, ~seq3Proxy, // Pn( Plazy { ~seq3 }),
	\time, ~time3proxy,
	\dur, ~stepProxy);});
~buff4 = Buffer.read(s, "/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/26_ding01.wav".standardizePath, action: { ~time4proxy = PatternProxy(~buff4.duration); ~buff4Proxy = PatternProxy(~buff4); ~pat4 = Pbind(\instrument, \sampleplayer,
	\bufnum, ~buff4Proxy,
	\out, ~outProxy,
	\start, ~start1proxy,
	\amp, ~amp1Proxy,
	\seqgate, ~seq4Proxy, // Pn( Plazy { ~seq4 }),
	\time, ~time4proxy,
	\dur, ~stepProxy);});
)

( // audio start
~verb = Synth.new(\reverb, [\inBus, ~drumOut, \outBus, [2,3]]);
~verb.set(\damp, 0.7);
~verb.set(\room, 0.8);
~outProxy.source = ~drumOut;
)


(
~mainseq = Ptpar([
	0, ~pat1,
	0, ~pat2,
	0, ~pat3,
	0, ~pat4], 4).play(TempoClock(1))
)

x = ~pat1.play(TempoClock(1));
x.stop;
x.play(TempoClock(1))

~mainseq.stop;
~mainseq.play;

// Change values
~setBPM.value(295);

( // randomize instr 1
var rarr = Array.rand(~totalSteps, 0, 1).postln;
~seq1Proxy.source = Pseq(rarr, inf);
)
( // randomize instr 2
var rarr = Array.rand(~totalSteps, 0, 1).postln;
~seq2Proxy.source = Pseq(rarr, inf);
)
( // randomize instr 3
var rarr = Array.rand(~totalSteps, 0, 1).postln;
~seq3Proxy.source = Pseq(rarr, inf);
)
( // randomize instr 4
var rarr = Array.rand(~totalSteps, 0, 1).postln;
~seq4Proxy.source = Pseq(rarr, inf);
)

( // randomize all
var rarr = Array.rand(~totalSteps, 0, 1).postln;
~seq1Proxy.source = Pseq(rarr, inf);
rarr = Array.rand(~totalSteps, 0, 1).postln;
~seq2Proxy.source = Pseq(rarr, inf);
rarr = Array.rand(~totalSteps, 0, 1).postln;
~seq3Proxy.source = Pseq(rarr, inf);
rarr = Array.rand(~totalSteps, 0, 1).postln;
~seq4Proxy.source = Pseq(rarr, inf);
)

TempoClock.default.tempo = 1;

(
~setPattern = {|pat, seq|
	pat.postln;
	if (pat==1) { ~seq1Proxy.source = Pseq(seq, inf); };
	if (pat==2) { ~seq2Proxy.source = Pseq(seq, inf); };
	if (pat==3) { ~seq3Proxy.source = Pseq(seq, inf); };
	if (pat==4) { ~seq4Proxy.source = Pseq(seq, inf); };
	if (pat==0) { "SET ALL EQUALS".postln;
		~seq1Proxy.source = Pseq(seq, inf);
		~seq2Proxy.source = Pseq(seq, inf);
		~seq3Proxy.source = Pseq(seq, inf);
		~seq4Proxy.source = Pseq(seq, inf); };
	if (pat==8) { "SET ALL RANDOM".postln;
		~seq1Proxy.source = Pseq(Array.rand(16,0,1).postln, inf);
		~seq2Proxy.source = Pseq(Array.rand(16,0,1).postln, inf);
		~seq3Proxy.source = Pseq(Array.rand(16,0,1).postln, inf);
		~seq4Proxy.source = Pseq(Array.rand(16,0,1).postln, inf); };
}
)

~setPattern.value(1, [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0]);
~setPattern.value(2, [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0]);
~setPattern.value(3, [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0]);
~setPattern.value(4, [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);

~setPattern.value(1, [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);

~setPattern.value(4, Array.fill(16, 0));

~setPattern.value(1, Array.rand(16,0,1).postln);
~setPattern.value(2, Array.rand(16,0,1).postln);
~setPattern.value(3, Array.rand(16,0,1).postln);
~setPattern.value(4, Array.rand(16,0,1).postln);
~setPattern.value(8, Array.rand(16,0,1).postln);

// usando probabilità

~seq1Proxy.source = Pseq([ 2.rand, 2.rand, 2.rand, 2.rand], inf);
~seq2Proxy.source = Pseq([ 2.rand, 2.rand, 2.rand, 2.rand], inf);
~seq3Proxy.source = Pseq([ 2.rand, 2.rand, 2.rand, 2.rand], inf);
~seq4Proxy.source = Pseq([ 2.rand, 2.rand, 2.rand, 2.rand], inf);


a = Pseq([ 2.rand, 2.rand, 2.rand, 2.rand], 4).asStream;
~fstr = FuncStream({ 2.rand });
a = Pseq([~fstr, ~fstr, ~fstr, ~fstr], 4).asStream;
a.next


~seq1Proxy.source =  Pseq([~fstr], inf);
~seq2Proxy.source =  Pseq([~fstr], inf);
~seq3Proxy.source =  Pseq([~fstr], inf);
~seq4Proxy.source =  Pseq([~fstr], inf);

~weightSet = FuncStream({ var coin = 0.5.coin; if(coin, {[1]},{[0]}) });
~weightSet.next;



~seq1Proxy.source = Pseq(~weightSet, inf);

// bpm per tic of the sequencer (default)
~defBPM = 60 / 100 ;
~stepProxy.source = ~defBPM;

a = Pwrand([[1,0,1,0], [1,0,0,0], [1,1,1,0]], (3..1).normalizeSum, inf).asStream
a.next

a = ~pat1.play;
a.stop;

b = Pwrand([[1,0,1,0], [1,0,0,0], [1,1,1,0]], (3..1).normalizeSum, inf).asStream;
c = FuncStream(b);
b.next
~seq1Proxy.source = Pseq(b.next, inf);
~seq2Proxy.source = Pseq([0], inf);
~seq3Proxy.source = Pseq([0], inf);
~seq4Proxy.source = Pseq([0], inf);

~verb.set(\outBus, [0,1]);