(
~tailorpath = "/Users/hellska/Documents/SonicTaylorWorkshop/samples/*";
~tailors = SoundFile.collectIntoBuffers(~tailorpath.standardizePath, s);
)

(
~tailorpath_mono = "/Users/hellska/Documents/SonicTaylorWorkshop/sample_mono/soundscapes/*";
~tailors_mono = SoundFile.collectIntoBuffers(~tailorpath_mono.standardizePath, s);
)
(
~tw = "/Users/hellska/Documents/SonicTaylorWorkshop/sample_mono/words/*";
~twb = SoundFile.collectIntoBuffers(~tw.standardizePath, s);
)

(
~fileInfo = {|fileNum, sndFileArray|
	"####### File info Start #######".postln;
	sndFileArray[fileNum].path.postln;
	sndFileArray[fileNum].numChannels.postln;
	sndFileArray[fileNum].sampleRate.postln;
	sndFileArray[fileNum].headerFormat.postln;
	sndFileArray[fileNum].sampleFormat.postln;
	sndFileArray[fileNum].numFrames.postln;
	"######## File info End ########"
};
)

~tailors_mono[0].play;
~tailors_mono.size;

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

NetAddr.langPort;

~tailors_mono.do({|i, idx| idx.post; (" : "++i).postln });
~tailors_mono[sampleNo].

x = Synth(\tailorPlayer, [\bufnum, ~tailors_mono[0].bufnum]);
~soudscape01 = Synth(\tailorPlayer, [\bufnum, ~tailors_mono[0].bufnum, \loop, 1]);
~soudscape02 = Synth(\tailorPlayer, [\bufnum, ~tailors_mono[0].bufnum, \loop, 1]);
~soudscape01.set(\loop, 1);
~soudscape02 = Synth(\tailorPlayer, [\bufnum, ~tailors_mono[1].bufnum, \loop, 1]);

~soudscape01.set(\outBus, ~delay);

(
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

~delay = Bus.audio(s, 2);
~mydelay = Synth.tail(nil, \delaylama, [\inbus, ~delay]);

~xxx = Synth.head(nil, \tailorPlayer, [\bufnum, ~tailors_mono[3].bufnum, \loop, 1, \outBus, ~delay]);
~www = Synth.head(nil, \tailorPlayer, [\bufnum, ~tailors_mono[4].bufnum, \loop, 1, \outBus, ~delay]);
~bbb = Synth.head(nil, \tailorPlayer, [\bufnum, ~tailors_mono[5].bufnum, \loop, 1, \outBus, ~delay]);
~
~yyy = Synth.head(nil, \tailorPlayer, [\bufnum, ~tailors_mono[10].bufnum, \loop, 1]);

~xxx.set(\loop, 0);

~aaa = Synth(\tailorPlayer, [\bufnum, ~twb[0].bufnum]);
~aaa = Synth(\tailorPlayer, [\bufnum, ~twb[0].bufnum, \rate, 8, \outBus, ~delay, \amp, 0.2, \loop, 1]);
~aaa.set(\loop,0);

~xxx.set(\outBus, ~delay);
~yyy.set(\outBus, ~delay);

s.queryAllNodes;

~mydelay.set(\dtl, 2);

~d2 = Bus.audio(s, 1);
~mydelay2 = Synth.tail(nil, \delaylama, [\inbus, ~d2]);

~yyy.set(\outBus, ~d2);
~zzz = Synth.head(nil, \tailorPlayer, [\bufnum, ~tailors_mono[0].bufnum, \outBus, ~d2]);

~mydelay2.set(\dlt, 0.3);
~twb.do({|in, idx| idx.post; in.postln });

~aaa = Synth(\tailorPlayer, [\bufnum, ~twb[0].bufnum, \rate, 1.7, \outBus, ~delay, \amp, 0.2, \loop, 1]);
~aaa.set(\rate,1.8);
~aaa.set(\loop, 0);
Bus.control(s, 1);
~bbb = Synth(\tailorPlayer, [\bufnum, ~twb[1].bufnum, \rate, 1, \outBus, ~delay, \amp, 0.2, \loop, 1]);
~bbb.set(\loop, 0);
~ccc = Synth(\tailorPlayer, [\bufnum, ~twb[2].bufnum, \rate, 0.1, \outBus, ~delay, \amp, 0.2, \loop, 1]);
~ccc.set(\loop, 0);
~ccc.set(\rate, 0.23);
~ccc.set(\rate, 0.32);
~ccc.set(\loop, 0);

~ddd = Synth(\tailorPlayer, [\bufnum, ~twb[15].bufnum, \rate, 1, \outBus, ~delay, \amp, 0.2, \loop, 1]);
~ddd.set(\rate, 0.3);
~ddd.set(\amp, 0.2);