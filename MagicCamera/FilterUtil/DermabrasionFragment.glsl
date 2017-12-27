precision highp float;

varying highp vec2 textureCoordinate;
uniform sampler2D inputImageTexture;
uniform lowp float intensity;
uniform lowp float alpha;
uniform lowp float radius;


void main(void)
{
    highp float Wij = 0;
    highp float x = textureCoordinate.x
    highp float y = textureCoordinate.y
    highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    highp vec4 totalColor = vec4(0,0,0,0);
    for (i = x - 5; i < x + 5; i ++) {
        for (j = y - 5; j < y + 5; j ++) {
            highp vec4 textureColorNew = texture2D(inputImageTexture, vec2(x,y));
        }
    }
}



