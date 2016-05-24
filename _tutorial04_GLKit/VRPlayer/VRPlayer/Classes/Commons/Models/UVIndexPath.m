//
//  UVIndexPath.m
//  Pods
//
//  Created by green on 16/5/25.
//
//

#import "UVIndexPath.h"

@implementation UVIndexPath

+ (instancetype)indexPathForRow:(float)row andColumn:(float)column {
    
    UVIndexPath *indexPath = [[UVIndexPath alloc] init];
    
    indexPath.row = row;
    indexPath.column = column;
    
    return indexPath;
}

@end
