//
//  homografia.c
//  app0100
//
//  Created by Pablo Flores Guridi on 16/02/13.
//
//

#include <stdio.h>
#include "homografia.h"

/*--------------------------------------Funciones para homografia 2D-------------------------------------*/
void solveHomographie(float **imgPts, float **imgPts2, float *h){
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
    float ** A;
    float ** Ainv;
    float * imgPtsmod;
    int j;
    
    //Reservo memoria
    A=(float **)malloc(8 * sizeof(float *));
    for (int i=0;i<8;i++) A[i]=(float *)malloc(8 * sizeof(float));
    
    Ainv=(float **)malloc(8 * sizeof(float *));
    for (int i=0;i<8;i++) Ainv[i]=(float *)malloc(8 * sizeof(float));
    
	imgPtsmod=(float *)malloc(8 * sizeof(float));
    
    
    
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
    //  printf("resultado inside matrixVectorProduct\n");
    matrixVectorProduct(Ainv,8,imgPtsmod,h);
    
    
    //    //PRINTS
    //    printf("PUNTOS IMAGE POINTS\n");
    //    printf("VECTOR imgPts\n");
    //    for(int i=0;i<4;i++)
    //    {
    //        printf("%f\t",imgPts[i][0]);
    //        printf("%f\t",imgPts[i][1]);
    //        printf("\n");
    //    }
    //
    //    printf("PUNTOS INVENTADOS\n");
    //    for(int i=0;i<4;i++)
    //    {
    //        printf("%f\t",imgPts2[i][0]);
    //        printf("%f\t",imgPts2[i][1]);
    //        printf("\n");
    //    }
    //
    //    printf("Vector imgPtsmod\n");
    //    for(int i=0;i<8;i++)
    //    {
    //        printf("%f\t",imgPtsmod[i]);
    //        printf("\n");
    //    }
    //
    //    printf("MATRIZ A\n");
    //    for(int i=0;i<8;i++)
    //    {
    //        for(j=0;j<8;j++)
    //            printf("%f\t",A[i][j]);
    //        printf("\n");
    //    }
    //
    //
    //    printf("Vector h\n");
    //    for(int i=0;i<8;i++)
    //    {
    //        printf("%f\t",h[i]);
    //        printf("\n");
    //    }
    //    printf("FIN PRINT\n");
    
    
    
    //Libero memoria
    for (int i=0;i<8;i++) free(A[i]);
    free(A);
    
    for (int i=0;i<8;i++) free(Ainv[i]);
    free(Ainv);
    
    free(imgPtsmod);
    
}

void solveAffineTransformation(float **imgPts, float **imgPts2, float *h){
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
    float ** A;
    float ** Ainv;
    float * imgPtsmod;
    int j;
    
    //Reservo memoria
    A=(float **)malloc(6 * sizeof(float *));
    for (int i=0;i<6;i++) A[i]=(float *)malloc(6 * sizeof(float));
    
    Ainv=(float **)malloc(6 * sizeof(float *));
    for (int i=0;i<6;i++) Ainv[i]=(float *)malloc(6 * sizeof(float));
    
	imgPtsmod=(float *)malloc(6 * sizeof(float));
    
    
    
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
    //    printf("PUNTOS IMAGE POINTS\n");
    //    printf("VECTOR imgPts\n");
    //    for(int i=0;i<3;i++)
    //    {
    //        printf("%f\t",imgPts[i][0]);
    //        printf("%f\t",imgPts[i][1]);
    //        printf("\n");
    //    }
    //
    //    printf("PUNTOS INVENTADOS\n");
    //    for(int i=0;i<3;i++)
    //    {
    //        printf("%f\t",imgPts2[i][0]);
    //        printf("%f\t",imgPts2[i][1]);
    //        printf("\n");
    //    }
    //
    //    printf("Vector imgPtsmod\n");
    //    for(int i=0;i<6;i++)
    //    {
    //        printf("%f\t",imgPtsmod[i]);
    //        printf("\n");
    //    }
    //
    //    printf("MATRIZ A\n");
    //    for(int i=0;i<6;i++)
    //    {
    //        for(j=0;j<6;j++)
    //            printf("%f\t",A[i][j]);
    //        printf("\n");
    //    }
    //
    //
    //    printf("Vector h\n");
    //    for(int i=0;i<6;i++)
    //    {
    //        printf("%f\t",h[i]);
    //        printf("\n");
    //    }
    //    printf("FIN PRINT\n");
    
    
    
    //Libero memoria
    for (int i=0;i<6;i++) free(A[i]);
    free(A);
    
    for (int i=0;i<6;i++) free(Ainv[i]);
    free(Ainv);
    
    free(imgPtsmod);
    
}


void solveHomographiePro(float **imgPts, float **imgPts2, float *h){
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
    float ** A;
    float ** Ainv;
    float * imgPtsmod;
    int j;
    
    //Reservo memoria
    A=(float **)malloc(24 * sizeof(float *));
    for (int i=0;i<24;i++) A[i]=(float *)malloc(8 * sizeof(float));
    
    Ainv=(float **)malloc(24 * sizeof(float *));
    for (int i=0;i<24;i++) Ainv[i]=(float *)malloc(8 * sizeof(float));
    
	imgPtsmod=(float *)malloc(24 * sizeof(float));
    
    
    
    //Asignacion de valores
    j=0;
    for (int i=0; i<12; i++) {
        
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
    
    imgPtsmod[8]=imgPts[4][0];
    imgPtsmod[9]=imgPts[4][1];
    imgPtsmod[10]=imgPts[5][0];
    imgPtsmod[12]=imgPts[5][1];
    imgPtsmod[12]=imgPts[6][0];
    imgPtsmod[13]=imgPts[6][1];
    imgPtsmod[14]=imgPts[7][0];
    imgPtsmod[15]=imgPts[7][1];
    
    imgPtsmod[16]=imgPts[8][0];
    imgPtsmod[17]=imgPts[8][1];
    imgPtsmod[18]=imgPts[9][0];
    imgPtsmod[19]=imgPts[9][1];
    imgPtsmod[20]=imgPts[10][0];
    imgPtsmod[21]=imgPts[10][1];
    imgPtsmod[22]=imgPts[11][0];
    imgPtsmod[23]=imgPts[11][1];
    
    //inicializo h en 0
    for(int i=0;i<24;i++)h[i]=0;
    
    
    //Resuelvo sistema A*h=imgPts2mod
    PseudoInverseGen(A,24,8,Ainv);
    //  printf("resultado inside matrixVectorProduct\n");
    matrixVectorProduct(Ainv,24,imgPtsmod,h);
    
    
    //    //PRINTS
    //    printf("PUNTOS IMAGE POINTS\n");
    //    printf("VECTOR imgPts\n");
    //    for(int i=0;i<4;i++)
    //    {
    //        printf("%f\t",imgPts[i][0]);
    //        printf("%f\t",imgPts[i][1]);
    //        printf("\n");
    //    }
    //
    //    printf("PUNTOS INVENTADOS\n");
    //    for(int i=0;i<4;i++)
    //    {
    //        printf("%f\t",imgPts2[i][0]);
    //        printf("%f\t",imgPts2[i][1]);
    //        printf("\n");
    //    }
    //
    //    printf("Vector imgPtsmod\n");
    //    for(int i=0;i<8;i++)
    //    {
    //        printf("%f\t",imgPtsmod[i]);
    //        printf("\n");
    //    }
    //
    printf("MATRIZ A\n");
    for(int i=0;i<24;i++)
    {
        for(j=0;j<8;j++)
            printf("%f\t",A[i][j]);
        printf("\n");
    }
    //
    //
    //    printf("Vector h\n");
    //    for(int i=0;i<8;i++)
    //    {
    //        printf("%f\t",h[i]);
    //        printf("\n");
    //    }
    //    printf("FIN PRINT\n");
    
    
    
    //Libero memoria
    for (int i=0;i<24;i++) free(A[i]);
    free(A);
    
    for (int i=0;i<24;i++) free(Ainv[i]);
    free(Ainv);
    
    free(imgPtsmod);
    
}


void matrixProduct(float ** A, int rowA, float ** B, int colB, float ** C)
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

void matrixVectorProduct(float ** A, int rowA, float* B, float* C)
{
    int i,k;
    for (i=0; i<rowA; i++) {
        
        
        
        for (k=0; k<rowA; k++) {
            C[i]+=A[i][k]*B[k];
        }
        // printf("%f\n",C[i]);
        
        
        
    }
    
}

