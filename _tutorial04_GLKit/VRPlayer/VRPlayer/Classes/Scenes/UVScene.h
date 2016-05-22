//
//  UVScence.h
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import <Foundation/Foundation.h>
#import "UVModel.h"

@interface UVScene : UVModel

@property(nonatomic,strong) NSMutableArray *configs;

- (void)prepareConfigs;

@end
