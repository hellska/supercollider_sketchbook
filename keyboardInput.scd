(
w = Window("test", Rect(100,100,300, 300)).front ;
v = TextView(w, Rect(50,10,200, 22)).focus(true) ;
v.keyDownAction_{|i, char|
	char.switch(
		$a, {"eccolo".postln}
	);
	v.string = ""
} ;
)
