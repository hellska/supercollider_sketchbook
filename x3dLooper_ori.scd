// Use With Junxion Software and the file x3dLoopControl.j4xml
// put the subfolder name you want
~changeFolder.value("industr", "wav");
~changeFolder.value("20141026", "aiff");
~changeFolder.value("20150325", "aiff");
// restart interpreter and quit server
// thisProcess.recompile;
// boot the local server
// s.boot;
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
~mute = Bus.audio(s, 2);
~fxBus = Bus.audio(s, 2);
~fxCount = 0;
~inputVol = 0.9;
///////// Control Bus
~pitchRatio = Bus.control(s, 1);
~delTime = Bus.control(s, 1);
///////// Buffers
~recordBuff = Buffer.alloc(s, 65536);
~currentFile = "~/x3dLooper/x3dL_default.aiff";
~playBuff = Buffer.read(s, ~currentFile.standardizePath, 0);

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
	envdur = start / 44100 - 0.02;
	env = Env.asr(attackTime:0.02,sustainLevel:0.5,releaseTime:envdur,curve:\lin);
	source = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), 1, start, loop, doneAction:2);
	out = Pan2.ar(source, panpot) * EnvGen.ar(env);
    Out.ar(outBus, out)
}).send(s);
// Very simple Pitch Shifter
SynthDef.new(\picthShifter, {|inBus, outBus, pshift, pRndVar = 0, trndVar = 0|
	var source, out;
	source = In.ar(inBus, 2);
	out = PitchShift.ar(source, 0.2, pshift, pRndVar, trndVar);
	Out.ar(outBus, out)
}).send(s);
SynthDef(\deldelay, {|inBus, outBus, repeat = 15, delaytime|
	var source, out;
	source = In.ar(inBus, 2);
	out = CombC.ar(source,maxdelaytime: delaytime + (delaytime/4) , delaytime: delaytime,decaytime: delaytime * repeat);
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
	// comment this to record from a synthdef
	i = Synth.new(\soundinMono, [\inBus, source, \outBus, ~input, \amp, ~inputVol]);
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
	// (msg[1] * ~mulPitch + ~minPitch).postln;
}, '/jXcontrol/Zrotation');
// receive slider values
OSCdef(\deltime, {|msg, time, addr, port|
	~delTime.set(msg[1] * 4 + 0.02);
	// (msg[1] * 4 + 0.02).postln;
}, '/jXcontrol/slider');
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
		~pitchshifter = Synth.new(\picthShifter, [\inBus, ~sampleOut, \pshift, 2.3, \outBus, ~mute], addAction: \addToTail);
		~delay = Synth.new(\deldelay, [\inBus, ~sampleOut, \outBus, ~mute, \delaytime, 0.2], addAction: \addToTail);
		~mixer = Synth.new(\mixer, [\inBus, ~sampleOut], addAction: \addToTail);
		~startup = false;
		~pitchshifter.map(\pshift, ~pitchRatio);
		~fxCount = 0;
	} {
		if (msg[1]==1) {
			~fxCount = ~fxCount - 1;
			if (~fxCount == 0) {
				~mixer.set(\inBus, ~sampleOut);
			};
			~pitchshifter.set(\inBus, ~mute);
			"FX 1 (pitch shifter) off!".postln;
			~fxCount.postln;
		} {
			~fxCount = ~fxCount + 1;
			~mixer.set(\inBus, ~fxBus);
			~pitchshifter.set(\inBus, ~sampleOut, \outBus, ~fxBus);
			"FX 1 (pitch shifter) on!".postln;
			~fxCount.postln;
		};
	};
}, '/jXcontrol/fx1');
// second fx
OSCdef(\fx2, {|msg, time, addr, port|
	if (msg[1]==1) {
		~fxCount = ~fxCount - 1;
		if (~fxCount == 0) {
			~mixer.set(\inBus, ~sampleOut);
		};
		~delay.set(\inBus, ~mute);
		"FX 2 (delay) off!".postln;
		~fxCount.postln;
	} {
		~delay.map(\delaytime, ~delTime);
		~fxCount = ~fxCount + 1;
		~mixer.set(\inBus, ~fxBus);
		~delay.set(\inBus, ~sampleOut, \outBus, ~fxBus);
		"FX 2 (delay) on!".postln;
		~fxCount.postln;
	};
}, '/jXcontrol/fx2');
// select sample folder
~changeFolder = {|folder, ext|
~currentFolder = "~/x3dLooper/"++folder++"/";
~recFile = ~currentFolder++"x3dL_1.aiff";
~stdHeader = ~currentFolder++"x3dL_";
~stdHeader.postln;
~ext = ext;
~ext.postln;
};
)