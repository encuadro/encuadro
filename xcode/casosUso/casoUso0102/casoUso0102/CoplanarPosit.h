/*
 Program: CoplanarPosit.c
 Proyect: encuadro - Facultad de Ingeniería - UDELAR
 Author: Juan Ignacio Braun - juanibraun@gmail.com.
 
 Description:
 C implementation of modern copalanar posit, based on the IJCV 2004 SoftPOSIT paper by Daniel DeMenthon and coplanar posit paper.
 
 Hosted on:
 http://code.google.com/p/encuadro/
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>
#include "vvector.h"

#define MY_PI 3.14159265

#define absValue(a,b)	\
{					\
if(b<0) a=-b;       \
else a=b;           \
}

void CoplanarPosit(int NbPts, float **imgPts, float** worldPts, float focalLength, float center[2], float** Rot, float* Trans);

void PositBranches(int NbPts, float **centeredImage, float** worldPts, float**objectMat, float** Rot1, float** Rot2, float* Trans);

void imgDiff(int numberOfPoints,float** imgPts,float** objPts,float** Rot,float* Tras,float* Er);

void PositLoop(int NbPts, float **centeredImage, float** homogeneousWorldPts, float**objectMat, float f,float center[2], float** RotIn, float* TransIn,float** Rot, float* Trans);

void Matrix2Euler(float** Rot, float* angles1, float* angles2);

void Euler2Matrix(float* angles,float** Rot);