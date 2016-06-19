//
//  UVScence.m
//  Pods
//
//  Created by green on 16/5/22.
//
//

#import "UVScene.h"
#import "UVSquare.h"

@interface UVScene ()

@end

@implementation UVScene

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _models = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

- (void)buildProgram {
    
}

- (void)setupPositionBuffer:(GLuint*)buffer positonAttrib:(GLuint)attrib {
    
}
- (void)setupColorBuffer:(GLuint*)buffer colorAttrib:(GLuint)attrib {
    
}
- (void)setupTextureBuffer:(GLuint*)buffer textureAttrib:(GLuint)attrib {
    
}
- (void)setupElementBuffer:(GLuint*)buffer elementCount:(GLsizei *)count {
    
}
- (void)updateTextureInfo:(GLuint*)textureIndex {
    
}

- (void)updateWithMVP: (GLKMatrix4)mvp {
    [super updateWithMVP:mvp];
    
    for (UVModel *model in _models) {
        
        [model updateWithMVP:self.mvp];
    }
    
}

- (void)draw {
    [super draw];
    
    for (UVModel *model in _models) {
        
        [model draw];
    }
}

- (void)free {
    [super free];
    
    for (UVModel *model in _models) {
        
        [model free];
    }
}

@end
