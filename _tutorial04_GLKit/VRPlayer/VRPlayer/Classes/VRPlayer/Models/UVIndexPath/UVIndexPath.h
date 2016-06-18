//
//  UVIndexPath.h
//  Pods
//
//  Created by green on 16/5/25.
//
//

#import <Foundation/Foundation.h>

@interface UVIndexPath : NSObject

+ (instancetype)indexPathForRow:(float)row andColumn:(float)column;

@property (nonatomic, assign) float row;
@property (nonatomic, assign) float column;

@end
