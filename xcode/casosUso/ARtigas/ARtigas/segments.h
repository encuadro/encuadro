/*
Program: segments.h
Proyect: encuadro - Facultad de Ingeniería - UDELAR
Author: Martin Etchart - mrtn.etchart@gmail.com

Description:
Real time marker detection for pose estimation.
Line Segment Detector (LSD) for segment detection and OpenCV as interface.
This program is the evolution of 'lsd-opencv'.

Both programs hosted on:
http://code.google.com/p/encuadro/
*/
#include <math.h>
#include <stdlib.h>

#define MY_PI 3.14159265358979323846

typedef struct segment{
		int p1[2];
		int p2[2];
		/*float dir[2];
		float length;
		float angleDeg;
		float angleRad;*/
		float width;
} segment;

segment segmentNew(int x1,int y1,int x2,int y2,float w);

int lineIntersection(	float Ax, float Ay,
						float Bx, float By,
						float Cx, float Cy,
						float Dx, float Dy,
						float *X, float *Y );
					
int lineSegmentIntersection(float Ax, float Ay,
							float Bx, float By,
							float Cx, float Cy,
							float Dx, float Dy,
							float *X, float *Y );
							
float** getCorners(int *listSize, float *list);

float* filterSegments(int *listOutSize , int *listInSize , float *listIn, float distance_thr);

float** getMarkerCornersAlgo(int *listSize, float *list);

