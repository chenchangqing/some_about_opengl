//
//  UVVRPlayer.h
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import <Foundation/Foundation.h>
#import "UVScene.h"

@interface UVVRPlayer : UIView

- (void)pushWithScene:(UVScene *)scene;
- (void)popScene;

@end
