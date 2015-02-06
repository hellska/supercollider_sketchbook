////////////////////////////////////////////
//////N O R T O N   C O M M A N D E R//////
////////////////////////////////////////////

~simple.value;
~rumble.value;
~randomDelay.value;
~ranDelaySwipe.value;

////////////////////////////////////////////

(
// frq as MIDI value
SynthDef.new(\bassline, {|outBus=0, frq=48, dur=3, amp=0.5|
	var source, filter, env, out;
	source = WhiteNoise.ar(0.8);
	env = EnvGen.ar(Env.perc(attackTime:0.01,releaseTime:dur,curve:-1),doneAction:2);
	filter = RLPF.ar(source, frq.midicps, 4 / frq);
	out = filter.clip(0, 0.5) * env !2;
//	out = filter * env;
	Out.ar(outBus, out * amp)
}).send(s);
// rumble generator
SynthDef.new(\pulseBass, {|outBus=0, frq=48, dur=3, amp=0.5, times=4, att=0.01, dec=0.2, sus=0.5, rel=2.2|
	var source, filter, env, out;
	env = EnvGen.ar(Env.perc(attackTime:att,releaseTime:dur,level:amp,curve:-3),doneAction:2);
	source = Saw.ar(frq.midicps) * Pulse.kr(times, 0.5) !2;
	filter = RLPFD.ar(source, frq.midicps - 15);
	out = filter * env;
	Out.ar(outBus, out * amp)
}).send(s);
//// swipe down synth - mars attack
SynthDef.new(\pulseBass2, {|outBus=0, frq=48, dur=3, amp=0.5, times=4, att=0.01, dec=0.2, sus=0.5, rel=2.2|
	var source, filter, env, out;
	env = EnvGen.ar(Env.perc(attackTime:att,releaseTime:dur,curve:-3),doneAction:2);
	source = Saw.ar(frq.midicps * env) * Pulse.kr(times, 0.5);
	filter = RLPFD.ar(source, frq.midicps - 15);

	out = filter * env !2;
	Out.ar(outBus, out * amp)
}).send(s);
)
///////////// I N I T I A L I Z E   M I D I   D E V I C E ////////////////////
MIDIClient.init;
///////////// C O N N E C T   M I D I   D E V I C E ////////////////////
MIDIIn.connect;
////////// standard delay without rumble
(
~simple = {|status|
MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
~synth1 = "\pulseBass";
~synth2 = "\bassline";
~attenv = Env.adsr(attackTime:0.01,decayTime:0.5,sustainLevel:0.5,releaseTime:1,peakLevel:1,curve:-3).asStream;
~mul = 0.3;
~pmul = 0.3;
~ddur = 2.3;
~noteOn = {arg src, chan, num, vel;
	var pitch, velo;
    pitch = num; //.midicps;
	velo = (vel / 127.0) * 1.5;
	Synth(~synth1, [\frq, pitch, \amp, velo, \outBus, 0]); // ~input]);
//	Synth(~synth2, [\frq, pitch * ~pmul, \amp, velo * ~mul, \dur, ~ddur, \outBus, 0]); //~input]);
};
MIDIIn.addFuncTo(\noteOn, ~noteOn);
};
////////// Synth con rumble background
~rumble = {|status|
MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
// change this variable to select the correct synth
~synth = "\pulseBass";
~synth2 = "\bassline";
~attenv = Env.adsr(attackTime:0.01,decayTime:0.5,sustainLevel:0.5,releaseTime:1,peakLevel:1,curve:-3).asStream;
~mul = 0.3;
~pmul = 0.5;
~ddur = 4.3;
~noteOn = {arg src, chan, num, vel;
	var pitch, velo;
    pitch = num; //.midicps;
	velo = (vel / 127.0) * 1.5;
	Synth(~synth, [\frq, pitch, \amp, velo, \outBus, 0]);
	Synth(~synth2, [\frq, pitch * ~pmul, \amp, velo * ~mul, \dur, ~ddur, \outBus, 0]);
};
MIDIIn.addFuncTo(\noteOn, ~noteOn);
};
~randomDelay = {|status|
// random delay
MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
~synth1 = "\pulseBass";
~synth2 = "\bassline";
~attenv = Env.adsr(attackTime:0.01,decayTime:0.5,sustainLevel:0.5,releaseTime:1,peakLevel:1,curve:-3).asStream;
~mul = 0.3;
~pmul = 0.3;
~ddur = 2.3;
~noteOn = {arg src, chan, num, vel;
	var pitch, velo;
	~times = 100.sum3rand + 0.1;
    pitch = num; //.midicps;
	velo = (vel / 127.0) * 1.2;
	Synth(~synth1, [\frq, pitch, \amp, velo, \outBus, 0, \times, ~times]); // ~input]);
//	Synth(~synth2, [\frq, pitch * ~pmul, \amp, velo * ~mul, \dur, ~ddur, \outBus, 0]); //~input]);
};
MIDIIn.addFuncTo(\noteOn, ~noteOn);
};
~ranDelaySwipe = {|status|
// random delay
MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
~synth1 = "\pulseBass2";
// ~synth2 = "\bassline";
~attenv = Env.adsr(attackTime:0.01,decayTime:0.5,sustainLevel:0.5,releaseTime:1,peakLevel:1,curve:-3).asStream;
~mul = 0.3;
~pmul = 0.3;
~ddur = 2.3;
~noteOn = {arg src, chan, num, vel;
	var pitch, velo;
	~times = 100.sum3rand + 0.1;
    pitch = num; //.midicps;
	velo = (vel / 127.0) * 1.2;
	Synth(~synth1, [\frq, pitch, \amp, velo, \outBus, 0, \times, ~times]); // ~input]);
};
MIDIIn.addFuncTo(\noteOn, ~noteOn);
};
)

