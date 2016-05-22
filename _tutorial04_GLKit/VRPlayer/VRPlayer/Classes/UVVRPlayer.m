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
#import "UVBorderSphereScene.h"
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
    
    [_scenes addObject:[[UVBorderSphereScene alloc] init]];
    
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
//    glEnable(GL_DEPTH_TEST);
    
    UVScene *topScene = _scenes.lastObject;
    
    for (UVModel *model in topScene.models) {
        
        [model create];
    }
    
}

- (void)dealloc
{
    [EAGLContext setCurrentContext:_glkcontext];
    
    
    UVScene *topScene = _scenes.lastObject;
    
    for (UVModel *model in topScene.models) {
        
        [model free];
    }
    
    if ([EAGLContext currentContext] == _glkcontext) {
        [EAGLContext setCurrentContext:nil];
    }
    
    _glkcontext = nil;
    _displayLink.paused = YES;
    _displayLink = nil;
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    UVScene *topScene = _scenes.lastObject;
    
    for (UVModel *model in topScene.models) {
        
        [model drawInRect:rect];
    }
    
}

#pragma mark - Public

- (void)pushWithScene:(UVScene *)scene {
    
    [_scenes addObject:scene];
}

- (void)popScene {
    
    [_scenes removeLastObject];
}

@end
