//
//  UVVRPlayer.h
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import <Foundation/Foundation.h>
#import "UVScene.h"

@class UVVRPlayer;

@protocol UVVRPlayerDataSource<NSObject>

@required

- (NSInteger)numberOfScenesInVRPlayer:(UVVRPlayer *)vrplayer;

- (NSInteger)vrplayer:(UVVRPlayer *)vrplayer numberOfModelsInScene:(NSInteger)sceneIndex;

- (UVScene *)vrplayer:(UVVRPlayer *)vrplayer sceneAtIndex:(NSInteger)sceneIndex;

- (UVModel *)vrplayer:(UVVRPlayer *)vrplayer modelForSceneAtIndex:(NSIndexPath *)indexPath;

@end

/**
 *  VR模式视图
 */
@interface UVVRPlayer : UIView

@property (nonatomic, weak) id <UVVRPlayerDataSource> dataSource;

- (void)reloadData;

@end
