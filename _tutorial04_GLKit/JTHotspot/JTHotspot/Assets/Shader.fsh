//
//  Shader.fsh
//  GLKViewSnapshot
//
//  Created by Nishiyama Nobuyuki on 2013/09/10.
//  Copyright (c) 2013年 Nishiyama Nobuyuki. All rights reserved.
//

varying lowp vec4 colorVarying;
varying lowp vec2 textureVarying;

uniform sampler2D textureSampler;

void main()
{
//    gl_FragColor = colorVarying;
    gl_FragColor = texture2D(textureSampler,textureVarying).rgba;
}
