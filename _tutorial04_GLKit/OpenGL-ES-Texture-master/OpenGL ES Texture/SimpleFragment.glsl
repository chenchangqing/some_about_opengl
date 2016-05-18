varying lowp vec4 DestinationColor;

varying lowp vec2 TexCoordOut;

uniform sampler2D Texture;

void main(void) {
//    lowp float gray;
    lowp vec4 pixelColor = texture2D(Texture,TexCoordOut);
//    gray = pixelColor.r * 0.3 + pixelColor.g * 0.59 + pixelColor.b * 0.11;
//    pixelColor.r = 1.0 - pixelColor.r;
//    pixelColor.g = 1.0 - pixelColor.g;
//    pixelColor.b = 1.0 - pixelColor.b;
    gl_FragColor = pixelColor;
//    gl_FragColor = DestinationColor * texture2D(Texture,TexCoordOut);
}