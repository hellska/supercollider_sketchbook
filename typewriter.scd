(
// USE clang01 e clang02 sounds
~bufDrumkit = SoundFile.collectIntoBuffers(path: "/Volumes/ssdData/Industrial-autoprodotti/*".standardizePath);
// Simulate writing
~typewriter = Task({
	inf.do({|idx|
		var gap;
		gap = rand(255) / 255 / 2 + 0.1;
		// typewriter carriage return ;)
		if (mod(idx,80)==0) {
			{ Out.ar(2, Pan2.ar(PlayBuf.ar(1, ~bufDrumkit[96].bufnum,rate:0.4, doneAction: 2),0)) }.play;
			1.5.wait;
		};
		{ Out.ar(2, Pan2.ar(PlayBuf.ar(1, ~bufDrumkit[12].bufnum,rate:rand(4)+2, doneAction: 2),0)) }.play;
		gap.wait;
	});
});
)
~typewriter.start;
~typewriter.stop;

s.prepareForRecord;
s.record;
s.stopRecording;