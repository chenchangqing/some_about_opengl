//
//  JTViewController.m
//  JTHotspot
//
//  Created by chenchangqing on 05/17/2016.
//  Copyright (c) 2016 chenchangqing. All rights reserved.
//

#import "JTViewController.h"
#import <JTHotspot/JTHotspotView.h>

@interface JTViewController ()

@property (nonatomic, weak) IBOutlet JTHotspotView * hotspotView;

@end

@implementation JTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    HotspotItem *item = [[HotspotItem alloc] init];
    [_hotspotView addHotspot:item];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
