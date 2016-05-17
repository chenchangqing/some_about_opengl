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
        _centerVector = GLKVector4Make(0, 0, 0, 1);
        
        struct HotspotRotation rotation;
        rotation.xAngle = 0;
        rotation.yAngle = 0;
        rotation.zAngle = 0;
        
        _rotation = rotation;
    }
    
    return self;
}

@end
