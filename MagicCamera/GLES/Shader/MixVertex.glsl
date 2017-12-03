
attribute vec4 Position;
attribute vec2 TextureCoords;
varying vec2 TextureCoordsOut;

void main(void)
{
    gl_Position = Position;
    TextureCoordsOut = TextureCoords;
}
