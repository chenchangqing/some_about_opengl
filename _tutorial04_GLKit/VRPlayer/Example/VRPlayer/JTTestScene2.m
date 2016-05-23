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
    
    UVCollection *collection = [[UVCollection alloc] init];
    
    collection.yaw = 0;
    collection.pitch = 0;
    
    collection.rx = 0;
    collection.ry = 0;
    collection.rz = 0;
    
    collection.sx = 0.7f;
    collection.sy = 0.3f;
    collection.sz = 1;
    
    collection.tx = 0;
    collection.ty = 0.4f;
    collection.tz = 0;
    
    [super.models addObject:collection];
    
    UVSquare *square = [[UVSquare alloc] init];
    
    square.yaw = 0;
    square.pitch = 0;
    
    square.rx = 10;
    square.ry = 0;
    square.rz = 0;
    
    square.sx = 0.8;
    square.sy = 0.1;
    square.sz = 1;
    
    square.tx = 0;
    square.ty = -3.0f;
    square.tz = 0;
    
    [super.models addObject:square];
    
}

@end
