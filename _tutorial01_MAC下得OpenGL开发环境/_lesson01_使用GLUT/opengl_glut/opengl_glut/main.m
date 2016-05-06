//
//  main.m
//  opengl_glut
//
//  Created by green on 16/5/3.
//  Copyright © 2016年 xyz.chenchangqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <GLUT/GLUT.h>
void display()
{
    glClear(GL_COLOR_BUFFER_BIT);
    glBegin(GL_POLYGON);
    glVertex2f(-0.5, -0.5);
    glVertex2f(-0.5, 0.5);
    glVertex2f(0.5, 0.5);
    glVertex2f(0.5, -0.5);
    glEnd();
    glFlush();
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        glutInit(&argc, argv);
        glutCreateWindow("Xcode Glut Demo");
        glutDisplayFunc(display);
        glutMainLoop();
    }
    return 0;
}