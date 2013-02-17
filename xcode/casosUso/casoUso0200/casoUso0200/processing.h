///Users/pablofloresguridi/Desktop/tiempoReal/tiempoReal.xcodeproj
//  processing.h
//  prueba2
//
//  Created by Juan Cardelino on 18/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


void rgb2gray(float* brillo, unsigned char *pixels, int w, int h, int d);
void solveHomographie(float **imgPts, float **imgPts2, float *h);
void matrixProduct(float ** A, int rowA, float ** B, int colB, float ** C);
void matrixVectorProduct(float ** A, int rowA, float* B, float* C);
void solveAffineTransformation(float **imgPts, float **imgPts2, float *h);