o = Server.default.options;
o.numBuffers;
o.memSize;

~drumkit = SoundFile.collect(path: "/Volumes/ssdData/Industrial-autoprodotti/*".standardizePath);

(
~fileInfo = {|fileNum, sndFileArray|
	"####### File info Start #######".postln;
	sndFileArray[fileNum].path.postln;
	sndFileArray[fileNum].numChannels.postln;
	sndFileArray[fileNum].sampleRate.postln;
	sndFileArray[fileNum].headerFormat.postln;
	sndFileArray[fileNum].sampleFormat.postln;
	sndFileArray[fileNum].numFrames.postln;
	"######## File info End ########"
};
)

~fileInfo.value(96, ~drumkit);


// plays randomly a sample read from an array of buffers
{ PlayBuf.ar(1, ~bufDrumkit[rand(~bufDrumkit.size-1)].bufnum, doneAction: 2) }.play;
// plays randomly a sample read from an array of buffers at random rate
{ PlayBuf.ar(1, ~bufDrumkit[rand(~bufDrumkit.size-1)].bufnum,rate:rand(10), doneAction: 2) }.play;

// play the loaded file
~drumkit[45].play;

b = ~drumkit[0].info;

// type writer soud design
{ PlayBuf.ar(1, ~bufDrumkit[20].bufnum,rate:rand(10)+2, doneAction: 2) }.play;

