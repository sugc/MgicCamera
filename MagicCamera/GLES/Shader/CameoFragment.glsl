precision highp float;
varying vec2 TextureCoordsOut;

uniform sampler2D Texture;

void main(void)
{
    vec4 desColor;
    vec4 cuColor = texture2D(Texture,TextureCoordsOut);

    vec2 letTextCoord = vec2(TextureCoordsOut.x - 1.0/500.0, TextureCoordsOut.y - 1.0/500.0);
    vec4 leftUpColor = texture2D(Texture,letTextCoord);
    desColor = cuColor - leftUpColor;
    
    float h = 0.3*desColor.x + 0.59*desColor.y + 0.11*desColor.z;
    
    vec4 bkColor = vec4(0.5, 0.5, 0.5, 1.0);
    
    gl_FragColor = vec4(h,h,h,0.0) +bkColor;
}
