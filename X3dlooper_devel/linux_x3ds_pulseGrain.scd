(
SynthDef(\sgrana, {|outbus=0, bufnu, samples, amp=0.2, trig=3, kappa=5, minrate=0.5, maxrate=1, gate=1, release=0.1, gdur=0.1|
	var source, env, out, cycle, position, myrate;
	env = Env.adsr(0.01, release, 1);
	cycle = SinOsc.ar(trig * (1/kappa));
	position = ( cycle + 1 ) / 2;
	myrate = (cycle + 1 / 2) * (maxrate-minrate) + minrate;
	source = GrainBuf.ar(
		numChannels:1,
		trigger:Impulse.ar(trig),
		dur:gdur,
		sndbuf:bufnu,
		rate: myrate,
		pos:position
	);
	out = EnvGen.ar(env, gate:gate, doneAction:2);
	Out.ar([0,1], source * out * amp)
}).send(s);
///// Control Variables
// ~pg_synth = ();
~pg_synth = Array.newClear(25);
~pg_curr_synth = 0;
~pg_next_synth = 0;
~pg_max_synths = 25;
~pg_sound = ();
~pg_curr_sound = 0;
~pg_mindur = 0.003;
~pg_maxdur = 1.1;
~pg_maxkappa = 333;
~pg_minkappa = 0.01;
///// Special Objects Initialization
~kappaspec = ControlSpec(1, 100, \linear, 1);
~gdurspec = ControlSpec(0.001, 1, \linear, 0.001);

///// G U I
~pulsegrainGui = {|parent, xpos, ypos|
	var pg_mainwin,pg_view,pg_bpm,pg_gdur,pg_kappa,pg_makesynth,pg_soundrag, pg_killall,
	gdurlabel,kappalabel,bpmlabel,kappashow,gdurshow,synthshow,synthlabel,activesynths,
	pg_killMe, pg_volume;
	if (parent == "",
		{
			~pg_mainwin = Window("Pulsegrain").setTopLeftBounds(Rect(xpos,ypos,500,500)).front;

		}, {
			~pg_mainwin = parent;
	});
	pg_view = CompositeView(~pg_mainwin, Rect(xpos,ypos,500,500)).background_(Color.gray);
	pg_bpm = NumberBox(pg_view, Rect(10,10,40,30))
	.clipLo_(20).clipHi_(680).step_(1).value_(120)
	.action_({|me|
		var trigFreq = me.value / 60.0;
		// ("New Trig:"++trigFreq).postln;
		~pg_synth[~pg_curr_synth].set(\trig, trigFreq);
	});
	bpmlabel = StaticText(pg_view, Rect(10,40,40,15)).string_("BPM")
	.align_(\center).stringColor_(Color.green); //label
	kappashow = NumberBox(pg_view, Rect(80,10,60,30)).enabled_(false);
	kappalabel = StaticText(pg_view, Rect(80,40,60,15))
	.string_("Kappa").align_(\center).stringColor_(Color.green); //label
	gdurshow = NumberBox(pg_view, Rect(170,10,60,30)).enabled_(false);
	gdurlabel = StaticText(pg_view, Rect(170,40,60,15))
	.string_("Grain Dur").align_(\center).stringColor_(Color.green); //label
	synthshow = NumberBox(pg_view, Rect(260, 10, 40, 30))
	.clipLo_(0).clipHi_(~pg_max_synths).step_(1)
	.action_{|me| ~pg_curr_synth = me.value };
	synthlabel = StaticText(pg_view, Rect(260, 40, 40, 15))
	.string_("Synth").align_(\center).stringColor_(Color.green); //label
	pg_killMe = Button(pg_view, Rect(320, 10, 30, 30))
	.states_([["KM", Color.black, Color.red]])
	.action_({|me|
		//// Stop all synths
		~pg_curr_synth.postln;
		synthshow.value;
		~pg_synth[~pg_curr_synth].set(\gate, 0);
		~pg_synth[~pg_curr_synth] = nil;
		//// reset the counters
		//~pg_synth = ();
	});
	activesynths = StaticText(pg_view, Rect(380, 10, 40, 30))
	.string_('0');
	~pg_fileview = SoundFileView(pg_view, Rect(25,55,450,150)).gridColor_(Color.red).gridOn_(false);
	pg_gdur = Slider(pg_view, Rect(25, 220, 150, 30))
	.action_{|me|
		var odur; // = me.value * ~pg_maxdur + ~pg_mindur;
		odur = ~gdurspec.map(me.value);
		~pg_synth[~pg_curr_synth].set(\gdur, odur);
		gdurshow.value = odur;
	};
	gdurlabel = StaticText(pg_view, Rect(175, 220, 150, 30)).string_("Grain Dur");
	pg_kappa = Slider(pg_view, Rect(25, 260, 150,  30)).step_(0.002)
	.action_{|me|
		var kappa = ~kappaspec.map(me.value).asInt;
		~pg_synth[~pg_curr_synth].set(\kappa, kappa);
		kappashow.value = kappa
	};
	pg_volume = Slider(pg_view, Rect(25, 300, 150, 30)).step_(0.02)
	.action_{|me|
		var pgvol = me.value;
		// ("current volume"+pgvol.asString).postln;
		~pg_synth[~pg_curr_synth].set(\amp, pgvol);
	};

	//
	kappalabel = StaticText(pg_view, Rect(175,260,150,30)).string_("Kappa Cycle");
	~pg_fileview = SoundFileView(pg_view, Rect(25,55,450,150))
	.gridColor_(Color.red).gridOn_(false);
	pg_soundrag = DragSink(pg_view, Rect(25,55,450,150))
	.align_(\center).string_("DRAG SOUND HERE!").backColor_(Color.new255(2,2,2,0.2))
	.receiveDragHandler_({|v|
		var file, buf, soundfile, smpdur, myframes, mysmprate;
		file = View.currentDrag.asString;
		~pg_sound[~pg_curr_sound] = Buffer.readChannel(s, file, channels: 0);
		~pg_fileview.soundfile = ~pg_sound[~pg_curr_sound];
		~pg_fileview.read(0, ~pg_sound[~pg_curr_sound].numFrames).refresh;
		// not working ... WHY?!?!?
		// myframes = ~pg_sound[~pg_curr_sound-1].numFrames.asInt;
		// mysmprate = ~pg_sound[~pg_curr_sound-1].sampleRate.asInt;
		// smpdur = myframes  / mysmprate;
		// ~gdurspec.maxval = smpdur;
		~gdurspec.maxval = ~pg_sound[~pg_curr_sound].numFrames / ~pg_sound[~pg_curr_sound].sampleRate;
	});
	// Buttons at the end because needs most of the other values
	pg_makesynth = Button(pg_view, Rect(405,220,70,70))
	.states_([["CREATE"]])
	.action_{|me|
		// TODO use ~pg_curr_synth
		var kappas = ~kappaspec.map(pg_kappa.value).asInt;
		var odurs = ~gdurspec.map(pg_gdur.value);
		"### NEW SYNTH with values".postln;
		pg_bpm.value.postln;
		kappas.postln;
		odurs.postln;
		~pg_synth[~pg_next_synth] = Synth.new(\sgrana, [
			\bufnu, ~pg_sound[~pg_curr_sound],
			\trig, pg_bpm.value / 60.0,
			\kappa, kappas,
			\gdur, odurs
		]);
		~pg_next_synth = ~pg_next_synth + 1;
		activesynths.string = ~pg_next_synth;
	};
	// kill all synths
	pg_killall = Button(pg_view, Rect(25, 340, 150, 30))
	.states_([["KILL ALL", Color.black, Color.red]])
	.action_({|me|
		//// Stop all synths
		~pg_synth.size.do{|me| me.postln; ~pg_synth[me].set(\gate, 0)};
		//// reset the counters
		//~pg_synth = ();
		~pg_curr_synth = 0;
		~pg_next_synth = 0;
	});
	// set default values
	pg_kappa.value_(~kappaspec.unmap(4));
	kappashow.value_(4);
	pg_gdur.value_(~gdurspec.unmap(0.4));
	gdurshow.value_(0.4);
	// synthshow.value_(~pg_synth.size);
};
///// Functions
~pg_showFile = {|buffer|
	// filename
	buffer.path.postln;
	// file length
	(buffer.numFrames / buffer.sampleRate).asStringPrec(3).postln;
	~pg_fileview.soundfile = buffer;
	~pg_fileview.read(0, buffer.numFrames).refresh;
};

) // THE END

/*
~xxx = SoundFile(~filename);
~xxx.numChannels

~filename = "/Volumes/ssdData/soundsAndSamples/900-bla/avantieindrio.wav"
~pg_sound[~pg_curr_sound] = Buffer.readChannel(s, ~filename.standardizePath, channels: 1);
~pg_showFile.value(f);
f.play
~pg_showFile.value(~pg_sound[~pg_curr_sound]);


~pg_sound[~pg_curr_sound].play;

//////// CREATING

~pg_kappa2 = Slider(~pg_mainwin, Rect(25, 300, 150,  30)).step_(0.002)
.action_{|me| var kappa = ~kappaspec.map(me.value).asInt.postln ; ~pg_synth[~pg_curr_synth].set(\kappa, kappa); };

//////// TESTING
s.meter;

~pg_fileview.gridOn = false;
~pg_fileview.gridResolution ;
~pg_fileview.gridOffset = 0.1;

(f.numFrames / f.sampleRate).asStringPrec(3)

decimals(3);
f.path
Buffer

~pg_fileview.soundfile = f;
~pg_fileview.read(0, f.numFrames);
~pg_fileview.refresh;
~pg_sound[~pg_curr_sound]

~pg_synth.size;
~pg_synth = ();
~pg_synth[0].set(\gate, 0);
~kapparevspec.map(34);
~kappaspec.map(0.83);
4/100
~kappaspec.map(0.9)
~kappaspec.unmap(90)
~gdurspec.range
~gdurspec.clipHi = 23;
~gdurspec.maxval = 23;

//// Stop all synths
~pg_synth.size.do{|me| me.postln; ~pg_synth[me].set(\gate, 0)};
//// reset the counters
~pg_synth = ();
//// Set the range of graindur according to the file length
~gdurspec.maxval = ~pg_sound[~pg_curr_sound].numFrames / ~pg_sound[~pg_curr_sound].sampleRate;

~pg_sound[~pg_curr_sound].frameRate
Buffer
~pg_sound[~pg_curr_sound].play
~pg_curr_synth = 0
~pg_curr_synth
~pg_synth[~pg_curr_synth].set(\gdur, 0.01);
~pg_synth[~pg_curr_synth].set(\maxrate, 0.2);
~pg_synth.size
~pg_synth[~pg_curr_synth].play;

~pg_sound

// sound 202631
*/