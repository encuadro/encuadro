//
//  Header.h
//  siftSinCamara
//
//  Created by Pablo Flores Guridi on 09/08/12.
//  Copyright (c) 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#ifndef siftSinCamara_Header_h
#define siftSinCamara_Header_h

#import "sift.h"
#import "vl/pgm.h"
typedef struct
{
    int k1 ;
    int k2 ;
    double score ;
} Pair ;


void sift(float* fdata, int width, int height, int* nKeyPoints, double** keyPoints, int** descriptors );
void transposeDescriptor(vl_sift_pix* dst, vl_sift_pix* src);
Pair* compare (Pair* pairs_iterator, int * L1_pt, int* L2_pt, int K1, int K2, int ND, float thresh, int* matches);
int* levantarDescriptor(char* nombre, int*);
void escribirDescriptor(char* nombre, int* descriptor, long int largo);

#endif
