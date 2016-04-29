///// INITIALIZE MIDI
MIDIClient.init;
MIDIClient.sources;
MIDIIn.connect(0, MIDIClient.sources[2]); MIDIClient.sources[2];

(
SynthDef(\killerLoop, {|outbus=0, amp=1, gate=1, nota=60, notb=64, notc=67, control=1|
	var freqa = AY.freqtotone(nota.midicps);
	var freqb = AY.freqtotone(nota.midicps*(5/4));
	var freqc = AY.freqtotone(nota.midicps*(3/2));
	var env = EnvGen.ar(Env.asr(), gate, doneAction:2);
//	var source = SinOsc.ar(note.midicps, amp);
	var source = AY.ar(Vibrato.kr(freqa, 0.01), Vibrato.kr(freqb, 0.03), Vibrato.kr(freqc, 0.06), control:control);
	var out = source * env;
	Out.ar(outbus, out)
}).send(s);
)

(
~killernotes = Array.newClear(127);
~note_on = {arg src, chan, num, vel;
	var noise = vel / 127 * 31;
//	vel.postln;
//	noise.postln;
	~killernotes[num] =  Synth(\killerLoop, [\nota, num, \noise, noise])};
~note_off = {arg src, chan, num, vel; num.postln;
	~killernotes[num].set(\gate, 0);}
)

(
MIDIIn.addFuncTo(\noteOn, ~note_on);
MIDIIn.addFuncTo(\noteOff, ~note_off);
)

(
//////// REMOVE
MIDIIn.removeFuncFrom(\noteOn, ~note_on);
MIDIIn.removeFuncFrom(\noteOff, ~note_off);
)

~killerLoop = Synth(\killerLoop);
~killerLoop.set(\gate, 0);

