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

@implementation UVVRPlayer(Gesture)

-(void)setPreviousPoint:(NSString *)previousPoint {
    
    objc_setAssociatedObject(self, &kPreviousPoint, previousPoint, OBJC_ASSOCIATION_COPY);
}

-(NSString *)previousPoint {
    
    return objc_getAssociatedObject(self, &kPreviousPoint);
}

- (void)setupGesture {
    
    // 增加滑动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panGesture];
}

#pragma mark - 手势处理

- (void)panGesture:(UIPanGestureRecognizer *) panGesture {
    
    CGPoint currentPoint = [panGesture locationInView:panGesture.view];
    CGPoint velocity = [panGesture velocityInView:panGesture.view];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateEnded: {
            
            break;
        }
        case UIGestureRecognizerStateBegan: {
            
            self.previousPoint = NSStringFromCGPoint(currentPoint);
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            // 改变 yaw、pitch
            [self moveToPointX:currentPoint.x - CGPointFromString(self.previousPoint).x andPointY:currentPoint.y - CGPointFromString(self.previousPoint).y];
            
            self.previousPoint = NSStringFromCGPoint(currentPoint);
            break;
        }
        default:
            break;
    }
}

@end
