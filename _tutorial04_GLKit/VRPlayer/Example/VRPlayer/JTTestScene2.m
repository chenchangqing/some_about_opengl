//
//  JTTestScene2.m
//  VRPlayer
//
//  Created by green on 16/5/24.
//  Copyright © 2016年 chenchangqing. All rights reserved.
//

#import "JTTestScene2.h"

@interface JTTestScene2()<UVCollectionDataSource,UVCollectionDelegate>

@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation JTTestScene2
@synthesize models;

- (void)prepareModels {
    [super prepareModels];
    
    self.models = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray *firstRow = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *secondRow = [NSMutableArray arrayWithCapacity:0];
    
    [firstRow addObject:[[UVSquare alloc] init]];
    [firstRow addObject:[[UVSquare alloc] init]];
    [firstRow addObject:[[UVSquare alloc] init]];
    [firstRow addObject:[[UVSquare alloc] init]];
    
    [secondRow addObject:[[UVSquare alloc] init]];
    [secondRow addObject:[[UVSquare alloc] init]];
    [secondRow addObject:[[UVSquare alloc] init]];
    [secondRow addObject:[[UVSquare alloc] init]];
    
    [self.models addObject:firstRow];
    [self.models addObject:secondRow];
    
    UVCollection *collection = [[UVCollection alloc] init];
    
    collection.delegate = self;
    collection.dataSource = self;
    
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
    
}

#pragma mark - UVCollectionDataSource

- (float)numberOfRowsInCollection:(UVCollection *)collection {
    
    return 2.0f;
}

- (float)numberOfColumnsInCollection:(UVCollection *)collection {
    
    return 1.0f;
}

- (UVSquare *)collection:(UVCollection *)collection modelForItemAtIndexPath:(UVIndexPath *)indexPath {
    
    NSArray *row = [models objectAtIndex:indexPath.row];
    UVSquare *model = [row objectAtIndex:indexPath.column];
    
    return model;
}

#pragma mark - UVCollectionDelegate

- (void)collection:(UVCollection *)collection modelViewMatrix:(GLKMatrix4)modelViewMatrix atIndexPath:(UVIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
    }
    
    if (indexPath.row == 1) {
       
    }
}

- (float)horizontalMargin {
    
    return  0.0f;
}

- (float)verticalMargin {
    
    return 0.0f;
}

- (float)rowSpace {
    
    return 0.0f;
}

- (float)columnSpace {
    
    return 0.0f;
}

@end
