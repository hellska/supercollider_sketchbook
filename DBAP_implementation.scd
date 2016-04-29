// DBAP study and implementatio

// 4 speakers in square position
(
var numChannels = 4;
~spkArray = Array.newClear(numChannels);
~spkArray[0] = Point.new(-20,20);
~spkArray[1] = Point.new(20,20);
~spkArray[2] = Point.new(20,-20);
~spkArray[3] = Point.new(-20,-20);
)
~spkArray
// Visualization instantaneous
(
var xsize = 300;
var ysize = 300;
~visDBAPwin = Window.new("Speakers Space Visualization", Rect(700,0,xsize,ysize)).front;
~visDBAPwin.drawFunc_{

	~spkArray.do{|el|
		var x = (xsize/2) + el.x;
		var y = (ysize/2) + el.y;
		Pen.fillColor = Color.black;
		Pen.strokeColor = Color.black;
		Pen.addOval(Rect(x,y,5,5));

	};
	Pen.fillStroke;
	// draw the point
	~srcArray.do{|src|

		var x = (xsize/2) + src.x;
		var y = (ysize/2) + src.y;
		var color = Color.red;
		Pen.fillColor = color;
		Pen.addOval(Rect(x,y,5,5));
		};
	Pen.fillStroke;
	// "ciao".postln;
};
~visDBAPwin.refresh
)
// source definition // max 20
(
~srcArray = Array.new(20);
~srcArray.add(Point.new());
)
// this routine refresh the view
(
~ruttin = Routine{
	loop{
		{ ~visDBAPwin.refresh}.defer;
		0.04.wait; // 25 fps
	}
};
)
~ruttin.play;
~ruttin.free;

~srcArray[0].dist(~spkArray[0]);

~srcArray[0] = ~srcArray[0] + 4;
~srcArray[0] = ~srcArray[0].transpose();
~srcArray[0] = ~srcArray[0].x_(3);
~srcArray[0] = ~srcArray[0].y_(95);

1/25