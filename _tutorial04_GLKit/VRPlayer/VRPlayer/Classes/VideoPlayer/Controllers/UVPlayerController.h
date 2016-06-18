//
//  UVPlayerController.h
//  Pods
//
//  Created by green on 16/6/18.
//
//

@interface UVPlayerController : NSObject

- (id)initWithURL:(NSURL *)assetURL;

@property (strong, nonatomic, readonly) UIView *view;

@end
