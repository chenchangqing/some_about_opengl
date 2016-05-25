//
//  JTTestScene.m
//  VRPlayer
//
//  Created by green on 16/5/23.
//  Copyright © 2016年 chenchangqing. All rights reserved.
//

#import "JTTestScene.h"

@interface JTTestScene()<UVCollectionDataSource,UVCollectionDelegate>

@property (nonatomic, strong) UVCollection *collection;
@property (nonatomic, strong) UVSquare *square2;

@end

@implementation JTTestScene
@synthesize collection;
@synthesize square2;

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)prepareModels {
    [super prepareModels];
    
//    collection = [[UVCollection alloc] init];
//    collection.delegate = self;
//    collection.dataSource = self;
//    collection.yaw = 0.0f;
//    collection.pitch = 0.0f;
//    collection.sx = 1.0f;
//    collection.sy = 1.0f/3.0f*2.0f;
//    collection.sz = 1.0f;
//    collection.tx = 0.0f;
//    collection.ty = 0.5f;
//    collection.tz = 0.0f;
//    collection.rx = 0.0f;
//    collection.ry = 0.0f;
//    collection.rz = 0.0f;
//    [super.models addObject:collection];
    
    square2 = [[UVSquare alloc] init];
    square2.delegate = self;
    square2.yaw = 0.0f;
    square2.pitch = 0.0f;
    square2.sx = 1.0f;
    square2.sy = 1.0f;
    square2.sz = 1.0f;
    square2.tx = 0.0f;
    square2.ty = 0.0f;
    square2.tz = 0.0f;
    square2.rx = 0.0f;
    square2.ry = 0.0f;
    square2.rz = 0.0f;
    [super.models addObject:square2];
    
}

#pragma mark - UVCollectionDataSource

- (float)numberOfRowsInCollection:(UVCollection *)collection {
    
    return 3.0f;
}

- (float)numberOfColumnsInCollection:(UVCollection *)collection {
    
    return 4.0f;
}

- (float)numberOfItemsInCollection:(UVCollection *)collection {
    
    return 12.0f;
}

#pragma mark - UVCollectionDelegate

- (void)configureModelViewMatrixForModel:(UVModel *)model {
    
    if (model == square2) {
        
        model.modelViewMatrix = GLKMatrix4Translate(model.modelViewMatrix, 0.0f, 0.0f, 0.0f);
    }
}

- (void)collection:(UVCollection *)collection configureModel:(UVSquare *)model atIndexPath:(UVIndexPath *)indexPath {
    
}

- (void)collection:(UVCollection *)collection configureModelViewMatrixForModel:(UVSquare *)model atIndexPath:(UVIndexPath *)indexPath {
    
}

- (float)horizontalMargin:(UVCollection *)collection {
    
    return 0.2f;
}

- (float)verticalMargin:(UVCollection *)collection {
    
    return 0.2f;
}

- (float)rowSpace:(UVCollection *)collection {
    
    return 0.3f;
}

- (float)columnSpace:(UVCollection *)collection {
    
    return 0.3f;
}


@end
