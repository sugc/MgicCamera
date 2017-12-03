precision mediump float;

uniform sampler2D Texture;
uniform sampler2D TexturePip;
varying vec2 TextureCoordsOut;
varying vec2 TextureCoordsOutPip;

void main(void){
    
    vec4 mask = texture2D(texture,TextureCoordsOut);
    vec4 maskPip = texture2D(texturePip,TextureCoordsOutPip);
    
    gl_FragColor = vec4(mask.rgb,0);

}
