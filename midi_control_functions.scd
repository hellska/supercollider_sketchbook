// \particleSin player
~particleSin = {|status|
	MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
	// change this variable to select the correct synth
	~synth = "\particleSin";
	~attenv = Env.adsr(attackTime:0.01,decayTime:0.5,sustainLevel:0.5,releaseTime:1,peakLevel:1,curve:-3).asStream;
	~mul = 0.3;
	~pmul = 0.5;
	~ddur = 4.3;
	~noteOn = {arg src, chan, num, vel;
		var pitch, velo;
		pitch = num; //.midicps;
		velo = (vel / 127.0) * 1.5;
		Synth(~synth, [\freq, pitch.midicps]);
	};
MIDIIn.addFuncTo(\noteOn, ~noteOn);
};
// \greenGlitch
~greenGlitch = {|status|
	MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
	// change this variable to select the correct synth
	~synth = "\greenGlitch";
	~attenv = Env.adsr(attackTime:0.01,decayTime:0.5,sustainLevel:0.5,releaseTime:1,peakLevel:1,curve:-3).asStream;
	~mul = 0.3;
	~pmul = 0.5;
	~ddur = 4.3;
	~noteOn = {arg src, chan, num, vel;
		var pitch, velo, pos;
		pos = 1.rand * 2 - 1;
		pitch = num; //.midicps;
		velo = (vel / 127.0) * 1.5;
		Synth(~synth, [\hpfreq, pitch.midicps, \posstart, pos]);
	};
	MIDIIn.addFuncTo(\noteOn, ~noteOn);
};
// \rumbledrone
~rumbledrone = {|status|
	MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
	// change this variable to select the correct synth
	~synth = '\rumbledrone';
	~attenv = Env.adsr(attackTime:0.01,decayTime:0.5,sustainLevel:0.5,releaseTime:1,peakLevel:1,curve:-3).asStream;
	~mul = 0.3;
	~pmul = 0.5;
	~dur = 30;
	~noteOn = {arg src, chan, num, vel;
		var pitch, velo;
		pitch = num; //.midicps;
		velo = (vel / 127.0) * 1.5;
		Synth(~synth, [\minFreq, pitch.midicps, \dur, ~dur]);
	};
	MIDIIn.addFuncTo(\noteOn, ~noteOn);
};

~simple = {|status|
	MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
	~synth1 = "\pulseBass";
	~synth2 = "\bassline";
	~attenv = Env.adsr(attackTime:0.01,decayTime:0.5,sustainLevel:0.5,releaseTime:1,peakLevel:1,curve:-3).asStream;
	~mul = 0.3;
	~pmul = 0.3;
	~ddur = 2.3;
	~noteOn = {arg src, chan, num, vel;
		var pitch, velo;
		pitch = num; //.midicps;
		velo = (vel / 127.0) * 1.5;
		Synth(~synth1, [\frq, pitch, \amp, velo, \outBus, 0]); // ~input]);
	};
	MIDIIn.addFuncTo(\noteOn, ~noteOn);
};
////////// Synth con rumble background
~rumble = {|status|
	MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
	// change this variable to select the correct synth
	~synth = "\pulseBass";
	~synth2 = "\bassline";
	~attenv = Env.adsr(attackTime:0.01,decayTime:0.5,sustainLevel:0.5,releaseTime:1,peakLevel:1,curve:-3).asStream;
	~mul = 0.3;
	~pmul = 0.5;
	~ddur = 4.3;
	~noteOn = {arg src, chan, num, vel;
		var pitch, velo;
		pitch = num; //.midicps;
		velo = (vel / 127.0) * 1.5;
		Synth(~synth, [\frq, pitch, \amp, velo, \outBus, 0]);
		Synth(~synth2, [\frq, pitch * ~pmul, \amp, velo * ~mul, \dur, ~ddur, \outBus, 0]);
	};
	MIDIIn.addFuncTo(\noteOn, ~noteOn);
};
~randomDelay = {|status|
	// random delay
	MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
	~synth1 = "\pulseBass";
	~synth2 = "\bassline";
	~attenv = Env.adsr(attackTime:0.01,decayTime:0.5,sustainLevel:0.5,releaseTime:1,peakLevel:1,curve:-3).asStream;
	~mul = 0.3;
	~pmul = 0.3;
	~ddur = 2.3;
	~noteOn = {arg src, chan, num, vel;
		var pitch, velo;
		~times = 100.sum3rand + 0.1;
		pitch = num; //.midicps;
		velo = (vel / 127.0) * 1.2;
		Synth(~synth1, [\frq, pitch, \amp, velo, \outBus, 0, \times, ~times]); // ~input]);
	};
	MIDIIn.addFuncTo(\noteOn, ~noteOn);
};
~ranDelaySwipe = {|status|
	// random delay
	MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
	~synth1 = "\pulseBass2";
	// ~synth2 = "\bassline";
	~attenv = Env.adsr(attackTime:0.01,decayTime:0.5,sustainLevel:0.5,releaseTime:1,peakLevel:1,curve:-3).asStream;
	~mul = 0.3;
	~pmul = 0.3;
	~ddur = 2.3;
~noteOn = {arg src, chan, num, vel;
		var pitch, velo;
	~times = 100.sum3rand + 0.1;
		pitch = num; //.midicps;
		velo = (vel / 127.0) * 1.2;
		Synth(~synth1, [\frq, pitch, \amp, velo, \outBus, 0, \times, ~times]); // ~input]);
};
	MIDIIn.addFuncTo(\noteOn, ~noteOn);
};