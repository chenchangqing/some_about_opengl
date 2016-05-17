//
//  HotspotItem.h
//  Pods
//
//  Created by green on 16/5/17.
//
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <UIKit/UIKit.h>
#import "HotspotType.h"
#import "HotspotScale.h"
#import "HotspotRotation.h"
#import "HotspotPosition.h"

@interface HotspotItem : NSObject

@property (nonatomic, assign) HotspotType type;
@property (nonatomic, strong) HotspotPosition *position;
@property (nonatomic, strong) HotspotScale *scale;
@property (nonatomic, strong) HotspotRotation *rotation;

@end
