#!/bin/sh
bindir=$(pwd)
cd /Users/green/some_about_opengl/_tutorial03_OpenGL基础知识/ogl/tutorial09_vbo_indexing/
export 

if test "x$1" = "x--debugger"; then
	shift
	if test "x" = "xYES"; then
		echo "r  " > $bindir/gdbscript
		echo "bt" >> $bindir/gdbscript
		GDB_COMMAND-NOTFOUND -batch -command=$bindir/gdbscript  /Users/green/Desktop/demos/opengl/some_about_opengl/_tutorial03_OpenGL基础知识/ogl-practices/MinSizeRel/tutorial09_vbo_indexing 
	else
		"/Users/green/Desktop/demos/opengl/some_about_opengl/_tutorial03_OpenGL基础知识/ogl-practices/MinSizeRel/tutorial09_vbo_indexing"  
	fi
else
	"/Users/green/Desktop/demos/opengl/some_about_opengl/_tutorial03_OpenGL基础知识/ogl-practices/MinSizeRel/tutorial09_vbo_indexing"  
fi
