//
//  UVPlayerController.m
//  Pods
//
//  Created by green on 16/6/18.
//
//

#import "UVPlayerController.h"
#import "UVPlayerView.h"
#import <AVFoundation/AVFoundation.h>

#define STATUS_KEYPATH @"status"
static const NSString *PlayerItemStatusContext;

@interface UVPlayerController()

@property (strong, nonatomic) AVAsset *asset;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) UVPlayerView *playerView;

@end

@implementation UVPlayerController

#pragma mark - Setup

- (id)initWithURL:(NSURL *)assetURL {
    self = [super init];
    if (self) {
        _asset = [AVAsset assetWithURL:assetURL];
        [self prepareToPlay];
    }
    return self;
}

- (void)prepareToPlay {
    NSArray *keys = @[
                      @"tracks",
                      @"duration",
                      @"commonMetadata",
                      @"availableMediaCharacteristicsWithMediaSelectionOptions"
                      ];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset
                           automaticallyLoadedAssetKeys:keys];
    
    [self.playerItem addObserver:self                                       // 3
                      forKeyPath:STATUS_KEYPATH
                         options:0
                         context:&PlayerItemStatusContext];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerView = [[UVPlayerView alloc] initWithPlayer:self.player];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context {
    
    if (context == &PlayerItemStatusContext) {
        
        dispatch_async(dispatch_get_main_queue(), ^{                        // 1
            
            [self.playerItem removeObserver:self forKeyPath:STATUS_KEYPATH];
            
            if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
                
                // Set up time observers.                                   // 2
                
                
                CMTime duration = self.playerItem.duration;
                
                // Synchronize the time display                             // 3
                
                
                // Set the video title.
                                 // 4
                
                [self.player play];                                         // 5
                
                
            } else {
                
            }
        });
    }
}

#pragma mark - Housekeeping

- (UIView *)view {
    return self.playerView;
}

@end
