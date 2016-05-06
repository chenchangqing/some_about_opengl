//
//  textfile.h
//  opengl_glew
//
//  Created by green on 16/5/4.
//  Copyright © 2016年 xyz.chenchangqing. All rights reserved.
//

#ifndef macGL_textfile_h
#define macGL_textfile_h

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *textFileRead(const char *fn);
int textFileWrite(char *fn, char *s);
unsigned char *readDataFromFile(char *fn);
#endif