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
        
        _rowCount = 3.0f;
        _columnCount = 4.0f;
        
        _leftMargin = 0.1f;
        _rightMargin = 0.1f;
        _topMargin = 0.1f;
        _bottomMargin = 0.1f;
        
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
    
    float aspectW = ( 1/(_columnCount*2 + _columnSpace * (_columnCount - 1) ) / ( 1/(_columnCount*2)));
    float originW = 1.0f / _columnCount;
    float itemW = originW * aspectW;
    
    float aspectH = ( 1/(_rowCount*2 + _rowSpace * (_rowCount - 1) ) / (1/(_rowCount*2)) );
    float originH = 1.0f / _rowCount;
    float itemH = originH * aspectH;
    
    float itemSx = itemW;
    float itemSy = itemH;
    
    super.modelViewMatrix = GLKMatrix4Scale(super.modelViewMatrix, itemSx, itemSy, 1.0f);

    for(int row=1;row<=_rowCount;row++) {
        
        for(int column=1;column<=_columnCount;column++) {
            
            // 如果是第一列，做连续位移(_columnCount-1)*2个单位
            if (column == 1) {
                
                // 找关系Horizontal
                // _columnCount row==1  row!=1
                // 1            0       0
                // 2            0.5     1
                // 3            1       2
                // 4            1.5     3
                // 5            2       4
                // 6            2.5     5
                
                // 找关系Vertical
                // _rowCount row==1
                // 1            0
                // 2            0.5
                // 3            1
                // 4            1.5
                // 5            2
                // 6            2.5
                
                // 如果是第一行，特殊处理
                if (row == 1) {
                    
                    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix,
                                                                -(_columnCount-1)-_columnSpace*(/** 变量 **/(_columnCount-1)/2),
                                                                +(_rowCount-1)+_rowSpace*(/** 变量 **/(_rowCount-1)/2),
                                                                0.0f);
                } else {
                    
                    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix,
                                                                -(_columnCount-1)*2-_columnSpace*(/** 变量 **/(_columnCount-1)),
                                                                -2-_rowSpace,
                                                                0.0f);
                }
                
            } else {
                
                super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 2+_columnSpace, 0, 0.0f);
            }
            [super draw];
        }
    }
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 1-_columnCount, _rowCount-1, 0.0f);
//    [super draw];
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 2, 0, 0.0f);
//    [super draw];
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 2, 0, 0.0f);
//    [super draw];
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 2, 0, 0.0f);
//    [super draw];
//    
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, -(_columnCount-1)*2, -2, 0.0f);
//    [super draw];
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 2, 0, 0.0f);
//    [super draw];
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 2, 0, 0.0f);
//    [super draw];
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 2, 0, 0.0f);
//    [super draw];
//
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, -(_columnCount-1)*2, -2, 0.0f);
//    [super draw];
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 2, 0, 0.0f);
//    [super draw];
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 2, 0, 0.0f);
//    [super draw];
//    super.modelViewMatrix = GLKMatrix4Translate(super.modelViewMatrix, 2, 0, 0.0f);
//    [super draw];
    
    
}

- (void)free {
    [super free];
}

@end
