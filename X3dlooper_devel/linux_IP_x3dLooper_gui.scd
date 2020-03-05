s.makeGui;
s.meter;
// Function to get file info from a soundfile array
~fileInfo = {|fileNum, sndFileArray|
	var filestr, filedur;
	~cdur = sndFileArray[fileNum].numFrames/sndFileArray[fileNum].sampleRate;
	filestr = sndFileArray[fileNum].path.split();
	filedur = (sndFileArray[fileNum].numFrames/sndFileArray[fileNum].sampleRate);
	(
		"File: "+filestr[filestr.size()-1].quote
		+" - Folder:"+filestr[filestr.size()-2].quote
		+" - Index: "+fileNum.asString.quote
		+"\nChannels: "+sndFileArray[fileNum].numChannels
		+" - Sample Rate: "+sndFileArray[fileNum].sampleRate
		+" - Frames: "+sndFileArray[fileNum].numFrames
		+"\nBPM: "+(60/filedur)
		+" - Dur"+filedur
	);
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
// create the main window
~loboMain = Window("ICE PICK Performance Patch").setTopLeftBounds(Rect(980,0,700,925)).front ;
// main volume import
~mainVol = s.volume.gui(~loboMain);
// synth selection frame~
~synth_list = TextField(~loboMain, Rect(80,10,50,22)).focus(true) ;
//v.align_(\center);
~synth_active = TextField(~loboMain, Rect(135,10,220,22)).string_("Select a Synth");
// keyboard input
~synth_list.keyDownAction_{|i, char|
	char.switch(
		// the functions are in the file: midi_control_functions.scd
		$0, { ~noSynth.value; ~synth_active.string = "NO SYNTH / MIDI OFF"  },
		$1, { ~simple.value; ~synth_active.string = "SYNTH: ~simple"  },
		$2, { ~rumble.value; ~synth_active.string = "SYNTH: ~rumble" },
		$3, { ~randomDelay.value; ~synth_active.string = "SYNTH: ~randomDelay" },
		$4, { ~ranDelaySwipe.value; ~synth_active.string = "SYNTH: ~ranDelaySwipe" },
		$5, { ~particleSin.value; ~synth_active.string = "SYNTH: ~particleSin" },
		$6, { ~greenGlitch.value; ~synth_active.string = "SYNTH: ~greenGlitch" },
		$7, { ~rumbledrone.value; ~synth_active.string = "SYNTH: ~rumbledrone" }
	);
	~synth_list.string = ""
};

// change recording folder
~score_sample_folder = TextField(~loboMain,Rect(375,10,130,22))
.value_(~currentFolderName);
~score_samplef_button = Button(~loboMain, Rect(515,10,110,22))
.states_([["load folder",Color.black,Color.red]])
.action_({|me|
	var path;
	path = "~/soundAndSamples/samples/x3dLooper/"++~score_sample_folder.value;
	~score_sample_folder.value.postln;
	path.postln;
	File.exists(path.standardizePath).if({
		~changeFolder.value(~score_sample_folder.value,"aiff");
		~x3d_recfolderfiles = SoundFile.collectIntoBuffers(path++"/*");
		~setListViewContent.value(~x3d_recfolderfiles);
		~lobo_CurrentSoundFileList = ~x3d_recfolderfiles;
		}
		, { "folder does not exists!".postln });
});
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
//// List the available sound file lists
~lobo_Popup = PopUpMenu(~loboMain, Rect(280, 38, 150, 22))
.items_([
	"He Was Bad",
	"Duel",
	"Irregular",
	"Dark prayer",
	"matrix_ludens",
	"espeak",
	"loops",
	"industrial",
	"berlin",
	"ramples",
	"pighost"
])
.action_({|me| me.value.postln;
	switch (me.value,
		0, { ~setListViewContent.value(~he_was_bad);
			~lobo_CurrentSoundFileList = ~he_was_bad;
		},
		1, { ~setListViewContent.value(~duel);
			~lobo_CurrentSoundFileList = ~duel;
		},
		2, {  ~setListViewContent.value(~irregular);
			~lobo_CurrentSoundFileList = ~irregular;
		},
		3, {  ~setListViewContent.value(~dark_prayer);
			~lobo_CurrentSoundFileList = ~dark_prayer;
		},
		4, {  ~setListViewContent.value(~matrix_ludens);
			~matrix_ludens = SoundFile.collectIntoBuffers(~bbpath++"matrix_ludens/*");
			~lobo_CurrentSoundFileList = ~matrix_ludens;
		},
		5, {  ~setListViewContent.value(~espeak_out);
			~lobo_CurrentSoundFileList = ~espeak_out;
		},
		6, {  ~setListViewContent.value(~loops);
			~loops = SoundFile.collectIntoBuffers(~bbpath++"loops/*");
			~lobo_CurrentSoundFileList = ~loops;
		},
		7, {  ~setListViewContent.value(~berlin);
			~lobo_CurrentSoundFileList = ~berlin;
		},
		8, {  ~setListViewContent.value(~saturdaynight);
			~lobo_CurrentSoundFileList = ~saturdaynight;
		},
		9, { ~setListViewContent.value(~discopatch);
			~lobo_CurrentSoundFileList = ~discopatch;
		},
		10, { ~setListViewContent.value(~pighost);
			~lobo_CurrentSoundFileList = ~pighost;
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

	~x3dView = CompositeView(parent, Rect(80,280,600,200)).background_(Color.new255);
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

	~x3d_pitchshift_control_button = Button(~x3dView, Rect(390, 82, 90, 20))
	.states_([["Pitch OFF"],["Pitch ON", Color.black, Color.red]]);
//	.action_{|me| me.value.postln; ~x3d_pitchshift_control_button.value = me.value};

	~x3d_delay_control_button = Button(~x3dView, Rect(490, 82, 90, 20))
	.states_([["Delay OFF"],["Delay ON", Color.black, Color.red]]);
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
	~tapTempo_view = CompositeView(parent, Rect(80,490,600,130)); //.background_(Color.red);

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
	~tapTempo_timebox = TextView.new(~tapTempo_view, Rect(320, 80, 100, 30));
	~tapTempo_timesend = Button.new(~tapTempo_view, Rect(430, 80, 100, 30))
	.states_([["Set DelTime"]])
	.action_({
		var mtime = 60 / ~tapTempo_timebox.string.asInt;
		~delTime.set(mtime);
		mtime.postln; });
};