//
//  UVVRPlayer.h
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import <Foundation/Foundation.h>
#import "UVScene.h"

/**
 *  VR模式视图
 */
@interface UVVRPlayer : UIView

@property(nonatomic,strong) NSMutableArray *scenes;

/**
 *  准备场景
 */
- (void)prepareScenes;

@end
