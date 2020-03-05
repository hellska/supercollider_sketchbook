include("SuperDirt");

SuperDirt.start;
SuperDirt.stop;

(
// configure the sound server: here you could add hardware specific options
// see http://doc.sccode.org/Classes/ServerOptions.html
s.options.numBuffers = 1024 * 16; // increase this if you need to load more samples
s.options.memSize = 8192 * 16; // increase this if you get "alloc failed" messages
s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
s.options.numOutputBusChannels = 2; // set this to your hardware output channel size, if necessary
s.options.numInputBusChannels = 2; // set this to your hardware input channel size, if necessary
// boot the server and start SuperDirt
s.waitForBoot {
    ~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
    ~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
    s.sync; // wait for samples to be read
    ~dirt.start(57120, [0, 0]);   // start listening on port 57120, create two orbits, each sending audio to channel 0. You can direct sounds to the orbits from tidal e.g. by: `# orbit "0 1 1"
}
)

s.meter;
~dirt = SuperDirt(2, s);
~dirt.loadSoundFiles;
~dirt.start;
~dirt.stop;

Platform.userExtensionDir

~dirt.loadSoundFiles("/Users/hellska/soundAndSamples/samples/Industrial-autoprodott*".standardizePath);
s.makeGui;

~dirt.loadSoundFiles("/Users/hellska/hellska/remix/eccezziunale_samples*".standardizePath);

~dirt.loadSoundFiles("/Users/hellska/soundAndSamples/samples/convertedwav*".standardizePath);

// Send messages to HYDRA

n = NetAddr("127.0.0.1", 9999); // local machine

OSCdef(\test, {|msg, time, addr, recvPort| \unmatching.postln}, '/test', n); // def style

n.sendMsg("/test",33);

50.do{|idx|
	idx.postln;
	n.sendMsg("/test",idx);
	//wait(3);
};

/*  HYDRA CODE

// to do: add more examples

// to try this example, run the processing sketch in the folder processing.
// clicking on the sketch window sends the mouse x and y position to hydra via osc
// set port to listen to osc messages. default port is 57101
msg.setPort(9999)

// do something when a message is received at address '/test'
msg.on('/test', (args) => {
// log osc results to console
 log(args)
})

// uses argument as variables in hydra
freq = 10
rot = 0.2
msg.on('/test', (args) => {
 freq = args[0]
 rot = args[0]/10
 log(args[0])
})

osc(() => freq)
.mult(osc().rotate(()=>rot))
.out()

*/