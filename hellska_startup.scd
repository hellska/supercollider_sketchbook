// 1
~lobotomix_startup = {
	var basepath;
	basepath="/Volumes/datadisk/hellska/supercollider_sketchbook/";
	// joystick controlled looper - OSC messages managed by junXion (STEIM software)
	(basepath++"x3dLooper.scd").standardizePath.load;
	// synth definition
	(basepath++"grainSynthDefs.scd").standardizePath.load;
	(basepath++"subtractiveSynthetizers.scd").standardizePath.load;
	(basepath++"sound_control_synths.scd").standardizePath.load;
	// MIDI controls
	(basepath++"midi_control_functions.scd").standardizePath.load;
	// load sound files collections
	// (basepath++"soundfilesCollections.scd").standardizePath.load;
	// various functions
	(basepath++"typewriter.scd").standardizePath.load;
	// load GUI for lobotomix project
	(basepath++"lobotomixGUI.scd").standardizePath.load;
};
// 4
~icePick_startup = {
	var basepath;
	basepath="/Volumes/ssdData/GIT_repos_cloned/IcePickSupercollider/";
	// joystick controlled looper - OSC messages managed by junXion (STEIM software)
	(basepath++"x3dLooper.scd").standardizePath.load;
	// synth definitions
	(basepath++"hellska_synths.scd").standardizePath.load;
	// MIDI controls
	(basepath++"midi_control_functions.scd").standardizePath.load;
	// load GUI for lobotomix project
	(basepath++"IcePick_GUI.scd").standardizePath.load;
};
// 5 MUTEK/KLINGTGUT performance, change sample length according to joystick drift position
~x3dSampler_start = {
	var ldir;
	ldir = "/Volumes/ssdData/GIT_repos_cloned/x3dSampler/";
	(ldir++"x3ds_main.scd").standardizePath.load;
	(ldir++"x3ds_loopMatrix.scd").standardizePath.load;
	(ldir++"x3ds_GUI.scd").standardizePath.load;
	(ldir++"x3ds_pulseGrain.scd").standardizePath.load;
	~x3d_guiCreator.value("x3d Looper", ~loboMain);
	~tapTempoGuiCreator.value("", ~loboMain);
	~x3d_loops_matrix_creator.value(~loboMain, 80, 400);
	~x3d_netesGUI.value(~loboMain, 350, 400);
	~pulsegrainGui.value(~loboMain, 350, 400);
	~startup.value();

};
// 2
~simulacrum_startup = {
	var basepath;
	basepath="/Volumes/datadisk/hellska/supercollider_sketchbook/";
	// load files for simulacrum project
	(basepath++"sound_control_OSC.scd").standardizePath.load;
	(basepath++"sound_control_synths.scd").standardizePath.load;
};
// 3
~soundSeed_startup = {
	var basepath = "/Volumes/ssdData/GIT_repos_cloned/SoundSeed/sc_code/";
	(basepath++"sound_seed_main.scd").load;
};


~hellska_startup_gui = {
	var btn1, btn2, btn3, btn4, btn5;
	~hellska_startup_win = Window("S T A R T U P    B U T T O N S").setTopLeftBounds(Rect(0,0,620,100)).front;
	btn1 = Button(~hellska_startup_win, Rect(20,20,100,60))
	.states_([["LOBOTOMIX"],["LOBOTOMIX",Color.black,Color.cyan]])
	.action_{|me| case {me.value==1} { ~lobotomix_startup.value() }};
	btn2 = Button(~hellska_startup_win, Rect(140,20,100,60))
	.states_([["SIMULACRUM"],["SIMULACRUM",Color.black,Color.cyan]])
	.action_{|me| case {me.value==1} { ~simulacrum_startup.value() }};
	btn3 = Button(~hellska_startup_win, Rect(260,20,100,60))
	.states_([["SoundSeed"],["SoundSeed",Color.black,Color.cyan]])
	.action_{|me| case {me.value==1} { ~soundSeed_startup.value() }};
	btn4 = Button(~hellska_startup_win, Rect(380,20,100,60))
	.states_([["ICE PICK"],["ICE PICK",Color.black,Color.cyan]])
	.action_{|me| case {me.value==1} { ~icePick_startup.value() }};
	btn5 = Button(~hellska_startup_win, Rect(500,20,100,60))
	.states_([["X3DSampler"],["X3DSampler",Color.black,Color.cyan]])
	.action_{|me| case {me.value==1} { ~x3dSampler_start.value() }};
};
~hellska_startup_gui.value();