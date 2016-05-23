//
//  UVSquare.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVSquare.h"
#import "UVShellLoader.h"
#import <OpenGLES/ES2/glext.h>

/**
 *  顶点数据
 */
static const GLfloat g_vertex_buffer_data[] = {
    -1.0f, -1.0f, -0.0f,
    1.0f, -1.0f, -0.0f,
    1.0f,  1.0f, -0.0f,
    
    1.0f,  1.0f, -0.0f,
    -1.0f,  1.0f, -0.0f,
    -1.0f, -1.0f, -0.0f
};

/**
 *  颜色数据
 */
static const GLfloat g_color_buffer_data[] = {
    1, 0, 0, 1,
    0, 1, 0, 1,
    0, 0, 1, 1,
    1, 0, 0, 1,
    0, 1, 0, 1,
    0, 0, 1, 1
};

@interface UVSquare() {
    
}

@property (nonatomic, assign) GLuint program;

@property (nonatomic, assign) GLuint vertexArray;

@property (nonatomic, assign) GLuint vertexBuffer;
@property (nonatomic, assign) GLuint colorBuffer;

@property (nonatomic, assign) GLuint attribVertex;
@property (nonatomic, assign) GLuint attribColor;

@property (nonatomic, assign) GLint  uniformMVP;

@end

@implementation UVSquare

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setup {
    [super setup];
    
    _uniformMVP     = 0;
    _attribColor    = 0;
    _attribVertex   = 1;
    
    _program = [UVShellLoader loadSphereShadersWithVertexShaderString:@"SquareShader" fragmentShaderString:@"SquareShader" andAttribLocations:
                @[@{@"index":[NSNumber numberWithUnsignedInt:_attribVertex],@"name":@"position"},
                  @{@"index":[NSNumber numberWithUnsignedInt:_attribColor],@"name":@"color"}]];
    _uniformMVP = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_vertex_buffer_data), g_vertex_buffer_data, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_colorBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_color_buffer_data), g_color_buffer_data, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(_attribColor);
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
    glVertexAttribPointer(_attribColor, 4, GL_FLOAT, GL_FALSE, 0, 0);
    
    glEnableVertexAttribArray(_attribVertex);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glVertexAttribPointer(_attribVertex, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    glBindVertexArrayOES(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (void)updateWithPMatrix: (GLKMatrix4) projectionMatrix {
    [super updateWithPMatrix:projectionMatrix];
    
}

- (void)draw {
    
    glBindVertexArrayOES(_vertexArray);
    
    glUseProgram(_program);
    glUniformMatrix4fv(_uniformMVP, 1, 0, super.mvp.m);
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (void)free {
    [super free];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_colorBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

@end
