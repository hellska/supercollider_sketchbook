(
s.options.numBuffers = 1024 * 16; // increase this if you need to load more samples
s.options.memSize = 8192 * 16; // increase this if you get "alloc failed" messages
s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
s.options.numOutputBusChannels = 2; // set this to your hardware output channel size, if necessary
s.options.numInputBusChannels = 2;
)
~dirt = SuperDirt.start(2, ~pserver, 4);
~dirt.loadSoundFiles("/Users/hellska/hellska/remix/eccezziunale_samples*".standardizePath);
s.makeGui;
s.meter;