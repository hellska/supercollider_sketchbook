//// soundin
(
SynthDef(\livein, {|inBus=0, outBus=0, amp=1.5, nch = 1, inpanpot=0|
	var source, pan;
	source = SoundIn.ar(inBus, 1); // fixed number of channels
	pan = Pan2.ar(source, inpanpot * 2 - 1); // mappa l'input del joystick e lo normalizza
	Out.ar(outBus, pan * amp)
}).send(s)
)
// simple
(
~liveInput = Synth(\livein, [\inBus, 8, \outBus, ~sampleOut], ~sampleGroup, addAction: \addToHead);
// controllo del panpot
~liveInput.map(\inpanpot, ~panbus);
)
~liveInput.free;
// with tremolo MONOOO MONOOO
(
SynthDef(\livein, {|inBus=6, outBus=6, amp=1, nch = 1, bpm=1|
	var source, tre, tremolo;
	tremolo = bpm / 60;
	source = SoundIn.ar(inBus, 1); // fixed number of channels
	tre = source * SinOsc.ar(tremolo);
	Out.ar(outBus, tre)
}).send(s)
)
/*
~startup_soundin = {
	"Starting default Synths and values mapping.......".postln;
	~pitchshifter = Synth.new(\picthShifter,
		[\inBus, ~pitchBus, \pshift, 2.3, \outBus, ~mute],~efxGroup, addAction: \addToHead);
	~delay = Synth.new(\deldelay,
		[\inBus, ~delayBus, \outBus, ~mute, \delaytime, 0.2],~efxGroup,addAction: \addToTail);
	~compressor = Synth(\compressor, [\inbus, ~compBus], ~efxGroup, \addToTail);
	~mixer = Synth.new(\mixer, [\inBus, ~sampleOut, \outBus, ~compBus],~sampleGroup, addAction: \addToTail);
	~loopmixer = Synth.new(\mixer, [\inBus, ~loopOut, \outBus, ~compBus],~sampleGroup, addAction: \addToTail);
	~startup = false;
	//~pitchshifter.map(\pshift, ~pitchRatio);
	// mapping moved outside startup function, binded to startup execution
};
*/
s.meter;




// with ice pick patch
~liveInput = Synth(\livein );
~liveInput.set(\outBus, 0);
~liveInput.set(\inBus, 0);




~liveInput = Synth(\livein,[\inBus, 0, \outBus, 0] );

j.slots[3].at(0).createBus(s);
~liveInput.map(\inpanpot, j.slots[3].at(0).bus);



s.plotTree;

~playBuff

s.meter;
~liveInput = Synth(\livein, [\outBus, ~sampleOut, \bpm, 120], ~sampleGroup, addAction: \addToHead);
~liveInput.set(\bpm, 360);
~liveInput.set(\bpm, 50);
~liveInput.set(\bpm, 132);
~liveInput.set(\bpm, 190);
~liveInput.set(\bpm, 0);
~liveInput = Synth(\livein, [\bpm, 50 ] );