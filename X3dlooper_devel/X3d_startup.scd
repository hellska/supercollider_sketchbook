(
// Startup for the first release of Ice Pick Experimental Trio
~icePick_startup = {
	//var basepath = "/home/hellska/git-repos/supercollider_sketchbook/linux_icepick/";
	var basepath = "/Users/hellska/hellska/supercollider_sketchbook/X3dlooper_devel/";
	// sound collection
	(basepath++"linux_IP_songsamples.scd").standardizePath.load;
	// synth definitions
	(basepath++"linux_IP_synths_collection.scd").standardizePath.load;
	// MIDI controls
	(basepath++"linux_IP_midi_functions.scd").standardizePath.load;
	// looper functions
	(basepath++"linux_IP_x3dLooper.scd").standardizePath.load;
	// Performance Gui
	(basepath++"linux_IP_x3dLooper_gui.scd").standardizePath.load;
	// Loop Matrix
	(basepath++"linux_x3ds_loopMatrix.scd").standardizePath.load;
	// Joystick mapping & startup execution
	// Starts default synths mixer, effects(pitch Shifter, Delay)
	// (basepath++"linux_IP_logitec_HID_mapping.scd").standardizePath.load;
	// Joystick mapping & startup execution FOR MAC
	// Starts default synths mixer, effects(pitch Shifter, Delay)
	//(basepath++"linux_IP_logitec_HID_mapping.scd").standardizePath.load;
	// "/Users/hellska/hellska/supercollider_sketchbook/mac_icepick/mac_OSCmapping2junxion.scd".standardizePath.load;
	(basepath++"mac_OSCmapping2junxion.scd").standardizePath.load;
};
)
/////////////// Standard patch start ///////////////

~icePick_startup.value();
(
~grainbuff_guiCreator.value(3, "GrainBuff", ~loboMain);
~x3d_guiCreator.value("x3d Looper", ~loboMain);
~tapTempoGuiCreator.value("", ~loboMain);
~lobo_score.value("score",~loboMain, Color.black);
~x3d_loops_matrix_creator.value(~loboMain, 20, 630);
)
~startup_func.value();
~pitchshifter.map(\pshift, ~pitchRatio);
// nano key
MIDIClient.init;
MIDIClient.sources;
MIDIClient.sources[0];
MIDIIn.connect(0, 0);

/////////////// Standard patch start ///////////////




("/Users/hellska/hellska/supercollider_sketchbook/X3dlooper_devel/linux_IP_midi_functions.scd").standardizePath.load;

// La matrice di loop in una finestra separata
~x3d_loops_matrix_creator.value("", 10, 20);
// granulatore in finestra separata
~pulsegrainGui.value(~loboMain, 10, 10);
// rumbledrone duration for the end of duel

~dur=5;
~dur=30;
~dur=240;
s.plotTree;
s.meter;

// imposta il canalel di registrazione
~currentInputSource.postln;
~currentInputSource = 6; // guitar
~currentInputSource = 9; // flute - voice
~currentInputSource = 8;
~currentInputSource = 0; // sp555
~currentInputSource = 2; // dronin
//drone day
~currentInputSource = 6; // tabla
~currentInputSource = 7; // djeridoo
~currentInputSource = 8; // flauto