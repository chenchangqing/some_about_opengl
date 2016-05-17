//
//  HotspotItem.h
//  Pods
//
//  Created by green on 16/5/17.
//
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "HotspotType.h"
#import "HotspotRotation.h"

@interface HotspotItem : NSObject

@property (nonatomic, assign) HotspotType type;
@property (nonatomic, assign) GLKVector4 centerVector;
@property (nonatomic, assign) struct HotspotRotation rotation;

@end
