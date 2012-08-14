#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "Composit.h"
#include "SoftPosit.h"

#define NUMBER_OF_ROT 17  /*nombre de rotations autour de Ou, premier axe du rep. objet*/
#define NUMBER_OF_TRANS 1 /*nombre de translations suivant Cz, axe optique*/
#define TRANS_MIN 500     /*premiere des translations suivant Cz. Unites du rep. objet*/
#define TRANS_STEP 100    /*increment des translations suivant Cz*/

static double x;

#define round(a) (x=(a),(fabs(x - ceil(x))) < (fabs(x - floor(x))) ? \
(ceil(x)) : (floor(x)))

/*******************************************************************************************************/
int main() /*donnee des points objets, focale et amplitude du bruit*/
{
    long int NumberOfPoints,i;
    double **object,f=1.912676038879050e+03;/*f: longueur focale, en pixels*/
    double **imagePts;
    double **coplMatrix;    
    double Rot1[3][3],Trans1[3],Rot2[3][3],Trans2[3];
    double *nbsol;
    /*ampl_noise: amplitude pour le generateur aleatoire uniforme de bruit:*/
    /*0.0->bruit de quantification seul*/
    /*1.0->+ ou - 1 pixel en plus => ecart jusqu'a 1.5 pixel*/
    /*2.0->+ ou - 2 pixel en plus => ecart jusqu'a 2.5 pixel*/
    
    
    NumberOfPoints=8;           /*nombre de points utilises: a changer si != 10*/
    
    /* allocation */
    object=(double **)malloc(8 * sizeof(double *));
    for (i=0;i<NumberOfPoints;i++) object[i]=(double *)malloc(3 * sizeof(double));
    
    imagePts=(double **)malloc(7 * sizeof(double *));
    for (i=0;i<NumberOfPoints;i++)imagePts[i]=(double *)malloc(2 * sizeof(double));
    
    coplMatrix=(double **)malloc(3 * sizeof(double *));
    for (i=0;i<3;i++) coplMatrix[i]=(double *)malloc(NumberOfPoints * sizeof(double));
    
    /*10 points "aleatoirement" repartis a la main dans ce meme carre (dont deux sommets)*/
    //object[0][0]=5.0;
    //object[0][1]=10.0;
    //object[0][2]=-15.0;
    //
    //object[1][0]=-5.0;
    //object[1][1]=10.0;
    //object[1][2]=-15.0;
    //
    //object[2][0]=-5.0;
    //object[2][1]=-10.0;
    //object[2][2]=-15.0;
    //
    //object[3][0]=5.0;
    //object[3][1]=-10.0;
    //object[3][2]=-15.0;
    //
    //    
    //    imagePts[0][0]=695.789507514584-512.5;
    //imagePts[0][1]=394.660721029837-512.5;
    //
    //    imagePts[1][0]=566.637629377669-512.5;
    //imagePts[1][1]=371.372464388385-512.5;
    //
    //    imagePts[2][0]=612.760214007138-512.5;
    //imagePts[2][1]=110.682091483785-512.5;
    //
    //    imagePts[3][0]=741.969585508370-512.5;
    //imagePts[3][1]=134.973754219845-512.5;
    //        
    //Composit(NumberOfPoints,imagePts,object,f,Rot1,Trans1);    
    //
    //    printf("\nRotacion: \n");
    //    printf("%f\t %f\t %f\n",Rot1[0][0],Rot1[0][1],Rot1[0][2]);
    //    printf("%f\t %f\t %f\n",Rot1[1][0],Rot1[1][1],Rot1[1][2]);
    //    printf("%f\t %f\t %f\n",Rot1[2][0],Rot1[2][1],Rot1[2][2]);
    //    printf("Traslacion: \n");
    //    printf("%f\t %f\t %f\n",Trans1[0],Trans1[1],Trans1[2]);
    //
    //}
    
    
    object[0][0]=-0.5000;
    object[0][1]=-0.5000;
    object[0][2]=-0.5000;
    object[1][0]=0.5000;   
    object[1][1]=-0.5000;
    object[1][2]=-0.5000;
    object[2][0]=0.5000;
    object[2][1]=0.5000;
    object[2][2]=-0.5000;
    object[3][0]=-0.5000; 
    object[3][1]=0.5000;   
    object[3][2]=-0.5000;
    object[4][0]=-0.5000;
    object[4][1]=-0.5000;
    object[4][2]=0.5000;
    object[5][0]=0.5000;
    object[5][1]=-0.5000;
    object[5][2]=0.5000;
    object[6][0]=0.5000;
    object[6][1]=0.5000;
    object[6][2]=0.5000;
    object[7][0]=-0.5000;
    object[7][1]=0.5000;
    object[7][2]=0.5000;
    
    
    imagePts[0][0]=172.3829;  
    imagePts[0][1]=-15.4229;
    imagePts[1][0]=174.9147;
    imagePts[1][1]=-183.8248;
    imagePts[2][0]=-28.3942;
    imagePts[2][1]=-147.8052;
    imagePts[3][0]=243.2142;
    imagePts[3][1]=105.4463;
    imagePts[4][0]=252.6934;
    imagePts[4][1]=-72.3310;
    imagePts[5][0]=25.7430;
    imagePts[5][1]=-28.9218;
    imagePts[6][0]=35.9377;
    imagePts[6][1]=149.1948;
    
    double beta0=0.0002;
    int nbImagePts=7;
    int nbWorldPts=8;
    double noiseStd=0;
    double initRot[3][3];
    
    initRot[0][0] = 0.9149;    
    initRot[0][1] = 0.1910;   
    initRot[0][2] = -0.3558;
    initRot[1][0] = -0.2254;
    initRot[1][1] = 0.9726;   
    initRot[1][2] = -0.0577;
    initRot[2][0] = 0.3350;    
    initRot[2][1] = 0.1330;
    initRot[2][2] = 0.9328;
    
    double initTrans[3];
    initTrans[0]=0;
    initTrans[1]=0;
    initTrans[2]=50;
    
    double focalLength=1500;
    double** rot;
    rot=(double**)malloc(3*sizeof(double*));        
    for (i=0; i<3; i++) rot[i]=(double*)malloc(3*sizeof(double));
    
    
    double* trans;
    trans=(double*)malloc(3*sizeof(double));
    
    int center[2];
    center[0]=0;
    center[1]=0;
    
    softPosit(imagePts, nbImagePts, object, nbWorldPts,beta0,noiseStd, initRot, initTrans,focalLength, center,rot, trans);
    printf("rot:\n");
    printf("%f\t %f\t %f\n",rot[0][0],rot[0][1],rot[0][2]);
    printf("%f\t %f\t %f\n",rot[1][0],rot[1][1],rot[1][2]);
    printf("%f\t %f\t %f\n",rot[2][0],rot[2][1],rot[2][2]);
    
    printf("trans:\n");
    printf("%f\t %f\t %f\n",trans[0],trans[1],trans[2]);
}



