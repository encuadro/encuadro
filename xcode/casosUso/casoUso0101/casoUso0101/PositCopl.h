//
//  PositCopl.h
//  CoplanarPosit
//
//  Created by Juan Ignacio Braun on 3/16/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//

#include <stdio.h>
#include <math.h>
#include <stdlib.h>

    
void PositCopl(long int nbP,float** imagePoints,float**objectPoints,float** objectMatrix,
               float focalLength,float Rot1[3][3],float Trans1[3],float Rot2[3][3],float Trans2[3]);

