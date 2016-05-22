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

@interface UVVRPlayer()<GLKViewDelegate>

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
    
    _scenes = [NSMutableArray arrayWithCapacity:0];
    
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
    
    [EAGLContext setCurrentContext:_glkcontext];
    
    glEnable(GL_CULL_FACE);
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

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // 透视
    float aspect = fabs(self.bounds.size.width / self.bounds.size.height);
    GLKMatrix4 mvMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -0.5f);
    GLKMatrix4 pMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(100), aspect, 0.1f, 2.4f);
    
    // 正交
    const GLfloat zNear = 0.01, zFar = 1000.0, fieldOfView = 45.0;
    GLfloat size;
    size = zNear * tanf(GLKMathDegreesToRadians(fieldOfView) / 2.0);
    rect.size.width *= [UIScreen mainScreen].scale;
    rect.size.height *= [UIScreen mainScreen].scale;
    mvMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -5.0f);
    pMatrix = GLKMatrix4MakeFrustum(-size, size, -size / (rect.size.width / rect.size.height), size /
                                               (rect.size.width / rect.size.height), zNear, zFar);
    
    // mvp
    GLKMatrix4 mvp = GLKMatrix4Multiply(pMatrix, mvMatrix);
    
    mvp = GLKMatrix4Identity;
    
    [_scenes.lastObject drawWithMVP:mvp andConfig:nil];
}

#pragma mark - Public

- (void)pushWithScene:(UVScene *)scene {
    
    [scene setup];
    [_scenes addObject:scene];
}

- (void)popScene {
    
    [_scenes removeLastObject];
}

@end
