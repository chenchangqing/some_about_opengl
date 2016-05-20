//
//  JTSphereModel.m
//  Pods
//
//  Created by green on 16/5/19.
//
//

#import "JTSphereModel.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>

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
    ATTRIB_TEXCOORD,
    NUM_ATTRIBUTES
};

@interface JTSphereModel ()<GLKViewDelegate>{
    
    GLuint _program;
    GLint _uniforms[NUM_UNIFORMS];
    
    GLuint _vertexBuffer;
    GLuint _texCoordBuffer;
    GLuint _inducesBuffer;
    GLuint _vertexArray;
    GLuint _textureBuffer;
    
    int _triagleCount;
}

@property (weak, nonatomic) GLKView *glkView;
@property (strong, nonatomic) CADisplayLink* displayLink;
@property (strong, nonatomic) EAGLContext *glkcontext;
@property (strong, nonatomic) GLKTextureInfo* textureInfo;
@property (nonatomic,assign) float yaw;
@property (nonatomic,assign) float pitch;
@property (nonatomic,assign) CGPoint velocityValue;
@property (nonatomic,assign) CGPoint beginPoint;
@property (nonatomic,assign) CGPoint previousPoint;

@end

@implementation JTSphereModel

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
    [self setupGestures];
}

- (void)setupGL {
    
    // OpenGL相关
    [EAGLContext setCurrentContext:_glkcontext];
    
    [self loadShaders];
    
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    
    [self createSphereMode];
    
}

#pragma mark - Yaw/Pitch

-(void)setYaw:(float)yaw {
    if (yaw < 0) {
        yaw += M_PI * 2;
    } else if (yaw > M_PI * 2) {
        yaw -= M_PI * 2;
    }
    _yaw = yaw ;
}

-(void)setPitch:(float)pitch {
    _pitch = pitch;
}

#pragma mark - Gestures

- (void)setupGestures {
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    panGesture.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:panGesture];
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint currentPoint = [panGesture locationInView:panGesture.view];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateEnded: {
            self.velocityValue = [panGesture velocityInView:panGesture.view];
            break;
        }
        case UIGestureRecognizerStateBegan: {
            self.beginPoint = currentPoint;
            self.previousPoint = currentPoint;
            self.velocityValue = CGPointZero;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self moveToPointX:currentPoint.x - self.previousPoint.x andPointY:currentPoint.y - self.previousPoint.y];
            self.previousPoint = currentPoint;
            break;
        }
        default:
            break;
    }
    
    
}
- (void)moveToPointX:(CGFloat)pointX andPointY:(CGFloat)pointY
{
    pointX *= 0.005;
    pointY *= 0.005;
    float newYaw = _yaw - pointX / 1;
    float newPitch = _pitch - pointY / 1;
    //限制pitch在-90到90之间
    if(newPitch > M_PI_2)
    {
        newPitch = M_PI_2;
    }else if(newPitch < -M_PI_2)
    {
        newPitch = -M_PI_2;
    }
    //to do 可以限制yaw在 0到360度之间
    
    self.yaw = newYaw;
    self.pitch = newPitch;
    
}

/**
 *  球模型
 */
-(void)createSphereMode{
    //==以下创建球模型==
    int segW = 48;// 宽度分块数目
    int segH = 48;// 高度分块数目
    int segW1 = segW + 1;// 宽度分块顶点数目
    int segH1 = segH + 1;// 高度分块顶点数目
    // 顶点坐标
    int vertexSize = 3;//一个点x/y/z三个坐标
    int vertexCount = segW1 * segH1 * vertexSize;
    float *vertices = (float*) malloc(sizeof(float) * vertexCount);
    int kk = 0;
    for (int j = 0; j < segH1; j++) {
        double vj = 1.0 * j / segH;
        double deltT = (0.5 - vj) * M_PI;
        double cosdeltT = cos(deltT);
        double sindeltT = sin(deltT);
        for (int i = 0; i < segW1; i++) {
            double ui = 2.0 * i / segW;
            double deltP = -ui * M_PI;
            float zz = (float) (cos(deltP) * cosdeltT);
            float xx = (float) (sin(deltP) * cosdeltT);
            float yy = (float) sindeltT;
            vertices[kk++] = xx;
            vertices[kk++] = yy;
            vertices[kk++] = zz;
        }
    }
    // 纹理坐标
    int textureCount = segW1 * segH1 * 2;
    float *texcoords = (float*) malloc(sizeof(float) *textureCount);
    kk = 0;
    for (int j = 0; j < segH1; j++) {
        double vj = 1.0 * j / segH;
        for (int i = 0; i < segW1; i++) {
            double ui = 1.0 * i / segW;
            texcoords[kk++] = (float) ui;
            texcoords[kk++] = 1 - (float) vj;//跟android相比，纹理v坐标上下颠倒，因为坐标系问题
        }
    }
    
    // 三角形编号
    _triagleCount = segW * segH * 2 * 3;//三角形总数目
    unsigned short *indices = (unsigned short *) malloc(sizeof(unsigned short) * _triagleCount);
    kk = 0;
    for (int j = 0; j < segH; j++) {
        int m = j * segW1;
        int n = m + segW1;
        for (int i = 0; i < segW; i++) {
            int h0 = i + m;
            int h1 = h0 + 1;
            int h3 = i + n;
            int h2 = h3 + 1;
            indices[kk++] = (short) h0;
            indices[kk++] = (short) h2;
            indices[kk++] = (short) h1;
            
            indices[kk++] = (short) h0;
            indices[kk++] = (short) h3;
            indices[kk++] = (short) h2;
        }
    }
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(GLfloat), vertices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 3, NULL);
    
    NSString* filePath = [NSString stringWithFormat:@"Frameworks/SphereModel.framework/SphereModel.Bundle/%@",@"pano_sphere.jpg"];
    UIImage * image = [UIImage imageNamed:filePath];
    _textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:nil error:nil];
    _textureBuffer = _textureInfo.name;
    
    glGenBuffers(1, &_texCoordBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _texCoordBuffer);
    glBufferData(GL_ARRAY_BUFFER, textureCount * sizeof(GLfloat), texcoords, GL_STATIC_DRAW);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glEnableVertexAttribArray(ATTRIB_TEXCOORD);
    glBindBuffer(GL_ARRAY_BUFFER, _texCoordBuffer);
    glVertexAttribPointer(ATTRIB_TEXCOORD, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 2, NULL);
    
    glGenBuffers(1, &_inducesBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _inducesBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _triagleCount * sizeof(GLushort), indices, GL_STATIC_DRAW);
    
    glBindVertexArrayOES(0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    //释放
    free(vertices);
    free(texcoords);
    free(indices);
    //==以上创建球模型==
}

#pragma mark - clearGL

- (void)tearDownGL {
    
    [EAGLContext setCurrentContext:_glkcontext];
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_inducesBuffer);
    glDeleteBuffers(1, &_texCoordBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
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
    GLKMatrix4 vMatrix = GLKMatrix4MakeLookAt(0, 0, 0.1, 0, 0, 0, 0, -1, 0);
    GLKMatrix4 pMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(100), aspect, 0.1f, 2.4f);
    GLKMatrix4 mvMatrix = GLKMatrix4Multiply(mMatrix, vMatrix);
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(pMatrix, mvMatrix);
    
    // 旋转
    GLKMatrix4 _mvMatrix = GLKMatrix4Identity;
    GLKMatrix4 yawMatrix = GLKMatrix4MakeRotation(self.yaw + M_PI, 0, 1, 0);
    GLKMatrix4 pitchMatrix = GLKMatrix4MakeRotation(self.pitch, 1, 0, 0);
    _mvMatrix = GLKMatrix4Multiply(_mvMatrix, pitchMatrix);
    _mvMatrix = GLKMatrix4Multiply(_mvMatrix, yawMatrix);
    
    GLKMatrix4 resultMat = GLKMatrix4Multiply(mvpMatrix, _mvMatrix);
    
    glBindVertexArrayOES(_vertexArray);
    glUseProgram(_program);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _textureBuffer);
    glUniform1i(_uniforms[UNIFORM_TEXTURE_SAMPLER], 0);
    glUniformMatrix4fv(_uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, resultMat.m);
    glDrawElements(GL_TRIANGLES, _triagleCount, GL_UNSIGNED_SHORT, 0);
    
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Frameworks/SphereModel.framework/SphereModel.Bundle/Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Frameworks/SphereModel.framework/SphereModel.Bundle/Shader" ofType:@"fsh"];
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
    glBindAttribLocation(_program, ATTRIB_TEXCOORD, "texture");
    
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
