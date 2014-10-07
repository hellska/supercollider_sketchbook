s.meter;

(
// read input signal
SynthDef.new(\soundinMono, {arg inBus, outBus=0,amp=0.9;
	var source, out;
	source = SoundIn.ar(inBus);
	out = source * amp;
	Out.ar(outBus, out)
}).add;

// this will record to the disk
SynthDef(\rec, {arg bufnum, inbus;
    DiskOut.ar(bufnum, In.ar(inbus,1));
}).send(s);

// this will play it back
SynthDef(\play, {| out = 0, bufnum = 0 |
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction:2)
    )
}).add;
// recording soundin
~rec = {|filein|
	i = Synth.new(\soundinMono, [\inBus, 0]);
	r = Buffer.alloc(s, 65536, 1);
//	r.write("~/diskouttest.aiff".standardizePath, "aiff", "int16", 0, 0, true);
	r.write(filein.standardizePath, "aiff", "int16", 0, 0, true);
	b = Synth.tail(nil,\rec, [\bufnum, r, \inbus, 0]);
};
// stop recording soundin
~stop = {
	b.free;
	i.free;
	r.close;
	r.free;
};
~play = {|filein|
	p = Buffer.read(s, filein.standardizePath, 0, bufnum: 1);
	Synth.new(\play, [\bufnum, p]);
};
)

~rec.value("~/rec/Doll_03.aiff");
~stop.value;
~play.value("~/rec/MaiKo_02.aiff");

s.queryAllNodes;
