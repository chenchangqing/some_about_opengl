//
//  UVVRPlayer.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVVRPlayer.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>
#import "UVShellLoader.h"

// Uniform index.
enum
{
    UNIFORM_BORDER_SPHERE_MODELVIEWPROJECTION_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_BORDER_SPHERE_VERTEX,
    NUM_ATTRIBUTES
};

@interface UVVRPlayer()<GLKViewDelegate> {
    
    int _segW;
    
    GLuint _borderSphereProgram;
    GLuint _borderSpherevertexArray;
    GLuint _borderSphereVertexBuffer;
}

@property (weak, nonatomic) GLKView *glkView;
@property (strong, nonatomic) CADisplayLink* displayLink;
@property (strong, nonatomic) EAGLContext *glkcontext;

@property(nonatomic,strong) NSMutableArray *scenes;

@end

@implementation UVVRPlayer

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

- (void)setup {
    
    _segW = 48;
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
    
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    
    _borderSphereProgram = [UVShellLoader loadSphereShadersWithVertexShaderString:@"BorderSphere" fragmentShaderString:@"BorderSphere" andAttribLocations:
     @[@{@"index":[NSNumber numberWithUnsignedInt:ATTRIB_BORDER_SPHERE_VERTEX],@"name":@"position"}]];
    uniforms[UNIFORM_BORDER_SPHERE_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_borderSphereProgram, "modelViewProjectionMatrix");
    
    [self createBorderSphere];
    
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

- (void)tearDownGL {
    
    [EAGLContext setCurrentContext:_glkcontext];
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    
    glDeleteBuffers(1, &_borderSphereVertexBuffer);
    glDeleteVertexArraysOES(1, &_borderSpherevertexArray);
    
    if (_borderSphereProgram) {
        glDeleteProgram(_borderSphereProgram);
        _borderSphereProgram = 0;
    }
}

#pragma mark - Model

/**
 *  球网格
 */
-(void)createBorderSphere {
    
    int vertexSize = 3;
    
    int segW1 = _segW + 1;
    int pointCount = (segW1 + 6) * vertexSize;
    
    float *vertices = (float*) malloc(sizeof(float) * pointCount);
    int kk = 0;
    
    for (int i = 0; i < segW1; i++) {
        double ui = 2.0 * i / _segW;
        double deltP = -ui * M_PI;
        float zz = (float) (cos(deltP) * 1);
        float xx = (float) (sin(deltP) * 1);
        float yy = (float) 0;
        vertices[kk++] = xx;
        vertices[kk++] = yy;
        vertices[kk++] = zz;
        printf("%f,",xx);
        printf("%f,",yy);
        printf("%f\n",zz);
    }
    
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    
    vertices[kk++] = 1;
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    
    vertices[kk++] = 0;
    vertices[kk++] = 1;
    vertices[kk++] = 0;
    
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    vertices[kk++] = 1;
    
    glGenVertexArraysOES(1, &_borderSpherevertexArray);
    glBindVertexArrayOES(_borderSpherevertexArray);
    
    glGenBuffers(1, &_borderSphereVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _borderSphereVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, pointCount * sizeof(GLfloat), vertices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(ATTRIB_BORDER_SPHERE_VERTEX);
    glVertexAttribPointer(ATTRIB_BORDER_SPHERE_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 3, NULL);
    
    glBindVertexArrayOES(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    //释放
    free(vertices);
}

#pragma mark - GLKViewDelegate

- (void)update {
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_borderSpherevertexArray);
    glUseProgram(_borderSphereProgram);
    
    // mvp
    float aspect = fabs(self.bounds.size.width / self.bounds.size.height);
    
    // 正交
    const GLfloat zNear = 0.01, zFar = 1000.0, fieldOfView = 45.0;
    GLfloat size;
    size = zNear * tanf(GLKMathDegreesToRadians(fieldOfView) / 2.0);
    rect.size.width *= [UIScreen mainScreen].scale;
    rect.size.height *= [UIScreen mainScreen].scale;
    GLKMatrix4 mvMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -5.0f);
    GLKMatrix4 pMatrix = GLKMatrix4MakeFrustum(-size, size, -size / (rect.size.width / rect.size.height), size /
                                               (rect.size.width / rect.size.height), zNear, zFar);
    
//    mvMatrix = GLKMatrix4Identity;
//    pMatrix = GLKMatrix4Identity;
    
    glUniformMatrix4fv(uniforms[UNIFORM_BORDER_SPHERE_MODELVIEWPROJECTION_MATRIX], 1, 0, GLKMatrix4Multiply(pMatrix, mvMatrix).m);
    glDrawArrays(GL_LINE_LOOP, 0, _segW+1);
    glDrawArrays(GL_LINE_LOOP, _segW+1, 6);
    
    mvMatrix = GLKMatrix4Rotate(mvMatrix, GLKMathDegreesToRadians(90), 0, 0, 1);
    glUniformMatrix4fv(uniforms[UNIFORM_BORDER_SPHERE_MODELVIEWPROJECTION_MATRIX], 1, 0, GLKMatrix4Multiply(pMatrix, mvMatrix).m);
    glDrawArrays(GL_LINE_LOOP, 0, _segW+1);
    
    mvMatrix = GLKMatrix4Rotate(mvMatrix, GLKMathDegreesToRadians(45), 1, 0, 0);
    glUniformMatrix4fv(uniforms[UNIFORM_BORDER_SPHERE_MODELVIEWPROJECTION_MATRIX], 1, 0, GLKMatrix4Multiply(pMatrix, mvMatrix).m);
    glDrawArrays(GL_LINE_LOOP, 0, _segW+1);
    
    mvMatrix = GLKMatrix4Rotate(mvMatrix, GLKMathDegreesToRadians(45), 1, 0, 0);
    glUniformMatrix4fv(uniforms[UNIFORM_BORDER_SPHERE_MODELVIEWPROJECTION_MATRIX], 1, 0, GLKMatrix4Multiply(pMatrix, mvMatrix).m);
    glDrawArrays(GL_LINE_LOOP, 0, _segW+1);
    
    mvMatrix = GLKMatrix4Rotate(mvMatrix, GLKMathDegreesToRadians(45), 1, 0, 0);
    glUniformMatrix4fv(uniforms[UNIFORM_BORDER_SPHERE_MODELVIEWPROJECTION_MATRIX], 1, 0, GLKMatrix4Multiply(pMatrix, mvMatrix).m);
    glDrawArrays(GL_LINE_LOOP, 0, _segW+1);
    
}

#pragma mark - Public

- (void)pushWithScene:(UVScene *)scene {
    
    [_scenes addObject:scene];
}

- (void)popScene {
    
    [_scenes removeLastObject];
}

@end
