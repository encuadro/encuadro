//
//  svd.h
//  CoplanarPosit
//
//  Created by Juan Ignacio Braun on 3/16/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

void  PseudoInverse(double** A,long int N,double** B);
void  PseudoInverseGen(double** A,int N,int M,double** B);
void  svdcmp(double **a,int m,int n,double *w,double **v);