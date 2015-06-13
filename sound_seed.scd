// Generatore di Grani
(
SynthDef(\singlegrain, {
	|outbus = 0,
	freq = 440,
	length = 50, // ms range(50,250)
	amp = 0.8|
	var dur, env, grain;
	dur = 1 / 1000 * length;
	env = EnvGen.kr(Env([0, 1, 0], [dur/2, dur/2], \sine),doneAction:2); //Gaussian-shaped
	grain = SinOsc.ar([freq,freq],mul:amp) * env;
	Out.ar(outbus, grain)
}).send(s);
// draw GUI
~soundseed_w = Window.new("Sound Seed", Rect(10, 500, 600, 350)).front;
~cagrid = BoxGrid.new(~soundseed_w, bounds: Rect(20, 20, 300, 300), columns: 16, rows: 16);
~caplay = Button(~soundseed_w,Rect(350,20,30,30));
~carandConfig = Button(~soundseed_w,Rect(350,70,60,30));
~carandConfigSized = Button(~soundseed_w,Rect(420,70,60,30));
~carandConfigSizedNbox = NumberBox(~soundseed_w,Rect(490,70,30,30));
~cageneration = Button(~soundseed_w,Rect(350,170,40,30));
// behaviour definition
~caplay
.states_([
	[">",Color.black,Color.gray],
	[">",Color.black,Color.green]])
.action_({|me|
	if (me.value==1){
		~tas.play
	} {
		~tas.stop
}});
~carandConfig
.states_([["Random",Color.black,Color.gray]])
.action_({|me|
	if (~carandConfigSized.value==0) {
		~randConfig.value(16)
	} {
		~randConfigSized.value(16,~carandConfigSizedNbox.value)
	}
});
~carandConfigSized
.states_([
	["Cell No",Color.black,Color.gray],
	["Cell No",Color.black,Color.green]]);
//.action_({|me| ~randConfigSized.value(16,~carandConfigSizedNbox.value) });
~carandConfigSizedNbox.value_(5);
~cageneration
.states_([["GoL",Color.black,Color.gray]])
.action_({ ~gameOfLife.value(~cagrid) });
// read column from the CA BoxGrid
~readcol = {|col|
	var my2d,bfreq,freq,lenght,amp,dur;
	bfreq = 80;
	freq = List[];
	lenght = List[];
	//col.postln;
	my2d = Array2D.fromArray(16,16,~cagrid.getNodeStates.flat);
//	my2d.colAt(col).postln;
	dur = rand(200) + 50;
	my2d.colAt(col).do{
		|me,idx|
		if (me==1) {
			freq.add(idx + 1 * bfreq/2);
			// different length for each sine of the column
			// lenght.add(rand(200) + 50);
			// same length for each grain of the column
			lenght.add(dur);
		}
	};
//	freq.postln;
//	lenght.postln;
	amp = 1 / freq.size;
	freq.size.do{|idx| Synth(\singlegrain, [\freq, freq[idx], \length, lenght[idx],\amp,amp]) };
};
// sequencer - read each column every timestep
~sequencer = {|cols|
	cols.do{|i|
		var step;
		if (~rnd==nil){~rnd=0};
		step = ~timestep + rand(~rnd);
//		("Current Column "++i).postln;
		~readcol.value(i);
		step.wait;
	}
};
// generation of random configuration
~randConfig = {|side|
	var matrix;
	matrix = Array.fill(side*side, { rrand(0,1) }).clump(16);
	~cagrid.setNodeStates_(matrix);
};
// generate a fixed number of active cells in random positions
~randConfigSized = {|side,size|
	var matrix;
	matrix = Array.fill(side*side, 0).clump(16);
	size.do{
		var x,y;
		x = rand(16);
		y = rand(16);
		matrix[x][y] = 1;
	};
	~cagrid.setNodeStates_(matrix);
};
//
~timestep = 0.03;
// componente randomica per rendere il sequencer meno prevedibile
// sviluppare perlin noise per il calcolo di un valore più naturale
~rnd = 0.03;
// when use variable in a loop inside a Task and you update
~tas = Task{ loop{
	~sequencer.value(16,~timestep,~rnd);
//	"CA Generation".postln;
//	~randConfig.value(16);
	~gameOfLife.value(~cagrid);
	}
};
~gameOfLife = {|boxGrid,rows=16,cols=16|
	var grid,newgrid,x,y,liceCellCount,xmap,ymap;
	liceCellCount = 0;
	xmap = [-1,-1,-1,0,0,1,1,1];
	ymap = [-1,0,1,-1,1,-1,0,1];
	grid = Array2D.fromArray(rows,cols,boxGrid.getNodeStates.flat);
	newgrid = Array.fill(rows*cols, 0).clump(rows);
	x = grid.cols -2;
	y = grid.rows -2;
	y.do{|row|
		x.do{|col|
			var xc,yc,cell,neiCount;
			neiCount = 0;
			// calc array2D indexs to avoid borders
			xc = col+1;
			yc = row+1;
			//("Row: "++yc++" Col: "++xc++" Value: "++boxGrid.getState(xc,yc)).postln;
			//cell = boxGrid.getState(xc,yc);
			cell = grid[yc,xc];
			// count live cells
			if (cell==1){ liceCellCount = liceCellCount+1 };
			// count the neighbours
			xmap.size.do{|idx|
				var neighbour,nx,ny;
//				xmap[idx].postln;
				nx = xc + xmap[idx];
				ny = yc + ymap[idx];
				//neighbour = boxGrid.getState(nx,ny);
				neighbour = grid[ny,nx];
				if (neighbour==1){neiCount = neiCount+1};
			};
			// Implement the rules
			if (cell==1) {
				newgrid[yc][xc] = 1;
//				("Alive neighbours: "++neiCount).postln;
				// conway rule 1
				if (neiCount<2) {
					//boxGrid.setState_(xc,yc,0);
					newgrid[yc][xc] = 0;
					("apply rule 1 on x: "++yc++" y: "++xc).postln;
				};

				// conway rule 2 is implicit
				// conway rule 3
				if (neiCount>3) {
					//boxGrid.setState_(xc,yc,0);
					newgrid[yc][xc] = 0;
					("apply rule 3 on x: "++yc++" y: "++xc).postln;
				};
			};
			if (cell==0) {
				// conway rule 4
				if (neiCount==3) {
					//boxGrid.setState_(xc,yc,1);
					newgrid[yc][xc] = 1;
					("apply rule 4 on x: "++yc++" y: "++xc).postln;
				};
			}
		}
	};
	boxGrid.setNodeStates_(newgrid);
	liceCellCount.postln;
	grid.postln;
	newgrid
};
)
///////////////
// MANUAL EXECUTION - also controlled by GUI
///////////////
~tas.play;
~tas.stop;

~timestep = 0.0019;
~rnd = 0.05;