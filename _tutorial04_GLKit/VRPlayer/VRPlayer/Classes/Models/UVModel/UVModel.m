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

@property (nonatomic, assign) GLuint programIndex;

@property (nonatomic, assign) GLuint vertexArrayIndex;

@property (nonatomic, assign) GLuint positionBuffer;
@property (nonatomic, assign) GLuint colorBuffer;
@property (nonatomic, assign) GLuint texCoordBuffer;
@property (nonatomic, assign) GLuint elementsBuffer;

@property (nonatomic, assign) GLuint positionAttrib;
@property (nonatomic, assign) GLuint colorAttrib;
@property (nonatomic, assign) GLuint texCoordAttrib;

@property (nonatomic, assign) GLint  mvpUniform;
@property (nonatomic, assign) GLint  samplerUniform;

@property (nonatomic, strong) GLKTextureInfo *textureInfo;

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
    
    _mvpUniform     = 0;
    _positionAttrib   = 1;
    _colorAttrib    = 2;
    
    _programIndex = [UVShellLoader loadSphereShadersWithVertexShaderString:@"UVModelShader" fragmentShaderString:@"UVModelShader" callback:^(GLuint programIndex){
                      
          glBindAttribLocation(programIndex, _positionAttrib, kAPositionName.UTF8String);
          glBindAttribLocation(programIndex, _colorAttrib, kAColorName.UTF8String);
          glBindAttribLocation(programIndex, _texCoordAttrib, kATextureCoordName.UTF8String);
    }];
    _mvpUniform = glGetUniformLocation(_programIndex, kUMVPName.UTF8String);
    _samplerUniform = glGetUniformLocation(_programIndex, kUBGSamplerName.UTF8String);
    
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"Frameworks/VRPlayer.framework/VRPlayer.bundle/ribing" ofType:@"jpg"];
    _textureInfo =  [GLKTextureLoader textureWithContentsOfFile:imgPath options:nil error:nil];
    
    element_count = 0;
    
    glGenVertexArraysOES(1, &_vertexArrayIndex);
    glBindVertexArrayOES(_vertexArrayIndex);
    
    [self setupPositionBuffer:&_positionBuffer positonAttrib:_positionAttrib];
    [self setupTextureBuffer:&_texCoordBuffer textureAttrib:_texCoordAttrib];
    [self setupElementBuffer:&_elementsBuffer elementCount:&element_count];
    [self setupColorBuffer:&_colorBuffer colorAttrib:_colorAttrib];
    
    glBindVertexArrayOES(0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (void)setupPositionBuffer:(GLuint*)buffer positonAttrib:(GLuint)attrib {
    NSAssert(NO, @"请提供顶点数据");
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
- (void)setupTextureBuffer:(GLuint*)buffer textureAttrib:(GLuint)attrib {
    NSAssert(NO, @"请提供纹理数据");
}
- (void)setupElementBuffer:(GLuint*)buffer elementCount:(GLsizei *)count {
    NSAssert(NO, @"请提供索引数据");
}
- (void)updateTextureInfo:(GLKTextureInfo *)textureInfo {
    NSAssert(NO, @"请提供纹理数据2");
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
    
    glBindVertexArrayOES(_vertexArrayIndex);
    
    glUseProgram(_programIndex);
    glUniformMatrix4fv(_mvpUniform, 1, 0, self.mvp.m);
    glUniform1i(_samplerUniform, 0);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.textureInfo.name);
    
    if (element_count != 0) {
        
        glDrawElements(GL_TRIANGLES, element_count, GL_UNSIGNED_SHORT, 0);
    }
}

- (void)free {
    
    glDeleteBuffers(1, &_positionBuffer);
    glDeleteBuffers(1, &_colorBuffer);
    glDeleteBuffers(1, &_texCoordBuffer);
    glDeleteBuffers(1, &_elementsBuffer);
    glDeleteVertexArraysOES(1, &_vertexArrayIndex);
    
    if (_programIndex) {
        glDeleteProgram(_programIndex);
        _programIndex = 0;
    }
}

@end
