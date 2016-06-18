//
//  JTPlayerViewController.m
//  VRPlayer
//
//  Created by green on 16/6/18.
//  Copyright © 2016年 chenchangqing. All rights reserved.
//

#import "JTPlayerViewController.h"
#import <VRPlayer/VRPlayer.h>
#define MAIZI_URL @"http://ocsource.maiziedu.com/U3djcsxbc-01.mp4"

@interface JTPlayerViewController ()
@property (strong, nonatomic) UVPlayerController *controller;
@end

@implementation JTPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *streamingURL = [NSURL URLWithString:MAIZI_URL];
    NSURL *localURL = [[NSBundle mainBundle] URLForResource:@"hubblecast" withExtension:@"m4v"];
    
    self.controller = [[UVPlayerController alloc] initWithURL:localURL];
    UIView *playerView = self.controller.view;
    playerView.frame = self.view.frame;
    [self.view addSubview:playerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
