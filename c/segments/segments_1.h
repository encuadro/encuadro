#include <math.h>
#include "lsd.h"

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

void filterSegments(ntuple_list ntl_in, ntuple_list ntl_out , float distance_thr);
