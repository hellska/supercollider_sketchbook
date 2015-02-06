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