MIDIClient.init;
MIDIClient.sources; // show useful sources

(
SynthDef("moto-rev", { arg ffreq=100, pfrq=0.2, amp=1;
    var x;
    x = RLPF.ar(LFPulse.ar(SinOsc.kr(pfrq, 0, 10, 21), [0,0.1], 0.1),
        ffreq, 0.1)
	    .clip2(0.4);
    Out.ar(0, x * amp);
}).add;
)

b = Bus.control(s);
e = Bus.control(s);

x = Synth("moto-rev");

x.map(0, b);
x.map(2, e);
x.map(\pfrq, e);
x.set(1, 0.2);

x.free;
(
MIDIClient.init;
MIDIIn.connect(0, MIDIClient.sources.at(0)); // connect only the first MIDI source
)
// maps pitc and velocity
(
~noteOn = {arg src, chan, num, vel;
    b.value = num.midicps.postln;
	e.value = (vel / 127.0).postln;
};
MIDIIn.addFuncTo(\noteOn, ~noteOn);
)
(

~control = {arg src, chan, num, val;
    [chan,num,val].postln;
};
MIDIIn.addFuncTo(\control, ~control);

~bend = {arg src, chan, val;
	    e.value = (val / 8150).postln;
};
MIDIIn.addFuncTo(\bend, ~bend);
)

MIDIIn.removeFuncFrom(\bend, ~bend);
MIDIIn.removeFuncFrom(\control, ~control);
MIDIIn.removeFuncFrom(\noteOn, ~noteOn);