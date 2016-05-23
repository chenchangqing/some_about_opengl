//
//  UVCollection.m
//  Pods
//
//  Created by green on 16/5/24.
//
//

#import "UVCollection.h"

@implementation UVCollection

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _rowCount = 3;
        _columnCount = 4;
    }
    return self;
}

- (void)setup {
    [super setup];
    
}

- (void)updateWithPMatrix:(GLKMatrix4)projectionMatrix {

    [super updateWithPMatrix:projectionMatrix];
}

- (void)draw {
    [super draw];
    
}

- (void)free {
    [super free];
}

@end
