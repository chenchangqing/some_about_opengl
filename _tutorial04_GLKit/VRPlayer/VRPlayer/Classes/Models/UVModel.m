//
//  UVModel.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVModel.h"

@interface UVModel()

@property(nonatomic,strong) NSMutableArray *submodels;

@end

@implementation UVModel

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _yaw = -90;
        _pitch = 0;
        
        _sx = 1;
        _sy = 1;
        _sz = 1;
        
        _tx = 0;
        _ty = 0;
        _tz = 0;
        
        _rx = 0;
        _ry = 0;
        _rz = 0;
        
        _submodels = [NSMutableArray arrayWithCapacity:0];
        
    }
    
    return self;
}

- (void)addSubModel:(UVModel *)model {
    
    [_submodels addObject:model];
}

- (void)removeSubModel:(UVModel *)model {
    
    [_submodels removeObject:model];
}

@end
