(
var speakerList, x=200, y=150, targx=200, targy=150;
var atorad = (2pi) / 360, rtoang = 360.0 / (2pi);
var targRotate, actRotate, targPoint, actPoint;
var maxShiftPerFrame = 20, frameInterval = 0.01;
var resched = false, count = 0;
var panBus, widthBus, recButton;
var a, b, c, e;

maxShiftPerFrame = maxShiftPerFrame * atorad;
actPoint = Point(x, y) - Point(200, 200);
panBus = Bus.control;
widthBus = Bus.control.set(60);

w = GUI.window.new("5.1 Panner", Rect(128, 64, 400, 450)).front;
w.view.background_(Color.grey(0.3));
w.view.decorator = FlowLayout(w.view.bounds);
// speakerList = [[-30, "L"], [30, "R"], [0, "C"], [-110, "Ls"], [110, "Rs"]];
speakerList = [[-45, "L"], [46, "R"], [0, "C"], [-90, "Ls"], [90, "Rs"], [-180, "B"], [-135, "Lb"], [135, "Rb"]];
c = GUI.userView.new(w,Rect(0, 0, 400, 380));
c.canFocus = false;

c.drawFunc = {
    Color.grey(0.8).set;
    // draw the speaker layout
    GUI.pen.translate(200,200);
    ((actPoint.theta + (0.5pi)).wrap2(pi) * rtoang).round(0.01).asString.drawCenteredIn(Rect.aboutPoint(0@170, 30, 10), GUI.font.new("Arial", 10), Color.grey(0.8));
    GUI.pen.strokeOval(Rect.aboutPoint(0@0, 150, 150));
    GUI.pen.rotate(pi);
    speakerList.do({|spkr|
        GUI.pen.use({
            GUI.pen.rotate(spkr[0] * atorad);
            GUI.pen.moveTo(0@170);
            GUI.pen.strokeRect(r = Rect.aboutPoint(0@170, 30, 10));
            if(spkr[0].abs < 90, {
                GUI.pen.use({
                    GUI.pen.translate(0, 170);
                    GUI.pen.rotate(pi);
                    spkr[1].drawCenteredIn(Rect.aboutPoint(0@0, 30, 10),
                        GUI.font.new("Arial", 10), Color.grey(0.8));
                });
            },{
                spkr[1].drawCenteredIn(r, GUI.font.new("Arial", 10), Color.grey(0.8));
            });
        });
    });

    GUI.pen.moveTo(0@0);

    // draw the pan point
    GUI.pen.rotate(actPoint.theta + 0.5pi);
    targPoint = Point(x, y) - Point(200, 200);
    // trunc to avoid loops due to fp math
    targRotate = (targPoint.theta - actPoint.theta).trunc(1e-15);
    // wrap around
    if(targRotate.abs > pi, {targRotate = (2pi - targRotate.abs) * targRotate.sign.neg});
    actRotate = targRotate.clip2(maxShiftPerFrame).trunc(1e-15);
    actPoint = actPoint.rotate(actRotate);
    GUI.pen.rotate(actRotate);
    GUI.pen.lineTo(0@150);
    GUI.pen.stroke;
    GUI.pen.fillOval(Rect.aboutPoint(0@150, 7, 7));
    GUI.pen.addWedge(0@0, 140, neg(e.value * 0.5) * atorad + 0.5pi, e.value * atorad);
    GUI.pen.stroke;
    Color.grey(0.8).alpha_(0.1).set;
    GUI.pen.addWedge(0@0, 140, neg(e.value * 0.5) * atorad + 0.5pi, e.value * atorad);
    GUI.pen.fill;

    if((actRotate.abs > 0), {AppClock.sched(frameInterval, {w.refresh})}, {count = 0;});
    if(count%4 == 0, {panBus.set((actPoint.theta + (0.5pi)).wrap2(pi) * rtoang)});
};
//c.mouseTrackFunc_({|v,inx,iny| x = inx; y = iny; w.refresh;});
//c.mouseBeginTrackFunc_({|v,inx,iny| x = inx; y = iny; w.refresh;});
c.mouseDownAction_({|v,inx,iny| x = inx; y = iny; w.refresh;});

e = GUI.ezSlider.new(w, 380@20, "Stereo Width", [0, 180].asSpec, {arg ez; widthBus.set(ez.value); w.refresh}, 60);
e.labelView.setProperty(\stringColor,Color.grey(0.8));

w.refresh;

// VBAP

a = VBAPSpeakerArray.new(2, speakerList.collect(_.first));
b = Buffer.loadCollection(s, a.getSetsAndMatrices;);

SynthDef('VBAP 5 chan', { |azi = 0, ele = 0, spr = 0, width = 60, vbapBuf|
var panned, source, idx;
idx = rand(~bufDrumkit.size);
source = Pan2.ar(GrainBuf.ar(1,Impulse.kr(1.6666*4),1,~bufDrumkit[idx],SinOsc.kr(0.5)+1,~bufDrumkit[idx].numFrames*SawDPW.kr(0.6)));
//	SinOsc.ar([440, 660], 0, Decay2.ar(Impulse.ar([1, 0.9]), 0.1, 0.2));
azi = azi.circleRamp;
panned = VBAP.ar(5, source, vbapBuf, [azi - (0.5 * width), azi + (0.5 * width)], ele, spr);
// 'standard' channel order for 5.1
[0, 1, 2, 4, 5].do({arg bus, i; Out.ar(bus, panned[0][i])});
[0, 1, 2, 4, 5].do({arg bus, i; Out.ar(bus, panned[1][i])});

}).play(s, [vbapBuf: b.bufnum, azi: panBus.asMap, width: widthBus.asMap]);

)