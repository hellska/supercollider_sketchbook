// start -

(
// arpeggiator with analog style synth
SynthDef(\percthrone, {|outbus=2, amp=0.5, mute=1, freq=220, brate=2, gate=1, atk=0.01, rt=0.4, crv=\lin, res=1, cutoff=880|
	var source, env, out;
	source = PulseDPW.ar(freq, 0.5, 0.1) + SinOscFB.ar(freq/2, mul: 0.1);
	env = EnvGen.ar(Env.perc(atk, rt), gate, doneAction: 2);
	//out = MoogVCF.ar(source, cutoff, res) * env;
	out = LPF.ar(source, cutoff, res) + LPF.ar(source, 440, res) * env;
	Out.ar(outbus, [out, out] * amp * mute)
}).send(s);
)
(
// P A T T E R N
~arp = [0, 3, -3, 5, -5, 3, -2, 7, -1, 6, 0, -5];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(12, 0.8); //[0.1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
~ampseq = Pseq(~amp);
~mute = Array.fill(12, 1); //[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
~muteseq = Pseq(~amp);
~ampProxy = PatternProxy(0);
// ~arpProxy = PatternProxy(Pseq(~arpfrq, inf));
~durProxy = PatternProxy(60/360);
~arpPatt = Pbindef(
	"uno",
	\instrument, \percthrone,
	\freq, Pn(Plazy { ~arpseq }),
	\dur, ~durProxy,
	\amp, Pn(Plazy { ~ampseq }),
	\mute, Pn(Plazy { ~muteseq })
);
)

~arpPatt.stop;
~arpPatt.play;

// cambio
// Filtro del SP-555 - Low Freq Emphasis

( // step 1
~arp = [ 0, 0, 0, 1];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.8) });
~ampseq = Pseq(~amp)
)

// SP-555 Pattern B11

// SP-555 Pattern B11 --> OFF
(
SynthDef.new(\percthrone, {
	| outBus = 2, amp = 0.3, subamp = 0.5, freq = 220, cutoff = 500, limit = 0.2|
	var sourceR, sourceL, env, filter, lowsrc;
	env = EnvGen.ar(Env.perc, doneAction: 2);
	lowsrc = SinOscFB.ar(freq , 1, amp) * SinOsc.kr(6) * env;
	sourceR = Saw.ar(freq, amp / 4) + Saw.ar(freq/2+2, amp / 3) * env;
	sourceL = Saw.ar(freq, amp / 4) + Saw.ar(freq/2, amp / 3) * env;
	filter = LPF.ar([sourceL + lowsrc, sourceR + lowsrc], cutoff);
	Out.ar(outBus, filter * limit)
}).send(s);
)

( // step 2
~arp = [0, 3, -3, 5, -5, 3, -2, 7, -1, 6, 0, -5];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(12, 0.8);
~ampseq = Pseq(~amp);
)

~durProxy.source = 60/(360+180);
~durProxy.source = 60/(200);