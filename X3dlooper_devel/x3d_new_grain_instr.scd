~loboMain.bounds

~x3d_play.free;

// #### // Attività fatte

// modifica informazioni sul sample (inserire BPM) v FATTO!!!
// "load folder" permette di caricare cartelle x3dlooper precedenti
//      dal path: /Users/hellska/soundAndSamples/samples/x3dLooper/<FOLDER>

// #### // To DO list

// modifica parametri del pitch shifter
// Normalizzazione dei campion - Usare SoundFile.normalize
// selezione di una parte del campione
//     usando la selezione del mouse
//     usando la rotazione del joystick
// gestoine del volume del LOOPER autonoma



(
var filestr = "/Users/hellska/soundAndSamples/samples/icepicksongsamples/dark_prayer/01-tsunami-_92_viti02.wav".split();
filestr[filestr.size()-1].postln;
)

/*
BufGrain.ar(trigger: 0, dur: 1, sndbuf, rate: 1, pos: 0, interp: 2, mul: 1, add: 0)
Arguments:
trigger: A kr or ar trigger to start a new grain. If ar, grains after the start of the synth are sample accurate. The following args are polled at grain creation time.
dur: Size of the grain.
sndbuf: The buffer holding an audio signal.
rate:	The playback rate of the sampled sound.
pos:	The playback position for the grain to start with (0 is beginning, 1 is end of file).
interp:	The kind of interpolation for the sampled sound in the grain (1 - none, 2 - linear, 4 - cubic).
*/
~playBuff.numFrames/44100
EnvGen.ar(Env.perc(0.04), doneAction: 2)
(
var decay = ~playBuff.numFrames/44100;
l = {
	BufGrain.ar(Impulse.kr(180), 0.4, ~playBuff, pos: (SinOsc.kr(0.1) * 2)-1 ) *
	EnvGen.ar(Env.perc(0.04, ~playBuff.numFrames/44100, curve: -1), doneAction: 2)
}.play;
)
l.free;
s.plotTree

Env.perc(0.04, ~playBuff.numFrames/44100, curve: 8).test.plot;

// #####
~x3d_play.free;

// Play sfruttand ola cetena di effetti x3d con nuvo synht
(
~x3d_play = OSCdef(\play, {|msg, time, addr, port|
	if (msg[1]==1) {
		// var time;
		// time = (~playBuff.numFrames - ~startPos) / 44100;
		// ~play.value(~playBuff, ~startPos, time);
		var decay = ~playBuff.numFrames/44100;
		l = {
//			BufGrain.ar(Impulse.kr(180), 0.4, ~playBuff, pos: (SinOsc.kr(0.1, ~startPos/~playBuff.numFrames) * 2)-1 ) *
			BufGrain.ar(Impulse.kr(180), ~graindur3d, ~playBuff, pos: ~startPos/~playBuff.numFrames ) *
			EnvGen.ar(Env.perc(0.04, ~playBuff.numFrames/44100, curve: -1), doneAction: 2)
		}.play;
	};
},
'/jXcontrol/1'
);
)

(
Synth.new(\x3dgrain,
	[\outbus, ~sampleOut, \gdur, ~graindur3d, \buffer, ~playBuff, \position, ~startPos/~playBuff.numFrames, \decay, ~playBuff.numFrames/44100],
	~sampleGroup, addAction: \addToHead);
)

~x3d_pitchvalue.free

~pitchRatio = Bus.control(s,1);
~minPitch = 0.02;
~mulPitch = 1.5;

(
~x3d_pitchvalue = OSCdef(\pitchvalue, {|msg, time, addr, port|
	~pitchRatio.set(msg[1] * ~mulPitch + ~minPitch);
	~graindur3d = msg[1];
	~graindur3d.postln;
}, '/jXcontrol/zrotation');
)

SynthDef(\x3dgrain, {|outbus=0, rate=180, gdur=0.2, buffer=1, position=1, decay=1, panpot= 0|
	var sound, env, pan, out, attenuate;
	env = EnvGen.ar(Env.perc(0.04, decay, curve: 1), doneAction: 2);
	sound = BufGrain.ar(Impulse.kr(rate), gdur, buffer, pos: SinOsc.kr(position) );
	attenuate = 1 / ( rate / 4 * gdur + 0.0001);
	pan = Pan2.ar(sound, panpot);
	out = pan * env;
	Out.ar(outbus, out * attenuate.clip(0, 1));
}).send(s);

SynthDef(\x3dgrain, {|outbus=0, rate=180, gdur=0.2, buffer=1, position=1, decay=1, panpot= 0|
	var sound, env, pan, out, attenuate;
	env = EnvGen.ar(Env.perc(0.04, decay, curve: 1), doneAction: 2);
	sound = BufGrain.ar(Impulse.kr(rate), gdur, buffer, pos: SinOsc.kr(position + 0.01 * 10) );
	attenuate = 0.3 * (1-gdur) + 0.01;
	pan = Pan2.ar(sound, panpot);
	out = pan * env;
	Out.ar(outbus, out * attenuate.clip(0, 1));
}).send(s);

// ########## E N D    T E S T I N G ###############

(
// BuffGrain synth def per x3dlooper
SynthDef(\x3dgrain, {|outbus=0, rate=180, gdur=0.2, buffer=1, position=1, decay=1, panpot= 0|
	var sound, env, pan, out, attenuate;
	env = EnvGen.ar(Env.perc(0.04, decay, curve: 1), doneAction: 2);
	sound = BufGrain.ar(Impulse.kr(rate), gdur, buffer, pos: SinOsc.kr(position + 0.01 * 10) );
	attenuate = 0.3 * (1-gdur) + 0.01;
	pan = Pan2.ar(sound, panpot);
	out = pan * env;
	Out.ar(outbus, out * attenuate.clip(0, 1));
}).send(s);

~x3d_play.free;
// substitution of play function
~x3d_play = OSCdef(\play, {|msg, time, addr, port|
	var attrate, posit;
	if (msg[1]==1) {
		// var time;
		attrate = 0.8 * ( 1 - ~graindur3d) + 0.1;
		posit = ~startPos/~playBuff.numFrames;
		// time = (~playBuff.numFrames - ~startPos) / 44100;
		// ~play.value(~playBuff, ~startPos, time);
		Synth.new(\x3dgrain,
			[
				\outbus, ~sampleOut,
				\gdur, ~graindur3d,
				\buffer, ~playBuff,
				\position, ~startPos/~playBuff.numFrames,
				\decay, ~grain_decay,
				\panpot, ~panpot
			],
			~sampleGroup, addAction: \addToHead);
		("~grain_decay: "++~grain_decay).postln;
		("~graindur3d: "++~graindur3d).postln;
		//attrate = 1 /  180 / 4 * ~graindur3d;
		("attenuate: "++attrate.clip(0,1).asString()).postln;
		("position: "++posit).postln;
	};
},
'/jXcontrol/1'
);

~x3d_pitchvalue.free;
// map rotation to grain duration of granulizer
~x3d_pitchvalue = OSCdef(\pitchvalue, {|msg, time, addr, port|
	~pitchRatio.set(msg[1] * ~mulPitch + ~minPitch);
	~graindur3d = msg[1] + 0.01;
	~grain_decay = msg[1] * ~playBuff.numFrames/44100 + 1;
	//~graindur3d.postln;
}, '/jXcontrol/zrotation');

)


// ####

s.plotTree

1 / 0.0001

 env = EnvGen.ar(Env.perc(0.04, decay, curve: -1), doneAction: 2);
Env.perc(0.04, 15, curve: 2).plot;