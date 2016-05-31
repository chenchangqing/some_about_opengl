//
//  JTTestScene.m
//  VRPlayer
//
//  Created by green on 16/5/23.
//  Copyright © 2016年 chenchangqing. All rights reserved.
//

#import "JTTestScene.h"

@interface JTTestScene()<UVCollectionDataSource,UVCollectionDelegate>

@property (nonatomic, strong) UVCollection *grid;
@property (nonatomic, strong) UVCollection *toolbar;

@end

@implementation JTTestScene
@synthesize grid;
@synthesize toolbar;

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.pitch = 0.0f;
        self.yaw = -25.0f;
    }
    return self;
}

- (void)prepareModels {
    [super prepareModels];
    
    grid = [[UVCollection alloc] init];
    grid.delegate = self;
    grid.dataSource = self;
    grid.yaw = 0.0f;
    grid.pitch = 0.0f;
    grid.sx = 1.0f;
    grid.sy = 9.0f/16.0f;
    grid.sz = 1.0f;
    grid.tx = 0.0f;
    grid.ty = 0.3f;
    grid.tz = 0.0f;
    grid.rx = 0.0f;
    grid.ry = 0.0f;
    grid.rz = 0.0f;
    [super.models addObject:grid];
    
    toolbar = [[UVCollection alloc] init];
    toolbar.delegate = self;
    toolbar.dataSource = self;
    toolbar.delegate = self;
    toolbar.yaw = 0.0f;
    toolbar.pitch = -30.0f;
    toolbar.sx = 1.2f;
    toolbar.sy = 1.0f/6.0f;
    toolbar.sz = 1.0f;
    toolbar.tx = 0.0f;
    toolbar.ty = 0.0f;
    toolbar.tz = 0.0f;
    toolbar.rx = 0.0f;
    toolbar.ry = 0.0f;
    toolbar.rz = 0.0f;
    [super.models addObject:toolbar];
    
}

#pragma mark - UVCollectionDataSource

- (float)numberOfRowsInCollection:(UVCollection *)collection {
    
    if (collection == grid) {
        
        return 3.0f;
    }
    if (collection == toolbar) {
        
        return 1.0f;
    }
    
    return 0.0f;
}

- (float)numberOfColumnsInCollection:(UVCollection *)collection {
    
    if (collection == grid) {
        
        return 4.0f;
    }
    if (collection == toolbar) {
        
        return 3.0f;
    }
    
    return 0.0f;
}

- (float)numberOfItemsInCollection:(UVCollection *)collection {
    
    if (collection == grid) {
        
        return 12.0f;
    }
    if (collection == toolbar) {
        
        return 3.0f;
    }
    
    return 0.0f;
}

#pragma mark - UVCollectionDelegate

- (void)configureModelViewMatrixForModel:(UVModel *)model {
    
    if (model == toolbar) {
        
        model.modelViewMatrix = GLKMatrix4Translate(model.modelViewMatrix, 0.0f, 0.0f, -1.0f);
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
