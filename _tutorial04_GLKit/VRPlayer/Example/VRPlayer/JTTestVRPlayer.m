//
//  JTTestVRPlayer.m
//  VRPlayer
//
//  Created by green on 16/5/23.
//  Copyright © 2016年 chenchangqing. All rights reserved.
//

#import "JTTestVRPlayer.h"
#import "JTTestScene.h"
#import "JTTestScene2.h"

@implementation JTTestVRPlayer

- (void)prepareScenes {
    [super prepareScenes];
    
    JTTestScene *scene = [[JTTestScene alloc] init];
    [self.scenes addObject:scene];
    
//    JTTestScene2 *scene2 = [[JTTestScene2 alloc] init];
//    [self.scenes addObject:scene2];
}

@end
