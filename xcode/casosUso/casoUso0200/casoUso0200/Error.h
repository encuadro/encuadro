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

void Error(long int NP,float** impts,float** obpts,float f,float Rotat[3][3],float Translat[3],float* Er,long int* Epr,float* Erhvmax);