//
//  JTViewController.m
//  VRPlayer
//
//  Created by chenchangqing on 05/21/2016.
//  Copyright (c) 2016 chenchangqing. All rights reserved.
//

#import "JTViewController.h"
#import <VRPlayer/VRPlayer.h>
#import "JTTestScene.h"

@interface JTViewController ()

@property (nonatomic, weak) IBOutlet UVVRPlayer *player;

@end

@implementation JTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    JTTestScene *scene = [[JTTestScene alloc] init];
    [_player pushWithScene:scene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
