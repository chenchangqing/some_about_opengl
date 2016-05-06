#!/bin/sh
bindir=$(pwd)
cd /Users/green/some_about_opengl/_tutorial03_OpenGL基础知识/ogl/tutorial14_render_to_texture/
export 

if test "x$1" = "x--debugger"; then
	shift
	if test "x" = "xYES"; then
		echo "r  " > $bindir/gdbscript
		echo "bt" >> $bindir/gdbscript
		GDB_COMMAND-NOTFOUND -batch -command=$bindir/gdbscript  /Users/green/some_about_opengl/_tutorial03_OpenGL基础知识/org-practices/Release/tutorial14_render_to_texture 
	else
		"/Users/green/some_about_opengl/_tutorial03_OpenGL基础知识/org-practices/Release/tutorial14_render_to_texture"  
	fi
else
	"/Users/green/some_about_opengl/_tutorial03_OpenGL基础知识/org-practices/Release/tutorial14_render_to_texture"  
fi
