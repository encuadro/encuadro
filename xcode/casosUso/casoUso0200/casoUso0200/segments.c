/*
Program: segments.c
Proyect: encuadro - Facultad de Ingeniería - UDELAR
Author: Martin Etchart - mrtn.etchart@gmail.com

Description:
Real time marker detection for pose estimation.
Line Segment Detector (LSD) for segment detection and OpenCV as interface.
This program is the evolution of 'lsd-opencv'.

Both programs hosted on:
http://code.google.com/p/encuadro/
*/

#include "segments.h"
#include "vvector.h"

float *angleList;

segment segmentNew(int x1, int y1, int x2, int y2, float w){

	segment seg;

	seg.p1[0] = x1 ;
	seg.p1[1] = y1 ;
	seg.p2[0] = x2 ;
	seg.p2[1] = y2 ;
	seg.width = w;
/*	seg.dir[1] = seg.p1[1]-seg.p2[1] ;
	seg.dir[2] = seg.p1[2]-seg.p2[2] ; 
	seg.length = sqrt( pow(seg.dir[1],2) + pow(seg.dir[2],2) );
	seg.dir[1] = seg.dir[1]/seg.length ;
	seg.dir[2] = seg.dir[2]/seg.length ;
	seg.angleRad = atan2(seg.dir[1],seg.dir[2]);
	seg.angleDeg = seg.angleRad*180/MY_PI;
*/
	return seg;
}


int lineIntersection(	float Ax, float Ay,
						float Bx, float By,
						float Cx, float Cy,
						float Dx, float Dy,
						float *X, float *Y ) {
//  public domain function by Darel Rex Finley, 2006
// http://alienryderflex.com/intersect/
//
//  Determines the intersection point of the line defined by points A and B with the
//  line defined by points C and D.
//
//  Returns YES if the intersection point was found, and stores that point in X,Y.
//  Returns NO if there is no determinable intersection point, in which case X,Y will
//  be unmodified.

	float  distAB, theCos, theSin, newX, ABpos ;

	//  Fail if either line is undefined.
	if (Ax==Bx && Ay==By || Cx==Dx && Cy==Dy) return -1;

	//  (1) Translate the system so that point A is on the origin.
	Bx-=Ax; By-=Ay;
	Cx-=Ax; Cy-=Ay;
	Dx-=Ax; Dy-=Ay;

	//  Discover the length of segment A-B.
	distAB=sqrt(Bx*Bx+By*By);

	//  (2) Rotate the system so that point B is on the positive X axis.
	theCos=Bx/distAB;
	theSin=By/distAB;
	newX=Cx*theCos+Cy*theSin;
	Cy  =Cy*theCos-Cx*theSin; Cx=newX;
	newX=Dx*theCos+Dy*theSin;
	Dy  =Dy*theCos-Dx*theSin; Dx=newX;

	//  Fail if the lines are parallel.
	if (Cy==Dy) return -1;

	//  (3) Discover the position of the intersection point along line A-B.
	ABpos=Dx+(Cx-Dx)*Dy/(Dy-Cy);

	//  (4) Apply the discovered position to line A-B in the original coordinate system.
	*X=Ax+ABpos*theCos;
	*Y=Ay+ABpos*theSin;

	//  Success.
	return 0; 
}

int lineSegmentIntersection(	float Ax, float Ay,
								float Bx, float By,
								float Cx, float Cy,
								float Dx, float Dy,
								float *X, float *Y ) {
//  public domain function by Darel Rex Finley, 2006
// http://alienryderflex.com/intersect/
//
//  Determines the intersection point of the line defined by points A and B with the
//  line defined by points C and D.
//
//  Returns YES if the intersection point was found, and stores that point in X,Y.
//  Returns NO if there is no determinable intersection point, in which case X,Y will
//  be unmodified.

	float  distAB, theCos, theSin, newX, ABpos ;

	//  Fail if either line is undefined.
	if (Ax==Bx && Ay==By || Cx==Dx && Cy==Dy) return -1;

	//  (1) Translate the system so that point A is on the origin.
	Bx-=Ax; By-=Ay;
	Cx-=Ax; Cy-=Ay;
	Dx-=Ax; Dy-=Ay;

	//  Discover the length of segment A-B.
	distAB=sqrt(Bx*Bx+By*By);

	//  (2) Rotate the system so that point B is on the positive X axis.
	theCos=Bx/distAB;
	theSin=By/distAB;
	newX=Cx*theCos+Cy*theSin;
	Cy  =Cy*theCos-Cx*theSin; Cx=newX;
	newX=Dx*theCos+Dy*theSin;
	Dy  =Dy*theCos-Dx*theSin; Dx=newX;

	//  Fail if segment C-D doesn't cross line A-B.
	if (Cy<0. && Dy<0. || Cy>=0. && Dy>=0.) return -1;

	//  (3) Discover the position of the intersection point along line A-B.
	ABpos=Dx+(Cx-Dx)*Dy/(Dy-Cy);

	//  (4) Apply the discovered position to line A-B in the original coordinate system.
	*X=Ax+ABpos*theCos;
	*Y=Ay+ABpos*theSin;

	//  Success.
	return 0; 
}

float** getCorners(int *listSize, float *list){
	
	float center_thr = 25;
	int listDim = 7;
	long int NP = *listSize;
	float **imgPts;
	int i,j,k,l;
	int I[4];
	
	/*get memory*/
	imgPts=(float **)malloc(NP * sizeof(float *));
	for (i=0;i<NP;i++) imgPts[i]=(float *)malloc(2 * sizeof(float));
	
	/*find marker corners*/
	for (i=0;i<NP;i+=4){
		I[0]=i; I[1]=i+1; I[2]=i+2; I[3]=i+3;
		lineIntersection(list[0+I[0]*listDim], list[1+I[0]*listDim],
						 list[2+I[0]*listDim], list[3+I[0]*listDim],
						 list[0+I[1]*listDim], list[1+I[1]*listDim],
						 list[2+I[1]*listDim], list[3+I[1]*listDim],
						 &imgPts[I[0]][0]	 , &imgPts[I[0]][1] );			 
		lineIntersection(list[0+I[0]*listDim], list[1+I[0]*listDim],
						 list[2+I[0]*listDim], list[3+I[0]*listDim],
						 list[0+I[2]*listDim], list[1+I[2]*listDim],
						 list[2+I[2]*listDim], list[3+I[2]*listDim],
						 &imgPts[I[1]][0]	 , &imgPts[I[1]][1]	);
		lineIntersection(list[0+I[1]*listDim], list[1+I[1]*listDim],
						 list[2+I[1]*listDim], list[3+I[1]*listDim],
						 list[0+I[3]*listDim], list[1+I[3]*listDim],
						 list[2+I[3]*listDim], list[3+I[3]*listDim],
						 &imgPts[I[2]][0]	 , &imgPts[I[2]][1]	);
		lineIntersection(list[0+I[2]*listDim], list[1+I[2]*listDim],
						 list[2+I[2]*listDim], list[3+I[2]*listDim],
						 list[0+I[3]*listDim], list[1+I[3]*listDim],
						 list[2+I[3]*listDim], list[3+I[3]*listDim],
						 &imgPts[I[3]][0]	 , &imgPts[I[3]][1]	);
	};
	
	return imgPts;
};

float* filterSegments(int *listOutSize , int *listInSize , float *listIn, float distance_thr){
	
	int listDim = 7;	
	float* listOut;
	int i,j,k,l;
	float dist[4], dist3[4]; 
	int marker_id = 0;
	int index[4];
	segment seg[4];
	segment segi;
	int marker_found;
	
	/*get memory*/
	listOut=(float *) malloc ( 100 * listDim * sizeof(float));
	
	/*use width field to flag marker id - initialize*/
	for (j=0;j<*listInSize;j++) listIn[4+j*listDim] = 0;

	/*search for markers of the form of 4 conex segments*/
	for (j=0;j<*listInSize;j++){
		if (listIn[4+j*listDim] == 0){
			index[0] = j;
			
			seg[0] = segmentNew(listIn[0+j*listDim],
							  	listIn[1+j*listDim],
							  	listIn[2+j*listDim],
							  	listIn[3+j*listDim],
							  	listIn[4+j*listDim]);
							  
			
			dist[0] = 0; dist[1] = 0; dist[2] = 0; dist[3] = 0;
			
			/*search for 2 conex segments to seg1: one for each endpoint*/
			marker_found = 0;
			for (i=j+1;i<*listInSize;i++){
				if (listIn[4+i*listDim] == 0){
				
					segi = segmentNew(listIn[0+i*listDim],
									  listIn[1+i*listDim],
									  listIn[2+i*listDim],
									  listIn[3+i*listDim],
									  listIn[4+i*listDim]);
					
					if (!dist[0] && !dist[1])	{	//seg[0] p1 endpoint not matched yet
						dist[0] = ( pow(seg[0].p1[0]-segi.p1[0],2) + pow(seg[0].p1[1]-segi.p1[1],2) ) < distance_thr;
						dist[1] = ( pow(seg[0].p1[0]-segi.p2[0],2) + pow(seg[0].p1[1]-segi.p2[1],2) ) < distance_thr;
						
						if (dist[0] || dist[1])	{	// p1 match
							seg[1] = segmentNew(listIn[0+i*listDim],
									  			listIn[1+i*listDim],
									  			listIn[2+i*listDim],
									  			listIn[3+i*listDim],
									  			listIn[4+i*listDim]);
							index[1] = i;			
						}
					}
					
					if (!dist[2] && !dist[3])	{	//seg[0] p2 endpoint not matched yet
						dist[2] = ( pow(seg[0].p2[0]-segi.p1[0],2) + pow(seg[0].p2[1]-segi.p1[1],2) ) < distance_thr;
						dist[3] = ( pow(seg[0].p2[0]-segi.p2[0],2) + pow(seg[0].p2[1]-segi.p2[1],2) ) < distance_thr;
						
						if (dist[2] || dist[3])	{	// p2 match
							seg[2] = segmentNew(listIn[0+i*listDim],
										  		listIn[1+i*listDim],
										  		listIn[2+i*listDim],
										  		listIn[3+i*listDim],
										  		listIn[4+i*listDim]);
							index[2] = i;
						}
					}
					
					if ( (dist[0] || dist[1]) && (dist[2] || dist[3]) ) {	//conex segments found, find the last
						k = 0;
						dist3[0] = 0; dist3[1] = 0; dist3[2] = 0; dist3[3] = 0;
						/* search for one segment that matches the unmatched endpoints of seg[1] and seg[2]*/
						while (k<*listInSize){
							if ( (k!=index[0]) && (k!=index[1]) && (k!=index[2]) ){
								
								seg[3] = segmentNew(listIn[0+k*listDim],
											  		listIn[1+k*listDim],
											  		listIn[2+k*listDim],
											  		listIn[3+k*listDim],
											  		listIn[4+k*listDim]);
											  		
								if (dist[0] && dist[2]) { 
									//seg[0].p1 matched seg[1].p1 and seg[0].p2 matched seg[2].p1									
									dist3[0] = ( pow(seg[1].p2[0]-seg[3].p1[0],2) + pow(seg[1].p2[1]-seg[3].p1[1],2) ) < distance_thr;
									dist3[1] = ( pow(seg[2].p2[0]-seg[3].p2[0],2) + pow(seg[2].p2[1]-seg[3].p2[1],2) ) < distance_thr;
									dist3[2] = ( pow(seg[1].p2[0]-seg[3].p2[0],2) + pow(seg[1].p2[1]-seg[3].p2[1],2) ) < distance_thr;
									dist3[3] = ( pow(seg[2].p2[0]-seg[3].p1[0],2) + pow(seg[2].p2[1]-seg[3].p1[1],2) ) < distance_thr;
								} else if (dist[0] && dist[3]){
									//seg[0].p1 matched seg[1].p1 and seg[0].p2 matched seg[2].p2
									dist3[0] = ( pow(seg[1].p2[0]-seg[3].p1[0],2) + pow(seg[1].p2[1]-seg[3].p1[1],2) ) < distance_thr;
									dist3[1] = ( pow(seg[2].p1[0]-seg[3].p2[0],2) + pow(seg[2].p1[1]-seg[3].p2[1],2) ) < distance_thr;
									dist3[2] = ( pow(seg[1].p2[0]-seg[3].p2[0],2) + pow(seg[1].p2[1]-seg[3].p2[1],2) ) < distance_thr;
									dist3[3] = ( pow(seg[2].p1[0]-seg[3].p1[0],2) + pow(seg[2].p1[1]-seg[3].p1[1],2) ) < distance_thr;
								} else if (dist[1] && dist[2]){
									//seg[0].p1 matched seg[1].p2 and seg[0].p2 matched seg[2].p1
									dist3[0] = ( pow(seg[1].p1[0]-seg[3].p1[0],2) + pow(seg[1].p1[1]-seg[3].p1[1],2) ) < distance_thr;
									dist3[1] = ( pow(seg[2].p2[0]-seg[3].p2[0],2) + pow(seg[2].p2[1]-seg[3].p2[1],2) ) < distance_thr;
									dist3[2] = ( pow(seg[1].p1[0]-seg[3].p2[0],2) + pow(seg[1].p1[1]-seg[3].p2[1],2) ) < distance_thr;
									dist3[3] = ( pow(seg[2].p2[0]-seg[3].p1[0],2) + pow(seg[2].p2[1]-seg[3].p1[1],2) ) < distance_thr;
								} else if (dist[1] && dist[3]){
									//seg[0].p1 matched seg[1].p2 and seg[0].p2 matched seg[2].p2
									dist3[0] = ( pow(seg[1].p1[0]-seg[3].p1[0],2) + pow(seg[1].p1[1]-seg[3].p1[1],2) ) < distance_thr;
									dist3[1] = ( pow(seg[2].p1[0]-seg[3].p2[0],2) + pow(seg[2].p1[1]-seg[3].p2[1],2) ) < distance_thr;
									dist3[2] = ( pow(seg[1].p1[0]-seg[3].p2[0],2) + pow(seg[1].p1[1]-seg[3].p2[1],2) ) < distance_thr;
									dist3[3] = ( pow(seg[2].p1[0]-seg[3].p1[0],2) + pow(seg[2].p1[1]-seg[3].p1[1],2) ) < distance_thr;
								};
								
								if ( (dist3[0] && dist3[1]) || (dist3[2] && dist3[3]) ) {
									/*success! marker found*/
									marker_found = 1;
									index[3] = k;
									marker_id++;
									for (l=0;l<4;l++){
										
										//add marker segments to output list 
										listOut[0+(*listOutSize)*listDim] = listIn[0+index[l]*listDim];
										listOut[1+(*listOutSize)*listDim] = listIn[1+index[l]*listDim];
										listOut[2+(*listOutSize)*listDim] = listIn[2+index[l]*listDim];
										listOut[3+(*listOutSize)*listDim] = listIn[3+index[l]*listDim];
										listOut[4+(*listOutSize)*listDim] = marker_id;
										
										//store orientations for manual correspondance
//										angleList[index[l] + listOutSize] =
										
										*listOutSize = 1+(*listOutSize);
										//burn segments used
										listIn[4+index[l]*listDim] = marker_id; 
										
									}
									break;
								}
							}
							k++;
						}
					}
				}
				if (marker_found) break;
			}
		}
	}
	return listOut;
}
