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
#import "UVModelConfig.h"

@interface UVModel : NSObject

@property (nonatomic, assign) GLKMatrix4 mvp;

- (void)setup;
- (void)drawWithPMatrix: (GLKMatrix4) projectionMatrix andConfig: (UVModelConfig *) config;
- (void)free;

@end
