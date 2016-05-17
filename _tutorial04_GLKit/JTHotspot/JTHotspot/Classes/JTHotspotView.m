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

@interface JTHotspotView ()<GLKViewDelegate>{
    
    GLuint _vertexBuffer;
    GLuint _colorBuffer;
    GLuint _vertexArray;
}

@property (weak, nonatomic) GLKView *glkView;
@property (strong, nonatomic) CADisplayLink* displayLink;
@property (strong, nonatomic) EAGLContext *glkcontext;
@property (strong, nonatomic) GLKBaseEffect *effect;
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
    [self clearGL];
    
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
    
    _effect = [[GLKBaseEffect alloc] init];
    _hotspots = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setupGL];
}

- (void)setupGL {
    
    // OpenGL相关
    [EAGLContext setCurrentContext:_glkcontext];
    glEnable(GL_CULL_FACE);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_vertex_buffer_data), g_vertex_buffer_data, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_colorBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_color_buffer_data), g_color_buffer_data, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);// 很关键
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);// 很关键
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, 0);
    
    glBindVertexArrayOES(0);
}

#pragma mark - clearGL

- (void)clearGL {
    
    [EAGLContext setCurrentContext:_glkcontext];
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_colorBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(0.0, 0.0, 1.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    // mvp
    float aspect = fabs(self.bounds.size.width / self.bounds.size.height);
    
    GLKMatrix4 mMatrix = GLKMatrix4Identity;
    GLKMatrix4 vMatrix = GLKMatrix4MakeLookAt(0, 0, 5, 0, 0, 0, 0, 1, 0);
    GLKMatrix4 pMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 0.1f, 10.0f);
    GLKMatrix4 mvMatrix = GLKMatrix4Multiply(mMatrix, vMatrix);
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(pMatrix, mvMatrix);
    _effect.transform.projectionMatrix = mvpMatrix;
    
    // 绘制热点
    
    for (HotspotItem *item in _hotspots) {
        
        GLKMatrix4 resultMat = GLKMatrix4Identity;
        
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
        
        self.effect.transform.modelviewMatrix = resultMat;
        [_effect prepareToDraw];
        glDrawArrays(GL_TRIANGLES, 0, 6);
        
    }
    
}

@end
