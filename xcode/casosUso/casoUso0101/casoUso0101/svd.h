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

void  PseudoInverse(float** A,long int N,float** B);
void  PseudoInverseGen(float** A,int N,int M,float** B);
void  svdcmp(float **a,int m,int n,float *w,float **v);