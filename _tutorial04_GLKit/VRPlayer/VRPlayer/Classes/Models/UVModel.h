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

- (void)setup;
- (void)drawWithPMatrix: (GLKMatrix4) projectionMatrix andMVMatrix:(GLKMatrix4) modelViewMatrix andConfig: (UVModelConfig *) config;
- (void)free;

@end
