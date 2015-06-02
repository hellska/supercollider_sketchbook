////////////////////////////////////////////
//////N O R T O N   C O M M A N D E R//////
//////////////////////////////////////////
s.meter
// Change Synth and MIDI Func

~simple.value;
~rumble.value;
~randomDelay.value;
~ranDelaySwipe.value;
// N E W !!!
~particleSin.value;
~greenGlitch.value;
~rumbledrone.value;
~dur = 180; // define note duration in seconds for ~rumbledrone
~dur = 30; // default
////////////////////////////////////////////
/////////// L O O P E R ///////////////////

// changel the looper folder
// put the subfolder name you want

~changeFolder.value("industr", "wav"); // self recorded hammers, barrels etc...
~changeFolder.value("industr_01", "wav"); // self recorded hammers, barrels etc...
~changeFolder.value("20141026", "aiff");
~changeFolder.value("20150127", "aiff");
~changeFolder.value("sonicTailors", "aiff"); // italian word from factory workers of Marghera
~changeFolder.value("20150517", "aiff");
~changeFolder.value("prove20150518", "aiff");
~changeFolder.value("pasta_ravel_06", "aiff");
~changeFolder.value("20150520", "aiff");
~changeFolder.value("20150524", "aiff");

// 20150506
~fxCount = 0;
// change input volume
~inputVol = 0.9;
// print current folder
~currentFolder.postln;

////////////////////////////////////////////

// typewriter 80 char per line ;)
~typewriter.start;
~typewriter.stop;

// SoundFile: industrial file collection
~bufDrumkit.size;
~bufDrumkit[34].numFrames;
~bufDrumkit[64].play;

// soundFile for Tic (Giorgio gaber)

~ticGaber.size;
~ticGaber[1].play;

///////////// M I D I //////////////////////////////
MIDIClient.init;
///////////// C O N N E C T   M I D I   D E V I C E ////////////////////
MIDIIn.connect;
MIDIClient.sources;
// Connect and disconnect MIDI devices without removing functions
MIDIIn.connect(0, MIDIClient.sources.at(0));
MIDIIn.disconnect;
