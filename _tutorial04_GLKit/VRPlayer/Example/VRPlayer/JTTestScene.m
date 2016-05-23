//
//  JTTestScene.m
//  VRPlayer
//
//  Created by green on 16/5/23.
//  Copyright © 2016年 chenchangqing. All rights reserved.
//

#import "JTTestScene.h"

@implementation JTTestScene

- (void)prepareConfigs {
    
    UVSquareConfig *square = [[UVSquareConfig alloc] init];
    
//    square.rx = 70;
    
    square.sx = 0.5;
    square.sy = 0.5;
    
    square.tx = -3;
    
    [super.configs addObject:square];
    
//    UVSquareConfig *square2 = [[UVSquareConfig alloc] init];
//    
//    square2.rx = 70;
//    
//    square2.tx = 0.1;
//    square2.ty = 0.1;
//    
//    square2.sx = 0.5;
//    square2.sy = 0.5;
//    
//    [super.configs addObject:square2];
}

@end
