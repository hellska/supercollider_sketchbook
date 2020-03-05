(
SynthDef(\anothrone, {|outbus=0, amp=0.1, freq=220, brate=2, gate=1, atk=0.01, sl=1, rt=0.4, crv=\lin, res=0.5, cutoff=440|
	var source, env, out;
	source = Pulse.ar([freq], 0.1) + SinOsc.ar(freq/2, 0.2);
	env = EnvGen.ar(Env.asr(atk, sl, rt, crv), gate, doneAction: 2);
	//out = RLPF.ar(source, freq, 200/(freq*2)) * env;
	out = LPF.ar(source, freq, env);
	Out.ar(outbus, out * amp)
}).send(s);
)

200.linexp(0, 8373, 0.1, 0.3).postln;
5 * 800.linexp(0, 8373, 0.1, 0.3).postln;

(
SynthDef(\anothrone, {|outbus=0, amp=0.1, freq=220, brate=2, gate=1, atk=0.01, sl=1, rt=0.4, crv=\lin, res=0.5, cutoff=440|
	var source, env, out;
	//source = Pulse.ar([freq], 0.1) + SinOsc.ar(freq/2, 0.2);
	// source = VOsc.ar(0, freq);
	source = PMOsc.ar(freq, 34);
	env = EnvGen.ar(Env.asr(atk, sl, rt, crv), gate, doneAction: 2);
	//out = RLPF.ar(source, freq, 200/(freq*2)) * env;
	out = LPF.ar(source, freq, env);
	Out.ar(outbus, out * amp)
}).send(s);
)

(
SynthDef(\anothrone, {|outbus=0, amp=0.1, freq=220, brate=2, gate=1, atk=0.01, sl=1, rt=0.4, crv=\lin, res=0.5, cutoff=440|
	var source, env, out;
	//source = Pulse.ar([freq], 0.1) + SinOsc.ar(freq/2, 0.2);
	// source = VOsc.ar(0, freq);
	source = PMOsc.ar(freq, 34);
	env = EnvGen.ar(Env.asr(atk, sl, rt, crv), gate, doneAction: 2);
	//out = RLPF.ar(source, freq, 200/(freq*2)) * env;
	out = LPF.ar(source, freq, env);
	Out.ar(outbus, out * amp)
}).send(s);
)

( // step 2
~arp = [0, 3, -3, 5, -5, 3, -2, 7, -1, 6, 0, -5];
~arpfrq = (~arp + 47).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(12, 0.05);
~ampseq = Pseq(~amp);
)
( // step 2
~arp = [0, 3, -3, 5, -5, 3, -2, 7, -1, 6, 0, -5];
~arpfrq = (~arp + 48).midicps;
~arpseq = Pseq(~arpfrq);
~amp = Array.fill(12, 0.05);
~ampseq = Pseq(~amp);
)