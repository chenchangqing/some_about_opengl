//
//  UVShellLoader.h
//  UtoVRPlayer
//
//  Created by XueMinghao on 16/4/21.
//  Copyright © 2016年 xue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface UVShellLoader : NSObject
/**
 *  locations: 一个由包含健为index,name的字典组成的数组
 */
+ (GLuint)loadSphereShadersWithVertexShaderString:(NSString*)vertexShaderString fragmentShaderString:(NSString*)fragmentShaderString andAttribLocations:(NSArray*)locations;

@end
