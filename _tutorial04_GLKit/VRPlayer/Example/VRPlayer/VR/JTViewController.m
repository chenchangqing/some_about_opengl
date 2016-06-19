//
//  JTViewController.m
//  VRPlayer
//
//  Created by chenchangqing on 05/21/2016.
//  Copyright (c) 2016 chenchangqing. All rights reserved.
//

#import "JTViewController.h"
#import <VRPlayer/VRPlayer.h>

@interface JTViewController()<UVVRPlayerDataSource>

@property (nonatomic, weak) IBOutlet UVVRPlayer *player;

@property (nonatomic, strong) UVScene *curruntScene;

@property (nonatomic, strong) UVScene *scene1;
@property (nonatomic, strong) UVScene *scene2;

@end

@implementation JTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RandColor];
    
    /**
     场景一
     */
    _scene1 = [[UVScene alloc] init];
    UVSphere *sphere = [[UVSphere alloc] init];
    [_scene1.models addObject:sphere];
    
    /**
     场景二
     */
    _scene2 = [[UVScene alloc] init];
    
    UVSquare *grid = [[UVCollection alloc] init];
    grid.yaw = 0.0f;
    grid.pitch = 0.0f;
    grid.sx = 1.0f;
    grid.sy = 9.0f/16.0f;
    grid.sz = 1.0f;
    grid.tx = 0.0f;
    grid.ty = 0.0f;
    grid.tz = -1.0f;
    grid.rx = 0.0f;
    grid.ry = 0.0f;
    grid.rz = 0.0f;
    [_scene2.models addObject:grid];
    
    UVSquare *toolbar = [[UVCollection alloc] init];
    toolbar.yaw = 0.0f;
    toolbar.pitch = 0.0f;
    toolbar.sx = 0.8f;
    toolbar.sy = 0.8f/6.0f;
    toolbar.sz = 1.0f;
    toolbar.tx = 0.0f;
    toolbar.ty = 0.0f;
    toolbar.tz = -1.0f;
    toolbar.rx = -85.0f;
    toolbar.ry = 0.0f;
    toolbar.rz = 0.0f;
    [_scene2.models addObject:toolbar];
    
    /**
     *  当前场景
     */
    _curruntScene = _scene1;
    
    [self.player setDataSource:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _curruntScene = _scene2;
        [self.player reloadData];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UVVRPlayerDataSource

- (NSInteger)numberOfScenesInVRPlayer:(UVVRPlayer *)vrplayer {
    
    if (_curruntScene) {
        
        return 1;
    }
    
    return 0;
}

- (NSInteger)vrplayer:(UVVRPlayer *)vrplayer numberOfModelsInScene:(NSInteger)sceneIndex {
    
    if (_curruntScene.models.count > 0) {
        
        return _curruntScene.models.count;
    }
    return 0;
}

- (UVScene *)vrplayer:(UVVRPlayer *)vrplayer sceneAtIndex:(NSInteger)sceneIndex {
    
    return _curruntScene;
}

- (UVModel *)vrplayer:(UVVRPlayer *)vrplayer modelForSceneAtIndex:(NSIndexPath *)indexPath {
    
    return [_curruntScene.models objectAtIndex:indexPath.row];
}

@end
