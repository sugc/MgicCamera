
attribute vec4 Position;
attribute vec2 TextCoords;
attribute vec2 TextCoordsPip;
varying vec2 TextCoordsOut;
varying vec2 TextCoordsOutPip;


void main(void){
    gl_Position = position;
    textCoordsOut = textCoords;
    textCoordsOutPip = textCoordsPip;
}
