(
// Joystik controlled looper functions via OSC protocol
OSCdef(\play, {|msg, time, addr, port|
	if (msg[1]==1) {
		var time;
		time = (~playBuff.numFrames - ~startPos) / 44100;
		~play.value(~playBuff, ~startPos, time);
	};
 },
	'/jXcontrol/1'
);
// recording control
OSCdef(\rec, {|msg, time, addr, port|
	if (msg[1]==1){
		~recFile = ~stdHeader++~currentRecNo++"."++~ext;
		~rec.value(~recFile, ~currentInputSource);
		// set GUI
		//~x3d_rec_string = "R E C O R D I N G => "++~currentRecNo;
		//{ ~x3d_rec_viewer.backColor_(Color.red).string_(~x3d_rec_string) }.defer;
		("Recording sample: "++~recFile).postln;
		} {
		~stop.value();
		("Stop Recording sample: "++~recFile).postln;
		if (~currentRecNo<6) { ~currentRecNo = ~currentRecNo + 1 } { ~currentRecNo = 1 };
	};
	},
	'/jXcontrol/2'
);

// live recorded sample selection
OSCdef(\selsample1, {|msg, time, addr, port|
	// transform message input into toggle ;)
	if (msg[1]==1) {
		~sampleSelection.value(1);
	} },
	'/jXcontrol/sample1'
);
OSCdef(\selsample2, {|msg, time, addr, port|
	// transform message input into toggle ;)
	if (msg[1]==1) {
		~sampleSelection.value(2);
	} },
	'/jXcontrol/sample2'
);
OSCdef(\selsample3, {|msg, time, addr, port|
	// transform message input into toggle ;)
	if (msg[1]==1) {
		~sampleSelection.value(3);
	} },
	'/jXcontrol/sample3'
);
OSCdef(\selsample4, {|msg, time, addr, port|
	// transform message input into toggle ;)
	if (msg[1]==1) {
		~sampleSelection.value(4);
	} },
	'/jXcontrol/sample4'
);
OSCdef(\selsample5, {|msg, time, addr, port|
	// transform message input into toggle ;)
	if (msg[1]==1) {
		~sampleSelection.value(5);
	} },
	'/jXcontrol/sample5'
);
OSCdef(\selsample6, {|msg, time, addr, port|
	// transform message input into toggle ;)
	if (msg[1]==1) {
		~sampleSelection.value(6);
	} },
	'/jXcontrol/sample6'
);
// set cursor position with slider
// ~delTime = Bus.control(s,1);
OSCdef(\startPos, {|msg, time, addr, port|
	if (~sliderDelay==0){
		//(msg[1]* ~maxDelTime + 0.02).postln;
		~delTime.set(msg[1] * ~maxDelTime + 0.02);
	} {
		~startPos = (msg[1] * ~playBuff.numFrames).floor.asInt;
		~cursorBus.set(msg[1]);
	}},
	'/jXcontrol/slider'
);
// set cursor position with Y axis
// set panpot Y (4 channel patch) with Y axis
OSCdef(\startPosYaxis, {|msg, time, addr, port|
	if (~sliderDelay==0){
		~startPos = (msg[1] * ~playBuff.numFrames).floor.asInt;
		~cursorBus.set(msg[1]);
	};
	~panpotY = (msg[1] * 2 - 1) * - 1; // change range -1/1
	},
	'/jXcontrol/yaxis'
);
// panpot using X axis value
OSCdef(\panpot, {|msg, time, addr, port|
	~panpot = msg[1] * 2 - 1; // change range -1/1
	}, '/jXcontrol/xaxis'
);
// route samples to pitshifter efx
OSCdef(\pitch, {|msg, time, addr, port|
	if (msg[1]==1) {
		if (~fx1 == 1) {
			~fxCount = ~fxCount - 1;
			if (~fx2 == 0) {
				~mixer.set(\outBus, ~compBus);
			} {
				~mixer.set(\outBus, ~delayBus);
			};
			~pitchshifter.set(\outBus, ~mute);
			"FX 1 (pitch shifter) off!".postln;
			~fxCount.postln;
			~fx1 = 0;
		} {
			~fxCount = ~fxCount + 1;
			// ~mixer.set(\inBus, ~fxBus);
			~mixer.set(\outBus, ~pitchBus);
			if (~fx2==0) {
				~pitchshifter.set(\outBus, ~compBus);
			} {
				~pitchshifter.set(\outBus, ~delayBus);
			};
			"FX 1 (pitch shifter) on!".postln;
			~fxCount.postln;
			~fx1 = 1;
		}
	};
	},
	'/jXcontrol/fx1'
);
// set pitch shifter value using Zrotation
~pitchRatio = Bus.control(s,1);
~minPitch = 0.02;
// ~mulPitch = 2.5;
~mulPitch = 1.5;
OSCdef(\pitchvalue, {|msg, time, addr, port|
	~pitchRatio.set(msg[1] * ~mulPitch + ~minPitch);
}, '/jXcontrol/zrotation');
// map the synthdef to pitch value bus
//~pitchshifter.map(\pshift, ~pitchRatio);
// route samples to delay efx
OSCdef(\delay, {|msg, time, addr, port|
	if (msg[1]==1) {
		if (~fx2==1){
			~fxCount = ~fxCount - 1;
			if (~fx1 == 0) {
				~mixer.set(\outBus, ~compBus);
			} {
				~mixer.set(\outBus, ~pitchBus);
				// change pitchshifter routing here
				~pitchshifter.set(\outBus, ~compBus);
			};
			//~delay.set(\outBus, ~mute);
			"FX 2 (delay) off!".postln;
			~fxCount.postln;
			~fx2 = 0;
		} {
			~delay.map(\delaytime, ~delTime);
			~fxCount = ~fxCount + 1;
			//		~mixer.set(\inBus, ~fxBus);
			if (~fx1==0) {
				~mixer.set(\outBus, ~delayBus);
				~delay.set(\outBus, ~compBus);
			} {
				~pitchshifter.set(\outBus, ~delayBus);
				~delay.set(\outBus, ~compBus);
			};
			"FX 2 (delay) on!".postln;
			~fxCount.postln;
			~fx2 = 1;
		};
	};
	},
	'/jXcontrol/fx2'
);
/////////////////////////////
// fin qui OK
/////////////////////////////





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

/*
// select sample folder
~changeFolder = {|folder, ext|
~currentFolder = "~/x3dLooper/"++folder++"/";
~recFile = ~currentFolder++"x3dL_1.aiff";
~stdHeader = ~currentFolder++"x3dL_";
~stdHeader.postln;
~ext = ext;
~ext.postln;
};
*/
)