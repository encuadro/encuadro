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
     imgPts     --->    x,y puntos detectados por el filtro
     imgPts2    --->    i,j puntos sinteticos absolutos a partir de los cuales se pretende hacer la transformacion
     */
    double ** A;
    double ** Ainv;
    double * imgPtsmod;
    int j;
    
//Reservo memoria    
    A=(double **)malloc(8 * sizeof(double *));
    for (int i=0;i<8;i++) A[i]=(double *)malloc(8 * sizeof(double));
    
    Ainv=(double **)malloc(8 * sizeof(double *));
    for (int i=0;i<8;i++) Ainv[i]=(double *)malloc(8 * sizeof(double));
    
	imgPtsmod=(double *)malloc(8 * sizeof(double));
    

    
//Asignacion de valores    
    j=0;
    for (int i=0; i<4; i++) {
        
        A[j][0]=imgPts2[i][0];
        A[j][1]=imgPts2[i][1];
        A[j][2]=1;
        A[j][3]=0;
        A[j][4]=0;
        A[j][5]=0;
        A[j][6]=-imgPts2[i][0]*imgPts[i][0];
        A[j][7]=-imgPts2[i][1]*imgPts[i][0];
        
        A[j+1][0]=0;
        A[j+1][1]=0;
        A[j+1][2]=0;
        A[j+1][3]=imgPts2[i][0];
        A[j+1][4]=imgPts2[i][1];
        A[j+1][5]=1;
        A[j+1][6]=-imgPts2[i][0]*imgPts[i][1];
        A[j+1][7]=-imgPts2[i][1]*imgPts[i][1];
        j=j+2;
        
    }

    
    
    /*
     imgPts2=[i1 j1; i2 j2; i3 j3; i4 j4]           --->    4x2
     imgPts2mod=[i1; j1; i2; j2; i3; j3; i4; j4]    --->    8x1
     
     h = Ainv(8x8) * imgPts2mod(8x1)
     */
    imgPtsmod[0]=imgPts[0][0];
    imgPtsmod[1]=imgPts[0][1];
    imgPtsmod[2]=imgPts[1][0];
    imgPtsmod[3]=imgPts[1][1];
    imgPtsmod[4]=imgPts[2][0];
    imgPtsmod[5]=imgPts[2][1];
    imgPtsmod[6]=imgPts[3][0];
    imgPtsmod[7]=imgPts[3][1];
    
    //inicializo h en 0
    for(int i=0;i<8;i++)h[i]=0;

    
//Resuelvo sistema A*h=imgPts2mod 
    PseudoInverseGen(A,8,8,Ainv);
    printf("resultado inside matrixVectorProduct\n");
    matrixVectorProduct(Ainv,8,imgPtsmod,h);

    
//PRINTS     
    printf("PUNTOS IMAGE POINTS\n");
    printf("VECTOR imgPts\n");
    for(int i=0;i<4;i++)
    {
        printf("%f\t",imgPts[i][0]);
        printf("%f\t",imgPts[i][1]);
        printf("\n");
    }
     
     printf("PUNTOS INVENTADOS\n");
    for(int i=0;i<4;i++)
    {
        printf("%f\t",imgPts2[i][0]);
        printf("%f\t",imgPts2[i][1]);
        printf("\n");
    }
    
    printf("Vector imgPtsmod\n");
    for(int i=0;i<8;i++)
    {
        printf("%f\t",imgPtsmod[i]);
        printf("\n");
    }
    
    printf("MATRIZ A\n");
    for(int i=0;i<8;i++)
    {
        for(j=0;j<8;j++)
            printf("%f\t",A[i][j]);
        printf("\n");
    }
    
    
    printf("Vector h\n");
    for(int i=0;i<8;i++)
    {
        printf("%f\t",h[i]);
        printf("\n");
    }
    printf("FIN PRINT\n");
    
    
    
//Libero memoria
    for (int i=0;i<8;i++) free(A[i]);
    free(A);
    
    for (int i=0;i<8;i++) free(Ainv[i]);
    free(Ainv);
    
    free(imgPtsmod);

}

void solveAffineTransformation(double **imgPts, double **imgPts2, double *h){
    //PUNTO 4 --X: 208.142039
    //PUNTO 4 --Y: 231.760118
    //PUNTO 5 --X: 208.254415
    //PUNTO 5 --Y: 165.749664
    //PUNTO 6 --X: 140.647865
    //PUNTO 6 --Y: 165.646337
    //PUNTO 7 --X: 140.951607
    //PUNTO 7 --Y: 232.487685
    
    /*
     imgPts     --->    x,y puntos detectados por el filtro
     imgPts2    --->    i,j puntos sinteticos absolutos a partir de los cuales se pretende hacer la transformacion
     */
    double ** A;
    double ** Ainv;
    double * imgPtsmod;
    int j;
    
    //Reservo memoria    
    A=(double **)malloc(6 * sizeof(double *));
    for (int i=0;i<6;i++) A[i]=(double *)malloc(6 * sizeof(double));
    
    Ainv=(double **)malloc(6 * sizeof(double *));
    for (int i=0;i<6;i++) Ainv[i]=(double *)malloc(6 * sizeof(double));
    
	imgPtsmod=(double *)malloc(6 * sizeof(double));
    
    
    
    //Asignacion de valores    
    j=0;
    for (int i=0; i<3; i++) {
        
        A[j][0]=imgPts2[i][0];
        A[j][1]=imgPts2[i][1];
        A[j][2]=1;
        A[j][3]=0;
        A[j][4]=0;
        A[j][5]=0;
                
        A[j+1][0]=0;
        A[j+1][1]=0;
        A[j+1][2]=0;
        A[j+1][3]=imgPts2[i][0];
        A[j+1][4]=imgPts2[i][1];
        A[j+1][5]=1;
        j=j+2;
        
    }
    
    
    
    /*
     imgPts2=[i1 j1; i2 j2; i3 j3]           --->    3x2
     imgPts2mod=[i1; j1; i2; j2; i3; j3]    --->    6x1
     
     h = Ainv(6x6) * imgPtsmod(6x1)
     */
    imgPtsmod[0]=imgPts[0][0];
    imgPtsmod[1]=imgPts[0][1];
    imgPtsmod[2]=imgPts[1][0];
    imgPtsmod[3]=imgPts[1][1];
    imgPtsmod[4]=imgPts[2][0];
    imgPtsmod[5]=imgPts[2][1];
    
    
    //inicializo h en 0
    for(int i=0;i<6;i++)h[i]=0;
    
    
    //Resuelvo sistema A*h=imgPts2mod 
    PseudoInverseGen(A,6,6,Ainv);
    printf("resultado inside matrixVectorProduct\n");
    matrixVectorProduct(Ainv,6,imgPtsmod,h);
    
    
    //PRINTS     
    printf("PUNTOS IMAGE POINTS\n");
    printf("VECTOR imgPts\n");
    for(int i=0;i<3;i++)
    {
        printf("%f\t",imgPts[i][0]);
        printf("%f\t",imgPts[i][1]);
        printf("\n");
    }
    
    printf("PUNTOS INVENTADOS\n");
    for(int i=0;i<3;i++)
    {
        printf("%f\t",imgPts2[i][0]);
        printf("%f\t",imgPts2[i][1]);
        printf("\n");
    }
    
    printf("Vector imgPtsmod\n");
    for(int i=0;i<6;i++)
    {
        printf("%f\t",imgPtsmod[i]);
        printf("\n");
    }
    
    printf("MATRIZ A\n");
    for(int i=0;i<6;i++)
    {
        for(j=0;j<6;j++)
            printf("%f\t",A[i][j]);
        printf("\n");
    }
    
    
    printf("Vector h\n");
    for(int i=0;i<6;i++)
    {
        printf("%f\t",h[i]);
        printf("\n");
    }
    printf("FIN PRINT\n");
    
    
    
    //Libero memoria
    for (int i=0;i<6;i++) free(A[i]);
    free(A);
    
    for (int i=0;i<6;i++) free(Ainv[i]);
    free(Ainv);
    
    free(imgPtsmod);
    
}

void matrixProduct(double ** A, int rowA, double ** B, int colB, double ** C)
{
    int i,j,k;
    
    for (i=0; i<rowA; i++) {
        
        for (j=0; j<colB; j++) {
            
            for (k=0; k<rowA; k++) {
                C[i][j]+=A[i][k]*B[k][j];
            }
            
        }
        
    }
    
}

void matrixVectorProduct(double ** A, int rowA, double* B, double* C)
{
    int i,k;
    for (i=0; i<rowA; i++) {
        
        
        
        for (k=0; k<rowA; k++) {
            C[i]+=A[i][k]*B[k];
        }
        printf("%f\n",C[i]);
        
        
        
    }
    
}
