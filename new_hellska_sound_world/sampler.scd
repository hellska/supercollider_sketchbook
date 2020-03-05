~x3d_sampler_view.value(0, 0, "", "");
~x3d_sampler_populate_filelist.value("");
~berlin = SoundFile.collectIntoBuffers("/home/hellska/soundAndSamples/samples/berlin/*");
~industrial = SoundFile.collectIntoBuffers("/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/*");


(


// sampler viewer (joystick controller)
~x3d_sampler_view = {|xpos, ypos, parent, buffColl|
	var mainWin, mainView, samplerLabel, samplerFileList, xsize, ysize, yposRelative, localBuff, fileListSelector, x3d_updateSoundFile, x3d_fileView;

	// internal function -- TESTING

	x3d_updateSoundFile = {|filePath|
		var soundfile;
		"INTERNAL FUNCTION".postln;
		soundfile = SoundFile.new;
		soundfile.openRead(filePath);
		x3d_fileView.soundfile = soundfile;            // set soundfile
		x3d_fileView.read(0, soundfile.numFrames);     // read in the entire file.
		x3d_fileView.refresh;                  // refresh to display the file.
		x3d_fileView.timeCursorPosition_(soundfile.numFrames/2);
		soundfile.close;
	};

	//x3d_updateSoundFile.value("ciccio");

	////////////////////////////////
	xsize = 600;
	ysize = 600;
	yposRelative = 0;
	if (xpos>0, { xpos.postln }, { xpos = 0 });
	if (ypos>0, { ypos.postln }, { ypos = 0 });
	if (parent == "",
		{
			"qui".postln;
			mainWin = Window("EEE Drum").setTopLeftBounds(Rect(xpos,ypos,xsize,ysize)).front;
		}, {
			mainWin = parent;
	});
	// creo il buffer con i suoni di default pe rpopolare la lista, la file view e suonare
	if (buffColl == "", { localBuff = SoundFile.collectIntoBuffers("/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/*"); }, { localBuff = buffColl });
	samplerFileList = Array.new(localBuff.size);
	localBuff.do({|item, idx| samplerFileList.add(localBuff[idx].path); });

	// G U I
	// creo la finestra interna per rendere indipendente la visualizzazione
	mainView = CompositeView(mainWin, Rect(xpos, ypos, xsize, ysize));
	// label della finestra di visualizzazione
	samplerLabel = StaticText(mainView, Rect(0, yposRelative, xsize / 2, 22))
	.string_("Lista dei campioni caricati in memoria");


	// popup list - stessa y position
	fileListSelector = PopUpMenu(mainView, Rect(xsize / 2, yposRelative, xsize / 2, 22))
	.items_([ "industrial", "berlin", "loops"])
	.action_({|me|
		me.value.postln;
		switch (me.value,
			0, {
				var list = Array.fill(~industrial.size, {arg idx; ~industrial[idx].path});
				samplerFileList.items_(list);
				localBuff = ~industrial;
				x3d_updateSoundFile.value(localBuff[0].path);
			},
			1, {
				var list = Array.fill(~berlin.size, {arg idx; ~berlin[idx].path});
				samplerFileList.items_(list);
				localBuff = ~berlin;
				x3d_updateSoundFile.value(localBuff[0].path);
			},
			2, { // dynamic - reload buffer every time
				var list, sf = SoundFile.collect("/home/hellska/soundAndSamples/samples/loops/*");
				~loops = SoundFile.collectIntoBuffers("/home/hellska/soundAndSamples/samples/loops/*");
				list = Array.fill(sf.size, {arg idx; sf[idx].path});
				samplerFileList.items_(list);
				localBuff = ~loops;
				x3d_updateSoundFile.value(sf[0].path);
			};

		);
	});

	// ricalcolo la posizione relativa
	yposRelative = yposRelative + 22;

	// sampler File List
	samplerFileList = ListView(mainView,Rect(0,yposRelative,xsize,100))
	.items_( samplerFileList )
	.background_(Color.white)
	.hiliteColor_(Color.green(alpha:0.6))
	.action_({ arg sbs;
		~currentSampleNo = 0;
		//~playBuff = ~lobo_CurrentSoundFileList[~ticView.value];
		~playBuff = localBuff[samplerFileList.value]; // need global variable for buffer to play ~playBuff ???
		x3d_updateSoundFile.value(localBuff[sbs.value].path.standardizePath);
	}).keyDownAction_({|i, char, uni, key|
		if ( key == 13 ) {
			"SUONO".postln;
			localBuff[samplerFileList.value].play;
		}
	});

	// ricalcolo la posizione relativa
	yposRelative = yposRelative + 100;

	// file viewer
	x3d_fileView = SoundFileView(mainView, Rect(0,yposRelative,xsize,178))
	.timeCursorOn_(true)
	.timeCursorColor_(Color.red);
	// imposto il contenuto
	x3d_updateSoundFile.value(localBuff[0].path);

};
)