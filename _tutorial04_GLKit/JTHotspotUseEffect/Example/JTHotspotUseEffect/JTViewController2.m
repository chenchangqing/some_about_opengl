//
//  JTViewController2.m
//  JTHotspot
//
//  Created by green on 16/5/17.
//  Copyright © 2016年 chenchangqing. All rights reserved.
//

#import "JTViewController2.h"
#import <JTHotspotUseEffect/JTHotspotView.h>

@interface JTViewController2 ()

@property (nonatomic, weak) IBOutlet JTHotspotView * hotspotView;

@end

@implementation JTViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HotspotItem *item = [[HotspotItem alloc] init];
    
    item.rotation.xAngle = 70;
    item.rotation.zAngle = 70;
    
    [_hotspotView addHotspot:item];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
