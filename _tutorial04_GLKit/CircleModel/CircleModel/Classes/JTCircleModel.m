//
//  JTCircleModel.m
//  Pods
//
//  Created by green on 16/5/20.
//
//

#import "JTCircleModel.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    NUM_UNIFORMS
};

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    NUM_ATTRIBUTES
};

@interface JTCircleModel ()<GLKViewDelegate>{
    
    GLuint _program;
    GLint _uniforms[NUM_UNIFORMS];
    
    GLuint _vertexArray;
    
    GLuint _vertexBuffer;
    int pointCount;
    int segW;
    int segH;
}

@property (weak, nonatomic) GLKView *glkView;
@property (strong, nonatomic) CADisplayLink* displayLink;
@property (strong, nonatomic) EAGLContext *glkcontext;

@end

@implementation JTCircleModel

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
    
    [self setupGL];
}

- (void)setupGL {
    
    // OpenGL相关
    [EAGLContext setCurrentContext:_glkcontext];
    
    [self loadShaders];
    
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    
    [self createCircleMode];
    
}

/**
 *  圆模型
 */
-(void)createCircleMode{
    
    int vertexSize = 3;
    
    segW = 48;
    segH = 48;
    
    pointCount = segW * segH * vertexSize;
    float *vertices = (float*) malloc(sizeof(float) * pointCount);
    int kk = 0;
    for (int j = 1; j <= segH; j++) {
        
        double vj = 1.0 * j / segH;
        double deltT = (0.5 - vj) * M_PI;
        double cosdeltT = cos(deltT);
        double sindeltT = sin(deltT);
        
        printf("%lf,",deltT);
        printf("%lf,",cosdeltT);
        printf("%lf----- ----- ----- ----- -----\n",sindeltT);
        
        for (int i = 1; i <= segW; i++) {
            double ui = 2.0 * i / segW;
            double deltP = -ui * M_PI;
            float zz = (float) (cos(deltP) * cosdeltT);
            float xx = (float) (sin(deltP) * cosdeltT);
            float yy = (float) sindeltT;
            vertices[kk++] = xx;
            vertices[kk++] = yy;
            vertices[kk++] = zz;
            printf("%f,",xx);
            printf("%f,",yy);
            printf("%f\n",zz);
        }
    }
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, pointCount * sizeof(GLfloat), vertices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 3, NULL);
    
    glBindVertexArrayOES(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);

    
    //释放
    free(vertices);
    //==以上创建球模型==
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    //    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    // mvp
    float aspect = fabs(self.bounds.size.width / self.bounds.size.height);
    
    GLKMatrix4 mMatrix = GLKMatrix4Identity;
    GLKMatrix4 vMatrix = GLKMatrix4MakeLookAt(0, 0, 0.1+1.5, 0, 0, 0, 0, 1, 0);
    GLKMatrix4 pMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(100), aspect, 0.1f, 2.4f);
    GLKMatrix4 mvMatrix = GLKMatrix4Multiply(mMatrix, vMatrix);
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(pMatrix, mvMatrix);
    
    // 旋转
    GLKMatrix4 _mvMatrix = GLKMatrix4Identity;
    GLKMatrix4 xMatrix = GLKMatrix4MakeRotation(0, 1, 0, 0);
    GLKMatrix4 yMatrix = GLKMatrix4MakeRotation(0, 0, 1, 0);
    GLKMatrix4 zMatrix = GLKMatrix4MakeRotation(0, 0, 0, 1);
    _mvMatrix = GLKMatrix4Multiply(_mvMatrix, xMatrix);
    _mvMatrix = GLKMatrix4Multiply(_mvMatrix, yMatrix);
    _mvMatrix = GLKMatrix4Multiply(_mvMatrix, zMatrix);
    
    //    mvpMatrix = GLKMatrix4Multiply(mvpMatrix, _mvMatrix);
    mvpMatrix = GLKMatrix4Identity;
    
    glBindVertexArrayOES(_vertexArray);
    glUseProgram(_program);
    glUniformMatrix4fv(_uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, mvpMatrix.m);
    
    for (int i = 0; i < segH; i++) {
        
        glDrawArrays(GL_LINES, segW*i, segW);
    }
    
    GLKMatrix4 zMatrix2 = GLKMatrix4MakeRotation(90, 0, 0, 1);
    mvpMatrix = GLKMatrix4Multiply(mvpMatrix, zMatrix2);
    glUniformMatrix4fv(_uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, mvpMatrix.m);
    
    for (int i = 0; i < segH; i++) {
        
        glDrawArrays(GL_LINE_STRIP, segW*i, segW);
    }
    
    
}

#pragma mark - clearGL

- (void)tearDownGL {
    
    [EAGLContext setCurrentContext:_glkcontext];
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
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
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Frameworks/CircleModel.framework/CircleModel.bundle/Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Frameworks/CircleModel.framework/CircleModel.bundle/Shader" ofType:@"fsh"];
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
