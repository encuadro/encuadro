//
//  CoplanarPosit.h
//  ModernCoplanarPosit
//
//  Created by Juan Ignacio Braun on 5/14/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//

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

void CoplanarPosit(int NbPts, double **imgPts, double** worldPts, double focalLength, double center[2], double** Rot, double* Trans);

void PositBranches(int NbPts, double **centeredImage, double** worldPts, double**objectMat, double** Rot1, double** Rot2, double* Trans);

void imgDiff(int numberOfPoints,double** imgPts,double** objPts,double** Rot,double* Tras,double* Er);

void PositLoop(int NbPts, double **centeredImage, double** homogeneousWorldPts, double**objectMat, double f,double center[2], double** RotIn, double* TransIn,double** Rot, double* Trans);

void Matrix2Euler(double** Rot, double* angles1, double* angles2);

void Euler2Matrix(double* angles,double** Rot);