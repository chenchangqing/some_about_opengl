//
//  UVModel.h
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

@interface UVModel : NSObject

// 逆时针公转
@property (nonatomic, assign) float yaw;
@property (nonatomic, assign) float pitch;

// 缩放
@property (nonatomic, assign) float sx;
@property (nonatomic, assign) float sy;
@property (nonatomic, assign) float sz;

// 平移
@property (nonatomic, assign) float tx;
@property (nonatomic, assign) float ty;
@property (nonatomic, assign) float tz;

// 逆时针自转
@property (nonatomic, assign) float rx;
@property (nonatomic, assign) float ry;
@property (nonatomic, assign) float rz;

// 背景图
@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, assign) GLKMatrix4 mvp;

- (void)setup;
- (void)drawWithPMatrix: (GLKMatrix4) projectionMatrix;
- (void)free;

@end
