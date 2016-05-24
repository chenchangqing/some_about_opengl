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
        
        _projectionMatrix = GLKMatrix4Identity;
        _modelViewMatrix = GLKMatrix4Identity;
        
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

- (void)updateWithProjectionMatrix: (GLKMatrix4)projectionMatrix {
    
    // 初始位置(先绕y轴旋转,在绕x轴旋转)
    GLKMatrix4 positionMatrix = GLKMatrix4Identity;
    positionMatrix = GLKMatrix4Rotate(positionMatrix, GLKMathDegreesToRadians(_yaw + _degree), 0, 1, 0);
    positionMatrix = GLKMatrix4Rotate(positionMatrix, GLKMathDegreesToRadians(_pitch + _degree), 1, 0, 0);
    
    _projectionMatrix = projectionMatrix;
    _modelViewMatrix = GLKMatrix4Identity;
    
    // 缩放
    _modelViewMatrix = GLKMatrix4Scale(_modelViewMatrix, _sx, _sy, _sz);
    
    // 位移
    _modelViewMatrix = GLKMatrix4Translate(_modelViewMatrix, _tx, _ty, _tz);
    
    // 旋转
    _modelViewMatrix = GLKMatrix4Rotate(_modelViewMatrix, GLKMathDegreesToRadians(_rx + _degree), 1, 0, 0);
    _modelViewMatrix = GLKMatrix4Rotate(_modelViewMatrix, GLKMathDegreesToRadians(_ry + _degree), 0, 1, 0);
    _modelViewMatrix = GLKMatrix4Rotate(_modelViewMatrix, GLKMathDegreesToRadians(_rz + _degree), 0, 0, 1);
    
    _modelViewMatrix = GLKMatrix4Multiply(positionMatrix, _modelViewMatrix);
    
//        _degree++;
    
    if (_degree >= 360) {
        
        _degree = _degree % 360;
    }
}

- (void)draw {
    
}

- (void)free {
    
}

@end
