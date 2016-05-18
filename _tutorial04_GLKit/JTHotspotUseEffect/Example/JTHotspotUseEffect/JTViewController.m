//
//  JTViewController.m
//  JTHotspot
//
//  Created by chenchangqing on 05/17/2016.
//  Copyright (c) 2016 chenchangqing. All rights reserved.
//

#import "JTViewController.h"
#import <JTHotspotUseEffect/JTHotspotView.h>

@interface JTViewController ()

@property (nonatomic, weak) IBOutlet JTHotspotView * hotspotView;

@end

@implementation JTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HotspotItem *item = [[HotspotItem alloc] init];
    
    item.rotation.xAngle = 70;
    
    [_hotspotView addHotspot:item];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
