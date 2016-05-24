//
//  UVCollection.m
//  Pods
//
//  Created by green on 16/5/24.
//
//

#import "UVCollection.h"

@interface UVCollection() {
    
    GLKMatrix4 _tempMatrix;
}

@property (nonatomic, assign) float rowCount;
@property (nonatomic, assign) float columnCount;
@property (nonatomic, readonly) NSArray *indexPaths;

@end

@implementation UVCollection

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _tempMatrix = GLKMatrix4Identity;
        
        _horizontalMargin = 0.3f;
        _verticalMargin = 0.3f;
        
        _rowSpace = 0.3f;
        _columnSpace = 0.3f;
    }
    return self;
}

- (NSArray *)indexPaths {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for(int row=0;row<self.rowCount;row++) {
        
        for(int column=0;column<self.columnCount;column++) {
            
            if ([_dataSource respondsToSelector:@selector(collection:modelForItemAtIndexPath:)]) {
                
                UVIndexPath *indexPath = [UVIndexPath indexPathForRow:row andColumn:column];
                [array addObject:indexPath];
            }
        }
    }
    
    return [NSArray arrayWithArray:array];
}

- (float)rowCount {
    
    if ([_dataSource respondsToSelector:@selector(numberOfRowsInCollection:)]) {
        
        return [_dataSource numberOfRowsInCollection:self];
    }
    return 3.0f;
}

- (float)columnCount {
    
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInCollection:)]) {
        
        return [_dataSource numberOfColumnsInCollection:self];
    }
    return 4.0f;
}

- (void)setup {
    [super setup];
    
    for (UVIndexPath *indexPath in self.indexPaths) {
        
        if ([_dataSource respondsToSelector:@selector(collection:modelForItemAtIndexPath:)]) {
            
            UVSquare * model = [_dataSource collection:self modelForItemAtIndexPath:indexPath];
            
            [model setup];
        }
    }
    
}

- (void)updateWithProjectionMatrix: (GLKMatrix4)projectionMatrix {
    [super updateWithProjectionMatrix:projectionMatrix];
    
    float aspectW = ( 1/(_horizontalMargin*2 + self.columnCount*2 + _columnSpace * (self.columnCount - 1) ) / ( 1/(self.columnCount*2)) );
    float originW = 1.0f / self.columnCount;
    float itemW = originW * aspectW;
    
    float aspectH = ( 1/(_verticalMargin*2 + self.rowCount*2 + _rowSpace * (self.rowCount - 1) ) / (1/(self.rowCount*2)) );
    float originH = 1.0f / self.rowCount;
    float itemH = originH * aspectH;
    
    float itemSx = itemW;
    float itemSy = itemH;
    
    _tempMatrix = [super modelViewMatrix];
    _tempMatrix = GLKMatrix4Scale(_tempMatrix, itemSx, itemSy, 1.0f);
    
    
    for (UVIndexPath *indexPath in self.indexPaths) {
        
        [self updateTempMatrix:indexPath];
        
        if ([_dataSource respondsToSelector:@selector(collection:modelForItemAtIndexPath:)]) {
            
            UVSquare * model = [_dataSource collection:self modelForItemAtIndexPath:indexPath];
            
            [model updateWithProjectionMatrix:projectionMatrix];
            model.modelViewMatrix = GLKMatrix4Multiply(model.modelViewMatrix, _tempMatrix);
            
            // 回调
            if ([_delegate respondsToSelector:@selector(collection:modelViewMatrix:atIndexPath:)]) {
                
                [_delegate collection:self modelViewMatrix:model.modelViewMatrix atIndexPath:indexPath];
            }
        }
    }
    
}

- (void)updateTempMatrix:(UVIndexPath *) indexPath {
    
    if (indexPath.column == 0) {
        
        if (indexPath.row == 0) {
            
            _tempMatrix = GLKMatrix4Translate(_tempMatrix,
                                              -(self.columnCount-1)-_columnSpace*(/** 变量 **/(self.columnCount-1)/2),
                                              +(self.rowCount-1)+_rowSpace*(/** 变量 **/(self.rowCount-1)/2),
                                              0.0f);
        } else {
            
            _tempMatrix = GLKMatrix4Translate(_tempMatrix,
                                              -(self.columnCount-1)*2-_columnSpace*(/** 变量 **/(self.columnCount-1)),
                                              -2-_rowSpace,
                                              0.0f);
        }
        
    } else {
        
        _tempMatrix = GLKMatrix4Translate(_tempMatrix, 2+_columnSpace, 0, 0.0f);
    }
}

- (void)draw {
    [super draw];
    
    for (UVIndexPath *indexPath in self.indexPaths) {
        
        if ([_dataSource respondsToSelector:@selector(collection:modelForItemAtIndexPath:)]) {
            
            UVSquare * model = [_dataSource collection:self modelForItemAtIndexPath:indexPath];
            
            [model draw];
        }
    }
    
}

- (void)free {
    [super free];
    
    for (UVIndexPath *indexPath in self.indexPaths) {
        
        if ([_dataSource respondsToSelector:@selector(collection:modelForItemAtIndexPath:)]) {
            
            UVSquare * model = [_dataSource collection:self modelForItemAtIndexPath:indexPath];
            
            [model free];
        }
    }
}

@end
