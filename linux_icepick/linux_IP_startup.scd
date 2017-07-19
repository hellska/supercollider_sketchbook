// Startup for the first release of Ice Pick Experimental Trio
~icePick_startup = {
	var basepath = "/home/hellska/git-repos/supercollider_sketchbook/linux_icepick/";
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
	(basepath++"linux_IP_logitec_HID_mapping.scd").standardizePath.load;
};
// x3dlooper impro
~x3dlooper_startup = {
	var basepath = "/home/hellska/git-repos/supercollider_sketchbook/linux_icepick/";
	// sound collection
	(basepath++"linux_soundAndSamples.scd").standardizePath.load;
	// synth definitions
	(basepath++"linux_IP_synths_collection.scd").standardizePath.load;
	// MIDI controls
	(basepath++"linux_IP_midi_functions.scd").standardizePath.load;
	// looper functions
	(basepath++"linux_x3dLooper_ori_samples.scd").standardizePath.load;
	// Performance Gui
	(basepath++"linux_x3dLooper_gui_impro.scd").standardizePath.load;
	// Joystick mapping & startup execution
	// Starts default synths mixer, effects(pitch Shifter, Delay)
	(basepath++"linux_IP_logitec_HID_mapping.scd").standardizePath.load;
};
~icePick_startup.value();
~x3dlooper_startup.value();