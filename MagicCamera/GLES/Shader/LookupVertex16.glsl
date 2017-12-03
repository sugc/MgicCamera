precision highp float;
attribute vec4 Position;
attribute vec2 TextureCoords;

varying vec2 TextureCoordsOut;

void main()
{
    TextureCoordsOut = TextureCoords;
    gl_Position = Position;
}
