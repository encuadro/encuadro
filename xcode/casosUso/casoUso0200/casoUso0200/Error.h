//
//  Error.h
//  CoplanarPosit
//
//  Created by Juan Ignacio Braun on 3/16/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//

#include <stdio.h>
#include <math.h>
#include <stdlib.h>

void Error(long int NP,double** impts,double** obpts,double f,double Rotat[3][3],double Translat[3],double* Er,long int* Epr,double* Erhvmax);