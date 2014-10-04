
(
// start default server using 1GB of memory for large delay use
o = ServerOptions.new;
o.memSize = 1048576;
s = Server(\default, NetAddr("localhost", 57110), o);
s.boot;

)
s.quitAll;

NetAddr


// point to remote server
s = Server("bMServer", NetAddr("192.168.1.4", 56888));

s.sendMsg("s_new", "default", n = s.nextNodeID, 0, 1);
s.sendMsg("s_new", "\particleForm", s.nextNodeID, 0, 1);
s.sendMsg("s_new", "\particleSin", s.nextNodeID, 0, 1);
s.sendMsg("n_free", n);


(
// get server info
Main.version.postln;
thisProcess.platform.postln;
Main.packages.do({|i, index| i.postln });

)

(
// get version specs
Main.scVersionMajor.postln;
Main.scVersionMinor.postln;
Main.scVersionPostfix.postln;
thisProcess.openPorts;
thisProcess.pid;

)