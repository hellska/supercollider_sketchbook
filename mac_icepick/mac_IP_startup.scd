(
// Startup for the first release of Ice Pick Experimental Trio
~icePick_startup = {
	//var basepath = "/home/hellska/git-repos/supercollider_sketchbook/linux_icepick/";
	var basepath = "/Users/hellska/hellska/supercollider_sketchbook/linux_icepick/";
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
	// Joystick mapping & startup execution
	// Starts default synths mixer, effects(pitch Shifter, Delay)
	// (basepath++"linux_IP_logitec_HID_mapping.scd").standardizePath.load;
	// Joystick mapping & startup execution FOR MAC
	// Starts default synths mixer, effects(pitch Shifter, Delay)
	//(basepath++"linux_IP_logitec_HID_mapping.scd").standardizePath.load;
	"/Users/hellska/hellska/supercollider_sketchbook/mac_icepick/mac_OSCmapping2junxion.scd".standardizePath.load;
};
)
/////////////// Standard patch start ///////////////
~icePick_startup.value();
~startup_func.value();
~pitchshifter.map(\pshift, ~pitchRatio);
// nano key
MIDIClient.init;
MIDIClient.sources[1];
MIDIIn.connect(0, 1);

// La matrice di loop in una finestra separata
~x3d_loops_matrix_creator.value("", 10, 20);
// granulatore in finestra separata
~pulsegrainGui.value("", 10, 10);
// rumbledrone duration for the end of duel

~dur=5;
~dur=30;
s.plotTree;
s.meter;

// imposta il canalel di registrazione
~currentInputSource.postln;
~currentInputSource = 6; // guitar
~currentInputSource = 9; // flute
~currentInputSource = 0; // sp555
