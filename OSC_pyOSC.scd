n = NetAddr("127.0.0.1", 57120);

// separate port for different incoming messages
~frompyOSC = OSCdef('\frompyOSC', {|msg, time, addr, port| msg.postln }, '/webin', recvPort:57130);

OSCdef.all;
OSCdef('\frompyOSC').recvPort;
~frompyOSC.recvPort;
OSCdef('\frompyOSC').free;

// execute a python script from SC and get the output
(
var path;
path = "~/pyscript".standardizePath;
f = PathName.new(path);
f.filesDo{|fin| fin.postln };
)

"cat /Users/hellska/pyscript/soundDownload.py".unixCmdGetStdOut.postln;

// init MIDI and check midi input devices available
MIDIClient.init;
MIDIClient.sources;

// Use MIDIIn to receive the clock ... need to create my own sync program!!!
(
~count = 0;
~sysrt = { arg src, chan, val;  ~count.postln; ~count=~count+1; [~count,chan,val].postln; };
)
MIDIIn.addFuncTo(\sysrt, ~sysrt);
MIDIIn.removeFuncFrom(\sysrt, ~sysrt);
MIDIIn.functionPerformList


// ddw_lib MIDISyncClock ... it's a pain till now
// debug this ... not working properly
MIDISyncClock.init(0, 0);
MIDIIn.connect(0, MIDIClient.sources[0]);
(
t = Task({
	var	synth;
	loop {
		#[60, 62, 64, 65, 67, 65, 64, 62].do({ |note|
			s.makeBundle(0.2, {
				synth = Synth(\default, [freq: note.midicps])
			});
			s.makeBundle(0.4, {
				synth.release;
			});
			0.25.wait;
		});
	}
}).play(MIDISyncClock, quant: 1);
)

MIDISyncClock.seconds;

t = Pbind(\midinote, Pseq([60, 62, 64, 65, 67, 65, 64, 62], inf),
	\delta, 0.25, \dur, 0.25, \instrument, \default)
	.play(MIDISyncClock, quant:4);

t.stop;