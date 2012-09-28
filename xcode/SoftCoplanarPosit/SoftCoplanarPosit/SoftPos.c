//
//  SoftPosit.c
//  CoplanarPosit
//
//  Created by Juan Ignacio Braun on 3/16/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//


#include "softPos.h"

void softPosit(double** imgPoints, int nbImagePts, double** worldPoints, int nbWorldPts, double beta0, double noiseStd, double initRot[3][3], double initTrans[3],double focalLength, double* center,double** rot, double* trans)
/* las */
{
    int i,j,m,n;
    double alpha = 9.21*pow(noiseStd,2.0) + 1;
    double maxDelta = sqrt(alpha)/2;  // Max allowed errro per world point
    double delta;
    
    double betaFinal = 0.5;           // Terminate iteration when beta == betaFinal
    double betaUpdate = 1.05;         // Update rate on beta
    double epsilon0 = 0.01;           // Used to initialize assignment matrix
    
    int maxCount = 2; 
    int minBetaCount = 5;
    
    int minNbPts = fmin(nbWorldPts, nbImagePts);
    int maxNbPts = fmax(nbWorldPts, nbImagePts);
    double  scale = 1/((double)maxNbPts+1); 
    
    double Tx,Ty,Tz;
    double r1[3],r2[3],r3[3];
    int count=0;
        
    /* allocation for centeredImage*/
    double** centeredImage;
    centeredImage=(double **)malloc(nbImagePts* sizeof(double *));
    for (i=0;i<nbImagePts;i++) centeredImage[i]=(double *)malloc(2 * sizeof(double));
    /* end alloc*/
    
    /*Convert to normalized image coordinates. With normalized coorinates, (0,0) is the point where the optic axis penetrates the image, and the focal length is 1*/ 
    for (i=0;i<nbImagePts;i++){
        centeredImage[i][0] = (imgPoints[i][0] - center[0])/focalLength;
        centeredImage[i][1] = (imgPoints[i][1] - center[1])/focalLength;
        
    }
    
    /* allocation for homogeneusWorldPts*/
    double** homogeneusWorldPts;
    homogeneusWorldPts=(double **)malloc(nbWorldPts* sizeof(double *));
    for (i=0;i<nbWorldPts;i++) homogeneusWorldPts[i]=(double *)malloc(4 * sizeof(double));
    /* end alloc*/ 
    
    /* Homogeneus world points -  append a 1 to each 3-vector. An Nx4 matrix.*/
    for (i=0;i<nbWorldPts;i++){
        homogeneusWorldPts[i][0] = worldPoints[i][0];
        homogeneusWorldPts[i][1] = worldPoints[i][1];
        homogeneusWorldPts[i][2] = worldPoints[i][2];
        homogeneusWorldPts[i][3] = 1;
        
    }
    
    /* initial rotation and traslation as passed into this function*/ 
    for (i=0; i<3; i++) {
        trans[i]=initTrans[i];
        for (j=0; j<3; j++) {
            rot[i][j]=initRot[i][j];
        }
    }
    
    /* allocation for assignMat*/
    double** assignMat;
    assignMat=(double **)malloc((nbImagePts+1)* sizeof(double *));
    for (i=0;i<(nbImagePts+1);i++) assignMat[i]=(double *)malloc((nbWorldPts+1) * sizeof(double));
//    double assignMat[nbImagePts+1][nbWorldPts+1];
    /* end alloc*/
    
    /* assignMat initialization*/
    for(i=0;i<nbImagePts+1;i++){
        for(j=0;j<nbWorldPts+1;j++){
            assignMat[i][j] = 1 +epsilon0; 
        }
    }
        
    /* allocation for wk*/
    double* wk;
    wk=(double *)malloc(nbWorldPts*sizeof(double));
    /* end alloc*/
    
    /* Initialize the depths of all world points based on initial pose*/
    for(i=0;i<nbWorldPts;i++){
        wk[i] = (homogeneusWorldPts[i][0]*rot[2][0] + homogeneusWorldPts[i][1]*rot[2][1] + homogeneusWorldPts[i][2]*rot[2][2])/trans[2] + 1;
//        printf("wk[i]:%f\n",wk[i]);
    }
    
    
    /* First two rows for the camera matrix(for both perspective and SOP). Note:
     the scale factor is s=f/Tz=1/Tz since f=1. */
    double* r1T;
    r1T=(double*)malloc(4*sizeof(double));
    double* r2T;
    r2T=(double*)malloc(4*sizeof(double));
    double* r3T;
    r3T=(double*)malloc(4*sizeof(double));
    
    r1T[0] = rot[0][0]/trans[2];
    r1T[1] = rot[0][1]/trans[2];
    r1T[2] = rot[0][2]/trans[2];
    r1T[3] = trans[0]/trans[2];
    
    r2T[0] = rot[1][0]/trans[2];
    r2T[1] = rot[1][1]/trans[2];
    r2T[2] = rot[1][2]/trans[2];
    r2T[3] = trans[1]/trans[2];
    
    int betaCount = 0; 
    bool poseConverged = false; 
    bool assignConverged = false; 
    bool foundPose = false; 
    double beta=beta0; 
    double sumCol[nbWorldPts];
    
    
    /* allocation for distMat*/
    double** distMat; 
    distMat=(double **)malloc(nbImagePts * sizeof(double *));
    for (i=0;i<nbImagePts;i++) distMat[i]=(double *)malloc((nbWorldPts) * sizeof(double));
    /* end alloc*/
    
    /* allocation for SumSkSkt*/
    double** sumSkSkT;
    sumSkSkT=(double **)malloc(4 * sizeof(double*));
    for (i=0; i<4; i++) sumSkSkT[i]=(double *)malloc(4 * sizeof(double));
    /* end*/
    
    /* objectMat alloc*/
    double** objectMat;
    objectMat=(double **)malloc(4 * sizeof(double*));
    for (i=0; i<4; i++) objectMat[i]=(double *)malloc(4 * sizeof(double));
    /* end*/
    
    /* allocation for singular values W*/
    double* W;
    W=(double*)malloc(2*sizeof(double));
    /*end*/
    
    /* allocation for V matrix to use in SVD*/
    double** V;
    V=(double**)malloc(2*sizeof(double*));
    for (i=0; i<2; i++) V[i]=(double*)malloc(2*sizeof(double));
    /*end*/
    
    /* allocation for a matrix to copmute the pseudoinverse*/
    double** a;
    a=(double**)malloc(3*sizeof(double*));
    for (i=0; i<3; i++) a[i]=(double*)malloc(2*sizeof(double));
    /*end*/
    
    double projectedU[nbWorldPts];
    double projectedV[nbWorldPts];
    
    while (beta<betaFinal && !assignConverged) {
    /* Given the current pose and w[i], compute the distance matrix, d[j,k]. d[j,k] is the squared distance between the j-th corrected SOP image point and the SOP projection of the k-th scene point.*/
        
        /* SOP of the world points */
//        printf("ProjectedU\t ProjectedV\n");
        for (i=0;i<nbWorldPts;i++){
            projectedU[i] = homogeneusWorldPts[i][0]*r1T[0] + homogeneusWorldPts[i][1]*r1T[1] + homogeneusWorldPts[i][2]*r1T[2] + homogeneusWorldPts[i][3]*r1T[3];   
            projectedV[i] = homogeneusWorldPts[i][0]*r2T[0] + homogeneusWorldPts[i][1]*r2T[1] + homogeneusWorldPts[i][2]*r2T[2] + homogeneusWorldPts[i][3]*r2T[3];   
            
//            printf("%f\t %f\n",projectedU[i],projectedV[i]);

        }
//        printf("\n");
//        printf("r1T\n");
//        printf("%f\t %f\t %f\t %f\n", r1T[0],r1T[1],r1T[2],r1T[3]);
//
//        printf("\n");
//        printf("r2T\n");
//        printf("%f\t %f\t %f\t %f\n", r2T[0],r2T[1],r2T[2],r2T[3]);

        
        /* distMat and assignMat calculation */
        for(i=0;i<nbImagePts;i++){
            for(j=0;j<nbWorldPts;j++){
//                printf("U: %f\t V: %f\t Img: %f\t %f\t wk: %f\n",projectedU[j],projectedV[j],centeredImage[i][0],centeredImage[i][1],wk[j]);
                distMat[i][j] = pow(focalLength,2.0)*(pow((projectedU[j]-centeredImage[i][0]*wk[j]),2)+pow((projectedV[j]-centeredImage[i][1]*wk[j]),2));
                double param=-beta*(distMat[i][j]-alpha);
                assignMat[i][j] = scale*exp(param);
//                printf("assignMat[%d][%d]=%f\n",i,j,assignMat[i][j]);
            }
        }
       
//        printf("Matriz de distancia:\n");
//        for (i=0; i<nbImagePts;i++) {
//            for (j=0; j<nbWorldPts; j++) {
//                printf("%E\t", distMat[i][j]);
//            }
//            printf("\n");
//        }
//        
             
        i=0;
        for(i=0;i<nbImagePts+1;i++){
            assignMat[i][nbWorldPts] = scale;
//            printf("assignMat[%d][%d]:%f\n",i,nbWorldPts,assignMat[i][nbWorldPts]);
        }
        
        for(i=0;i<nbWorldPts+1;i++){
            assignMat[nbImagePts][i] = scale;
        }
        
   


        sinkhornImp(assignMat,nbImagePts+1,nbWorldPts+1);
        
//        printf("Matriz de asignacion:\n");
//        for (i=0; i<nbImagePts+1;i++) {
//            for (j=0; j<nbWorldPts+1; j++) {
//                printf("%4.4f\t", assignMat[i][j]);
//            }
//            printf("\n");
//        }
            
                
        /* sumSkSkT definition and initiaization*/ 
        
        for (i=0; i<4; i++) {
            for(j=0;j<4;j++){
                sumSkSkT[i][j]=0;
            }
        }
        /*end*/
        printf("sumCol\n");
        /* calculation for sumSkSkt*/
        for(i=0;i<nbWorldPts;i++){
            sumCol[i]=0;
            for (j=0; j<nbImagePts; j++) {
                sumCol[i]+=assignMat[j][i];   
            }
           printf("%f\t",sumCol[i]);
            for (m=0; m<4; m++) {
                for (n=0; n<4; n++) {
                    sumSkSkT[m][n]+=sumCol[i]*homogeneusWorldPts[i][m]*homogeneusWorldPts[i][n];
                    
                }
            }
        }
        /*end*/
    
        printf("\n");
        printf("Matriz de sumSkSkt\n");
        printf("%f\t %f\t %f\t %f\n", sumSkSkT[0][0],sumSkSkT[0][1],sumSkSkT[0][2],sumSkSkT[0][3]);
        printf("%f\t %f\t %f\t %f\n", sumSkSkT[1][0],sumSkSkT[1][1],sumSkSkT[1][2],sumSkSkT[1][3]);
        printf("%f\t %f\t %f\t %f\n", sumSkSkT[2][0],sumSkSkT[2][1],sumSkSkT[2][2],sumSkSkT[2][3]);
        printf("%f\t %f\t %f\t %f\n", sumSkSkT[3][0],sumSkSkT[3][1],sumSkSkT[3][2],sumSkSkT[3][3]);
        printf("\n");
        
        double det;
        INVERT_4X4(objectMat,det,sumSkSkT);

        printf("%f\n \n",det);
        printf("\n");
        printf("Matriz de sumSkSkt\n");
        printf("%f\t %f\t %f\t %f\n", sumSkSkT[0][0],sumSkSkT[0][1],sumSkSkT[0][2],sumSkSkT[0][3]);
        printf("%f\t %f\t %f\t %f\n", sumSkSkT[1][0],sumSkSkT[1][1],sumSkSkT[1][2],sumSkSkT[1][3]);
        printf("%f\t %f\t %f\t %f\n", sumSkSkT[2][0],sumSkSkT[2][1],sumSkSkT[2][2],sumSkSkT[2][3]);
        printf("%f\t %f\t %f\t %f\n", sumSkSkT[3][0],sumSkSkT[3][1],sumSkSkT[3][2],sumSkSkT[3][3]);
        printf("\n");
        
        printf("\n");
        printf("Matriz objectMat\n");
        printf("%f\t %f\t %f\t %f\n", objectMat[0][0],objectMat[0][1],objectMat[0][2],objectMat[0][3]);
        printf("%f\t %f\t %f\t %f\n", objectMat[1][0],objectMat[1][1],objectMat[1][2],objectMat[1][3]);
        printf("%f\t %f\t %f\t %f\n", objectMat[2][0],objectMat[2][1],objectMat[2][2],objectMat[2][3]);
        printf("%f\t %f\t %f\t %f\n", objectMat[3][0],objectMat[3][1],objectMat[3][2],objectMat[3][3]);
        printf("\n");

      
        double weightedUi[4];
        double weightedVi[4];
        for (i=0; i<4; i++) {
            weightedUi[i]=0;
            weightedVi[i]=0;
        }
        
        for (i=0; i<nbImagePts; i++) {
            for (j=0; j<nbWorldPts; j++) {
                for (m=0; m<4; m++) {
                    weightedUi[m]+=assignMat[i][j]*wk[j]*centeredImage[i][0]*homogeneusWorldPts[j][m];
                    weightedVi[m]+=assignMat[i][j]*wk[j]*centeredImage[i][1]*homogeneusWorldPts[j][m];
                }
            }
        }
         
        
        for (i=0; i<4; i++) {
           r1T[i]=0;
            r2T[i]=0;
        }
        
        for (i=0; i<4; i++) {
            for (j=0; j<4; j++) {
                r1T[i]+=objectMat[i][j]*weightedUi[j];
                r2T[i]+=objectMat[i][j]*weightedVi[j];
            }
            
        }
        
//        printf("\n");
//        printf("wightedUi\n");
//        printf("%f\t %f\t %f\t %f\n", weightedUi[0],weightedUi[1],weightedUi[2],weightedUi[3]);
//        
//        printf("\n");
//        printf("wightedVi\n");
//        printf("%f\t %f\t %f\t %f\n", weightedVi[0],weightedVi[1],weightedVi[2],weightedVi[3]);
//        
//        printf("\n");
//        printf("r1T\n");
//        printf("%f\t %f\t %f\t %f\n", r1T[0],r1T[1],r1T[2],r1T[3]);
//        
//        printf("\n");
//        printf("r2T\n");
//        printf("%f\t %f\t %f\t %f\n", r2T[0],r2T[1],r2T[2],r2T[3]);
        
        for (i=0;i<3;i++){
            a[i][0]=r1T[i];
            a[i][1]=r2T[i];
        }
       
        
//        printf("\n");
//        printf("Matriz a\n");
//        printf("%f\t %f\t %f\n", a[0][0],a[0][1],a[0][2]);
//        printf("%f\t %f\t %f\n", a[1][0],a[1][1],a[1][2]);   
//        printf("%f\t %f\t %f\n", a[2][0],a[2][1],a[2][2]);

        
        svdcmp(a,3,2,W,V);
        
//        printf("\n");
//        printf("Matriz a\n");
//        printf("%f\t %f\t %f\n", a[0][0],a[0][1],a[0][2]);
//        printf("%f\t %f\t %f\n", a[1][0],a[1][1],a[1][2]);   
//        printf("%f\t %f\t %f\n", a[2][0],a[2][1],a[2][2]);
        
        
//        printf("\n");
//        printf("Matriz V\n");
//        printf("%f\t %f\n", V[0][0],V[0][1]);
//        printf("%f\t %f\n", V[1][0],V[1][1]); 
        
//        printf("\n");
//        printf("Matriz W\n");
//        printf("%f\t %f\n", W[0],W[1]);

        
        for (i=0; i<3; i++) {
            r1[i]=a[i][0]*V[0][0]+a[i][1]*V[0][1];
            r2[i]=a[i][0]*V[1][0]+a[i][1]*V[1][1];
        }
        r3[0]=r1[1]*r2[2]-r2[1]*r1[2];
        r3[1]=r1[2]*r2[0]-r2[2]*r1[0];
        r3[2]=r1[0]*r2[1]-r2[0]*r1[1];
        
       
        Tz = 2/(W[0]+W[1]);
        Tx = r1T[3]*Tz;
        Ty = r2T[3]*Tz;
        
        r3T[0] = r3[0];
        r3T[1] = r3[1];
        r3T[2] = r3[2];
        r3T[3] = Tz;

        r1T[0] = r1[0]/Tz;
        r1T[1] = r1[1]/Tz;
        r1T[2] = r1[2]/Tz;
        r1T[3] = Tx/Tz;
        
//        printf("\n");
//        printf("r1T\n");
//        printf("%f\t %f\t %f\t %f\n", r1T[0],r1T[1],r1T[2],r1T[3]);
        
        r2T[0] = r2[0]/Tz;
        r2T[1] = r2[1]/Tz;
        r2T[2] = r2[2]/Tz;
        r2T[3] = Ty/Tz;
        
//        printf("\n");
//        printf("r2T\n");
//        printf("%f\t %f\t %f\t %f\n", r2T[0],r2T[1],r2T[2],r2T[3]);


        for(i=0;i<nbWorldPts;i++){
            wk[i] = (homogeneusWorldPts[i][0]*r3T[0] + homogeneusWorldPts[i][1]*r3T[1] + homogeneusWorldPts[i][2]*r3T[2] + homogeneusWorldPts[i][3]*r3T[3])/Tz;
//            printf("wk[i]:%f\n",wk[i]);
        }
        delta = 0;
        for (i=0; i<nbImagePts; i++) {
            for (j=0; j<nbWorldPts; j++) {
                delta+=assignMat[i][j]*distMat[i][j]/nbWorldPts;
            }
        }
        
            
//        delta /= nbWorldPts;
        delta = sqrt(delta);
        poseConverged = delta < maxDelta; 
        count++;
        beta *= betaUpdate;
        betaCount++;
        assignConverged = poseConverged && betaCount > minBetaCount;
        printf("Cantidad iteraciones: %d\n",count);
        
    }
    
    
    trans[0]=Tx;
    trans[1]=Ty;
    trans[2]=Tz;
    
    for (i=0; i<3; i++) {
        rot[0][i]=r1[i];
        rot[1][i]=r2[i];
        rot[2][i]=r3[i];
    }
    
    free(centeredImage);  
    free(homogeneusWorldPts);
    free(assignMat);
    free(wk);
    free(r1T);  
    free(r2T);
    free(r3T);
    free(distMat);
    free(sumSkSkT);
    free(objectMat);
    free(W);
    free(V);
    free(a);
    
}

void softPositCopl(double** imgPoints, int nbImagePts, double** worldPoints, int nbWorldPts, double beta0, double noiseStd, double** initRot, double* initTrans,double focalLength, double* center,double** rot, double* trans)
/* las */
{
    int i,j;
    double alpha = 9.21*pow(noiseStd,2.0) + 1;
    double maxDelta = sqrt(alpha)/2;  // Max allowed errro per world point
    double delta;
    
    double betaFinal = 0.5;           // Terminate iteration when beta == betaFinal
    double betaUpdate = 1.05;         // Update rate on beta
    double epsilon0 = 0.01;           // Used to initialize assignment matrix
    
    int minBetaCount = 80;
    
    int minNbPts = fmin(nbWorldPts, nbImagePts);
    int maxNbPts = fmax(nbWorldPts, nbImagePts);
    double  assMatScale = 1/((double)maxNbPts+1);
    
    int count=0;
    
    /*allocation for pos*/
    int** pos;
    pos=(int**)malloc(nbWorldPts*sizeof(int*));
    for (i=0; i<nbWorldPts; i++) pos[i]=(int*)malloc(2*sizeof(int));
    /*end alloc*/
    
    /*allocation for pos*/
    double** ratio;
    ratio=(double**)malloc(nbWorldPts*sizeof(double*));
    for (i=0; i<nbWorldPts; i++) ratio[i]=(double*)malloc(2*sizeof(double));
    /*end alloc*/
    
    /* allocation for centeredImage*/
    double** centeredImage;
    centeredImage=(double **)malloc(nbImagePts* sizeof(double *));
    for (i=0;i<nbImagePts;i++) centeredImage[i]=(double *)malloc(2 * sizeof(double));
    /* end alloc*/
    
    /*Convert to normalized image coordinates. With normalized coorinates, (0,0) is the point where the optic axis penetrates the image, and the focal length is 1*/ 
    for (i=0;i<nbImagePts;i++){
        centeredImage[i][0] = (imgPoints[i][0] - center[0])/focalLength;
        centeredImage[i][1] = (imgPoints[i][1] - center[1])/focalLength;
        
    }
    
    /* allocation for homogeneusWorldPts*/
    double** homogeneusWorldPts;
    homogeneusWorldPts=(double **)malloc(nbWorldPts* sizeof(double *));
    for (i=0;i<nbWorldPts;i++) homogeneusWorldPts[i]=(double *)malloc(4 * sizeof(double));
    /* end alloc*/ 
    
    /* Homogeneus world points -  append a 1 to each 3-vector. An Nx4 matrix.*/
    for (i=0;i<nbWorldPts;i++){
        homogeneusWorldPts[i][0] = worldPoints[i][0];
        homogeneusWorldPts[i][1] = worldPoints[i][1];
        homogeneusWorldPts[i][2] = worldPoints[i][2];
        homogeneusWorldPts[i][3] = 1;
        
    }
    
    /* initial rotation and traslation as passed into this function*/ 
    for (i=0; i<3; i++) {
        trans[i]=initTrans[i];
        for (j=0; j<3; j++) {
            rot[i][j]=initRot[i][j];
        }
    }
    
    /* allocation for distMat*/
    double** distMat;
    distMat=(double **)malloc(nbImagePts * sizeof(double *));
    for (i=0;i<nbImagePts;i++) distMat[i]=(double *)malloc((nbWorldPts) * sizeof(double));
    /* end alloc*/
    
    /* allocation for distMat1*/
    double** distMat1;
    distMat1=(double **)malloc(nbImagePts * sizeof(double *));
    for (i=0;i<nbImagePts;i++) distMat1[i]=(double *)malloc((nbWorldPts) * sizeof(double));
    /* end alloc*/
    
    /* allocation for distMat2*/
    double** distMat2;
    distMat2=(double **)malloc(nbImagePts * sizeof(double *));
    for (i=0;i<nbImagePts;i++) distMat2[i]=(double *)malloc((nbWorldPts) * sizeof(double));
    /* end alloc*/
    
    /* allocation for assignMat*/
    double** assignMat;
    assignMat=(double **)malloc((nbImagePts+1)* sizeof(double *));
    for (i=0;i<(nbImagePts+1);i++) assignMat[i]=(double *)malloc((nbWorldPts+1) * sizeof(double));
    //    double assignMat[nbImagePts+1][nbWorldPts+1];
    /* end alloc*/
    
    /* allocation for assignMat1*/
    double** assignMat1;
    assignMat1=(double **)malloc((nbImagePts+1)* sizeof(double *));
    for (i=0;i<(nbImagePts+1);i++) assignMat1[i]=(double *)malloc((nbWorldPts+1) * sizeof(double));
    //    double assignMat[nbImagePts+1][nbWorldPts+1];
    /* end alloc*/
    
    /* allocation for assignMat2*/
    double** assignMat2;
    assignMat2=(double **)malloc((nbImagePts+1)* sizeof(double *));
    for (i=0;i<(nbImagePts+1);i++) assignMat2[i]=(double *)malloc((nbWorldPts+1) * sizeof(double));
    //    double assignMat[nbImagePts+1][nbWorldPts+1];
    /* end alloc*/
    
    
    for(i=0;i<nbImagePts+1;i++){
        assignMat1[i][nbWorldPts] = assMatScale;
        assignMat2[i][nbWorldPts] = assMatScale;
        
        //            printf("assignMat[%d][%d]:%f\n",i,nbWorldPts,assignMat[i][nbWorldPts]);
    }
    
    for(i=0;i<nbWorldPts+1;i++){
        assignMat1[nbImagePts][i] = assMatScale;
        assignMat2[nbImagePts][i] = assMatScale;
    }
    
    /* assignMat initialization*/
    for(i=0;i<nbImagePts+1;i++){
        for(j=0;j<nbWorldPts+1;j++){
            assignMat[i][j] = 1 +epsilon0; 
        }
    }
 
   
    /* allocation for wk*/
    double* wk;
    wk=(double *)malloc(nbWorldPts*sizeof(double));
    /* end alloc*/
    
    /* allocation for wk1*/
    double* wk1;
    wk1=(double *)malloc(nbWorldPts*sizeof(double));
    /* end alloc*/
    
    /* allocation for wk2*/
    double* wk2;
    wk2=(double *)malloc(nbWorldPts*sizeof(double));
    /* end alloc*/
    
    /* Initialize the depths of all world points based on initial pose*/
    for(i=0;i<nbWorldPts;i++){
        wk[i] = (homogeneusWorldPts[i][0]*rot[2][0] + homogeneusWorldPts[i][1]*rot[2][1] + homogeneusWorldPts[i][2]*rot[2][2])/trans[2] + 1;
//    printf("wk[i]:%f\n",wk[i]);
    }
    
    
    /* allocation for SumSkSkt*/
    double** sumSkSkT;
    sumSkSkT=(double **)malloc(3 * sizeof(double*));
    for (i=0; i<3; i++) sumSkSkT[i]=(double *)malloc(3 * sizeof(double));
    /* end*/
    
    /* objectMat alloc*/
    double** objectMat;
    objectMat=(double **)malloc(3 * sizeof(double*));
    for (i=0; i<3; i++) objectMat[i]=(double *)malloc(3 * sizeof(double));
    /* end*/
    
    
    /* First two rows for the camera matrix(for both perspective and SOP). Note:
     the scale factor is s=f/Tz=1/Tz since f=1. */
    double* r1T;
    r1T=(double*)malloc(4*sizeof(double));
    double* r2T;
    r2T=(double*)malloc(4*sizeof(double));
    double* r3T;
    r3T=(double*)malloc(4*sizeof(double));
    
    r1T[0] = rot[0][0]/trans[2];
    r1T[1] = rot[0][1]/trans[2];
    r1T[2] = rot[0][2]/trans[2];
    r1T[3] = trans[0]/trans[2];
    
    r2T[0] = rot[1][0]/trans[2];
    r2T[1] = rot[1][1]/trans[2];
    r2T[2] = rot[1][2]/trans[2];
    r2T[3] = trans[1]/trans[2];
    
//    VEC_PRINT_4(r1T);
//    VEC_PRINT_4(r2T);
//    VEC_PRINT_4(r3T);
    
    int betaCount = 0;
    bool poseConverged = false; 
    bool assignConverged = false; 
    bool foundPose = false; 
    double beta=beta0; 
    double sumCol[nbWorldPts];    
    
    double projectedU[nbWorldPts];
    double projectedV[nbWorldPts];

    /* SOP of the world points */
    //        printf("ProjectedU\t ProjectedV\n");
    for (i=0;i<nbWorldPts;i++){
        projectedU[i] = homogeneusWorldPts[i][0]*r1T[0] + homogeneusWorldPts[i][1]*r1T[1] + homogeneusWorldPts[i][2]*r1T[2] + homogeneusWorldPts[i][3]*r1T[3];
        projectedV[i] = homogeneusWorldPts[i][0]*r2T[0] + homogeneusWorldPts[i][1]*r2T[1] + homogeneusWorldPts[i][2]*r2T[2] + homogeneusWorldPts[i][3]*r2T[3];
        
        //            printf("%f\t %f\n",projectedU[i],projectedV[i]);
        
    }
    
    /* distMat and assignMat calculation */
    for(i=0;i<nbImagePts;i++){
        for(j=0;j<nbWorldPts;j++){
            //                printf("U: %f\t V: %f\t Img: %f\t %f\t wk: %f\n",projectedU[j],projectedV[j],centeredImage[i][0],centeredImage[i][1],wk[j]);
            distMat[i][j] = pow(focalLength,2.0)*(pow((projectedU[j]-centeredImage[i][0]*wk[j]),2)+pow((projectedV[j]-centeredImage[i][1]*wk[j]),2));
            double param=-beta*(distMat[i][j]-alpha);
            assignMat[i][j] = assMatScale*exp(param);
            //                printf("assignMat[%d][%d]=%f\n",i,j,assignMat[i][j]);
        }
    }
    
    if(false){
        printf("\nMatriz de distancia:\n");
        for (i=0; i<nbImagePts;i++) {
            for (j=0; j<nbWorldPts; j++) {
                printf("%4.4f\t", distMat[i][j]);
            }
            printf("\n");
        }
    }

    
    for(i=0;i<nbImagePts+1;i++){
        assignMat[i][nbWorldPts] = assMatScale;
        //            printf("assignMat[%d][%d]:%f\n",i,nbWorldPts,assignMat[i][nbWorldPts]);
    }
    
    for(i=0;i<nbWorldPts+1;i++){
        assignMat[nbImagePts][i] = assMatScale;
    }


    sinkhornImp(assignMat,nbImagePts+1,nbWorldPts+1);
    
    if(false){
        printf("Matriz de asignacion:\n");
        for (i=0; i<nbImagePts+1;i++) {
            for (j=0; j<nbWorldPts+1; j++) {
                printf("%4.4f\t", assignMat[i][j]);
            }
            printf("\n");
        }
    }
    
    delta = 0;
    for (i=0; i<nbImagePts; i++) {
        for (j=0; j<nbWorldPts; j++) {
            delta+=assignMat[i][j]*distMat[i][j]/nbWorldPts;
           
        }
    }
    delta=sqrt(delta);
    
    while (beta<betaFinal && !assignConverged) {
//    while (beta<betaFinal) {
               

        
        for (i=0; i<3; i++) {
            for(j=0;j<3;j++){
                sumSkSkT[i][j]=0;
            }
        }
        for(i=0;i<nbWorldPts;i++){
            sumCol[i]=0;
            for (j=0; j<nbImagePts; j++) sumCol[i]+=assignMat[j][i];
        }

        double a[3],m[3][3],det;
        for(i=0;i<nbWorldPts;i++){
            a[0]=homogeneusWorldPts[i][0];
            a[1]=homogeneusWorldPts[i][1];
            a[2]=homogeneusWorldPts[i][3];
            OUTER_PRODUCT_3X3(m, a, a);
            ACCUM_SCALE_MATRIX_3X3(sumSkSkT, sumCol[i], m)
        }
        
        INVERT_3X3(objectMat,det, sumSkSkT)
        MAT_PRINT_3X3(objectMat);
        double r1Taux[3],r2Taux[3],r11Taux[3]={0,0,0},r22Taux[3]={0,0,0};
        double x,y;
        for (i=0; i<nbImagePts; i++) {
            for (j=0; j<nbWorldPts; j++) {
                a[0]=homogeneusWorldPts[j][0];
                a[1]=homogeneusWorldPts[j][1];
                a[2]=homogeneusWorldPts[j][3];
                x=assignMat[i][j]*wk[j]*centeredImage[i][0];
                y=assignMat[i][j]*wk[j]*centeredImage[i][1];
                VEC_ACCUM(r11Taux,x,a);
                VEC_ACCUM(r22Taux,y,a);
            }
        }
        VEC_DOT_MAT_3X3(r1Taux,r11Taux,objectMat);
        VEC_DOT_MAT_3X3(r2Taux,r22Taux,objectMat)
        VEC_PRINT(r1Taux);
        VEC_PRINT(r2Taux);
        
        r1T[0]=r1Taux[0];
        r1T[1]=r1Taux[1];
        r1T[2]=0;
        r1T[3]=r1Taux[2];
        
        r2T[0]=r2Taux[0];
        r2T[1]=r2Taux[1];
        r2T[2]=0;
        r2T[3]=r2Taux[2];
        
        double I0I0,J0J0,I0J0,absI0J0;
        I0I0=r1T[0]*r1T[0]+r1T[1]*r1T[1]+r1T[2]*r1T[2];
        J0J0=r2T[0]*r2T[0]+r2T[1]*r2T[1]+r2T[2]*r2T[2];
        I0J0=r1T[0]*r2T[0]+r1T[1]*r2T[1]+r1T[2]*r2T[2];
        
        if (false){
            printf("I0I0J0J0I0J0\n");
            printf("%g\t%g\t%g\n",I0I0,J0J0,I0J0);
        }
        
        /*Computation of u, unit vector normal to the image plane*/
        int firstNonCol=2;
        double NU=0.0;
        double U[3],u[3];
        while (NU==0.0)
        {
            U[0]=homogeneusWorldPts[1][1]*homogeneusWorldPts[firstNonCol][2]-homogeneusWorldPts[1][2]*homogeneusWorldPts[firstNonCol][1];
            U[1]=homogeneusWorldPts[1][2]*homogeneusWorldPts[firstNonCol][0]-homogeneusWorldPts[1][0]*homogeneusWorldPts[firstNonCol][2];
            U[2]=homogeneusWorldPts[1][0]*homogeneusWorldPts[firstNonCol][1]-homogeneusWorldPts[1][1]*homogeneusWorldPts[firstNonCol][0];
            NU=sqrt(U[0]*U[0]+U[1]*U[1]+U[2]*U[2]);
            firstNonCol++;
        }
        for (i=0;i<3;i++) u[i]=U[i]/NU;
        
        /*Computation of mu and lambda*/
        //    delta=sqrt((J0J0-I0I0)*(J0J0-I0I0)+4*(I0J0*I0J0));
        //    if ((I0I0-J0J0)>=0) q=atan((-2*I0J0)/((J0J0-I0I0)*(J0J0-I0I0)));
        //    else q=atan((-2*I0J0)/((J0J0-I0I0)*(J0J0-I0I0)))+MY_PI/2;
        //    {
        //        lambda=sqrt(delta)*cos(q/2);
        //        if (lambda==0.0) mu=0.0;
        //        else mu=sqrt(delta)*sin(q/2);
        //    }
        double ro,q,lambda,mu;
        
        /*Computation of mu and lambda*/
        ro=sqrt((J0J0-I0I0)*(J0J0-I0I0)+4*(I0J0*I0J0));
        if ((J0J0-I0J0)>0.00000001){
            q=atan2(-2*I0J0, (J0J0-I0I0));
        }
        else if ((J0J0-I0J0)<-0.00000001) {
            q=atan2(-2*I0J0, (J0J0-I0I0))+MY_PI;
        }
        else{
            absValue(absI0J0, I0J0);
            delta=2*absI0J0;
            q=(I0J0/absI0J0)*MY_PI;
        }
        
        
        lambda=sqrt(ro)*cos(q/2);
        mu=sqrt(ro)*sin(q/2);

//        ro=(J0J0-I0I0)*(J0J0-I0I0)+4*(I0J0*I0J0);
//        if ((I0I0-J0J0)>=0) q=-(I0I0-J0J0+sqrt(ro))/2;
//        else q=-(I0I0-J0J0-sqrt(ro))/2;
//        if (q>=0)
//        {
//            lambda=sqrt(q);
//            if (lambda==0.0) mu=0.0;
//            else mu=-I0J0/sqrt(q);
//        }
//        else
//        {
//            lambda=sqrt(-(I0J0*I0J0)/q);
//            if (lambda==0.0) mu=sqrt(I0I0-J0J0);
//            else mu=-I0J0/sqrt(-(I0J0*I0J0)/q);
//        }
        
        
        //    printf("\nlambda=%f\t mu=%f\n",lambda,mu);
        
        double scale,IVect[3],JVect[3],r1Ta[4],r2Ta[4],r3Ta[4],r1Tb[4],r2Tb[4],r3Tb[4];
        
        /*First Rotation Matrix computation*/
        for (i=0;i<3;i++)
        {
            IVect[i]=r1T[i]+lambda*u[i];
            JVect[i]=r2T[i]+mu*u[i];
        }
        
        scale=sqrt(sqrt(IVect[0]*IVect[0]+IVect[1]*IVect[1]+IVect[2]*IVect[2])*sqrt(JVect[0]*JVect[0]+JVect[1]*JVect[1]+JVect[2]*JVect[2]));
        
        for (i=0;i<3;i++)
        {
            r1Ta[i]=IVect[i]/scale;
            r2Ta[i]=JVect[i]/scale;
        }
        
        r3Ta[0]=r1Ta[1]*r2Ta[2]-r1Ta[2]*r2Ta[1];
        r3Ta[1]=r1Ta[2]*r2Ta[0]-r1Ta[0]*r2Ta[2];
        r3Ta[2]=r1Ta[0]*r2Ta[1]-r1Ta[1]*r2Ta[0];
        
        r1Ta[3]=r1T[3]/scale;
        r2Ta[3]=r2T[3]/scale;
        r3Ta[3]=1/scale;
 
        VEC_PRINT_4(r1Ta);
        VEC_PRINT_4(r2Ta);
        VEC_PRINT_4(r3Ta);

      
        /*Second Rotation matrix computation*/
        for (i=0;i<3;i++)
        {
            IVect[i]=r1T[i]-lambda*u[i];
            JVect[i]=r2T[i]-mu*u[i];
        }
        
        for (i=0;i<3;i++)
        {
            r1Tb[i]=IVect[i]/scale;
            r2Tb[i]=JVect[i]/scale;
        }
        r3Tb[0]=r1Tb[1]*r2Tb[2]-r1Tb[2]*r2Tb[1];
        r3Tb[1]=r1Tb[2]*r2Tb[0]-r1Tb[0]*r2Tb[2];
        r3Tb[2]=r1Tb[0]*r2Tb[1]-r1Tb[1]*r2Tb[0];

        r1Tb[3]=r1T[3]/scale;
        r2Tb[3]=r2T[3]/scale;
        r3Tb[3]=1/scale;
   
        VEC_PRINT_4(r1Tb);
        VEC_PRINT_4(r2Tb);
        VEC_PRINT_4(r3Tb);
        
        for(i=0;i<nbWorldPts;i++){
            wk1[i] = (homogeneusWorldPts[i][0]*r3Ta[0] + homogeneusWorldPts[i][1]*r3Ta[1] + homogeneusWorldPts[i][2]*r3Ta[2] + homogeneusWorldPts[i][3]*r3Ta[3])/r3Ta[3];
            wk2[i] = (homogeneusWorldPts[i][0]*r3Tb[0] + homogeneusWorldPts[i][1]*r3Tb[1] + homogeneusWorldPts[i][2]*r3Tb[2] + homogeneusWorldPts[i][3]*r3Tb[3])/r3Tb[3];
//           printf("wk1[i]:%f\n",wk1[i]);
//            printf("wk2[i]:%f\n",wk2[i]);
        }
        
        if(false){
            printf("wk1\twk2\n");
            for(i=0;i<nbWorldPts;i++){
                printf("%f\t%f\t%f\n",wk[i],wk1[i],wk2[i]);
            }
        }
        double projectedU1[nbWorldPts];
        double projectedV1[nbWorldPts];
        double projectedU2[nbWorldPts];
        double projectedV2[nbWorldPts];
        /* SOP of the world points */
        //        printf("ProjectedU\t ProjectedV\n");
        for (i=0;i<nbWorldPts;i++){
            projectedU1[i] = (homogeneusWorldPts[i][0]*r1Ta[0] + homogeneusWorldPts[i][1]*r1Ta[1] + homogeneusWorldPts[i][2]*r1Ta[2] + homogeneusWorldPts[i][3]*r1Ta[3])/r3Ta[3];
            projectedV1[i] = (homogeneusWorldPts[i][0]*r2Ta[0] + homogeneusWorldPts[i][1]*r2Ta[1] + homogeneusWorldPts[i][2]*r2Ta[2] + homogeneusWorldPts[i][3]*r2Ta[3])/r3Ta[3];

            projectedU2[i] = (homogeneusWorldPts[i][0]*r1Tb[0] + homogeneusWorldPts[i][1]*r1Tb[1] + homogeneusWorldPts[i][2]*r1Tb[2] + homogeneusWorldPts[i][3]*r1Tb[3])/r3Tb[3];
            projectedV2[i] = (homogeneusWorldPts[i][0]*r2Tb[0] + homogeneusWorldPts[i][1]*r2Tb[1] + homogeneusWorldPts[i][2]*r2Tb[2] + homogeneusWorldPts[i][3]*r2Tb[3])/r3Tb[3];

            //            printf("%f\t %f\n",projectedU[i],projectedV[i]);
            
        }
        if(false){
            printf("\nCentered Points\n");
            for (i=0; i<nbImagePts; i++) printf("%f\t %f\n",centeredImage[i][0],centeredImage[i][1]);
            
            printf("\nSOP para pose 1\n");
            for (i=0; i<nbWorldPts; i++) printf("%f\t %f\n",projectedU1[i],projectedV1[i]);
            
            printf("\nSOP para pose 21\n");
            for (i=0; i<nbWorldPts; i++) printf("%f\t %f\n",projectedU2[i],projectedV2[i]);
        }
        

        
        /* distMat and assignMat calculation */
        for(i=0;i<nbImagePts;i++){
            for(j=0;j<nbWorldPts;j++){
                //                printf("U: %f\t V: %f\t Img: %f\t %f\t wk: %f\n",projectedU[j],projectedV[j],centeredImage[i][0],centeredImage[i][1],wk[j]);
                distMat1[i][j] = pow(focalLength,2.0)*(pow((projectedU1[j]-centeredImage[i][0]*wk1[j]),2)+pow((projectedV1[j]-centeredImage[i][1]*wk1[j]),2));
                double param=-beta*(distMat1[i][j]-alpha);
                assignMat1[i][j] = assMatScale*exp(param);
                
                distMat2[i][j] = pow(focalLength,2.0)*(pow((projectedU2[j]-centeredImage[i][0]*wk2[j]),2)+pow((projectedV[j]-centeredImage[i][1]*wk2[j]),2));
                param=-beta*(distMat2[i][j]-alpha);
                assignMat2[i][j] = assMatScale*exp(param);

                //                printf("assignMat[%d][%d]=%f\n",i,j,assignMat[i][j]);
            }
        }

        if(false){
            printf("\nMatriz de distancia1:\n");
            for (i=0; i<nbImagePts;i++) {
                for (j=0; j<nbWorldPts; j++) {
                    printf("%4.4f\t", distMat1[i][j]);
                }
                printf("\n");
            }
            
            printf("\nMatriz de distancia2:\n");
            for (i=0; i<nbImagePts;i++) {
                for (j=0; j<nbWorldPts; j++) {
                    printf("%4.4f\t", distMat2[i][j]);
                }
                printf("\n");
            }
        }

        
        sinkhornImp(assignMat1,nbImagePts+1,nbWorldPts+1);
        
        if(false){
            printf("\nMatriz de asignacion1:\n");
            for (i=0; i<nbImagePts+1;i++) {
                for (j=0; j<nbWorldPts+1; j++) {
                    printf("%4.4f\t", assignMat1[i][j]);
                }
                printf("\n");
            }
        }
        
        sinkhornImp(assignMat2,nbImagePts+1,nbWorldPts+1);
        
        if(false){
            printf("\nMatriz de asignacion2:\n");
            for (i=0; i<nbImagePts+1;i++) {
                for (j=0; j<nbWorldPts+1; j++) {
                    printf("%4.4f\t", assignMat2[i][j]);
                }
                printf("\n");
            }
        }

        
        double delta1 = 0;
        double delta2 = 0;
        for (i=0; i<nbImagePts; i++) {
            for (j=0; j<nbWorldPts; j++) {
                delta1+=assignMat1[i][j]*distMat1[i][j]/nbWorldPts;
                delta2+=assignMat2[i][j]*distMat2[i][j]/nbWorldPts;
            }
        }
        
        if (delta1<delta2){
            
            r1T[0]=r1Ta[0]/r3Ta[3];
            r1T[1]=r1Ta[1]/r3Ta[3];
            r1T[2]=r1Ta[2]/r3Ta[3];
            r1T[3]=r1Ta[3]/r3Ta[3];
            
            r2T[0]=r2Ta[0]/r3Ta[3];
            r2T[1]=r2Ta[1]/r3Ta[3];
            r2T[2]=r2Ta[2]/r3Ta[3];
            r2T[3]=r2Ta[3]/r3Ta[3];
            
            r3T[0]=r3Ta[0];
            r3T[1]=r3Ta[1];
            r3T[2]=r3Ta[2];
            r3T[3]=r3Ta[3];
            
            for(i=0;i<nbImagePts;i++){
                for(j=0;j<nbWorldPts;j++){
                    //                printf("U: %f\t V: %f\t Img: %f\t %f\t wk: %f\n",projectedU[j],projectedV[j],centeredImage[i][0],centeredImage[i][1],wk[j]);
                    distMat[i][j] = distMat1[i][j];
                    assignMat[i][j] = assignMat1[i][j];
                    
                }
            }
            delta=delta1;
        }
        else{
            r1T[0]=r1Tb[0]/r3Tb[3];
            r1T[1]=r1Tb[1]/r3Tb[3];
            r1T[2]=r1Tb[2]/r3Tb[3];
            r1T[3]=r1Tb[3]/r3Tb[3];
            
            r2T[0]=r2Tb[0]/r3Tb[3];
            r2T[1]=r2Tb[1]/r3Tb[3];
            r2T[2]=r2Tb[2]/r3Tb[3];
            r2T[3]=r2Tb[3]/r3Tb[3];
            
            r3T[0]=r3Tb[0];
            r3T[1]=r3Tb[1];
            r3T[2]=r3Tb[2];
            r3T[3]=r3Tb[3];
            for(i=0;i<nbImagePts;i++){
                for(j=0;j<nbWorldPts;j++){
                    //                printf("U: %f\t V: %f\t Img: %f\t %f\t wk: %f\n",projectedU[j],projectedV[j],centeredImage[i][0],centeredImage[i][1],wk[j]);
                    distMat[i][j] = distMat2[i][j];
                    assignMat[i][j] = assignMat2[i][j];
                    
                }
            }
            delta=delta2;

        }
        
//        VEC_PRINT_4(r1T);
//        VEC_PRINT_4(r2T);
//        VEC_PRINT_4(r3T);
            

        delta = sqrt(delta);
        poseConverged = delta < maxDelta;
        count++;
        beta *= betaUpdate;
        betaCount++;
        assignConverged = poseConverged && betaCount > minBetaCount;

        
    }
    
    
    trans[0]=r1T[3]*r3T[3];
    trans[1]=r2T[3]*r3T[3];
    trans[2]=r3T[3];
    
    for (i=0; i<3; i++) {
        rot[0][i]=r1T[i]*r3T[3];
        rot[1][i]=r2T[i]*r3T[3];
        rot[2][i]=r3T[i];
    }
    
    free(centeredImage);  
    free(homogeneusWorldPts);
    free(assignMat);
    free(wk);
    free(r1T);  
    free(r2T);
    free(r3T);
    free(distMat);
    
}


void sinkhornImp(double** assMat,int nbRow, int nbCol){
    
    int i,j;
    int iMaxIterSinkhorn = 60;
    double fEpsilon = 0.0001;
    int iNumSinkIter = 0;
    double fMdiffSum = fEpsilon + 1;
    double sum=0;
    int sizeMax=0;  
    int row=0,col=0;
    
    /* allocation for pos*/
    int** pos;
    pos = (int **)malloc(nbRow*sizeof(int*));
    for (i=0; i<nbRow; i++) pos[i] = (int*)malloc(2*sizeof(int));
    /* end alloc*/
    
    /* allocation for ratios*/
    double** ratios;
    ratios = (double **)malloc(nbRow*sizeof(double*));
    for (i=0; i<nbRow; i++) ratios[i] = (double*)malloc(2*sizeof(double));
    /* end alloc*/
        
    /* allocation for assMatPrev*/
    double** assMatPrev;
    assMatPrev = (double **)malloc(nbRow*sizeof(double*));
    for (i=0; i<nbRow; i++) assMatPrev[i] = (double*)malloc(nbCol*sizeof(double));
    /* end alloc*/

//    sizeMax=maxPosRatio(assMat,pos,ratios,nbRow,nbCol);
    
      
    while (fabs(fMdiffSum)> fEpsilon && iNumSinkIter<iMaxIterSinkhorn) {
        for (i=0; i<nbRow; i++) {
            for (j=0; j<nbCol; j++) {
                assMatPrev[i][j]=assMat[i][j];
            }
        }
        
        /* Row normalization (except outlier row - do not normalize col slacks against each other)*/
        for (i=0; i<nbRow-1; i++) {
            sum=0;
            for (j=0; j<nbCol; j++){
                sum+=assMat[i][j];     
            }
            for(j=0; j<nbCol; j++){
                assMat[i][j]/=sum;     
            }
        }
        
        /* fix values in the slack row*/
        for (i=0; i<sizeMax; i++) {
            row=pos[i][0];
            col=pos[i][1];
            assMat[nbRow-1][col]=ratios[i][1]*assMat[row][col];
        }

        /* Col normalization (except outlier column - do not normalize col slacks against each other)*/
        for (i=0; i<nbCol-1; i++) {
            sum=0;
            for (j=0; j<nbRow; j++){
             sum+=assMat[j][i];     
            }
            for(j=0; j<nbRow; j++){
                assMat[j][i]/=sum;     
            }
        }
        
        /* fix values in the slack column*/
        for (i=0; i<sizeMax; i++) {
            row=pos[i][0];
            col=pos[i][1];
            assMat[row][nbCol-1]=ratios[i][0]*assMat[row][col];
        }
 

        iNumSinkIter++;
        fMdiffSum=0;
        double x,y;
        for (i=0; i<nbRow-1; i++) {
            for (j=0; j<nbCol-1; j++) {
                fMdiffSum+=fabs(assMat[i][j]-assMatPrev[i][j]);
            }
        }
        
    }
    free(pos);
    free(ratios);
    free(assMatPrev);
}

int maxPosRatio(double** assMat,int** pos, double** ratios, int nbRow, int nbCol){
    
    int i,j,k;
    double max;
    int posMaxRow=0,posMaxCol=0;
    int size=0;
//    printf("pos(:,1)\t pos(:,2)\t ratio(:,1)\t ratio(:,2)\n");
    for(i=0;i<nbCol-1;i++){
        max=0;
        /* maxValue in the current column*/
        for(j=0;j<nbRow;j++){
            if (assMat[j][i]>(max)){
//                printf("assMat[%d][%d]=%f\n",j,i,assMat[j][i]);
                max = assMat[j][i];
                posMaxRow = j;
                posMaxCol = i;
            }
        }
        
        if(posMaxRow < nbRow-1){
            /* maxValue in the row containing the max value in the column*/
            for (k=0; k<nbCol; k++) {
                    if (assMat[posMaxRow][k]>(max)) {
//                    printf("assMat[%d][%d]=%f\n",posMaxRow,k,assMat[posMaxRow][k]);
                    max= assMat[posMaxRow][k];
                    posMaxCol = k;
                }
            }
            if (posMaxCol < nbCol-1 && posMaxCol>=i) {
                    
                
                    pos[size][0] = posMaxRow;
                    pos[size][1] = posMaxCol;
                    
                    ratios[size][0] = assMat[posMaxRow][nbCol-1]/assMat[posMaxRow][posMaxCol];
                    ratios[size][1] = assMat[nbRow-1][posMaxCol]/assMat[posMaxRow][posMaxCol];
//                    printf("%d\t %d\t %f\t %f\n",pos[size][0],pos[size][1],ratios[size][0],ratios[size][1]);
                    size++;    
                
                
            }
        }
    }
    return size;
}


