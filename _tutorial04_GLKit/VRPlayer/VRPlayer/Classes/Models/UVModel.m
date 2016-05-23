//
//  UVModel.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVModel.h"

@interface UVModel() {
    
    int _degree;
    
}

@end

@implementation UVModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _mvp = GLKMatrix4Identity;
        
        _yaw = 0;
        _pitch = 0;
        
        _sx = 1;
        _sy = 1;
        _sz = 1;
        
        _tx = 0.0;
        _ty = 0.0;
        _tz = 0.0;
        
        _rx = 0;
        _ry = 0;
        _rz = 0;
    }
    return self;
}

- (void)dealloc
{
    [self free];
}

- (void)setup {
    
}

- (void)updateWithPMatrix:(GLKMatrix4)projectionMatrix {
    
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0, 0, -0.8);
    
    // 位置
    // baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, GLKMathDegreesToRadians(_pitch), 1, 0, 0);
    baseModelViewMatrix = GLKMatrix4Translate(baseModelViewMatrix, 0, sin(_pitch), 0);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, GLKMathDegreesToRadians(_yaw + _degree), 0, 1, 0);
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(baseModelViewMatrix, 0, 0, 0);
    
    // 缩放
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, _sx, _sy, _sz);
    
    // 位移
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, _tx, _ty, _tz);
    
    // 旋转
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rx + _degree), 1, 0, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_ry + _degree), 0, 1, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rz + _degree), 0, 0, 1);
    
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    // mvp
    _mvp = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    //    _degree++;
    
    
    if (_degree >= 360) {
        
        _degree = _degree % 360;
    }
}

- (void)draw {
    
}

- (void)free {
    
}

@end
