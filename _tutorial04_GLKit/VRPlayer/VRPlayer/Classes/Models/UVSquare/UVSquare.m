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
#import "UIColor+HEX.h"

/**
 *  顶点数据
 */
static const GLfloat g_vertex_buffer_data[] = {
    -1.0f, -1.0f, 0.0f,
    1.0f, -1.0f, 0.0f,
    1.0f,  1.0f, 0.0f,
    -1.0f,  1.0f, 0.0f
};

static const GLushort g_element_buffer_data[] = {
    0,1,2,
    2,3,0
};

@interface UVSquare() {
    
    GLfloat *g_color_buffer_data;
}

@property (nonatomic, assign) GLuint program;

@property (nonatomic, assign) GLuint vertexArray;

@property (nonatomic, assign) GLuint positionBuffer;
@property (nonatomic, assign) GLuint colorBuffer;
@property (nonatomic, assign) GLuint elementsBuffer;

@property (nonatomic, assign) GLuint attribVertex;
@property (nonatomic, assign) GLuint attribColor;

@property (nonatomic, assign) GLint  uniformMVP;

@end

@implementation UVSquare

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    
    super.backgroundColor = backgroundColor;
    
    GLfloat red = ((NSNumber *)[super.backgroundColor.RGBDictionary objectForKey:@"R"]).floatValue;
    GLfloat green = ((NSNumber *)[super.backgroundColor.RGBDictionary objectForKey:@"G"]).floatValue;
    GLfloat blue = ((NSNumber *)[super.backgroundColor.RGBDictionary objectForKey:@"B"]).floatValue;
    GLfloat alpha = ((NSNumber *)[super.backgroundColor.RGBDictionary objectForKey:@"A"]).floatValue;
    
    // NSLog(@"R:%f,G:%f,B:%f,A:%f",red,green,blue,alpha);
    
    GLfloat rgba[4] = {
        red,green,blue,alpha
    };
    
    g_color_buffer_data = (float*) malloc(sizeof(float) * 24);
    for (int i=0; i<24; i++) {
        
        g_color_buffer_data[i] = rgba[i%4];
    }
    
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
    
    glGenBuffers(1, &_positionBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _positionBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_vertex_buffer_data), g_vertex_buffer_data, GL_STATIC_DRAW);
    glEnableVertexAttribArray(_attribVertex);
    glVertexAttribPointer(_attribVertex, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    glGenBuffers(1, &_colorBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
    glBufferData(GL_ARRAY_BUFFER, 24 * sizeof(GLfloat), g_color_buffer_data, GL_STATIC_DRAW);
    glEnableVertexAttribArray(_attribColor);
    glVertexAttribPointer(_attribColor, 4, GL_FLOAT, GL_FALSE, 0, 0);
    
    glGenBuffers(1, &_elementsBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _elementsBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(g_element_buffer_data), g_element_buffer_data, GL_STATIC_DRAW);
    
    glBindVertexArrayOES(0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
}

- (void)updateWithMVP: (GLKMatrix4)mvp {
    [super updateWithMVP:mvp];
    
}

- (void)draw {
    [super draw];
    
    glBindVertexArrayOES(_vertexArray);
    
    glUseProgram(_program);
    glUniformMatrix4fv(_uniformMVP, 1, 0, self.mvp.m);
    glDrawElements(GL_TRIANGLES, sizeof(g_element_buffer_data), GL_UNSIGNED_SHORT, 0);
}

- (void)free {
    [super free];
    
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
