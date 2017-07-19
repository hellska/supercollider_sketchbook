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



~synth_list = TextField(~loboMain, Rect(80,10,50,22)).focus(true) ;
//v.align_(\center);
~synth_active = TextField(~loboMain, Rect(135,10,220,22))
.string_("Select a Synth");
// keyboard input
~synth_list.keyDownAction_{|i, char|
	char.switch(
		// the functions are in the file: midi_control_functions.scd
		$1, { ~simple.value; ~synth_active.string = "MIDI Func: ~simple"  },
		$2, { ~rumble.value; ~synth_active.string = "MIDI Func: ~rumble" },
		$3, { ~randomDelay.value; ~synth_active.string = "MIDI Func: ~randomDelay" },
		$4, { ~ranDelaySwipe.value; ~synth_active.string = "MIDI Func: ~ranDelaySwipe" },
		$5, { ~particleSin.value; ~synth_active.string = "Synth Selected: ~particleSin" },
		$6, { ~greenGlitch.value; ~synth_active.string = "Synth Selected: ~greenGlitch" },
		$7, { ~rumbledrone.value; ~synth_active.string = "Synth Selected: ~rumbledrone" }
	);
	~synth_list.string = ""
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
	// update the file viewer
	if (~ticViewButton.value == 1) {
		~x3d_updateSoundFile.value(~lobo_CurrentSoundFileList[sbs.value].path.standardizePath);
	};
	// set the sample of x3dlooper if external src is enabled (Button in ~x3dViewer)
	if (~x3d_externalSample.value == 1) {
		~currentSampleNo = 0;
		~playBuff = ~lobo_CurrentSoundFileList[~ticView.value];
		~x3d_updateSoundFile.value(~lobo_CurrentSoundFileList[sbs.value].path.standardizePath);
	};
}).keyDownAction_({|i, char, uni, key|
	if ( key == 13 ) {
		~lobo_CurrentSoundFileList[~ticView.value].play
	}
});
// populate the list with the default soundFile buffer
~setListViewContent.value(~lobo_CurrentSoundFileList);
//~lobo_CurrentSoundFileList = ~lobo_CurrentSoundFileList;
//// List the available sound file lists
~lobo_Popup = PopUpMenu(~loboMain, Rect(280, 38, 150, 22))
.items_(["Drum kit", "Tic Gaber", "900 voices", "Tzunami"])
.action_({|me| me.value.postln;
	switch (me.value,
		0, { ~setListViewContent.value(~bufDrumkit);
			~lobo_CurrentSoundFileList = ~bufDrumkit;
		},
		1, { ~setListViewContent.value(~ticGaber);
			~lobo_CurrentSoundFileList = ~ticGaber;
		},
		2, { ~setListViewContent.value(~mwvoices900);
			~lobo_CurrentSoundFileList = ~mwvoices900;
		},
		3, {  ~setListViewContent.value(~tzunami);
			~lobo_CurrentSoundFileList = ~tzunami;
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
//////////// x3dLooper GUI
~x3d_guiCreator = {|title, parent|

	~x3d_rec_string = "N O T  R E C O R D I N G";

	~x3dView = CompositeView(parent, Rect(80,380,600,200)).background_(Color.new255);
	~x3d_Label = StaticText(~x3dView, Rect(10,0,150,22))
	.string_(title)
	.stringColor_(Color.red);
	~x3d_fileView = SoundFileView(~x3dView, Rect(10,22,350,178))
	.timeCursorOn_(true)
	.timeCursorColor_(Color.red);

	~x3d_externalSample = Button(~x3dView, Rect(390,22,90,20))
	.states_([["Internal src",Color.black,Color.white],
		["External src",Color.black,Color.red]]);
	~x3d_chansetup = Button(~x3dView,Rect(490,22,90,20))
	.states_([
		["Stereo Out",Color.black,Color.gray],
		["4 Channel",Color.black,Color.gray]])
	.action_({|me|
		if (me.value==0){~setup=2; ~sliderDelay=0};
		if (me.value==1){~setup=4; ~sliderDelay=1};
	});

	~x3d_delay_control_button = Button(~x3dView, Rect(390,52,90,20))
	.states_([["Weel 2 delay",Color.black,Color.white],
		["Weel 2 pointer",Color.black,Color.red]])
	.action_({|me|
		case
		{me.value==0} { ~sliderDelay = 0 }
		{me.value==1} { ~sliderDelay = 1 };
	});
	~x3d_loop_control_button = Button(~x3dView, Rect(490,52,90,20))
	.states_([["NO LOOP"],["L O O P",Color.black,Color.red]])
	.action_{|me|
		case
		{me.value==0} { ~loop = 0 }
		{me.value==1} { ~loop = 1 }
	};
	// recording viewer - show if recording and sample number
	~x3d_rec_viewer = StaticText(~x3dView, Rect(400,160,170,30))
	.string_(~x3d_rec_string)
	.backColor_(Color.white)
	.align_(\center);
	// load the default sample file of x3dlooper
	~x3d_soundFile = SoundFile.new;
	~x3d_soundFile.openRead(~currentFile.standardizePath);
	~x3d_fileView.soundfile = ~x3d_soundFile;            // set soundfile
	~x3d_fileView.read(0, ~x3d_soundFile.numFrames);     // read in the entire file.
	~x3d_fileView.refresh;                  // refresh to display the file.
	~x3d_fileView.timeCursorPosition_(~x3d_soundFile.numFrames/2);
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

	};


}; //// end of function ~x3d_guiCreator

//// tap tempo GUI
~tapTempoGuiCreator = {|title,parent|
	~tapTempo_view = CompositeView(parent, Rect(80,590,600,130)); //.background_(Color.red);

	~lastTap = nil;
	~tapTempo = {
		var estim;
        ~lastTap.isNil.if({~lastTap = Main.elapsedTime}, {
            estim = Main.elapsedTime;
			~taptime = estim - ~lastTap;
			~tapbpm = 60 / (estim - ~lastTap);
			~lastTap = estim;
			~tapTempo_text.string_("BPM: "++~tapbpm.round(0.01)++" Time: "++~taptime.round(0.01));
			if (~tapTempo_2Delay.value==1) {
				if (~taptime < 4000) {
					~delTime.set(~taptime)
				}
			}
		})
    };
	~tapTempo_tapButton = Button.new(~tapTempo_view, Rect(10, 10, 300, 100))
	.states_([
		["Press me, or the space bar", Color.black, Color.grey]
	])
    .action_({~tapTempo.value});
	~tapTempo_2Delay = Button.new(~tapTempo_view,Rect(320,10,20,20))
	.states_([
		["x",Color.black,Color.gray],
		["D",Color.black,Color.red]
	]);
	~tapTempo_text = StaticText.new(~tapTempo_view, Rect(320, 50, 200, 30))
    .string_("No tempo")
    .font_(Font("Monaco", 15));


};

~lobo_score = {|title, parent, pcolor|
	~score_main = CompositeView(parent,Rect(690,60,140,700))
	.background_(pcolor);
	~score_label = StaticText(~score_main,Rect(10,0,130,20))
	.string_(title)
	.stringColor_(Color.red);
	~score_text = TextView(~score_main,Rect(10,20,130,200))
	.string_(title+" edit");
/*
	~grainAr[~synthIndex].get(\ratio, {|a| { ~nboxes[0].valueAction_(a)}.defer});
	~grainAr[~synthIndex].get(\dur, {|a| {~nboxes[1].valueAction_(a)}.defer});
	~grainAr[~synthIndex].get(\rate, {|a| {~nboxes[2].valueAction_(a)}.defer});
	~grainAr[~synthIndex].get(\amp, {|a| {~vol.valueAction_(a)}.defer});
	~grainAr[~synthIndex].get(\speed, {|au| {~grain_speed.string_(au)}.defer});
*/

	~score_getSynthValues = Button(~score_main,Rect(10,230,130,20))
	.states_([["Get Synth Values",Color.grey,Color.black]])
	.action_({|me|
		{~score_text.setString(("\n"+~synthIndex),~score_text.string.size)}.defer;
		~grainAr[~synthIndex].get(\ratio,
			{|inget|
				{~score_text.setString((":"+inget),~score_text.string.size)}
				.defer
			}
		);
		~grainAr[~synthIndex].get(\dur,
		{|inget|
				{~score_text.setString((","+inget),~score_text.string.size)}
				.defer
			}
		);
		~grainAr[~synthIndex].get(\rate,
		{|inget|
				{~score_text.setString((","+inget),~score_text.string.size)}
				.defer
			}
		);
		~grainAr[~synthIndex].get(\amp,
		{|inget|
			{~score_text.setString((","+inget),~score_text.string.size)}
			.defer
		}
		);
		~grainAr[~synthIndex].get(\speed,
		{|inget|
			{~score_text.setString((","+inget),~score_text.string.size)}
			.defer
		}
		);


	});
	~score_sample_folder = TextField(~score_main,Rect(10,260,130,20))
	.value_("000000");
	~score_samplef_button = Button(~score_main, Rect(10,290,110,20))
	.states_([["load folder",Color.black,Color.red]])
	.action_({|me|
		var path;
		path = "~/x3dLooper/"++~score_sample_folder.value;
		// ~load_folder.value(~score_sample_folder.value,"aiff");
//		me.value.postln();
		~score_sample_folder.value.postln;
		File.exists(path.standardizePath).if({
			~changeFolder.value(~score_sample_folder.value,"aiff")
			}
			, { "folder does not exists!".postln });
	});
};



~grainbuff_guiCreator.value(3, "GrainBuff", ~loboMain);
~x3d_guiCreator.value("x3d Looper", ~loboMain);
~tapTempoGuiCreator.value("", ~loboMain);
~lobo_score.value("score",~loboMain, Color.black);