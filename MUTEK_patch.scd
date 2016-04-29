(
~single_bus = Bus.audio(s, 1);
~comp_bus = Bus.audio(s, 1);
~fourch_bus = Bus.audio(s, 4);

// granule sintesizer
SynthDef(\sgrana, {|outbus=0, bufnu, samples, amp=1, trig=3, rate=0.5, gate=1, release=0.1,gdur=1|
	var source, env, out;
	env = Env.adsr(0.01, release, amp);
	source = GrainBuf.ar(
		numChannels:1,
		trigger:Impulse.kr(trig),
		dur:gdur,
		sndbuf:bufnu,
		rate:SinOsc.kr(rate)+1,
	    pos:samples*SawDPW.kr(0.6));
	out = EnvGen.ar(env, gate:gate, doneAction:2);
	Out.ar(outbus, source * out)
}).send(s);
// Limiter
SynthDef(\compressor, {
	|inbus, outbus=0,thresh=0.1,slopeb=1,slopea=0.1,ctime=0.01,rtime=0.01|
	var source, out;
	source = In.ar(inbus, 1);
	out = Compander.ar(source, source, thresh, slopeb, slopea, ctime, rtime);
	Out.ar(outbus, out)
}).send(s);
//
SynthDef.new(\spat_move, {|inbus, outbus = 0,xrate=0.1,yrate=0.1|
	var source, out, xpos, ypos;
	source = In.ar(inbus, 1);
	xpos = SinOsc.kr(xrate);
	ypos = SinOsc.kr(yrate);
	out = Pan4.ar(source,xpos,ypos);
	Out.ar(outbus, out)
}).send(s);
// testing
/*
p = Platform.resourceDir +/+ "sounds/a11wlk01.wav";
b = Buffer.read(s, p);
t = Synth(\sgrana, [\bufnu, b])
t.set(\gate, 0);
~play_array[0] = Synth(\sgrana, [\bufnu, b]);
~play_array[0].set(\gate, 0);
~play_array[0] = Synth(\sgrana, [\bufnu, b]);
s.queryAllNodes
s.plotTree
Buffer
*/

// read file from a folder convert to wav mono, normalize (using sox) and load into buffer automatically
~smpllist = Array.newClear(99);
~filelist = Array.newClear(99);
~time = 5;
~scount = 0;
~maxsounds = 99;
~rfc = Routine.new({|inval|
	loop {
		var smpldir, smplpath, smpllist, isnew, wavdir, stdout;
		// isnew = true;
		// smpldir = "/Volumes/ssdData/soundsAndSamples/smplcollection/";
		// web app path
		// smpldir = "/Volumes/ssdData/python_web_dev_virtualenv/first_app/sounds/";
		smpldir = "/Volumes/ssdData/python_web_dev_virtualenv/FreesoundSearch/FreesoundFlaskSearch/sounds/";
		wavdir = "/Volumes/ssdData/soundsAndSamples/convertedwav/";
		smplpath = PathName.new(smpldir);
		// smplpath.files.postln;
		// check the counter for resetting the sounds buffer
		// HERE
		smplpath.filesDo{|file|
			isnew = true;
			~filelist.do{|el idx|
				if (file.fullPath==el) { isnew = false };
			};
			if (isnew) {
				var soxc, soxn;
				~filelist = ~filelist.put(~scount, file.fullPath);
				// comversin mp3 -> wav
				///
				/// change the file names because they does not match the filename check
				///
				soxc = "/opt/local/bin/sox"
				+file.fullPath.postln
				+wavdir++file.fileNameWithoutExtension++".wav channels 1";
				soxc.standardizePath.unixCmdGetStdOut;
				// wait to be sure that the file exists
				0.5.wait;
				// normalize files
				soxn = "/opt/local/bin/sox --norm"
				+wavdir++file.fileNameWithoutExtension++".wav"
				+wavdir++file.fileNameWithoutExtension++"norm.wav";
				// soxn.postln;
				stdout = soxn.standardizePath.unixCmdGetStdOut;
				// wait to be sure that the file exists
				0.5.wait;
				/*
				// Normalized sound and delete the original
				~smpllist = ~smpllist.put(~scount,
					Buffer.read(s,(wavdir++file.fileNameWithoutExtension++"norm.wav").standardizePath,
						action:{ ("read"+wavdir++file.fileNameWithoutExtension++"norm.wav").postln;
							File.delete(wavdir++file.fileNameWithoutExtension++".wav".standardizePath);
					})
					*/
				// non normalized sound
				~smpllist = ~smpllist.put(~scount,
					Buffer.read(s,(wavdir++file.fileNameWithoutExtension++".wav").standardizePath,
						action:{ ("read"+wavdir++file.fileNameWithoutExtension++".wav").postln;
					})
				);
				if (~scount<(~maxsounds-1)) {
					~scount = ~scount + 1;
				} {
					~scount = 0;
					"restart filling the collection!".postln;
				};
			};
		};
		~time.wait;
		~curr_sound = ~scount-1;
	};
});
// Window maker
~fs_loops_win_maker = {

	var loops_height = 100;
	var loops_width = 100;
	var loops_gap = 20;
	var loops_cols = 5;
	var loops_rows = 5;
	var xwin = (loops_gap * (loops_cols+1)) + (loops_width * loops_cols);
	var ywin = (loops_gap * (loops_rows+1)) + (loops_height * loops_rows);
	~fs_loop_number = 25; // the maximum loop number
	~fs_loop_buttons_array = Array.fill(~fs_loop_number,0);
	// GUI Elements
	~fs_loop_viewer_win = Window("Freesound Matrix Player").setTopLeftBounds(Rect(0,0,xwin,ywin + 50)).front;
	~fs_loops_view = CompositeView(~fs_loop_viewer_win, Rect(10,10,xwin,ywin));

	~fs_loop_number.do{|id|
		var row, col, xstart, ystart;
		col = (id%loops_cols);
		row = (id/loops_rows).asInt;
		xstart = (col * (loops_width+ loops_gap)) + loops_gap;
		ystart = (row * (loops_height+ loops_gap)) + loops_gap;
		("Col:"+col+"Row:"+row+"X:"+xstart+"Y:"+ystart).postln;
		~fs_loop_buttons_array.put(id,
			Button(~fs_loops_view,Rect(xstart,ystart,loops_width,loops_height))
			.states_([[id.asString],[id.asString,Color.black,Color.green]])
			.action_{|me|
				case
				{me.value==0} {~play_array[id].free}
			};
		);
	};

	~fs_loops_killall = Button(~fs_loop_viewer_win, Rect(10,ywin + 10,xwin - 20,30))
	.states_([[" K I L L   A L L   L O O P S "]])
	.action_{|me| ~fs_loop_number.do{|el|
		~play_array[el].free;
		{ ~fs_loop_buttons_array[el].value_(0) }.defer;
		};
		~play_array_element = 0;
	};
};
// build the window
~fs_loops_win_maker.value;
// set the sound functions
~curr_sound = ~scount-1;
~curr_sound = 1;
// Preset from Rehearsal
~strig = [6,12,1.5,3,9,23,1.5];
~srate = [6,1,1,1.5,2,2,34];
~sgdur = [0.1,0.4,0.8,1,1.3,0.3,0.1];
~play_array = Array.newClear(25);
~uno = {|idx, trig|
	var mybuf, mySamples;
	idx.postln;
	mybuf = ~smpllist[~curr_sound];
	mySamples = mybuf.numFrames;
	mySamples.postln;
	~play_array[idx] = Synth(\sgrana, [\bufnu, mybuf, \trig, ~strig[idx], \rate, ~srate[idx], \gdur, ~sgdur[idx], \samples, mySamples, \outbus, ~single_bus]);
	{ ~fs_loop_buttons_array[idx].value_(1) }.defer;
};
~due = {|idx|
	var mybuf, mySamples;
	idx.postln;
	mybuf = ~smpllist[~curr_sound];
	mySamples = mybuf.numFrames;
	~play_array[idx] = Synth(\sgrana, [\bufnu, mybuf, \trig, 12, \rate, 1, \gdur, 0.4, \samples, mySamples, \outbus, ~single_bus]);
	{ ~fs_loop_buttons_array[idx].value_(1) }.defer;
};
~tre = {|idx|
	var mybuf, mySamples;
	idx.postln;
	mybuf = ~smpllist[~curr_sound];
	mySamples = mybuf.numFrames;
	~play_array[idx] = Synth(\sgrana, [\bufnu, mybuf, \trig, 1.5, \rate, 1, \gdur, 0.8, \samples, mySamples, \outbus, ~single_bus]);
	{ ~fs_loop_buttons_array[idx].value_(1) }.defer;
};
~qua = {|idx|
	var mybuf, mySamples;
	idx.postln;
	mybuf = ~smpllist[~curr_sound];
	mySamples = mybuf.numFrames;
	~play_array[idx] = Synth(\sgrana, [\bufnu, mybuf, \trig, 3, \rate, 1.5, \gdur, 1, \samples, mySamples]);
	{ ~fs_loop_buttons_array[idx].value_(1) }.defer;
};
~cin = {|idx|
	var mybuf, mySamples;
	idx.postln;
	mybuf = ~smpllist[~curr_sound];
	mySamples = mybuf.numFrames;
	~play_array[idx] = Synth(\sgrana, [\bufnu, mybuf, \trig, 9, \rate, 2, \gdur, 1.3, \samples, mySamples, \outbus, ~single_bus]);
	{ ~fs_loop_buttons_array[idx].value_(1) }.defer;
};
~sei = {|idx|
	var mybuf, mySamples;
	idx.postln;
	mybuf = ~smpllist[~curr_sound];
	mySamples = mybuf.numFrames;
	~play_array[idx] = Synth(\sgrana, [\bufnu, mybuf, \trig, 23, \rate, 2, \gdur, 0.3, \samples, mySamples, \outbus, ~single_bus]);
	{ ~fs_loop_buttons_array[idx].value_(1) }.defer;
};
~set = {|idx|
	var mybuf, mySamples;
	idx.postln;
	mybuf = ~smpllist[~curr_sound];
	mySamples = mybuf.numFrames;
	~play_array[idx] = Synth(\sgrana, [\bufnu, mybuf, \trig, 1.5, \rate, 34, \gdur, 0.1, \samples, mySamples, \outbus, ~single_bus]);
	{ ~fs_loop_buttons_array[idx].value_(1) }.defer;
};
// start routine to read files
~rfc.play;


)
(
MIDIClient.init;
MIDIIn.connect(0, MIDIClient.sources[2]); MIDIClient.sources[2];
)
(
MIDIIn.removeFuncFrom(\noteOn, ~patPlay);
~patPlay = {|src ,chan, val|
	val.postln;
	case
	{ val == 60 } { ~play_array[0].set(\gate,0); ~uno.value(0) }
	{ val == 62 } { ~play_array[0].set(\gate,0); { ~fs_loop_buttons_array[0].value_(0) }.defer; }
	{ val == 64 } { ~play_array[1].set(\gate,0); ~uno.value(1) }
	{ val == 65 } { ~play_array[1].set(\gate,0); { ~fs_loop_buttons_array[1].value_(0) }.defer; }
	{ val == 67 } { ~play_array[2].set(\gate,0); ~uno.value(2) }
	{ val == 69 } { ~play_array[2].set(\gate,0); { ~fs_loop_buttons_array[2].value_(0) }.defer; }
	{ val == 71 } { ~play_array[3].set(\gate,0); ~uno.value(3) }
	{ val == 72 } { ~play_array[3].set(\gate,0); { ~fs_loop_buttons_array[3].value_(0) }.defer; }
	{ val == 74 } { ~play_array[4].set(\gate,0); ~uno.value(4) }
	{ val == 76 } { ~play_array[4].set(\gate,0); { ~fs_loop_buttons_array[4].value_(0) }.defer; }
	{ val == 77 } { ~play_array[5].set(\gate,0); ~uno.value(5) }
	{ val == 79 } { ~play_array[5].set(\gate,0); { ~fs_loop_buttons_array[5].value_(0) }.defer; }
	{ val == 81 } { ~play_array[6].set(\gate,0); ~uno.value(6) }
	{ val == 83 } { ~play_array[6].set(\gate,0); { ~fs_loop_buttons_array[6].value_(0) }.defer; }
	;
};
MIDIIn.addFuncTo(\noteOn, ~patPlay);
)


~mutek_spat = Synth(\spat_move, [\inbus, ~comp_bus], addAction:'addToTail');
~compressor = Synth(\compressor, [\inbus, ~single_bus, \outbus, ~comp_bus]);
s.meter;
s.plotTree;

~compressor.set(\outbus, ~comp_bus);
// Original
~strig = [6,12,1.5,3,9,23,1.5];
~srate = [6,1,1,1.5,2,2,34];
~sgdur = [0.1,0.4,0.8,1,1.3,0.3,0.1];
//
~strig = [2,6,5,4,5,5,1];
~srate = [1,1,5,1,1,6,3];
~sgdur = [0.6,0.1,0.2,0.4,0.4,0.1,0.5];
//


~strig = [0.1,];
~srate = [2,];
~sgdur = [0.1,];
~mutek_spat.set(\xrate, 0.9)
~mutek_spat.set(\yrate, 0.32)

~curr_sound = ~scount-1;
~curr_sound = 5;
~compressor.set(\thresh, 0.1);
~compressor.free;
~scount-1;
~rfc.stop
~rfc.free
MIDIClient.sources[2]

~curr_sound = 23;
~smpllist[~curr_sound];
~curr_sound.postln;