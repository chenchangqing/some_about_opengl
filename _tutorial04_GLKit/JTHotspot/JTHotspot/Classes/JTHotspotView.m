//
//  JTHotspotView.m
//  Pods
//
//  Created by green on 16/5/17.
//
//

#import "JTHotspotView.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>


/**
 *  顶点数据
 */
static const GLfloat g_vertex_buffer_data[] = {
    -1.0f, -1.0f, 0.0f,
    1.0f, -1.0f, 0.0f,
    1.0f,  1.0f, 0.0f,
    
    1.0f,  1.0f, 0.0f,
    -1.0f,  1.0f, 0.0f,
    -1.0f, -1.0f, 0.0f
};

/**
 *  颜色数据
 */
static const GLfloat g_color_buffer_data[] = {
    1, 0, 0, 1,
    0, 1, 0, 1,
    0, 0, 1, 1,
    1, 0, 0, 1,
    0, 1, 0, 1,
    0, 0, 1, 1
};

static const GLfloat g_uv_buffer_data[] = {
    0,0,
    1,0,
    1,1,
    1,1,
    0,1,
    0,0
};

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_TEXTURE_SAMPLER,
    NUM_UNIFORMS
};

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
    ATTRIB_TEXTURE,
    NUM_ATTRIBUTES
};

@interface JTHotspotView ()<GLKViewDelegate>{
    
    GLuint _program;
    GLint _uniforms[NUM_UNIFORMS];
    
    GLuint _vertexBuffer;
    GLuint _colorBuffer;
    GLuint _textureBuffer;
    GLuint _textureUVBuffer;
    GLuint _vertexArray;
}

@property (weak, nonatomic) GLKView *glkView;
@property (strong, nonatomic) CADisplayLink* displayLink;
@property (strong, nonatomic) EAGLContext *glkcontext;
@property (strong, nonatomic) NSMutableArray *hotspots;

@end

@implementation JTHotspotView

#pragma mark - Life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == _glkcontext) {
        [EAGLContext setCurrentContext:nil];
    }
    _glkcontext = nil;
    _displayLink.paused = YES;
    _displayLink = nil;
}

#pragma mark - Public

- (void)addHotspot:(HotspotItem *)item {
    
    [_hotspots addObject:item];
}

- (void)removeHotspot:(HotspotItem *)item {
    
    [_hotspots removeObject:item];
}

- (void)clearHotspots {
    
    [_hotspots removeAllObjects];
}

#pragma mark - Set up

- (void)setup {
    
    _glkcontext =[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GLKView *tglkView = [[GLKView alloc] initWithFrame:CGRectZero context:_glkcontext];
    [self addSubview:tglkView];
    _glkView = tglkView;
    
    _glkView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDictionary = @{@"tglkView":_glkView};
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tglkView]-0-|" options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tglkView]-0-|" options:0 metrics:nil views:viewsDictionary]];
    
    
    if (!_glkcontext) {
        NSLog(@"Failed to create ES context");
    }
    _glkView.delegate = self;
    _glkView.enableSetNeedsDisplay = NO;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:_glkView selector:@selector(display)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    _hotspots = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setupGL];
}

- (void)setupGL {
    
    // OpenGL相关
    [EAGLContext setCurrentContext:_glkcontext];
    
    [self loadShaders];
    
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_vertex_buffer_data), g_vertex_buffer_data, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_colorBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_color_buffer_data), g_color_buffer_data, GL_STATIC_DRAW);
    
    glGenBuffers(1,&_textureUVBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _textureUVBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_uv_buffer_data), g_uv_buffer_data, GL_STATIC_DRAW);
    
    [self setupTexture:@"leaves.gif"];
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);// 很关键
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    glEnableVertexAttribArray(ATTRIB_COLOR);
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);// 很关键
    glVertexAttribPointer(ATTRIB_COLOR, 4, GL_FLOAT, GL_FALSE, 0, 0);
    
    glEnableVertexAttribArray(ATTRIB_TEXTURE);
    glBindBuffer(GL_ARRAY_BUFFER, _textureUVBuffer);// 很关键
    glVertexAttribPointer(ATTRIB_TEXTURE, 2, GL_FLOAT, GL_FALSE, 0, 0);
    
    glBindVertexArrayOES(0);
}

#pragma mark - clearGL

- (void)tearDownGL {
    
    [EAGLContext setCurrentContext:_glkcontext];
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_colorBuffer);
    glDeleteBuffers(1, &_textureBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - Texture

- (GLuint)setupTexture:(NSString *)fileName {
    
    NSString* filePath = [NSString stringWithFormat:@"Frameworks/JTHotspot.framework/JTHotspot.Bundle/%@",fileName];
    UIImage * image = [UIImage imageNamed:filePath];
    CGImageRef spriteImage = image.CGImage;
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    glGenTextures(1, &_textureBuffer);
    
    glBindTexture(GL_TEXTURE_2D, _textureBuffer);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    // mvp
    float aspect = fabs(self.bounds.size.width / self.bounds.size.height);
    
    GLKMatrix4 mMatrix = GLKMatrix4Identity;
    GLKMatrix4 vMatrix = GLKMatrix4MakeLookAt(0, 0, 5, 0, 0, 0, 0, 1, 0);
    GLKMatrix4 pMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 0.1f, 10.0f);
    GLKMatrix4 mvMatrix = GLKMatrix4Multiply(mMatrix, vMatrix);
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(pMatrix, mvMatrix);
    
    // 绘制热点
    for (HotspotItem *item in _hotspots) {
        
        GLKMatrix4 resultMat = mvpMatrix;
        
        // 旋转
        GLKMatrix4 rotatXMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-item.rotation.xAngle), 1, 0, 0);
        GLKMatrix4 rotatYMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-item.rotation.yAngle), 0, 1, 0);
        GLKMatrix4 rotatZMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-item.rotation.zAngle), 0, 0, 1);
        
        resultMat = GLKMatrix4Multiply(resultMat, rotatXMatrix);
        resultMat = GLKMatrix4Multiply(resultMat, rotatYMatrix);
        resultMat = GLKMatrix4Multiply(resultMat, rotatZMatrix);
        
        // 缩放
        GLKMatrix4 scaleMatrix3 = GLKMatrix4MakeScale(item.scale.widthScale, item.scale.heigthScale, 1);
        
        resultMat = GLKMatrix4Multiply(resultMat, scaleMatrix3);
        
        // 位置
        GLKMatrix4 transMatrix3 = GLKMatrix4MakeTranslation(item.position.x, item.position.y, item.position.z);
        
        resultMat = GLKMatrix4Multiply(resultMat, transMatrix3);
        
        glUseProgram(_program);
        glUniform1i(_uniforms[UNIFORM_TEXTURE_SAMPLER], 0);
        glUniformMatrix4fv(_uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, resultMat.m);
        glDrawArrays(GL_TRIANGLES, 0, 6);
        
    }
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Frameworks/JTHotspot.framework/JTHotspot.Bundle/Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Frameworks/JTHotspot.framework/JTHotspot.Bundle/Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(_program, ATTRIB_COLOR, "color");
    glBindAttribLocation(_program, ATTRIB_TEXTURE, "textureuv");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    _uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    _uniforms[UNIFORM_TEXTURE_SAMPLER] = glGetUniformLocation(_program, "textureSampler");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
