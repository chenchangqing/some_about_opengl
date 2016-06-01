//
//  UVVRPlayer+Gesture.m
//  Pods
//
//  Created by green on 16/6/1.
//
//

#import "UVVRPlayer+Gesture.h"
#import "UVVRPlayer.h"
#import <objc/runtime.h>

static char kPreviousPoint;
static char kVelocityValue;

@implementation UVVRPlayer(Gesture)

#pragma mark - get/set

-(void)setVelocityValue:(NSString *)velocityValue {
    
    objc_setAssociatedObject(self, &kVelocityValue, velocityValue, OBJC_ASSOCIATION_COPY);
}

-(NSString *)velocityValue {
    
    return objc_getAssociatedObject(self, &kVelocityValue);
}

#pragma mark - setup

- (void)setupGesture {
    
    // 增加滑动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panGesture];
}

#pragma mark - 手势处理

- (void)panGesture:(UIPanGestureRecognizer *) panGesture {
    
    CGPoint currentPoint = [panGesture locationInView:panGesture.view];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateEnded: {
            
            break;
        }
        case UIGestureRecognizerStateBegan: {
            
            self.velocityValue = NSStringFromCGPoint(CGPointZero);
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            // 改变 yaw、pitch
            self.velocityValue = NSStringFromCGPoint([panGesture velocityInView:panGesture.view]);
            break;
        }
        default:
            break;
    }
}

@end
