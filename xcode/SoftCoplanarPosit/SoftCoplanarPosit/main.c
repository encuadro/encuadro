//
//  main.c
//  SoftCoplanarPosit
//
//  Created by Juan Ignacio Braun on 4/3/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "CoplanarPosit.h"
#include "Composit.h"
#include "SoftPos.h"



#define NUMBER_OF_ROT 17  /*nombre de rotations autour de Ou, premier axe du rep. objet*/
#define NUMBER_OF_TRANS 1 /*nombre de translations suivant Cz, axe optique*/
#define TRANS_MIN 500     /*premiere des translations suivant Cz. Unites du rep. objet*/
#define TRANS_STEP 100    /*increment des translations suivant Cz*/


#define round(a) (x=(a),(fabs(x - ceil(x))) < (fabs(x - floor(x))) ? \
(ceil(x)) : (floor(x)))

int main() /*donnee des points objets, focale et amplitude du bruit*/
{
    int NumberImgPts,NumberWorldPts,i;
    double **object,**objectCrop,f;/*f: longueur focale, en pixels*/
    double **imagePts,**imgPtsCopl,**imgPtsCoplCrop;
    double** rot;
    double* trans;
    double center[2];
    
//    //    Render 480x360
//    float intrinsic[3][3]=  {{586.6381,  0,         240.0000},
//        {0,          586.6381  ,180.0000},
//        {0,          0,          1},
//    };
    
    
    ////    Camara iPod 640x480
    float intrinsic[3][3]=  {{745.43429,  0,         292.80331},
        {0,          746.36170  ,217.56288},
        {0,          0,          1},
    };
    
    f=intrinsic[0][0];
    center[0]=intrinsic[0][2];
    center[1]=intrinsic[1][2];
    

    // Puntos en la imagen
    
    FILE *fp;
    char* num;
    fp = fopen("/Users/juanignaciobraun/Desktop/DataBenchmark/benchmark/iPod/640x480/Caso4/Scale0.8/threshold25/Caso4-PuntosLSD13.txt", "r");
//    fp = fopen("/Users/juanignaciobraun/Desktop/Caso10-Puntos38.txt", "r");
//    fgets(num, 3, fp);
//    NumberImgPts=strtod(num,&num);
    fscanf(fp, "%d\n",&NumberImgPts);
    imagePts=(double **)malloc(NumberImgPts * sizeof(double *));
    for (i=0;i<NumberImgPts;i++)imagePts[i]=(double *)malloc(2 * sizeof(double));

    double c;
    double b;
    for(int i=0; i<NumberImgPts; i++){
        fscanf(fp, "%lf\t %lf\n",&b,&c);
        imagePts[i][0]=b;
        imagePts[i][1]=c;
    }
    fclose(fp);
    
    NumberWorldPts=36;           /*nombre de points utilises: a changer si != 10*/
    
    /* allocation */
    object=(double **)malloc(NumberWorldPts * sizeof(double *));
    for (i=0;i<NumberWorldPts;i++) object[i]=(double *)malloc(3 * sizeof(double));
    
     
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
    
//    objectCrop=(double **)malloc(NumberWorldPts * sizeof(double *));
//    for (i=0;i<NumberWorldPts;i++) objectCrop[i]=(double *)malloc(3 * sizeof(double));
//
//    
//    fp = fopen("/Users/juanignaciobraun/Desktop/benchmark/iPod/640x480/Caso10/Scale0.8/threshold25/Caso10-PuntosFiltro2.txt", "r");
//    //    fp = fopen("/Users/juanignaciobraun/Desktop/Caso10-Puntos38.txt", "r");
//    //    fgets(num, 3, fp);
//    //    NumberImgPts=strtod(num,&num);
//    imgPtsCopl=(double **)malloc(NumberWorldPts * sizeof(double *));
//    for (i=0;i<NumberWorldPts;i++)imgPtsCopl[i]=(double *)malloc(2 * sizeof(double));
//    
//    imgPtsCoplCrop=(double **)malloc(NumberWorldPts * sizeof(double *));
//    for (i=0;i<NumberWorldPts;i++)imgPtsCoplCrop[i]=(double *)malloc(2 * sizeof(double));
//    
//    for(int i=0; i<NumberWorldPts; i++){
//        fscanf(fp, "%lf\t %lf\n",&b,&c);
//        imgPtsCopl[i][0]=b;
//        imgPtsCopl[i][1]=c;
//    }
//    fclose(fp);
//
//    getCropLists(imgPtsCopl, object, imgPtsCoplCrop, objectCrop);
    
    rot=(double**)malloc(3*sizeof(double*));
    for (i=0; i<3; i++) rot[i]=(double*)malloc(3*sizeof(double));
    
    trans=(double*)malloc(3*sizeof(double));

    double** initRot;
    initRot=(double**)malloc(3*sizeof(double*));
    for (i=0; i<3; i++) initRot[i]=(double*)malloc(3*sizeof(double));

    double angles[3],anglesB[3];
    
    double beta0=0.005;
    double noiseStd=1.2;

    
    
    angles[0]=10.3107;
    angles[1]=47.8372;
    angles[2]=97.1375;

    double initTrans[3]; 	 
        
    initTrans[0]=44.9748;
    initTrans[1]=78.9796;
    initTrans[2]=984.7806;
    
    Euler2Matrix(angles, initRot);

    printf("rot:\n");
    printf("%f\t %f\t %f\n",initRot[0][0],initRot[0][1],initRot[0][2]);
    printf("%f\t %f\t %f\n",initRot[1][0],initRot[1][1],initRot[1][2]);
    printf("%f\t %f\t %f\n",initRot[2][0],initRot[2][1],initRot[2][2]);


//  
//    CoplanarPosit(NumberImgPts, imgPtsCoplCrop, objectCrop, f,center, rot,trans);
//    printf("rot:\n");
//    printf("%f\t %f\t %f\n",rot[0][0],rot[0][1],rot[0][2]);
//    printf("%f\t %f\t %f\n",rot[1][0],rot[1][1],rot[1][2]);
//    printf("%f\t %f\t %f\n",rot[2][0],rot[2][1],rot[2][2]);
//    
//    printf("trans:\n");
//    printf("%f\t %f\t %f\n",trans[0],trans[1],trans[2]);
//    printf("\n");
//
//    
//    for(i=0;i<NumberOfPoints;i++){
//        imagePts[i][0]-=center[0];
//        imagePts[i][1]-=center[1];
//        
//    }
//    Composit(NumberOfPoints,imagePts,object, f,rot, trans);
    
//    printf("rot:\n");
//    printf("%f\t %f\t %f\n",rot[0][0],rot[0][1],rot[0][2]);
//    printf("%f\t %f\t %f\n",rot[1][0],rot[1][1],rot[1][2]);
//    printf("%f\t %f\t %f\n",rot[2][0],rot[2][1],rot[2][2]);
//    
//    printf("trans:\n");
//    printf("%f\t %f\t %f\n",trans[0],trans[1],trans[2]);
    
    
    softPositCopl(imagePts, NumberImgPts, object,NumberWorldPts,beta0, noiseStd, initRot, initTrans,f, center,rot, trans);
    
    Matrix2Euler(rot, angles, anglesB);
    printf("rot:\n");
    printf("%f\t %f\t %f\n",rot[0][0],rot[0][1],rot[0][2]);
    printf("%f\t %f\t %f\n",rot[1][0],rot[1][1],rot[1][2]);
    printf("%f\t %f\t %f\n",rot[2][0],rot[2][1],rot[2][2]);
    
    printf("angulos:\n");
    printf("%f\t %f\t %f\n",angles[0],angles[1],angles[2]);
    
    printf("trans:\n");
    printf("%f\t %f\t %f\n",trans[0],trans[1],trans[2]);
    
}



