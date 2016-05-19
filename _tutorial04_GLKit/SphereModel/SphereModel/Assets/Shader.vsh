//
//  Shader.vsh
//  GLKViewSnapshot
//
//  Created by Nishiyama Nobuyuki on 2013/09/10.
//  Copyright (c) 2013年 Nishiyama Nobuyuki. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;
attribute vec2 texture;

varying lowp vec4 colorVarying;
varying lowp vec2 textureVarying;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    textureVarying = texture;
    gl_Position = modelViewProjectionMatrix * position;
}
