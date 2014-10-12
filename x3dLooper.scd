// NEXT STEP CONTROL RECORDING SAMPLE SEPARATELY FROM PLAY SAMPLE!!!!!!



// first of all load all needed Bus ONLY ONCE
(
~input = Bus.audio(s, 1);
~startPos = 0;
~recordBuff = Buffer.alloc(s, 65536);
~playBuff = Buffer.read(s, "~/x3dLooper/x3dL_default.aiff".standardizePath, 0);
~currentFile = "~/x3dLooper/x3dL_default.aiff";
~recFile = "~/x3dLooper/x3dL_1.aiff";
~stdHeader = "~/x3dLooper/x3dL_";
~currentSampleNo = 0;
~currentRecNo = 1;
///)
///(
// read input signal
SynthDef.new(\soundinMono, {arg inBus, outBus=0,amp=0.9;
	var source, out;
	source = SoundIn.ar(inBus);
	out = source * amp;
	Out.ar(outBus, out)
}).send(s);

// this will record to the disk
SynthDef(\rec, {arg bufnum, inbus;
    DiskOut.ar(bufnum, In.ar(inbus,1));
}).send(s);

// this will play it back
SynthDef(\play, {| out = 0, bufnum, start = 0, loop = 0 |
	var source;
	source = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), 1, start, loop, doneAction:2);
    Out.ar(out, source)
}).send(s);
// recording soundin
~rec = {|filein, source|
	i = Synth.new(\soundinMono, [\inBus, 0, \outBus, ~input]);
	r = Buffer.alloc(s, 65536, 1);
	r.write(filein.standardizePath, "aiff", "int16", 0, 0, true);
	b = Synth.tail(nil,\rec, [\bufnum, r, \inbus, source]);
};
// stop recording soundin
~stop = {
	b.free;
	i.free;
	r.close;
	r.free;
};
~play = {|buffer, startPos|
	Synth.new(\play, [\bufnum, buffer, \start, startPos]);
};
// end of Synth Def
////////////////////////////////////
// Actions trigger - play,rec,stop,samplePosition
////////////////////////////////////

// Joystik controlled looper functions via OSc protocol
OSCdef(\play, {|msg, time, addr, port|
	if (msg[1]==1) {
//		~play.value(~playBuff, ~startPos);
		switch (~currentSampleNo)
		{0} { ~play.value(~playBuff, ~startPos) }
		{1} { ~play.value(~playBuff1, ~startPos) }
		{2} { ~play.value(~playBuff2, ~startPos) }
		{3} { ~play.value(~playBuff3, ~startPos) }
		{4} { ~play.value(~playBuff4, ~startPos) }
		{5} { ~play.value(~playBuff5, ~startPos) }
		{6} { ~play.value(~playBuff6, ~startPos) };
		("play current sample: "++~currentFile).postln
	};
 },
	'/jXcontrol/1'
);
OSCdef(\rec, {|msg, time, addr, port|
	if (msg[1]==1){
		~recFile = ~stdHeader++~currentRecNo++".aiff";
		~rec.value(~recFile, ~input);
		("Recording sample: "++~recFile).postln;
		} {
		~stop.value();
		"Stop Recording sample: ".postln;
		if (~currentRecNo<6) { ~currentRecNo = ~currentRecNo + 1 } { ~currentRecNo = 1 };
	};
	},
	'/jXcontrol/2'
);
OSCdef(\startPos, {|msg, time, addr, port|
	~startPos = (msg[1] * ~playBuff.numFrames).floor.asInt },
	'/jXcontrol/3'
);
////////////////////////////////////
// Functions and OSC def for Sample Selection
////////////////////////////////////
~sampleSelection = {|sampleNo|
	~currentFile = ~stdHeader++sampleNo++".aiff";
	~recFile = ~stdHeader++sampleNo++".aiff";
	if (File.exists(~currentFile.standardizePath)) {
		("Selected File: "++~currentFile).postln;
	} {
		~currentFile = "~/x3dLooper/x3dL_default.aiff";
		("SAMPLE NOT RECORDED YET! Selected default file: "++~currentFile).postln;
	};
	switch (sampleNo)
		{1} {~playBuff1 = Buffer.read(s, ~currentFile.standardizePath) }
		{2} {~playBuff2 = Buffer.read(s, ~currentFile.standardizePath) }
		{3} {~playBuff3 = Buffer.read(s, ~currentFile.standardizePath) }
		{4} {~playBuff4 = Buffer.read(s, ~currentFile.standardizePath) }
		{5} {~playBuff5 = Buffer.read(s, ~currentFile.standardizePath) }
		{6} {~playBuff6 = Buffer.read(s, ~currentFile.standardizePath) };
	~currentSampleNo = sampleNo;
};

OSCdef(\selsample1, {|msg, time, addr, port|
	// transform message input into toggle ;)
	if (msg[1]!=0) {
		~sampleSelection.value(1);
	} },
	'/jXcontrol/4'
);
OSCdef(\selsample2, {|msg, time, addr, port|
	// transform message input into toggle ;)
	if (msg[1]!=0) {
		~sampleSelection.value(2);
	} },
	'/jXcontrol/5'
);
OSCdef(\selsample3, {|msg, time, addr, port|
	// transform message input into toggle ;)
	if (msg[1]!=0) {
		~sampleSelection.value(3);
	} },
	'/jXcontrol/6'
);
OSCdef(\selsample4, {|msg, time, addr, port|
	// transform message input into toggle ;)
	if (msg[1]!=0) {
		~sampleSelection.value(4);
	} },
	'/jXcontrol/7'
);
OSCdef(\selsample5, {|msg, time, addr, port|
	// transform message input into toggle ;)
	if (msg[1]!=0) {
		~sampleSelection.value(5);
	} },
	'/jXcontrol/8'
);
OSCdef(\selsample6, {|msg, time, addr, port|
	// transform message input into toggle ;)
	if (msg[1]!=0) {
		~sampleSelection.value(6);
	} },
	'/jXcontrol/9'
);
)


////////////////////////////////////
// Debug functions and manual testing
////////////////////////////////////

OSCdef.all.do({|in, idx| in.postln });
OSCdef.freeAll;

File.exists("~/x3dLooper/x3dL_2.aiff".standardizePath);

s.queryAllNodes;

// manual test
~input = Bus.audio(s, ~input);
~rec.value("~/x3dLooper/test1.aiff", ~input);
~stop.value;
~play.value("~/x3dLooper/test1.aiff");
// OSC function to monitor input messages
(
OSCdef(\monitor, {|msg, time, addr, port|
	("Current Value: "++msg[1]).postln;
	("Current time: "++time).postln;
	("Current addr: "++addr).postln;
	("Current port: "++port).postln
	},
	'/jXcontrol/3'
);
)
OSCdef(\monitor).disable;
OSCdef(\monitor).enable;

~startPos.postln;
(
var sampleNo = 1;
~currentFile++sampleNo = ~stdHeader++sampleNo++".aiff";
)
~currentFile.postln;
~currentFile1.postln;

