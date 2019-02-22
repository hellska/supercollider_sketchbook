// Startup for the first release of Ice Pick Experimental Trio
~icePick_startup = {
	//var basepath = "/home/hellska/git-repos/supercollider_sketchbook/linux_icepick/";
	var basepath = "/Users/viviana/Desktop/DAN/git-repos/supercollider_sketchbook/linux_icepick/";
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
	"/Users/viviana/Desktop/DAN/git-repos/supercollider_sketchbook/mac_icepick/";
};



/////////////// Standard patch start ///////////////
~icePick_startup.value();
("/home/hellska/git-repos/supercollider_sketchbook/linux_icepick/linux_IP_logitec_HID_mapping.scd").standardizePath.load;
// avvia i synth di default mixer, pitch shifter e delay
~startup_func.value();

// dopo la creazione dei synth altrimenti il map non funziona
// j.slots[3].at(5).createBus(s);
// ~pitchshifter.map(\pshift, j.slots[3].at(5).bus);
~pitchshifter.map(\pshift, ~pitchRatio);

// La matrice di loop in una finestra separata
~x3d_loops_matrix_creator.value("", 10, 20);
// granulatore in finestra separata
~pulsegrainGui.value("", 10, 10);
// rumbledrone duration for the end of duel

~dur=5;
s.plotTree;