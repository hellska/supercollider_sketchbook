~fileInfo = {|fileNum, sndFileArray|
	~cdur = sndFileArray[fileNum].numFrames/sndFileArray[fileNum].sampleRate;
	("Name: "+sndFileArray[fileNum].path
	+"\nIndex: "+fileNum
	+"\nChannels: "+sndFileArray[fileNum].numChannels
	+"\nSample Rate: "+sndFileArray[fileNum].sampleRate
	+"\nFrames: "+sndFileArray[fileNum].numFrames
	+"\nDur"+(sndFileArray[fileNum].numFrames/sndFileArray[fileNum].sampleRate));

};

// Items from list view
~ticItems = Array.new(~bufDrumkit.size);
~bufDrumkit.do({|item, idx|
//	postln(idx+": "+~bufDrumkit[idx].path);
	~ticItems.add(~bufDrumkit[idx].path)
});

// Set the main window
~loboMain = Window("Lobotomix Controls").setTopLeftBounds(Rect(0,0,800,800)).front ;
~mainVol = s.volume.gui(~loboMain);
v = TextField(~loboMain, Rect(80,10,50,22)).focus(true) ;
//v.align_(\center);
l = TextField(~loboMain, Rect(135,10,220,22)) ;
l.string = "Select a Synth";
// keyboard input
v.keyDownAction_{|i, char|
	char.switch(
		$1, { ~simple.value; l.string = "MIDI Func: ~simple"  },
		$2, { ~rumble.value; l.string = "MIDI Func: ~rumble" },
		$3, { ~randomDelay.value; l.string = "MIDI Func: ~randomDelay" },
		$4, { ~ranDelaySwipe.value; l.string = "MIDI Func: ~ranDelaySwipe" },
		$5, { ~particleSin.value; l.string = "Synth Selected: ~particleSin" },
		$6, { ~greenGlitch.value; l.string = "Synth Selected: ~greenGlitch" },
		$7, { ~rumbledrone.value; l.string = "Synth Selected: ~rumbledrone" }
	);
	v.string = ""
};
//c = ListView(w, rect(5, 30, 50, 22)).items_(["1", "s", "e"]);
~ticLabel = StaticText(~loboMain, Rect(80, 42, 300, 22));
~ticLabel.string = "Lista files in ~Drumkit Buffer";
~ticView = ListView(~loboMain,Rect(80,60,600,100))
    .items_( ~ticItems )
    .background_(Color.white)
    .hiliteColor_(Color.green(alpha:0.6))
    .action_({ arg sbs;
	// [sbs.value, ~ticView.items[sbs.value]].postln; // .value returns the integer
	~info = ~fileInfo.value(sbs.value, ~bufDrumkit);
	~ticInfo.string = ~info;
}).keyDownAction_({|i, char, uni, key|
	if ( key == 13 ) {
		~ticPlay.focus(true)
	}
});

~ticInfo = TextView(~loboMain, Rect(80, 165, 600, 100));
~info = ~fileInfo.value(~ticView.value, ~bufDrumkit);
~ticInfo.string = ~info;
~ticPlay = Button(~loboMain, Rect(600, 70, 50, 22))
.states_([["Play", Color.black, Color.white]])
.action_({arg me;
	~bufDrumkit[~ticView.value].play;
});


//// Controllo per synth grainBuff (inside a function to cleare and recreate as needed)

~synth_controller = {|el, name, parent|
~elements = 3;
~knobs = Array.new(el);
~nboxes = Array.new(el);
~newBoxes = Array.new(el);
~grainGroup = Group.new;
~grainAr = Array.new(25);
~grainMax = 25; // massimo numero di synth granulatori contemporanei
~grainCount = 0; // numero attuale di synth attivi
~synthIndex = ~grainCount; // current controlled synth

// set the parent HERE
~w1	= CompositeView(parent,Rect(80,270,600,200)).background_(Color.rand);

el.do({|idx|
	var base,altezza,bordoDestro,bordoSuperiore,orizontalIncr,verticalIncr,xcoord,offset;
	base = 30;
	altezza = 30;
	bordoDestro = 30;
	bordoSuperiore = 5;
	offset = 70;
	xcoord = (bordoDestro + (offset * idx));
	~knobs.add(Knob(~w1, Rect(xcoord, bordoSuperiore, base, altezza)));
	~knobs[idx].action = {|me|
		me.value * 3000 + 30; //
		me.value.postln;
		~nboxes[idx].value_(me.value);
	};
	~knobs[idx].mode = '\vert';
});
// create the number boxes to show current active synth values
	el.do({|idx|
		var base,altezza,bordoDestro,bordoSuperiore,orizontalIncr,verticalIncr,xcoord,offset;
		base = 60;
		altezza = 30;
		bordoDestro = 30;
		bordoSuperiore = 40;
		offset = 70;
		orizontalIncr = bordoDestro + base;
		verticalIncr = bordoSuperiore + altezza;
		xcoord = (bordoDestro + (offset * idx));
		~nboxes.add(NumberBox(~w1,Rect(xcoord, bordoSuperiore, base, altezza)));
		~nboxes[idx].string_(0.01)
		.clipLo_(0.01)
		.decimals_(10);
	});
// create the number boxes to set the values for new synths
el.do({|idx|
	var base,altezza,bordoDestro,bordoSuperiore,orizontalIncr,verticalIncr,xcoord,offset;
	base = 60;
	altezza = 30;
	bordoDestro = 30;
	bordoSuperiore = 120;
	offset = 70;
	orizontalIncr = bordoDestro + base;
	verticalIncr = bordoSuperiore + altezza;
	xcoord = (bordoDestro + (offset * idx));
	~newBoxes.add(NumberBox(~w1,Rect(xcoord, bordoSuperiore, base, altezza)));
	~newBoxes[idx].string_(0.01)
	.clipLo_(0.01)
	.decimals_(3);
//	.action_({|me| me.value });  ////// set the action before to control a variable
});
// the volume slider
~vol = Slider(~w1, Rect(240,10,25,150))
.action_({
	~grainAr[~synthIndex].set(\amp, ~vol.value);
});
//// N E W   Button ///// Bottoni per aggiunte Synth granulatori
~newGrainbuff = Button(~w1, Rect(170, 160, 60, 20))
	.states_([["New", Color.black, Color.green]])
	.action_({|act|
		~grainCount = ~grainCount + 1;
		~synthIndex = ~grainCount - 1;
		if ( ~grainCount <= ~grainMax ) {
			// verify button
			switch (~newValues.value,
				0, {~grainAr.add(Synth(\granulaHell,
					[\sndBuf, ~bufDrumkit[~ticView.value]],
					~grainGroup, \addToHead)
					.onFree({~grainCount = ~grainCount - 1})); },
				1, {~grainAr.add(Synth(\granulaHell,
					[\sndBuf, ~bufDrumkit[~ticView.value],
					\ratio, ~newBoxes[0].value,
					\dur, ~newBoxes[1].value,
					\rate, ~newBoxes[2].value
					],
					~grainGroup, \addToHead)
					.onFree({~grainCount = ~grainCount - 1}));
			});
			~synthNumberViewer.string_(~grainCount);
			~activeNumberViewer.string_(~synthIndex);
			~smSynt[~synthIndex].value = 1;
			~grainAr[~synthIndex].get(\ratio, {|a| { ~nboxes[0].valueAction_(a)}.defer});
			~grainAr[~synthIndex].get(\dur, {|a| {~nboxes[1].valueAction_(a)}.defer});
			~grainAr[~synthIndex].get(\rate, {|a| {~nboxes[2].valueAction_(a)}.defer});
			~grainAr[~synthIndex].get(\amp, {|a| {~vol.valueAction_(a)}.defer});
			~smSynt[~synthIndex].focus(true);
		};
});
//// Stop All Synths with gate (gently stops)
~stopAll = Button(~w1, Rect(170, 180, 60, 20))
	.states_([["Stop All",Color.black, Color.red]])
	.action_({|act|
		~grainCount.do({|me, idx|
			~grainAr.removeAt(0).set(\gate, 0);
			~smSynt[idx].value_(0);
		});
		~grainAr = Array.new(25);
		~synthIndex = 0;
		~synthNumberViewer.string_(0);
		~activeNumberViewer.string_(0);
});
//// Standard - Set values //// use standard or set values in number box for synth creation
~newValues = Button(~w1, Rect(100, 160, 60, 20))
	.states_([["Default", Color.black,Color.gray],["N Boxes",Color.black,Color.red]]);

~synthNumberViewerLabel = StaticText(~w1, Rect(440, 5, 60, 20)).string_("Synth N°");
~synthNumberViewer = NumberBox(~w1, Rect(440, 35, 30, 30)).string_(0);
~activeNumberViewerLabel = StaticText(~w1, Rect(440, 70, 60, 20)).string_("Activ N°");
~activeNumberViewer = NumberBox(~w1, Rect(440, 95, 30, 30)).string_(0)
.action_({|me|
	~synthIndex = me.string.asInt;
	~grainAr[~synthIndex].get(\ratio, {|a| { ~nboxes[0].valueAction_(a)}.defer});
	~grainAr[~synthIndex].get(\dur, {|a| {~nboxes[1].valueAction_(a)}.defer});
	~grainAr[~synthIndex].get(\rate, {|a| {~nboxes[2].valueAction_(a)}.defer});
	~grainAr[~synthIndex].get(\amp, {|a| {~vol.valueAction_(a)}.defer});
	~smSynt[~synthIndex].focus(true);
	});
// generate the matrix to control the synths
~synthMatrix = CompositeView(~w1, Rect(275,10,155,155)).background_(Color.cyan);
~smSynt = Array.new(~grainMax);
~matrixCols = 5;
~matrixrows = ~grainMax / ~matrixCols;
~matrixrows.do({|index|
	~matrixCols.do({|idx|
		var base,altezza,bordoDestro,bordoSuperiore,xcoord,ycoord;
		base = 25;
		altezza = 25;
		bordoDestro = 5;
		bordoSuperiore = 5;
		xcoord = (bordoDestro + (base + bordoDestro * idx));
		ycoord = (bordoSuperiore + (altezza + bordoSuperiore * index));
		~grainMax / ~matrixCols;
		~smSynt.add(Button(~synthMatrix,Rect(xcoord,ycoord,base,altezza))
			.states_([["I",Color.black,Color.gray],["A",Color.black,Color.green],["P",Color.black,Color.yellow]])
			.focusColor_(Color.red)
			.action_({|act|
				switch (act.value,
					0, {"mando in play".postln;
						~grainAr[idx].set(\amp, 0.7);
						act.value = 1;
						~synthIndex = idx;
						~activeNumberViewer.value_(idx)
						},
					1, {"synth non attivo".postln; act.value = 0},
					2, {"metto in pausa".postln; ~grainAr[idx].set(\amp, 0)}
				);
//				~synthIndex = idx; ~synthIndex.postln;
			})
		);
	});
});

// set the knob preferences
~knobs[0]
	.action_({|me|
	var newval;
	newval = me.value * 2970.0 + 30.0;
	~nboxes[0].value_(newval);
	~grainAr[~synthIndex].set(\ratio, newval);
})
	.step_(0.001)
	.keystep_(0.0001);
~nboxes[0]
	.clipHi_(2970.0 + 30.0)
	.action_({|me|
		~grainAr[~synthIndex].set(\ratio, me.value);
		~knobs[0].value_(me.value / me.clipHi);
	});
~newBoxes[0].clipHi_(2970.0 + 30.0);
~knobs[1]
	.action_({|me|
		var newval;
		newval = me.value * 1.99 + 0.01;
		~nboxes[1].value_(newval);
		~grainAr[~synthIndex].set(\dur, newval);
	});
~nboxes[1]
	.clipHi_(1.99 + 0.01)
	.action_({|me|
		~grainAr[~synthIndex].set(\dur, me.value);
		~knobs[1].value_(me.value / me.clipHi);
	});
~newBoxes[1].clipHi_(1.99 + 0.01);
~knobs[2]
	.action_({|me|
		var newval;
		newval = me.value * 163.0 - 3.0;
		~nboxes[2].value_(newval);
		~grainAr[~synthIndex].set(\rate, newval);
	})
	.step_(0.001)
	.keystep_(0.001);
~nboxes[2]
	.clipHi_(163.0 - 3.0)
	.action_({|me|
		~grainAr[~synthIndex].set(\rate, me.value);
		~knobs[2].value_(me.value / me.clipHi);
	});
~newBoxes[2].clipHi_(163.0 - 3.0);
}; // end of function ~synth_controller

~synth_controller.value(3, "GrainBuff", ~loboMain);

