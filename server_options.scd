(
// start default server using 1GB of memory for large delay use
o = ServerOptions.new;
o.memSize = 1048576;
Server.default.options = o;
s.boot;
s.meter;
s.volume.gui;
)
(
// start secondary server using 1GB of memory for large delay use
o = ServerOptions.new;
o.memSize = 1048576;
Server.default = Server.local;
l = Server(\local2, NetAddr("localhost", 57110), o);
l.boot;
l.meter;
)

(
// OSC ports
("Lang Port: " ++ NetAddr.langPort).postln;
("Local Address: " ++ NetAddr.localAddr).postln;
)

// point to remote server
s = Server("bMServer", NetAddr("192.168.1.4", 56888));

s.sendMsg("s_new", "default", n = s.nextNodeID, 0, 1);

a = Synth.new(\defaul);

s.sendMsg("s_new", "\particleForm", s.nextNodeID, 0, 1);
s.sendMsg("s_new", "\particleSin", s.nextNodeID, 0, 1);
s.sendMsg("n_free", n);

(
s.record; // start recording on disk (master output)
s.stopRecording; // stop recording on disk
)

(
// get version specs
Main.packages.do({|i, index| i.postln });
("Current Version: " ++ Main.scVersionMajor ++ "." ++ Main.scVersionMinor ++ Main.scVersionPostfix).postln;
("Platform: " ++ thisProcess.platform).postln;
("Local Address: " ++ NetAddr.localAddr).postln;
("Current PID: " ++ thisProcess.pid).postln;
)

// recompile the class library - equivalent to restart SuperCollider
thisProcess.recompile;
thisProcess.argv;
thisProcess.preferences

(
// get server info in other format/way
Main.version.postln;
thisProcess.openPorts.postln;
)

"ps -ef | grep scsy".unixCmd;
"kill".unixCmd;
