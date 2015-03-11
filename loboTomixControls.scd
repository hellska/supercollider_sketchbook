////////////////////////////////////////////
//////N O R T O N   C O M M A N D E R//////
//////////////////////////////////////////

// Change Synth and MIDI Func

~simple.value;
~rumble.value; //mono sistemare
~randomDelay.value;
~ranDelaySwipe.value;
// N E W !!!
~particleSin.value;
~greenGlitch.value;
~rumbledrone.value;
~dur = 180; // define note duration in seconds for ~rumbledrone

////////////////////////////////////////////
/////////// L O O P E R ///////////////////

// changel the looper folder
// put the subfolder name you want

~changeFolder.value("industr", "wav");
~changeFolder.value("industr_01", "wav");
~changeFolder.value("20141026", "aiff");
~changeFolder.value("20150127", "aiff");

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

///////////// M I D I //////////////////////////////
MIDIClient.init;
///////////// C O N N E C T   M I D I   D E V I C E ////////////////////
MIDIIn.connect;
MIDIClient.sources;
// Connect and disconnect MIDI devices without removing functions
MIDIIn.connect(0, MIDIClient.sources.at(0));
MIDIIn.disconnect;

s.meter