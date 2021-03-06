//
//  kalman.c
//  demoConKalman
//
//  Created by Juan Ignacio Braun on 10/1/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//

#include <stdio.h>
#include "kalman.h"
#include <stdlib.h>


kalman_state kalman_init(float q, float r, float p, float intial_value)
{
    kalman_state result;
    result.q = q;
    result.r = r;
    result.p = p;
    result.x = intial_value;
    
    return result;
}

void kalman_update(kalman_state* state, float measurement)
{
    //prediction update
    //omit x = x
    state->p = state->p + state->q;
    
    //measurement update
    state->k = state->p / (state->p + state->r);
    state->x = state->x + state->k * (measurement - state->x);
    state->p = (1 - state->k) * state->p;
}

kalman_state_3 kalman_init_3x3(float** q, float** r, float** p, float** k, float* intial_value){
    kalman_state_3 result;
    result.q = q;
    result.r = r;
    result.p = p;
    result.k = k;
    result.x = intial_value;
  
    
    return result;
}

void kalman_update_3x3(kalman_state_3* state, float* measurement,float** A, float** H)
{
    float** auxMat;
    auxMat=(float**)malloc(3*sizeof(float*));
    for (int i=0; i<3; i++) auxMat[i]=malloc(3*sizeof(float));
    float* auxVet;
    auxVet=(float*)malloc(3*sizeof(float));
   
    float pTrsp[3][3],Atrsp[3][3];
    
    /*predicted p*/
    TRANSPOSE_MATRIX_3X3(Atrsp, A);
    MATRIX_PRODUCT_3X3(auxMat, state->p, Atrsp);
    MATRIX_PRODUCT_3X3(state->p, A, auxMat);
    ACCUM_SCALE_MATRIX_3X3(state->p, 1, state->q)
    /*predicted x*/
    MAT_DOT_VEC_3X3(state->x, A, state->x);
//    state->x=xaux;

    /*kalman gain*/
    float Htrsp[3][3], S[3][3], Sinv[3][3], B[3][3], det;
    TRANSPOSE_MATRIX_3X3(Htrsp, H);
    TRANSPOSE_MATRIX_3X3(pTrsp, state->p);
    MATRIX_PRODUCT_3X3(auxMat, pTrsp, Htrsp);
    MATRIX_PRODUCT_3X3(S, H, auxMat);
    ACCUM_SCALE_MATRIX_3X3(S, 1.0, state->r);
 
    MATRIX_PRODUCT_3X3(B, H, pTrsp);
 
    INVERT_3X3(Sinv, det, S);
    MATRIX_PRODUCT_3X3(auxMat, Sinv, B);
    TRANSPOSE_MATRIX_3X3(state->k, auxMat);
//    MAT_PRINT_3X3(state->k);

    /*estimated x*/    
    MAT_DOT_VEC_3X3(auxVet, H, state->x);
    VEC_DIFF(auxVet, measurement, auxVet);
    MAT_DOT_VEC_3X3(auxVet, state->k, auxVet);
    VEC_SUM(state->x, state->x, auxVet);
    
    /*estimated P*/
    MATRIX_PRODUCT_3X3(auxMat, H, state->p);
    MATRIX_PRODUCT_3X3(auxMat, state->k, auxMat);
    ACCUM_SCALE_MATRIX_3X3(state->p, -1.0, auxMat);
   
    /*out*/
    MAT_DOT_VEC_3X3(measurement, H, state->x);
    
    for (int i=0; i<3; i++) free(auxMat[i]);
    free(auxMat);
    free(auxVet);
//
//    //    //prediction update
////    //omit x = x
////    state->p = state->p + state->q;
////    
////    //measurement update
////    state->k = state->p / (state->p + state->r);
////    state->x = state->x + state->k * (measurement - state->x);
////    state->p = (1 - state->k) * state->p;
////
//    
////    x_prd = A * x_est;
////    p_prd = A * p_est * A' + Q;
////    S = H * p_prd' * H' + R;
////    B = H * p_prd';
////    klm_gain = (S \ B)';
////    x_est = x_prd + klm_gain * (goodPoses(n,1:3)' - H * x_prd);
////                                p_est = p_prd - klm_gain * H * p_prd;
////                                y(n,1:3) = H * x_est;
////}
//
}
