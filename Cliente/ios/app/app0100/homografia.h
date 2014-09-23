//
//  homografia.h
//  app0100
//
//  Created by Pablo Flores Guridi on 16/02/13.
//
//

#ifndef app0100_homografia_h
#define app0100_homografia_h
#include "svd.h"

/*--------------------------------------Funciones para homografia 2D-------------------------------------*/
void solveHomographie(float **imgPts, float **imgPts2, float *h);
void solveHomographiePro(float **imgPts, float **imgPts2, float *h);
void matrixProduct(float ** A, int rowA, float ** B, int colB, float ** C);
void matrixVectorProduct(float ** A, int rowA, float* B, float* C);
void solveAffineTransformation(float **imgPts, float **imgPts2, float *h);


#endif
