(
SynthDef(\livein, {|inBus=0, outBus=0, amp=1, nch = 1, bpm=1|
	var source, tre, tremolo;
	tremolo = bpm / 60;
	source = SoundIn.ar(inBus, 1); // fixed number of channels
	tre = source * SinOsc.ar(tremolo);
	Out.ar(outBus, tre)
}).send(s)
)
// Test synthdef
~liveInput = Synth(\livein,[\inBus, 0, \outBus, 0] );
~liveInput.set(\bpm, 0);
~liveInput.free;

// Set bpm of tremolo
~liveInput.set(\bpm, 360);
~liveInput.set(\bpm, 50);
~liveInput.set(\bpm, 132);
~liveInput.set(\bpm, 190);
~liveInput.set(\bpm, 0);

// soundin start/stop function
(
~x3dsoundin = {|action|
	if (action == 1,
	{ ~liveInput = Synth(\livein ); },
	{ ~liveInput.free; });
};
)
// TEST THE FUNCTION
~x3dsoundin.value(1);
~x3dsoundin.value(0);

//  soundin BUTTON Run the function throug button in X3d ... gui
(

~soundinaction = Button.new(~loboMain, Rect(500, 630, 100, 30))
.states_([["SoundIn"], ["STOP"]])
.action_({ arg std; std.value.postln; ~x3dsoundin.value(std.value); });
)

~tezt = Window.new("",Rect(0, 0, 340, 80));
~tezt.front;

(
~soundingui = {|parent, x, y|
	// defines all gui object names
	var panel, actionbtn, bpminput, bpmbtn;

	panel = CompositeView(parent, Rect(x, y, 340, 80)).background(Color.black);
	actionbtn = Button.new(panel, Rect(10, 10, 100, 30))
	.states_([["SoundIn"], ["STOP"]])
	.action_({ arg std; std.value.postln; ~x3dsoundin.value(std.value); });
	bpminput = TextView.new(panel, Rect(120, 10, 100, 30));
	bpmbtn = Button.new(panel, Rect(230, 10, 100, 30))
	.states_([["BPM set"]])
	.action_{ var inn;
		"AAAAAAAAAAAAA".postln; bpminput.string.postln;
		inn = bpminput.string;
		if ( inn == "", { "nulla".postln }, { ~liveInput.set(\bpm, bpminput.string.asInteger) });
	};
};
)
~soundingui.value(~loboMain, 300, 630);
~soundingui.value(~tezt, 0, 0);

~liveInput = Synth(\livein, [\outBus, ~sampleOut, \bpm, 120], ~sampleGroup, addAction: \addToHead);