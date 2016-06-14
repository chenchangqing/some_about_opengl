//
//  UVSphere.m
//  Pods
//
//  Created by green on 16/6/13.
//
//

#import "UVSphere.h"

@interface UVSphere() {
    
}

@end

@implementation UVSphere

- (void)setupPositionBuffer:(GLuint*)buffer positonAttrib:(GLuint)attrib {
    
    int segW = 48;// 宽度分块数目
    int segH = 48;// 高度分块数目
    int segW1 = segW + 1;// 宽度分块顶点数目
    int segH1 = segH + 1;// 高度分块顶点数目
    
    // 顶点坐标
    int vertexSize = 3;//一个点x/y/z三个坐标
    int vertexCount = segW1 * segH1 * vertexSize;
    float *g_position_buffer_data = (float*) malloc(sizeof(float) * vertexCount);
    int kk = 0;
    for (int j = 0; j < segH1; j++) {
        double vj = 1.0 * j / segH;
        double deltT = (0.5 - vj) * M_PI;
        double cosdeltT = cos(deltT);
        double sindeltT = sin(deltT);
        for (int i = 0; i < segW1; i++) {
            double ui = 2.0 * i / segW;
            double deltP = -ui * M_PI;
            float zz = (float) (cos(deltP) * cosdeltT);
            float xx = (float) (sin(deltP) * cosdeltT);
            float yy = (float) sindeltT;
            g_position_buffer_data[kk++] = xx;
            g_position_buffer_data[kk++] = yy;
            g_position_buffer_data[kk++] = zz;
        }
    }
    
    glGenBuffers(1, buffer);
    glBindBuffer(GL_ARRAY_BUFFER, *buffer);
    glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(GLfloat), g_position_buffer_data, GL_STATIC_DRAW);
    glEnableVertexAttribArray(attrib);
    glVertexAttribPointer(attrib, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 3, 0);
}
- (void)setupColorBuffer:(GLuint*)buffer colorAttrib:(GLuint)attrib {
    
    GLfloat red = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"R"]).floatValue;
    GLfloat green = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"G"]).floatValue;
    GLfloat blue = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"B"]).floatValue;
    GLfloat alpha = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"A"]).floatValue;
    
    GLfloat rgba[4] = {
        red,green,blue,alpha
    };
    
    int segW = 48;// 宽度分块数目
    int segH = 48;// 高度分块数目
    int segW1 = segW + 1;// 宽度分块顶点数目
    int segH1 = segH + 1;// 高度分块顶点数目
    
    // 纹理坐标
    int textureCount = segW1 * segH1 * 4;
    float *g_color_buffer_data = (float*) malloc(sizeof(float) *textureCount);
    
    for (int i=0; i<textureCount; i++) {
        
        g_color_buffer_data[i] = rgba[i%4];
    }
    
    glGenBuffers(1, buffer);
    glBindBuffer(GL_ARRAY_BUFFER, *buffer);
    glBufferData(GL_ARRAY_BUFFER, textureCount * sizeof(GLfloat), g_color_buffer_data, GL_STATIC_DRAW);
    glEnableVertexAttribArray(attrib);
    glVertexAttribPointer(attrib, 4, GL_FLOAT, GL_FALSE, 0, 0);
}
- (void)setupTextureBuffer:(GLuint*)buffer textureAttrib:(GLuint)attrib {
    
    int segW = 48;// 宽度分块数目
    int segH = 48;// 高度分块数目
    int segW1 = segW + 1;// 宽度分块顶点数目
    int segH1 = segH + 1;// 高度分块顶点数目
    
    // 纹理坐标
    int textureCount = segW1 * segH1 * 2;
    float *g_texture_buffer_data = (float*) malloc(sizeof(float) *textureCount);
    int kk = 0;
    for (int j = 0; j < segH1; j++) {
        double vj = 1.0 * j / segH;
        for (int i = 0; i < segW1; i++) {
            double ui = 1.0 * i / segW;
            g_texture_buffer_data[kk++] = (float) ui;
            g_texture_buffer_data[kk++] = (float) vj;//跟android相比，纹理v坐标上下颠倒，因为坐标系问题
        }
    }
    
    glGenBuffers(1, buffer);
    glBindBuffer(GL_ARRAY_BUFFER, *buffer);
    glBufferData(GL_ARRAY_BUFFER, textureCount * sizeof(GLfloat), g_texture_buffer_data, GL_STATIC_DRAW);
    glEnableVertexAttribArray(attrib);
    glVertexAttribPointer(attrib, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 2, NULL);
}
- (void)setupElementBuffer:(GLuint*)buffer elementCount:(GLsizei *)count {
    
    int segW = 48;// 宽度分块数目
    int segH = 48;// 高度分块数目
    int segW1 = segW + 1;// 宽度分块顶点数目
    int segH1 = segH + 1;// 高度分块顶点数目
    
    // 三角形编号
    int triangleCount = segW * segH * 2 * 3;//三角形总数目
    unsigned short *g_element_buffer_data = (unsigned short *) malloc(sizeof(unsigned short) * triangleCount);
    int kk = 0;
    for (int j = 0; j < segH; j++) {
        int m = j * segW1;
        int n = m + segW1;
        for (int i = 0; i < segW; i++) {
            int h0 = i + m;
            int h1 = h0 + 1;
            int h3 = i + n;
            int h2 = h3 + 1;
            g_element_buffer_data[kk++] = (short) h0;
            g_element_buffer_data[kk++] = (short) h2;
            g_element_buffer_data[kk++] = (short) h1;
            
            g_element_buffer_data[kk++] = (short) h0;
            g_element_buffer_data[kk++] = (short) h3;
            g_element_buffer_data[kk++] = (short) h2;
        }
    }
    
    glGenBuffers(1, buffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, *buffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, triangleCount * sizeof(GLushort), g_element_buffer_data, GL_STATIC_DRAW);
    
    *count = triangleCount;
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
