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
        
        _rowCount = 2.0f;
        _columnCount = 3.0f;
        
        _margin = 0.1f;
        _padding = 0.1f;
        
        _rowSpace = 0.1f;
        _columnSpace = 0.1f;
    }
    return self;
}

- (void)setup {
    [super setup];
    
}

- (void)updateWithProjectionMatrix: (GLKMatrix4)projectionMatrix {
    [super updateWithProjectionMatrix:projectionMatrix];
    
}

- (void)draw {
    [super draw];
    
//    float itemW = 1.0f/_columnCount;
//    float itemH = 1.0f/_rowCount;
//    
//    float itemSx = itemW;
//    float itemSy = itemH;
//    
//    super.modelViewMatrix = GLKMatrix4Scale(super.modelViewMatrix, itemSx, itemSy, 1.0f);
//    
//    for(int i=0;i<_rowCount;i++) {
//        
//        for(int j=0;j<_columnCount;j++) {
//            
//        }
//    }
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 1-_columnCount, _rowCount-1, 0.0f);
//    [super draw];
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 2, 0, 0.0f);
//    [super draw];
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 2, 0, 0.0f);
//    [super draw];
//    
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 0, -2, 0.0f);
//    [super draw];
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, -2, 0, 0.0f);
//    [super draw];
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, -2, 0, 0.0f);
//    [super draw];
    
    
}

- (void)free {
    [super free];
}

@end
