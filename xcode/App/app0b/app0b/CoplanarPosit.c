//
//  CoplanarPosit.c
//  ModernCoplanarPosit
//
//  Created by Juan Ignacio Braun on 5/14/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>
#include "svd.h"
#include "CoplanarPosit.h"


void CoplanarPosit(int NbPts, double **imgPts, double** worldPts, double focalLength, double center[2], double** Rot, double* Trans){
    

    long int i,j;
    double** Rot1;
    double** Rot2;
    double** RotFinal1;
    double** RotFinal2;
    double* TransFinal1;
    double* TransFinal2;
    double  E1,Ehvmax1,E2,Ehvmax2;
    long int Ep1,Ep2;
    


    /* allocation for Rot1*/ 
    Rot1=(double **)malloc(3* sizeof(double *));
    for (i=0;i<3;i++) Rot1[i]=(double *)malloc(3 * sizeof(double));
    /* end alloc*/ 
    
    /* allocation for Rot2*/ 
    Rot2=(double **)malloc(3* sizeof(double *));
    for (i=0;i<3;i++) Rot2[i]=(double *)malloc(3 * sizeof(double));
    /* end alloc*/ 
    
    /* allocation for RotFinal1*/ 
    RotFinal1=(double **)malloc(3* sizeof(double *));
    for (i=0;i<3;i++) RotFinal1[i]=(double *)malloc(3 * sizeof(double));
    /* end alloc*/ 
    
    /* allocation for RotFinal2*/ 
    RotFinal2=(double **)malloc(3* sizeof(double *));
    for (i=0;i<3;i++) RotFinal2[i]=(double *)malloc(3 * sizeof(double));
    /* end alloc*/ 
    
    /* allocation for TransFinal1*/ 
    TransFinal1=(double *)malloc(3* sizeof(double));
    /* end alloc*/ 
    
    /* allocation for TransFinal2*/ 
    TransFinal2=(double *)malloc(3* sizeof(double));
    /* end alloc*/ 


    
    /* allocation for homogeneousWorldPts*/ 
    double** homogeneousWorldPts;
    homogeneousWorldPts=(double **)malloc(NbPts* sizeof(double *));
    for (i=0;i<NbPts;i++) homogeneousWorldPts[i]=(double *)malloc(4 * sizeof(double));
    /* end alloc*/ 
    
    /* Homogeneus world points -  append a 1 to each 3-vector. An Nx4 matrix.*/
    for (i=0;i<NbPts;i++){
        homogeneousWorldPts[i][0] = worldPts[i][0];
        homogeneousWorldPts[i][1] = worldPts[i][1];
        homogeneousWorldPts[i][2] = worldPts[i][2];
        homogeneousWorldPts[i][3] = 1;
    }
    
    
    /* allocation for centeredImage*/
    double** centeredImage;
    centeredImage=(double**)malloc(NbPts*sizeof(double*));
    for (i=0; i<NbPts; i++) centeredImage[i]=(double*)malloc(2*sizeof(double));
    /* end alloc*/   
    
    for (i=0;i<NbPts;i++){
         centeredImage[i][0]=(imgPts[i][0]-center[0])/focalLength;
         centeredImage[i][1]=(imgPts[i][1]-center[1])/focalLength;
        
    }
    
    
    /* objectMat alloc*/
    double** objectMat;
    objectMat=(double **)malloc(4 * sizeof(double*));
    for (i=0; i<4; i++) objectMat[i]=(double *)malloc(NbPts* sizeof(double));
    /* end*/
    
    PseudoInverseGen(homogeneousWorldPts,NbPts,4,objectMat);
    
    PositBranches(NbPts, centeredImage, worldPts, objectMat, Rot1, Rot2, Trans);
    
    printf("\nRotacion1 antes de iterar: \n");
    printf("%f\t %f\t %f\n",Rot1[0][0],Rot1[0][1],Rot1[0][2]);
    printf("%f\t %f\t %f\n",Rot1[1][0],Rot1[1][1],Rot1[1][2]);
    printf("%f\t %f\t %f\n",Rot1[2][0],Rot1[2][1],Rot1[2][2]);
    printf("Traslacion: \n");
    printf("%f\t %f\t %f\n",Trans[0],Trans[1],Trans[2]);
    
    printf("\nRotacion2 antes de iterar: \n");
    printf("%f\t %f\t %f\n",Rot2[0][0],Rot2[0][1],Rot2[0][2]);
    printf("%f\t %f\t %f\n",Rot2[1][0],Rot2[1][1],Rot2[1][2]);
    printf("%f\t %f\t %f\n",Rot2[2][0],Rot2[2][1],Rot2[2][2]);
    printf("Traslacion: \n");
    printf("%f\t %f\t %f\n",Trans[0],Trans[1],Trans[2]);
    
    if ((Rot1[0][0])!=2.0) /*pose1 a priori possible*/
    {
        /*printf("\nBranche 1");*/
        PositLoop(NbPts, centeredImage, homogeneousWorldPts, objectMat, focalLength, center,Rot1, Trans, RotFinal1, TransFinal1);     /*ITERATIONS a partir de la premiere pose fournie*/
        /*PosCopl (BRANCHE 1)*/
    }
    
//    printf("\nRotacion: \n");
//    printf("%f\t %f\t %f\n",Rot[0][0],Rot[0][1],Rot[0][2]);
//    printf("%f\t %f\t %f\n",Rot[1][0],Rot[1][1],Rot[1][2]);
//    printf("%f\t %f\t %f\n",Rot[2][0],Rot[2][1],Rot[2][2]);
//    printf("Traslacion: \n");
//    printf("%f\t %f\t %f\n",Trans[0],Trans[1],Trans[2]);
    
    if ((Rot2[0][0])!=2.0) /*pose1 a priori possible*/
    {
        /*printf("\nBranche 2");*/
       PositLoop(NbPts, centeredImage, homogeneousWorldPts, objectMat, focalLength, center, Rot2, Trans, RotFinal2, TransFinal2);        /*ITERATIONS a partir de la premiere pose fournie*/
        /*PosCopl (BRANCHE 2)*/
    }
    
//    printf("\nRotacion: \n");
//    printf("%f\t %f\t %f\n",Rot[0][0],Rot[0][1],Rot[0][2]);
//    printf("%f\t %f\t %f\n",Rot[1][0],Rot[1][1],Rot[1][2]);
//    printf("%f\t %f\t %f\n",Rot[2][0],Rot[2][1],Rot[2][2]);
//    printf("Traslacion: \n");
//    printf("%f\t %f\t %f\n",Trans[0],Trans[1],Trans[2]);
    
    if ((RotFinal1[0][0]!=2)&&(RotFinal2[0][0]!=2))
    {
        ErrorC(NbPts,centeredImage,worldPts,focalLength,center,RotFinal1,TransFinal1,&E1,&Ep1,&Ehvmax1);
        ErrorC(NbPts,centeredImage,worldPts,focalLength,center,RotFinal2,TransFinal2,&E2,&Ep2,&Ehvmax2);
        
        if (E1<E2)
        {
            for (i=0;i<3;i++)
            {
                Trans[i]=TransFinal1[i];
                for (j=0;j<3;j++) Rot[i][j]=RotFinal1[i][j];
            }
        }
        else
        {
            for (i=0;i<3;i++)
            {
                Trans[i]=TransFinal2[i];
                for (j=0;j<3;j++) Rot[i][j]=RotFinal2[i][j];
            }
        }
    }
    
    if ((RotFinal1[0][0]!=2)&&(RotFinal2[0][0]==2))
    {
        /*Error(np,coplImage,copl,fLength,POSITRot1,POSITTrans1,&E1,&Ep1,&Ehvmax1);*/
        /*Error(np,coplImage,copl,fLength,POSITRot2,POSITTrans2,&E2,&Ep2,&Ehvmax2);*/
        /*printf("\nErhvmax1=%f Erhvmax2=%f\n",Ehvmax1,Ehvmax2); */
        for (i=0;i<3;i++)
        {
            Trans[i]=TransFinal1[i];
            for (j=0;j<3;j++) Rot[i][j]=RotFinal1[i][j];
        }
    }
    if ((RotFinal1[0][0]==2)&&(RotFinal2[0][0]!=2))
    {
        /*Error(np,coplImage,copl,fLength,POSITRot1,POSITTrans1,&E1,&Ep1,&Ehvmax1);*/
        /*Error(np,coplImage,copl,fLength,POSITRot2,POSITTrans2,&E2,&Ep2,&Ehvmax2);*/
        /*printf("\nErhvmax1=%f Erhvmax2=%f\n",Ehvmax1,Ehvmax2);*/
        for (i=0;i<3;i++)
        {
            Trans[i]=TransFinal2[i];
            for (j=0;j<3;j++) Rot[i][j]=RotFinal2[i][j];
        }
    }
    
    /* if ((POSITRot1[0][0]==2)&&(POSITRot2[0][0]==2))...CAS A IMPLEMENTER (n'apparait jamais)*/
    
    /*desallocations*/
    for (i=0;i<NbPts;i++) {
        free(homogeneousWorldPts[i]);
        free(centeredImage[i]);
    }
    for (i=0;i<3;i++) {
        free(Rot1[i]);
        free(Rot2[i]);
        free(RotFinal1[i]);
        free(RotFinal2[i]);
    }
    free(TransFinal1);
    free(TransFinal2);
    for (i=0;i<4;i++) free(objectMat[i]);
        
}

void CoplanarPosit4Soft(int NbPts, double **centeredImage, double** homogeneousWorldPts, double focalLength, double center[2], double** Rot, double* Trans){
    
    
    long int i,j;
    double** Rot1;
    double** Rot2;
    double** RotFinal1;
    double** RotFinal2;
    double* TransFinal1;
    double* TransFinal2;
    double  E1,Ehvmax1,E2,Ehvmax2;
    long int Ep1,Ep2;
    
    
    
    /* allocation for Rot1*/ 
    Rot1=(double **)malloc(3* sizeof(double *));
    for (i=0;i<3;i++) Rot1[i]=(double *)malloc(3 * sizeof(double));
    /* end alloc*/ 
    
    /* allocation for Rot2*/ 
    Rot2=(double **)malloc(3* sizeof(double *));
    for (i=0;i<3;i++) Rot2[i]=(double *)malloc(3 * sizeof(double));
    /* end alloc*/ 
    
    /* allocation for RotFinal1*/ 
    RotFinal1=(double **)malloc(3* sizeof(double *));
    for (i=0;i<3;i++) RotFinal1[i]=(double *)malloc(3 * sizeof(double));
    /* end alloc*/ 
    
    /* allocation for RotFinal2*/ 
    RotFinal2=(double **)malloc(3* sizeof(double *));
    for (i=0;i<3;i++) RotFinal2[i]=(double *)malloc(3 * sizeof(double));
    /* end alloc*/ 
    
    /* allocation for TransFinal1*/ 
    TransFinal1=(double *)malloc(3* sizeof(double));
    /* end alloc*/ 
    
    /* allocation for TransFinal2*/ 
    TransFinal2=(double *)malloc(3* sizeof(double));
    /* end alloc*/ 
    
    
    
    /* objectMat alloc*/
    double** objectMat;
    objectMat=(double **)malloc(4 * sizeof(double*));
    for (i=0; i<4; i++) objectMat[i]=(double *)malloc(NbPts* sizeof(double));
    /* end*/
    
    PseudoInverseGen(homogeneousWorldPts,NbPts,4,objectMat);
    
    PositBranches(NbPts, centeredImage, homogeneousWorldPts, objectMat, Rot1, Rot2, Trans);
    
//    printf("\nRotacion1 antes de iterar: \n");
//    printf("%f\t %f\t %f\n",Rot1[0][0],Rot1[0][1],Rot1[0][2]);
//    printf("%f\t %f\t %f\n",Rot1[1][0],Rot1[1][1],Rot1[1][2]);
//    printf("%f\t %f\t %f\n",Rot1[2][0],Rot1[2][1],Rot1[2][2]);
//    printf("Traslacion: \n");
//    printf("%f\t %f\t %f\n",Trans[0],Trans[1],Trans[2]);
//    
//    printf("\nRotacion2 antes de iterar: \n");
//    printf("%f\t %f\t %f\n",Rot2[0][0],Rot2[0][1],Rot2[0][2]);
//    printf("%f\t %f\t %f\n",Rot2[1][0],Rot2[1][1],Rot2[1][2]);
//    printf("%f\t %f\t %f\n",Rot2[2][0],Rot2[2][1],Rot2[2][2]);
//    printf("Traslacion: \n");
//    printf("%f\t %f\t %f\n",Trans[0],Trans[1],Trans[2]);
    
    if ((Rot1[0][0])!=2.0) /*pose1 a priori possible*/
    {
        /*printf("\nBranche 1");*/
        PositLoop(NbPts, centeredImage, homogeneousWorldPts, objectMat, focalLength, center,Rot1, Trans, RotFinal1, TransFinal1);     /*ITERATIONS a partir de la premiere pose fournie*/
        /*PosCopl (BRANCHE 1)*/
    }
    
    //    printf("\nRotacion: \n");
    //    printf("%f\t %f\t %f\n",Rot[0][0],Rot[0][1],Rot[0][2]);
    //    printf("%f\t %f\t %f\n",Rot[1][0],Rot[1][1],Rot[1][2]);
    //    printf("%f\t %f\t %f\n",Rot[2][0],Rot[2][1],Rot[2][2]);
    //    printf("Traslacion: \n");
    //    printf("%f\t %f\t %f\n",Trans[0],Trans[1],Trans[2]);
    
    if ((Rot2[0][0])!=2.0) /*pose1 a priori possible*/
    {
        /*printf("\nBranche 2");*/
        PositLoop(NbPts, centeredImage, homogeneousWorldPts, objectMat, focalLength, center, Rot2, Trans, RotFinal2, TransFinal2);        /*ITERATIONS a partir de la premiere pose fournie*/
        /*PosCopl (BRANCHE 2)*/
    }
    
    //    printf("\nRotacion: \n");
    //    printf("%f\t %f\t %f\n",Rot[0][0],Rot[0][1],Rot[0][2]);
    //    printf("%f\t %f\t %f\n",Rot[1][0],Rot[1][1],Rot[1][2]);
    //    printf("%f\t %f\t %f\n",Rot[2][0],Rot[2][1],Rot[2][2]);
    //    printf("Traslacion: \n");
    //    printf("%f\t %f\t %f\n",Trans[0],Trans[1],Trans[2]);
    
    if ((RotFinal1[0][0]!=2)&&(RotFinal2[0][0]!=2))
    {
        ErrorC(NbPts,centeredImage,homogeneousWorldPts,focalLength,center,RotFinal1,TransFinal1,&E1,&Ep1,&Ehvmax1);
        ErrorC(NbPts,centeredImage,homogeneousWorldPts,focalLength,center,RotFinal2,TransFinal2,&E2,&Ep2,&Ehvmax2);
        
        if (E1<E2)
        {
            for (i=0;i<3;i++)
            {
                Trans[i]=TransFinal1[i];
                for (j=0;j<3;j++) Rot[i][j]=RotFinal1[i][j];
            }
        }
        else
        {
            for (i=0;i<3;i++)
            {
                Trans[i]=TransFinal2[i];
                for (j=0;j<3;j++) Rot[i][j]=RotFinal2[i][j];
            }
        }
    }
    
    if ((RotFinal1[0][0]!=2)&&(RotFinal2[0][0]==2))
    {
        /*Error(np,coplImage,copl,fLength,POSITRot1,POSITTrans1,&E1,&Ep1,&Ehvmax1);*/
        /*Error(np,coplImage,copl,fLength,POSITRot2,POSITTrans2,&E2,&Ep2,&Ehvmax2);*/
        /*printf("\nErhvmax1=%f Erhvmax2=%f\n",Ehvmax1,Ehvmax2); */
        for (i=0;i<3;i++)
        {
            Trans[i]=TransFinal1[i];
            for (j=0;j<3;j++) Rot[i][j]=RotFinal1[i][j];
        }
    }
    if ((RotFinal1[0][0]==2)&&(RotFinal2[0][0]!=2))
    {
        /*Error(np,coplImage,copl,fLength,POSITRot1,POSITTrans1,&E1,&Ep1,&Ehvmax1);*/
        /*Error(np,coplImage,copl,fLength,POSITRot2,POSITTrans2,&E2,&Ep2,&Ehvmax2);*/
        /*printf("\nErhvmax1=%f Erhvmax2=%f\n",Ehvmax1,Ehvmax2);*/
        for (i=0;i<3;i++)
        {
            Trans[i]=TransFinal2[i];
            for (j=0;j<3;j++) Rot[i][j]=RotFinal2[i][j];
        }
    }
    
    if ((RotFinal1[0][0]==2)&&(RotFinal2[0][0]==2)){
        for (i=0;i<3;i++)
        {
            Trans[i]=0;
            for (j=0;j<3;j++) Rot[i][j]=3;
        }

    }
    
    /*desallocations*/
    for (i=0;i<NbPts;i++) {
        free(homogeneousWorldPts[i]);
        free(centeredImage[i]);
    }
    for (i=0;i<3;i++) {
        free(Rot1[i]);
        free(Rot2[i]);
        free(RotFinal1[i]);
        free(RotFinal2[i]);
    }
    free(TransFinal1);
    free(TransFinal2);
    for (i=0;i<4;i++) free(objectMat[i]);
    
}



void PositBranches(int NbPts, double **centeredImage, double** worldPts, double**objectMat, double** Rot1, double** Rot2, double* Trans){
    int i,j;
    double r1T[4],r2T[4],U[3],u[3],IVect[3],JVect[3],row1[3],row2[3],row3[3];
    double I0I0, J0J0, I0J0;
    double scale;
    double NU;
    int firstNonCol;
    double delta,lambda,mu,q,zi,zmin1,zmin2;

    for (i=0; i<4; i++) {
        r1T[i]=0;
        r2T[i]=0;
        for (j=0; j<NbPts; j++) {
            r1T[i]+=objectMat[i][j]*centeredImage[j][0]; 
            r2T[i]+=objectMat[i][j]*centeredImage[j][1]; 
        }
    }
    
    I0I0=r1T[0]*r1T[0]+r1T[1]*r1T[1]+r1T[2]*r1T[2];
    J0J0=r2T[0]*r2T[0]+r2T[1]*r2T[1]+r2T[2]*r2T[2];
    I0J0=r1T[0]*r2T[0]+r1T[1]*r2T[1]+r1T[2]*r2T[2];
    
    /*Computation of u, unit vector normal to the image plane*/
    firstNonCol=2;
    NU=0.0;
    while (NU==0.0)
    {
        U[0]=worldPts[1][1]*worldPts[firstNonCol][2]-worldPts[1][2]*worldPts[firstNonCol][1];
        U[1]=worldPts[1][2]*worldPts[firstNonCol][0]-worldPts[1][0]*worldPts[firstNonCol][2];
        U[2]=worldPts[1][0]*worldPts[firstNonCol][1]-worldPts[1][1]*worldPts[firstNonCol][0];
        NU=sqrt(U[0]*U[0]+U[1]*U[1]+U[2]*U[2]);
        firstNonCol++;
    }
    for (i=0;i<3;i++) u[i]=U[i]/NU;
    
    /*Computation of mu and lambda*/
    delta=(J0J0-I0I0)*(J0J0-I0I0)+4*(I0J0*I0J0);
    if ((I0I0-J0J0)>=0) q=-(I0I0-J0J0+sqrt(delta))/2;
    else q=-(I0I0-J0J0-sqrt(delta))/2;
    if (q>=0)
    {
        lambda=sqrt(q);
        if (lambda==0.0) mu=0.0;
        else mu=-I0J0/sqrt(q);
    }
    else
    {
        lambda=sqrt(-(I0J0*I0J0)/q);
        if (lambda==0.0) mu=sqrt(I0I0-J0J0);
        else mu=-I0J0/sqrt(-(I0J0*I0J0)/q);
    }
//    printf("\nlambda=%f\t mu=%f\n",lambda,mu);
    
    
    /*First Rotation Matrix computation*/
    for (i=0;i<3;i++)
    {
        IVect[i]=r1T[i]+lambda*u[i];
        JVect[i]=r2T[i]+mu*u[i];
    }
    
    scale=sqrt(IVect[0]*IVect[0]+IVect[1]*IVect[1]+IVect[2]*IVect[2]);
    
    for (i=0;i<3;i++)
    {
        row1[i]=IVect[i]/scale;
        row2[i]=JVect[i]/scale;
    }
    row3[0]=row1[1]*row2[2]-row1[2]*row2[1];
    row3[1]=row2[0]*row1[2]-row1[0]*row2[2];
    row3[2]=row1[0]*row2[1]-row1[1]*row2[0];
    for (i=0;i<3;i++)
    {
        Rot1[0][i]=row1[i];
        Rot1[1][i]=row2[i];
        Rot1[2][i]=row3[i];
    }
//    printf("\nRot1\n");
//    for (i=0;i<3;i++){ 
//        for (j=0;j<3;j++) printf("%f\t",Rot1[i][j]);
//        printf("\n");
//    }
    
    /*Second Rotation matrix computation*/
    for (i=0;i<3;i++)
    {
        IVect[i]=r1T[i]-lambda*u[i];
        JVect[i]=r2T[i]-mu*u[i];
    }
    
    for (i=0;i<3;i++)
    {
        row1[i]=IVect[i]/scale;
        row2[i]=JVect[i]/scale;
    }
    row3[0]=row1[1]*row2[2]-row1[2]*row2[1];
    row3[1]=row2[0]*row1[2]-row1[0]*row2[2];
    row3[2]=row1[0]*row2[1]-row1[1]*row2[0];
    for (i=0;i<3;i++)
    {
        Rot2[0][i]=row1[i];
        Rot2[1][i]=row2[i];
        Rot2[2][i]=row3[i];
    }
//    printf("\nRot2\n");
//    for (i=0;i<3;i++){ 
//        for (j=0;j<3;j++) printf("%f\t",Rot2[i][j]);
//        printf("\n");
//    } 
    
    /* computation of translation*/
    Trans[0]=r1T[3]/scale;
    Trans[1]=r2T[3]/scale;
    Trans[2]=1/scale;
    

//    printf("\nTranslation\n");
//    for (i=0;i<3;i++) printf("%f\t",Trans[i]);
//    printf("\n");
    
    /*calculation of the minimum depths zi of the model points in the camera coordinate sistem, for the first pose*/
    for (i=0;i<NbPts;i++)
    {
        zi=Trans[2]+(Rot1[2][0]*worldPts[i][0]+
                          Rot1[2][1]*worldPts[i][1]+
                          Rot1[2][2]*worldPts[i][2]);
        if (i==0) zmin1=zi;
        if (zi<zmin1) zmin1=zi;
    }
    
    /*calculation of the minimum depths zi of the model points in the camera coordinate sistem, for the second pose*/
    for (i=0;i<NbPts;i++)
    {
        zi=Trans[2]+(Rot2[2][0]*worldPts[i][0]+
                          Rot2[2][1]*worldPts[i][1]+
                          Rot2[2][2]*worldPts[i][2]);
        if (i==0) zmin2=zi;
	    if (zi<zmin2) zmin2=zi;	//Afshin: I corrected this. It was zmin1 by mistake
        //    if (zi<zmin1) zmin2=zi;	//Afshin: This was the original code
    }
    /*In case of incoherent pose, the first element of the rotation matrix is set to 2.*/
    /*(object points behind image plane)*/
    if (zmin1<0||zmin1!=zmin1) Rot1[0][0]=2;
    if (zmin2<0||zmin2!=zmin2) Rot2[0][0]=2;
    
    
    
    
}

void  PerspMoveAndProjC(int N, double **obj, double** r, double* t, double foc, double** proj) /*Image projection given a rotation and a traslation.*/
{
    double  **moved;
    long int    i,j,k;
    
    
    /*allocations*/
    moved=(double **)malloc(N * sizeof(double *));
    for (i=0;i<N;i++) moved[i]=(double *)malloc(3 * sizeof(double));
        
    for (i=0;i<N;i++)
    {
        for (j=0;j<3;j++) moved[i][j]=t[j];
    }
    for (i=0;i<N;i++)
    {
        for (j=0;j<3;j++)
        {
            for (k=0;k<3;k++) moved[i][j]+=r[j][k]*obj[i][k];
        }
    }
    for (i=0;i<N;i++)
    {
        for (j=0;j<2;j++)	proj[i][j]=foc*moved[i][j]/moved[i][2];
    }
    
    /*desallocations*/
    for (i=0;i<N;i++) free(moved[i]);
        
}

void ErrorC(long int NP,double** impts,double** obpts,double f,double center[2],double** Rotat,double* Translat,double* Er,long int* Epr,double* Erhvmax)
/*Returns different error between the original image and the projected image*/
/*E is the euclidean distance between the two images*/
/*Ep is the sum of the horizontal and vertical variations in pixels*/
/*Ehvmax is the maximum horizontal or vertical variation (nonround values in pixels)*/

{
    double  **impredic,**ErVect;
    long int    i,j,fr;
    
    /*allocations*/
    impredic=(double **)malloc(NP * sizeof(double *));
    ErVect=(double **)malloc(NP * sizeof(double *));
    for (i=0;i<NP;i++)
    {
        impredic[i]=(double *)malloc(2 * sizeof(double));
        ErVect[i]=(double *)malloc(2 * sizeof(double));
    }
    
    if ((Rotat[0][0])!=2.0) /*A 2 in the first position of the rotation matrix means the pose is not possible*/
    {
        PerspMoveAndProjC(NP,obpts,Rotat,Translat,f,impredic); /*Project the image with the current pose*/

//        printf("puntos proy\n");
//        for (i=0; i<NP; i++) {
//            printf("\n%f\t%f\n",impredic[i][0],impredic[i][1]);
//        }
//        printf("puntos imagen\n");
//        for (i=0; i<NP; i++) {
//            printf("\n%f\t%f\n",f*impts[i][0],f*impts[i][1]);
//        }  
        
        for (i=0;i<NP;i++)
        {
            for (j=0;j<2;j++) ErVect[i][j]=impredic[i][j]-f*impts[i][j];
        }
        
        /*Error computation*/
        *Er=0.0;
        *Epr=0;
        *Erhvmax=0;
        for (i=0;i<NP;i++)
        {
            *Er+=sqrt(ErVect[i][0]*ErVect[i][0]+ErVect[i][1]*ErVect[i][1]);
            *Epr+=(int)(fabs(impredic[i][0]-impts[i][0])+
                             fabs(impredic[i][1]-impts[i][1]));
            if (fabs(ErVect[i][0])>*Erhvmax) 
                *Erhvmax=fabs(ErVect[i][0]);
            if (fabs(ErVect[i][1])>*Erhvmax) 
                *Erhvmax=fabs(ErVect[i][1]);
        }
        *Er=*Er/NP;
    }
    else /*if the pose is not possible then all error equals to -1*/
    {
        *Er=-1.0;
        *Epr=-1.0;
        *Erhvmax=-1.0;
    }
    
    /*deallocations*/
    for (fr=0;fr<NP;fr++)
    {
        free(impredic[fr]);
        free(ErVect[fr]);
    }
}

void PositLoop(int NbPts, double **centeredImage, double** homogeneousWorldPts, double**objectMat, double f,double center[2], double** RotIn, double* TransIn,double** Rot, double* Trans){
    
    int i,j;
    double deltaX, deltaY,delta=0;
    int count=0;
    bool converged= false;
    double Er,Erhvmax,Er1,Erhvmax1,Er2,Erhvmax2;
    long int Epr,Epr1,Epr2;
    double r3T[4];
    
    
    
    
    /* allocation for Rot1 and Rot2*/
    double** Rot1;
    double** Rot2;
    Rot1=(double**)malloc(3*sizeof(double*));
    Rot2=(double**)malloc(3*sizeof(double*));
    for (i=0; i<3; i++) {
        Rot1[i]=(double*)malloc(3*sizeof(double));
        Rot2[i]=(double*)malloc(3*sizeof(double));
    }

    
    /* allocation for centeredImageAux*/
    double** centeredImageAux;
    centeredImageAux=(double **)malloc(NbPts* sizeof(double *));
    for (i=0;i<NbPts;i++) centeredImageAux[i]=(double *)malloc(2 * sizeof(double));
    /* end alloc*/
    
    /* allocation for wk*/
    double* wk;
    wk=(double *)malloc(NbPts*sizeof(double));
    /* end alloc*/
    
    /* initializaton for Rot and Trans*/
    for (i=0;i<3; i++) {
        for (j=0;j<3; j++) Rot[i][j]=RotIn[i][j];
        Trans[i]=TransIn[i];
    }
    
    /* initialization for imageCenteredAux*/
    for (i=0;i<NbPts; i++) {
        centeredImageAux[i][0]=centeredImage[i][0];
        centeredImageAux[i][1]=centeredImage[i][1];
    }

    count=1;
    while (!converged) {

        if (count!=0) {
        
            PositBranches(NbPts, centeredImageAux, homogeneousWorldPts, objectMat, Rot1, Rot2, Trans);        
            
            printf("\nRotacion 1 en iteracion %d: \n",count-1);
            printf("%f\t %f\t %f\n",Rot1[0][0],Rot1[0][1],Rot1[0][2]);
            printf("%f\t %f\t %f\n",Rot1[1][0],Rot1[1][1],Rot1[1][2]);
            printf("%f\t %f\t %f\n",Rot1[2][0],Rot1[2][1],Rot1[2][2]);
            printf("Traslacion en iteracion %d: \n",count-1);
            printf("%f\t %f\t %f\n",Trans[0],Trans[1],Trans[2]);

            printf("\nRotacion 2 en iteracion %d: \n",count-1);
            printf("%f\t %f\t %f\n",Rot2[0][0],Rot2[0][1],Rot2[0][2]);
            printf("%f\t %f\t %f\n",Rot2[1][0],Rot2[1][1],Rot2[1][2]);
            printf("%f\t %f\t %f\n",Rot2[2][0],Rot2[2][1],Rot2[2][2]);
            printf("Traslacion en iteracion %d: \n",count-1);
            printf("%f\t %f\t %f\n",Trans[0],Trans[1],Trans[2]);
            
            
            
            ErrorC(NbPts, centeredImage, homogeneousWorldPts, f,center, Rot1, Trans, &Er1, &Epr1, &Erhvmax1);//tiene que entrar los puntos en la imagen no centrados.
            ErrorC(NbPts, centeredImage, homogeneousWorldPts, f,center, Rot2, Trans, &Er2, &Epr2, &Erhvmax2);
            
            if ((Er1>=0)&&(Er2>=0))/*if the two poses are possible, choose the one with smaller error*/
            {
                if (Er2<Er1)
                {
                    Er=Er2;
                    Epr=Epr2;
                    Erhvmax=Erhvmax2;
                    for (i=0;i<3;i++)
                    {
                        for (j=0;j<3;j++) Rot[i][j]=Rot2[i][j];
                    }
                }
                else
                {
                    Er=Er1;
                    Epr=Epr1;
                    Erhvmax=Erhvmax1;
                    for (i=0;i<3;i++)
                    {
                        for (j=0;j<3;j++) Rot[i][j]=Rot1[i][j];
                    }
                }
            }
            
            /*if one of the poses is not possible(Er=-1), choose the other one*/
            if ((Er1<0)&&(Er2>=0))
            {
                Er=Er2;
                Epr=Epr2;
                Erhvmax=Erhvmax2;
                for (i=0;i<3;i++)
                {
                    for (j=0;j<3;j++) Rot[i][j]=Rot2[i][j];
                }
            }
            if ((Er2<0)&&(Er1>=0))
            {
                Er=Er1;
                Epr=Epr1;
                Erhvmax=Erhvmax1;
                for (i=0;i<3;i++)
                {
                    for (j=0;j<3;j++) Rot[i][j]=Rot1[i][j];
                }
            }
        }
        r3T[0]=Rot[2][0];
        r3T[1]=Rot[2][1];
        r3T[2]=Rot[2][2];
        r3T[3]=Trans[2];
        
        /* copmute wk, and the difference between images*/
        delta=0;
        for (i=0;i<NbPts;i++){
            wk[i]=0;
            deltaX=0;
            deltaY=0;
            for (j=0;j<4;j++){
                wk[i]+=homogeneousWorldPts[i][j]*r3T[j]/Trans[2];
            }
            deltaX-=centeredImageAux[i][0];
            deltaY-=centeredImageAux[i][1];
            centeredImageAux[i][0]=wk[i]*centeredImage[i][0];
            centeredImageAux[i][1]=wk[i]*centeredImage[i][1];
            deltaX+=centeredImageAux[i][0];
            deltaY+=centeredImageAux[i][1];
            delta+=deltaX*deltaX+deltaY*deltaY;
        }
//        printf("puntos imagen\n");
//        for (i=0; i<NbPts; i++) {
//            printf("\n%f\t%f\n",centeredImageAux[i][0],centeredImageAux[i][1]);
//        }
//        printf("\nwk en iteracion %d\n",count);
//        for (i=0; i<NbPts; i++) printf("%f\t",wk[i]);
//        printf("\n");
        delta=f*f*delta;
        converged=(count>0 && delta<0.001) || (count>20&&delta>100);
        count+=1;
        
        if (count>20&&delta>100) Rot[0][0]=2; /* if pose doesn't converge after 20 iteration, discard the pose, the value for count and delta is arbitrary*/
        


      
    
    }
    
    /* deallocation*/
    for (i=0;i<3;i++){
        free(Rot1[i]);
        free(Rot2[i]); 
    }
    for (i=0;i<NbPts;i++){
        free(centeredImageAux[i]);
    }
    free(wk);
    
}


