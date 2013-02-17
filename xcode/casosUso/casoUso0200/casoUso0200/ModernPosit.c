/*
 Program: ModernPosit.c
 Proyect: encuadro - Facultad de Ingeniería - UDELAR
 Author: Juan Ignacio Braun - juanibraun@gmail.com.
 
 Description:
 C implementation of modern posit, presented in the IJCV 2004 SoftPOSIT paper by Daniel DeMenthon.
 
 Hosted on:
 http://code.google.com/p/encuadro/
 *///

#include "ModernPosit.h"
#include "vvector.h"
#include "svd.h"


void  ModPosit(int NbPts,float** centeredImage,float** homogeneousWorldPts,float** objectMat, float focalLength,float center[2],float** R, float* T){
    /* 
    Esta funcion es identica a ModernPosit, se le cambian las entradas ya que se usa para positCoplanar donde se realizan dos calculos de pose por pasada. 
    Entradas:
    NbPts: numero de puntos
    centeredImage: los puntos de la imagen centrados divididos por la distancia focal. 
    homogeneousWorldPts: los puntos del modelo en coordenadas homogeneas.
    objectMat: la pseudo inversa de la matriz formada por los puntos del modelo en coordenadas homogeneas
    focalLength: distancia focal en pixeles. 
    center: centro en pixeles. 
    R: puntero donde guardar la matrtiz de rotacion.
    T: puntero donde guardar el vector de traslacion.
    */
    

    int i,j;
    float deltaX, deltaY,delta=0;
    float sR1,sR2,s;
    int count=0;
    bool converged= false;
    
    float* r1T;
    r1T=(float*)malloc(4*sizeof(float));
    float* r2T;
    r2T=(float*)malloc(4*sizeof(float));
    float* r3T;
    r3T=(float*)malloc(4*sizeof(float));
    
    /* allocation for centeredImage and centered imageAux*/
    float** centeredImageAux;
    centeredImageAux=(float **)malloc(NbPts* sizeof(float *));
    for (i=0;i<NbPts;i++){
        centeredImageAux[i]=(float *)malloc(2 * sizeof(float));
    }
    /* end alloc*/
    
    /*Convert to normalized image coordinates. With normalized coorinates, (0,0) is the point where the optic axis penetrates the image, and the focal length is 1*/ 
    for (i=0;i<NbPts;i++){
        centeredImageAux[i][0]=centeredImage[i][0];
        centeredImageAux[i][1]=centeredImage[i][1];
    }
    
    
    /* allocation for wk*/
    float* wk;
    wk=(float *)malloc(NbPts*sizeof(float));
    /* end alloc*/
    
    
    
    //    printf("objectMat:\n");
    //    for (j=0; j<4;j++) {
    //        for (i=0;i<NbPts;i++){
    //        printf("%f\t",objectMat[j][i]);
    //        }
    //        printf("\n");
    //    }
    
    
    while (!converged) {
        
        for (i=0; i<4; i++) {
            r1T[i]=0;
            r2T[i]=0;
            for (j=0; j<NbPts; j++) {
                r1T[i]+=objectMat[i][j]*centeredImageAux[j][0]; 
                r2T[i]+=objectMat[i][j]*centeredImageAux[j][1]; 
            }
        }
        
        printf("r1T:\n");
        for (i=0;i<4;i++) {
            printf("%f\t",r1T[i]);
        }
        printf("\n");
        
        printf("r2T:\n");
        for (i=0;i<4;i++) {
            printf("%f\t",r2T[i]);
        }
        printf("\n");
        
        sR1=1/sqrt(r1T[0]*r1T[0]+r1T[1]*r1T[1]+r1T[2]*r1T[2]); // norma de 1/r1T
        sR2=1/sqrt(r2T[0]*r2T[0]+r2T[1]*r2T[1]+r2T[2]*r2T[2]); // norma de 1/r2T
        s=sqrt(sR1*sR2); //norma de 1/s
        
        printf("sR1: %f\t sR2:%f\t s:%f\n",sR1,sR2,s);
        
        // normalizo r1T y r2T
        for (i=0; i<4; i++) {
            r1T[i]*=s;
            r2T[i]*=s;
        }
        
        //        printf("r1T:\n");
        //        for (i=0;i<4;i++) {
        //            printf("%f\t",r1T[i]);
        //        }
        //        printf("\n");
        //        
        //        printf("r2T:\n");
        //        for (i=0;i<4;i++) {
        //            printf("%f\t",r2T[i]);
        //        }
        //        printf("\n");
        
        
        for (i=0;i<3;i++){
            R[0][i]=r1T[i];
            R[1][i]=r2T[i];
        }
        
        // producto vectorial entre R1 y R2 para calcular R3
        R[2][0]=R[0][1]*R[1][2]-R[0][2]*R[1][1];
        R[2][1]=R[0][2]*R[1][0]-R[0][0]*R[1][2];
        R[2][2]=R[0][0]*R[1][1]-R[0][1]*R[1][0];
        
        r3T[0]=R[2][0];
        r3T[1]=R[2][1];
        r3T[2]=R[2][2];
        r3T[3]=s;
        
        
        //        printf("r3T:\n");
        //        for (i=0;i<4;i++) {
        //            printf("%f\t",r3T[i]);
        //        }
        //        printf("\n");
        
        
        T[0]=r1T[3];
        T[1]=r2T[3];
        T[2]=s;
        delta=0;
        for (i=0;i<NbPts;i++){
            wk[i]=0;
            deltaX=0;
            deltaY=0;
            for (j=0;j<4;j++){
                wk[i]+=homogeneousWorldPts[i][j]*r3T[j]/s;
            }
            deltaX+=centeredImageAux[i][0];
            deltaY+=centeredImageAux[i][1];
            centeredImageAux[i][0]=wk[i]*centeredImage[i][0];
            centeredImageAux[i][1]=wk[i]*centeredImage[i][1];
            deltaX-=centeredImageAux[i][0];
            deltaY-=centeredImageAux[i][1];
            delta+=deltaX*deltaX+deltaY*deltaY;
        }
        delta=focalLength*focalLength*delta;
        converged=count>0 && delta<1;
        count+=1;
    }
     // ARREGLAR tema de liberar memoria, hay que hacerlo fila por fila
    free(wk);
    free(r1T);
    free(r2T);
    free(r3T);
    free(centeredImageAux);
    


}

void  ModernPosit(int NbPts,float** imgPts,float** worldPts, float focalLength,float center[2],float **R, float* T){
    /* 
     Esta funcion calcula la pose dadas las correspondencias entre los puntos detectados en la imagen y los puntos del modelos 3D. La diferencia de esta version de posit con la version original es que no se necesita pasarle punto origen en el modelo. 
     Entradas:
     NbPts: numero de puntos
     imgPts: los puntos de la imagen.
     worldPts: los puntos del modelo.
     focalLength: distancia focal en pixeles. 
     center: centro en pixeles. 
     R: puntero donde guardar la matrtiz de rotacion.
     T: puntero donde guardar el vector de traslacion.
     */
    
    int i,j;
    float deltaX, deltaY,delta=0;
    float sR1,sR2,s;
    int count=0;
    bool converged= false;
    
    float* r1T;
    r1T=(float*)malloc(4*sizeof(float));
    float* r2T;
    r2T=(float*)malloc(4*sizeof(float));
    float* r3T;
    r3T=(float*)malloc(4*sizeof(float));

    
    /* allocation for centeredImage and centered imageAux*/
    float** centeredImage;
    float** centeredImageAux;
    centeredImage=(float **)malloc(NbPts* sizeof(float *));
    centeredImageAux=(float **)malloc(NbPts* sizeof(float *));
    for (i=0;i<NbPts;i++){
        centeredImage[i]=(float *)malloc(2 * sizeof(float));
        centeredImageAux[i]=(float *)malloc(2 * sizeof(float));
    }
    /* end alloc*/
    
    /*Convert to normalized image coordinates. With normalized coorinates, (0,0) is the point where the optic axis penetrates the image, and the focal length is 1*/ 
    for (i=0;i<NbPts;i++){
        centeredImage[i][0] = (imgPts[i][0] - center[0])/focalLength;
        centeredImage[i][1] = (imgPts[i][1] - center[1])/focalLength;
        centeredImageAux[i][0]=centeredImage[i][0];
        centeredImageAux[i][1]=centeredImage[i][1];
    }
    
    /* allocation for homogeneousWorldPts*/
    float** homogeneousWorldPts;
    homogeneousWorldPts=(float **)malloc(NbPts* sizeof(float *));
    for (i=0;i<NbPts;i++) homogeneousWorldPts[i]=(float *)malloc(4 * sizeof(float));
    /* end alloc*/ 
    
    /* Homogeneus world points -  append a 1 to each 3-vector. An Nx4 matrix.*/
    for (i=0;i<NbPts;i++){
        homogeneousWorldPts[i][0] = worldPts[i][0];
        homogeneousWorldPts[i][1] = worldPts[i][1];
        homogeneousWorldPts[i][2] = worldPts[i][2];
        homogeneousWorldPts[i][3] = 1;
    }
    
    /* allocation for wk*/
    float* wk;
    wk=(float *)malloc(NbPts*sizeof(float));
    /* end alloc*/
    
    
    /* objectMat alloc*/
    float** objectMat;
    objectMat=(float **)malloc(4 * sizeof(float*));
    for (i=0; i<4; i++) objectMat[i]=(float *)malloc(NbPts* sizeof(float));
    /* end*/
    
    PseudoInverseGen(homogeneousWorldPts,NbPts,4,objectMat);
    

    
//    printf("objectMat:\n");
//    for (j=0; j<4;j++) {
//        for (i=0;i<NbPts;i++){
//        printf("%f\t",objectMat[j][i]);
//        }
//        printf("\n");
//    }
          
    
    while (!converged) {
        
        for (i=0; i<4; i++) {
            r1T[i]=0;
            r2T[i]=0;
            for (j=0; j<NbPts; j++) {
                r1T[i]+=objectMat[i][j]*centeredImageAux[j][0]; 
                r2T[i]+=objectMat[i][j]*centeredImageAux[j][1]; 
            }
        }
        
        printf("r1T:\n");
        for (i=0;i<4;i++) {
            printf("%f\t",r1T[i]);
        }
        printf("\n");
        
        printf("r2T:\n");
        for (i=0;i<4;i++) {
            printf("%f\t",r2T[i]);
        }
        printf("\n");
        
        sR1=1/sqrt(r1T[0]*r1T[0]+r1T[1]*r1T[1]+r1T[2]*r1T[2]); // norma de 1/r1T
        sR2=1/sqrt(r2T[0]*r2T[0]+r2T[1]*r2T[1]+r2T[2]*r2T[2]); // norma de 1/r2T
        s=sqrt(sR1*sR2); //norma de 1/s
        
        printf("sR1: %f\t sR2:%f\t s:%f\n",sR1,sR2,s);
        
        // normalizo r1T y r2T
        for (i=0; i<4; i++) {
            r1T[i]*=s;
            r2T[i]*=s;
        }
        
//        printf("r1T:\n");
//        for (i=0;i<4;i++) {
//            printf("%f\t",r1T[i]);
//        }
//        printf("\n");
//        
//        printf("r2T:\n");
//        for (i=0;i<4;i++) {
//            printf("%f\t",r2T[i]);
//        }
//        printf("\n");

        
        for (i=0;i<3;i++){
            R[0][i]=r1T[i];
            R[1][i]=r2T[i];
        }
        
        // producto vectorial entre R1 y R2 para calcular R3
        R[2][0]=R[0][1]*R[1][2]-R[0][2]*R[1][1];
        R[2][1]=R[0][2]*R[1][0]-R[0][0]*R[1][2];
        R[2][2]=R[0][0]*R[1][1]-R[0][1]*R[1][0];

        r3T[0]=R[2][0];
        r3T[1]=R[2][1];
        r3T[2]=R[2][2];
        r3T[3]=s;
        
        
//        printf("r3T:\n");
//        for (i=0;i<4;i++) {
//            printf("%f\t",r3T[i]);
//        }
//        printf("\n");

        
        T[0]=r1T[3];
        T[1]=r2T[3];
        T[2]=s;
        delta=0;
        for (i=0;i<NbPts;i++){
            wk[i]=0;
            deltaX=0;
            deltaY=0;
            for (j=0;j<4;j++){
                wk[i]+=homogeneousWorldPts[i][j]*r3T[j]/s;
               }
            deltaX+=centeredImageAux[i][0];
            deltaY+=centeredImageAux[i][1];
            centeredImageAux[i][0]=wk[i]*centeredImage[i][0];
            centeredImageAux[i][1]=wk[i]*centeredImage[i][1];
            deltaX-=centeredImageAux[i][0];
            deltaY-=centeredImageAux[i][1];
            delta+=deltaX*deltaX+deltaY*deltaY;
        }
        delta=focalLength*focalLength*delta;
        converged=count>0 && delta<1;
        count+=1;
    }
    free(objectMat); // ARREGLAR tema de liberar memoria, hay que hacerlo fila por fila
    free(homogeneousWorldPts);
    free(wk);
    free(r1T);
    free(r2T);
    free(r3T);
    free(centeredImage);
    free(centeredImageAux);
    
    
    
}

