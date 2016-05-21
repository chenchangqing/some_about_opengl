//
//  UVModel.h
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import <Foundation/Foundation.h>

@interface UVModel : NSObject

@property (nonatomic, assign) float yaw;
@property (nonatomic, assign) float pitch;

@property (nonatomic, assign) float sx;
@property (nonatomic, assign) float sy;
@property (nonatomic, assign) float sz;

@property (nonatomic, assign) float tx;
@property (nonatomic, assign) float ty;
@property (nonatomic, assign) float tz;

@property (nonatomic, assign) float rx;
@property (nonatomic, assign) float ry;
@property (nonatomic, assign) float rz;

@property (nonatomic, strong) UIImage *backgroundImage;

- (void)addSubModel:(UVModel *)model;
- (void)removeSubModel:(UVModel *)model;

@end
