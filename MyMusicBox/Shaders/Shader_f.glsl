varying lowp vec4 colorVarying;
varying lowp vec2 textCoordOut;
varying lowp float alphaValueOut;
uniform sampler2D Texture;

void main()
{
    gl_FragColor = texture2D(Texture, textCoordOut) * alphaValueOut;
}
