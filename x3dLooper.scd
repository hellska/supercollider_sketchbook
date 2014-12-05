// restart interpreter and quit server
thisProcess.recompile;
// boot the local server
s.boot;
// first of all load all needed Bus and variables [[[ONLY ONCE]]]
(
///////// Global Variables
~startup = true; // turn to false after startup
~currentFolder = "date +\"%Y%m%d\"".unixCmdGetStdOutLines;
~currentFolder = "~/x3dLooper/"++~currentFolder[0]++"/";
~recFile = ~currentFolder++"x3dL_1.aiff";
~stdHeader = ~currentFolder++"x3dL_";
~ext = "aiff";
// check current folder and create a new one for each day session
if ( File.exists(~currentFolder.standardizePath) )
{ ("Folder for sample record: "++~currentFolder).postln }
{ "mkdir ~/x3dLooper/`date +\"%Y%m%d\"`".unixCmd } ;
// defines wich bus are used for audio input
~inch1 = 0;
~inch2 = 6;
// other startup values
~startPos = 0;
~panpot = 0;
~currentSampleNo = 0;
~currentRecNo = 1;
///////// Audio Bus
~input = Bus.audio(s, 1);
~sampleOut = Bus.audio(s, 2);
~pitchBus = Bus.audio(s, 2);
///////// Control Bus
~pitchRatio = Bus.control(s, 1);
///////// Buffers
~recordBuff = Buffer.alloc(s, 65536);
~playBuff = Buffer.read(s, "~/x3dLooper/x3dL_default.aiff".standardizePath, 0);
~currentFile = "~/x3dLooper/x3dL_default.aiff";
)
(
////////////////////////////////////
// SynthDef Definition - \soundinMono, \rec, \play, \picthShifter, \mixer
////////////////////////////////////
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
// this will play it back mono file (default panpot center)
SynthDef(\play, {| outBus = 0, bufnum, start = 0, loop = 0, panpot = 0 |
	var source, out, env, envdur;
	envdur = start / 44100 - 0.06;
	env = Env.asr(attackTime:0.02,sustainLevel:envdur,releaseTime:0.04,curve:\lin);
	source = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), 1, start, loop, doneAction:2);
	out = Pan2.ar(source, panpot) * EnvGen.ar(env);
    Out.ar(outBus, out)
}).send(s);
// Very simple Pitch Shifter
SynthDef.new(\picthShifter, {|inBus, outBus = 0, pshift, pRndVar = 0, trndVar = 0|
	var source, out;
	source = In.ar(inBus, 2);
	out = PitchShift.ar(source, 0.2, pshift, pRndVar, trndVar);
	Out.ar(outBus, out)
}).send(s);
// Otput Mixer for Al Samples
SynthDef.new(\mixer, {|inBus, outBus = 0|
	var source;
	source = In.ar(inBus, 2);
	Out.ar(outBus, source)
}).send(s);
////////////////////////////////////
// Functions - ~play, ~rec, ~stop
////////////////////////////////////
// recording soundin
~rec = {|filein, source|
	i = Synth.new(\soundinMono, [\inBus, source, \outBus, ~input]);
	r = Buffer.alloc(s, 65536, 1);
//	r.write(filein.standardizePath, ~ext, "int16", 0, 0, true);

	r.write(filein.standardizePath, ~ext, "int24", 0, 0, true);
	b = Synth.tail(nil,\rec, [\bufnum, r, \inbus, ~input]);
};
// stop recording soundin
~stop = {
	b.free;
	i.free;
	r.close;
	r.free;
};
~play = {|buffer, startPos|
	Synth.new(\play, [\bufnum, buffer, \start, startPos, \panpot, ~panpot, \outBus, ~sampleOut]);
};
// end of Synth Def
////////////////////////////////////
// Actions trigger - play,rec,stop,samplePosition
////////////////////////////////////

// Joystik controlled looper functions via OSC protocol
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
		// ("play current sample: "++~currentFile).postln
	};
 },
	'/jXcontrol/1'
);
// recording control
OSCdef(\rec, {|msg, time, addr, port|
	if (msg[1]==1){
		~recFile = ~stdHeader++~currentRecNo++"."++~ext;
		~rec.value(~recFile, ~currentInputSource);
		("Recording sample: "++~recFile).postln;
		} {
		~stop.value();
		("Stop Recording sample: "++~recFile).postln;
		if (~currentRecNo<6) { ~currentRecNo = ~currentRecNo + 1 } { ~currentRecNo = 1 };
	};
	},
	'/jXcontrol/2'
);
// Sample start Pos control
OSCdef(\startPos, {|msg, time, addr, port|
	switch (~currentSampleNo)
		{0} { ~startPos = (msg[1] * ~playBuff.numFrames).floor.asInt }
		{1} { ~startPos = (msg[1] * ~playBuff1.numFrames).floor.asInt }
		{2} { ~startPos = (msg[1] * ~playBuff2.numFrames).floor.asInt }
		{3} { ~startPos = (msg[1] * ~playBuff3.numFrames).floor.asInt }
		{4} { ~startPos = (msg[1] * ~playBuff4.numFrames).floor.asInt }
		{5} { ~startPos = (msg[1] * ~playBuff5.numFrames).floor.asInt }
		{6} { ~startPos = (msg[1] * ~playBuff6.numFrames).floor.asInt };
	},
	'/jXcontrol/3'
);
// Sample panpot control
OSCdef(\panpot, {|msg, time, addr, port|
	~panpot = msg[1] * 2 - 1; // change range -1/1
	}, '/jXcontrol/Xaxis'
);
// Pitch Shifter Mapping Function And Range Definition
~minPitch = 0.02;
~mulPitch = 2.5;
OSCdef(\pitch, {|msg, time, addr, port|
	~pitchRatio.set(msg[1] * ~mulPitch + ~minPitch);
}, '/jXcontrol/Zrotation');

// Bus selection for Sample Recording
OSCdef(\inputSource, {|msg, time, addr, port|
	var sourceNo = (msg[1]*127).floor.postln;
	if ((msg[1]*127).floor == 36)
	{ ~currentInputSource = ~inch1; ("Audio source selected: "++~currentInputSource).postln };
	if ((msg[1]*127).floor == 108)
	{ ~currentInputSource = ~inch2; ("Audio source selected: "++~currentInputSource).postln };
	},
	'/jXcontrol/10'
);
////////////////////////////////////
// Functions and OSC def for Sample Selection
////////////////////////////////////
~sampleSelection = {|sampleNo|
	~currentFile = ~stdHeader++sampleNo++"."++~ext;
	~recFile = ~stdHeader++sampleNo++"."++~ext;
	if (File.exists(~currentFile.standardizePath)) {
		("Selected File: "++~currentFile).postln;
	} {
		~currentFile = "~/x3dLooper/x3dL_default.aiff";
		("SAMPLE NOT RECORDED YET! Selected default file: "++~currentFile).postln;
	};
	switch (sampleNo)
		{1} {~playBuff1 = Buffer.read(s, ~currentFile.standardizePath).normalize }
		{2} {~playBuff2 = Buffer.read(s, ~currentFile.standardizePath).normalize }
		{3} {~playBuff3 = Buffer.read(s, ~currentFile.standardizePath).normalize }
		{4} {~playBuff4 = Buffer.read(s, ~currentFile.standardizePath).normalize }
		{5} {~playBuff5 = Buffer.read(s, ~currentFile.standardizePath).normalize }
		{6} {~playBuff6 = Buffer.read(s, ~currentFile.standardizePath).normalize };
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
// perform startup on first clik and fx 1 on/off
OSCdef(\fx1, {|msg, time, addr, port|
	if (~startup) {
		"Starting default Synths and values mapping.......".postln;
		~mixer = Synth.new(\mixer, [\inBus, ~sampleOut], addAction: \addToTail);
		~pitchshifter = Synth.new(\picthShifter, [\inBus, ~pitchBus, \pshift, 2.3], addAction: \addToTail);
		~pitchshifter.map(\pshift, ~pitchRatio);
		~startup = false;
	} {
		if (msg[1]==1) {
			"FX 1 (pitch shifter) off!".postln;
			~mixer.set(\outBus, 0);
		} {
			~mixer.set(\outBus, ~pitchBus);
			"FX 1 (pitch shifter) on!".postln;
		};
	};
}, '/jXcontrol/fx1');
)
// change directory
( // using wav extension
~currentFolder = "~/x3dLooper/industr/"; // the new path
~recFile = ~currentFolder++"x3dL_1.aiff";
~stdHeader = ~currentFolder++"x3dL_";
~stdHeader.postln;
~ext = "wav";
~ext.postln;
)
(
~currentFolder = "~/x3dLooper/20141026/";
~recFile = ~currentFolder++"x3dL_1.aiff";
~stdHeader = ~currentFolder++"x3dL_";
~stdHeader.postln;
~ext = "aiff";
~ext.postln;
)
(
a = ~mixer.nodeID;
~mixer.isPlaying;
~mixer.isRunning;
b = ~frettolo.nodeID;
s.queryAllNodes;
a.isPlaying

NodeWatcher.register(~mixer);

a = Synth.new(\mixer, [\inBus, ~sampleOut], addAction: \addToTail);
b = NodeWatcher.register(a);
a.isRunning;
b.start;