/*
Program: marker_detection.c
Proyect: encuadro - Facultad de Ingeniería - UDELAR
Author: Martin Etchart - mrtn.etchart@gmail.com

Description:
Real time marker detection for pose estimation.
Line Segment Detector (LSD) for segment detection and OpenCV as interface.
This program is the evolution of 'lsd-opencv'.

Both programs hosted on:
http://code.google.com/p/encuadro/
*/

#include "highgui.h"
#include "cv.h"
#include "lsd.h"
#include <stdio.h>
#include <stdlib.h>
#include "segments.h"
#include "coplanar.h"

int main(){
//int argc, char** argv
	int argc=2;
	char* argv[argc];
	
	/*colors*/
	CvScalar green = CV_RGB(0,255,0);
	CvScalar white = CV_RGB(255,255,255);
	CvScalar black = CV_RGB(0,0,0);
	CvScalar red = CV_RGB(255,0,0);
	CvScalar blue = CV_RGB(0,0,255);

	/*windows*/
	cvNamedWindow( "OpenCV on acid",CV_WINDOW_AUTOSIZE);
	cvNamedWindow( "LSD",CV_WINDOW_AUTOSIZE);
	cvNamedWindow( "LSD filtered",CV_WINDOW_AUTOSIZE);	
	
	/*picture from file. Set the path*/
	argv[1]="/home/mauri/workspace_eclipse/Integracion2/la foto7.pgm";

	/*pointer to the image*/
	IplImage *frame = cvLoadImage(argv[1],1);
	int width, height;

	double *image;
	double **imagePoints;
	int i, j, listSize = 0, listFiltSize = 0;
	int listDim = 7;
	int distance_thr = 16;	// 4 pixels
	
	/*drawing*/
	CvPoint pt1, pt2, pt3;
	
	/* get image properties */
	width=480;
	height=359;


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
	IplImage *frameBW = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 1 );
	IplImage *frameLsd = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 3 );
	IplImage *frameLsdFilt = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 3 );
	

		/*convert to grayscale*/
		cvCvtColor( frame , frameBW, CV_RGB2GRAY);
				
		/*cast into LSD image type*/
		uchar *data = (uchar *)frameBW->imageData;
		for (i=0;i<width;i++){
			for(j=0;j<height;j++){
				image[ i + j * width ] = data[ i + j * width];
			};
		};
		
		/*run LSD*/
		double *list;
		list = lsd( &listSize, image, width, height );
		
		/*filter LSD segments*/		
		listFilt = filterSegments( &listFiltSize , &listSize, list, distance_thr);
		imagePoints = getMarkerCorners( &listFiltSize, listFilt);
		/********************/
		
		/*run coplanar posit*/
		int cop=coplanar(imagePoints,width/2,height/2);

		/*draw segments on frame and frameLsd*/
		cvSet(frameLsd, black, 0);
		for (j=0; j<listSize ; j++){		
			//define segment end-points
			pt1 = cvPoint(list[ 0 + j * listDim ],list[ 1 + j * listDim ]);
			pt2 = cvPoint(list[ 2 + j * listDim ],list[ 3 + j * listDim ]);
	
			// draw line on frame
			cvLine(frame,pt1,pt2,white,1.5,8,0);
			
			// draw line on frameLsd
			cvLine(frameLsd,pt1,pt2,white,1.5,8,0);
			
		}
		
		/*draw segments on actual frameLsdFilt*/
		cvSet(frameLsdFilt, black, 0);	
		for (j=0; j<listFiltSize ; j++){		
			//define segment end-points
			pt1 = cvPoint(listFilt[ 0 + j * listDim ],listFilt[ 1 + j * listDim ]);
			pt2 = cvPoint(listFilt[ 2 + j * listDim ],listFilt[ 3 + j * listDim ]);
			//define marker corners
			pt3 = cvPoint(imagePoints[j][0],imagePoints[j][1]);
			
			// draw line on frameLsd
			cvLine(frameLsdFilt,pt1,pt2,white,1.5,8,0);
			// draw small corner circle
			cvCircle(frameLsdFilt, pt3, 3, red, 1, 8, 0);
		}		
		
		//printf("Numero de segmentos LSD: %d\n",listSize);
		//printf("Numero de segmentos FILTRADOS: %d\n\n",listFiltSize);
					
		/* free memory */
		free( (void *) list );
		listFiltSize = 0;
		listSize = 0;
		
		/*free imagePoints memory*/
		for(i = 0; i < listFiltSize; i++)
			free(imagePoints[i]);
		free(imagePoints);
		/********************/
		cvShowImage("OpenCV on acid",frame);
		cvShowImage("LSD",frameLsd);
		cvShowImage("LSD filtered",frameLsdFilt);
		char c = cvWaitKey(0);

	/* free memory */
  	//free( (void *) image );
  	//free( (void *) listFilt );


	cvReleaseImage( &frame );
	cvReleaseImage( &frameLsd );
	cvReleaseImage( &frameLsdFilt );
	//cvReleaseCapture( &capture );
	cvDestroyWindow( "OpenCV on acid");
	cvDestroyWindow( "LSD");
	cvDestroyWindow( "LSD filtered");
}
