//
//  UVBorderSphereScene.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVBorderSphereScene.h"
#import "UVBorderSphereModel.h"
#import "UVSquare.h"

@implementation UVBorderSphereScene

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        UVBorderSphereModel *model = [[UVBorderSphereModel alloc] init];
        
        UVSquare *square = [[UVSquare alloc] init];
        [self.models addObject: square];
        [self.models addObject: model];
        
    }
    
    return self;
}

@end
