//
//  ViewController.m
//  HelloGLKitPractice
//
//  Created by green on 16/5/8.
//  Copyright © 2016年 xyz.chenchangqing. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>

@interface ViewController ()<GLKViewDelegate>

@property (weak, nonatomic) IBOutlet GLKView *glkView;

@end

@implementation ViewController {
    
    float _curRed;
    BOOL _increasing;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Set up

- (void)setup {
    
    _increasing = YES;
    _curRed = 0.0;
    
    EAGLContext * context =[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _glkView.context = context;
    _glkView.delegate = self;
    _glkView.enableSetNeedsDisplay = NO;
    
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:_glkView selector:@selector(display)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    if (_increasing) {
        _curRed += 0.01;
    } else {
        _curRed -= 0.01;
    }
    if (_curRed >= 1.0) {
        _curRed = 1.0;
        _increasing = NO;
    }
    if (_curRed <= 0.0) {
        _curRed = 0.0;
        _increasing = YES;
    }
    
    glClearColor(_curRed, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
}

@end
