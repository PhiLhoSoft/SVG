/*****
*
*   SampleHandler.js
*
*   copyright 2003, Kevin Lindsey
*   licensing info available at: http://www.kevlindev.com/license.txt
*
*****/

/*****
*
*   class variables
*
*****/
SampleHandler.VERSION = 1.0;


/*****
*
*   constructor
*
*****/
function SampleHandler() { }


/*****
*
*   show
*
*****/
SampleHandler.prototype.show = function(name, params) {
    var result = [];
    var args = [];

    for (var i = 0; i < params.length; i++ )
        args[i] = params[i];

    result.push(name);
    result.push("(");
    result.push(args.join(","));
    result.push(")");

    println(result.join(""));
};


/*****
*
*   arcAbs - A
*
*****/
SampleHandler.prototype.arcAbs = function(rx, ry, xAxisRotation, largeArcFlag, sweepFlag, x, y) {
    this.show("arcAbs", arguments);
};


/*****
*
*   arcRel - a
*
*****/
SampleHandler.prototype.arcRel = function(rx, ry, xAxisRotation, largeArcFlag, sweepFlag, x, y) {
    this.show("arcRel", arguments);
};


/*****
*
*   curvetoCubicAbs - C
*
*****/
SampleHandler.prototype.curvetoCubicAbs = function(x1, y1, x2, y2, x, y) {
    this.show("curvetoCubicAbs", arguments);
};


/*****
*
*   curvetoCubicRel - c
*
*****/
SampleHandler.prototype.curvetoCubicRel = function(x1, y1, x2, y2, x, y) {
    this.show("curvetoCubicRel", arguments);
};


/*****
*
*   linetoHorizontalAbs - H
*
*****/
SampleHandler.prototype.linetoHorizontalAbs = function(x) {
    this.show("linetoHorizontalAbs", arguments);
};


/*****
*
*   linetoHorizontalRel - h
*
*****/
SampleHandler.prototype.linetoHorizontalRel = function(x) {
    this.show("linetoHorizontalRel", arguments);
};


/*****
*
*   linetoAbs - L
*
*****/
SampleHandler.prototype.linetoAbs = function(x, y) {
    this.show("linetoAbs", arguments);
};


/*****
*
*   linetoRel - l
*
*****/
SampleHandler.prototype.linetoRel = function(x, y) {
    this.show("linetoRel", arguments);
};


/*****
*
*   movetoAbs - M
*
*****/
SampleHandler.prototype.movetoAbs = function(x, y) {
    this.show("movetoAbs", arguments);
};


/*****
*
*   movetoRel - m
*
*****/
SampleHandler.prototype.movetoRel = function(x, y) {
    this.show("movetoRel", arguments);
};


/*****
*
*   curvetoQuadraticAbs - Q
*
*****/
SampleHandler.prototype.curvetoQuadraticAbs = function(x1, y1, x, y) {
    this.show("curvetoQuadraticAbs", arguments);
};


/*****
*
*   curvetoQuadraticRel - q
*
*****/
SampleHandler.prototype.curvetoQuadraticRel = function(x1, y1, x, y) {
    this.show("curvetoQuadraticRel", arguments);
};


/*****
*
*   curvetoCubicSmoothAbs - S
*
*****/
SampleHandler.prototype.curvetoCubicSmoothAbs = function(x2, y2, x, y) {
    this.show("curvetoCubicSmoothAbs", arguments);
};


/*****
*
*   curvetoCubicSmoothRel - s
*
*****/
SampleHandler.prototype.curvetoCubicSmoothRel = function(x2, y2, x, y) {
    this.show("curvetoCubicSmoothRel", arguments);
};


/*****
*
*   curvetoQuadraticSmoothAbs - T
*
*****/
SampleHandler.prototype.curvetoQuadraticSmoothAbs = function(x, y) {
    this.show("curvetoQuadraticSmoothAbs", arguments);
};


/*****
*
*   curvetoQuadraticSmoothRel - t
*
*****/
SampleHandler.prototype.curvetoQuadraticSmoothRel = function(x, y) {
    this.show("curvetoQuadraticSmoothRel", arguments);
};


/*****
*
*   linetoVerticalAbs - V
*
*****/
SampleHandler.prototype.linetoVerticalAbs = function(y) {
    this.show("linetoVerticalAbs", arguments);
};


/*****
*
*   linetoVerticalRel - v
*
*****/
SampleHandler.prototype.linetoVerticalRel = function(y) {
    this.show("linetoVerticalRel", arguments);
};


/*****
*
*   closePath - z or Z
*
*****/
SampleHandler.prototype.closePath = function() {
    this.show("closePath", arguments);
};
