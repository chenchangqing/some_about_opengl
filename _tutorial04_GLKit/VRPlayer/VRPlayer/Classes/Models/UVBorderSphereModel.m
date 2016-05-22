//
//  UVBorderSphereModel.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVBorderSphereModel.h"
#import "UVShellLoader.h"
#import <OpenGLES/ES2/glext.h>

@interface UVBorderSphereModel() {
    
}

@property (nonatomic, assign) GLuint program;
@property (nonatomic, assign) GLuint vertexArray;
@property (nonatomic, assign) GLuint vertexBuffer;
@property (nonatomic, assign) GLuint attribVertex;
@property (nonatomic, assign) GLint  uniformMVP;
@property (nonatomic, assign) int    segW;

@end

@implementation UVBorderSphereModel

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _segW = 48;
        
    }
    return self;
}

- (void)dealloc
{
    [self free];
}

- (void)free {
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

/**
 *  球网格
 */
-(void)createBorderSphere {
    
    _program = [UVShellLoader loadSphereShadersWithVertexShaderString:@"BorderSphere" fragmentShaderString:@"BorderSphere" andAttribLocations:
                @[@{@"index":[NSNumber numberWithUnsignedInt:_attribVertex],@"name":@"position"}]];
    _uniformMVP = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    
    int vertexSize = 3;
    
    int segW1 = _segW + 1;
    int pointCount = (segW1 + 6) * vertexSize;
    
    float *vertices = (float*) malloc(sizeof(float) * pointCount);
    int kk = 0;
    
    for (int i = 0; i < segW1; i++) {
        double ui = 2.0 * i / _segW;
        double deltP = -ui * M_PI;
        float zz = (float) (cos(deltP) * 1);
        float xx = (float) (sin(deltP) * 1);
        float yy = (float) 0;
        vertices[kk++] = xx;
        vertices[kk++] = yy;
        vertices[kk++] = zz;
        printf("%f,",xx);
        printf("%f,",yy);
        printf("%f\n",zz);
    }
    
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    
    vertices[kk++] = 1;
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    
    vertices[kk++] = 0;
    vertices[kk++] = 1;
    vertices[kk++] = 0;
    
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    
    vertices[kk++] = 0;
    vertices[kk++] = 0;
    vertices[kk++] = 1;
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, pointCount * sizeof(GLfloat), vertices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(_attribVertex);
    glVertexAttribPointer(_attribVertex, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 3, NULL);
    
    glBindVertexArrayOES(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    //释放
    free(vertices);
}

- (void)drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(self.vertexArray);
    glUseProgram(self.program);
    
    // 正交
    const GLfloat zNear = 0.01, zFar = 1000.0, fieldOfView = 45.0;
    GLfloat size;
    size = zNear * tanf(GLKMathDegreesToRadians(fieldOfView) / 2.0);
    rect.size.width *= [UIScreen mainScreen].scale;
    rect.size.height *= [UIScreen mainScreen].scale;
    GLKMatrix4 mvMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -5.0f);
    GLKMatrix4 pMatrix = GLKMatrix4MakeFrustum(-size, size, -size / (rect.size.width / rect.size.height), size /
                                               (rect.size.width / rect.size.height), zNear, zFar);
    
    glUniformMatrix4fv(self.uniformMVP, 1, 0, GLKMatrix4Multiply(pMatrix, mvMatrix).m);
    glDrawArrays(GL_LINE_LOOP, 0, self.segW+1);
    glDrawArrays(GL_LINE_LOOP, self.segW+1, 6);
    
    mvMatrix = GLKMatrix4Rotate(mvMatrix, GLKMathDegreesToRadians(90), 0, 0, 1);
    glUniformMatrix4fv(self.uniformMVP, 1, 0, GLKMatrix4Multiply(pMatrix, mvMatrix).m);
    glDrawArrays(GL_LINE_LOOP, 0, self.segW+1);
    
    mvMatrix = GLKMatrix4Rotate(mvMatrix, GLKMathDegreesToRadians(45), 1, 0, 0);
    glUniformMatrix4fv(self.uniformMVP, 1, 0, GLKMatrix4Multiply(pMatrix, mvMatrix).m);
    glDrawArrays(GL_LINE_LOOP, 0, self.segW+1);
    
    mvMatrix = GLKMatrix4Rotate(mvMatrix, GLKMathDegreesToRadians(45), 1, 0, 0);
    glUniformMatrix4fv(self.uniformMVP, 1, 0, GLKMatrix4Multiply(pMatrix, mvMatrix).m);
    glDrawArrays(GL_LINE_LOOP, 0, self.segW+1);
    
    mvMatrix = GLKMatrix4Rotate(mvMatrix, GLKMathDegreesToRadians(45), 1, 0, 0);
    glUniformMatrix4fv(self.uniformMVP, 1, 0, GLKMatrix4Multiply(pMatrix, mvMatrix).m);
    glDrawArrays(GL_LINE_LOOP, 0, self.segW+1);
    
}

@end
