(
SynthDef.new(\tailorPlayer, {
	|outBus = 0,
	amp = 1,
	bufnum,
	sampleNo = 0,
	loop = 0,
	rate = 1,
	start = 0,
	pan = 0|
	var source, out;
	source = PlayBuf.ar(1, bufnum, rate: rate, trigger: 1,startPos: start, loop:loop,doneAction:2);
	out = Pan2.ar(source,pos:pan,level:amp);
	Out.ar(outBus, out)
}).send(s);

SynthDef.new(\delaylama, {
	|inbus,
	outBus = 0,
	deltime = 0.7,
	dlt = 0.3,
	mxdelt = 3|
	var source, out;
	source = In.ar(inbus, 2);
	out = DelayC.ar(source,maxdelaytime:mxdelt, delaytime:dlt,add:source);
	Out.ar(outBus, out)
}).send(s);

)

(
// soundscapes
~ts = "/Users/hellska/Documents/SonicTaylorWorkshop/sample_mono/soundscapes/*";
~tsb = SoundFile.collectIntoBuffers(~tailorpath_mono.standardizePath, s);
// words
~tw = "/Users/hellska/Documents/SonicTaylorWorkshop/sample_mono/words/*";
~twb = SoundFile.collectIntoBuffers(~tw.standardizePath, s);
// drumkit
~td = "/Users/hellska/Documents/SonicTaylorWorkshop/sample_mono/drumkit/*";
~tdb = SoundFile.collectIntoBuffers(~td.standardizePath, s);
)
(
~tsb.size.postln;
~twb.size.postln;
~tdb.size.postln;
)
(
~delay = Bus.audio(s, 2);
~mydelay = Synth.tail(nil, \delaylama, [\inbus, ~delay]);
)