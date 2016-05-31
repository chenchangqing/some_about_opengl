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

- (void)updateWithMVP: (GLKMatrix4)mvp {
    [super updateWithMVP:mvp];
    
    float aspectW = (2 - self.columnSpace * (self.columnCount - 1) - self.horizontalMargin*2)/self.columnCount/2*self.sx;
    float aspectH = (2 - self.rowSpace * (self.rowCount - 1) - self.verticalMargin*2)/self.rowCount/2*self.sy;

    /**
     *  单元格布局
     */
    for (UVIndexPath *indexPath in self.indexPaths) {
        
        UVSquare * model = [[self.models objectAtIndex:indexPath.row] objectAtIndex:indexPath.column];
        
        if (indexPath.column == 0) {
            
            model.tx = -1.0f + 2*aspectW/2 + self.horizontalMargin;
        } else if (indexPath.column == self.columnCount - 1) {
            
            model.tx = 1.0f - 2*aspectW/2 - self.horizontalMargin;
        } else {
            
            if ((int)self.columnCount%2 == 0) {
                
                if ((indexPath.column + 1) < (self.columnCount)/2) {
                    
                    model.tx = ((indexPath.column + 1) - (self.columnCount)/2) * (2*aspectW + self.columnSpace) - 2*aspectW/2 - self.columnSpace/2;
                }
                
                if ((indexPath.column + 1) == (self.columnCount)/2) {
                    
                    model.tx = - 2*aspectW/2 - self.columnSpace/2;
                }
                
                if ((indexPath.column + 1) > (self.columnCount)/2) {
                    
                    model.tx = ((indexPath.column + 1) - (self.columnCount)/2) * (2*aspectW + self.columnSpace) - 2*aspectW/2 - self.columnSpace/2;
                }
            } else {
                
                if ((indexPath.column + 1) < (self.columnCount + 1)/2) {
                    
                    model.tx = ((indexPath.column + 1) - (self.columnCount + 1)/2) * (2*aspectW + self.columnSpace);
                }
                
                if ((indexPath.column + 1) == (self.columnCount + 1)/2) {
                    
                }
                
                if ((indexPath.column + 1) > (self.columnCount + 1)/2) {
                    
                    model.tx = ((indexPath.column + 1) - (self.columnCount + 1)/2) * (2*aspectW + self.columnSpace);
                }
            }
            
        }
        
        if (indexPath.row == 0) {
            
            model.ty = 1.0f - 2*aspectH/2 - self.verticalMargin;
        } else if (indexPath.row == self.rowCount - 1) {
            
            model.ty = -1.0f + 2*aspectH/2 + self.verticalMargin;
        } else {
            
            if ((int)self.rowCount%2 == 0) {
                
                if ((indexPath.row + 1) < (self.rowCount)/2) {
                    
                    model.ty = ((indexPath.row + 1) - (self.rowCount)/2) * (2*aspectH + self.rowSpace) - 2*aspectH/2 - self.rowSpace/2;
                }
                
                if ((indexPath.row + 1) == (self.rowCount)/2) {
                    
                    model.ty = - 2*aspectH/2 - self.rowSpace/2;
                }
                
                if ((indexPath.row + 1) > (self.rowCount)/2) {
                    
                    model.ty = ((indexPath.row + 1) - (self.rowCount)/2) * (2*aspectH + self.rowSpace) - 2*aspectH/2 - self.rowSpace/2;
                }
            } else {
                
                if ((indexPath.row + 1) < (self.rowCount + 1)/2) {
                    
                    model.ty = ((indexPath.row + 1) - (self.rowCount + 1)/2) * (2*aspectH + self.rowSpace);
                }
                
                if ((indexPath.row + 1) == (self.rowCount + 1)/2) {
                    
                }
                
                if ((indexPath.row + 1) > (self.rowCount + 1)/2) {
                    
                    model.ty = ((indexPath.row + 1) - (self.rowCount + 1)/2) * (2*aspectH + self.rowSpace);
                }
            }
        }
        
        model.yaw = self.yaw;
        model.pitch = self.pitch;
        model.sx = aspectW;
        model.sy = aspectH;
        model.sz = self.sz;
        model.tz = self.tz;
        model.rx = self.rx;
        model.ry = self.ry;
        model.rz = self.rz;
        
        [model updateWithMVP:mvp];
        
        // 回调
        if ([self.delegate respondsToSelector:@selector(collection:configureModelViewMatrixForModel:atIndexPath:)]) {
            
            [self.delegate collection:self configureModelViewMatrixForModel:model atIndexPath:indexPath];
        }
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
