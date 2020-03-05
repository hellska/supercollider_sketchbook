Amplitude


(
// use input amplitude to control SinOsc frequency - use headphones to prevent feedback.
{
    SinOsc.ar(
            Amplitude.kr(
                        SoundIn.ar(0),
                        0.01,
                        0.01,
                        1200,
                        400
            ),
            0, 0.3)
}.play;
)

(
{	SinOsc.ar(220) * Amplitude.ar(SoundIn.ar(0)) }.play;
)

(
SynthDef(\ingrain, {|outbus=0, inbus=0, ampscale=4, rate=120, posrate=4, gdur=0.2, buffer=1, position=1, decay=1, panpot= 0|
	var sound, env, pan, out, attenuate;
	//env = EnvGen.ar(Env.perc(0.04, decay, curve: 1), doneAction: 2);
	sound = BufGrain.ar(Impulse.kr(rate), gdur, buffer, pos: SinOsc.kr(posrate) );
	//attenuate = 0.3 * (1-gdur) + 0.01;
	pan = Pan2.ar(sound, panpot);
	out = pan * ( Amplitude.ar(SoundIn.ar(inbus)) * ampscale);
	Out.ar(outbus, out);
}).send(s);
SynthDef(\movegrain, {|outbus=0, rate=120, posrate=4, gdur=0.2, buffer=1, position=1, decay=1, panpot= 0, amp=1|
	var sound, env, pan, out, attenuate;
	//env = EnvGen.ar(Env.perc(0.04, decay, curve: 1), doneAction: 2);
	sound = BufGrain.ar(Impulse.kr(rate), gdur, buffer, pos: SinOsc.kr(posrate) );
	//attenuate = 0.3 * (1-gdur) + 0.01;
	pan = Pan2.ar(sound, panpot);
	out = pan * amp;
	Out.ar(outbus, out);
}).send(s);
)
(
x = Synth.new(\ingrain,
	[
		\outbus, 0,
		\gdur, 0.02,
		\buffer, ~discopatch[6],
		\position, 0,
		\decay, 20,
		\inbus, 21
	]);
)
(
x.set(\ampscale,40); // ottimale
x.set(\buffer, ~discopatch[0]);
)
(
x.set(\ampscale,100); // ottimale
x.set(\buffer, ~discopatch[6]);
)

x.set(\buffer, ~discopatch[3]);
x.set(\buffer, ~discopatch[0]);
x.set(\buffer, ~discopatch[1]);
x.set(\buffer, ~discopatch[2]);
x.set(\buffer, ~discopatch[6]);

x.set(\buffer, ~espeak_out[0]);
x.set(\buffer, ~espeak_out[1]);
x.set(\buffer, ~dark_prayer[0]);
x.set(\buffer, ~dark_prayer[1]);

x.set(\inbus, 21);
x.free;

x.set(\rate, 60);
x.set(\rate, 80);
x.set(\rate, 90);
x.set(\posrate, 3500);

60/120

~saturdaynight[0].play;
x.set(\buffer, ~saturdaynight[94]);
x.set(\buffer, ~saturdaynight[0]);


y = Synth.new(\ingrain,
	[
		\outbus, 0,
		\gdur, 0.02,
		\buffer, ~discopatch[6],
		\position, 0,
		\decay, 20,
		\inbus, 12
	]);
)

~discopatch[6].play;
(
x = Synth.new(\movegrain,
	[
		\outbus, 0,
		\gdur, 0.02,
		\buffer, ~discopatch[6],
		\position, 0,
		\decay, 20,
		\amp, 0.1
	]);
)

x.set(\gdur, 0.8);
x.set(\posrate, 1.01);
x.set(\buffer, ~discopatch[6]);
x.set(\buffer, ~discopatch[3]);
x.set(\buffer, ~discopatch[0]);
x.set(\amp, 0.2);
x.set(\amp, 0.6);
x.set(\amp, 0.7);
x.set(\amp, 0.8);
x.set(\amp, 0.9);

x.set(\inbus, 12);

x.set(\posrate, 0.1);

s.plotTree
x.free

class(~loops[0]);

~loops[0].play;
~loops[0].numChannels;
~discopatch[0].numChannels
~discopatch[3].play

x.free;

Buffer

s.meter;