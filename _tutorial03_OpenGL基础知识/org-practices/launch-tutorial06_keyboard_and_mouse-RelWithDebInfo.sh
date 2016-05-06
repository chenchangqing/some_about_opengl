#!/bin/sh
bindir=$(pwd)
cd /Users/green/some_about_opengl/_tutorial03_OpenGL基础知识/ogl/tutorial06_keyboard_and_mouse/
export 

if test "x$1" = "x--debugger"; then
	shift
	if test "x" = "xYES"; then
		echo "r  " > $bindir/gdbscript
		echo "bt" >> $bindir/gdbscript
		GDB_COMMAND-NOTFOUND -batch -command=$bindir/gdbscript  /Users/green/some_about_opengl/_tutorial03_OpenGL基础知识/org-practices/RelWithDebInfo/tutorial06_keyboard_and_mouse 
	else
		"/Users/green/some_about_opengl/_tutorial03_OpenGL基础知识/org-practices/RelWithDebInfo/tutorial06_keyboard_and_mouse"  
	fi
else
	"/Users/green/some_about_opengl/_tutorial03_OpenGL基础知识/org-practices/RelWithDebInfo/tutorial06_keyboard_and_mouse"  
fi
