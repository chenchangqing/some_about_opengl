//
//  JTTestScene2.m
//  VRPlayer
//
//  Created by green on 16/5/24.
//  Copyright © 2016年 chenchangqing. All rights reserved.
//

#import "JTTestScene2.h"

@implementation JTTestScene2

- (void)prepareModels {
    [super prepareModels];
    
    UVSquare *square = [[UVSquare alloc] init];
    
    square.yaw = 0;
    square.pitch = 80;
    
    square.rx = 0.5;
    square.ry = 0.5;
    square.rz = 0;
    
    square.sx = 1;
    square.sy = 1;
    square.sz = 1;
    
    square.tx = 0;
    square.ty = 0;
    square.tz = 0;
    
    [super.models addObject:square];
    
}

@end
