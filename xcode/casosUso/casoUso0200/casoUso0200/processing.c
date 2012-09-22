//
//  processing.c
//  prueba2
//
//  Created by Juan Cardelino on 18/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "processing.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "svd.h"


void rgb2gray(double* brillo, unsigned char *pixels, int w, int h, int d)
{
    // printf("w: %-3d h: %-3d\n",w,h);
    
    unsigned long int  pixelNr;
    int blue,green, red, r,g,b;
    double fvalue;
    
    
    for(int j=0;j<h;j++)
    {
        
        for(int i=0;i<w;i=i++)
        {
            //pixelNr = i*h+j;
            pixelNr = j*w+i;
            blue                = pixelNr*d;
            green               = pixelNr*d+1;
            red                = pixelNr*d+2;
            
            r=pixels[red];
            g=pixels[green];
            b=pixels[blue];
            //convert each pixel to gray
            
            fvalue=0.30*r + 0.59*g + 0.11*b;
            
            
            //for debugging purpose only
            //printf(" %g",fvalue);
            //printf(" (%d,%d,%d)",r,g,b);
            brillo[pixelNr] = rint(fvalue);
        }
    }
    
    
}


void solveHomographie(double **imgPts, double **imgPts2, double *h){
//PUNTO 4 --X: 208.142039
//PUNTO 4 --Y: 231.760118
//PUNTO 5 --X: 208.254415
//PUNTO 5 --Y: 165.749664
//PUNTO 6 --X: 140.647865
//PUNTO 6 --Y: 165.646337
//PUNTO 7 --X: 140.951607
//PUNTO 7 --Y: 232.487685
    
    /*
     imgPts     --->    x,y
     imgPts2    --->    i,j
     */
    double ** A;
    double ** Ainv;
    double * imgPts2mod;
//    double ** imgPts2mod;
    
    
    A=(double **)malloc(8 * sizeof(double *));
    for (int i=0;i<8;i++) A[i]=(double *)malloc(8 * sizeof(double));
    
    Ainv=(double **)malloc(8 * sizeof(double *));
    for (int i=0;i<8;i++) Ainv[i]=(double *)malloc(8 * sizeof(double));
    
//    imgPts2mod=(double **)malloc(8 * sizeof(double *));
//    for (int i=0;i<8;i++) imgPts2mod[i]=(double *)malloc(sizeof(double));
    
    imgPts2mod=(double *)malloc(8 * sizeof(double));
    

    
    
    for (int i=0; i<4; i=i+2) {
        A[i][0]=imgPts[i+4][0];
        A[i][1]=imgPts[i+4][1];
        A[i][2]=1;
        A[i][3]=0;
        A[i][4]=0;
        A[i][5]=0;
        A[i][6]=-imgPts[i+4][0]*imgPts2[i][0];
        A[i][7]=-imgPts[i+4][1]*imgPts2[i][0];
        
        A[i+1][0]=0;
        A[i+1][1]=0;
        A[i+1][2]=0;
        A[i+1][3]=imgPts[i+4][0];
        A[i+1][4]=imgPts[i+4][1];
        A[i+1][5]=1;
        A[i+1][6]=-imgPts[i+4][0]*imgPts2[i][1];
        A[i+1][7]=-imgPts[i+4][1]*imgPts2[i][1];
        
    }
    
    printf("PUNTOS IMAGE POINTS\n");
    printf("PUNTO 4 --X: %f --Y: %f\n",imgPts[4][0],imgPts[4][1]);
    printf("PUNTO 5 --X: %f --Y: %f\n",imgPts[5][0],imgPts[5][1]);
    printf("PUNTO 6 --X: %f --Y: %f\n",imgPts[6][0],imgPts[6][1]);
    printf("PUNTO 7 --X: %f --Y: %f\n",imgPts[7][0],imgPts[7][1]);       
    printf("\n");
    
    printf("PUNTOS INVENTADOS\n");
    printf("PUNTO INV 4 --X: %f --Y: %f\n",imgPts2[0][0],imgPts2[0][1]);
    printf("PUNTO INV 5 --X: %f --Y: %f\n",imgPts2[1][0],imgPts2[1][1]);
    printf("PUNTO INV 6 --X: %f --Y: %f\n",imgPts2[2][0],imgPts2[2][1]);
    printf("PUNTO INV 7 --X: %f --Y: %f\n",imgPts2[3][0],imgPts2[3][1]);    
    printf("\n");
    
    printf("PUNTOS IMAGE POINTS\n");
    printf("A[0][0]= %f A[0][1]= %f A[0][2]= %f A[0][3]= %f A[0][4]= %f A[0][5]= %f A[0][6]= %f A[0][7]= %f\n",A[0][0],A[0][1],A[0][2],A[0][3],A[0][4],A[0][5],A[0][6],A[0][7]);
    printf("A[1][0]= %f A[1][1]= %f A[1][2]= %f A[1][3]= %f A[1][4]= %f A[1][5]= %f A[1][6]= %f A[1][7]= %f\n",A[1][0],A[1][1],A[1][2],A[1][3],A[1][4],A[1][5],A[1][6],A[1][7]);
    printf("\n");
    
    
    PseudoInverseGen(A,8,8,Ainv);
    
    /*
     imgPts2=[i1 j1; i2 j2; i3 j3; i4 j4]           --->    4x2
     imgPts2mod=[i1; j1; i2; j2; i3; j3; i4; j4]    --->    8x1
     
     h = Ainv(8x8) * imgPts2mod(8x1)
     */
    
//    imgPts2mod[0][0]=imgPts2[0][0];
//    imgPts2mod[1][0]=imgPts2[0][1];
//    imgPts2mod[2][0]=imgPts2[1][0];
//    imgPts2mod[3][0]=imgPts2[1][1];
//    imgPts2mod[4][0]=imgPts2[2][0];
//    imgPts2mod[5][0]=imgPts2[2][1];
//    imgPts2mod[6][0]=imgPts2[3][0];
//    imgPts2mod[7][0]=imgPts2[3][1];
    
    printf("inicio asignacion imgPts2mod\n");
    imgPts2mod[0]=imgPts2[0][0];
    imgPts2mod[1]=imgPts2[0][1];
    imgPts2mod[2]=imgPts2[1][0];
    imgPts2mod[3]=imgPts2[1][1];
    imgPts2mod[4]=imgPts2[2][0];
    imgPts2mod[5]=imgPts2[2][1];
    imgPts2mod[6]=imgPts2[3][0];
    imgPts2mod[7]=imgPts2[3][1];
    printf("fin asignacion imgPts2mod\n");
    
  //  matrixProduct(Ainv, 8, imgPts2mod,1, h);
  //  matrixVectorProduct(Ainv,8,imgPts2mod,h);
    
    for (int i=0;i<8;i++) free(A[i]);
    free(A);
    for (int i=0;i<8;i++) free(Ainv[i]);
    free(Ainv);
    //for (int i=0;i<8;i++) free(imgPts2mod[i]);
    free(imgPts2mod);
}


void matrixProduct(double ** A, int rowA, double ** B, int colB, double ** C)
{
    for (int i=0; i<rowA; i++) {
        
        for (int j=0; j<colB; j++) {
            
            for (int k=0; k<rowA; k++) {
                C[i][j]=A[i][k]*B[k][j];
            }
            
        }
        
    }

}

void matrixVectorProduct(double ** A, int rowA, double* B, double* C)
{
    for (int i=0; i<rowA; i++) {
        
       
            
            for (int k=0; k<rowA; k++) {
                C[i]=A[i][k]*B[k];
            }
            
        
        
    }
    
}
