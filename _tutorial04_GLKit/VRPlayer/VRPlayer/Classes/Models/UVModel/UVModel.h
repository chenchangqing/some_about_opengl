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

#define kAPositionName @"a_position"
#define kAColorName @"a_color"
#define kATextureCoordName @"a_textureCoord"
#define kUMVPName @"u_mvp"
#define kUBGSamplerName @"u_BGSampler"

@class UVModel;
/**
 *  委托
 */
@protocol UVModelDelegate<NSObject>
@optional

- (void)configureModelViewMatrixForModel:(UVModel *) model;

@end

/**
 *  模型超类
 */
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

@property (nonatomic, assign) GLKMatrix4 mvp;

@property (nonatomic, weak) id <UVModelDelegate> delegate;

- (void)setup;
- (void)updateWithMVP: (GLKMatrix4)mvp;
- (void)draw;
- (void)free;

- (void)setupVertexCount:(int *)count vertexData:(GLfloat **)data;
- (void)setupColorCount:(int *)count colorData:(GLfloat **)data;
- (void)setupElementCount:(int *)count elementData:(GLfloat **)data;

@end
