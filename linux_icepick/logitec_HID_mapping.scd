MIDIClient.init;
MIDIClient.sources[3];
MIDIIn.connect(0, 3);

GeneralHID.buildDeviceList;
// generate the list of HID devices
// d = GeneralHID.deviceList;
// open after manual check
// j = GeneralHID.open(d[4]);
// open by direct search
j = GeneralHID.findBy(1133, 49685, "usb-0000:00:1d.0-1.2/input0");

j = GeneralHID.open(j);
GeneralHID.startEventLoop;
j.caps;

/*
	GeneralHIDSlot(Button, type: 1, id: 297, value: 0) btn 10 (sample 4)
	GeneralHIDSlot(Button, type: 1, id: 293, value: 0) btn 6
	GeneralHIDSlot(Button, type: 1, id: 295, value: 0) btn 8 (sample 2)
    GeneralHIDSlot(Button, type: 1, id: 291, value: 0) btn 4 (loop)
    GeneralHIDSlot(Button, type: 1, id: 294, value: 0) btn 7 (sample 1)
    GeneralHIDSlot(Button, type: 1, id: 288, value: 0) FIRE (PLAY)
	GeneralHIDSlot(Button, type: 1, id: 298, value: 0) btn 11 (sample 5)
	GeneralHIDSlot(Button, type: 1, id: 296, value: 0) btn 9 (sample 3)
	GeneralHIDSlot(Button, type: 1, id: 299, value: 0) btn 12 (sample 6)
    GeneralHIDSlot(Button, type: 1, id: 289, value: 0) btn 2 (RECORD)
    GeneralHIDSlot(Button, type: 1, id: 290, value: 0) btn 3 (delay)
    GeneralHIDSlot(Button, type: 1, id: 292, value: 0) btn 5 (pitch shifter)

	GeneralHIDSlot(Miscellaneous, type: 4, id: 4, value: 0) message send

	GeneralHIDSlot(Syn, type: 0, id: 1, value: 0)
	GeneralHIDSlot(Syn, type: 0, id: 0, value: 0)

	GeneralHIDSlot(Absolute, type: 3, id: 1, value: 0.49657869012708) Y axis
	GeneralHIDSlot(Absolute, type: 3, id: 5, value: 0.50196078431373) turn
	GeneralHIDSlot(Absolute, type: 3, id: 0, value: 0.49657869012708) X axis
	GeneralHIDSlot(Absolute, type: 3, id: 16, value: 0.5) minijoy X axis
	GeneralHIDSlot(Absolute, type: 3, id: 17, value: 0.5) minijoy Y axis
	GeneralHIDSlot(Absolute, type: 3, id: 6, value: 0) levetta
a GeneralHIDDevice
*/

/*
j.debug_(true);
j.debug_(false);
j.info;
j.info.findArgs;

j.slots[1].at(288).action_{|v| v.value.postln; };
j.slots[3].at(5).action_{|v| v.value.postln; };
j.slots[3].at(5).action_{ };
j.slots[3].at(5).freeMsg;
*/

// check joystick input
j.makeGui;
// recording
j.slots[1].at(289).action_{|v|
	if (v.value==1){
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
		//~x3d_rec_string = "R E C O R D E D => "++~currentRecNo;
		//{ ~x3d_rec_viewer.backColor_(Color.white).string_(~x3d_rec_string) }.defer;
	};
};
// playback
j.slots[1].at(288).action_{|v|
	if (v.value==1) {
		var time;
		time = (~playBuff.numFrames - ~startPos) / 44100;
		~play.value(~playBuff, ~startPos, time);
	};
};
// set cursor position with slider
j.slots[3].at(6).action_{|v|
	if (~sliderDelay==0){
		~delTime.set(v.value * ~maxDelTime + 0.02);
	} {
		~startPos = (v.value * ~playBuff.numFrames).floor.asInt;
		~cursorBus.set(v.value);
	}
};
// set cursor position and front/back panpot with Y axis
j.slots[3].at(1).action_{|v|
	if (~sliderDelay==0){
		~startPos = (v.value * ~playBuff.numFrames).floor.asInt;
		~cursorBus.set(v.value);
	};
	~panpotY = (v.value * 2 - 1) * - 1; // change range -1/1
};
// set panpot left/right with X axis
j.slots[3].at(0).action_{|v|
	~panpot = v.value * 2 - 1; // change range -1/1
};
// start pitch shifter
j.slots[1].at(292).action_{|v|
	if (v.value==1) {
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
};
// start/stop delay
j.slots[1].at(290).action_{ |v|
	if (v.value==1) {
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
};
// sample selection
j.slots[1].at(294).action_{|v|
	if (v.value==1) {
		~sampleSelection.value(1);
	}
};
j.slots[1].at(295).action_{|v|
	if (v.value==1) {
		~sampleSelection.value(2);
	}
};
j.slots[1].at(296).action_{|v|
	if (v.value==1) {
		~sampleSelection.value(3);
	}
};
j.slots[1].at(297).action_{|v|
	if (v.value==1) {
		~sampleSelection.value(4);
	}
};
j.slots[1].at(298).action_{|v|
	if (v.value==1) {
		~sampleSelection.value(5);
	}
};
j.slots[1].at(299).action_{|v|
	if (v.value==1) {
		~sampleSelection.value(6);
	}
};
// avvia i synth di default mixer, pitch shifter e delay
~startup_func.value();
// dopo la creazione dei synth altrimenti il map non funziona
j.slots[3].at(5).createBus(s);
~pitchshifter.map(\pshift, j.slots[3].at(5).bus);
// pitch shifter - aggiungere i valori al pitch shifter
~minPitch = 0.02;
~mulPitch = 2.5;

