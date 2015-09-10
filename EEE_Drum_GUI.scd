SynthDef(\timer_poll, {
	|t_start = 0, t_stop = 0|
	var trig, timer;
	trig = SetResetFF.kr(t_start, t_stop);
	timer = Timer.kr(t_start+t_stop);
	timer.poll(1)
}).store;

a = Synth.new(\timer_poll);
a.set(\t_start, 1);
a.set(\t_stop, 1);
a.free;

s.makeGui;
s.plotTree;
s.meter;
12 * s.sampleRate / 22050

s.queryAllNodes

(
~makeDrumWin = {
	~recnumber = 0; // the master loop
	~eee_win = Window("EEE Drum").setTopLeftBounds(Rect(0,0,1200,420)).front;
	~eee_recButton = Button(~eee_win, Rect(10,10,400,400))
	.states_([["WAIT"],["REC",Color.black,Color.red]])
	.action_{|me|
		case
		{me.value==0} {
			if (~recnumber==0) {
				~rec.set(\t_stop, 1);~playM = Synth.new(\playM, [\whichBuf, ~b1, \numBars, 8], ~playMGroup);
				~eee_loopMaster.value = 1;
			};
			if (~recnumber==1) {
				~recS1.set(\t_stop, 1);
				~b2.close;
				~b2.free;
				~b2 = Buffer.read(s,"~/looop1".standardizePath);
				~playS1 = Synth.new(\playS, [\whichBuf, ~b2, \lengthMul, 1, \del, 0], ~playSGroup);
				~recS1.set(\whichBuf, ~b3);
				~eee_loop_1.value = 1;
			};
			if (~recnumber==2) {
				~recS1.set(\t_stop, 1);
				~playS2 = Synth.new(\playS, [\whichBuf, ~b3, \lengthMul, 1, \del, 0], ~playSGroup);
				~recS1.set(\whichBuf, ~b4);
				~eee_loop_2.value = 1;
			};
			if (~recnumber==3) {
				~recS1.set(\t_stop, 1);
				~playS3 = Synth.new(\playS, [\whichBuf, ~b3, \lengthMul, 1, \del, 0], ~playSGroup);
				~recS1.set(\whichBuf, ~b5);
				~eee_loop_3.value = 1;
			};
			~recnumber = ~recnumber+1; ~recnumber.postln;
		}
		{me.value==1} { "recording".postln;
			if (~recnumber==0) { ~rec.set(\t_start, 1) };
			if (~recnumber==1) {
				~b2.write("~/looop1.aiff".standardizePath, "aiff", "int16", 0, 0, true);
				~recS1.set(\t_start, 1) };
		};
	};
	~eee_loopsViewer = CompositeView(~eee_win,Rect(500,10,700,600));
	~eee_loopMaster = Button(~eee_loopsViewer, Rect(10,10,70,70))
	.states_([["OFF"],["PLAY",Color.black,Color.green]])
	.action_{|me|
		case
		{me.value==0} {"stop master".postln; ~playM.free}
		{me.value==1} {"play master"}
	};
	~eee_loop_1 = Button(~eee_loopsViewer, Rect(90,10,70,70))
	.states_([["OFF"],["PLAY",Color.black,Color.green]])
	.action_{|me|
		case
		{me.value==0} {"stop loop 1".postln; ~playS1.free}
		{me.value==1} {"play loop 1"}
	};
	~eee_loop_2 = Button(~eee_loopsViewer, Rect(180,10,70,70))
	.states_([["OFF"],["PLAY",Color.black,Color.green]])
	.action_{|me|
		case
		{me.value==0} {"stop loop 2".postln; ~playS2.free}
		{me.value==1} {"play loop 2"}
	};
	~eee_loop_3 = Button(~eee_loopsViewer, Rect(270,10,70,70))
	.states_([["OFF"],["PLAY",Color.black,Color.green]])
	.action_{|me|
		case
		{me.value==0} {"stop loop 3".postln; ~playS3.free}
		{me.value==1} {"play loop 3"}
	};
	~eee_reset = Button(~eee_win, Rect(420,360,100,40))
	.states_([["R E S E T"]])
	.action_{|me| ~setup.value };
};
)
~makeDrumWin.value;
s.freeAll