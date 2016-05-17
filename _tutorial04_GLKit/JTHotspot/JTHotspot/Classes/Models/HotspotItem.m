//
//  HotspotItem.m
//  Pods
//
//  Created by green on 16/5/17.
//
//

#import "HotspotItem.h"

@implementation HotspotItem

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _type = HotspotTypeSquare;
        
        _position = [[HotspotPosition alloc] init];
        _rotation = [[HotspotRotation alloc] init];
        _scale = [[HotspotScale alloc] init];
    }
    
    return self;
}

@end
