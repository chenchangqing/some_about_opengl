attribute vec4 Position;

attribute vec4 SourceColor;

attribute vec2 TexIN;

varying vec4 DestinationColor;

varying vec2 TexCoordOut;

void main(void) {
    DestinationColor = SourceColor;
//    gl_Position = Position;
    gl_Position = Position;
    
    TexCoordOut = TexIN;
}