/* 
  LookupFragment.strings
  Purika

  Created by zj－db0548 on 2017/1/27.
  Copyright © 2017年 魔方. All rights reserved.
*/
precision mediump float;

uniform sampler2D lookupTexture;
uniform sampler2D Texture;

varying vec2 TextureCoordsOut;
//uniform lowp float intensity;

void main(void)
{
    
    vec4 textureColor = texture2D(Texture, TextureCoordsOut);
    
    float blueColor = textureColor.b * 63.0;
    
    vec2 quad1;
    quad1.y = floor(floor(blueColor) / 8.0);
    quad1.x = floor(blueColor) - (quad1.y * 8.0);
    
    vec2 quad2;
    quad2.y = floor(ceil(blueColor) / 8.0);
    quad2.x = ceil(blueColor) - (quad2.y * 8.0);
    
    vec2 texPos1;
    texPos1.x = (quad1.x * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.r);
    texPos1.y = (quad1.y * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.g);
    
    vec2 texPos2;
    texPos2.x = (quad2.x * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.r);
    texPos2.y = (quad2.y * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.g);
    
    vec4 newColor1 = texture2D(lookupTexture, texPos1);
    vec4 newColor2 = texture2D(lookupTexture, texPos2);
    
    vec4 newColor = mix(newColor1, newColor2, fract(blueColor));
    gl_FragColor = texture2D(Texture, TextureCoordsOut);
}

