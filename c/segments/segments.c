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


int lineIntersection(	double Ax, double Ay,
						double Bx, double By,
						double Cx, double Cy,
						double Dx, double Dy,
						double *X, double *Y ) {
//  public domain function by Darel Rex Finley, 2006
// http://alienryderflex.com/intersect/
//
//  Determines the intersection point of the line defined by points A and B with the
//  line defined by points C and D.
//
//  Returns YES if the intersection point was found, and stores that point in X,Y.
//  Returns NO if there is no determinable intersection point, in which case X,Y will
//  be unmodified.

	double  distAB, theCos, theSin, newX, ABpos ;

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

int lineSegmentIntersection(	double Ax, double Ay,
								double Bx, double By,
								double Cx, double Cy,
								double Dx, double Dy,
								double *X, double *Y ) {
//  public domain function by Darel Rex Finley, 2006
// http://alienryderflex.com/intersect/
//
//  Determines the intersection point of the line defined by points A and B with the
//  line defined by points C and D.
//
//  Returns YES if the intersection point was found, and stores that point in X,Y.
//  Returns NO if there is no determinable intersection point, in which case X,Y will
//  be unmodified.

	double  distAB, theCos, theSin, newX, ABpos ;

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

double** getMarkerCorners(int *listSize, double *list){
	
	double center_thr = 25;
	int listDim = 7;
	long int NP = *listSize;
	double **imgPts;
	int i,j,k,l;
	int I[4];
	
	/*get memory*/
	imgPts=(double **)malloc(NP * sizeof(double *));
	for (i=0;i<NP;i++) imgPts[i]=(double *)malloc(2 * sizeof(double));
	
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

double* filterSegments(int *listOutSize , int *listInSize , double *listIn, float distance_thr){
	
	int listDim = 7;	
	double* listOut;
	int i,j,k,l;
	double dist[4], dist3[4]; 
	int marker_id = 0;
	int index[4];
	segment seg[4];
	segment segi;
	int marker_found;
	
	/*get memory*/
	listOut=(double *) malloc ( 100 * listDim * sizeof(double));
	
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
						dist[0] = ( pow(seg[0].p1[1]-segi.p1[1],2) + pow(seg[0].p1[2]-segi.p1[2],2) ) < distance_thr;
						dist[1] = ( pow(seg[0].p1[1]-segi.p2[1],2) + pow(seg[0].p1[2]-segi.p2[2],2) ) < distance_thr;
						
						if (dist[0] || dist[1])	{	// p1 match
							seg[1] = segmentNew(listIn[0+i*listDim],
									  			listIn[1+i*listDim],
									  			listIn[2+i*listDim],
									  			listIn[3+i*listDim],
									  			listIn[4+i*listDim]);
							index[1] = i;			
						};			  			
					};
					
					if (!dist[2] && !dist[3])	{	//seg[0] p2 endpoint not matched yet
						dist[2] = ( pow(seg[0].p2[1]-segi.p1[1],2) + pow(seg[0].p2[2]-segi.p1[2],2) ) < distance_thr;
						dist[3] = ( pow(seg[0].p2[1]-segi.p2[1],2) + pow(seg[0].p2[2]-segi.p2[2],2) ) < distance_thr;
						
						if (dist[2] || dist[3])	{	// p2 match
							seg[2] = segmentNew(listIn[0+i*listDim],
										  		listIn[1+i*listDim],
										  		listIn[2+i*listDim],
										  		listIn[3+i*listDim],
										  		listIn[4+i*listDim]);
							index[2] = i;
						};
					};
					
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
										
										*listOutSize = 1+(*listOutSize);
										//burn segments used
										listIn[4+index[l]*listDim] = marker_id; 
									};
									break;
								};
							};
							k++;
						};
					};
				};
				if (marker_found) break;
			};
		};
	};
	return listOut;
};

/***********FUNCIONES DE CORRESPONDENCIAS*************/
/*********** WORK IN PROGRESS ************/
double** getMarkerCornersAlgo(int *listSize, double *list){
	
	double center_thr = 25;
	int listDim = 7;
	long int NP = *listSize;
	double **imgPts, **center, **axis, **aux_axis;
	int i,j,k,l;
	int I[4];
	int ids[NP/4];
	int count[NP/4];
	int center_id = 0;
	
	/*get memory*/
	imgPts=(double **)malloc(NP * sizeof(double *));
	for (i=0;i<NP;i++) imgPts[i]=(double *)malloc(2 * sizeof(double));
	/*get memory*/
	center=(double **)malloc((NP/4) * sizeof(double *));
	for (i=0;i<(NP/4);i++) {
		center[i]=(double *)malloc(2 * sizeof(double));
	 	//memset(center[i], 0, 2 * sizeof(double));
	 }
	/*get memory*/
	axis=(double **)malloc((NP/4) * sizeof(double *));
	for (i=0;i<(NP/4);i++) {
		axis[i]=(double *)malloc(2 * sizeof(double));
	 	//memset(axis[i], 0, 2 * sizeof(double));
	 }
	 
	 /*set ids and count*/
	 for (i=0;i<(NP/4);i++) { ids[i] = i; count[i] = 1; }
	
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
		/*find centers*/
		k = i/4; // center index
		for (j=0;j<4;j++){
			center[k][0]+=0.25*imgPts[I[j]][0];
			center[k][1]+=0.25*imgPts[I[j]][1];	
		}
		
		/*find axis[k]=[(2*minorAxis)^2 (2*mayorAxis)^2] */
		axis[k][0] = pow(imgPts[I[0]][0]-imgPts[I[3]][0],2)+pow(imgPts[I[0]][1]-imgPts[I[3]][1],2);
		axis[k][1] = pow(imgPts[I[1]][0]-imgPts[I[2]][0],2)+pow(imgPts[I[1]][1]-imgPts[I[2]][1],2);
		if (axis[k][0]>axis[k][1]){
			aux_axis[0][0] = axis[k][0];
			axis[k][0] = axis[k][1];
			axis[k][1] = aux_axis[0][0];
		}
		
		
		/*search for matching centers*/
		for (j=0;j<k;j++){
			if (pow(center[k][0]-center[j][0],2)+pow(center[k][1]-center[j][1],2)<center_thr){
				ids[k] = ids[j];
				count[j]++;
				break;
			}
		}	
	}
	
	int aux[2];
	int i_pts = 0;
	/*search for sets of 3 matching centers*/
	for (i=0;i<(NP/4);i++){
		if (count[i] == 3){	//center i matches other 2 centers
			i_pts=0;
			for (j=i+1;j<(NP/4);j++){ //search for the other 2 centers
				if ((ids[j] == ids[i])){
					aux[i_pts++] = j;
					if (i_pts>1) break;
				}
			}
			/*for the 3 matching centers get the group of 
			segments and order from smallest to biggest*/
			if ((axis[aux[0]][1]<=axis[aux[1]][1]) &&  (axis[aux[1]][1]<=axis[aux[2]][1])){
			
			;
			} else if ((axis[aux[0]][1]<=axis[aux[1]][1]) &&  (axis[aux[1]][1]>axis[aux[2]][1])){
			;
			}
		}
	}
	
	/*free memory*/	
	for(i = 0; i<(NP/4); i++)
		free(center[i]);
	free(center);
	
	return imgPts;
};

/*
int compare_mayorAxis (const void *a, const void *b)
     {
       const double *da = (const double *) a[0];
       const double *db = (const double *) b[0];
     
       return (*da > *db) - (*da < *db);
     }
*/
