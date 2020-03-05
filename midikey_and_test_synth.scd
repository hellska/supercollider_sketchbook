(
SynthDef(\anothrone, {|outbus=0, amp=0.1, freq=220, brate=2, gate=1, atk=0.01, sl=1, rt=0.4, crv=\lin, res=0.5, cutoff=440|
	var source, env, out;
	source = Pulse.ar([freq], 0.1) +
	         SinOsc.ar(freq/2, 0.2);
	env = EnvGen.ar(Env.asr(atk, sl, rt, crv), gate, doneAction: 2);
	//out = RLPF.ar(source, freq, 200/(freq*2)) * env;
	out = LPF.ar(source, freq, env);
	Out.ar(outbus, out * amp)
}).send(s);
)
~anodrone = {|port, ch, key, vel| var freq = key.midicps; ("kfrq: "++freq+" kvel: "++vel).postln; ~noteArray.put(key, Synth.new(~inputSynth, [\freq, freq, \outbus, 3])); };
// percussive synth - no sustain
SynthDef(\percthrone, {|outbus=3, amp=0.5, freq=220, brate=2, gate=1, atk=0.01, rt=0.4, crv=\lin, res=0.5, cutoff=440|
	var source, env, out;
	source = Pulse.ar([freq, freq-brate], 0.5) + SinOscFB.ar(freq/2);
	env = EnvGen.ar(Env.perc(atk, rt), gate, doneAction: 2);
	out = MoogVCF.ar(source, cutoff, res) * env;
	Out.ar(outbus, out * amp)
}).send(s);
)
~percdrone = {|port, ch, key, vel| var freq = key.midicps; freq.postln; ~noteArray.put(key, Synth.new(~inputSynth, [\freq, freq])); };
~arp = [0, 2, 4, 6];
~percdroneArp = {|port, ch, key, vel| var arp = (~arp + key).midicps; arp.postln; ~arpProxy.source = Pseq(arp, inf); };
)

Array.

MIDIClient.init;
MIDIClient.sources[1];
MIDIIn.connect(0, 1);
MIDIIn.disconnect(0, 1);

s.meter;
s.plotTree;

~inputSynth = \anothrone;
~inputSynth = \percthrone;

~noteArray

~noteArray = Array.newClear(121);
MIDIIn.addFuncTo(\noteOn, ~anodrone);
~offnote = {|port, ch, key, vel| key.postln; ~noteArray[key].set(\gate, 0) };
MIDIIn.addFuncTo(\noteOff, ~offnote);

MIDIIn.removeFuncFrom(\noteOn, ~anodrone);
MIDIIn.removeFuncFrom(\noteOff, ~offnote);
MIDIIn.removeFuncFrom(\noteOn, \all);


MIDIIn.reset;
MIDIIn.replaceFuncTo(\noteOn, ~anodrone, ~anodrone);
// Arpeggiator
~arp = [0, 2, 4, 6];
~arpfrq = (~arp + 65).midicps;
~arpProxy = PatternProxy(Pseq(~arpfrq, inf));
~durProxy = PatternProxy(60/120);
~arpProxy.source = Pseq(~arpfrq, inf);

~arp.midicps
(~arp + 33).midicps
~arpPatt = Pbind(\instrument, \percthrone, \freq, ~arpProxy, \dur, ~durProxy).play;
~arpPatt = Pbind(\instrument, \percthrone, \freq, ~arpProxy, \dur, ~durProxy).play;
~arpPatt.play;
~arpPatt.stop;

~arp = [0, 2, 4, 6];
~percdroneArp = {|port, ch, key, vel| var arp = (~arp + key).midicps; arp.postln; ~arpProxy.source = Pseq(arp, inf); };

MIDIIn.addFuncTo(\noteOn, ~percdroneArp);
MIDIIn.removeFuncFrom(\noteOn, ~percdroneArp);
~arp = [0, 2, 4, 6, 8, 10, 7, 5, 3, 1];
~arp = [0, 3, -3, 5, -5];
~arp = [0, 3, 1, 5, -1, 7, -3];
~arp = [0, 3, 5, 3, 1, -1];
~arp = [0, 3, 5, 3, 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ];
~arp = [0, 5, 10, 12];
~arp = [0, 3, -3, 5, -5, 3, -2, 7, -1, 6, 0, -5];
~durProxy.source = 60/30;
~durProxy.source = 60/60;
~durProxy.source = 60/190;
~durProxy.source = 60/360;
~durProxy.source = 60/690;
~durProxy.source = 60/990;
~arp.size

~arp = [0, 2, 4, 6];
~arp = [0, 0, 0, 0];
~arpfrq = (~arp + 36).midicps;

~arpseq = Pseq(~arpfrq);

~ciccio = [ "uno" ];
~arpPatt = Pbindef(
	~ciccio[0], \instrument, \percthrone,
	\freq, Pn(Plazy { ~arpseq }),
	\dur, ~durProxy);

~durProxy = PatternProxy(Pseq(Array.fill(4, { 60/120 }), inf));
~durProxy.source = Pseq(Array.fill(4, { 60/370 }), inf);
~arpPatt.play;
~arpPatt.stop;
~percdroneArp = {|port, ch, key, vel| var arp = (~arp + key).midicps; arp.postln; ~arpseq = Pseq(arp); };
Pbindef("uno", \freq, Pn(Plazy { ~arpseq }));

~ciccio[0]

~alt = Window("xxx", Rect(500,500,100,80)).front;
~seqinsert = TextField(~alt, Rect(0,0,100,30));
(
~seqchange = Button(~alt, Rect(0,35,100,30)).action_{|me|
	//~seqinsert.value.postln;
	//~seqinsert.value.size.postln;
	~arp = Array.newClear(~seqinsert.value.size);
	~seqinsert.value.do{|val, idx|
		var normval;
		normval = ( 48 - val.asInt) * -1;
		normval.postln; ///idx.postln;
		~arp.put(idx, normval);
	};
	~arp.postln;
	~arpfrq = (~arp + 36).midicps;
	~arpseq = Pseq(~arpfrq);
};
)
s.meter
s.plotTree