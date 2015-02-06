Collection.dumpAllMethods;
Collection.dumpClassSubtree;
Collection.dumpFullInterface;
Collection.dumpSubclassList;
Collection.dumpMethodList;

(
{
        var sig = Pluck.ar(PinkNoise.ar, Impulse.ar(0.5), 110.reciprocal, 110.reciprocal, 10, 0.1) * 0.1;
        DelayL.ar(sig, 0.2, SinOsc.kr(MouseX.kr(4,10)).range(0, MouseY.kr(0.002, 0)));
}.play
)

( // simple tempo tap
var num = 5, times = nil!num, i = 0, prev,
w = Window('tap').front.view.mouseDownAction = {
        var now = AppClock.seconds, tempo;
        times.wrapPut(i, now - (prev?now));
        prev = now; i = i + 1 mod: num;
        tempo = times.reject(_.isNil).mean;
        if(tempo != 0, { TempoClock.default.tempo = tempo.reciprocal.debug('tempo') }) };
)

(
/* accoppiamento di view e controller */
var window, knob, screen ; // dichiarazione delle variabili usate
// una finestra contenitore
window = Window.new("A knob", Rect.new(0,0, 150, 100)) ;
window.background = Color.black ;
// una manopola nella finestra, range: [0,1]
knob = Knob.new(window, Rect(50, 25, 50, 50)) ;
knob.value = 0.5 ;

vol = Volume.new(window, Rect(0, 0, 30, 300));

// azione associata a knob
knob.action_({ arg me;
    var red, blue, green ;
    red = me.value ;
    green = red*0.5 ;
    blue = 0.25+(red*0.75) ;
    ["red, green, blue", red, green, blue].postln  ;
    window.background = Color(red, green, blue);
});
// non dimenticarmi
window.front ;
)


(
/*
Simple Color Selector
RGB-HSV
*/
var window = Window("Color Selector", Rect(100, 100, 300, 270) ).front ;
var guiArr, step = 50 ;
var flag = \rgb , colorFunc ;
var colorArr = [0,0,0] ;
colorFunc = { arg flag, cls;
    var color, v1, v2, v3 ;
    # v1, v2, v3 = cls ;
    if(flag == \rgb ){
        color = Color(v1, v2, v3)
    }{
color = Color.hsv(v1.min(0.999), v2, v3) };
color ; };
Button(window, Rect(10, 200, 100, 50))
.states_([["RGB", Color.white, Color.red], ["HSV", Color.white, Color.black]])
.action_({ arg me; if (me.value == 0) {flag = \rgb } {flag = \hsv } });
guiArr = Array.fill(3, { arg i ;
    [
        Slider(window, Rect(10, (step+10*i+10), 100, step)),
        StaticText(window, Rect(120, (step+10*i+10), 120, step))
    ]
}) ;
guiArr.do{|item, index|
    item[0].action_{|me|
        item[1].string_(me.value) ;
        colorArr[index] = me.value ;
        window.background_(colorFunc.value(flag, colorArr));
}} ; )

