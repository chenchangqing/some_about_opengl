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
#import "UVModel.h"

#define isAnimation 1

@interface UVVRPlayer()<GLKViewDelegate> {
    
    int _degree;
    
}

@property (weak, nonatomic) GLKView *glkView;
@property (strong, nonatomic) CADisplayLink* displayLink;
@property (strong, nonatomic) EAGLContext *glkcontext;
@property (nonatomic,assign) CGPoint previousPoint;
@property (nonatomic,assign) float yaw;
@property (nonatomic,assign) float pitch;

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
    
    // Init Props
    _yaw = 0.0f;
    _pitch = 0.0f;
    _scenes = [NSMutableArray arrayWithCapacity:0];
    _glkcontext =[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!_glkcontext) {
        NSLog(@"Failed to create ES context");
    }
    
    // Add GLKView
    GLKView *tglkView = [[GLKView alloc] initWithFrame:CGRectZero context:_glkcontext];
    [self addSubview:tglkView];
    _glkView = tglkView;
    _glkView.delegate = self;
    _glkView.enableSetNeedsDisplay = NO;
    
    // 增加滑动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panGesture];
    
    // Add GLKView Constraints
    _glkView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDictionary = @{@"tglkView":_glkView};
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tglkView]-0-|" options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tglkView]-0-|" options:0 metrics:nil views:viewsDictionary]];
    
    // 屏幕连接器
    _displayLink = [CADisplayLink displayLinkWithTarget:_glkView selector:@selector(display)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    // 准备场景s
    [self prepareScenes];
}

- (void)prepareScenes {
    
    [EAGLContext setCurrentContext:_glkcontext];
    glEnable(GL_DEPTH_TEST);
    
}

- (void)dealloc
{
    [EAGLContext setCurrentContext:_glkcontext];
    
    for (UVScene *scene in _scenes) {
        
        [scene free];
    }
    
    if ([EAGLContext currentContext] == _glkcontext) {
        [EAGLContext setCurrentContext:nil];
    }
    
    _glkcontext = nil;
    _displayLink.paused = YES;
    _displayLink = nil;
}

#pragma mark - 手势处理

- (void) panGesture:(UIPanGestureRecognizer *) panGesture {
    
    CGPoint currentPoint = [panGesture locationInView:panGesture.view];
    CGPoint velocity = [panGesture velocityInView:panGesture.view];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateEnded: {
            
            break;
        }
        case UIGestureRecognizerStateBegan: {
            
            _previousPoint = currentPoint;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            // 改变 yaw、pitch
            
            _previousPoint = currentPoint;
            break;
        }
        default:
            break;
    }
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    GLKMatrix4 mv = GLKMatrix4Identity;
    
    //转到空间yaw、pitch处
    GLKMatrix4 mtr = GLKMatrix4MakeTranslation(0, 0, -1);
    mv = GLKMatrix4Multiply(mtr, mv);
    
    GLKMatrix4 m1 = GLKMatrix4Identity;
    m1 = GLKMatrix4Rotate(m1, GLKMathDegreesToRadians(self.yaw + _degree), 0, 1, 0);
    m1 = GLKMatrix4Rotate(m1, GLKMathDegreesToRadians(self.pitch), 1, 0, 0);
    
    mv = GLKMatrix4Multiply(m1, mv);
    
    mtr = GLKMatrix4MakeTranslation(0, 0, 1);
    mv = GLKMatrix4Multiply(mtr, mv);
    
    [_scenes.lastObject updateWithMVP:GLKMatrix4Multiply([self projectionMatrix], mv)];
    [_scenes.lastObject draw];
    
    if (isAnimation) {
        
        _degree++;
        
        if (_degree >= 360) {
            
            _degree = _degree % 360;
        }
    }
}

/**
 *  透视投影
 */
- (GLKMatrix4)projectionMatrix {
    
    float aspect = fabs(CGRectGetWidth([UIScreen mainScreen].bounds) / CGRectGetHeight([UIScreen mainScreen].bounds));
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(78.0f), aspect, 0.01f, 1000.0f);
    
    return projectionMatrix;
//    return GLKMatrix4Identity;
}

/**
 *  正交投影
 */
- (GLKMatrix4)frustumMatrixWithRect: (CGRect)rect {
    
    const GLfloat zNear = 0.01, zFar = 1000.0, fieldOfView = 45.0;
    GLfloat size;
    size = zNear * tanf(GLKMathDegreesToRadians(fieldOfView) / 2.0);
    rect.size.width *= [UIScreen mainScreen].scale;
    rect.size.height *= [UIScreen mainScreen].scale;
    GLKMatrix4 frustumMatrix = GLKMatrix4MakeFrustum(-size, size, -size / (rect.size.width / rect.size.height), size / (rect.size.width / rect.size.height), zNear, zFar);
    return frustumMatrix;
}

@end
