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
    
    //缩放
    GLKMatrix4 m = GLKMatrix4Identity;
    m = GLKMatrix4Scale(m, self.sx, self.sy, self.sz);
    
    //旋转
    GLKMatrix4 m0 = GLKMatrix4Identity;
    m0 = GLKMatrix4Rotate(m0, GLKMathDegreesToRadians(self.rz), 0, 0, 1);
    m0 = GLKMatrix4Rotate(m0, GLKMathDegreesToRadians(self.rx), 1, 0, 0);
    m0 = GLKMatrix4Rotate(m0, GLKMathDegreesToRadians(self.ry), 0, 1, 0);
    m = GLKMatrix4Multiply(m0, m);
    
    //平移
    GLKMatrix4 mtr = GLKMatrix4MakeTranslation(self.tx, self.ty, self.tz);
    m = GLKMatrix4Multiply(mtr, m);
    
    //转到空间yaw、pitch处
    mtr = GLKMatrix4MakeTranslation(0, 0, -1);
    m = GLKMatrix4Multiply(mtr, m);
    
    GLKMatrix4 m1 = GLKMatrix4Identity;
    m1 = GLKMatrix4Rotate(m1, GLKMathDegreesToRadians(self.yaw), 0, 1, 0);
    m1 = GLKMatrix4Rotate(m1, GLKMathDegreesToRadians(self.pitch), 1, 0, 0);
    m1 = GLKMatrix4Multiply(m1, m);
    
    mtr = GLKMatrix4MakeTranslation(0, 0, 1);
    m1 = GLKMatrix4Multiply(mtr, m1);
    
    //附加相机矩阵
    m1 = GLKMatrix4Multiply(mvp, m1);
    self.mvp = m1;
    
    if ([self.delegate respondsToSelector:@selector(configureModelViewMatrixForModel:)]) {
        
        [self.delegate configureModelViewMatrixForModel:self];
    }
}

- (void)draw {
    
}

- (void)free {
    
}

@end
