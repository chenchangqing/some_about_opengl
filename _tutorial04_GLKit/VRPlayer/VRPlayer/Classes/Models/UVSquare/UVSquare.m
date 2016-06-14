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

static const GLushort g_element_buffer_data[] = {
    0,1,2,
    2,3,0
};

@interface UVSquare() {
    
}

@end

@implementation UVSquare

- (void)setup {
    
    [super setup];
    
}

- (void)setupVertexCount:(int *)count vertexData:(GLfloat **)data {
    
    *count = 12;
    
    *data = g_position_buffer_data;
}

- (void)setupColorCount:(int *)count colorData:(GLfloat **)data {
    
    *count = 24;
    
    GLfloat red = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"R"]).floatValue;
    GLfloat green = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"G"]).floatValue;
    GLfloat blue = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"B"]).floatValue;
    GLfloat alpha = ((NSNumber *)[RandColor.RGBDictionary objectForKey:@"A"]).floatValue;
    
    GLfloat rgba[4] = {
        red,green,blue,alpha
    };
    
    GLfloat *tdata = (float*) malloc(sizeof(float) * 24);
    for (int i=0; i<24; i++) {
        
        tdata[i] = rgba[i%4];
    }
    
    *data = tdata;
}

- (void)setupElementCount:(int *)count elementData:(GLfloat **)data {
    
    *count = 6;
    
    *data = g_element_buffer_data;
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
