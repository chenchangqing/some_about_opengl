//
//  UVModel.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVModel.h"
#import "UVShellLoader.h"

@interface UVModel()  {
    
    GLsizei element_count;
}

@property (nonatomic, assign) GLuint program;

@property (nonatomic, assign) GLuint vertexArray;

@property (nonatomic, assign) GLuint positionBuffer;
@property (nonatomic, assign) GLuint colorBuffer;
@property (nonatomic, assign) GLuint elementsBuffer;

@property (nonatomic, assign) GLuint positionAttrib;
@property (nonatomic, assign) GLuint colorAttrib;

@property (nonatomic, assign) GLint  mvpUniform;

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
    }
    return self;
}

- (void)dealloc
{
    [self free];
}

- (void)setup {
    
    _mvpUniform     = 0;
    _colorAttrib    = 0;
    _positionAttrib   = 1;
    
    _program = [UVShellLoader loadSphereShadersWithVertexShaderString:@"SquareShader" fragmentShaderString:@"SquareShader" andAttribLocations:
                @[@{@"index":[NSNumber numberWithUnsignedInt:_positionAttrib],@"name":@"position"},
                  @{@"index":[NSNumber numberWithUnsignedInt:_colorAttrib],@"name":@"color"}]];
    _mvpUniform = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    
    GLfloat *g_position_buffer_data;
    GLfloat *g_color_buffer_data;
    GLfloat *g_element_buffer_data;
    
    GLsizei vertex_count = 0;
    GLsizei color_count = 0;
    element_count = 0;
    
    [self setupVertexCount:&vertex_count vertexData:&g_position_buffer_data];
    [self setupColorCount:&color_count colorData:&g_color_buffer_data];
    [self setupElementCount:&element_count elementData:&g_element_buffer_data];
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_positionBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _positionBuffer);
    glBufferData(GL_ARRAY_BUFFER, vertex_count * sizeof(GLfloat), g_position_buffer_data, GL_STATIC_DRAW);
    glEnableVertexAttribArray(_positionAttrib);
    glVertexAttribPointer(_positionAttrib, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    glGenBuffers(1, &_colorBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
    glBufferData(GL_ARRAY_BUFFER, color_count * sizeof(GLfloat), g_color_buffer_data, GL_STATIC_DRAW);
    glEnableVertexAttribArray(_colorAttrib);
    glVertexAttribPointer(_colorAttrib, 4, GL_FLOAT, GL_FALSE, 0, 0);
    
    glGenBuffers(1, &_elementsBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _elementsBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, element_count * sizeof(GLushort), g_element_buffer_data, GL_STATIC_DRAW);
    
    glBindVertexArrayOES(0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (void)setupVertexCount:(int *)count vertexData:(GLfloat **)data {
    NSAssert(NO, @"请提供顶点数据");
}

- (void)setupColorCount:(int *)count colorData:(GLfloat **)data {
    NSAssert(NO, @"请提供颜色数据");
}

- (void)setupElementCount:(int *)count elementData:(GLfloat **)data {
    NSAssert(NO, @"请提供索引数据");
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
    
    glBindVertexArrayOES(_vertexArray);
    
    glUseProgram(_program);
    glUniformMatrix4fv(_mvpUniform, 1, 0, self.mvp.m);
    
    if (element_count != 0) {
        
        glDrawElements(GL_TRIANGLES, element_count, GL_UNSIGNED_SHORT, 0);
    }
}

- (void)free {
    
    glDeleteBuffers(1, &_positionBuffer);
    glDeleteBuffers(1, &_colorBuffer);
    glDeleteBuffers(1, &_elementsBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

@end
