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


void softPosit(double** imgPoints, int nbImagePts, double** worldPoints, int nbWorldPts, double beta0, double noiseStd, double initRot[3][3], double initTrans[3],double focalLength, double* center,double** rot, double* trans);

void maxPosRatio(double** assMat,double** pos, double** ratios, int nbRow, int nbCol,int sizeMax);
void sinkhornImp(double** assMat,int nbRow, int nbCol);