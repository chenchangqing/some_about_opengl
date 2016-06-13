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
@property (nonatomic, strong) UVSphere *sphere;

@end

@implementation JTTestScene
@synthesize grid;
@synthesize toolbar;
@synthesize sphere;

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.yaw = 0.0f;
        self.pitch = 0.0f;
        self.sx = 1.0f;
        self.sy = 1.0f;
        self.sz = 1.0f;
        self.tx = 0.0f;
        self.ty = 0.0f;
        self.tz = 0.0f;
        self.rx = 0.0f;
        self.ry = 0.0f;
        self.rz = 0.0f;
    }
    return self;
}

- (void)prepareModels {
    [super prepareModels];
    
    sphere = [[UVSphere alloc] init];
    
    sphere.yaw = 0.0f;
    sphere.pitch = 0.0f;
    sphere.sx = 1.0f;
    sphere.sy = 1.0f;
    sphere.sz = 1.0f;
    sphere.tx = 0.0f;
    sphere.ty = 0.0f;
    sphere.tz = 0.0f;
    sphere.rx = 0.0f;
    sphere.ry = 0.0f;
    sphere.rz = 0.0f;
    
    [super.models addObject:sphere];
    
    grid = [[UVCollection alloc] init];
    grid.delegate = self;
    grid.dataSource = self;
    grid.yaw = 0.0f;
    grid.pitch = 0.0f;
    grid.sx = 1.0f;
    grid.sy = 9.0f/16.0f;
    grid.sz = 1.0f;
    grid.tx = 0.0f;
    grid.ty = 0.0f;
    grid.tz = -1.0f;
    grid.rx = 0.0f;
    grid.ry = 0.0f;
    grid.rz = 0.0f;
    [super.models addObject:grid];
    
    toolbar = [[UVCollection alloc] init];
    toolbar.delegate = self;
    toolbar.dataSource = self;
    toolbar.yaw = 0.0f;
    toolbar.pitch = 0.0f;
    toolbar.sx = 0.8f;
    toolbar.sy = 0.8f/6.0f;
    toolbar.sz = 1.0f;
    toolbar.tx = 0.0f;
    toolbar.ty = 0.0f;
    toolbar.tz = -1.0f;
    toolbar.rx = -85.0f;
    toolbar.ry = 0.0f;
    toolbar.rz = 0.0f;
    [super.models addObject:toolbar];
    
}

#pragma mark - UVCollectionDataSource

- (float)numberOfRowsInCollection:(UVCollection *)collection {
    
    if (collection == grid) {
        
        return 4.0f;
    }
    if (collection == toolbar) {
        
        return 1.0f;
    }
    
    return 0.0f;
}

- (float)numberOfColumnsInCollection:(UVCollection *)collection {
    
    if (collection == grid) {
        
        return 5.0f;
    }
    if (collection == toolbar) {
        
        return 3.0f;
    }
    
    return 0.0f;
}

- (float)numberOfItemsInCollection:(UVCollection *)collection {
    
    if (collection == grid) {
        
        return 150.0f;
    }
    if (collection == toolbar) {
        
        return 100.0f;
    }
    
    return 0.0f;
}

#pragma mark - UVCollectionDelegate

- (void)configureModelViewMatrixForModel:(UVModel *)model {
    
    if (model == toolbar) {
        
        model.mvp = GLKMatrix4Translate(model.mvp, 0.0f, 0.0f, -1.0f);
    }
}

- (void)collection:(UVCollection *)collection configureModel:(UVSquare *)model atIndexPath:(UVIndexPath *)indexPath {
    
}

- (void)collection:(UVCollection *)collection configureModelViewMatrixForModel:(UVSquare *)model atIndexPath:(UVIndexPath *)indexPath {
    
    if (collection == toolbar) {
        
        model.mvp = GLKMatrix4Translate(model.mvp, 0.0f, 0.0f, -1.0f);
    }
}

- (float)horizontalMargin:(UVCollection *)collection {
    
    return 0.05f;
}

- (float)verticalMargin:(UVCollection *)collection {
    
    return 0.05f;
}

- (float)rowSpace:(UVCollection *)collection {
    
    return 0.05f;
}

- (float)columnSpace:(UVCollection *)collection {
    
    return 0.05f;
}


@end
