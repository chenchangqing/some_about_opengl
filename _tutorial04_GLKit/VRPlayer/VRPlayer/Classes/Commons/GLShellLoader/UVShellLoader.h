//
//  UVShellLoader.h
//  UtoVRPlayer
//
//  Created by XueMinghao on 16/4/21.
//  Copyright © 2016年 xue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

typedef void(^BindAttribLocationBlock)(GLuint programIndex);

@interface UVShellLoader : NSObject

+ (GLuint)loadSphereShadersWithVertexShaderString:(NSString*)vertexShaderString fragmentShaderString:(NSString*)fragmentShaderString callback:(BindAttribLocationBlock)block;

@end
