//
//  UVModelConfig.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVModelConfig.h"

@implementation UVModelConfig

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _yaw = 0;
        _pitch = 0;
        
        _sx = 1;
        _sy = 1;
        _sz = 1;
        
        _tx = 0.0;
        _ty = 0.0;
        _tz = 0.0;
        
        _rx = 0;
        _ry = 0;
        _rz = 0;
        
    }
    
    return self;
}

@end
