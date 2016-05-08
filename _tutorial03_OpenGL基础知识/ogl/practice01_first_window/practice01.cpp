
#include <stdio.h>
#include <stdlib.h>
#include <GL/glew.h>
#include <glfw3.h>
#include <glm/glm.hpp>
using namespace glm;

GLFWwindow* window;

int main( void )
{

    /**
     *  初始化GLFW
     */
    if( !glfwInit() )
    {
        fprintf( stderr, "Failed to initialize GLFW\n" );
        return -1;
    }
    
    /**
     *  创建OpenGL窗口
     */
    glfwWindowHint(GLFW_SAMPLES, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE); 
    
    window = glfwCreateWindow(1024, 768, "Practice 01", NULL, NULL);
    
    if (window == NULL)
    {
        fprintf( stderr, "Failed to open GLFW window\n" );
        getchar();
        glfwTerminate();
        return -1;
    }
    
    glfwMakeContextCurrent(window);
    glewExperimental=true;
    
    if (glewInit() != GLEW_OK) {
        fprintf(stderr, "Failed to initialize GLEW\n");
        getchar();
        glfwTerminate();
        return -1;
    }
    
    glfwSetInputMode(window, GLFW_STICKY_KEYS, GL_TRUE);
    
    glClearColor(0.0f, 0.0f, 0.4f, 0.0f);
    
    do{
        
        glClear( GL_COLOR_BUFFER_BIT );
        glfwSwapBuffers(window);
        glfwPollEvents();
        
    }
    
    /**
     *  按ESC退出
     */
    while( glfwGetKey(window, GLFW_KEY_ESCAPE ) != GLFW_PRESS &&
          glfwWindowShouldClose(window) == 0 );
    glfwTerminate();
    
    return 0;
}