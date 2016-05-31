//
//  UVModel.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVModel.h"
#import "MacroDefinition.h"

@interface UVModel() {
    
    int _degree;
    
}

@end

@implementation UVModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _mvp = GLKMatrix4Identity;;
        
        _yaw = 0.0f;
        _pitch = 0.0f;
        
        _sx = 1.0f;
        _sy = 1.0f;
        _sz = 1.0f;
        
        _tx = 0.0f;
        _ty = 0.0f;
        _tz = 0.0f;
        
        _rx = 0.0f;
        _ry = 0.0f;
        _rz = 0.0f;
        
        self.backgroundColor = RandColor;
    }
    return self;
}

- (void)dealloc
{
    [self free];
}

- (void)setup {
    
}

- (void)updateWithMVP: (GLKMatrix4)mvp {
    
    //构建平移到z=0的矩阵
    GLKMatrix4 mtr = GLKMatrix4MakeTranslation(0, 0, 1);
    //缩放
    GLKMatrix4 m = GLKMatrix4Identity;
    m = GLKMatrix4Scale(m, self.sx, self.sy, self.sz);
    m = GLKMatrix4Multiply(m, mtr);
    //自身旋转矩阵
    GLKMatrix4 m0 = GLKMatrix4Identity;
    m0 = GLKMatrix4Rotate(m0, GLKMathDegreesToRadians(self.rz), 0, 0, 1);
    m0 = GLKMatrix4Rotate(m0, GLKMathDegreesToRadians(self.rx), 1, 0, 0);
    m0 = GLKMatrix4Rotate(m0, GLKMathDegreesToRadians(self.ry), 0, 1, 0);
    m = GLKMatrix4Multiply(m0, m);
    //移回到z处
    mtr = GLKMatrix4MakeTranslation(self.tx, self.ty, -1+self.tz);
    m = GLKMatrix4Multiply(mtr, m);
    //转到空间yaw、pitch处
    GLKMatrix4 m1 = GLKMatrix4Identity;
    m1 = GLKMatrix4Rotate(m1, GLKMathDegreesToRadians(self.yaw + _degree), 0, 1, 0);
    m1 = GLKMatrix4Rotate(m1, GLKMathDegreesToRadians(self.pitch), 1, 0, 0);
    m1 = GLKMatrix4Multiply(m1, m);
    //附加相机矩阵
    m1 = GLKMatrix4Multiply(mvp, m1);
    self.mvp = m1;
    
//    _degree++;
    
    if (_degree >= 360) {
        
        _degree = _degree % 360;
    }
    
    if ([self.delegate respondsToSelector:@selector(configureModelViewMatrixForModel:)]) {
        
        [self.delegate configureModelViewMatrixForModel:self];
    }
}

- (void)draw {
    
}

- (void)free {
    
}

@end
