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
#import "OpenGLProgram.h"

#define kAPositionName @"a_position"
#define kAColorName @"a_color"
#define kATextureCoordName @"a_textureCoord"
#define kUMVPName @"u_mvp"
#define kUBGSamplerName @"u_BGSampler"

enum {
    ATTRIBUTE_POSITION,
    ATTRIBUTE_COLOR,
    ATTRIBUTE_TEXCOORD,
    NUM_ATTRIBUTES
};

enum {
    UNIFORM_MVP,
    UNIFORM_SAMPLER,
    NUM_UNIFORMS
};

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
@interface UVModel : NSObject {
    
    GLint uniforms[NUM_UNIFORMS];
    GLint attributes[NUM_ATTRIBUTES];
}

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

@property (nonatomic, strong) UIColor *backgroundColor;

@property (strong, nonatomic) OpenGLProgram *program;
@property (nonatomic, assign) GLKMatrix4 mvp;

@property (nonatomic, weak) id <UVModelDelegate> delegate;

- (void)updateWithMVP: (GLKMatrix4)mvp;
- (void)draw;
- (void)free;

- (void)buildProgram;

- (void)setupPositionBuffer:(GLuint*)buffer positonAttrib:(GLuint)attrib;
- (void)setupTextureBuffer:(GLuint*)buffer textureAttrib:(GLuint)attrib;
- (void)setupElementBuffer:(GLuint*)buffer elementCount:(GLsizei *)count;

- (void)updateTextureInfo:(GLuint*)textureIndex;

@end
