//
//  UVScence.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVScene.h"
#import "UVSquare.h"

@interface UVScene ()

@end

@implementation UVScene

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _models = [NSMutableArray arrayWithCapacity:0];
        [self prepareModels];
        [self setup];
    }
    
    return self;
}

- (void)prepareModels {
    
}

- (void)setup {
    [super setup];
    
    for (UVModel *model in _models) {
        
        [model setup];
    }
}

- (void)setupVertexCount:(int *)count vertexData:(GLfloat **)data {
    
}

- (void)setupColorCount:(int *)count colorData:(GLfloat **)data {
    
}

- (void)setupElementCount:(int *)count elementData:(GLfloat **)data {
    
}

- (void)updateWithMVP: (GLKMatrix4)mvp {
    [super updateWithMVP:mvp];
    
    for (UVModel *model in _models) {
        
        [model updateWithMVP:self.mvp];
    }
    
}

- (void)draw {
    [super draw];
    
    for (UVModel *model in _models) {
        
        [model draw];
    }
}

- (void)free {
    [super free];
    
    for (UVModel *model in _models) {
        
        [model free];
    }
}

@end
