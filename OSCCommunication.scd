// send test message to Processing OSC address space
// adressed to image_control_center sketch
(
m = NetAddr.new("127.0.0.1",12000);
m.sendMsg("/delay", 23456);
)

(



OSCdef.new("\input2", {|msg, time, addr, rport| ("ciccio: "++msg[1]).postln; rport.postln } , '/col');
)

(
// TESTING LOOPBACK MESSAGES
n = NetAddr.new("127.0.0.1", 57120);
n.sendMsg("/ciao", 234.54);
n.sendMsg("/column", 234.54);
)

OSCdef(\input).enable;
OSCdef(\input).disable;
OSCdef.all;
OSCdef.freeAll;

OSCFunc.new({|msg, time, addr, recvPort| ("Ciao sono io: "++msg[1]).postln }, '/col');
OSCFunc.new({|msg, time, addr, recvPort| ("Ciao sono io: "++msg[1]).postln }, '/column');
