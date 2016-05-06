//
//  main.m
//  lesson01
//
//  Created by green on 16/5/4.
//  Copyright © 2016年 xyz.chenchangqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <GLUT/GLUT.h>

void RenderSceneCB()
{
    int a=1234;
    printf("a=%d\n",a);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        glutInit(&argc, argv);
        glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
        glutInitWindowSize(1024, 768);
        glutInitWindowPosition(100, 100);
        glutCreateWindow("Tutorial 01");
        
        glutDisplayFunc(RenderSceneCB);
        glClearColor(0.0f,0.0f, 0.0f, 0.0f);
        glutMainLoop();
        glClear(GL_COLOR_BUFFER_BIT);
        glutSwapBuffers();
    }
    return 0;
}
