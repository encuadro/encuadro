//
//  kalman.c
//  demoConKalman
//
//  Created by Juan Ignacio Braun on 10/1/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//

#include <stdio.h>
#include "kalman.h"


kalman_state kalman_init(double q, double r, double p, double intial_value)
{
    kalman_state result;
    result.q = q;
    result.r = r;
    result.p = p;
    result.x = intial_value;
    
    return result;
}

void kalman_update(kalman_state* state, double measurement)
{
    //prediction update
    //omit x = x
    state->p = state->p + state->q;
    
    //measurement update
    state->k = state->p / (state->p + state->r);
    state->x = state->x + state->k * (measurement - state->x);
    state->p = (1 - state->k) * state->p;
}


