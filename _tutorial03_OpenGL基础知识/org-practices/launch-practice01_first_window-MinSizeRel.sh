#!/bin/sh
bindir=$(pwd)
cd /Users/green/some_about_opengl/_tutorial03_OpenGL基础知识/ogl/practice01_first_window/
export 

if test "x$1" = "x--debugger"; then
	shift
	if test "x" = "xYES"; then
		echo "r  " > $bindir/gdbscript
		echo "bt" >> $bindir/gdbscript
		GDB_COMMAND-NOTFOUND -batch -command=$bindir/gdbscript  /Users/green/some_about_opengl/_tutorial03_OpenGL基础知识/org-practices/MinSizeRel/practice01_first_window 
	else
		"/Users/green/some_about_opengl/_tutorial03_OpenGL基础知识/org-practices/MinSizeRel/practice01_first_window"  
	fi
else
	"/Users/green/some_about_opengl/_tutorial03_OpenGL基础知识/org-practices/MinSizeRel/practice01_first_window"  
fi
