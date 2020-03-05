(
~icePick_performance = {
	var basepath;
	basepath="/home/hellska/git-repos/IcePick_performance/";
	// joystick controlled looper - OSC messages managed by junXion (STEIM software)
	(basepath++"x3dLooper.scd").standardizePath.load;
	// synth definitions
	(basepath++"hellska_synths.scd").standardizePath.load;
	// MIDI controls
	(basepath++"midi_control_functions.scd").standardizePath.load;
	// load GUI for lobotomix project
	(basepath++"IcePick_GUI.scd").standardizePath.load;
};
)
~icePick_performance.value();