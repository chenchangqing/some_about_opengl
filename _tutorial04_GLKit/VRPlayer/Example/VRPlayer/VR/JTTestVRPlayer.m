//
//  JTTestVRPlayer.m
//  VRPlayer
//
//  Created by green on 16/5/23.
//  Copyright © 2016年 chenchangqing. All rights reserved.
//

#import "JTTestVRPlayer.h"
#import "JTTestScene.h"

@implementation JTTestVRPlayer

- (void)prepareScenes {
    [super prepareScenes];
    
    JTTestScene *scene = [[JTTestScene alloc] init];
    [self.scenes addObject:scene];
}

- (GLKMatrix4)projectionMatrix {
    
    GLKMatrix4 pMatrix = [super projectionMatrix];
    
    return pMatrix;
}

@end
