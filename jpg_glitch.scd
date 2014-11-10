// code found @ "http://uiae.de/?p=110"
// based on: http://www.hellocatfood.com/create-jpgs-in-pure-data/
// test with jpeg data here: http://www.ffd8.org/header_remix/?showall=yup

// NOT WORKING ON ssd Disks !!!!

(
// make 10 glitched versions of a JPEG
10.do{ |i|
	// change here the path of the original image and the path to the glithced images
	var outfile;
	var inpath = "/Volumes/Macintosh HD/hellska/processing_sketchbook/image_control_center/data/LeftBrainRightBrain.jpg";
	var outpath = "/Volumes/Macintosh HD/hellska/LeftBrainRightBrain-glitch-%.jpg".format(i);
	var file = File.open(inpath.standardizePath, "rb");
	var data = file.length.collect{ file.getInt8 };
//	var data = file.size.collect{ file.getInt8 };

	// how many bytes to replace
	100.do{
		var pos = rrand(200, data.size - 10);
		data[pos] = 256.rand;
		// data[pos] = (data[pos] + 100.rand2).max(0).min(255);
	};

	// write out the file
	outfile = File.new(outpath, "wb");
	outfile.write(data.as(Int8Array));
	outfile.close;
	"---> wrote %".format(outpath).postln;
};
)



(
i = "/Users/hellska/Images/Simulacrum/60_22_aug_3.jpg";
i = "/Volumes/Macintosh HD/hellska/processing_sketchbook/image_control_center/data/LeftBrainRightBrain.jpg";
i = "/Users/hellska/Desktop/WFS_workshop/schedule_v2.pdf";
f = File.open(i.standardizePath, "rb");
g = f.length.collect({ f.getInt8 });
)

f.isOpen;
f.close;
// 15 pendulums in sync with the same phase
{o=0; 15.do{|i| o=o+LFTri.ar(138.59*(1.0595**(3*i)), 0, LFPulse.kr((51+i)/60, 0, 0.05, 0.1))}; o;}.play;

"/Users/hellska/Desktop/WFS_workshop/schedule_v2.pdf"
"/Volumes/Macintosh HD/hellska/processing_sketchbook/image_control_center/data/LeftBrainRightBrain.jpg"