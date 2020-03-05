(
// arpeggiator with analog style synth
SynthDef(\percthrone_low, {|outbus=2, cut=1, amp=0.05, mute=1, freq=220, brate=2, gate=1, atk=0.01, rt=0.4, crv=\lin, res=0.8, cutoff=440|
	var source, env, out;
	source = PulseDPW.ar(freq, 0.5, amp) + SinOscFB.ar(freq/2, mul: amp/1);
	env = EnvGen.ar(Env.perc(atk, rt), gate, doneAction: 2);
	//out = MoogVCF.ar(source, freq * 5/12, res) * env;
	out = RLPF.ar(source, freq * cut, 200/(freq*2)) * env;
	//out = source * env;
	Out.ar(outbus, [out, out] * mute)
}).send(s);
)
(
// arpeggiator with analog style synth
SynthDef(\percthrone, {|outbus=6, cut=8, amp=0.05, mute=1, freq=220, brate=2, gate=1, atk=0.01, rt=0.4, crv=\lin, res=0.8, cutoff=440|
	var source, env, out;
	source = Pulse.ar(freq, 0.5, amp) + SinOscFB.ar(freq/2, mul: amp/0.8) + Saw.ar(freq, mul: amp);
	env = EnvGen.ar(Env.perc(atk, rt), gate, doneAction: 2);
	//out = MoogVCF.ar(source, freq * 5/12, res) * env;
	out = RLPF.ar(source, freq * cut, 200/(freq*2)) * env;
	//out = source * env;
	Out.ar(outbus, [out, out] * mute)
}).send(s);
)
~ddd = Synth(\percthrone, [\freq, 180]);
(
// P A T T E R N
~arp = [0, 3, -3, 5, -5, 3, -2, 7, -1, 6, 0, -5];
~arpfrq = (~arp + 65).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(12, 0.05); //[0.1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
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
(
// P A T T E R N
~arp = [0, 3, -3, 5, -5, 3, -2, 7, -1, 6, 0, -5];
~arpfrq = (~arp + 65).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(12, 0.05); //[0.1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
~ampseq = Pseq(~amp);
~mute = Array.fill(12, 1); //[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
~muteseq = Pseq(~amp);
~ampProxy = PatternProxy(0);
// ~arpProxy = PatternProxy(Pseq(~arpfrq, inf));
~durProxy = PatternProxy(60/360);
~arpPatt_low = Pbindef(
	"uno",
	\instrument, \percthrone_low,
	\freq, Pn(Plazy { ~arpseq }),
	\dur, ~durProxy,
	\amp, Pn(Plazy { ~ampseq }),
	\mute, Pn(Plazy { ~muteseq })
);
)
s.meter
~arpPatt.stop;
~arpPatt.play;
~arpPatt_low.play;
~arpPatt_low.stop;

s.meter

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
~amp = Array.fill(12, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp);


////////////////////////////////////////// LOOP
( // inizio
~arp = [ 0, -5, 0, 3, -3, 5, -5, 3, -2, 7, -1, 6];
~arpfrq = (~arp + 65).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(12, 0.05);
~ampseq = Pseq(~amp);
)
( // step 2
( // step 3 // rock'n'roll
~arp = [ 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = [ 0.05 ];
~ampseq = Pseq(~amp);
~durProxy.source = 60/360;
)
(
~arp = [0, -5, 0, 3, -3, 5, -5, 3, -2, 7, -1, 6];
~arpfrq = (~arp + 41 + 12).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(12, 0.05);
~ampseq = Pseq(~amp);
~durProxy.source = 60/360;
)
( // step 2
~arp = [0, -5, 0, 3, -3, 5, -5, 3, -2, 7, -1, 6];
~arpfrq = (~arp + 41).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(12, 0.05);
~ampseq = Pseq(~amp);
)
/////////////////
( // step 1 48
~arp = [ 1, 0, 0, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp)
)
~durProxy.source = 60/360;

( // step 3 // rock'n'roll
~arp = [ 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = [ 0.05 ];
~ampseq = Pseq(~amp);
~durProxy.source = 60/(100*2);
)




( // step 1 48
~arp = [ 1, 0, 0, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp)
)
( // step 1 65
~arp = [ 1, 0, 0, 0];
~arpfrq = (~arp + 65).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp)
)
( // step 2
~arp = [0, 3, -3, 5, -5, 3, -2, 7, -1, 6, 0, -5];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(12, 0.05);
~ampseq = Pseq(~amp);
)
( // step 2
~arp = [0, 3, -3, 5, -5, 3, -2, 7, -1, 6, 0, -5];
~arpfrq = (~arp + 41 + 12).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(12, 0.05);
~ampseq = Pseq(~amp);
)
( // step 2
~arp = [0, 3, -3, 5, -5, 3, -2, 7, -1, 6, 0, -5];
~arpfrq = (~arp + 41).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(12, 0.05);
~ampseq = Pseq(~amp);
)
(
// step 3 + pattern B5
~arp = Array.fill(4, 0);
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp)
)

( // violence pattern B12
~arp = [0, 3, -3, 5, -5, 3, -2];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(7, 0.05);
~ampseq = Pseq(~amp);
)

( // step 2
~arp = [0, 3, -3, 5, -5, 3];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
//~amp = Array.fill(6, 0.1);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp);
)

~durProxy.source = 60/238;
~durProxy.source = 60/480;
// secondo giro
~durProxy.source = 60/400;
~durProxy.source = Pseq(60 / Array.fill(20, { linrand(200,400) }));
Array.fill(20, { linrand(200,400) })
s.meter
// series
( // step 1
~arp = [ 0, 1, 0, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp)
)
( // step 1
~arp = [ 0, 0, 1, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp)
)
( // step 1 - hypnosys
~arp = [ 3, 0, 5, 0, 3, 1];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp)
)
( // step 1 + sample E3 loop 119bpm
~arp = [ 1, 0, 3, 5, 0, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp);
~durProxy.source = 60/357;
)
~arpPatt.play;
~arpPatt.stop;
( // step 1 + sample E3 loop 119bpm
~arp = [ 1, 0, 3, 5, 0, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp);
~durProxy.source = 60/(118*3);
)
~durProxy.source = 60/(56*8);
( // step 1 + sample E3 loop 119bpm
~arp = [ 1, 0, 3, 5, 0, 0, 3, 3, 7, 0, 5, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp);
)
s.meter
~durProxy.source = 60/(360);
~durProxy.source = 60/(119*4);

~durProxy.source = 60/(133*2);
~durProxy.source = 60/(137*2);

( // step 1 + sample E3 loop 119bpm
~arp = [ 1, 0, 1, 5, 0, 0, 3, 1, 7, 0, 5, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp);
)
( // step 1 + sample E3 loop 119bpm
~arp = [ 0, 2, 3, 4, 5, 0, 0, 3, 3, 5, 5, 7, 7];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp);
)


// rock'n'roll
( // step 1 + sample E3 loop 119bpm
~arp = [ 0, 0, 0, 4, 5, 0, 0, 3, 3, 5, 5, 7, 7];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp);
)
( // step 2 // rock'n'roll
~arp = [3, 3, 5, 5, 7, 7];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp);
)
( // step 3 // rock'n'roll
~arp = [ 0, 0, 0, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
// ~amp = Array.fill(4, { rrand(0.01, 0.05) });
~ampseq = [ 0.05, 0.02, 0.02, 0.02];
~ampseq = Pseq(~amp);
)
( // step 3 // rock'n'roll
~arp = [ 0, 0, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(3, { rrand(0.01, 0.05) });
~ampseq = Pseq(~amp);
)
~durProxy.source = 60/(480);
( // step 3 // rock'n'roll
~arp = [ 0, 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = [ 0.05, 0.02 ];
~ampseq = Pseq(~amp);
)
( // step 3 // rock'n'roll
~arp = [ 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = [ 0.05 ];
~ampseq = Pseq(~amp);
~durProxy.source = 60/(92*2);
)
( // step 3 // rock'n'roll
~arp = [ 0];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = [ 0.05, 0.05, 0.05, 0.08 ];
~ampseq = Pseq(~amp);
~durProxy.source = 60/(92*4);
)