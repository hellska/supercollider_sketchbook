//// simple drum machine
(
SynthDef(\sampleplayer, { |out, bufnum, start, time, amp, seqgate|
    var    sig = PlayBuf.ar(1, bufnum, startPos: start, loop: 0),
        env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp), doneAction: 2);
    Out.ar(out, (sig * env * seqgate) ! 2)
}).add;

~buff1 = Buffer.read(s, "/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/1_HHclose01.wav".standardizePath, action: { ~time1proxy = PatternProxy(~buff1.duration); ~buff1Proxy = PatternProxy(~buff1); ~pat1 = Pbind(\instrument, \sampleplayer,
	\bufnum, ~buff1Proxy,
	\start, ~start1proxy,
	\amp, ~amp1Proxy,
	\seqgate, ~seq1Proxy,
	\time, ~time1proxy,
	\dur, ~stepProxy);});
~buff2 = Buffer.read(s, "/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/7_barrel03.wav".standardizePath, action: { ~time2proxy = PatternProxy(~buff2.duration); ~buff2Proxy = PatternProxy(~buff2); ~pat2 = Pbind(\instrument, \sampleplayer,
	\bufnum, ~buff2Proxy,
	\start, ~start1proxy,
	\amp, ~amp1Proxy,
	\seqgate, ~seq2Proxy,
	\time, ~time2proxy,
	\dur, ~stepProxy);});
~buff3 = Buffer.read(s, "/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/19_cisterna06.wav".standardizePath, action: { ~time3proxy = PatternProxy(~buff3.duration); ~buff3Proxy = PatternProxy(~buff3); ~pat3 = Pbind(\instrument, \sampleplayer,
	\bufnum, ~buff3Proxy,
	\start, ~start1proxy,
	\amp, ~amp1Proxy,
	\seqgate, ~seq3Proxy,
	\time, ~time3proxy,
	\dur, ~stepProxy);});
~buff4 = Buffer.read(s, "/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/51_low_ham04.wav".standardizePath, action: { ~time4proxy = PatternProxy(~buff4.duration); ~buff4Proxy = PatternProxy(~buff4); ~pat4 = Pbind(\instrument, \sampleplayer,
	\bufnum, ~buff4Proxy,
	\start, ~start1proxy,
	\amp, ~amp1Proxy,
	\seqgate, ~seq4Proxy,
	\time, ~time4proxy,
	\dur, ~stepProxy);});

~totalSteps = 16;
~tempArray = Array.fill(~totalSteps, 1);

~seq1Proxy = PatternProxy(Pseq(~tempArray, inf));
~seq2Proxy = PatternProxy(Pseq(~tempArray, inf));
~seq3Proxy = PatternProxy(Pseq(~tempArray, inf));
~seq4Proxy = PatternProxy(Pseq(~tempArray, inf));

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
~defBPM = 60 / 150 ;
~stepProxy = PatternProxy(~defBPM);
~setBPM = {|bpm| ~stepProxy.source = 60 / bpm };

)

(
~mainseq = Ptpar([
	0, ~pat1,
	0, ~pat2,
	0, ~pat3,
	0, ~pat4], 4).play
)

~mainseq.stop

// Change values
~setBPM.value(150);

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