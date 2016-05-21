//
//  UVScence.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVScene.h"

@implementation UVScene

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _model = [[UVModel alloc] init];
    }
    
    return self;
}

@end
