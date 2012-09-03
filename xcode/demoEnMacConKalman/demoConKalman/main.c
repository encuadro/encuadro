//
//  main.c
//  benchmark
//
//  Created by Juan Ignacio Braun on 7/25/12.
//  Copyright (c) 2012 juanibraun@gmail.com. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include "highgui.h"
#include "cv.h"
#include "lsd.h"
#include "segments.h"
#include "marker.h"
#include "CoplanarPosit.h"
#include "Composit.h"
#include "math.h"
#include <string.h>
#include <stdbool.h>
#include "sys/stat.h"

int main(int argc, const char * argv[])
{
    
    /*Variable para openCV y LSD*/
    int width, height;
	double *image;
	double **imagePoints,**imagePointsCrop;
	int i, j, listSize = 0, listFiltSize = 0; 	int listDim = 7;
	int distance_thr = 25;	// 4 pixels
    double scale=0.6;
    bool flag=false;
    bool flag1=false,flag2=false;
    
    
    
    /*Variables para el Coplanar*/
    int NumberOfPoints,k, cantPtsDetectados;
    double **object, **objectCrop;
    float **objectProy;
    double f; // Para el ipod y para el ipad tambien sirve /*f: focal length en pixels*/
    double** Rot;
    double* Tras;
    double center[2];
    double angles1[3];
    double angles2[3];

    
    NumberOfPoints=36;
    
    /*parametros intrinsecos*/  
    f=745.43429;
    center[0]=217.56288;
    center[1]=292.80331;
    float intrinsic[3][3]=  {{745.43429,  0,          217.56288},
        {0,          746.36170  ,292.80331},
        {0,          0,          1},
    };
    
    /*Reservamos memoria para pose*/
    Rot=(double **)malloc(3 * sizeof(double *));
    for (k=0;k<3;k++) Rot[k]=(double *)malloc(3 * sizeof(double));
    Tras=(double *)malloc(3 * sizeof(double));
    
    /*Reservo memoria para imagePioints2*/
    imagePointsCrop=(double **)malloc(NumberOfPoints*sizeof(double*));
    for(i=0;i<NumberOfPoints;i++)imagePointsCrop[i]=(double*)malloc(2*sizeof(double));
    
    /*Reservamos memoria para marcador*/
    object=(double **)malloc(NumberOfPoints * sizeof(double *));
    for (k=0;k<NumberOfPoints;k++) object[k]=(double *)malloc(3 * sizeof(double));
    
    objectCrop=(double **)malloc(NumberOfPoints * sizeof(double *));
    for (k=0;k<NumberOfPoints;k++) objectCrop[k]=(double *)malloc(3 * sizeof(double));
        
    objectProy=(float **)malloc(NumberOfPoints * sizeof(float *));
    for (k=0;k<NumberOfPoints;k++) objectProy[k]=(float *)malloc(2 * sizeof(float));
    
    //distancia entre marcadores, a segun x (eje largo), b segun y (eje corto)
    double a=182.5, b=98;       
    
    /* BEGIN MARKER */
    
    // Marcador 0
    
    object[0][0]=17.5;
    object[0][1]=17.5;
    object[0][2]=0.0;
    
    object[1][0]=17.5;   
    object[1][1]=-17.5;
    object[1][2]=0.0;
    
    object[2][0]=-17.5;
    object[2][1]=-17.5;
    object[2][2]=0.0;
    
    object[3][0]=-17.5; 
    object[3][1]=17.5;   
    object[3][2]=0.0;
    
    object[4][0]=32.5;
    object[4][1]=32.5;
    object[4][2]=0.0;
    
    object[5][0]=32.5;
    object[5][1]=-32.5;
    object[5][2]=0.0;
    
    object[6][0]=-32.5;
    object[6][1]=-32.5;
    object[6][2]=0.0;
    
    object[7][0]=-32.5;
    object[7][1]=32.5;
    object[7][2]=0.0;
    
    object[8][0]=47.5;
    object[8][1]=47.5;
    object[8][2]=0.0;
    
    object[9][0]=47.5;   
    object[9][1]=-47.5;
    object[9][2]=0.0;
    
    object[10][0]=-47.5;
    object[10][1]=-47.5;
    object[10][2]=0.0;
    
    object[11][0]=-47.5; 
    object[11][1]=47.5;  
    object[11][2]=0.0;
    
    // Marcador 1 
    
    object[12][0]=17.5+a;
    object[12][1]=17.5;
    object[12][2]=0.0;
    
    object[13][0]=17.5+a;   
    object[13][1]=-17.5;
    object[13][2]=0.0;
    
    object[14][0]=-17.5+a;
    object[14][1]=-17.5;
    object[14][2]=0.0;
    
    object[15][0]=-17.5+a; 
    object[15][1]=17.5;   
    object[15][2]=0.0;
    
    object[16][0]=32.5+a;
    object[16][1]=32.5;
    object[16][2]=0.0;
    
    object[17][0]=32.5+a;
    object[17][1]=-32.5;
    object[17][2]=0.0;
    
    object[18][0]=-32.5+a;
    object[18][1]=-32.5;
    object[18][2]=0.0;
    
    object[19][0]=-32.5+a;
    object[19][1]=32.5;
    object[19][2]=0.0;
    
    object[20][0]=47.5+a;
    object[20][1]=47.5;
    object[20][2]=0.0;
    
    object[21][0]=47.5+a;   
    object[21][1]=-47.5;
    object[21][2]=0.0;
    
    object[22][0]=-47.5+a;
    object[22][1]=-47.5;
    object[22][2]=0.0;
    
    object[23][0]=-47.5+a; 
    object[23][1]=47.5;  
    object[23][2]=0.0;    
    
    // Marcador 2 
    
    object[24][0]=17.5;
    object[24][1]=17.5+b;
    object[24][2]=0.0;
    
    object[25][0]=17.5;   
    object[25][1]=-17.5+b;
    object[25][2]=0.0;
    
    object[26][0]=-17.5;
    object[26][1]=-17.5+b;
    object[26][2]=0.0;
    
    object[27][0]=-17.5; 
    object[27][1]=17.5+b;   
    object[27][2]=0.0;
    
    object[28][0]=32.5;
    object[28][1]=32.5+b;
    object[28][2]=0.0;
    
    object[29][0]=32.5;
    object[29][1]=-32.5+b;
    object[29][2]=0.0;
    
    object[30][0]=-32.5;
    object[30][1]=-32.5+b;
    object[30][2]=0.0;
    
    object[31][0]=-32.5;
    object[31][1]=32.5+b;
    object[31][2]=0.0;
    
    object[32][0]=47.5;
    object[32][1]=47.5+b;
    object[32][2]=0.0;
    
    object[33][0]=47.5;   
    object[33][1]=-47.5+b;
    object[33][2]=0.0;
    
    object[34][0]=-47.5;
    object[34][1]=-47.5+b;
    object[34][2]=0.0;
    
    object[35][0]=-47.5; 
    object[35][1]=47.5+b;  
    object[35][2]=0.0;
    
    /* END MARKER*
     
     /*get memory for output list*/
    double *listFilt;
    listFilt=(double *) malloc ( 100 * listDim * sizeof(double));
    
      double *list;
    
    
     /*colors*/
	CvScalar green = CV_RGB(0,255,0);
	CvScalar white = CV_RGB(255,255,255);
	CvScalar black = CV_RGB(0,0,0);
	CvScalar red = CV_RGB(255,0,0);
	CvScalar blue = CV_RGB(0,0,255);
    
	/*font*/
	CvFont font1;
	cvInitFont(&font1, CV_FONT_HERSHEY_SIMPLEX, 0.5, 0.5, 0.5, 1, 8);
    
    /*drawing*/
    CvPoint pt1, pt2, pt3;
    
    /*windows*/
    cvNamedWindow( "OpenCV on acid",CV_WINDOW_AUTOSIZE);
    cvNamedWindow( "LSD",CV_WINDOW_AUTOSIZE);
    cvNamedWindow( "LSD filtered",CV_WINDOW_AUTOSIZE);	
    
    
    CvCapture* capture = cvCaptureFromCAM( CV_CAP_ANY );
    cvSetCaptureProperty(capture, CV_CAP_PROP_FRAME_WIDTH, 352);
    cvSetCaptureProperty(capture, CV_CAP_PROP_FRAME_HEIGHT, 288);
    
    
    IplImage* img = cvQueryFrame( capture );
    width  = img->width;
    height = img->height;
    IplImage *imgBW = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 1 );
    IplImage *imgLsd = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 3 );
    IplImage *imgLsdFilt = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 3 );

    if ( !capture ) {
        fprintf( stderr, "ERROR: capture is NULL \n" );
        getchar();
        return -1;
    }        
    
    // Show the image captured from the camera in the window and repeat
    while ( 1 ) {
        
        /*get image properties*/            
        img = cvQueryFrame( capture );
        width  = img->width;
        height = img->height;
        
        if ( !img ) {
            fprintf( stderr, "ERROR: frame is null...\n" );
            getchar();
            break;
        }
        
        
        
        
        /*create LSD image type*/
        image = (double *) malloc( width * height * sizeof(double) );
        if( image == NULL ){
            fprintf(stderr,"error: not enough memory\n");
            exit(EXIT_FAILURE);
        }
        
 
//        /*create OpenCV image structs*/
//        imgBW = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 1 );
//        imgLsd = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 3 );
//        imgLsdFilt = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 3 );
        
        
        /*convert to grayscale*/ 
        cvCvtColor( img , imgBW, CV_RGB2GRAY);
        
        /*cast into LSD image type*/
        uchar *data = (uchar *)imgBW->imageData;
        for (i=0;i<width;i++){
            for(j=0;j<height;j++){
                image[ i + j * width ] = data[ i + j * width];
            };
        };
        
        
        /*run LSD*/
      
        list = lsd_scale(&listSize, image, width, height,scale);
        
        /*filter LSD segments*/		
        listFilt = filterSegments( &listFiltSize , &listSize, list, distance_thr);
        //imagePoints = getCorners( &listFiltSize, listFilt);
        imagePoints = findPointCorrespondances(&listFiltSize, listFilt);
        
        /*draw segments on frame and frameLsd*/
        cvSet(imgLsd, black, 0);
        for (j=0; j<listSize ; j++){		
            //define segment end-points
            pt1 = cvPoint(list[ 0 + j * listDim ],list[ 1 + j * listDim ]);
            pt2 = cvPoint(list[ 2 + j * listDim ],list[ 3 + j * listDim ]);
            
            // draw line on frame
            cvLine(img,pt1,pt2,white,1.5,8,0);
            
            // draw line on frameLsd
            cvLine(imgLsd,pt1,pt2,white,1.5,8,0);
        }
        
        
        
        
        cvShowImage("OpenCV on acid",img);
        cvShowImage("LSD",imgLsd);
        
        
        
        
        for (j=0;j<NumberOfPoints;j++){
            //            printf("%g\t%g\n",imagePoints[j][0],imagePoints[j][1]);
            
            if (!flag1) {
                flag1=((imagePoints[j][0]==0)&&(imagePoints[j][1]==0))||(imagePoints[j][0]>1000)||(imagePoints[j][1]>1000);
            }    
            else {
                flag2=((imagePoints[j][0]==0)&&(imagePoints[j][1]==0))||(imagePoints[j][0]>1000)||(imagePoints[j][1]>1000);
                
            }
            flag=flag1&&flag2;
            if (flag) break;
        }
        
        
        cantPtsDetectados=getCropLists(imagePoints, object, imagePointsCrop, objectCrop);
        
        //        for (int i=cantPtsDetectados; i<NumberOfPoints; i++) {
        //            free(imagePointsCrop[i]);
        //            free(objectCrop[i]);
        //            free(imagePoints4Composit[i]);
        //        }
        //        imagePointsCrop=realloc(imagePointsCrop, cantPtsDetectados*sizeof(double**));
        //        objectCrop=realloc(objectCrop, cantPtsDetectados*sizeof(double**));
        //        imagePoints4Composit=realloc(imagePoints4Composit, cantPtsDetectados*sizeof(double**));
        
        
        
        /* chequeo si hay error de filtro o de Pose*/
        if (!flag) {
            CoplanarPosit(cantPtsDetectados, imagePointsCrop, objectCrop, f, center, Rot, Tras);
        
            
            printf("\nRotacion: \n");
            printf("%f\t %f\t %f\n",Rot[0][0],Rot[0][1],Rot[0][2]);
            printf("%f\t %f\t %f\n",Rot[1][0],Rot[1][1],Rot[1][2]);
            printf("%f\t %f\t %f\n",Rot[2][0],Rot[2][1],Rot[2][2]);
            printf("Traslacion: \n");
            printf("%f\ t %f\t %f\n",Tras[0],Tras[1],Tras[2]);
            
            Matrix2Euler(Rot,angles1,angles2);
            
            printf("\nPrimera solicion\n");
            printf("theta1: %g\npsi1: %g\nphi1: %g\n",angles1[0],angles1[1],angles1[2]);
            printf("\nSegunda solicion\n");
            printf("theta2: %g\npsi2: %g\nphi2: %g\n",angles2[0],angles2[1],angles2[2]);
        }
        /*Poject object points and save reprojection error*/
        
        for(i=0;i<NumberOfPoints;i++){
            
            /*project CoplanarPosit*/
            float a[3],b[3];
            b[0]=object[i][0];
            b[1]=object[i][1];
            b[2]=object[i][2];
            MAT_DOT_VEC_3X3(a, Rot, b);
            VEC_SUM(b,a,Tras);
            objectProy[i][0]=intrinsic[0][2]+intrinsic[0][0]*b[0]/b[2];
            objectProy[i][1]=intrinsic[1][2]+intrinsic[1][1]*b[1]/b[2];
            //            printf("%g\t%g\n",objectProy[i][0],objectProy[i][1]);

    
        }
        
        
        
        /*draw segments on actual frameLsdFilt*/
        cvSet(imgLsdFilt, black, 0);	
        for (j=0; j<listFiltSize ; j++){
            //define segment end-points
            pt1 = cvPoint(listFilt[ 0 + j * listDim ],listFilt[ 1 + j * listDim ]);
            pt2 = cvPoint(listFilt[ 2 + j * listDim ],listFilt[ 3 + j * listDim ]);
            
            // draw line on frameLsd
            cvLine(imgLsdFilt,pt1,pt2,white,1.5,8,0);
            
            if (j<36){
                //define marker corners
                pt1 = cvPoint(imagePoints[j][0],imagePoints[j][1]);
                // draw small corner circle
                cvCircle(imgLsdFilt, pt1, 3, green, 1, 8, 0);
                pt2 = cvPoint(objectProy[j][0],objectProy[j][1]);
                // draw small corner circle
                cvCircle(imgLsdFilt, pt2, 3, red, 1, 8, 0);
                char *ind[2];
                sprintf(ind,"%d",j);
                cvPutText(imgLsdFilt, ind, pt1, &font1 , blue);
                
            }
        }
        
        /* free memory */
        free(list);
        free(listFilt);
        listFiltSize = 0;
        listSize = 0;
        
        /*free imagePoints memory*/
        for(i = 0; i < 36; i++)
            free(imagePoints[i]);
        free(imagePoints);
        /********************/

        free(image);
        
        for (i=0;i<3;i++){
            Rot[i][0]=0;
            Rot[i][1]=0;
            Rot[i][2]=0;
            Tras[i]=0;
        }
        
        cvShowImage("LSD filtered",imgLsdFilt);
    
        

        
        flag=false;
        flag1=false;
        flag2=false;
        if ( (cvWaitKey(10) & 255) == 27 ) break;
        
        
    }
    /* free memory */
    
    cvReleaseImage( &img );
    cvReleaseImage( &imgLsd );
    cvReleaseImage( &imgLsdFilt );
    
    
    cvDestroyWindow( "OpenCV on acid");
    cvDestroyWindow( "LSD");
    cvDestroyWindow( "LSD filtered");
    cvReleaseCapture( &capture ); 
    return 0;
    
}



