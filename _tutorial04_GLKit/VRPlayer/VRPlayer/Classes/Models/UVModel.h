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
- (void)drawWithMVP: (GLKMatrix4) mvp andConfig: (UVModelConfig *) config;
- (void)free;

@end
