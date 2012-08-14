# Program: marker_a4.py
# Proyect: encuadro - Facultad de Ingeniería - UDELAR
# Author: Martin Etchart - mrtn.etchart@gmail.com.
# 
# Description:
# Python script to render blender model providing pose (rotation, translation), fov 
# and image dimensions.
# 
# Hosted on:
# http://code.google.com/p/encuadro/
#
# Usage:
# blender -b marker_a4.blend --python "marker_a4.py" -o //<filename> -F JPEG -x 1 -f 1 
#
# More info:
# http://code.google.com/p/encuadro/wiki/Rendering


import bpy
import sys

####################################
# OPTIONAL ARGUMENT PARSING WITH LIBRARY. DONT WORK
#
#import argparse
#
#parser = argparse.ArgumentParser(description='Python script to render blender model #providing pose (rotation, translation), fov and image dimensions.')
#
#parser.add_argument('-rot', action="store", dest="r")
#parser.add_argument('-tra', action="store", dest="t")
#parser.add_argument('-fov', action="store", dest="fov", type=float)
####################################

####################################
# OPTIONAL ARGUMENT PARSING BY ME. DONT WORK
#
#i = 4
#while (i<len(sys.argv)):
#	if (sys.argv[i]=="-tra"):
#		i+=1
#		tx = float(sys.argv[i])	
#		i+=1
#		ty = float(sys.argv[i])	
#		i+=1
#		tz = float(sys.argv[i])	
#		print "TRA"	
#	elif (sys.argv[i]=="-rot"):
#		i+=1
#		rx = float(sys.argv[i])	
#		i+=1
#		ry = float(sys.argv[i])	
#		i+=1
#		rz = float(sys.argv[i])	
#		print "ERRE"	
#	elif (sys.argv[i]=="-fov"):
#		i+=1
#		fov = float(sys.argv[i])
#	elif (sys.argv[i]=="-o"):
#		print "OOO"
#		break		
#	i+=1
####################################

if (sys.argv[5]=="-o"):
	#default values
	tx = 0.0
	ty = 0.0
	tz = 80.0
	rx = 0.0
	ry = 0.0
	rz = 0.0
	fov = 50
	height = 359
	width = 480
else:
	#command line arguments
	# FIXME: not optional arguments. still buggy.
	tx = float(sys.argv[5])	
	ty = float(sys.argv[6])	
	tz = float(sys.argv[7])	
	rx = float(sys.argv[8])	
	ry = float(sys.argv[9])	
	rz = float(sys.argv[10])	
	fov = float(sys.argv[11])	
	height = int(sys.argv[12])	
	width = int(sys.argv[12])	

pi = 3.14159265

scene = bpy.data.scenes["Scene"]
#camera = bpy.data.scenes["Camera"]

# Set render resolution
scene.render.resolution_x = width
scene.render.resolution_y = height

# Set camera fov in degrees
scene.camera.data.angle = fov*(pi/180.0)

# Set camera rotation in euler angles
scene.camera.rotation_mode = 'XYZ'
scene.camera.rotation_euler[0] = rx*(pi/180.0)
scene.camera.rotation_euler[1] = ry*(pi/180.0)
scene.camera.rotation_euler[2] = rz*(pi/180.0)

# Set camera translation
scene.camera.location.x = tx
scene.camera.location.y = ty
scene.camera.location.z = tz


