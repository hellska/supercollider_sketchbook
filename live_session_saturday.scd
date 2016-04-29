(
	~hey1 =	{ var idx; idx = 1; GrainBuf.ar(2,Impulse.kr(164),0.02,~smpllist[idx],SinOsc.kr(0.5)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6)) }.play;
)
~hey1.free;
(
	~hey2 =	{ var idx; idx = 2; GrainBuf.ar(2,Impulse.kr(12),0.02,~smpllist[idx],SinOsc.kr(32)+1,~smpllist[idx].numFrames*SawDPW.kr(0.6)) }.play;
)
~hey2.free;
(
	~hey3 =	{ var idx; idx = 3; GrainBuf.ar(2,Impulse.kr(3),0.04,~smpllist[idx],1,~smpllist[idx].numFrames*SawDPW.kr(1)) }.play;
)
~hey3.free;
(
	~hey4 =	{ var idx; idx = 4; GrainBuf.ar(2,Impulse.kr(6),0.06,~smpllist[idx],0.2,~smpllist[idx].numFrames*SawDPW.kr(1)) }.play;
)
~hey4.free;
(
	~hey5 =	{ var idx; idx = 5; GrainBuf.ar(2,Impulse.kr(9),0.08,~smpllist[idx],4,~smpllist[idx].numFrames*SawDPW.kr(10)) }.play;
)
~hey5.free;
(
~hey6 =	{ var idx; idx = 12;
	GrainBuf.ar(2,Impulse.kr(6),0.08,~smpllist[idx],4,~smpllist[idx].numFrames*SawDPW.kr(10)) }.play;
)
// largos
(
~hey7 =	{ var idx; idx = 12;
	GrainBuf.ar(2,Impulse.kr(0.75),2.08,~smpllist[idx],4,~smpllist[idx].numFrames*SawDPW.kr(0.2),mul:0.5) }.play;
)
~hey7.free;
(
~hey8 =	{ var idx; idx = 12;
	GrainBuf.ar(2,Blip.kr(1.5),2.08,~smpllist[idx],4,~smpllist[idx].numFrames*SawDPW.kr(0.2),mul:0.5) }.play;
)
~hey8.free;
(
~hey9 =	{ var idx; idx = 12;
	GrainBuf.ar(2,Blip.kr(0.375),2.08,~smpllist[idx],4,mul:0.01) }.play;
)
~hey9.free;
(
~hey10 =	{ var idx; idx = 12;
	GrainBuf.ar(2,Pulse.kr(0.15),2.08,~smpllist[idx],4,
		~smpllist[idx].numFrames*SawDPW.kr(0.2),
		mul:0.5) }.play;
)
~hey10.free;
(
~hey11 =	{ var idx; idx = 1;
	GrainBuf.ar(2,Pulse.kr(1),2.08,~smpllist[idx],4,
		~smpllist[idx].numFrames*SawDPW.kr(0.2),
		mul:0.5) }.play;
)
1.5/4
s.meter
~hey11.free