s.meter

SynthDef(\percthrone2, {|outbus=0, amp=0.1, mute=1, freq=220, brate=2, atk=0.01, rt=0.4, crv=\lin, res=0.5, cutoff=440|
	var source, env, out;
	source = PulseDPW.ar(freq, 0.5, 0.1)
	+ SinOscFB.ar(freq/2, mul: 0.1)
	+ SawDPW.ar(freq, mul: 0.1);
	env = EnvGen.ar(Env.perc(atk, rt), doneAction: 2);
	out = MoogVCF.ar(source, cutoff, res) * env;
	Out.ar(outbus, [out, out] * amp * mute)
}).send(s);

(
// P A T T E R N
~arp = [0, 3, -3, 5, -5, 3, -2, 7, -1, 6, 0, -5];
~arpfrq = (~arp + 65).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(12, 0.1); //[0.1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
~ampseq = Pseq(~amp);
~mute = Array.fill(12, 1); //[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
~muteseq = Pseq(~amp);
~ampProxy = PatternProxy(0);
~durProxy = PatternProxy(60/360);
~rtProxy = PatternProxy(Pseq(Array.fill(12, { rrand(0.4,1) }),inf));
// ~arpProxy = PatternProxy(Pseq(~arpfrq, inf));

~arpPatt = Pbindef(
	"uno",
	\instrument, \percthrone2,
	\freq, Pn(Plazy { ~arpseq }),
	\dur, ~durProxy,
	\amp, Pn(Plazy { ~ampseq }),
	\mute, Pn(Plazy { ~muteseq }),
	\rt, ~rtProxy
);
)
~arpPatt.play;
~arpPatt.stop;
~rtProxy.source = Pseq([1.01, 0.01, 0.01, 0.01],inf);
~rtProxy.source = Pseq(Array.fill(12, 1), inf); //stop
( // step 1
~arp = [ 1, 0, 0, 0, 1, 0, 0, 3, 7, 2, 0, 0, 0];
~arpfrq = (~arp + 42).midicps;
~arpseq = Pseq(~arpfrq);

~amp = Array.fill(4, { rrand(0.01, 0.1) });
~ampseq = Pseq(~amp,inf)
)

~durProxy.source = Pseq([0.2, 0.2, 0.6, 0.8], inf);
~durProxy.source = 60/360;
Array.fill(12, { rrand(0.4,1) })