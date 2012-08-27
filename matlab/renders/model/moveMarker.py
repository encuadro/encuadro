# Program: moveMarker.py
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
#pi = 3.14

#command line arguments
t[0] = float(sys.argv[6])/10.0 
t[1] = -float(sys.argv[7])/10.0
t[2] = -float(sys.argv[8])/10.0
r[0] = float(sys.argv[9])*(pi/180.0)
r[1] = -float(sys.argv[10])*(pi/180.0)
r[2] = -float(sys.argv[11])*(pi/180.0)
fov = float(sys.argv[12])	
height = int(sys.argv[13])	
width = int(sys.argv[14])
fname = sys.argv[15]

scene = bpy.data.scenes["Scene"]
marker = bpy.data.objects["Marker"]

# Set render resolution
scene.render.resolution_x = width
scene.render.resolution_y = height

# Set camera fov in degrees
scene.camera.data.angle = fov*(pi/180.0)

# Set camera to defaults
scene.camera.rotation_mode = 'XYZ'
scene.camera.rotation_euler = [0,0,0]
scene.camera.location = [0,0,0]

# Set cube rotation
marker.rotation_mode = 'XYZ'
marker.rotation_euler = r
#marker.delta_rotation_euler = r
# Set cube translation
marker.location = t


# Set Scenes camera and output filename 
bpy.data.scenes["Scene"].render.file_format = 'PNG'
bpy.data.scenes["Scene"].render.filepath = str(fname)
# Render Scene and store the scene 
bpy.ops.render.render( write_still=True ) 




