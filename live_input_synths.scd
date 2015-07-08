// synthdef
(
SynthDef("imitational",{|
	inBus=0,
	gate=1,
	att=0.05,
	rel=0.005,
	infreq=80,
	lagTime=0.5,
	frqmul=1,
	delt=0.3|
	var env, in, amp, freq, hasFreq, out;
	env = EnvGen.ar(Env.asr(0.02,1),gate,doneAction:2);
	in = Mix.new(SoundIn.ar(inBus)) * env;
	amp = Amplitude.kr(in, att, rel);
	# freq, hasFreq = Pitch.kr(in, ampThreshold: 0.1, median: 4);
	freq = Lag.kr(freq.cpsmidi.round(1).midicps, lagTime);
	out = Mix.new(
		SinOsc.ar(freq,mul: amp / 2) +
		SinOsc.ar(freq * frqmul,mul: amp / 3)
	);
	3.do({
		out = AllpassN.ar(out, 2, [delt,delt], 0.4)
	});
	Out.ar(0,out)
}).send(s)
)
// imitational synth GUI management
(
~imi_synth_creation = {
	~imi_window = Window("Imitational").setTopLeftBounds(Rect(0,0,400,200)).front;
	~imi_synth_activate = Button(~imi_window,Rect(10,10,60,30))
	.states_([
		["Inactive",Color.black,Color.gray],
		["Active",Color.black,Color.green]])
	.action_({|me|
		if(me.value==0) { ~imi_synth.set(\gate,0) };
		if(me.value==1) { ~imi_synth = Synth(\imitational) }
	});
	~imi_lagtime = Knob(~imi_window,Rect(10,50,30,30))
	.action_({|me|
		var lagvalue;
		lagvalue = (me.value * 9.9) + 0.1;
		//~imi_synth.set(\lagTime,lagvalue)
		~imi_synth.set(\frqmul,lagvalue)
	});
	~imi_lagtime_label = StaticText(~imi_window,Rect(50,50,60,30)).string_("freq shift");
	~imi_delaytime = Knob(~imi_window,Rect(10,90,30,30))
	.action_({|me|
		var deltime;
		deltime = me.value * 1.99 + 0.01;
		~imi_synth.set(\delt,deltime)
	});
	~imi_lagtime_label = StaticText(~imi_window,Rect(50,90,60,30)).string_("delay time");
};
)

Gate

~imi_synth_creation.value();

~imi_synth.set(\att,0.3);
~imi_synth.set(\lagTime,1.0);

~imi = Synth(\imitational);
~imi.set(\gate, 0);
~imi.set(\att,0.1);
~imi.set(\infreq,80);
