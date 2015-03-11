(
// plot two sinusoids of different amplitude
   {SinOsc.ar(100)}.plot(bounds:Rect(0,0,400,400));
   {SinOsc.ar(100)*2}.plot(bounds:Rect(400,0,400,400));
)

{arg x; tan(x**2);}.plotGraph(100,-pi,pi);

(
// data visualization using custom plotters
   // the parent window
   var window = Window.new("Plotter Example", Rect(0,0,640,480)).front;
   // the datasets to visualize
   var datasetA = Array.fill(1000,{rrand(-1.0,1.0)});// random floats
   var datasetB =  [ // a 2-dimensional array of random floats
     Array.fill(10,{rrand(-1.0,1.0)}),
     Array.fill(10,{rrand(-1.0,1.0)})
   ];
   // the plotters
   var plotterA = Plotter("PlotterA",Rect(5,5,630,235),window);
   var plotterB = Plotter("PlotterB",Rect(5,240,630,235),window);
￼// setup and customize plotterA
plotterA.value_(datasetA);
plotterA.setProperties(
// load dataset
// customize appearance
// plot color
\plotColor, Color.red,
\backgroundColor, Color.black, // background color
\gridColorX, Color.white,      // gridX color
\gridColorY, Color.yellow)     // gridY color
.editMode_(true)   // allow editing with the cursor
.editFunc_({ // this function is evaluated whenever data is edited
  arg plotter,plotIndex,index,val,x,y;
  ("Value: " ++ val ++ " inserted at index: " ++ index ++
    ".").postln;
});
// setup and customize plotterB
plotterB.value_(datasetB);   // load datasetB
plotterB.superpose_(true);   // allow channels overlay
plotterB.setProperties(
	\plotColor, [Color.blue,Color.green], // plot colors
	\backgroundColor, Color.grey, // background color
	\gridOnX, false,
	\gridOnY, false)
.plotMode_(\steps);
)
(
// display the contents of a soundfile
   // create the view
   var view = SoundFileView.new(Window.new("A SoundFileView Example", 640@480).front,640@480);
   // load a soundfile in the view using a SoundFile
   var file = SoundFile.new;   // create a new SoundFile
   file.openRead(Platform.resourceDir +/+ "sounds/a11wlk01.wav"); // read a file
   view.soundfile_(file);       // set the soundfile
   view.read(0, file.numFrames); // read the entire soundfile (**for big soundFiles use .readWithTask instead**)
   file.close; // we no longer need the SoundFile
// configure appearence
   view.timeCursorOn_(false);
   view.gridOn_(false);
   view.background_(Color.green);
   view.waveColors_([Color.magenta]);
// waveform color (it has to be an array)
)

{ GrainBuf.ar(1,Impulse.kr(10), MouseX.kr(0.01,3), ~playBuff, LFNoise1.kr.range(0.5,2)); }.scopeResponse;

//adding harmonics with clip
   {Mix.new(SinOsc.ar((1..5)*LFNoise2.ar(10).range(200,500)))}.scopeResponse; // original
   {LeakDC.ar((Mix.new(SinOsc.ar((1..5)*LFNoise2.ar(10).range(200,500))).clip))}.scopeResponse; // with harmonics added

(
// sculpting a spectrum in the time-domain
{ var signal = ClipNoise.ar(0.1); // start with a signal  rich in partials
	signal = DynKlank.ar([[400,800,1300,4000],nil,[0.3,1,0.4,1]],signal, SinOsc.kr(0.1).range(0.5,4));
		// use a bank of resonators to sculpt away partials and modulate their resonant frequencies
	signal = BPF.ar(signal, 2000,0.1); // band-pass filter to remove more from the original
}.scopeResponse;
)

( // freezing spectra
var buffer = Buffer.read(Server.default, Platform.resourceDir +/+
	"sounds/a11wlk01.wav"); // read a soundfile into the buffer
{ //var signal = PlayBuf.ar(1,buffer,BufRateScale.kr(buffer),loop:1);
	var signal = SoundIn.ar(0);
	signal = FFT(LocalBuf(1024),signal);
	//       signal = PV_Freeze(signal,Duty.kr(1,0,Dseq([0,1],inf)));
	signal = PV_Freeze(signal,SinOsc.kr(0.5));
	// freeze signal every other second
	signal = IFFT(signal); // synthesize time-domain equivalent
}.scopeResponse;
)

(
s.waitForBoot{
	b = Buffer.alloc(a,512);
	{
		var in, chain;
		in = SoundIn.ar(0);
		chain = FFT(b, in);
	}.play;
};
)
(
~buf = Buffer.alloc(a,512);
~in = Bus.audio(s, 1);
(
	{
		var in, chain;
		in = In.ar(~in);
		chain = FFT(~buf, in);
	}.play;
)
(
{ var in, chain;
in = SoundIn.ar(0);
chain = FFT(~buf, in);
}.play;
)
(
~frq = 2200;
{
	var in, chan;
	in = SinOsc.ar(~frq);
	chan = FFT(~buf, in);
}.play;
)
~buf.clear
~buf.play;
~buf.numFrames;
~buf.free;
(
SynthDef.new(\granulaSample, {
	|trigga = 10,
	dur = 0.1,
	maxGrains = 512,
	minrate = 1,
	outBus = 0,
	sndBuf,
	gate = 1,
	buffer|
	var env, source, out, chan;
	env = EnvGen.ar( Env.asr(0.01, 1, dur * maxGrains, -3),gate:gate, doneAction: 2);
	source = GrainBuf.ar(2, Impulse.kr(trigga), dur, sndBuf, minrate);
	out = source * env;
	chan = FFT(buffer, out);
	Out.ar(outBus, out)
}).send(s);
)
// This code portion plots the magnitude of the frequency bins
(
~buf.getToFloatArray(action: { |data|
//	var z, x;
	z = data.clump(2).flop;
	// Initially data is in complex form
	z = [Signal.newFrom(z[0]), Signal.newFrom(z[1])];
	x = Complex(z[0], z[1]);
	{x.magnitude.plot}.defer;
});
)
~buf = Buffer.alloc(s, 512);
x = Synth.new(\granulaSample, [\buffer, ~buf]);
~frq = 2000;
s.meter;
z
x
a = Array.fill(30, { 5.rand });
a.clump(2);
s = Signal.rectWindow(512);
s = Signal.hanningWindow(512);
Signal.sineFill(512, 1.0/[1,2,3,4,5,6], [1pi,1pi,1pi,1pi,1pi,1pi]).plot;
Signal.sineFill(512, 1.0/[1,2,3,4,5,6]).plot;
Signal.chebyFill(512,[1,2,3,4,5,6]).plot;
s.plot
Signal.sineFill(512, [1]).plot;

x = Signal.sineFill(512, [0, 0, 0, 1]);
[x, x.neg, x.abs, x.sign, x.squared, x.cubed, x.asin.normalize, x.exp.normalize, x.distort].flop;
.flat    .plot(numChannels: 9);

[[1, 2, 3], [4, 5, 6]].flop;
[[1, 2, 3], [4, 5, 6], [7, 8]].flop; // shorter array wraps
[].flop; // result is always 2-d.