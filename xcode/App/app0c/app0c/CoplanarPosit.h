//
//  CoplanarPosit.h
//  ModernCoplanarPosit
//
//  Created by Juan Ignacio Braun on 5/14/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//


void CoplanarPosit(int NbPts, double **imgPts, double** worldPts, double focalLength, double center[2], double** Rot, double* Trans);

void CoplanarPosit4Soft(int NbPts, double **centeredImage, double** homogeneousWorldPts, double focalLength, double center[2], double** Rot, double* Trans);

void PositBranches(int NbPts, double **centeredImage, double** worldPts, double**objectMat, double** Rot1, double** Rot2, double* Trans);

void PerspMoveAndProjC(int N, double **obj, double **r, double *t, double foc, double** proj);

void ErrorC(long int NP,double** impts,double** obpts,double f,double center[2], double** Rotat,double* Translat,double* Er,long int* Epr,double* Erhvmax);

void PositLoop(int NbPts, double **centeredImage, double** homogeneousWorldPts, double**objectMat, double f,double center[2], double** RotIn, double* TransIn,double** Rot, double* Trans);