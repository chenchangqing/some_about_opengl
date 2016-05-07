// Include standard headers
#include <stdio.h>
#include <stdlib.h>

// Include GLEW
#include <GL/glew.h>

// Include GLFW
#include <glfw3.h>
GLFWwindow* window;

// Include GLM
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
using namespace glm;

// GPU缓冲
GLuint vertexbuffer;

// 定义顶点数据
static const GLfloat g_vertex_buffer_data[] = {
    -1.0f, -1.0f, 0.0f,
    1.0f, -1.0f, 0.0f,
    0.0f,  1.0f, 0.0f,
};

/**
 *  渲染
 */
static void renderScene()
{
    
    glClear( GL_COLOR_BUFFER_BIT );
    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glDisableVertexAttribArray(0);
    glfwSwapBuffers(window);
    glfwPollEvents();
    
}

/**
 *  清除缓冲
 */
static void clear() {
    
    glDeleteBuffers(1, &vertexbuffer);
}

/**
 *  创建顶点数组缓冲
 */
static void createVertexBuffer()
{
    glGenBuffers(1, &vertexbuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_vertex_buffer_data), g_vertex_buffer_data, GL_STATIC_DRAW);
}

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
    
    window = glfwCreateWindow(1024, 768, "Practice 02", NULL, NULL);
    
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
    
    /**
     *  渲染
     */
    glClearColor(0.0f, 0.0f, 0.4f, 0.0f);
    
    createVertexBuffer();
    do{
        
        renderScene();
        
    } while(glfwGetKey(window, GLFW_KEY_ESCAPE ) != GLFW_PRESS
            && glfwWindowShouldClose(window) == 0 );
    
    clear();
    
    glfwTerminate();
    return 0;
}