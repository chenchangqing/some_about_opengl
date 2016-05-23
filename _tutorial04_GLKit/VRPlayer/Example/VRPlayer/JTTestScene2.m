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
    
    collection.sx = 1.6;
    collection.sy = 0.8;
    collection.sz = 1;
    
    collection.tx = 0;
    collection.ty = 0;
    collection.tz = 0;
    
    [super.models addObject:collection];
    
}

@end
