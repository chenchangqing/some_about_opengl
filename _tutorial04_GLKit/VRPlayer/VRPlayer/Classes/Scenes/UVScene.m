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

- (void)updateWithProjectionMatrix: (GLKMatrix4)projectionMatrix andModelViewMatrix:(GLKMatrix4)modelViewMatrix {
    [super updateWithProjectionMatrix:projectionMatrix andModelViewMatrix:modelViewMatrix];
    
    for (UVModel *model in _models) {
        
        [model updateWithProjectionMatrix:projectionMatrix andModelViewMatrix:self.modelViewMatrix];
    }
    
}

- (void)draw {
    [super draw];
    
    for (UVModel *model in _models) {
        
        if ([model isKindOfClass:[UVSquare class]]) {
            
            [(UVSquare *)model draw];
        }
    }
}

- (void)free {
    [super free];
    
    for (UVModel *model in _models) {
        
        [model free];
    }
}

@end
