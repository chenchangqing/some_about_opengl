//
//  UVSphere.m
//  Pods
//
//  Created by green on 16/6/13.
//
//

#import "UVSphere.h"
#import "UVShellLoader.h"
#import <OpenGLES/ES2/glext.h>

@interface UVSphere() {
    
}

@property (nonatomic, assign) GLuint program;

@property (nonatomic, assign) GLuint vertexArray;

@property (nonatomic, assign) GLuint positionBuffer;
@property (nonatomic, assign) GLuint texCoordBuffer;
@property (nonatomic, assign) GLuint elementsBuffer;

@property (nonatomic, assign) GLuint positionAttrib;
@property (nonatomic, assign) GLuint texCoordAttrib;

@property (nonatomic, assign) GLint  mvpUniform;
@property (nonatomic, assign) GLint  samplerUniform;

@property (nonatomic, strong) GLKTextureInfo *textureInfo;

@property (nonatomic,assign) GLsizei triangleCount;

@end

@implementation UVSphere

- (void)setup {
    [super setup];
    
    _mvpUniform       = 0;
    _positionAttrib   = 0;
    _texCoordAttrib   = 1;
    
    _program = [UVShellLoader loadSphereShadersWithVertexShaderString:@"SphereShader" fragmentShaderString:@"SphereShader" andAttribLocations:
                @[@{@"index":[NSNumber numberWithUnsignedInt:_positionAttrib],@"name":@"a_position"},
                  @{@"index":[NSNumber numberWithUnsignedInt:_texCoordAttrib],@"name":@"a_textureCoord"}]];
    _mvpUniform = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    _samplerUniform = glGetUniformLocation(_program, "imageSampler");
    
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"Frameworks/VRPlayer.framework/VRPlayer.bundle/ribing" ofType:@"jpg"];
    _textureInfo =  [GLKTextureLoader textureWithContentsOfFile:imgPath options:nil error:nil];
    
    [self setupSphereData];
}

- (void)setupSphereData {
    int segW = 48;// 宽度分块数目
    int segH = 48;// 高度分块数目
    int segW1 = segW + 1;// 宽度分块顶点数目
    int segH1 = segH + 1;// 高度分块顶点数目
    // 顶点坐标
    int vertexSize = 3;//一个点x/y/z三个坐标
    int vertexCount = segW1 * segH1 * vertexSize;
    float *vertices = (float*) malloc(sizeof(float) * vertexCount);
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
            vertices[kk++] = xx;
            vertices[kk++] = yy;
            vertices[kk++] = zz;
        }
    }
    // 纹理坐标
    int textureCount = segW1 * segH1 * 2;
    float *texcoords = (float*) malloc(sizeof(float) *textureCount);
    kk = 0;
    for (int j = 0; j < segH1; j++) {
        double vj = 1.0 * j / segH;
        for (int i = 0; i < segW1; i++) {
            double ui = 1.0 * i / segW;
            texcoords[kk++] = (float) ui;
            texcoords[kk++] = (float) vj;//跟android相比，纹理v坐标上下颠倒，因为坐标系问题
        }
    }
    
    // 三角形编号
    self.triangleCount = segW * segH * 2 * 3;//三角形总数目
    unsigned short *indices = (unsigned short *) malloc(sizeof(unsigned short) * self.triangleCount);
    kk = 0;
    for (int j = 0; j < segH; j++) {
        int m = j * segW1;
        int n = m + segW1;
        for (int i = 0; i < segW; i++) {
            int h0 = i + m;
            int h1 = h0 + 1;
            int h3 = i + n;
            int h2 = h3 + 1;
            indices[kk++] = (short) h0;
            indices[kk++] = (short) h2;
            indices[kk++] = (short) h1;
            
            indices[kk++] = (short) h0;
            indices[kk++] = (short) h3;
            indices[kk++] = (short) h2;
        }
    }
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_positionBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _positionBuffer);
    glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(GLfloat), vertices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(_positionAttrib);
    glVertexAttribPointer(_positionAttrib, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 3, NULL);
    
    glGenBuffers(1, &_texCoordBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _texCoordBuffer);
    glBufferData(GL_ARRAY_BUFFER, textureCount * sizeof(GLfloat), texcoords, GL_STATIC_DRAW);
    glEnableVertexAttribArray(_texCoordAttrib);
    glVertexAttribPointer(_texCoordAttrib, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 2, NULL);
    
    glGenBuffers(1, &_elementsBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _elementsBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, self.triangleCount * sizeof(GLushort), indices, GL_STATIC_DRAW);
    
    glBindVertexArrayOES(0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    //释放
    free(vertices);
    free(texcoords);
    free(indices);
}

- (void)updateWithMVP: (GLKMatrix4)mvp {
    [super updateWithMVP:mvp];
    
}

- (void)draw {
    [super draw];
    
    glBindVertexArrayOES(_vertexArray);
    
    glUseProgram(_program);
    glUniformMatrix4fv(_mvpUniform, 1, 0, self.mvp.m);
    glUniform1i(_samplerUniform, 0);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.textureInfo.name);
    glDrawElements(GL_TRIANGLES, self.triangleCount, GL_UNSIGNED_SHORT, 0);
}

- (void)free {
    [super free];
    
    glDeleteBuffers(1, &_positionBuffer);
    glDeleteBuffers(1, &_texCoordBuffer);
    glDeleteBuffers(1, &_elementsBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

@end
