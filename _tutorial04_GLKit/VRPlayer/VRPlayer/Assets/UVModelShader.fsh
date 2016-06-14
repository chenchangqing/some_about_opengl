//
//  Shader.fsh
//  GLKViewSnapshot
//
//  Created by Nishiyama Nobuyuki on 2013/09/10.
//  Copyright (c) 2013年 Nishiyama Nobuyuki. All rights reserved.
//

varying lowp vec2 v_textureCoord;
varying lowp vec4 v_color;
uniform sampler2D u_BGSampler;

void main()
{
    //gl_FragColor = texture2D(u_BGSampler, v_textureCoord);
//    gl_FragColor = v_color;
    
    gl_FragColor = v_color;
    gl_FragColor = texture2D(u_BGSampler, v_textureCoord);
}
