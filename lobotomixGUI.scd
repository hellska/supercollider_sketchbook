s.makeGui;
s.meter;
// Function to get file info from a soundfile array
~fileInfo = {|fileNum, sndFileArray|
	~cdur = sndFileArray[fileNum].numFrames/sndFileArray[fileNum].sampleRate;
	("Name: "+sndFileArray[fileNum].path
	+"\nIndex: "+fileNum
	+"\nChannels: "+sndFileArray[fileNum].numChannels
	+"\nSample Rate: "+sndFileArray[fileNum].sampleRate
	+"\nFrames: "+sndFileArray[fileNum].numFrames
	+"\nDur"+(sndFileArray[fileNum].numFrames/sndFileArray[fileNum].sampleRate));
};
// Items from list view for ~bufDrumkit
~setListViewContent = {|buffColl|
	~ticItems = Array.new(buffColl.size);
	buffColl.do({|item, idx|
		//	postln(idx+": "+~bufDrumkit[idx].path);
		~ticItems.add(buffColl[idx].path);
		~ticView.items_(~ticItems)
	});
};
// Set the main window
~loboMain = Window("Lobotomix Controls").setTopLeftBounds(Rect(600,0,840,900)).front ;
~mainVol = s.volume.gui(~loboMain);
v = TextField(~loboMain, Rect(80,10,50,22)).focus(true) ;
//v.align_(\center);
l = TextField(~loboMain, Rect(135,10,220,22)) ;
l.string = "Select a Synth";
// keyboard input
v.keyDownAction_{|i, char|
	char.switch(
		$1, { ~simple.value; l.string = "MIDI Func: ~simple"  },
		$2, { ~rumble.value; l.string = "MIDI Func: ~rumble" },
		$3, { ~randomDelay.value; l.string = "MIDI Func: ~randomDelay" },
		$4, { ~ranDelaySwipe.value; l.string = "MIDI Func: ~ranDelaySwipe" },
		$5, { ~particleSin.value; l.string = "Synth Selected: ~particleSin" },
		$6, { ~greenGlitch.value; l.string = "Synth Selected: ~greenGlitch" },
		$7, { ~rumbledrone.value; l.string = "Synth Selected: ~rumbledrone" }
	);
	v.string = ""
};
//c = ListView(w, rect(5, 30, 50, 22)).items_(["1", "s", "e"]);
~ticLabel = StaticText(~loboMain, Rect(80, 42, 300, 22))
.string_("Lista files in ~Drumkit Buffer");
~ticView = ListView(~loboMain,Rect(80,60,600,100))
    .items_( ~ticItems )
    .background_(Color.white)
    .hiliteColor_(Color.green(alpha:0.6))
    .action_({ arg sbs;
	// [sbs.value, ~ticView.items[sbs.value]].postln; // .value returns the integer
	~info = ~fileInfo.value(sbs.value, ~lobo_CurrentSoundFileList);
	~ticInfo.string = ~info;
	if (~ticViewButton.value == 1) {
		~x3d_updateSoundFile.value(~lobo_CurrentSoundFileList[sbs.value].path.standardizePath);
	};
}).keyDownAction_({|i, char, uni, key|
	if ( key == 13 ) {
		~ticPlay.focus(true)
	}
});
// populate the list with the default soundFile buffer
~setListViewContent.value(~bufDrumkit);
~lobo_CurrentSoundFileList = ~bufDrumkit;
//// List the available sound file lists
~lobo_Popup = PopUpMenu(~loboMain, Rect(280, 38, 150, 22))
.items_(["Drum kit", "Tic Gaber"])
.action_({|me| me.value.postln;
	switch (me.value,
		0, { ~setListViewContent.value(~bufDrumkit);
			~lobo_CurrentSoundFileList = ~bufDrumkit;
		},
		1, { ~setListViewContent.value(~ticGaber);
			~lobo_CurrentSoundFileList = ~ticGaber;
		}
	);
});
//// Create and populate the text view for soundfile info
~ticInfo = TextView(~loboMain, Rect(80, 165, 600, 100))
.string_(~fileInfo.value(~ticView.value, ~lobo_CurrentSoundFileList));
//// This button play sounds from ListView ~ticView
~ticPlay = Button(~loboMain, Rect(600, 70, 50, 22))
.states_([["Play", Color.black, Color.white]])
.action_({arg me;
	~lobo_CurrentSoundFileList[~ticView.value].play;
});
//// Enable/disable the visualization of sounds in SoundFileView
~ticViewButton = Button(~loboMain,Rect(600,98,50,22))
.states_([["View",Color.black,Color.gray],["View",Color.yellow,Color.red]])
.action_({|me|
	switch (me.value,
		0, {~x3d_Label.string_("x3d Looper");
		~x3d_updateSoundFile.value(~currentFile.standardizePath) },
		1, {~x3d_Label.string_("Industrial Drum Kit");
			~x3d_updateSoundFile.value(~lobo_CurrentSoundFileList[~ticView.value].path.standardizePath) }
	);
});
//// Controllo per synth grainBuff (inside a function to cleare and recreate as needed)
~grainbuff_guiCreator = {|el, name, parent|
	~elements = 3;
	~knobs = Array.new(el);
	~nboxes = Array.new(el);
	~newBoxes = Array.new(el);
	~grainGroup = Group.new;
	~grainAr = Array.new(25);
	~grainMax = 25; // massimo numero di synth granulatori contemporanei
	~grainCount = 0; // numero attuale di synth attivi
	~synthIndex = ~grainCount; // current controlled synth
	// set the parent HERE
	~w1	= CompositeView(parent,Rect(80,270,600,200)).background_(Color.rand);
	// create n Knob according to el input value
	el.do({|idx|
		var base,altezza,bordoDestro,bordoSuperiore,orizontalIncr,verticalIncr,xcoord,offset;
		base = 30;
		altezza = 30;
		bordoDestro = 30;
		bordoSuperiore = 5;
		offset = 70;
		xcoord = (bordoDestro + (offset * idx));
		~knobs.add(Knob(~w1, Rect(xcoord, bordoSuperiore, base, altezza)));
		~knobs[idx].action = {|me|
			me.value * 3000 + 30; //
			me.value.postln;
			~nboxes[idx].value_(me.value);
		};
		~knobs[idx].mode = '\vert';
	});
	// create n=el number boxes to show current active synth values
	el.do({|idx|
		var base,altezza,bordoDestro,bordoSuperiore,orizontalIncr,verticalIncr,xcoord,offset;
		base = 60;
		altezza = 30;
		bordoDestro = 30;
		bordoSuperiore = 40;
		offset = 70;
		orizontalIncr = bordoDestro + base;
		verticalIncr = bordoSuperiore + altezza;
		xcoord = (bordoDestro + (offset * idx));
		~nboxes.add(NumberBox(~w1,Rect(xcoord, bordoSuperiore, base, altezza)));
		~nboxes[idx].string_(0.01)
		.clipLo_(0.01)
		.decimals_(10);
	});
	// create n=el number boxes to set the values for new synths
	el.do({|idx|
		var base,altezza,bordoDestro,bordoSuperiore,orizontalIncr,verticalIncr,xcoord,offset;
		base = 60;
		altezza = 30;
		bordoDestro = 30;
		bordoSuperiore = 120;
		offset = 70;
		orizontalIncr = bordoDestro + base;
		verticalIncr = bordoSuperiore + altezza;
		xcoord = (bordoDestro + (offset * idx));
		~newBoxes.add(NumberBox(~w1,Rect(xcoord, bordoSuperiore, base, altezza)));
		~newBoxes[idx].string_(0.01)
		.clipLo_(0.01)
		.decimals_(3);
		//	.action_({|me| me.value });  ////// set the action before to control a variable
	});
	// the master volume slider
	~vol = Slider(~w1, Rect(240,10,25,150))
	.action_({
		~grainAr[~synthIndex].set(\amp, ~vol.value);
	});
	//// N E W   Button ///// Bottoni per aggiunte Synth granulatori
	~newGrainbuff = Button(~w1, Rect(170, 160, 60, 20))
	.states_([["New", Color.black, Color.green]])
	.action_({|act|
		~grainCount = ~grainCount + 1;
		~synthIndex = ~grainCount - 1;
		if ( ~grainCount <= ~grainMax ) {
			switch (~newValues.value,
				0, {~grainAr.add(Synth(\granulaHell,
					[\sndBuf, ~lobo_CurrentSoundFileList[~ticView.value]],
					~grainGroup, \addToHead)
					.onFree({~grainCount = ~grainCount - 1})); },
				1, {~grainAr.add(Synth(\granulaHell,
					[\sndBuf, ~lobo_CurrentSoundFileList[~ticView.value],
					\ratio, ~newBoxes[0].value,
					\dur, ~newBoxes[1].value,
					\rate, ~newBoxes[2].value
					],
					~grainGroup, \addToHead)
					.onFree({~grainCount = ~grainCount - 1}));
			});
			~activeNumberViewer.string_(~synthIndex);
			~smSynt[~synthIndex].value = 1;
			~grainAr[~synthIndex].get(\ratio, {|a| { ~nboxes[0].valueAction_(a)}.defer});
			~grainAr[~synthIndex].get(\dur, {|a| {~nboxes[1].valueAction_(a)}.defer});
			~grainAr[~synthIndex].get(\rate, {|a| {~nboxes[2].valueAction_(a)}.defer});
			~grainAr[~synthIndex].get(\amp, {|a| {~vol.valueAction_(a)}.defer});
			~smSynt[~synthIndex].focus(true);
		};
	});
	//// Stop All Synths with gate (gently stops)
	~stopAll = Button(~w1, Rect(325, 170, 60, 20))
	.states_([["Stop All",Color.black, Color.red]])
	.action_({|act|
		~grainCount.do({|me, idx|
			~grainAr.removeAt(0).set(\gate, 0);
			~smSynt[idx].value_(0);
		});
		~grainAr = Array.new(~grainMax);
		~synthIndex = 0;
		~activeNumberViewer.string_(0);
	});
	//// Standard - Set values //// use standard or set values in number box for synth creation
	~newValues = Button(~w1, Rect(100, 160, 60, 20))
	.states_([["Default", Color.black,Color.gray],["N Boxes",Color.black,Color.red]]);
	//// Show current active synth (index of matrix)
	~activeNumberViewerLabel = StaticText(~w1, Rect(440, 10, 90, 20)).string_("Active Synth");
	~activeNumberViewer = NumberBox(~w1, Rect(440, 35, 60, 60)).string_(0)
	.font_(Font(size:42))
	.align_('\center')
	.action_({|me|
		~synthIndex = me.string.asInt;
		~grainAr[~synthIndex].get(\ratio, {|a| { ~nboxes[0].valueAction_(a)}.defer});
		~grainAr[~synthIndex].get(\dur, {|a| {~nboxes[1].valueAction_(a)}.defer});
		~grainAr[~synthIndex].get(\rate, {|a| {~nboxes[2].valueAction_(a)}.defer});
		~grainAr[~synthIndex].get(\amp, {|a| {~vol.valueAction_(a)}.defer});
		~smSynt[~synthIndex].focus(true);
	});
	// generate the matrix to control the synths
////////////////
////////////////
////////////////
	~synthMatrix = CompositeView(~w1, Rect(275,10,155,155)).background_(Color.cyan);
	~smSynt = Array.new(~grainMax);
	~matrixCols = 5;
	~matrixrows = ~grainMax / ~matrixCols;
	~matrixrows.do({|index|
		~matrixCols.do({|idx|
			var base,altezza,bordoDestro,bordoSuperiore,xcoord,ycoord;
			base = 25;
			altezza = 25;
			bordoDestro = 5;
			bordoSuperiore = 5;
			xcoord = (bordoDestro + (base + bordoDestro * idx));
			ycoord = (bordoSuperiore + (altezza + bordoSuperiore * index));
			~grainMax / ~matrixCols;
			~smSynt.add(Button(~synthMatrix,Rect(xcoord,ycoord,base,altezza))
				.states_([
					["I",Color.black,Color.gray],
					["A",Color.black,Color.green],
					["P",Color.black,Color.yellow]
				])
				.focusColor_(Color.red)
				.action_({|act|
					switch (act.value,
						0, {"mando in play".postln;
							~grainAr[idx].set(\amp, 0.7);
							act.value = 1;
							~synthIndex = idx;
							~activeNumberViewer.value_(idx)
						},
						1, {"synth non attivo".postln; act.value = 0},
						2, {"metto in pausa".postln; ~grainAr[idx].set(\amp, 0)}
					);
//				~synthIndex = idx; ~synthIndex.postln;
				})
			);
		});
	});
////////////////
////////////////
////////////////

	// set the knob preferences
	~knobs[0]
	.action_({|me|
		var newval;
		newval = me.value * 2970.0 + 30.0;
		~nboxes[0].value_(newval);
		~grainAr[~synthIndex].set(\ratio, newval);
	})
	.step_(0.001)
	.keystep_(0.0001);
	~nboxes[0]
	.clipHi_(2970.0 + 30.0)
	.action_({|me|
		~grainAr[~synthIndex].set(\ratio, me.value);
		~knobs[0].value_(me.value / me.clipHi);
	});
	~newBoxes[0].clipHi_(2970.0 + 30.0);
	~knobs[1]
	.action_({|me|
		var newval;
		newval = me.value * 1.99 + 0.01;
		~nboxes[1].value_(newval);
		~grainAr[~synthIndex].set(\dur, newval);
	});
	~nboxes[1]
	.clipHi_(1.99 + 0.01)
	.action_({|me|
		~grainAr[~synthIndex].set(\dur, me.value);
		~knobs[1].value_(me.value / me.clipHi);
	});
	~newBoxes[1].clipHi_(1.99 + 0.01);
	~knobs[2]
	.action_({|me|
		var newval;
		newval = me.value * 163.0 - 3.0;
		~nboxes[2].value_(newval);
		~grainAr[~synthIndex].set(\rate, newval);
	})
	.step_(0.001)
	.keystep_(0.001);
	~nboxes[2]
	.clipHi_(163.0 - 3.0)
	.action_({|me|
		~grainAr[~synthIndex].set(\rate, me.value);
		~knobs[2].value_(me.value / me.clipHi);
	});
	~newBoxes[2].clipHi_(163.0 - 3.0);

}; // end of function ~synth_controller

//////////// x3dLooper GUI
~x3d_guiCreator = {|title, parent|

	~x3dView = CompositeView(parent, Rect(80,480,600,200)).background_(Color.new255);
	~x3d_Label = StaticText(~x3dView, Rect(0,0,150,22))
	.string_(title)
	.stringColor_(Color.red);
	~x3d_fileView = SoundFileView(~x3dView, Rect(10,22,300,178))
	.timeCursorOn_(true)
	.timeCursorColor_(Color.red);

	~x3d_soundFile = SoundFile.new;
	~x3d_soundFile.openRead(~currentFile.standardizePath);
	~x3d_fileView.soundfile = ~x3d_soundFile;            // set soundfile
	~x3d_fileView.read(0, ~x3d_soundFile.numFrames);     // read in the entire file.
	~x3d_fileView.refresh;                  // refresh to display the file.
	~x3d_fileView.timeCursorPosition_(~x3d_soundFile.numFrames/2);
	//// control bus to store cursor values
	~cursorBus = Bus.control(s,1);
	//// Synth that writes on control bus - It should be stopped and restarted when soundFile changes
/*
	~cursorPlay = {
		var cursorVal;
		cursorVal = MouseX.kr(0, ~x3d_soundFile.numFrames);
		Out.kr(~cursorBus, cursorVal)
	}.play;
*/
	//// Infinite Routine Coninuous update the cursor position in file viewer
	{
		inf.do{
			~cursorBus.get({ |frame|
				{~x3d_fileView.timeCursorPosition_(frame * ~x3d_soundFile.numFrames)}.defer;
				{~x3d_fileView.refresh}.defer;
			});
			0.02.wait;
		}
	}.fork;
	//// Function that updates the file viewer and restart the cursor process
	~x3d_updateSoundFile = {|filePath|
//		~cursorPlay.free;
		~x3d_soundFile.close;
		~x3d_soundFile = SoundFile.new;
		~x3d_soundFile.openRead(filePath);
		~x3d_fileView.soundfile = ~x3d_soundFile;            // set soundfile
		~x3d_fileView.read(0, ~x3d_soundFile.numFrames);     // read in the entire file.
		~x3d_fileView.refresh;                  // refresh to display the file.
		~x3d_fileView.timeCursorPosition_(~x3d_soundFile.numFrames/2);
/*
		~cursorPlay = {
			var cursorVal;
			cursorVal = MouseX.kr(0, ~x3d_soundFile.numFrames);
			Out.kr(~cursorBus, cursorVal)
		}.play;
*/
	};


}; //// end of function ~x3d_guiCreator

~grainbuff_guiCreator.value(3, "GrainBuff", ~loboMain);
~x3d_guiCreator.value("x3d Looper", ~loboMain);