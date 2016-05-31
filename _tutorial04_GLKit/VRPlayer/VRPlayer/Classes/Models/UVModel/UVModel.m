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
        
        _projectionMatrix = GLKMatrix4Identity;
        _modelViewMatrix = GLKMatrix4Identity;
        
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

- (void)updateWithProjectionMatrix: (GLKMatrix4)projectionMatrix {
    
//    GLKMatrix4 mtr = GLKMatrix4MakeTranslation(0, 0, 1);
//    
//    /**
//     *  模型矩阵
//     */
//    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
//    
//    modelMatrix = GLKMatrix4Scale(modelMatrix, _sx, _sy, _sz);// 缩放
//    
//    modelMatrix = GLKMatrix4Translate(modelMatrix, _tx, _ty, _tz);// 位移
//    
//    modelMatrix = GLKMatrix4Rotate(modelMatrix, GLKMathDegreesToRadians(_rx), 1.0f, 0.0f, 0.0f);
//    modelMatrix = GLKMatrix4Rotate(modelMatrix, GLKMathDegreesToRadians(_ry), 0.0f, 1.0f, 0.0f);
//    modelMatrix = GLKMatrix4Rotate(modelMatrix, GLKMathDegreesToRadians(_rz), 0.0f, 0.0f, 1.0f);// 旋转
//    
//    /**
//     *  观察矩阵
//     */
//    GLKMatrix4 viewMatrix = GLKMatrix4Identity;
//    
//    viewMatrix = GLKMatrix4Rotate(viewMatrix, GLKMathDegreesToRadians(_yaw + _degree), 0.0f, 1.0f, 0.0f);
//    viewMatrix = GLKMatrix4Rotate(viewMatrix, GLKMathDegreesToRadians(_pitch), 1.0f, 0.0f, 0.0f);
//    
//    /**
//     *  投影矩阵
//     */
//    _projectionMatrix = projectionMatrix;
//    _modelViewMatrix = GLKMatrix4Multiply(modelMatrix, viewMatrix);
    
    // 初始位置(先绕y轴旋转,在绕x轴旋转)
    GLKMatrix4 positionMatrix = GLKMatrix4Identity;
    positionMatrix = GLKMatrix4Rotate(positionMatrix, GLKMathDegreesToRadians(_yaw + _degree), 0.0f, 1.0f, 0.0f);
    positionMatrix = GLKMatrix4Rotate(positionMatrix, GLKMathDegreesToRadians(_pitch), 1.0f, 0.0f, 0.0f);
    
    _projectionMatrix = projectionMatrix;
    _modelViewMatrix = GLKMatrix4Identity;
    
    // 缩放
    _modelViewMatrix = GLKMatrix4Scale(_modelViewMatrix, _sx, _sy, _sz);
    
    // 位移
    _modelViewMatrix = GLKMatrix4Translate(_modelViewMatrix, _tx, _ty, _tz);
    
    // 旋转
    _modelViewMatrix = GLKMatrix4Rotate(_modelViewMatrix, GLKMathDegreesToRadians(_rx), 1.0f, 0.0f, 0.0f);
    _modelViewMatrix = GLKMatrix4Rotate(_modelViewMatrix, GLKMathDegreesToRadians(_ry), 0.0f, 1.0f, 0.0f);
    _modelViewMatrix = GLKMatrix4Rotate(_modelViewMatrix, GLKMathDegreesToRadians(_rz), 0.0f, 0.0f, 1.0f);
    
    _modelViewMatrix = GLKMatrix4Multiply(positionMatrix, _modelViewMatrix);
    
//        _degree++;
    
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
