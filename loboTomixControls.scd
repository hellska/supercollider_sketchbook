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
//
~rumbledrone.value;
~dur = 180; // define note duration in seconds

////////////////////////////////////////////

// changel the looper folder
// put the subfolder name you want
~changeFolder.value("industr", "wav");
~changeFolder.value("20141026", "aiff");
~changeFolder.value("20150127", "aiff");

// change input volume

////////////////////////////////////////////

// start typewriter ;)
~typewriter.start;
~typewriter.stop;

///////////// M I D I //////////////////////////////
MIDIClient.init;
///////////// C O N N E C T   M I D I   D E V I C E ////////////////////
MIDIIn.connect;
MIDIClient.sources;
// Connect and disconnect MIDI devices without removing functions
MIDIIn.connect(0, MIDIClient.sources.at(0));
MIDIIn.disconnect;

s.meter