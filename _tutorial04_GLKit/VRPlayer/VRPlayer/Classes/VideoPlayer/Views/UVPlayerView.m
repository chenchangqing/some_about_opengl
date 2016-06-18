//
//  UVPlayerView.m
//  Pods
//
//  Created by green on 16/6/18.
//
//

#import "UVPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@implementation UVPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (id)initWithPlayer:(AVPlayer *)player {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth;
        
        [(AVPlayerLayer *) [self layer] setPlayer:player];
    }
    return self;
}

@end
