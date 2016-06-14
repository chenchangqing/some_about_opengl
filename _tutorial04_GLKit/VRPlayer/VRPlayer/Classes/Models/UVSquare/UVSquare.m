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

- (void)setupPositionBuffer:(GLuint*)buffer positonAttrib:(GLuint)attrib {
    
    glGenBuffers(1, buffer);
    glBindBuffer(GL_ARRAY_BUFFER, *buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_position_buffer_data), g_position_buffer_data, GL_STATIC_DRAW);
    glEnableVertexAttribArray(attrib);
    glVertexAttribPointer(attrib, 3, GL_FLOAT, GL_FALSE, 0, 0);
}
- (void)setupColorBuffer:(GLuint*)buffer colorAttrib:(GLuint)attrib {
    
    GLfloat *g_color_buffer_data = (float*) malloc(sizeof(float) * 24);
    
    GLfloat red = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"R"]).floatValue;
    GLfloat green = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"G"]).floatValue;
    GLfloat blue = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"B"]).floatValue;
    GLfloat alpha = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"A"]).floatValue;
    
    GLfloat rgba[4] = {
        red,green,blue,alpha
    };
    for (int i=0; i<24; i++) {
        
        g_color_buffer_data[i] = rgba[i%4];
    }
    
    glGenBuffers(1, buffer);
    glBindBuffer(GL_ARRAY_BUFFER, *buffer);
    glBufferData(GL_ARRAY_BUFFER, 24 * sizeof(GLfloat), g_color_buffer_data, GL_STATIC_DRAW);
    glEnableVertexAttribArray(attrib);
    glVertexAttribPointer(attrib, 4, GL_FLOAT, GL_FALSE, 0, 0);
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
- (void)updateTextureInfo:(GLKTextureInfo *)textureInfo {
    
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"Frameworks/VRPlayer.framework/VRPlayer.bundle/ribing" ofType:@"jpg"];
    textureInfo =  [GLKTextureLoader textureWithContentsOfFile:imgPath options:nil error:nil];
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
