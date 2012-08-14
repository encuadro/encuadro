#include "segments_1.h"

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
