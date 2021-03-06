//
//  UVModel.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVModel.h"
#import "UVShellLoader.h"
#import "MacroDefinition.h"
#import "UIColor+HEX.h"

@interface UVModel()  {
    
    GLsizei element_count;
}

@property (nonatomic, assign) GLuint vertexArrayID;
@property (nonatomic, assign) GLuint texCoordIndex;

@property (nonatomic, assign) GLuint positionBuffer;
@property (nonatomic, assign) GLuint colorBuffer;
@property (nonatomic, assign) GLuint texCoordBuffer;
@property (nonatomic, assign) GLuint elementsBuffer;

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
        
        _backgroundColor = RandColor;
        
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [self free];
}

- (void)setup {
    
    [self buildProgram];
    
    if (!_program) {
        return;
    }
    
    [self updateTextureInfo:&_texCoordIndex];
    
    glGenVertexArraysOES(1, &_vertexArrayID);
    glBindVertexArrayOES(_vertexArrayID);
    
    [self setupPositionBuffer:&_positionBuffer positonAttrib:attributes[ATTRIBUTE_POSITION]];
    [self setupTextureBuffer:&_texCoordBuffer textureAttrib:attributes[ATTRIBUTE_TEXCOORD]];
    [self setupElementBuffer:&_elementsBuffer elementCount:&element_count];
    [self setupColorBuffer:&_colorBuffer colorAttrib:attributes[ATTRIBUTE_COLOR]];
    
    [_program use];
}

- (void)buildProgram {
    NSAssert(NO, @"请提供Program");
}

- (void)setupPositionBuffer:(GLuint*)buffer positonAttrib:(GLuint)attrib {
    NSAssert(NO, @"请提供顶点数据");
}
- (void)setupTextureBuffer:(GLuint*)buffer textureAttrib:(GLuint)attrib {
    NSAssert(NO, @"请提供纹理数据");
}
- (void)setupElementBuffer:(GLuint*)buffer elementCount:(GLsizei *)count {
    NSAssert(NO, @"请提供索引数据");
}
- (void)updateTextureInfo:(GLuint*)textureIndex {
    NSAssert(NO, @"请提供纹理数据2");
}
- (void)setupColorBuffer:(GLuint*)buffer colorAttrib:(GLuint)attrib {
    
    GLfloat *g_color_buffer_data = (float*) malloc(sizeof(float) * element_count*4);
    
    GLfloat red = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"R"]).floatValue;
    GLfloat green = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"G"]).floatValue;
    GLfloat blue = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"B"]).floatValue;
    GLfloat alpha = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"A"]).floatValue;
    
    GLfloat rgba[4] = {
        red,green,blue,alpha
    };
    for (int i=0; i<element_count*4; i++) {
        
        g_color_buffer_data[i] = rgba[i%4];
    }
    
    glGenBuffers(1, buffer);
    glBindBuffer(GL_ARRAY_BUFFER, *buffer);
    glBufferData(GL_ARRAY_BUFFER, element_count*4 * sizeof(GLfloat), g_color_buffer_data, GL_STATIC_DRAW);
    glEnableVertexAttribArray(attrib);
    glVertexAttribPointer(attrib, 4, GL_FLOAT, GL_FALSE, 0, 0);
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
    
    if (!_program) {
        return;
    }
    
    [_program use];
    
    glBindVertexArrayOES(_vertexArrayID);
    glUniformMatrix4fv(uniforms[UNIFORM_MVP], 1, 0, self.mvp.m);
    glUniform1i(uniforms[UNIFORM_SAMPLER], 0);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texCoordIndex);
    
    if (element_count != 0) {
        
        glDrawElements(GL_TRIANGLES, element_count, GL_UNSIGNED_SHORT, 0);
    }
}

- (void)free {
    
    glDeleteBuffers(1, &_positionBuffer);
    glDeleteBuffers(1, &_colorBuffer);
    glDeleteBuffers(1, &_texCoordBuffer);
    glDeleteBuffers(1, &_elementsBuffer);
    glDeleteVertexArraysOES(1, &_vertexArrayID);
    
    _program = nil;
}

@end
