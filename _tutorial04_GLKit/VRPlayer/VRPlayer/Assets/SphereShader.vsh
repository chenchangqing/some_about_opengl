//
//  Shader.vsh
//  GLKViewSnapshot
//
//  Created by Nishiyama Nobuyuki on 2013/09/10.
//  Copyright (c) 2013年 Nishiyama Nobuyuki. All rights reserved.
//

attribute vec4 a_position;
attribute vec2 a_textureCoord;

varying lowp vec2 v_texCoord;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    v_texCoord = a_textureCoord;
    gl_Position = modelViewProjectionMatrix * a_position;
}
