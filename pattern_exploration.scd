// ((::Pattern Exploration::))
(
~uno = Pbind(
       \degree, Prand([0, 1, 2, 4, 5], 10),
       \dur, 0.25
);
~due = Pbind(
       \degree, Pxrand([0, 1, 2, 4, 5], 10),
       \dur, 0.25
);
~tre = Pbind(
       \degree, Pshuf([0, 1, 2, 4, 5], 10),
       \dur, 0.25
);
~qua = Pbind(
       \degree, Ptuple([
             Pseries(7, -1, 8),
             Pseq([9, 7, 7, 7, 4, 4, 2, 2], 1),
             Pseq([4, 4, 4, 2, 2, 0, 0, -3], 1)
], inf),
       \dur, 0.24
);
~cin = Pbind(
       \degree, Pseries(-7, 1, 35),
       \dur, Pgeom(0.5, 0.89140193218427, 35)
);
)

MIDIClient.init;
MIDIClient.sources;
MIDIIn.connect(0, MIDIClient.sources[2]);
(
~patPlay = {|src ,chan, val|
	case
	{ val == 60 } { ~uno.play }
	{ val == 62 } { ~due.play }
	{ val == 64 } { ~tre.play }
	{ val == 65 } { ~qua.play }
	{ val == 67 } { ~cin.play }
	;
};
)
MIDIIn.addFuncTo(\noteOn, ~patPlay);
MIDIIn.removeFuncFrom(\noteOn, ~patPlay);
~qua.stop;
~bufDrumkit.size

~bufDrumkit[1].play;

10.do{ { var idx; idx = rand(~bufDrumkit.size); Pan2.ar(PlayBuf.ar(1, ~bufDrumkit[idx], doneAction: 2)) }.play; };

~gen_bpm = 100; ~gen_bps = ~gen_bpm / 60;
[120, 60, 130, 2.16, 0.72]
60 / 2.16 * 3
60 / 2.16
// veri nice sample granulator setup ;)
(
{ var idx; idx = rand(~bufDrumkit.size); Pan2.ar(GrainBuf.ar(1,Impulse.kr(8),1,~bufDrumkit[idx],SinOsc.kr(0.5)+0.01,~bufDrumkit[idx].numFrames*LFNoise1.kr(20))) }.play;
{ var idx; idx = rand(~ticGaber.size); Pan2.ar(GrainBuf.ar(1,Impulse.kr(2),1,~ticGaber[idx],SinOsc.kr(0.5)+0.01,~ticGaber[idx].numFrames*LFNoise1.kr(20))) }.play;
)
~bufDrumKit.do{|snd, idx| (snd).postln };
~bufDrumKit

	{ var idx; idx = rand(~smpllist.size); Pan2.ar(GrainBuf.ar(1,Impulse.kr(83.33333),1,~smpllist[idx],SinOsc.kr(0.5)+0.01,~smpllist[idx].numFrames*SinOsc.kr(16))) }.play;

	{ var idx; idx = rand(~ticGaber.size); Pan2.ar(GrainBuf.ar(1,Impulse.kr(27.7777),1,~ticGaber[idx],SinOsc.kr(0.5)+1/2,~ticGaber[idx].numFrames*SinOsc.kr(16))) }.play;

	~hey =	{ var idx; idx = rand(~bufDrumkit.size); Pan2.ar(GrainBuf.ar(1,Impulse.kr(32),1,~bufDrumkit[idx],SinOsc.kr(0.5)+0.01,~bufDrumkit[idx].numFrames*SawDPW.kr(6))) }.play;

	~hey =	{ var idx; idx = rand(~bufDrumkit.size); Pan2.ar(GrainBuf.ar(1,Impulse.kr(1.41666),1,~bufDrumkit[idx],SinOsc.kr(0.5)+1,~bufDrumkit[idx].numFrames*SawDPW.kr(4.235))) }.play;

	~hey =	{ var idx; idx = rand(~bufDrumkit.size); Pan2.ar(GrainBuf.ar(1,Impulse.kr(4.06/4),1,~bufDrumkit[idx],SinOsc.kr(0.5)+1,~bufDrumkit[idx].numFrames*SawDPW.kr(96))) }.play;

	~hey =	{ var idx; idx = rand(~bufDrumkit.size); Pan2.ar(GrainBuf.ar(1,Impulse.kr(1.6666*4),1,~bufDrumkit[idx],SinOsc.kr(0.5)+1,~bufDrumkit[idx].numFrames*SawDPW.kr(0.6))) }.play;

	// now read from the folder of freesound
	~hey =	{ var idx; idx = rand(~smpllist.size); Pan2.ar(GrainBuf.ar(2,Impulse.kr(1.6666*4),1,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6))) }.play;

	~hey1 =	{ var idx; idx = rand(~smpllist.size); Pan2.ar(GrainBuf.ar(2,Impulse.kr(1.6666*4),1,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6))) }.play;

		~hey =	{ var idx; idx = 0; Pan2.ar(GrainBuf.ar(2,Impulse.kr(1.6666*4),1,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6))) }.play;
	~hey =	{ var idx; idx = 1; GrainBuf.ar(2,Impulse.kr(1.6666*4),1,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6)) }.play;


// 90 bpm
(
	~hey0 =	{ var idx; idx = 4; GrainBuf.ar(2,Impulse.kr(0.75),1,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6),mul:0.5) }.play;
)
(
	~hey1 =	{ var idx; idx = ~scount-1; GrainBuf.ar(2,Impulse.kr(3),2,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6)) }.play;
)
(
	~hey2 =	{ var idx; idx = ~scount-1; GrainBuf.ar(2,Impulse.kr(1.5),1,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6)) }.play;
)
// intro with short grains
(
		~hey3 =	{ var idx; idx = 4; GrainBuf.ar(2,Impulse.kr(6),0.2,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6)) }.play;
)
(
	~hey4 =	{ var idx; idx = 5; GrainBuf.ar(2,Impulse.kr(24),0.01,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6)) }.play;
)
(
	~hey5 =	{ var idx; idx = ~scount -1; GrainBuf.ar(2,Impulse.kr(12),0.01,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6)) }.play;
)
(
	~hey6 =	{ var idx; idx = 4; GrainBuf.ar(2,Impulse.kr(164),0.02,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6)) }.play;
)

(
	~hey6 =	{ var idx; idx = ~scount -1; GrainBuf.ar(2,Impulse.kr(7),0.3,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6)) }.play;
)

~hehey = [];
~hehey.add({ var idx; idx = 9; GrainBuf.ar(2,Impulse.kr(6),0.02,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6)) }.play;)
~hehey.do{|val idx| val.postln };
~smpllist.size;
~scount
(
	~hey0.free;
	~hey1.free;
	~hey2.free;
	~hey3.free;
	~hey4.free;
	~hey5.free;
	~hey6.free;
)
//

Function
~scount

~smpllist[~scount-1]
s.makeGui;
