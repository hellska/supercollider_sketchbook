// sounds from various forders

//~bbpath = "/home/hellska/soundAndSamples/samples/"; LINUX
~bbpath = "/Users/hellska/soundAndSamples/samples/"; // MAC Vivi
//~bufDrumkit = SoundFile.collectIntoBuffers(path: ~bbpath++"Industrial-autoprodotti/*".standardizePath);
//~ticGaber = SoundFile.collectIntoBuffers(~bbpath++"tic_gaber/*".standardizePath);
//~mwvoices900 = SoundFile.collectIntoBuffers(~bbpath++"900-marghera-workers-voices/*".standardizePath);
//~tzunami = SoundFile.collectIntoBuffers(~bbpath++"tzunami/*".standardizePath);
//~blo_samples = SoundFile.collectIntoBuffers(~bbpath++"BLO/*".standardizePath);
~icepicksongspath = ~bbpath++"icepicksongsamples/";
~dark_prayer = SoundFile.collectIntoBuffers(~icepicksongspath++"dark_prayer/*");
~he_was_bad = SoundFile.collectIntoBuffers(~icepicksongspath++"he_was_bad/*");
~duel = SoundFile.collectIntoBuffers(~icepicksongspath++"duel/*");
~irregular = SoundFile.collectIntoBuffers(~icepicksongspath++"irregular/*");
// lithograph
~matrix_ludens = SoundFile.collectIntoBuffers(~bbpath++"matrix_ludens/*");
~espeak_out = SoundFile.collectIntoBuffers(~bbpath++"espeak_out/*");
~loops = SoundFile.collectIntoBuffers(~bbpath++"loops/*");
~berlin = SoundFile.collectIntoBuffers(~bbpath++"berlin/*");
~saturdaynight = SoundFile.collectIntoBuffers(~bbpath++"Industrial-autoprodotti/*");
// default samples
~lobo_CurrentSoundFileList = ~dark_prayer;