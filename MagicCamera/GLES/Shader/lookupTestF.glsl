precision mediump float;

uniform sampler2D Texture;
uniform sampler2D lookupTexture

void main (void){
    
    vec4 textureColor = texture2D(Texture,TextureCoordsOut);
    highp float blue = textureColor.b;
    
    vec2 coord1;
    
    
    coord1.y = blue / 255 * 15 / 4
    coord1.x =
    
    

}
