/*****
*
*   pathData.js
*
*   copyright 2001, Kevin Lindsey
*
*****/

/*****
*
*   PathData Object
*
*****/

/*****
*
*   PathData Class Variables
*
*****/
PathData.COMMAND = 0;
PathData.NUMBER  = 1;
PathData.EOD     = 2;

PathData.NEXTMODE = {
    M: "L",
    m: "l"
};


/*****
*
*   PathData Constructor
*
*****/
function PathData() {
    this.node     = null;
    this.segments = new Array();
}


/*****
*
*   loadDataFrom
*
*****/
PathData.prototype.loadDataFrom = function(node) {
    this.node = node;
    this.parseData(node.getAttributeNS(null, "d"));
}


/*****
*
*   loadCustomData
*
*****/
PathData.prototype.loadCustomData = function(node) {
    this.node = node;
    var nodes = node.getElementsByTagNameNS("http://www.kevlindev.com/dom/pathdata", "*");

    for ( var i = 0; i < nodes.length; i++ ) {
        var node  = nodes.item(i);
        this.appendSegment( new PathSegment(node) );
    }
    // Perhaps the user should perform this step in case
    // they want to manipulat the path before it appears
    this.applySegments();
}


/*****
*
*   applySegments
*
*****/
PathData.prototype.applySegments = function() {
    if ( this.node ) {
        this.node.setAttributeNS(null, "d", this.toString());
    }
}


/*****
*
*   appendSegment
*
*****/
PathData.prototype.appendSegment = function(pathSegment) {
    this.segments[this.segments.length] = pathSegment;
};


/*****
*
*   getSegmentsByCommandName
*
*****/
PathData.prototype.getSegmentsByCommandName = function(command) {
    var result   = new Array();
    var segments = this.segments;

    for ( var i = 0; i < segments.length; i++ ) {
        var segment = segments[i];
        
        if ( segment.command == command ) {
            result[result.length] = segment;
        }
    }

    return result;
};


/*****
*
*   item
*
*****/
PathData.prototype.item = function(index) {
    var result = null;
    
    if ( index >= 0 && index < this.segments.length ) {
        result = this.segments[index];
    }

    return result;
};


/*****
*
*   parseData
*
*****/
PathData.prototype.parseData = function(d) {
    var tokens = this.tokenize(d);
    var index  = 0;
    var token  = tokens[index];
    var mode   = "BOD";

    this.segments = new Array();

    while ( token.typeis(PathData.EOD) == false ) {
        var param_length;
        var params = new Array();

        if ( mode == "BOD" ) {
            if ( token.text == "M" || token.text == "m" ) {
                index++; // Advance past command token
                param_length = PathSegment.PARAMS[token.text].length;
                mode = token.text;
            } else {
                alert("Path must begin with a moveto command");
                break;
            }
        } else {
            if ( token.typeis(PathData.NUMBER) ) {
                param_length = PathSegment.PARAMS[mode].length;
            } else {
                index++; // Advance past command token
                param_length = PathSegment.PARAMS[token.text].length;
                mode = token.text;
            }
        }
        
        if ( (index + param_length) < tokens.length ) {
            for (var i = index; i < index + param_length; i++) {
                var number = tokens[i];
                
                if ( number.typeis(PathData.NUMBER) ) {
                    params[params.length] = number.text;
                } else {
                    alert("Parameter type is not a number");
                    break;
                }
            }
            
            this.appendSegment( new PathSegment(mode, params) );

            index += param_length;
            token = tokens[index];

            if ( mode == "M" || mode == "m" ) mode = PathData.NEXTMODE[mode];
        } else {
            alert("Path data ended before all parameters were found");
            break;
        }
    }
}


/*****
*
*   tokenize
*
*   Need to add support for scientific notation
*
*****/
PathData.prototype.tokenize = function(d) {
    var tokens = new Array();

    while ( d ) {
        if ( d.match(/^([ \t\r\n,]+)/) )
        {
            d = d.substr(RegExp.$1.length);
        }
        else if ( d.match(/^([aAcChHlLmMqQsStTvVzZ])/) )
        {
            tokens[tokens.length] = new Token(PathData.COMMAND, RegExp.$1);
            d = d.substr(RegExp.$1.length);
        }
        else if ( d.match(/^(([-+]?[0-9]+(\.[0-9]*)?|[-+]?\.[0-9]+)([eE][-+]?[0-9]+)?)/) )
        {
            tokens[tokens.length] = new Token(PathData.NUMBER, RegExp.$1);
            d = d.substr(RegExp.$1.length);
        }
        else
        {
            alert("Unrecognized segment command: " + d);
            d = "";
        }
    }

    tokens[tokens.length] = new Token(PathData.EOD, null);

    return tokens;
}


/*****
*
*   toString
*
*****/
PathData.prototype.toString = function() {
    var segments = this.segments;
    var seg_text = new Array();

    for ( var i = 0; i < segments.length; i++ ) {
        seg_text[seg_text.length] = segments[i].toString();
    }

    return seg_text.join(" ");
};


/*****
*
*   PathSegment Object
*
*****/

/*****
*
*   PathSegment Class Variables
*
*****/
PathSegment.PARAMS = {
    A: [ "rx", "ry", "xAxisRotation", "largeArcFlag", "sweepFlag", "x", "y" ],
    a: [ "rx", "ry", "xAxisRotation", "largeArcFlag", "sweepFlag", "x", "y" ],
    C: [ "x1", "y1", "x2", "y2", "x", "y" ],
    c: [ "x1", "y1", "x2", "y2", "x", "y" ],
    H: [ "x" ],
    h: [ "x" ],
    L: [ "x", "y" ],
    l: [ "x", "y" ],
    M: [ "x", "y" ],
    m: [ "x", "y" ],
    Q: [ "x1", "y1", "x", "y" ],
    q: [ "x1", "y1", "x", "y" ],
    S: [ "x2", "y2", "x", "y" ],
    s: [ "x2", "y2", "x", "y" ],
    T: [ "x", "y" ],
    t: [ "x", "y" ],
    V: [ "y" ],
    v: [ "y" ],
    Z: [],
    z: []
};

PathSegment.TAGMAP = {
    arc:                        "A",
    curveto:                    "C",
    'horizontal-lineto':        "H",
    lineto:                     "L",
    moveto:                     "M",
    'quadratic-curveto':        "Q",
    'smooth-curvto':            "S",
    'smooth-quadratic-curveto': "T",
    'vertical-lineto':          "V",
    'close-path':               "Z"
};


/*****
*
*   PathSegment constructor
*
*****/
function PathSegment(command, params) {
    switch ( arguments.length ) {
        case 0: alert("new PathSegment ( pd:node | command, param-array | command, param+ )");
        case 1: this.fromNode( arguments[0] ); break;
        case 2: this.fromArray( arguments[0], arguments[1] ); break;
        default: this.fromArray( arguments[0], arguments.slice(1) ); break;
    }
}


/*****
*
*   fromArray [constructor]
*
*****/
PathSegment.prototype.fromArray = function(command, params) {
    var param_names = PathSegment.PARAMS[command];
    
    if ( param_names != null ) {
        this.command = command;
        if ( params.length == param_names.length ) {
            for ( var i = 0; i < param_names.length; i++ ) {
                var param_name = param_names[i];
                
                this[param_name] = parseFloat(params[i]);
            }
        } else {
            alert("The '" + command + "' Segment Command requires " + param_names.length +
                  " parameters.\n  You supplied " + params.length + " parameters");
        }
    } else {
        alert("Unrecognized Segment Command: '" + command + "'");
    }
};


/*****
*
*   fromNode [constructor]
*
*****/
PathSegment.prototype.fromNode = function(node) {
    var command = PathSegment.TAGMAP[node.localName];

    if ( node.getAttributeNS(null, "position") == "relative" ) {
        command = command.toLowerCase();
    }

    this.command = command;
    var param_names = PathSegment.PARAMS[command];
    
    for ( var i = 0; i < param_names.length; i++ ) {
        var param_name = param_names[i];
        var attr_name  = param_name.replace(/([A-Z])/g, "-$1").toLowerCase();
        
        this[param_name] = parseFloat( node.getAttributeNS(null, attr_name) );
    }
};


/*****
*
*   toString
*
*****/
PathSegment.prototype.toString = function() {
    var param_names = PathSegment.PARAMS[this.command];
    var params = new Array();

    for ( var i = 0; i < param_names.length; i++ ) {
        params[params.length] = this[param_names[i]];
    }

    return this.command + params.join(",");
};


/*****
*
*   Token Object
*
*****/

/*****
*
*   Token constructor
*
*****/
function Token(type, text) {
    this.type = type;
    this.text = text;
}


/*****
*
*   typeis
*
*****/
Token.prototype.typeis = function(type) {
    return this.type == type;
}

