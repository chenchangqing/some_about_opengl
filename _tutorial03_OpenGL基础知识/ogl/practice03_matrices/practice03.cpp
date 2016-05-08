
#include <stdio.h>
#include <stdlib.h>
#include <GL/glew.h>
#include <glfw3.h>
#include <common/shader.hpp>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
using namespace glm;

/**
 *  变量
 */
GLFWwindow* window;
GLuint vertexarray;
GLuint vertexbuffer;
GLuint programID;
GLuint matrixID;
glm::mat4 MVP;

/**
 *  顶点数据
 */
static const GLfloat g_vertex_buffer_data[] = {
    -1.0f, -1.0f, 0.0f,
    1.0f, -1.0f, 0.0f,
    0.0f,  1.0f, 0.0f,
};

/**
 *  创建OpenGL窗口
 */
static int createWindow() {
    
    if( !glfwInit() )
    {
        fprintf( stderr, "Failed to initialize GLFW\n" );
        getchar();
        return -1;
    }
    
    glfwWindowHint(GLFW_SAMPLES, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    
    window = glfwCreateWindow(1024, 768, "Practice 03", NULL, NULL);
    
    if (window == NULL)
    {
        fprintf( stderr, "Failed to open GLFW window. If you have an Intel GPU, they are not 3.3 compatible. Try the 2.1 version of the tutorials.\n" );
        getchar();
        glfwTerminate();
        return -1;
    }
    
    glfwMakeContextCurrent(window);
    
    glewExperimental = true;
    if (glewInit() != GLEW_OK) {
        fprintf(stderr, "Failed to initialize GLEW\n");
        getchar();
        glfwTerminate();
        return -1;
    }
    
    glfwSetInputMode(window, GLFW_STICKY_KEYS, GL_TRUE);
    
    return 0;
}

/**
 *  加载着色器
 */
static void loadShaders() {
    
    programID = LoadShaders( "SimpleTransform.vertexshader", "SingleColor.fragmentshader" );
}

/**
 *  创建矩阵
 */
static void createMatrix() {
    
    matrixID = glGetUniformLocation(programID, "MVP");
    
    glm::mat4 Projection = glm::perspective(glm::radians(45.0f), 4.0f / 3.0f, 0.1f, 100.0f);
    glm::mat4 View       = glm::lookAt(glm::vec3(4,3,3),glm::vec3(0,0,0),glm::vec3(0,1,0));
    glm::mat4 Model      = glm::mat4(1.0f);
    
    MVP = Projection * View * Model;
}

/**
 *  创建顶点数组缓冲
 */
static void createBuffers()
{
    
    glGenVertexArrays(1, &vertexarray);
    glBindVertexArray(vertexarray);
    
    glGenBuffers(1, &vertexbuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_vertex_buffer_data), g_vertex_buffer_data, GL_STATIC_DRAW);
    
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
}

/**
 *  渲染
 */
static void renderScene()
{
    
    do{
        glUseProgram(programID);
        
        glUniformMatrix4fv(matrixID, 1, GL_FALSE, &MVP[0][0]);
        
        glClear( GL_COLOR_BUFFER_BIT );
        
        glEnableVertexAttribArray(0);
        glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
        
        glDrawArrays(GL_TRIANGLES, 0, 3);
        
        glDisableVertexAttribArray(0);
        
        glfwSwapBuffers(window);
        glfwPollEvents();
        
    } while(glfwGetKey(window, GLFW_KEY_ESCAPE ) != GLFW_PRESS && glfwWindowShouldClose(window) == 0 );
    
}

/**
 *  释放
 */
static void clear() {
    
    glDeleteBuffers(1, &vertexbuffer);
    glDeleteVertexArrays(1, &vertexarray);
    glDeleteProgram(programID);
    glfwTerminate();
}

/**
 *  主函数
 */
int main( void )
{
    if (createWindow() != 0 ) {
        
        return -1;
    }
    
    loadShaders();
    
    createMatrix();
    
    createBuffers();
    
    renderScene();
    
    clear();
    
    return 0;
}