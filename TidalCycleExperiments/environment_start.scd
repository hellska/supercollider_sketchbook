s.makeGui
(1/60)/4
120/60/4
20/60/4
1/60
1/(10/60/4)
1/(5/60/4)
1/(8/60/4)
(8/60/4)

Quarks.gui



~dirt = SuperDirt.start(2, s, 4);
~dirt.orbits.size
s.plotTree
s.meter

PV_BinScramble

pow(2, 10);

// crete a public server
~net = NetAddr.new("172.20.10.14");
~opt = ServerOptions();
~opt.maxNumClients = 10;
~pserver = Server.new(p, ~net, clientID:1);

~pserver.maxNumClients(10);

~pserver.boot();

Server.all
Server.allRunningServers;

~dirt = SuperDirt.start(2, ~pserver, 4);
~pserver.meter;
~pserver.quit;

s = Server.local;
b.options.numBuffers = 1024 * 16; // increase this if you need to load more samples
b.options.memSize = 8192 * 16; // increase this if you get "alloc failed" messages
b.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
b = Server(\myServer, NetAddr("172.20.10.14", 57150));
b.boot;
~dirt = SuperDirt.start(2, b, 4);
b.plotTree
b.meter;
{ SinOsc.ar * 0.1 }.play(b);
~dirt.stop;

s.plotTree
s.meter
~dirt = SuperDirt.start(2, s, 4);
//
~dirt = SuperDirt.start(2, s, 4)
s.plotTree;

