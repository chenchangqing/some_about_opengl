//
//  Shader.fsh
//  GLKViewSnapshot
//
//  Created by Nishiyama Nobuyuki on 2013/09/10.
//  Copyright (c) 2013年 Nishiyama Nobuyuki. All rights reserved.
//

varying lowp vec4 v_color;

void main()
{
    gl_FragColor = v_color;
}
