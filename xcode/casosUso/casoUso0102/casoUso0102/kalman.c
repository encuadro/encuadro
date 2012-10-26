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

kalman_state_n kalman_init_n(float** q, float** r, float** p, float** k, float* intial_value){
    kalman_state_n result;
    result.q = q;
    result.r = r;
    result.p = p;
    result.k = k;
    result.x = intial_value;
  
    
    return result;
}

void kalman_update_3x3(kalman_state_n* state, float* measurement,float** A, float** H)
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
}


void kalman_sensors_update(kalman_state_n* state, float* measurement,float** A, float** H)
{

    float **S,**Sinv;
    S=(float**)malloc(6*sizeof(float*));
    for (int i=0; i<6; i++) S[i]=(float *)malloc(6*sizeof(float));
    Sinv=(float**)malloc(6*sizeof(float*));
    for (int i=0; i<6; i++) Sinv[i]=(float *)malloc(6*sizeof(float));

    float auxVec3[3],auxVec6[6],auxMat3x6[3][6],auxMat6x3[6][3],auxMat3x3[3][3];
    float Atrsp[3][3];
//    printf("\n \n ARRANCA KALMAN\n\n");
    /*predicted p*/
    TRANSPOSE_MATRIX_3X3(Atrsp, A);
    MATRIX_PRODUCT_3X3(auxMat3x3, state->p, Atrsp);
    MATRIX_PRODUCT_3X3(state->p, A, auxMat3x3);
    ACCUM_SCALE_MATRIX_3X3(state->p, 1, state->q)
    /*predicted x*/
    MAT_DOT_VEC_3X3(state->x, A, state->x);
//    VEC_PRINT(state->x);
    /*kalman gain*/
//    printf("\nARRANCA KALMAN GAIN\n");
    float Htrsp[3][6];
    TRANSPOSE_MATRIX_6X3(Htrsp, H);
//    MAT_PRINT_3X6(Htrsp);
    MATRIX_PRODUCT_3X3x3X6(auxMat3x6, state->p, Htrsp);
//    MAT_PRINT_3X6(auxMat3x6);
    MATRIX_PRODUCT_6X3x3X6(S, H, auxMat3x6);
    ACCUM_SCALE_MATRIX_6X6(S, 1.0, state->r);
//    MAT_PRINT_6X6(state->r);
//    MAT_PRINT_6X6(S);
    PseudoInverseGen(S, 6, 6, Sinv);
//    MAT_PRINT_6X6(Sinv);
    MATRIX_PRODUCT_3X6x6X6(state->k, auxMat3x6, Sinv);
//    MAT_PRINT_3X6(state->k);
//    printf("\TERMINA KALMAN GAIN\n");
    
    /*estimated x*/
//    VEC_PRINT(state->x);
    MAT_DOT_VEC_6X3(auxVec6, H, state->x);
//    VEC_PRINT_6(auxVec6);
    VEC_DIFF_6(auxVec6, measurement, auxVec6);
//    VEC_PRINT_6(measurement);
//    VEC_PRINT_6(auxVec6);
//    MAT_PRINT_3X6(state->k);
    MAT_DOT_VEC_3X6(auxVec3, state->k, auxVec6);
//    VEC_PRINT(auxVec3);
    VEC_SUM(state->x, state->x, auxVec3);
    VEC_PRINT(state->x);
    
    /*estimated P*/
    MATRIX_PRODUCT_6X3x3X3(auxMat6x3, H, state->p);
    MATRIX_PRODUCT_3X6x6X3(auxMat3x3, state->k, auxMat6x3);
    ACCUM_SCALE_MATRIX_3X3(state->p, -1.0, auxMat3x3);
    
    for (int i=0; i<6; i++) {
        free(S[i]);
        free(Sinv[i]);
    }
    free(S);
    free(Sinv);
    printf("\n \n TERMINA KALMAN\n\n");
}
