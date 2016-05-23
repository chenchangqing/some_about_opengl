//
//  UVScence.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVScene.h"
#import "UVSquare.h"
#import "UVSquareConfig.h"

@interface UVScene ()

@property (nonatomic, strong) UVSquare * square;

@end

@implementation UVScene

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _configs = [NSMutableArray arrayWithCapacity:0];
        _square = [[UVSquare alloc] init];
        [self prepareConfigs];
    }
    
    return self;
}

- (void)prepareConfigs {
    
}

- (void)setup {
    
    [_square setup];
}

- (void)drawWithMVP:(GLKMatrix4)mvp andConfig:(UVModelConfig *)config {
    
    for (UVModelConfig *config in _configs) {
        
        if ([config isKindOfClass:[UVSquareConfig class]]) {
            
            [_square drawWithMVP:mvp andConfig:config];
        }
    }
}

- (void)free {
    
    [_square free];
}

@end