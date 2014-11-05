// test communication with junxion
// load junxion patch testOSCinputs.j4xml
// create a NetAddr to send messages to junxion software
~junxion = NetAddr.new("localhost", 6666);
// mapped on two OSC inputs to switch between state 1 and 2
(
~junxion.sendMsg("/jXinput/1", 0); // change to junxion state 2
~junxion.sendMsg("/jXinput/1", 1);
)
(
~junxion.sendMsg("/jXinput/2", 0); // change back to junxion state 1
~junxion.sendMsg("/jXinput/2", 1);
)

// from state 1 change to state 2
~junxion.sendBundle(0.2,["/jXinput/1", 0],[ "/jXinput/1", 1]);
// from state 2 change to state 1
~junxion.sendBundle(0.2,["/jXinput/2", 0],[ "/jXinput/2", 1]);