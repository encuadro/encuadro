#include <math.h>
#include "vvector.h"

/*----defines-----*/
#define QL_NB_VERTICES 4
#define QLSET_NB_QLS 3
#define MRKR_NB_QLSETS 3
#define QL_CENTER_TH 5

#define MY_PI 3.14159265358979323846

/*-----macros-----*/

/*gives angle between (-pi/2,pi/2]*/
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
/*----structures-----*/
/*FIXME: resolve structure intialization! */
typedef struct quadrilateral{
	//const int NB = QL_NB_VERTICES;
	double vertices[QL_NB_VERTICES][2];
	double dirs_deg[QL_NB_VERTICES];
	double center[2] ;
	double perimeter;
	int id; //not constructed - not assigned
} quadrilateral;
typedef struct quadrilateralSet {
	//const int NB = QLSET_NB_QLS;
	quadrilateral ql[QLSET_NB_QLS];
	double center[2] ;
	int id; //not constructed - not assigned

} quadrilateralSet;
typedef struct markerQr{
	//const int NB = MRKR_NB_QLSETS;
	quadrilateralSet qlSet[MRKR_NB_QLSETS];
	double origin[2] ;
	double directions[2][2];
} markerQr;


/*-----constructors-----*/
quadrilateral quadrilateralNew(double vertices[4][2]);
quadrilateralSet quadrilateralSetNew(quadrilateral ql[QLSET_NB_QLS]);
markerQr markerQrNew(quadrilateralSet qlSet[MRKR_NB_QLSETS]);

/*-----functions------*/
double** findPointCorrespondances(int *listSize, double *list);
double** getMarkerVertices(markerQr marker);

quadrilateral* getQlList(int listSize, double *list);
quadrilateralSet getQlSet(int qlListSize, quadrilateral *qlList);
markerQr getMarker(quadrilateralSet qlSet[MRKR_NB_QLSETS]);
int getQlSetArrDirections(quadrilateralSet qlSet[MRKR_NB_QLSETS]);

int orderQlArr(quadrilateral *ql);
int orderQlSetArr(quadrilateralSet *qlSet);
int orderQlSetArr2(quadrilateralSet *qlSet);
int orderMarkerVertices(markerQr *marker);


