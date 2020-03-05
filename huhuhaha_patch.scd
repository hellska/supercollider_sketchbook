(
SynthDef(\oneLoop, { |out, bufnum, start, time, amp|
    var    sig = PlayBuf.ar(1, bufnum, startPos: start, loop: 0),
        env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp), doneAction: 2);
    Out.ar(out, (sig * env) ! 2)
}).add;

~huhubuf = Buffer.read(s, "/home/hellska/soundAndSamples/samples/loops/ueaaaauaueua.wav");
~setInitialPatternValues = {
	~looplength = ~huhubuf.duration;
	~starList = Array.interpolation(12, 0, ~huhubuf.numFrames - (~huhubuf.numFrames/12));
	~tempList = ~starList; // used in order to sramble startlist values
	// set pattern values
	~buffProxy = PatternProxy(~huhubuf);
	~timeProxy = PatternProxy(0.4);
	~startListProxy = PatternProxy(Pseq(~tempList, inf));
	~accentProxy = PatternProxy(Pseq([24, 12, 0], inf));
};
~resetPatternValues = {|buf|
	~looplength = ~huhubuf.duration;
	~starList = Array.interpolation(12, 0, ~huhubuf.numFrames - (~huhubuf.numFrames/12));
	~tempList = ~starList; // used in order to sramble startlist values
	// set pattern values
	~buffProxy.source = ~huhubuf;
	~timeProxy.source = 0.4;
	~startListProxy.source = Pseq(~tempList, inf);
	~accentProxy.source = Pseq([24, 12, 0], inf);
};
)

~setInitialPatternValues.value();

(
~myPattern = Ptpar([
	0, Pn( Pfindur(~looplength, Pbind(\instrument, \oneLoop,
	\bufnum, ~buffProxy,
	\amp, 0.2,
	\start, ~startListProxy,
	\time, ~timeProxy,
	\dur, ~looplength / 12)), 4),
	0.5, Pn( Pfindur(~looplength, Pbind( \instrument, \oneLoop,
		\bufnum, ~buffProxy,
		\amp, Pseq([0.1, 0.2, 0.1, 0], inf),
		\start, 23465,
		\time, ~timeProxy,
		\dur, ~looplength / 12 )), 3)
], inf).play
)

·~myPattern.stop
~myPattern.start

~timeProxy.source = 0.4;


(
~myPattern = Ptpar([
	0, Pn( Pfindur(~timeStep * 12, ~pat1), 1),
	~looplength, Pn( Pfindur(~timeStep * 9, ~pat2), 4)
], inf).play
)
~myPattern.stop;
(
~pat1 = Pbind(\instrument, \oneLoop,
	\bufnum, ~pat1BuffProxy,
	\amp, 0.2,
	\start, ~pat1StartProxy,
	\time, ~pat1TimeProxy,
	\dur, ~timeStep);
~pat2 = Pbind( \instrument, \oneLoop,
	\bufnum, ~pat2BuffProxy,
	\amp, 0.2,
	\start, ~pat2startProxy,
	\time, ~pat2TimeProxy,
	\dur, ~timeStep );
)

~frameStep = ~huhubuf.numFrames / 12;
~timeStep = ~looplength / 12;
~pat2startProxy = PatternProxy(Array.interpolation(8, 0, ~huhubuf.numFrames - (~huhubuf.numFrames/8)));
~pat2startProxy.source = Array.interpolation(8, 0, ~huhubuf.numFrames - (~huhubuf.numFrames/2));
~pat2startProxy.source = Pseq(Array.interpolation(8, 0, ~frameStep * 8), inf);
~huhubuf.duration
~looplength

Array.interpolation(8, 0, ~frameStep * 8);
~testarray = Array.rand(8, 0, ~huhubuf.numFrames);
~pat2startProxy.source = Pseq(~testarray, inf);
~timeProxy.source = 1.9;