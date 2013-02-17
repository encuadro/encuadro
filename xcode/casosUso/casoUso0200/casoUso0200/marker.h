/*======================includes=======================*/
#include <math.h>
#include "vvector.h"
/*=====================================================*/


/*======================defines========================*/
//marker properties
#define QL_NB_VERTICES 4
#define QLSET_NB_QLS 3
#define MRKR_NB_QLSETS 3
#define MRKR_NP MRKR_NB_QLSETS*QLSET_NB_QLS*QL_NB_VERTICES

//thesholds
#define QL_CENTER_TH 10
#define ANGLE_TH 15
#define PERIMETER_TH 10

//output error codes
#define MRKR_INCOMPLETE_NOT_FOUND -3
#define MRKR_NOT_SUFFICIENT -2
#define MRKR_NOT_ENOUGH_SEGMENTS -1
#define MRKR_COMPLETE_FOUND 0
#define MRKR_INCOMPLETE_FOUND 1


//misc
#define MY_PI 3.14159265358979323846
/*=====================================================*/


/*======================macros=========================*/
//gives angle between (-pi/2,pi/2]
#define VEC_ANGLE_2(a,v) 								\
{														\
(a) = atan((v)[1]/(v)[0])*(180/MY_PI);	\
}

/*gives angle between (-pi,pi]*/
/*
 #define VEC_ANGLE_2(a,v) 								\
 {														\
 (a) = fmod((atan2((v)[1],(v)[0]))*(180/MY_PI),180);	\
 }
 */
/*=====================================================*/


/*====================structures=======================*/
/*FIXME: resolve structure intialization! */
typedef struct quadrilateral{
	//const int NB = QL_NB_VERTICES;
	float vertices[QL_NB_VERTICES][2];
	float dirs_deg[QL_NB_VERTICES];
	float center[2] ;
	float perimeter;
	int id; //not constructed - not assigned
} quadrilateral;
typedef struct quadrilateralSet {
	//const int NB = QLSET_NB_QLS;
	quadrilateral ql[QLSET_NB_QLS];
	float center[2] ;
	int id; //not constructed - not assigned
    
} quadrilateralSet;
typedef struct markerQr{
	//const int NB = MRKR_NB_QLSETS;
	quadrilateralSet qlSet[MRKR_NB_QLSETS];
	float origin[2] ;
	float directions[2][2];
} markerQr;
/*=====================================================*/


/*======================constructors===================*/
quadrilateral quadrilateralNew(float vertices[4][2]);
quadrilateralSet quadrilateralSetNew(quadrilateral ql[QLSET_NB_QLS]);
markerQr markerQrNew(quadrilateralSet qlSet[MRKR_NB_QLSETS]);
/*=====================================================*/


/*=====================functions=======================*/
int findPointCorrespondances(int *listSize, float *list, float **imgPts);
int getMarkerVertices(markerQr marker, float **imgPts);

int getQlList(int listSize, float *list, quadrilateral *qlList);
int getQlSet(int qlListSize, quadrilateral *qlList, quadrilateralSet *qlSet );
int getQlSetArr(int qlListSize, quadrilateral *qlList, quadrilateralSet *qlSet);
int getMarker(quadrilateralSet *qlSet, markerQr *marker);
int getQlSetArrDirections(quadrilateralSet qlSet[MRKR_NB_QLSETS]);

int orderQlArr(quadrilateral *ql);
int orderQlSetArr(quadrilateralSet *qlSet);
int orderQlSetArr2(quadrilateralSet *qlSet);
int orderMarkerVertices(markerQr *marker);

int getIncompleteQlSet(int qlListSize, quadrilateral *qlList, quadrilateralSet *qlSet , float perimeter[3]);
int getIncompleteQlSetArr(int qlListSize, quadrilateral *qlList, quadrilateralSet *qlSet);
int orderIncompleteQlArr(quadrilateral *ql, float perimeter[3]);
int getCropLists(float **imagePts, float **worldPts, float
                 **imagePtsCrop, float **worldPtsCrop);

/*=====================================================*/

