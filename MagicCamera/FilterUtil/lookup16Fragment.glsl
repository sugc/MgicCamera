precision highp float;

varying highp vec2 textureCoordinate;
varying highp vec2 textureCoordinate2;
uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2; // lookup texture

uniform lowp float intensity;

void main(void)
{
    highp float width = 4.0;
    highp float count = 15.0;
    highp float size = 64.0;
    highp float factor = 0.25;
    highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    highp float blueColor = textureColor.b * count;
    
    highp vec2 quad1;
    quad1.y = floor(floor(blueColor) / width);
    quad1.x = floor(blueColor) - (quad1.y * width);
    
    highp vec2 quad2;
    quad2.y = floor(ceil(blueColor) / width);
    quad2.x = ceil(blueColor) - (quad2.y * width);
    
    highp vec2 texPos1;
    texPos1.x = (quad1.x * factor) + 0.5/size + ((factor - 1.0/size) * textureColor.r);
    texPos1.y = (quad1.y * factor) + 0.5/size + ((factor - 1.0/size) * textureColor.g);
    
    highp vec2 texPos2;
    texPos2.x = (quad2.x * factor) + 0.5/size + ((factor - 1.0/size) * textureColor.r);
    texPos2.y = (quad2.y * factor) + 0.5/size + ((factor - 1.0/size) * textureColor.g);
    
    highp vec4 newColor1 = texture2D(inputImageTexture2, texPos1);
    highp vec4 newColor2 = texture2D(inputImageTexture2, texPos2);
    
    highp vec4 newColor = mix(newColor1, newColor2, fract(blueColor));
    vec4 finalColor = mix(textureColor, vec4(newColor.rgb, textureColor.w), intensity);
    gl_FragColor = newColor;
}



