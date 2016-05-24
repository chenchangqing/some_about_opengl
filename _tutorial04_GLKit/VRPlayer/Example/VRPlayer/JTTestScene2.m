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
    
    collection.rx = 0.0f;
    collection.ry = 0.0f;
    collection.rz = 0.0f;
    
    collection.sx = 1.0f;
    collection.sy = 1.0f;
    collection.sz = 1.0f;
    
    collection.tx = 0.0f;
    collection.ty = 0.0f;
    collection.tz = 0.0f;
    
    [super.models addObject:collection];
    
//    UVSquare *square = [[UVSquare alloc] init];
//    
//    square.yaw = 0;
//    square.pitch = 0;
//    
//    square.rx = 0;
//    square.ry = 0;
//    square.rz = 0;
//    
//    square.sx = 1;
//    square.sy = 1;
//    square.sz = 1;
//    
//    square.tx = 0;
//    square.ty = 0.0f;
//    square.tz = 0;
//    
//    [super.models addObject:square];
    
}

@end
