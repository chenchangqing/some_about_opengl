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
    }
    return self;
}

- (void)dealloc
{
    [self free];
}

- (void)setup {
    
}

- (void)drawWithPMatrix: (GLKMatrix4) projectionMatrix andConfig: (UVModelConfig *) config {
    
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -3.0f);
    
    // 位置
    // baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, GLKMathDegreesToRadians(config.pitch), 1, 0, 0);
    baseModelViewMatrix = GLKMatrix4Translate(baseModelViewMatrix, 0, sin(config.pitch), 0);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, GLKMathDegreesToRadians(config.yaw + _degree), 0, 1, 0);
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(baseModelViewMatrix, 0, 0, 0);
    
    // 缩放
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, config.sx, config.sy, config.sz);
    
    // 位移
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, config.tx, config.ty, config.tz);
    
    // 旋转
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(config.rx + _degree), 1, 0, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(config.ry + _degree), 0, 1, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(config.rz + _degree), 0, 0, 1);
    
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    // mvp
    _mvp = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
//    _degree++;
    
    
    if (_degree >= 360) {
        
        _degree = _degree % 360;
    }
}

- (void)free {
    
}

@end
