//
//  UVBorderSphereModel.h
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import <Foundation/Foundation.h>
#import "UVModel.h"

@interface UVBorderSphereModel : UVModel

- (void)createBorderSphere;

- (void)drawInRect:(CGRect)rect;

- (void)free;

@end
