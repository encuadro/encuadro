# Program: moveObject.py
# Proyect: encuadro - Facultad de Ingeniería - UDELAR
# Author: Martin Etchart - mrtn.etchart@gmail.com.
# 
# Description:
# Python script to render blender model providing pose (rotation, translation), fov 
# and image dimensions moving object.
# 
# Hosted on:
# http://code.google.com/p/encuadro/
#
# Usage:
# blender -b demo.blend -P "moveObject.py" -- <cmd_line_args>
#
# More info:
# http://code.google.com/p/encuadro/wiki/Rendering


import bpy
import sys

# defs
t = [0.0] * 3
r = [0.0] * 3
pi = 3.141592653589793115997963468544

#command line arguments
t[0] = float(sys.argv[6])	 
t[1] = -float(sys.argv[7])	
t[2] = -float(sys.argv[8])	
r[0] = float(sys.argv[9])*(pi/180.0)
r[1] = -float(sys.argv[10])*(pi/180.0)
r[2] = -float(sys.argv[11])*(pi/180.0)
fov = float(sys.argv[12])	
height = int(sys.argv[13])	
width = int(sys.argv[14])

scene = bpy.data.scenes["Scene"]
cube = bpy.data.objects["Cube"]
lamp = bpy.data.objects["Lamp"]

# Set render resolution
scene.render.resolution_x = width
scene.render.resolution_y = height

# Set camera fov in degrees
scene.camera.data.angle = fov*(pi/180.0)

# Set camera to defaults
scene.camera.rotation_mode = 'XYZ'
scene.camera.rotation_euler = [0,0,0]
scene.camera.location = [0,0,0]

# Set cube translation
cube.location = t
# Set cube rotation
cube.rotation_mode = 'XYZ'
cube.rotation_euler = r

# Set lamp translation
lamp.location[0] = t[0]-5.0
lamp.location[1] = t[1]+5.0
lamp.location[2] = t[2]+5.0
# Set lamp rotation
lamp.rotation_mode = 'XYZ'
lamp.rotation_euler = r


# Set Scenes camera and output filename 
bpy.data.scenes["Scene"].render.file_format = 'PNG'
bpy.data.scenes["Scene"].render.filepath = 'out'
# Render Scene and store the scene 
bpy.ops.render.render( write_still=True ) 




