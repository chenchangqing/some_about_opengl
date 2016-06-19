//
//  Shader.vsh
//  GLKViewSnapshot
//
//  Created by Nishiyama Nobuyuki on 2013/09/10.
//  Copyright (c) 2013年 Nishiyama Nobuyuki. All rights reserved.
//

attribute vec4 a_position;
attribute vec4 a_color;

varying lowp vec4 v_color;

uniform mat4 u_mvp;

void main()
{
    v_color = a_color;
    gl_Position = u_mvp * a_position;
}
