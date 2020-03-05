(
// arpeggiator with analog style synth
SynthDef(\percthrone, {|outbus=7, amp=0.5, mute=1, freq=220, brate=2, gate=1, atk=0.01, rt=0.4, crv=\lin, res=1, cutoff=880|
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

s.meter(2,8);
s.meter;
s.plotTree;

~durProxy.source = 60/(200);
// M I D I
~percdroneArp = {|port, ch, key, vel| var arp = (~arp + key).midicps; arp.postln; ~arpseq = Pseq(arp); };
MIDIIn.addFuncTo(\noteOn, ~percdroneArp);
MIDIIn.removeFuncFrom(\noteOn, ~percdroneArp);

(
~sequencerSelect = {|port, ch, key, val|
	key.postln;

};
)
MIDIIn.addFuncTo(\noteOn, ~sequencerSelect);
MIDIIn.removeFuncFrom(\noteOn, ~sequencerSelect);

MIDIClient.init;
MIDIClient.sources[3];
MIDIIn.connect(3);
MIDIIn.removeFuncFrom(\noteOn, ~percdroneArp);
~ampProxy.source = 0.5;
s.meter;

~amp = [0.1, 0, 0.1, 0, 0.1, 0, 0.1, 0, 0.1, 0, 0.1, 0];
~ampseq = Pseq(~amp);
~amp = Array.fill(12, { rrand(0.01, 0.1) });
~ampseq = Pseq(~amp);



( // step 1
~arp = [ 0, 0, 0, 1];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.1, 0.4) });
~ampseq = Pseq(~amp)
)
( // step 2
~arp = [0, 3, -3, 5, -5, 3, -2, 7, -1, 6, 0, -5];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(12, 0.8);
~ampseq = Pseq(~amp);
)
(
// step 3 + pattern B5
~arp = Array.fill(4, 0);
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.1, 0.4) });
~ampseq = Pseq(~amp)
)

( // step 2
~arp = [0, 3, -3, 5, -5, 3, -2];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(7, 0.8);
~ampseq = Pseq(~amp);
)

( // step 2
~arp = [0, 3, -3, 5, -5, 3];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
//~amp = Array.fill(6, 0.1);
~amp = Array.fill(4, { rrand(0.01, 0.1) });
~ampseq = Pseq(~amp);
)

~durProxy.source = 60/238;
// secondo giro
~durProxy.source = 60/400;
~durProxy.source = 60/800;
~durProxy.source = 60/360;
// main tempo
~durProxy.source = 60/(360);
// second chance
~durProxy.source = 60/(200);

~durProxy.source = Pseq(60 / Array.fill(20, { linrand(200,400) }));
Array.fill(20, { linrand(200,400) })
s.meter
// series
( // step 1
~arp = [ 0, 1, 0, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.1) });
~ampseq = Pseq(~amp)
)
( // step 1
~arp = [ 0, 0, 1, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.1) });
~ampseq = Pseq(~amp)
)
( // step 1 - hypnosys
~arp = [ 3, 0, 5, 0, 3, 1];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.1) });
~ampseq = Pseq(~amp)
)
( // step 1 + sample E3 loop 119bpm
~arp = [ 1, 0, 3, 5, 0, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.1) });
~ampseq = Pseq(~amp);
~durProxy.source = 60/357;
)
~arpPatt.play;
~arpPatt.stop;
( // step 1 + sample E3 loop 119bpm
~arp = [ 1, 0, 3, 5, 0, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.1) });
~ampseq = Pseq(~amp);
~durProxy.source = 60/(118*3);
)
~durProxy.source = 60/(56*8);
( // step 1 + sample E3 loop 119bpm
~arp = [ 1, 0, 3, 5, 0, 0, 3, 3, 7, 0, 5, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.1) });
~ampseq = Pseq(~amp);
)
s.meter
~durProxy.source = 60/(360);
~durProxy.source = 60/(119*4);

~durProxy.source = 60/(200);

( // step 1 + sample E3 loop 119bpm
~arp = [ 1, 0, 1, 5, 0, 0, 3, 1, 7, 0, 5, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.1) });
~ampseq = Pseq(~amp);
)
( // step 1 + sample E3 loop 119bpm
~arp = [ 0, 2, 3, 4, 5, 0, 0, 3, 3, 5, 5, 7, 7];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.1) });
~ampseq = Pseq(~amp);
)


// rock'n'roll
( // step 1 + sample E3 loop 119bpm
~arp = [ 0, 0, 0, 4, 5, 0, 0, 3, 3, 5, 5, 7, 7];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.1) });
~ampseq = Pseq(~amp);
)
( // step 2 // rock'n'roll
~arp = [3, 3, 5, 5, 7, 7];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.1) });
~ampseq = Pseq(~amp);
)
( // step 3 // rock'n'roll
~arp = [ 0, 0, 0, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
// ~amp = Array.fill(4, { rrand(0.01, 0.1) });
~ampseq = [ 0.1, 0.05, 0.05, 0.05];
~ampseq = Pseq(~amp);
)
( // step 3 // rock'n'roll
~arp = [ 0, 0, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(3, { rrand(0.01, 0.1) });
~ampseq = Pseq(~amp);
)
( // step 3 // rock'n'roll
~arp = [ 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = [ 0.4 ];
~ampseq = Pseq(~amp);
)

//////////// aaaaaaaaaa newwwwwwwwww

( // step 2 // rock'n'roll
~arp = [2,0,0,5,7, 7, 9,9,9,9,3,3,5,0,2,2];
~arpfrq = (~arp + 36).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.6) });
~ampseq = Pseq(~amp);
)
~amp.postln;
// array ~amp
// [ 0.56112239480019, 0.57309364557266, 0.21338705420494, 0.50545822739601 ]
// [ 0.56112239480019, 0.57309364557266, 0.21338705420494, 0.50545822739601 ]
~durProxy.source = 60/(91);