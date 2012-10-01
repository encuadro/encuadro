//
//  CoplanarPosit.h
//  ModernCoplanarPosit
//
//  Created by Juan Ignacio Braun on 5/14/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//


void CoplanarPosit(int NbPts, float **imgPts, float** worldPts, float focalLength, float center[2], float** Rot, float* Trans);

void CoplanarPosit4Soft(int NbPts, float **centeredImage, float** homogeneousWorldPts, float focalLength, float center[2], float** Rot, float* Trans);

void PositBranches(int NbPts, float **centeredImage, float** worldPts, float**objectMat, float** Rot1, float** Rot2, float* Trans);

void PerspMoveAndProjC(int N, float **obj, float **r, float *t, float foc, float** proj);

void ErrorC(long int NP,float** impts,float** obpts,float f,float center[2], float** Rotat,float* Translat,float* Er,long int* Epr,float* Erhvmax);

void PositLoop(int NbPts, float **centeredImage, float** homogeneousWorldPts, float**objectMat, float f,float center[2], float** RotIn, float* TransIn,float** Rot, float* Trans);

void Matrix2Euler(float** Rot, float* angles1, float* angles2);