//
//  encuadroSift.h
//  sift
//
//  Created by Pablo Flores Guridi on 21/08/12.
//  Copyright (c) 2012 Pablo Flores Guridi. All rights reserved.
//

#ifndef sift_encuadroSift_h
#define sift_encuadroSift_h


#import "vl/sift.h"
#import "vl/pgm.h"
typedef struct
{
    int k1 ;
    int k2 ;
    double score ;
} Pair ;


void sift(float* fdata, int width, int height, int* nKeyPoints, double** keyPoints, int** descriptors );
void transposeDescriptor(vl_sift_pix* dst, vl_sift_pix* src);
void compare (Pair* pairs_iterator, int * L1_pt, int* L2_pt, int K1, int K2, int ND, float thresh, int* matches);
int* levantarDescriptor(char* nombre, int*);
const char* buscarBaseDeDatos(int nKeyPoints, int* descriptors);
const char* buscarBaseDeDatos_ala(int nKeyPoints, int* descriptors, const char* ala);
#endif
