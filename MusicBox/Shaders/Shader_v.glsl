attribute vec4 position;
attribute vec2 textCoordIn;

varying vec2 textCoordOut;

void main()
{
    gl_Position = position;
    textCoordOut = textCoordIn;
}
