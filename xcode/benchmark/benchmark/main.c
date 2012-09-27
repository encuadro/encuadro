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
    
    /*================================================================*/
    /*=================Definiciones de variables======================*/
    /*================================================================*/
    
    int width, height;
    double f;
    double** Rot;
    double* Tras;
    double** Rot4Composit;
    double* Trans4Composit;
    double center[2];
    double x,y,err,x4Composit,y4Composit,err4Composit;
//
//    Render 480x360
    float intrinsic[3][3]=  {{586.6381,  0,         240.0000},
        {0,          586.6381  ,180.0000},
        {0,          0,          1},
    };
    
    
////    Camara iPod 640x480
//    float intrinsic[3][3]=  {{745.43429,  0,         292.80331},
//        {0,          746.36170  ,217.56288},
//        {0,          0,          1},
//    };
    
    f=intrinsic[0][0];
    center[0]=intrinsic[0][2];
    center[1]=intrinsic[1][2];
    
    int NumberOfPoints=36;
    double *image;
	double **imagePoints;
    double **imagePoints4Composit;
    double **imagePointsCrop;
    double **object;
    double **objectCrop;
    float **objectCamera;
    float **objectProy;
    double **objectProy4Composit;
    
    int i, j, listSize = 0, listFiltSize = 0; 	int listDim = 7;
	int distance_thr = 25;	// Threshold para findPointsCorrespondences
    int errorMarkerDetection; // codigo de error que devuelve findPointCorrespondences

    bool verImg=false; // para ver imagenes mientras se hace el benchmark
    
    double scale=0.8; // scale para el LSD
    int k;
    int cantPtsDetectados; // cantidad de puntos del maracador

    /*================================================================*/

    
    /*================================================================*/
    /*===============directorios para guardar datos===================*/
    /*================================================================*/
    
    char folderName[100];
    sprintf(folderName, "%s%s%g",argv[1],"Scale",scale);
    mkdir(folderName,S_IRWXU);
    sprintf(folderName, "%s%s%d%s",folderName,"/threshold",distance_thr,"/");
    mkdir(folderName,S_IRWXU);
    
    /*================================================================*/

    
    /*================================================================*/
    /*===================Reserva de memoria===========================*/
    /*================================================================*/
    /*Reservamos memoria para pose*/
    Rot=(double **)malloc(3 * sizeof(double *));
    for (k=0;k<3;k++) Rot[k]=(double *)malloc(3 * sizeof(double));
    Tras=(double *)malloc(3 * sizeof(double));
    
    Rot4Composit=(double **)malloc(3 * sizeof(double *));
    for (k=0;k<3;k++) Rot4Composit[k]=(double *)malloc(3 * sizeof(double));
    Trans4Composit=(double *)malloc(3 * sizeof(double));

    
    /*Reservo memoria para imagePoints*/
    imagePoints=(double **)malloc(NumberOfPoints*sizeof(double*));
    for(i=0;i<NumberOfPoints;i++)imagePoints[i]=(double*)malloc(2*sizeof(double));
    
    /*Reservo memoria para imagePioints4Composit*/
    imagePoints4Composit=(double **)malloc(NumberOfPoints*sizeof(double*));
    for(i=0;i<NumberOfPoints;i++)imagePoints4Composit[i]=(double*)malloc(2*sizeof(double));
    
    /*Reservo memoria para imagePiointsCrop*/
    imagePointsCrop=(double **)malloc(NumberOfPoints*sizeof(double*));
    for(i=0;i<NumberOfPoints;i++)imagePointsCrop[i]=(double*)malloc(2*sizeof(double));
    
    /*Reservamos memoria para marcador*/
    object=(double **)malloc(NumberOfPoints * sizeof(double *));
    for (k=0;k<NumberOfPoints;k++) object[k]=(double *)malloc(3 * sizeof(double));
    
    /*Reservamos memoria para marcador Crop*/
    objectCrop=(double **)malloc(NumberOfPoints * sizeof(double *));
    for (k=0;k<NumberOfPoints;k++) objectCrop[k]=(double *)malloc(3 * sizeof(double));
    
    /*Reservamos memoria para marcador en el eje de coordenadas de la camara*/
    objectCamera=(float **)malloc(NumberOfPoints * sizeof(float *));
    for (k=0;k<NumberOfPoints;k++) objectCamera[k]=(float *)malloc(3 * sizeof(float));
    
    /*Reservamos memoria para marcador proyectado sobre imagen*/
    objectProy=(float **)malloc(NumberOfPoints * sizeof(float *));
    for (k=0;k<NumberOfPoints;k++) objectProy[k]=(float *)malloc(2 * sizeof(float));

    /*Reservamos memoria para marcador proyectado sobre imagen para composit*/
    objectProy4Composit=(double **)malloc(NumberOfPoints * sizeof(double *));
    for (k=0;k<NumberOfPoints;k++) objectProy4Composit[k]=(double *)malloc(2 * sizeof(double));
     
    /*================================================================*/
    
    
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
    
    /* leo que caso estoy analizando*/
    long int l=strlen(argv[1]);
    char CasoStr[2]={'0','0'};
    int Caso;
    if ((argv[1][l-3]<='9')&&(argv[1][l-3]>='0')){
        CasoStr[0]=argv[1][l-3];
        CasoStr[1]=argv[1][l-2];
        }
    else CasoStr[1]=argv[1][l-2];
    
    Caso=strtod(CasoStr,&CasoStr);

    char* imgNameRoot;
    char imgName[100];
    int imgNum=1;
    switch (Caso) {
        case 1:
            imgNameRoot="Caso1-";
            break;
        case 2:
            imgNameRoot="Caso2-";
            break;
        case 3:
            imgNameRoot="Caso3-";
            break;
        case 4:
            imgNameRoot="Caso4-";
            break;
        case 5:
            imgNameRoot="Caso5-";
            break;
        case 6:
            imgNameRoot="Caso6-";
            break;
        case 7:
            imgNameRoot="Caso7-";
            break;
        case 8:
            imgNameRoot="Caso8-";
            break;
        case 9:
            imgNameRoot="Caso9-";
            break;
        case 10:
            imgNameRoot="Caso10-";
            break;
        case 11:
            imgNameRoot="Caso11-";
            break;

            
        default:
            break;
    }
    
    
    
    
    /*colors*/
	CvScalar green = CV_RGB(0,255,0);
	CvScalar white = CV_RGB(255,255,255);
	CvScalar black = CV_RGB(0,0,0);
	CvScalar red = CV_RGB(255,0,0);
	CvScalar blue = CV_RGB(0,0,255);
    
	/*font*/
	CvFont font1;
	cvInitFont(&font1, CV_FONT_HERSHEY_SIMPLEX, 0.5, 0.5, 0.5, 1, 8);
    
	
    /*Guardo en archivo poses*/
    FILE *poses_coplanar;
    char poseName[150];
    sprintf(poseName, "%s%s%g%s",folderName,"poses_coplanar_scale",scale,".txt");
    poses_coplanar=fopen(poseName, "w");
    FILE *poses_composit;
    sprintf(poseName, "%s%s%g%s",folderName,"poses_composit_scale",scale,".txt");
    poses_composit=fopen(poseName, "w");


    
    for (k=1; k<50; k++) {
        
        
        if (verImg) {
            
            /*windows*/
            cvNamedWindow( "OpenCV on acid",CV_WINDOW_AUTOSIZE);
            cvNamedWindow( "LSD",CV_WINDOW_AUTOSIZE);
            cvNamedWindow( "LSD filtered",CV_WINDOW_AUTOSIZE);	
        }   
        /*drawing*/
        CvPoint pt1, pt2, pt3;
        
        
        /*get image properties*/
        
        sprintf(imgName, "%s%s%d%s",argv[1],imgNameRoot,imgNum,".png");
        IplImage* img = cvLoadImage( imgName ,1); 
        width  = img->width;
        height = img->height;
        cvMoveWindow( "LSD filtered", img->width, 42);
        
        /*create LSD image type*/
        image = (double *) malloc( width * height * sizeof(double) );
        if( image == NULL ){
            fprintf(stderr,"error: not enough memory\n");
            exit(EXIT_FAILURE);
        }
        
        /*get memory for output list*/
        double *listFilt;
        listFilt=(double *) malloc ( 100 * listDim * sizeof(double));
        
        /*create OpenCV image structs*/
        IplImage *imgBW = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 1 );
        IplImage *imgLsd = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 3 );
        IplImage *imgLsdFilt = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 3 );
        
        
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
        double *list;
        list = lsd_scale(&listSize, image, width, height,scale);
        
        /*Guardo en archivo puntos detectados*/
        FILE *puntosLSD;
        char puntosLSDfileName[200];
        sprintf(puntosLSDfileName, "%s%s%s%d%s",folderName,imgNameRoot,"PuntosLSD",imgNum,".txt");
        puntosLSD=fopen(puntosLSDfileName, "w");
        
        fprintf(puntosLSD, "%d\n",2*listSize);
        for (j=0;j<2*listSize;j++){
            fprintf(puntosLSD,"%g\t%g\n",list[0+j*listDim],list[1+j*listDim]);
            fprintf(puntosLSD,"%g\t%g\n",list[2+j*listDim],list[3+j*listDim]);
        }
        fclose(puntosLSD);

        
        /*filter LSD segments*/		
        listFilt = filterSegments( &listFiltSize , &listSize, list, distance_thr);
        
        /*Guardo en archivo puntos detectados*/
        FILE *puntos;
        char puntosfileName[200];
        sprintf(puntosfileName, "%s%s%s%d%s",folderName,imgNameRoot,"Puntos",imgNum,".txt");
        puntos=fopen(puntosfileName, "w");
        
        fprintf(puntos, "%d\n",listFiltSize);
        for (j=0;j<listFiltSize;j++){
            fprintf(puntos,"%g\t%g\n",listFilt[0+j*listDim],listFilt[1+j*listDim]);
//            fprintf(puntos,"%g\t%g\n",listFilt[2+j*listDim],listFilt[3+j*listDim]);
        }
        fclose(puntos);

        
        //imagePoints = getCorners( &listFiltSize, listFilt);
        errorMarkerDetection = findPointCorrespondances(&listFiltSize, listFilt, imagePoints);
        
        
        
        /*Guardo en archivo puntos detectados*/
        FILE *puntosFiltro;
        char fileName[200];
        sprintf(fileName, "%s%s%s%d%s",folderName,imgNameRoot,"PuntosFiltro",imgNum,".txt");
        puntosFiltro=fopen(fileName, "w");
        
        for (j=0;j<NumberOfPoints;j++){
            fprintf(puntosFiltro,"%g\t%g\n",imagePoints[j][0],imagePoints[j][1]);
        }
        fclose(puntosFiltro);
        
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
        char imgName[200]; 
        sprintf(imgName, "%s%s%s%d%s",folderName,imgNameRoot,"LSD",imgNum,".jpg");
        cvSaveImage(imgName, imgLsd, 0);
        
        if(verImg){
            
            cvShowImage("OpenCV on acid",img);
            cvShowImage("LSD",imgLsd);
        }
        
        
        
        
        cantPtsDetectados=getCropLists(imagePoints, object, imagePointsCrop, objectCrop);
        
        /* creo archivo para guardar los errores*/
        FILE *errorFile;
        sprintf(fileName, "%s%s%d%s",folderName,imgNameRoot,imgNum,".txt");
        errorFile=fopen(fileName, "w");
        fprintf(errorFile, "%d\n",cantPtsDetectados);
        
        /* chequeo si hay error de filtro o de Pose*/
        if (errorMarkerDetection>=0) {
            CoplanarPosit(cantPtsDetectados, imagePointsCrop, objectCrop, f, center, Rot, Tras);
            
            for (j=0;j<NumberOfPoints;j++){
                imagePoints4Composit[j][0]=imagePointsCrop[j][0]-center[0];
                imagePoints4Composit[j][1]=imagePointsCrop[j][1]-center[1];
                
            }
            
            Composit(cantPtsDetectados, imagePoints4Composit, objectCrop, f,Rot4Composit , Trans4Composit);
            
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
            
            if (Rot[0][0]>=2.0) {
                err=-20;
                fprintf(errorFile, "%g\n",err);
                fclose(errorFile);
                goto FreeLabel;
            }
        }
        else {
            fprintf(errorFile, "%d\n",errorMarkerDetection);
            fclose(errorFile);
            fprintf(poses_coplanar, "%4.4f %4.4f %4.4f %4.4f %4.4f %4.4f\n",-1.0,-1.0,-1.0,-1.0,-1.0,-1.0);
            fprintf(poses_composit, "%4.4f %4.4f %4.4f %4.4f %4.4f %4.4f\n",-1.0,-1.0,-1.0,-1.0,-1.0,-1.0);
            goto FreeLabel;
            
        }
        /*Poject object points and save reprojection error*/
        
        for(i=0;i<cantPtsDetectados;i++){
            
            /*project CoplanarPosit*/
            float a[3],b[3];
            b[0]=objectCrop[i][0];
            b[1]=objectCrop[i][1];
            b[2]=objectCrop[i][2];
            MAT_DOT_VEC_3X3(a, Rot, b);
            VEC_SUM(b,a,Tras);
            objectProy[i][0]=intrinsic[0][2]+intrinsic[0][0]*b[0]/b[2];
            objectProy[i][1]=intrinsic[1][2]+intrinsic[1][1]*b[1]/b[2];
            //            printf("%g\t%g\n",objectProy[i][0],objectProy[i][1]);
            
            
            /*project Composit*/
            b[0]=objectCrop[i][0];
            b[1]=objectCrop[i][1];
            b[2]=objectCrop[i][2];
            MAT_DOT_VEC_3X3(a, Rot4Composit, b);
            VEC_SUM(b,a,Trans4Composit);
            objectProy4Composit[i][0]=intrinsic[0][2]+intrinsic[0][0]*b[0]/b[2];
            objectProy4Composit[i][1]=intrinsic[1][2]+intrinsic[1][1]*b[1]/b[2];
            //            printf("%g\t%g\n",objectProy[i][0],objectProy[i][1]);
            
            /*reprojection error*/
            
            x=pow((imagePointsCrop[i][0]-objectProy[i][0]),2);
            y=pow((imagePointsCrop[i][1]-objectProy[i][1]),2);
            err=sqrt(x+y);
            x4Composit=pow((imagePointsCrop[i][0]-objectProy4Composit[i][0]),2);
            y4Composit=pow((imagePointsCrop[i][1]-objectProy4Composit[i][1]),2);
            err4Composit=sqrt(x4Composit+y4Composit);
            
            fprintf(errorFile, "%g\t%g\n",err,err4Composit);
  
        }
        fclose(errorFile);
        
        
        
        /*draw segments on actual frameLsdFilt*/
        cvSet(imgLsdFilt, black, 0);	
        for (j=0; j<listFiltSize ; j++){
            //define segment end-points
            pt1 = cvPoint(listFilt[ 0 + j * listDim ],listFilt[ 1 + j * listDim ]);
            pt2 = cvPoint(listFilt[ 2 + j * listDim ],listFilt[ 3 + j * listDim ]);
            
            // draw line on frameLsd
            cvLine(imgLsdFilt,pt1,pt2,white,1.5,8,0);
        }
        
        for (j=0; j<NumberOfPoints; j++) {
            //define marker corners
            pt1 = cvPoint(imagePoints[j][0],imagePoints[j][1]);
            // draw small corner circle
            cvCircle(imgLsdFilt, pt1, 3, green, 1, 8, 0);
            char *ind[2];
            sprintf(ind,"%d",j);
            cvPutText(imgLsdFilt, ind, pt1, &font1 , blue);
        }
            
        for (j=0; j<cantPtsDetectados; j++) {
            pt2 = cvPoint(objectProy[j][0],objectProy[j][1]);
            // draw small corner circle
            cvCircle(imgLsdFilt, pt2, 3, red, 1, 8, 0);
            pt3 = cvPoint(objectProy4Composit[j][0],objectProy4Composit[j][1]);
            // draw small corner circle
            cvCircle(imgLsdFilt, pt3, 3, white , 1, 8, 0);
          
            
        }

        
        sprintf(imgName, "%s%s%s%d%s",folderName,imgNameRoot,"LSDfilter",imgNum,".jpg");
        cvSaveImage(imgName, imgLsdFilt, 0);
        
        //printf("Numero de segmentos LSD: %d\n",listSize);
        //printf("Numero de segmentos FILTRADOS: %d\n\n",listFiltSize);
        
    FreeLabel: 
        /* free memory */
        free( (void *) list );
        listFiltSize = 0;
        listSize = 0;

        
        for (i=0;i<3;i++){
            Rot[i][0]=0;
            Rot[i][1]=0;
            Rot[i][2]=0;
            Tras[i]=0;
        }
        
        if (verImg) {
            
            cvShowImage("LSD filtered",imgLsdFilt);
            
            cvWaitKey(0);
            
            cvDestroyWindow( "OpenCV on acid");
            cvDestroyWindow( "LSD");
            cvDestroyWindow( "LSD filtered");
        }
        
        /* free memory */
        
        cvReleaseImage( &img );
        cvReleaseImage( &imgLsd );
        cvReleaseImage( &imgLsdFilt );
        
        imgNum++;
    }
    fclose(poses_coplanar);
    fclose(poses_composit);
}



