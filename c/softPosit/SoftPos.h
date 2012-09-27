//
//  SoftPosit.h
//  CoplanarPosit
//
//  Created by Juan Ignacio Braun on 3/16/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include "vvector.h"
#include "svd.h"
#include "CoplanarPosit.h"

#define MY_PI 3.14159265

#define absValue(a,b)	\
{					\
if(b<0) a=-b;       \
else a=b;           \
}

void softPosit(double** imgPoints, int nbImagePts, double** worldPoints, int nbWorldPts, double beta0, double noiseStd, double initRot[3][3], double initTrans[3],double focalLength, double* center,double** rot, double* trans);
void softPositCopl(double** imgPoints, int nbImagePts, double** worldPoints, int nbWorldPts, double beta0, double noiseStd, double** initRot, double* initTrans,double focalLength, double* center,double** rot, double* trans);

int maxPosRatio(double** assMat,int** pos, double** ratios, int nbRow, int nbCol);
void sinkhornImp(double** assMat,int nbRow, int nbCol);