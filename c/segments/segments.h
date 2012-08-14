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
#include <malloc.h>

typedef struct segment{
		int p1[2];
		int p2[2];
		double dir[2];	
		double length;
		double angleDeg;
		double angleRad;
		double width;
} segment;

segment segmentNew(int x1,int y1,int x2,int y2,double w);

int lineIntersection(	double Ax, double Ay,
						double Bx, double By,
						double Cx, double Cy,
						double Dx, double Dy,
						double *X, double *Y );
					
int lineSegmentIntersection(double Ax, double Ay,
							double Bx, double By,
							double Cx, double Cy,
							double Dx, double Dy,
							double *X, double *Y );
							
double** getMarkerCorners(int *listSize, double *list);

double* filterSegments(int *listOutSize , int *listInSize , double *listIn, float distance_thr);

double** getMarkerCornersAlgo(int *listSize, double *list);

