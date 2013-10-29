attribute vec4 position;
attribute vec2 textCoordIn;
attribute float alphaValue;

varying vec2 textCoordOut;
varying float alphaValueOut;

void main()
{
    gl_Position = position;
    textCoordOut = textCoordIn;
    alphaValueOut = alphaValue;
}
