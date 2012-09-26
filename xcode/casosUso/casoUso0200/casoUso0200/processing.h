///Users/pablofloresguridi/Desktop/tiempoReal/tiempoReal.xcodeproj
//  processing.h
//  prueba2
//
//  Created by Juan Cardelino on 18/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


void rgb2gray(double* brillo, unsigned char *pixels, int w, int h, int d);
void solveHomographie(double **imgPts, double **imgPts2, double *h);
void matrixProduct(double ** A, int rowA, double ** B, int colB, double ** C);
void matrixVectorProduct(double ** A, int rowA, double* B, double* C);