//
//  main.c
//  benchmarkPosit
//
//  Created by Juan Ignacio Braun on 9/25/12.
//  Copyright (c) 2012 Juan Ignacio Braun. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "sys/stat.h"
#include "CoplanarPosit.h"  
#include "Composit.h"
#include "vvector.h"

int main(int argc, const char * argv[])
{
    
    /*================================================================*/
    /*===============directorios para guardar datos===================*/
    /*================================================================*/
    
    char folderName[100];
    sprintf(folderName, "%s",argv[1]);
//    mkdir(folderName,S_IRWXU);
    
    /*================================================================*/
    
    
    double** angles;
    double** traslations;
    int numPoses;
    int k=0;
    int i=0;

    
    char fileName[100];
    sprintf(fileName,"%s%s",argv[1],"poses.txt");
    FILE *fp;
    
    fp = fopen(fileName,"r");

    angles=malloc(1 * sizeof(double*)); /* give the pointer some memory */
    angles[0]=(double *)malloc(3 * sizeof(double));
    
    traslations=malloc(1 * sizeof(double*)); /* give the pointer some memory */
    traslations[0]=(double *)malloc(3 * sizeof(double));
    
    while (k!=EOF) {
        
        k=fscanf(fp, "%lf %lf %lf %lf %lf %lf\n",&angles[i][0],&angles[i][1],&angles[i][2],&traslations[i][0],&traslations[i][1],&traslations[i][2]);
           
        if (k!=EOF) {
            i++;
            
            angles=realloc(angles,(i+1) * sizeof(double*)); /* give the pointer some memory */
            angles[i]=(double *)malloc(3 * sizeof(double));
            
            traslations=realloc(traslations,(i+1) * sizeof(double*)); /* give the pointer some memory */
            traslations[i]=(double *)malloc(3 * sizeof(double));
        }
        

    }
    fclose(fp);
    numPoses=i;
//    for (k=0; k<numPoses; k++) {
//        printf("%4.4f %4.4f %4.4f %4.4f %4.4f %4.4f\n",angles[k][0],angles[k][1],angles[k][2],traslations[k][0],traslations[k][1],traslations[k][2]);
//    }
    
    
    //    Render 480x360
    float intrinsic[3][3]=  {{586.6381,  0,         240.0000},
        {0,          586.6381  ,180.0000},
        {0,          0,          1},
    };
    
//    //    iPod 640x480
//    float intrinsic[3][3]=  {{745.43429,  0,         292.80331},
//        {0,          746.36170  ,217.56288},
//        {0,          0,          1},
//    };
    
    double f=intrinsic[0][0];
    double center[2];
    center[0]=intrinsic[0][2];
    center[1]=intrinsic[1][2];

    
    /*Reservamos memoria para pose*/
    double** RotIn;
    RotIn=(double **)malloc(3 * sizeof(double *));
    for (k=0;k<3;k++) RotIn[k]=(double *)malloc(3 * sizeof(double));
    double* TrasIn;
    TrasIn=(double *)malloc(3 * sizeof(double));

    double** Rot;
    Rot=(double **)malloc(3 * sizeof(double *));
    for (k=0;k<3;k++) Rot[k]=(double *)malloc(3 * sizeof(double));
    double* Tras;
    Tras=(double *)malloc(3 * sizeof(double));
    
    double** Rot4Composit;
    Rot4Composit=(double **)malloc(3 * sizeof(double *));
    for (k=0;k<3;k++) Rot4Composit[k]=(double *)malloc(3 * sizeof(double));
    double* Trans4Composit;
    Trans4Composit=(double *)malloc(3 * sizeof(double));

    
    int NumberOfPoints=36;
    
    /*Reservo memoria para imagePoints*/
    double** imagePoints;
    imagePoints=(double **)malloc(NumberOfPoints*sizeof(double*));
    for(i=0;i<NumberOfPoints;i++)imagePoints[i]=(double*)malloc(2*sizeof(double));
    
    /*Reservo memoria para imagePioints4Composit*/
    double** imagePoints4Composit;
    imagePoints4Composit=(double **)malloc(NumberOfPoints*sizeof(double*));
    for(i=0;i<NumberOfPoints;i++)imagePoints4Composit[i]=(double*)malloc(2*sizeof(double));
    
    
    /*Reservamos memoria para marcador*/
    double** object;
    object=(double **)malloc(NumberOfPoints * sizeof(double *));
    for (k=0;k<NumberOfPoints;k++) object[k]=(double *)malloc(3 * sizeof(double));
    
    /*================================================================*/
    /*==================Inicializo marcador===========================*/
    /*================================================================*/
    /* BEGIN MARKER */
    //QlSet0
    object[0][0] = 15;
    object[0][1] = 15;
    object[0][2] = 0;
    object[1][0] = 15;
    object[1][1] = -15;
    object[1][2] = 0;
    object[2][0] = -15;
    object[2][1] = -15;
    object[2][2] = 0;
    object[3][0] = -15;
    object[3][1] = 15;
    object[3][2] = 0;
    object[4][0] = 30;
    object[4][1] = 30;
    object[4][2] = 0;
    object[5][0] = 30;
    object[5][1] = -30;
    object[5][2] = 0;
    object[6][0] = -30;
    object[6][1] = -30;
    object[6][2] = 0;
    object[7][0] = -30;
    object[7][1] = 30;
    object[7][2] = 0;
    object[8][0] = 45;
    object[8][1] = 45;
    object[8][2] = 0;
    object[9][0] = 45;
    object[9][1] = -45;
    object[9][2] = 0;
    object[10][0] = -45;
    object[10][1] = -45;
    object[10][2] = 0;
    object[11][0] = -45;
    object[11][1] = 45;
    object[11][2] = 0;
    //QlSet1
    object[12][0] = 205;
    object[12][1] = 15;
    object[12][2] = 0;
    object[13][0] = 205;
    object[13][1] = -15;
    object[13][2] = 0;
    object[14][0] = 175;
    object[14][1] = -15;
    object[14][2] = 0;
    object[15][0] = 175;
    object[15][1] = 15;
    object[15][2] = 0;
    object[16][0] = 220;
    object[16][1] = 30;
    object[16][2] = 0;
    object[17][0] = 220;
    object[17][1] = -30;
    object[17][2] = 0;
    object[18][0] = 160;
    object[18][1] = -30;
    object[18][2] = 0;
    object[19][0] = 160;
    object[19][1] = 30;
    object[19][2] = 0;
    object[20][0] = 235;
    object[20][1] = 45;
    object[20][2] = 0;
    object[21][0] = 235;
    object[21][1] = -45;
    object[21][2] = 0;
    object[22][0] = 145;
    object[22][1] = -45;
    object[22][2] = 0;
    object[23][0] = 145;
    object[23][1] = 45;
    object[23][2] = 0;
    //QlSet2
    object[24][0] = 15;
    object[24][1] = 115;
    object[24][2] = 0;
    object[25][0] = 15;
    object[25][1] = 85;
    object[25][2] = 0;
    object[26][0] = -15;
    object[26][1] = 85;
    object[26][2] = 0;
    object[27][0] = -15;
    object[27][1] = 115;
    object[27][2] = 0;
    object[28][0] = 30;
    object[28][1] = 130;
    object[28][2] = 0;
    object[29][0] = 30;
    object[29][1] = 70;
    object[29][2] = 0;
    object[30][0] = -30;
    object[30][1] = 70;
    object[30][2] = 0;
    object[31][0] = -30;
    object[31][1] = 130;
    object[31][2] = 0;
    object[32][0] = 45;
    object[32][1] = 145;
    object[32][2] = 0;
    object[33][0] = 45;
    object[33][1] = 55;
    object[33][2] = 0;
    object[34][0] = -45;
    object[34][1] = 55;
    object[34][2] = 0;
    object[35][0] = -45;
    object[35][1] = 145;
    object[35][2] = 0;
    /* END MARKER*/
    
    /*================================================================*/

    
    /*Guardo en archivo poses*/
    FILE *poses_coplanar;
    char poseName[150];
    sprintf(poseName, "%s%s",folderName,"poses_coplanar_scale.txt");
    poses_coplanar=fopen(poseName, "w");
    FILE *poses_composit;
    sprintf(poseName, "%s%s",folderName,"poses_composit_scale.txt");
    poses_composit=fopen(poseName, "w");

    
    for (i=0; i<numPoses; i++) {
        
        Euler2Matrix(angles[i], RotIn);
        TrasIn=traslations[i];
        /*project CoplanarPosit*/
        float a[3],b[3];
        for (int j=0; j<NumberOfPoints; j++) {
            b[0]=object[j][0];
            b[1]=object[j][1];
            b[2]=object[j][2];
            MAT_DOT_VEC_3X3(a, RotIn, b);
            VEC_SUM(b,a,TrasIn);
            imagePoints[j][0]=intrinsic[0][2]+intrinsic[0][0]*b[0]/b[2];
            imagePoints[j][1]=intrinsic[1][2]+intrinsic[1][1]*b[1]/b[2];
        }
        
        CoplanarPosit(NumberOfPoints, imagePoints, object,f, center, Rot, Tras);
        
        for (int j=0;j<NumberOfPoints;j++){
            imagePoints4Composit[j][0]=imagePoints[j][0]-center[0];
            imagePoints4Composit[j][1]=imagePoints[j][1]-center[1];
            
        }
        
        Composit(NumberOfPoints, imagePoints4Composit, object, f,Rot4Composit , Trans4Composit);
        
        printf("\nRotacion In: \n");
        printf("%f\t %f\t %f\n",RotIn[0][0],RotIn[0][1],RotIn[0][2]);
        printf("%f\t %f\t %f\n",RotIn[1][0],RotIn[1][1],RotIn[1][2]);
        printf("%f\t %f\t %f\n",RotIn[2][0],RotIn[2][1],RotIn[2][2]);
        printf("Traslacion Coplanar: \n");
        printf("%f\t %f\t %f\n",TrasIn[0],TrasIn[1],TrasIn[2]);
        
        printf("\nRotacion Coplanar: \n");
        printf("%f\t %f\t %f\n",Rot[0][0],Rot[0][1],Rot[0][2]);
        printf("%f\t %f\t %f\n",Rot[1][0],Rot[1][1],Rot[1][2]);
        printf("%f\t %f\t %f\n",Rot[2][0],Rot[2][1],Rot[2][2]);
        printf("Traslacion Coplanar: \n");
        printf("%f\t %f\t %f\n",Tras[0],Tras[1],Tras[2]);
        
        printf("\nRotacion Composit: \n");
        printf("%f\t %f\t %f\n",Rot4Composit[0][0],Rot4Composit[0][1],Rot4Composit[0][2]);
        printf("%f\t %f\t %f\n",Rot4Composit[1][0],Rot4Composit[1][1],Rot4Composit[1][2]);
        printf("%f\t %f\t %f\n",Rot4Composit[2][0],Rot4Composit[2][1],Rot4Composit[2][2]);
        printf("Traslacion Composit: \n");
        printf("%f\t %f\t %f\n",Trans4Composit[0],Trans4Composit[1],Trans4Composit[2]);
        
        double angles1[3],angles2[3];
        Matrix2Euler(Rot,angles1,angles2);
        fprintf(poses_coplanar, "%4.4f %4.4f %4.4f %4.4f %4.4f %4.4f\n",angles1[0],angles1[1],angles1[2],Tras[0],Tras[1],Tras[2]);
        
        printf("\nPrimera solicion\n");
        printf("psi1: %g\ntheta1: %g\nphi1: %g\n",angles1[0],angles1[1],angles1[2]);
        
        Matrix2Euler(Rot4Composit,angles1,angles2);
        fprintf(poses_composit, "%4.4f %4.4f %4.4f %4.4f %4.4f %4.4f\n",angles1[0],angles1[1],angles1[2],Trans4Composit[0],Trans4Composit[1],Trans4Composit[2]);

        printf("\nPrimera solicion\n");
        printf("psi1: %g\ntheta1: %g\nphi1: %g\n",angles1[0],angles1[1],angles1[2]);


    }
    fclose(poses_coplanar);
    fclose(poses_composit);

    
}

