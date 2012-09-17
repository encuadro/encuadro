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
#include <stdbool.h>

    
void PositCopl(long int nbP,double** imagePoints,double**objectPoints,double** objectMatrix,
               double focalLength,double Rot1[3][3],double Trans1[3],double Rot2[3][3],double Trans2[3]);
