// MTG Party startup
(
MIDIIn.connectAll;
MIDIdef.noteOn(\soundseedF0,
	{|vel, note, ch, ctrl|
		var freq;
		freq = note.midicps;
		~bsfreq = freq;
		{ ~seriebasefreq.value = freq }.defer;
});
~x3ds_start = {
	var ldir;
	ldir = "/Volumes/ssdData/GIT_repos_cloned/x3dSampler/";
	(ldir++"x3ds_collections.scd").standardizePath.load;
	(ldir++"x3ds_main.scd").standardizePath.load;
	(ldir++"x3ds_GUI.scd").standardizePath.load;
	(ldir++"x3ds_loopMatrix.scd").standardizePath.load;
};
~x3ds_start.value();
// ~grainbuff_guiCreator.value(3, "GrainBuff", ~loboMain);
~x3d_guiCreator.value("x3d Looper", ~loboMain);
~tapTempoGuiCreator.value("", ~loboMain);
// ~lobo_score.value("score",~loboMain, Color.black);
// ~x3d_loops_win_maker.value;

// ~x3d_externalSample.value_(1);
)
~taptime / 8
60000 / 120
60000 / 0.04 / 1000
~startup.value();