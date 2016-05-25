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
@property (nonatomic, assign) float itemCount;

@property (nonatomic, assign) float horizontalMargin;
@property (nonatomic, assign) float verticalMargin;

@property (nonatomic, assign) float rowSpace;
@property (nonatomic, assign) float columnSpace;

@property (nonatomic, strong) NSArray *indexPaths;
@property (nonatomic, strong) NSArray *models;

@end

@implementation UVCollection

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _tempMatrix = GLKMatrix4Identity;
        
        _rowCount = 3.0f;
        _columnCount = 4.0f;
        _itemCount = 0.0f;
        
        _horizontalMargin = 0.1f;
        _verticalMargin = 0.1f;
        
        _rowSpace = 0.1f;
        _columnSpace = 0.1f;
    }
    return self;
}

- (NSArray *)indexPaths {
    
    if (_indexPaths) {
        
        return _indexPaths;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for(int row=0;row<self.rowCount;row++) {
        
        BOOL flag = false;
        for(int column=0;column<self.columnCount;column++) {
            
            int willnum = self.columnCount * (row) +(column + 1);
            if (willnum > self.itemCount) {
                
                flag = true;
                break;
            }
            UVIndexPath *indexPath = [UVIndexPath indexPathForRow:row andColumn:column];
            [array addObject:indexPath];
        }
        
        if (flag) {
            break;
        }
    }
    _indexPaths = [NSArray arrayWithArray:array];
    return _indexPaths;
}

- (NSArray *)models {
    
    if (_models) {
        return _models;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for(int row=0;row<self.rowCount;row++) {
        
        NSMutableArray *rowArray = [NSMutableArray arrayWithCapacity:0];
        
        BOOL flag = false;
        for(int column=0;column<self.columnCount;column++) {
            
            int willnum = self.columnCount * (row) +(column + 1);
            if (willnum > self.itemCount) {
                
                flag = true;
                
                if (column != 0) {
                    
                    [array addObject:rowArray];
                }
                break;
            }
            [rowArray addObject:[[UVSquare alloc] init]];
            
        }
        
        if (flag) {
            break;
        }
        
        [array addObject:rowArray];
    }
    _models = [NSArray arrayWithArray:array];
    return _models;
}

- (float)itemCount {
    
    if ([_dataSource respondsToSelector:@selector(numberOfItemsInCollection:)]) {
        
        _itemCount = [_dataSource numberOfItemsInCollection:self];
    }
    return _itemCount;
}

- (float)rowCount {
    
    if ([_dataSource respondsToSelector:@selector(numberOfRowsInCollection:)]) {
        
        _rowCount = [_dataSource numberOfRowsInCollection:self];
    }
    return _rowCount;
}

- (float)columnCount {
    
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInCollection:)]) {
        
        _columnCount = [_dataSource numberOfColumnsInCollection:self];
    }
    return _columnCount;
}

- (float)horizontalMargin {
    
    if ([self.delegate respondsToSelector:@selector(horizontalMargin:)]) {
        
        _horizontalMargin = [self.delegate horizontalMargin:self];
    }
    return _horizontalMargin;
}

- (float)verticalMargin {
    
    if ([self.delegate respondsToSelector:@selector(verticalMargin:)]) {
        
        _verticalMargin = [self.delegate verticalMargin:self];
    }
    return _verticalMargin;
}

- (float)rowSpace {
    
    if ([self.delegate respondsToSelector:@selector(rowSpace:)]) {
        
        _rowSpace = [self.delegate rowSpace:self];
    }
    return _rowSpace;
}

- (float)columnSpace {
    
    if ([self.delegate respondsToSelector:@selector(columnSpace:)]) {
        
        _columnSpace = [self.delegate columnSpace:self];
    }
    return _columnSpace;
}

- (void)setup {
    [super setup];
    
    for (UVIndexPath *indexPath in self.indexPaths) {
        
        UVSquare * model = [[self.models objectAtIndex:indexPath.row] objectAtIndex:indexPath.column];
        
        if ([self.delegate respondsToSelector:@selector(collection:configureModel:atIndexPath:)]) {
            
            [self.delegate collection:self configureModel:model atIndexPath:indexPath];
        }
        
        [model setup];
    }
    
}

- (void)updateWithProjectionMatrix: (GLKMatrix4)projectionMatrix {
    [super updateWithProjectionMatrix:projectionMatrix];
    
    float aspectW = ( 1/(self.horizontalMargin*2 + self.columnCount*2 + self.columnSpace * (self.columnCount - 1) ) / ( 1/(self.columnCount*2)) );
    float originW = 1.0f / self.columnCount;
    float itemW = originW * aspectW;
    
    float aspectH = ( 1/(self.verticalMargin*2 + self.rowCount*2 + self.rowSpace * (self.rowCount - 1) ) / (1/(self.rowCount*2)) );
    float originH = 1.0f / self.rowCount;
    float itemH = originH * aspectH;
    
    float itemSx = itemW;
    float itemSy = itemH;
    
    _tempMatrix = [super modelViewMatrix];
    _tempMatrix = GLKMatrix4Scale(_tempMatrix, itemSx, itemSy, 1.0f);
    
    
    for (UVIndexPath *indexPath in self.indexPaths) {
        
        UVSquare * model = [[self.models objectAtIndex:indexPath.row] objectAtIndex:indexPath.column];
        
        [model updateWithProjectionMatrix:projectionMatrix];
        [self updateTempMatrix:indexPath];
        
        model.modelViewMatrix = GLKMatrix4Multiply(model.modelViewMatrix, _tempMatrix);
        
        // 回调
        if ([self.delegate respondsToSelector:@selector(collection:configureModelViewMatrixForModel:atIndexPath:)]) {
            
            [self.delegate collection:self configureModelViewMatrixForModel:model atIndexPath:indexPath];
        }
    }
    
}

- (void)updateTempMatrix:(UVIndexPath *) indexPath {
    
    if (indexPath.column == 0) {
        
        if (indexPath.row == 0) {
            
            _tempMatrix = GLKMatrix4Translate(_tempMatrix,
                                              -(self.columnCount-1)-self.columnSpace*(/** 变量 **/(self.columnCount-1)/2),
                                              +(self.rowCount-1)+self.rowSpace*(/** 变量 **/(self.rowCount-1)/2),
                                              0.0f);
        } else {
            
            _tempMatrix = GLKMatrix4Translate(_tempMatrix,
                                              -(self.columnCount-1)*2-self.columnSpace*(/** 变量 **/(self.columnCount-1)),
                                              -2-self.rowSpace,
                                              0.0f);
        }
        
    } else {
        
        _tempMatrix = GLKMatrix4Translate(_tempMatrix, 2+self.columnSpace, 0, 0.0f);
    }
}

- (void)draw {
    [super draw];
    
    for (UVIndexPath *indexPath in self.indexPaths) {
        
        UVSquare * model = [[self.models objectAtIndex:indexPath.row] objectAtIndex:indexPath.column];
        
        [model draw];
    }
    
}

- (void)free {
    [super free];
    
    for (UVIndexPath *indexPath in self.indexPaths) {
        
        UVSquare * model = [[self.models objectAtIndex:indexPath.row] objectAtIndex:indexPath.column];
        
        [model free];
    }
}

@end
