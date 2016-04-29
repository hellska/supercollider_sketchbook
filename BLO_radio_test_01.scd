(
SynthDef(\radio_in, {|inbus=0, outbus=0, amp=0.8|
	var source, out;
	source = SoundIn.ar(inbus);
	out = source * amp;
	Out.ar(outbus, out)
}).send(s);
)

~radio = Synth(\radio_in);

s.meter;

s.queryAllNodes

(
SynthDef(\granular_radio, {|inbus, outbus, amp=0.8, gate=1|
	var source, grain, out, pan, env;
	source = In.ar(inbus);
	pan = MouseX.kr(-1, 1);
	env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: 2);
	grain = GrainIn.ar(1, Impulse.kr(32), 1, SoundIn.ar(inbus), pan)
}).send(s)
)

{ GrainIn.ar(1, Impulse.kr(MouseX.kr(4, 40)), MouseY.kr(0.01, 0.5), SoundIn.ar(0), 0) }.play;

{ FreeVerb2.ar(GrainIn.ar(1, Impulse.kr(MouseX.kr(4, 40)), MouseY.kr(0.01, 0.5), SoundIn.ar(0), 0)) }.play;

Ndef(\a).play;
Ndef(\a).fadeTime = 2;

Ndef(\a, { GrainIn.ar(2, Impulse.kr(MouseX.kr(4, 40)), MouseY.kr(0.01, 0.5), SoundIn.ar(0), 0) });
Ndef(\a, { SoundIn.ar(0) });