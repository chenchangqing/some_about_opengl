//
//  ESView.m
//  OpenGL ES Texture
//
//  Created by lidehua on 15/7/23.
//  Copyright (c) 2015年 李德华. All rights reserved.
//

#import "ESView.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
@interface ESView()
@property (strong, nonatomic) CAEAGLLayer * eaglLayer;
@property (assign, nonatomic) GLuint renderBuffer;
@property (assign, nonatomic) GLuint frameBuffer;
@property (strong, nonatomic) EAGLContext * context;
@property (assign, nonatomic) GLuint positionSlot;
@property (assign, nonatomic) GLuint colorSlot;
@property (assign, nonatomic) GLuint progarmHandle;
@property (assign, nonatomic) GLuint texture;
@property (assign, nonatomic) GLuint texCoordSlot;
@property (assign, nonatomic) GLuint textureUniform;
@end
typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
} Vertex;
const Vertex Vertices[] = {
    {{1,-1,0},{1,0,0,1},{3,0}},
    {{1,1,0},{0,1,0,1},{3,3}},
    {{-1,1,0},{0,0,1,1},{0,3}},
    {{-1,-1,0},{0,0,0,1},{0,0}}
};
const GLubyte Indices[] = {
    0,1,2,
    2,3,0
};
@implementation ESView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
+(Class)layerClass {
    return [CAEAGLLayer class];
}
- (void)layoutSubviews {
    [self setup];
    [self compileShader];
    [self setupVBOs];
    
    [self render];
}
- (void)setup {
    
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
    _eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking:@NO,kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8};
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSAssert([EAGLContext setCurrentContext:_context], @"set context failed");
    
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
}
- (void)render {
    glClearColor(1.0, 1.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *)(sizeof(float) * 3));
    
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *)(sizeof(float) * 7));
    
    glActiveTexture(GL_TEXTURE0);
    
    glBindTexture(GL_TEXTURE_2D, _texture);
    
    glUniform1i(_textureUniform, 0);
    
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}
- (void)setupVBOs {
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
}
- (void)compileShader {
    GLuint vertexShader = [self compileShader:@"SimpleVertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment" withType:GL_FRAGMENT_SHADER];
    
    _texture = [self setupTexture:@"duck.png"];
    
    _progarmHandle = glCreateProgram();
    if (_progarmHandle == 0) {
        NSLog(@"create program failed");
    }
    glAttachShader(_progarmHandle, vertexShader);
    glAttachShader(_progarmHandle, fragmentShader);
    glLinkProgram(_progarmHandle);
    
    GLint linkSuccess;
    glGetProgramiv(_progarmHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar message[256];
        glGetProgramInfoLog(_progarmHandle, sizeof(message), 0, &message[0]);
        NSString * messageString = [NSString stringWithUTF8String:message];
        NSLog(@"%@",messageString);
    }
    glUseProgram(_progarmHandle);
    
    
    _texCoordSlot = glGetAttribLocation(_progarmHandle, "TexIN");
    _positionSlot = glGetAttribLocation(_progarmHandle, "Position");
    _colorSlot = glGetAttribLocation(_progarmHandle, "SourceColor");
    
    
    _textureUniform = glGetUniformLocation(_progarmHandle, "Texture");
    
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    glEnableVertexAttribArray(_texCoordSlot);
}
- (GLuint)compileShader:(NSString *)shaderName withType:(GLenum)shaderType {
    
    NSString * shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    
    NSError * error;
    
    NSString * shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    
    NSAssert(shaderString, @"load shaderString error");
    
    GLuint shaderHandle = glCreateShader(shaderType);
    
    const char * shaderStringUTF8 = [shaderString UTF8String];
    
    GLint shaderStringLength = (GLint)[shaderString length];
    
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    
    if (compileSuccess == GL_FALSE) {
        GLchar message[256];
        glGetShaderInfoLog(shaderHandle, sizeof(message), 0, &message[0]);
        NSString * messageString = [NSString stringWithUTF8String:message];
        NSLog(@"%@",messageString);
    }
    
    return shaderHandle;
}

- (GLuint)setupTexture:(NSString *)fileName {
    UIImage * image = [UIImage imageNamed:fileName];
    CGImageRef spriteImage = image.CGImage;
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    GLuint texName;
    
    glGenTextures(1, &texName);
    
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    
    return texName;
}

@end
