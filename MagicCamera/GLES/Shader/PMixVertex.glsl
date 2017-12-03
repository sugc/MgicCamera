
attribute vec4 Position;
attribute vec2 TextCoords;
varying vec2 TextCoordsOut;



void main (){
    gl_Position = Position;
    TextCoordsOut = TextCoords;

}
