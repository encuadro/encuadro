//
//  SoftPosit.c
//  CoplanarPosit
//
//  Created by Juan Ignacio Braun on 3/16/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//

#include "softPosit.h"
#include "svd.h"

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
    int minBetaCount = 20; 
    
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
        printf("\n");
        printf("r1T\n");
        printf("%f\t %f\t %f\t %f\n", r1T[0],r1T[1],r1T[2],r1T[3]);

        printf("\n");
        printf("r2T\n");
        printf("%f\t %f\t %f\t %f\n", r2T[0],r2T[1],r2T[2],r2T[3]);

        
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
        
//        printf("Matriz de distancia\n");
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", distMat[0][0],distMat[0][1],distMat[0][2],distMat[0][3],distMat[0][4],distMat[0][5],distMat[0][6],distMat[0][7]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", distMat[1][0],distMat[1][1],distMat[1][2],distMat[1][3],distMat[1][4],distMat[1][5],distMat[1][6],distMat[1][7]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", distMat[2][0],distMat[2][1],distMat[2][2],distMat[2][3],distMat[2][4],distMat[2][5],distMat[2][6],distMat[2][7]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", distMat[3][0],distMat[3][1],distMat[3][2],distMat[3][3],distMat[3][4],distMat[3][5],distMat[3][6],distMat[3][7]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", distMat[4][0],distMat[4][1],distMat[4][2],distMat[4][3],distMat[4][4],distMat[4][5],distMat[4][6],distMat[4][7]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", distMat[5][0],distMat[5][1],distMat[5][2],distMat[5][3],distMat[5][4],distMat[5][5],distMat[5][6],distMat[5][7]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", distMat[6][0],distMat[6][1],distMat[6][2],distMat[6][3],distMat[6][4],distMat[6][5],distMat[6][6],distMat[6][7]);
        
             
        i=0;
        for(i=0;i<nbImagePts+1;i++){
            assignMat[i][nbWorldPts] = scale;
//            printf("assignMat[%d][%d]:%f\n",i,nbWorldPts,assignMat[i][nbWorldPts]);
        }
        
        for(i=0;i<nbWorldPts+1;i++){
            assignMat[nbImagePts][i] = scale;
        }
        
//        printf("\n");
//        printf("Matriz de asignacion\n");
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[0][0],assignMat[0][1],assignMat[0][2],assignMat[0][3],assignMat[0][4],assignMat[0][5],assignMat[0][6],assignMat[0][7],assignMat[0][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[1][0],assignMat[1][1],assignMat[1][2],assignMat[1][3],assignMat[1][4],assignMat[1][5],assignMat[1][6],assignMat[1][7],assignMat[1][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[2][0],assignMat[2][1],assignMat[2][2],assignMat[2][3],assignMat[2][4],assignMat[2][5],assignMat[2][6],assignMat[2][7],assignMat[2][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[3][0],assignMat[3][1],assignMat[3][2],assignMat[3][3],assignMat[3][4],assignMat[3][5],assignMat[3][6],assignMat[3][7],assignMat[3][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[4][0],assignMat[4][1],assignMat[4][2],assignMat[4][3],assignMat[4][4],assignMat[4][5],assignMat[4][6],assignMat[4][7],assignMat[4][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[5][0],assignMat[5][1],assignMat[5][2],assignMat[5][3],assignMat[5][4],assignMat[5][5],assignMat[5][6],assignMat[5][7],assignMat[5][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[6][0],assignMat[6][1],assignMat[6][2],assignMat[6][3],assignMat[6][4],assignMat[6][5],assignMat[6][6],assignMat[6][7],assignMat[6][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[7][0],assignMat[7][1],assignMat[7][2],assignMat[7][3],assignMat[7][4],assignMat[7][5],assignMat[7][6],assignMat[7][7],assignMat[7][8]);


        sinkhornImp(assignMat,nbImagePts+1,nbWorldPts+1);
        
//        printf("\n");
//        printf("Matriz de asignacion\n");
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[0][0],assignMat[0][1],assignMat[0][2],assignMat[0][3],assignMat[0][4],assignMat[0][5],assignMat[0][6],assignMat[0][7],assignMat[0][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[1][0],assignMat[1][1],assignMat[1][2],assignMat[1][3],assignMat[1][4],assignMat[1][5],assignMat[1][6],assignMat[1][7],assignMat[1][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[2][0],assignMat[2][1],assignMat[2][2],assignMat[2][3],assignMat[2][4],assignMat[2][5],assignMat[2][6],assignMat[2][7],assignMat[2][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[3][0],assignMat[3][1],assignMat[3][2],assignMat[3][3],assignMat[3][4],assignMat[3][5],assignMat[3][6],assignMat[3][7],assignMat[3][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[4][0],assignMat[4][1],assignMat[4][2],assignMat[4][3],assignMat[4][4],assignMat[4][5],assignMat[4][6],assignMat[4][7],assignMat[4][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[5][0],assignMat[5][1],assignMat[5][2],assignMat[5][3],assignMat[5][4],assignMat[5][5],assignMat[5][6],assignMat[5][7],assignMat[5][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[6][0],assignMat[6][1],assignMat[6][2],assignMat[6][3],assignMat[6][4],assignMat[6][5],assignMat[6][6],assignMat[6][7],assignMat[6][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[7][0],assignMat[7][1],assignMat[7][2],assignMat[7][3],assignMat[7][4],assignMat[7][5],assignMat[7][6],assignMat[7][7],assignMat[7][8]);
        
                
        /* sumSkSkT definition and initiaization*/ 
        
        for (i=0; i<4; i++) {
            for(j=0;j<4;j++){
                sumSkSkT[i][j]=0;
            }
        }
        /*end*/
//        printf("sumCol\n");
        /* calculation for sumSkSkt*/
        for(i=0;i<nbWorldPts;i++){
            double sumCol=0;
            for (j=0; j<nbImagePts; j++) {
                sumCol+=assignMat[j][i];   
            }
//            printf("%f\t",sumCol);
            for (m=0; m<4; m++) {
                for (n=0; n<4; n++) {
                    sumSkSkT[m][n]+=sumCol*homogeneusWorldPts[i][m]*homogeneusWorldPts[i][n];
                }
            }
        }
        /*end*/
    
    
        PseudoInverseGen(sumSkSkT,4,4,objectMat);
        
//        printf("\n");
//        printf("Matriz de sumSkSkt\n");
//        printf("%f\t %f\t %f\t %f\n", sumSkSkT[0][0],sumSkSkT[0][1],sumSkSkT[0][2],sumSkSkT[0][3]);
//        printf("%f\t %f\t %f\t %f\n", sumSkSkT[1][0],sumSkSkT[1][1],sumSkSkT[1][2],sumSkSkT[1][3]);
//        printf("%f\t %f\t %f\t %f\n", sumSkSkT[2][0],sumSkSkT[2][1],sumSkSkT[2][2],sumSkSkT[2][3]);
//        printf("%f\t %f\t %f\t %f\n", sumSkSkT[3][0],sumSkSkT[3][1],sumSkSkT[3][2],sumSkSkT[3][3]);
//        printf("\n");
//        
//        printf("\n");
//        printf("Matriz objectMat\n");
//        printf("%f\t %f\t %f\t %f\n", objectMat[0][0],objectMat[0][1],objectMat[0][2],objectMat[0][3]);
//        printf("%f\t %f\t %f\t %f\n", objectMat[1][0],objectMat[1][1],objectMat[1][2],objectMat[1][3]);
//        printf("%f\t %f\t %f\t %f\n", objectMat[2][0],objectMat[2][1],objectMat[2][2],objectMat[2][3]);
//        printf("%f\t %f\t %f\t %f\n", objectMat[3][0],objectMat[3][1],objectMat[3][2],objectMat[3][3]);
//        printf("\n");

      
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
        
                printf("\n");
                printf("Matriz de asignacion\n");
                printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[0][0],assignMat[0][1],assignMat[0][2],assignMat[0][3],assignMat[0][4],assignMat[0][5],assignMat[0][6],assignMat[0][7],assignMat[0][8]);
            printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[1][0],assignMat[1][1],assignMat[1][2],assignMat[1][3],assignMat[1][4],assignMat[1][5],assignMat[1][6],assignMat[1][7],assignMat[1][8]);
            printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[2][0],assignMat[2][1],assignMat[2][2],assignMat[2][3],assignMat[2][4],assignMat[2][5],assignMat[2][6],assignMat[2][7],assignMat[2][8]);
                printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[3][0],assignMat[3][1],assignMat[3][2],assignMat[3][3],assignMat[3][4],assignMat[3][5],assignMat[3][6],assignMat[3][7],assignMat[3][8]);
                printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[4][0],assignMat[4][1],assignMat[4][2],assignMat[4][3],assignMat[4][4],assignMat[4][5],assignMat[4][6],assignMat[4][7],assignMat[4][8]);
                printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[5][0],assignMat[5][1],assignMat[5][2],assignMat[5][3],assignMat[5][4],assignMat[5][5],assignMat[5][6],assignMat[5][7],assignMat[5][8]);
                printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[6][0],assignMat[6][1],assignMat[6][2],assignMat[6][3],assignMat[6][4],assignMat[6][5],assignMat[6][6],assignMat[6][7],assignMat[6][8]);
               printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assignMat[7][0],assignMat[7][1],assignMat[7][2],assignMat[7][3],assignMat[7][4],assignMat[7][5],assignMat[7][6],assignMat[7][7],assignMat[7][8]);
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

void sinkhornImp(double** assMat,int nbRow, int nbCol){
    
    int i,j;
    int iMaxIterSinkhorn = 60;
    double fEpsilon = 0.001;
    int iNumSinkIter = 0;
    double fMdiffSum = fEpsilon + 1;
    double sum=0;
    int sizeMax=0;    
    
    /* allocation for pos*/
    double** pos;
    pos = (double **)malloc(nbRow*sizeof(double*));
    for (i=0; i<nbRow; i++) pos[i] = (double*)malloc(2*sizeof(double));
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

    maxPosRatio(assMat,pos,ratios,nbRow,nbCol,sizeMax);
    
    while (fabs(fMdiffSum)> fEpsilon && iNumSinkIter<iMaxIterSinkhorn) {
        for (i=0; i<nbRow; i++) {
            for (j=0; j<nbCol; j++) {
                assMatPrev[i][j]=assMat[i][j];
            }
        }
//        assMatPrev=assMat;
        
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
        
//        printf("\n");
//        printf("Matriz de asignacion\n");
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[0][0],assMat[0][1],assMat[0][2],assMat[0][3],assMat[0][4],assMat[0][5],assMat[0][6],assMat[0][7],assMat[0][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[1][0],assMat[1][1],assMat[1][2],assMat[1][3],assMat[1][4],assMat[1][5],assMat[1][6],assMat[1][7],assMat[1][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[2][0],assMat[2][1],assMat[2][2],assMat[2][3],assMat[2][4],assMat[2][5],assMat[2][6],assMat[2][7],assMat[2][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[3][0],assMat[3][1],assMat[3][2],assMat[3][3],assMat[3][4],assMat[3][5],assMat[3][6],assMat[3][7],assMat[3][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[4][0],assMat[4][1],assMat[4][2],assMat[4][3],assMat[4][4],assMat[4][5],assMat[4][6],assMat[4][7],assMat[4][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[5][0],assMat[5][1],assMat[5][2],assMat[5][3],assMat[5][4],assMat[5][5],assMat[5][6],assMat[5][7],assMat[5][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[6][0],assMat[6][1],assMat[6][2],assMat[6][3],assMat[6][4],assMat[6][5],assMat[6][6],assMat[6][7],assMat[6][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[7][0],assMat[7][1],assMat[7][2],assMat[7][3],assMat[7][4],assMat[7][5],assMat[7][6],assMat[7][7],assMat[7][8]);

        /* fix values in the slack column*/
        for (i=0; i<sizeMax; i++) {
            int row,col;
            row=pos[i][0];
            col=pos[i][1];
            assMat[row][nbCol]=ratios[i][0]*assMat[row][col];
        }

//        printf("\n");
//        printf("Matriz de asignacion\n");
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[0][0],assMat[0][1],assMat[0][2],assMat[0][3],assMat[0][4],assMat[0][5],assMat[0][6],assMat[0][7],assMat[0][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[1][0],assMat[1][1],assMat[1][2],assMat[1][3],assMat[1][4],assMat[1][5],assMat[1][6],assMat[1][7],assMat[1][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[2][0],assMat[2][1],assMat[2][2],assMat[2][3],assMat[2][4],assMat[2][5],assMat[2][6],assMat[2][7],assMat[2][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[3][0],assMat[3][1],assMat[3][2],assMat[3][3],assMat[3][4],assMat[3][5],assMat[3][6],assMat[3][7],assMat[3][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[4][0],assMat[4][1],assMat[4][2],assMat[4][3],assMat[4][4],assMat[4][5],assMat[4][6],assMat[4][7],assMat[4][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[5][0],assMat[5][1],assMat[5][2],assMat[5][3],assMat[5][4],assMat[5][5],assMat[5][6],assMat[5][7],assMat[5][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[6][0],assMat[6][1],assMat[6][2],assMat[6][3],assMat[6][4],assMat[6][5],assMat[6][6],assMat[6][7],assMat[6][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[7][0],assMat[7][1],assMat[7][2],assMat[7][3],assMat[7][4],assMat[7][5],assMat[7][6],assMat[7][7],assMat[7][8]);
 
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
//        printf("\n");
//        printf("Matriz de asignacion\n");
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[0][0],assMat[0][1],assMat[0][2],assMat[0][3],assMat[0][4],assMat[0][5],assMat[0][6],assMat[0][7],assMat[0][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[1][0],assMat[1][1],assMat[1][2],assMat[1][3],assMat[1][4],assMat[1][5],assMat[1][6],assMat[1][7],assMat[1][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[2][0],assMat[2][1],assMat[2][2],assMat[2][3],assMat[2][4],assMat[2][5],assMat[2][6],assMat[2][7],assMat[2][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[3][0],assMat[3][1],assMat[3][2],assMat[3][3],assMat[3][4],assMat[3][5],assMat[3][6],assMat[3][7],assMat[3][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[4][0],assMat[4][1],assMat[4][2],assMat[4][3],assMat[4][4],assMat[4][5],assMat[4][6],assMat[4][7],assMat[4][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[5][0],assMat[5][1],assMat[5][2],assMat[5][3],assMat[5][4],assMat[5][5],assMat[5][6],assMat[5][7],assMat[5][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[6][0],assMat[6][1],assMat[6][2],assMat[6][3],assMat[6][4],assMat[6][5],assMat[6][6],assMat[6][7],assMat[6][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[7][0],assMat[7][1],assMat[7][2],assMat[7][3],assMat[7][4],assMat[7][5],assMat[7][6],assMat[7][7],assMat[7][8]);

        
        /* fix values in the slack row*/
        for (i=0; i<sizeMax; i++) {
            int row,col;
            row=pos[i][0];
            col=pos[i][1];
            assMat[nbRow][col]=ratios[i][1]*assMat[row][col];
        }

//        printf("\n");
//        printf("Matriz de asignacion\n");
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[0][0],assMat[0][1],assMat[0][2],assMat[0][3],assMat[0][4],assMat[0][5],assMat[0][6],assMat[0][7],assMat[0][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[1][0],assMat[1][1],assMat[1][2],assMat[1][3],assMat[1][4],assMat[1][5],assMat[1][6],assMat[1][7],assMat[1][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[2][0],assMat[2][1],assMat[2][2],assMat[2][3],assMat[2][4],assMat[2][5],assMat[2][6],assMat[2][7],assMat[2][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[3][0],assMat[3][1],assMat[3][2],assMat[3][3],assMat[3][4],assMat[3][5],assMat[3][6],assMat[3][7],assMat[3][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[4][0],assMat[4][1],assMat[4][2],assMat[4][3],assMat[4][4],assMat[4][5],assMat[4][6],assMat[4][7],assMat[4][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[5][0],assMat[5][1],assMat[5][2],assMat[5][3],assMat[5][4],assMat[5][5],assMat[5][6],assMat[5][7],assMat[5][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[6][0],assMat[6][1],assMat[6][2],assMat[6][3],assMat[6][4],assMat[6][5],assMat[6][6],assMat[6][7],assMat[6][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMat[7][0],assMat[7][1],assMat[7][2],assMat[7][3],assMat[7][4],assMat[7][5],assMat[7][6],assMat[7][7],assMat[7][8]);
//        
//        printf("\n");
//        printf("Matriz de asignacion\n");
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMatPrev[0][0],assMatPrev[0][1],assMatPrev[0][2],assMatPrev[0][3],assMatPrev[0][4],assMatPrev[0][5],assMatPrev[0][6],assMatPrev[0][7],assMatPrev[0][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMatPrev[1][0],assMatPrev[1][1],assMatPrev[1][2],assMatPrev[1][3],assMatPrev[1][4],assMatPrev[1][5],assMatPrev[1][6],assMatPrev[1][7],assMatPrev[1][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMatPrev[2][0],assMatPrev[2][1],assMatPrev[2][2],assMatPrev[2][3],assMatPrev[2][4],assMatPrev[2][5],assMatPrev[2][6],assMatPrev[2][7],assMatPrev[2][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMatPrev[3][0],assMatPrev[3][1],assMatPrev[3][2],assMatPrev[3][3],assMatPrev[3][4],assMatPrev[3][5],assMatPrev[3][6],assMatPrev[3][7],assMatPrev[3][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMatPrev[4][0],assMatPrev[4][1],assMatPrev[4][2],assMatPrev[4][3],assMatPrev[4][4],assMatPrev[4][5],assMatPrev[4][6],assMatPrev[4][7],assMatPrev[4][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMatPrev[5][0],assMatPrev[5][1],assMatPrev[5][2],assMatPrev[5][3],assMatPrev[5][4],assMatPrev[5][5],assMatPrev[5][6],assMatPrev[5][7],assMatPrev[5][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMatPrev[6][0],assMatPrev[6][1],assMatPrev[6][2],assMatPrev[6][3],assMatPrev[6][4],assMatPrev[6][5],assMatPrev[6][6],assMatPrev[6][7],assMatPrev[6][8]);
//        printf("%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", assMatPrev[7][0],assMatPrev[7][1],assMatPrev[7][2],assMatPrev[7][3],assMatPrev[7][4],assMatPrev[7][5],assMatPrev[7][6],assMatPrev[7][7],assMatPrev[7][8]);


        iNumSinkIter++;
        fMdiffSum=0;
        double x,y;
        for (i=0; i<nbRow; i++) {
            for (j=0; j<nbCol; j++) {
                fMdiffSum+=fabs(assMat[i][j]-assMatPrev[i][j]);
            }
        }
        
    }
    free(pos);
    free(ratios);
    free(assMatPrev);
}

void maxPosRatio(double** assMat,double** pos, double** ratios, int nbRow, int nbCol, int sizeMax){
    
    int i,j,k;
    double maxCol;
    double maxRow;
    int posMaxRow,posMaxCol;
    sizeMax=0;
//    printf("pos(:,1)\t pos(:,2)\t ratio(:,1)\t ratio(:,2)\n");
    for(i=0;i<nbCol-1;i++){
        maxCol=0;
        maxRow=0;
        /* maxValue in the current column*/
        for(j=0;j<nbRow;j++){
            if (assMat[j][i]>maxCol){
//                printf("assMat[%d][%d]=%f\n",j,i,assMat[j][i]);
                maxCol = assMat[j][i];
                posMaxRow = j;
            }
        }
        
        if(posMaxRow < nbRow-1){
            /* maxValue in the row containing the max value in the column*/
            for (k=0; k<nbCol; k++) {
                if (assMat[posMaxRow][k]>maxRow) {
//                    printf("assMat[%d][%d]=%f\n",posMaxRow,k,assMat[posMaxRow][k]);
                    maxRow = assMat[posMaxRow][k];
                    posMaxCol = k;
                }
            }
            if (posMaxCol < nbCol-1) {
                sizeMax++;
                
                if (!(i>0 && (posMaxRow==pos[i-1][0]) && (posMaxCol==pos[i-1][1]))) {
                    pos[i][0] = posMaxRow;
                    pos[i][1] = posMaxCol;
                    
                    ratios[i][0] = assMat[posMaxRow][nbCol-1]/assMat[posMaxRow][posMaxCol];
                    ratios[i][1] = assMat[nbRow-1][posMaxCol]/assMat[posMaxRow][posMaxCol];
//                    printf("%f\t %f\t %f\t %f\n",pos[i][0],pos[i][1],ratios[i][0],ratios[i][1]);

                }
            }
        }
    }
}


