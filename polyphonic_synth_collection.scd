(
SynthDef(\anothrone, {|outbus=0, amp=0.1, freq=220, brate=2, gate=1, atk=0.01, sl=1, rt=0.4, crv=\lin, res=0.5, cutoff=440|
	var source, env, out;
	source = PulseDPW.ar(freq, 0.1) + SinOscFB.ar(freq/2, 0.1);
	env = EnvGen.ar(Env.asr(atk, sl, rt, crv), gate, doneAction: 2);
	out = MoogVCF.ar(source, cutoff, res) * env;
	Out.ar(outbus, out * amp)
}).send(s);
~inputSynth = \anothrone;

//// funzioni per synth polifonico
~anodrone = {|port, ch, key, vel| var freq = key.midicps; ~noteArray.put(key, Synth.new(~inputSynth, [\freq, freq, \outbus, 3])); };
~noteArray = Array.newClear(121);
MIDIIn.addFuncTo(\noteOn, ~anodrone);
~offnote = {|port, ch, key, vel| ~noteArray[key].set(\gate, 0) };
MIDIIn.addFuncTo(\noteOff, ~offnote);
)