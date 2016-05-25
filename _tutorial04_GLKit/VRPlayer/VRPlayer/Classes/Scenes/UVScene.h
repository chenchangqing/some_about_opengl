//
//  UVScence.h
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import <Foundation/Foundation.h>
#import "UVModel.h"

/**
 *  场景
 */
@interface UVScene : UVModel

@property(nonatomic,strong) NSMutableArray *models;

/**
 *  准备模型
 */
- (void)prepareModels;

@end
