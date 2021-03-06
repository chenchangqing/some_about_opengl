//
//  UVSquare.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVSquare.h"
#import "UIColor+HEX.h"
#import "MacroDefinition.h"

/**
 *  顶点数据
 */
static const GLfloat g_position_buffer_data[] = {
    -1.0f, -1.0f, 0.0f,
    1.0f, -1.0f, 0.0f,
    1.0f,  1.0f, 0.0f,
    -1.0f,  1.0f, 0.0f
};
static const GLfloat g_texture_buffer_data[] = {
   0.0f, 0.0f,
    1.0f, 0.0f,
    1.0f,  1.0f,
    -0.0f, 1.0f
};

static const GLushort g_element_buffer_data[] = {
    0,1,2,
    2,3,0
};

@interface UVSquare() {
    
}

@end

@implementation UVSquare

- (void)buildProgram {
    
    self.program = [[OpenGLProgram alloc] initWithVertexFilepath:@"UVSquare" fragmentShaderFilename:@"UVSquare"];
    
    [self.program addAttribute:kAPositionName];
    [self.program addAttribute:kAColorName];
    [self.program addAttribute:kATextureCoordName];
    
    attributes[ATTRIBUTE_POSITION] = [self.program attributeIndex:kAPositionName];
    attributes[ATTRIBUTE_COLOR] = [self.program attributeIndex:kAColorName];
    attributes[ATTRIBUTE_TEXCOORD] = [self.program attributeIndex:kATextureCoordName];
    
    [self.program link];
    
    uniforms[UNIFORM_MVP] = [self.program uniformIndex:kUMVPName];
    uniforms[UNIFORM_SAMPLER] = [self.program uniformIndex:kUBGSamplerName];
}

- (void)setupPositionBuffer:(GLuint*)buffer positonAttrib:(GLuint)attrib {
    
    glGenBuffers(1, buffer);
    glBindBuffer(GL_ARRAY_BUFFER, *buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_position_buffer_data), g_position_buffer_data, GL_STATIC_DRAW);
    glEnableVertexAttribArray(attrib);
    glVertexAttribPointer(attrib, 3, GL_FLOAT, GL_FALSE, 0, 0);
}
- (void)setupTextureBuffer:(GLuint*)buffer textureAttrib:(GLuint)attrib {
    
    glGenBuffers(1, buffer);
    glBindBuffer(GL_ARRAY_BUFFER, *buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_texture_buffer_data), g_texture_buffer_data, GL_STATIC_DRAW);
    glEnableVertexAttribArray(attrib);
    glVertexAttribPointer(attrib, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 2, NULL);
}
- (void)setupElementBuffer:(GLuint*)buffer elementCount:(GLsizei *)count {
    
    glGenBuffers(1, buffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, *buffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 6 * sizeof(GLushort), g_element_buffer_data, GL_STATIC_DRAW);
    
    *count = 6;
}
- (void)updateTextureInfo:(GLuint*)textureIndex {
    
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"Frameworks/VRPlayer.framework/VRPlayer.bundle/earth" ofType:@"png"];
    *textureIndex =  [GLKTextureLoader textureWithContentsOfFile:imgPath options:nil error:nil].name;
}

- (void)updateWithMVP: (GLKMatrix4)mvp {
    [super updateWithMVP:mvp];
    
}

- (void)draw {
    [super draw];
}

- (void)free {
    [super free];
}

@end
