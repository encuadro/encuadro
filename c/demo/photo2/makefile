#Program: makefile
#Proyect: encuadro - Facultad de Ingeniería - UDELAR
#Author: Martin Etchart - mrtn.etchart@gmail.com
#
#Description:
#Single photo marker detection for pose estimation 2.
#Line Segment Detector (LSD) for segment detection and OpenCV as interface.
#This program is the evolution of 'lsd-opencv'.
#
#Both programs hosted on:
#http://code.google.com/p/encuadro/


SRC = lsd.c segments.c  marker.c epnp.cpp
HDR = lsd.h segments.h marker.h epnp.h

all: markerPhoto2

markerPhoto2: ${SRC} ${HDR} main.cpp
	g++ -g -o markerPhoto2 main.cpp ${SRC} -lm `pkg-config --cflags --libs opencv`
	

	
