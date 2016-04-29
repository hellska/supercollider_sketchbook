(
	~hey1 =	{ var idx; idx = ~scount-1; GrainBuf.ar(2,Impulse.kr(3),1,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6)) }.play;
)
(
SynthDef(\sgrana, {|outbus=0, bufnu, samples, trig=3, rate=0.5|
	var source, env, out;
	source = GrainBuf.ar(
		numChannels:2,
		trigger:Impulse.kr(trig),
		dur:1,
		sndbuf:bufnu,
		rate:SinOsc.kr(rate)+1,
	    pos:samples*SawDPW.kr(0.6));
	Out.ar(outbus, source)
}).send(s);
)
(
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
//
SynthDef(\deldelay, {|inBus, outBus, repeat = 15, maxDelTime = 4, delaytime|
	var source, out;
	source = In.ar(inBus, 4);
	out = source + CombC.ar(source,maxdelaytime: maxDelTime, delaytime: delaytime,decaytime: delaytime * repeat);
	Out.ar(outBus, out)
}).send(s);
SynthDef(\compressor, {
	|inbus, outbus = 0, thresh = 1|
	var source, out;
	source = In.ar(inbus, 4);
	out = Compander.ar(source, source, thresh, 1, 0.5, 0.002, 0.01);
	Out.ar(outbus, out)
}).send(s);
// Otput Mixer for Al Samples
SynthDef.new(\mixer, {|inbus, outbus = 0,xpos=0,ypos=0|
	var source, out;
	source = In.ar(inbus, 1);
	out = Pan4.ar(source,xpos,ypos);
	Out.ar(outbus, out)
}).send(s);
SynthDef.new(\spat_move, {|inbus, outbus = 0,xrate=0.1,yrate=0.1|
	var source, out, xpos, ypos;
	source = In.ar(inbus, 1);
	xpos = SinOsc.kr(xrate);
	ypos = SinOsc.kr(yrate);
	out = Pan4.ar(source,xpos,ypos);
	Out.ar(outbus, out)
}).send(s);
)
~single_bus = Bus.audio(s, 1);
~fourch_bus = Bus.audio(s, 4);
// plain mixer
~mutek_mixer = Synth(\mixer, [\inbus, ~single_bus, \outbus, ~fourch_bus]);
// quadrafonic mixer
~mutek_spat = Synth(\spat_move, [\inbus, ~single_bus], addAction:'addToTail');

// movement rate
~mutek_spat.set(\xrate, 0.1);
~mutek_spat.set(\yrate, 13.01);

~mutek_mixer.free;
~smpllist[~scount-1]

(
var mybuf;
mybuf = ~smpllist[~scount-1];
t = Synth(\sgrana, [\bufnu, mybuf, \trig, 6, \rate, 7]);
)
t.free;
~scount
~scount-1;
~curr_sound = ~scount-1;
~curr_sound = 9;
~play_array = Array.newClear(25);
(
~uno = {|idx, trig|
	var mybuf, mySamples;
	idx.postln;
	mybuf = ~smpllist[~curr_sound];
	mySamples = mybuf.numFrames;
	mySamples.postln;
	~play_array[idx] = Synth(\sgrana, [\bufnu, mybuf, \trig, 6, \rate, 6, \gdur, 0.2, \samples, mySamples, \outbus, ~single_bus]);
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
	~play_array[idx] = Synth(\sgrana, [\bufnu, mybuf, \trig, 3, \rate, 1.5, \gdur, 1, \samples, mySamples, \outbus, ~single_bus]);
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
)
MIDIClient.init;
MIDIClient.sources;
MIDIIn.connect(0, MIDIClient.sources[2]); MIDIClient.sources[2];
(
~patPlay = {|src ,chan, val|
	val.postln;
	case
	{ val == 60 } { ~play_array[0].set(\gate,0); ~uno.value(0) }
	{ val == 62 } { ~play_array[0].set(\gate,0); { ~fs_loop_buttons_array[0].value_(0) }.defer; }
	{ val == 64 } { ~play_array[1].set(\gate,0); ~due.value(1) }
	{ val == 65 } { ~play_array[1].set(\gate,0); { ~fs_loop_buttons_array[1].value_(0) }.defer; }
	{ val == 67 } { ~play_array[2].set(\gate,0); ~tre.value(2) }
	{ val == 69 } { ~play_array[2].set(\gate,0); { ~fs_loop_buttons_array[2].value_(0) }.defer; }
	{ val == 71 } { ~play_array[3].set(\gate,0); ~qua.value(3) }
	{ val == 72 } { ~play_array[3].set(\gate,0); { ~fs_loop_buttons_array[3].value_(0) }.defer; }
	{ val == 74 } { ~play_array[4].set(\gate,0); ~cin.value(4) }
	{ val == 76 } { ~play_array[4].set(\gate,0); { ~fs_loop_buttons_array[4].value_(0) }.defer; }
	{ val == 77 } { ~play_array[5].set(\gate,0); ~sei.value(5) }
	{ val == 79 } { ~play_array[5].set(\gate,0); { ~fs_loop_buttons_array[5].value_(0) }.defer; }
	{ val == 81 } { ~play_array[6].set(\gate,0); ~set.value(6) }
	{ val == 83 } { ~play_array[6].set(\gate,0); { ~fs_loop_buttons_array[6].value_(0) }.defer; }
	;
};
~patStop = {|src ,chan, val|
	val.postln;
	case
	{ val == 60 } { ~unos.free }
	{ val == 62 } { ~due.play }
	{ val == 64 } { ~tre.play }
	{ val == 65 } { ~qua.play }
	{ val == 67 } { ~cin.play }
	;
};
)
MIDIIn.addFuncTo(\noteOn, ~patPlay);

MIDIIn.removeFuncFrom(\noteOn, ~patPlay);

MIDIClient.sources[2]
~uno.value
t.free
t.set(\gate,0);
s.queryAllNodes