///// LOADED SYNTH DEFS
// \particleSin
// \greenGlitch
// \rumbledrone

a = Synth.new(\particleSin);
b = Synth.new(\greenGlitch);
c = Synth.new(\rumbledrone); /// The filter blows up substitute with \freqOscillator
d = Synth.new(\freqOscillator);

c = Synth.new(\rumbledrone, [\dur, 30]);
c = Synth.new(\rumbledrone, [\dur, 10, \deltaFreq, 6000, \minFreq, 500]);
c = Synth.new(\rumbledrone, [\dur, 10, \deltaFreq, 2000, \minFreq, 200]);
c = Synth.new(\rumbledrone, [\minFreq, 40]);

d = Synth.new(\rumbledrone, [\dur, 40, \minFreq, 50]);
d = Synth.new(\rumbledrone, [\dur, 40, \minFreq, 90, \feedbackOscFreq, 0.3]);
d = Synth.new(\rumbledrone, [\dur, 40, \minFreq, 50, \panMul, 0.2]);
d = Synth.new(\rumbledrone, [\dur, 40, \minFreq, 50, \panOscFreq, 0.5]);
d = Synth.new(\rumbledrone, [\dur, 20, \deltaFreq, 3900, \minFreq, 45, \freqOscFreq, 0.00001]);
d = Synth(\rumbledrone, [\minFreq, 330, \freqOscFreq, 0.0002]);

d = Synth.new(\rumbledrone, [\dur, 20, \deltaFreq, 450, \minFreq, 45, \freqOscFreq, 0.004]);
d = Synth.new(\rumbledrone, [\dur, 20, \deltaFreq, 20000, \minFreq, 75, \freqOscFreq, 0.000000003]);

// Definition of frequency range for color
// Red 40Hz-300Hz
c = Synth.new(\rumbledrone, [\dur, 100, \minFreq, 40]);
c = Synth.new(\rumbledrone, [\dur, 10, \minFreq, 150]);
// Green 300Hz-1200Hz
b = Synth.new(\greenGlitch, [\dur, 100, \hpfreq, 300, \posstart, 0]);
b = Synth.new(\greenGlitch, [\dur, 10, \hpfreq, 1200, \posstart, 0]);
// Blue 1200Hz-5000Hz
a = Synth.new(\particleSin, [\dur, 100, \freq, 1200, \dt, 0.00003]);
a = Synth.new(\particleSin, [\dur, 10, \freq, 5000, \dt, 0.03]);

s.freqscope

c.set(\minFreq, 40);