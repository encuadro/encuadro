/*
Programa: lsd-opencv.c
Proyecto: encuadro - Facultad de Ingeniería - UDELAR
Autor: Martin Etchart - mrtn.etchart@gmail.com

Descripción:
Demo de opencv usando el lsd.
---le falta sensibilidad al lsd? habría que probar con una imagen.

un topic que ayudó a la construcción del demo.
http://stackoverflow.com/questions/6441706/how-to-apply-line-segment-detector-lsd-on-a-video-frame-by-frame
un breve tutorial del opencv
http://nashruddin.com/opencv-examples-for-operation-on-images.html/1
*/

#include "highgui.h"
#include "cv.h"
#include "lsd.h"
#include <stdio.h>
//#include "segments.h"

#include <math.h>

typedef struct segment{
		int p1[2];
		int p2[2];
		double dir[2];	
		double length;
		double angleDeg;
		double angleRad;
		double width;
} segment;

segment segmentNew(int x1,int y1,int x2,int y2,double w);

//segment[] segmentArr;

void filterSegments(ntuple_list ntl_in, ntuple_list ntl_out , float distance_thr);

int main( int argc, char** argv){
	
	/*colors*/
	CvScalar green = CV_RGB(0,255,0);
	CvScalar white = CV_RGB(255,255,255);
	CvScalar black = CV_RGB(0,0,0);
	CvScalar red = CV_RGB(255,0,0);
	CvScalar blue = CV_RGB(0,0,255);


	cvNamedWindow( "opencv on acid",CV_WINDOW_AUTOSIZE);
	cvNamedWindow( "lsd",CV_WINDOW_AUTOSIZE);
	
	CvCapture* capture;
	
	if ( argc == 1 ) {
	 	capture = cvCreateCameraCapture (0);
	} else {
	 	capture = cvCreateFileCapture (argv[1]);
	}
	assert( capture != NULL );
	
	IplImage* frame;
	image_double image;
	int width, height, i, j;
	
	while (1) {
		frame = cvQueryFrame( capture );
		if( !frame ) break;

		/* get image properties */
		width  = frame->width;
		height = frame->height;

		/* create new image for the grayscale version */
		IplImage* frameBW = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 1 );

		/*convert to grayscale*/ 
		cvCvtColor( frame , frameBW, CV_RGB2GRAY);
		
		/*cast into lsd image struct*/
		image = new_image_double(width, height);
		uchar* data = (uchar*)frameBW->imageData;
		for (i=0;i<height;i++){
			for(j=0;j<width;j++){
				image->data[ j + i * width ] = data[j + i*width];
			};
		};
		
		/*run lsd*/
		ntuple_list ntl;
		ntl = lsd(image);
		free_image_double(image);
		
		/*filter lsd segments*/		
		int degrees_thr = 20;	// degrees of threshold
		int distance_thr = 49;	// 7 pixels
		ntuple_list ntlFilt = new_ntuple_list(5);
		filterSegments( ntl, ntlFilt , distance_thr);
		/********************/
		
		//printf("A ver: %3.2f\n",ntl->values[1]);
		
		/*draw segments on frame and frameLsd*/
		IplImage* frameLsd = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 3 );
		cvSet(frameLsd, black, 0);
		for (j=0; j<ntl->size ; j++){		
			//define segment end-points
			CvPoint pt1 = cvPoint(ntl->values[ 0 + j * ntl->dim ],ntl->values[ 1 + j * ntl->dim ]);
			CvPoint pt2 = cvPoint(ntl->values[ 2 + j * ntl->dim ],ntl->values[ 3 + j * ntl->dim ]);
	
			// draw line on frame
			cvLine(frame,pt1,pt2,white,1.5,8,0);
			
			// draw line on frameLsd
			cvLine(frameLsd,pt1,pt2,white,1.5,8,0);
		}
		
		
		/*draw segments on actual frameLsdFilt*/
		IplImage* frameLsdFilt = cvCreateImage( cvSize( width, height ), IPL_DEPTH_8U, 3 );
		cvSet(frameLsdFilt, black, 0);	
		j = 0;
		for (j=0; j<ntlFilt->size ; j++){		
			//define segment end-points
			CvPoint pt1 = cvPoint(ntlFilt->values[ 0 + j * ntlFilt->dim ],ntlFilt->values[ 1 + j * ntlFilt->dim ]);
			CvPoint pt2 = cvPoint(ntlFilt->values[ 2 + j * ntlFilt->dim ],ntlFilt->values[ 3 + j * ntlFilt->dim ]);
			
			// draw line on frameLsd
			cvLine(frameLsdFilt,pt1,pt2,white,1.5,8,0);
		}		
					
		
		cvShowImage("opencv on acid",frame);
		cvShowImage("lsd",frameLsd);
		cvShowImage("lsd filtrado",frameLsdFilt);
		char c = cvWaitKey(25);
		if( c == 27 ) break;
	}
	cvReleaseCapture( &capture );
	cvDestroyWindow( "opencv on acid");
	cvDestroyWindow( "lsd");
	cvDestroyWindow( "lsd filtrado");
}

segment segmentNew(int x1, int y1, int x2, int y2, double w){

	segment seg;

	seg.p1[1] = x1 ;
	seg.p1[2] = y1 ;
	seg.p2[1] = x2 ; 
	seg.p2[2] = y2 ;
	seg.width = w;
	seg.dir[1] = seg.p1[1]-seg.p2[1] ;
	seg.dir[2] = seg.p1[2]-seg.p2[2] ; 
	seg.length = sqrt( pow(seg.dir[1],2) + pow(seg.dir[2],2) );
	seg.dir[1] = seg.dir[1]/seg.length ;
	seg.dir[2] = seg.dir[2]/seg.length ;
	seg.angleRad = atan2(seg.dir[1],seg.dir[2]);
	seg.angleDeg = seg.angleRad*180/M_PI;
	
	return seg;
}

void filterSegments(ntuple_list ntl_in, ntuple_list ntl_out , float distance_thr){
	
	int i,j,k,l;
	double dist[4], dist3[4]; 
	double angle, anglej, anglei;
	int marker_id = 0;
	int count = 0;
	int index[4];
	segment seg[4];
	segment segi;
	
	/*use width field to flag marker id - initialize*/
	for (j=0;j<ntl_in->size;j++)
		ntl_in->values[4+j*ntl_in->dim] = 0;

	/*search for markers of the form of 4 conex segments*/
	for (j=0;j<ntl_in->size;j++){
		if (ntl_in->values[4+j*ntl_in->dim] == 0){
			index[0] = j;
			
			seg[0] = segmentNew(ntl_in->values[0+j*ntl_in->dim],
							  	ntl_in->values[1+j*ntl_in->dim],
							  	ntl_in->values[2+j*ntl_in->dim],
							  	ntl_in->values[3+j*ntl_in->dim],
							  	ntl_in->values[4+j*ntl_in->dim]);
							  
			
			dist[0] = 0; dist[1] = 0; dist[2] = 0; dist[3] = 0;
			
			/*search for 2 conex segments to seg1*/
			for (i=0;i<ntl_in->size;i++){
			//for (i=j+1;i<ntl_in->size;i++){
				if (ntl_in->values[4+i*ntl_in->dim] == 0){
				
					segi = segmentNew(ntl_in->values[0+i*ntl_in->dim],
									  ntl_in->values[1+i*ntl_in->dim],
									  ntl_in->values[2+i*ntl_in->dim],
									  ntl_in->values[3+i*ntl_in->dim],
									  ntl_in->values[4+i*ntl_in->dim]);
					
					if (!dist[0] && !dist[1])	{	//seg[0] p1 endpoint not matched yet
						dist[0] = ( pow(seg[0].p1[1]-segi.p1[1],2) + pow(seg[0].p1[2]-segi.p1[2],2) ) < distance_thr;
						dist[1] = ( pow(seg[0].p1[1]-segi.p2[1],2) + pow(seg[0].p1[2]-segi.p2[2],2) ) < distance_thr;
						
						if (dist[0] || dist[1])	{	// p1 match
							seg[1] = segmentNew(ntl_in->values[0+i*ntl_in->dim],
									  			ntl_in->values[1+i*ntl_in->dim],
									  			ntl_in->values[2+i*ntl_in->dim],
									  			ntl_in->values[3+i*ntl_in->dim],
									  			ntl_in->values[4+i*ntl_in->dim]);
							index[1] = i;			
						};			  			
					};
					
					if (!dist[2] && !dist[3])	{	//seg[0] p2 endpoint not matched yet
						dist[2] = ( pow(seg[0].p2[1]-segi.p1[1],2) + pow(seg[0].p2[2]-segi.p1[2],2) ) < distance_thr;
						dist[3] = ( pow(seg[0].p2[1]-segi.p2[1],2) + pow(seg[0].p2[2]-segi.p2[2],2) ) < distance_thr;
						
						if (dist[2] || dist[3])	{	// p2 match
							seg[2] = segmentNew(ntl_in->values[0+i*ntl_in->dim],
										  		ntl_in->values[1+i*ntl_in->dim],
										  		ntl_in->values[2+i*ntl_in->dim],
										  		ntl_in->values[3+i*ntl_in->dim],
										  		ntl_in->values[4+i*ntl_in->dim]);
							index[2] = i;
						};
					};
					
					if ( (dist[0] || dist[1]) && (dist[2] || dist[3]) ) {	//conex segments found, find the last
						k = 0;
						while (k<ntl_in->size){
							if ( (k!=index[0]) && (k!=index[1]) && (k!=index[2]) ){
								seg[3] = segmentNew(ntl_in->values[0+k*ntl_in->dim],
											  		ntl_in->values[1+k*ntl_in->dim],
											  		ntl_in->values[2+k*ntl_in->dim],
											  		ntl_in->values[3+k*ntl_in->dim],
											  		ntl_in->values[4+k*ntl_in->dim]);
								if (dist[0] && dist[2]) { 
									//seg[0].p1 matched seg[1].p1 and seg[0].p2 matched seg[2].p1									
									dist3[0] = ( pow(seg[1].p2[1]-seg[3].p1[1],2) + pow(seg[1].p2[2]-seg[3].p1[2],2) ) < distance_thr;
									dist3[1] = ( pow(seg[2].p2[1]-seg[3].p2[1],2) + pow(seg[2].p2[2]-seg[3].p2[2],2) ) < distance_thr;
									dist3[2] = ( pow(seg[1].p2[1]-seg[3].p2[1],2) + pow(seg[1].p2[2]-seg[3].p2[2],2) ) < distance_thr;
									dist3[3] = ( pow(seg[2].p2[1]-seg[3].p1[1],2) + pow(seg[2].p2[2]-seg[3].p1[2],2) ) < distance_thr;
								} else if (dist[0] && dist[3]){
									//seg[0].p1 matched seg[1].p1 and seg[0].p2 matched seg[2].p2
									dist3[0] = ( pow(seg[1].p2[1]-seg[3].p1[1],2) + pow(seg[1].p2[2]-seg[3].p1[2],2) ) < distance_thr;
									dist3[1] = ( pow(seg[2].p1[1]-seg[3].p2[1],2) + pow(seg[2].p1[2]-seg[3].p2[2],2) ) < distance_thr;
									dist3[2] = ( pow(seg[1].p2[1]-seg[3].p2[1],2) + pow(seg[1].p2[2]-seg[3].p2[2],2) ) < distance_thr;
									dist3[3] = ( pow(seg[2].p1[1]-seg[3].p1[1],2) + pow(seg[2].p1[2]-seg[3].p1[2],2) ) < distance_thr;
								} else if (dist[1] && dist[2]){
									//seg[0].p1 matched seg[1].p2 and seg[0].p2 matched seg[2].p1
									dist3[0] = ( pow(seg[1].p1[1]-seg[3].p1[1],2) + pow(seg[1].p1[2]-seg[3].p1[2],2) ) < distance_thr;
									dist3[1] = ( pow(seg[2].p2[1]-seg[3].p2[1],2) + pow(seg[2].p2[2]-seg[3].p2[2],2) ) < distance_thr;
									dist3[2] = ( pow(seg[1].p1[1]-seg[3].p2[1],2) + pow(seg[1].p1[2]-seg[3].p2[2],2) ) < distance_thr;
									dist3[3] = ( pow(seg[2].p2[1]-seg[3].p1[1],2) + pow(seg[2].p2[2]-seg[3].p1[2],2) ) < distance_thr;
								} else if (dist[1] && dist[3]){
									//seg[0].p1 matched seg[1].p2 and seg[0].p2 matched seg[2].p2
									dist3[0] = ( pow(seg[1].p1[1]-seg[3].p1[1],2) + pow(seg[1].p1[2]-seg[3].p1[2],2) ) < distance_thr;
									dist3[1] = ( pow(seg[2].p1[1]-seg[3].p2[1],2) + pow(seg[2].p1[2]-seg[3].p2[2],2) ) < distance_thr;
									dist3[2] = ( pow(seg[1].p1[1]-seg[3].p2[1],2) + pow(seg[1].p1[2]-seg[3].p2[2],2) ) < distance_thr;
									dist3[3] = ( pow(seg[2].p1[1]-seg[3].p1[1],2) + pow(seg[2].p1[2]-seg[3].p1[2],2) ) < distance_thr;
								};
								
								if ( (dist3[0] && dist3[1]) || (dist3[2] && dist3[3]) ) {
									/*success! marker found*/
									index[3] = k;
									marker_id++;
									for (l=0;l<4;l++){
										add_5tuple( ntl_out, //add marker segments to output list 
													ntl_in->values[0+index[l]*ntl_in->dim],
													ntl_in->values[1+index[l]*ntl_in->dim],
													ntl_in->values[2+index[l]*ntl_in->dim],
													ntl_in->values[3+index[l]*ntl_in->dim],
													marker_id);			 
										ntl_in->values[4+j*ntl_in->dim] = marker_id; //burn segments used
									};
									break;
								};
							};
							k++;
						};
					};
				};
			};
		};
	};		 				 
};

