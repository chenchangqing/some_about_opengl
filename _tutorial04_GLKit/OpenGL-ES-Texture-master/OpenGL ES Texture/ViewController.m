//
//  ViewController.m
//  OpenGL ES Texture
//
//  Created by lidehua on 15/7/23.
//  Copyright (c) 2015年 李德华. All rights reserved.
//

#import "ViewController.h"
#import "ESView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ESView * view = [[ESView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
