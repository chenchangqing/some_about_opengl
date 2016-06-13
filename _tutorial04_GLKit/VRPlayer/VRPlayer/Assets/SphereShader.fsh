//
//  Shader.fsh
//  GLKViewSnapshot
//
//  Created by Nishiyama Nobuyuki on 2013/09/10.
//  Copyright (c) 2013年 Nishiyama Nobuyuki. All rights reserved.
//

varying lowp vec2 v_texCoord;
uniform sampler2D imageSampler;

void main()
{
    gl_FragColor = texture2D(imageSampler, v_texCoord);
}
