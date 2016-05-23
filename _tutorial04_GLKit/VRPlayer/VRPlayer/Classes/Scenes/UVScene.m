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
    
    for (UVModel *model in _models) {
        
        [model setup];
    }
}

- (void)drawWithPMatrix: (GLKMatrix4) projectionMatrix {
    
    for (UVModel *model in _models) {
        
        if ([model isKindOfClass:[UVSquare class]]) {
            
            [(UVSquare *)model drawWithPMatrix:projectionMatrix];
        }
    }
}

- (void)free {
    
    for (UVModel *model in _models) {
        
        [model free];
    }
}

@end
