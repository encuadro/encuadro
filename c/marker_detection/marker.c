#include "vvector.h"
#include "marker.h"
#include "segments.h"
#include <math.h>
#include <stdlib.h>
#include <stdio.h>

int QlId = 1;

#define VERBOSE 0

int compare_quadrilateral_perimeter(const void* a, const void* b) {
	struct quadrilateral* qa = (struct quadrilateral *) a;
	struct quadrilateral* qb = (struct quadrilateral *) b;
	return (int) (((*qa).perimeter > (*qb).perimeter)
			- ((*qa).perimeter < (*qb).perimeter));
}

quadrilateral quadrilateralNew(double vertices[QL_NB_VERTICES][2]) {

	quadrilateral ql;
	double sidelength;
	double side[2];

	VEC_ZERO_2(ql.center);
	ql.perimeter = 0;

	for (int i = 0; i < QL_NB_VERTICES; i++) {
		VEC_COPY_2(ql.vertices[i], vertices[i]);
		ql.center[0] += (1.0 / QL_NB_VERTICES) * (ql.vertices[i][0]);
		ql.center[1] += (1.0 / QL_NB_VERTICES) * (ql.vertices[i][1]);

		VEC_DIFF_2(side, ql.vertices[i], vertices[(i+1)%QL_NB_VERTICES]);
		//VEC_ANGLE_2(ql.dirs_deg[i],side);

		VEC_LENGTH_2(sidelength, side);
		ql.perimeter += sidelength;
	}

	ql.id = 0; //constructed - not assigned

	return ql;
}

quadrilateralSet quadrilateralSetNew(quadrilateral ql[QLSET_NB_QLS]) {

	quadrilateralSet qlSet;

	VEC_ZERO_2(qlSet.center);

	double count = 0;
	for (int i = 0; i < QLSET_NB_QLS; i++) {
		qlSet.ql[i] = ql[i];
		if (qlSet.ql[i].id != -1) {
			qlSet.center[0] += qlSet.ql[i].center[0];
			qlSet.center[1] += qlSet.ql[i].center[1];
			count++;
		}
	}
	qlSet.center[0] /= count;
	qlSet.center[1] /= count;

	qlSet.id = 0; //constructed - not assigned

	return qlSet;
}

markerQr markerQrNew(quadrilateralSet qlSet[MRKR_NB_QLSETS]) {
	markerQr marker;

	VEC_ZERO_2(marker.origin);

	for (int i = 0; i < MRKR_NB_QLSETS; i++)
		marker.qlSet[i] = qlSet[i];

	marker.origin[0] = qlSet[0].center[0];
	marker.origin[1] = qlSet[0].center[1];

	VEC_DIFF_2(marker.directions[0], qlSet[1].center, qlSet[0].center);
	VEC_DIFF_2(marker.directions[1], qlSet[2].center, qlSet[0].center);

	VEC_NORMALIZE_2(marker.directions[0]);
	VEC_NORMALIZE_2(marker.directions[1]);

	return marker;

}

int getQlSetArrDirections(quadrilateralSet qlSet[MRKR_NB_QLSETS]) {

	//UNUSED

	return 0;
}

int orderMarkerVertices(markerQr *marker) {

	double px, py;
	double vect[2];
	double temp_vertices[4][2];

	for (int i = 0; i < MRKR_NB_QLSETS; i++) {
		for (int j = 0; j < QLSET_NB_QLS; j++) {

			/*FIXME: implement circular shift for less general but better performance (?) */
			for (int k = 0; k < QL_NB_VERTICES; k++) {

				if ((marker->qlSet[i].ql[j].id) == -1) {
					VEC_COPY_2(temp_vertices[k],
							marker->qlSet[i].ql[j].vertices[k]);
				} else {
					VEC_DIFF_2(vect, marker->qlSet[i].ql[j].vertices[k],
							marker->qlSet[i].center);
					VEC_DOT_PRODUCT_2(px, vect, marker->directions[0]);
					VEC_DOT_PRODUCT_2(py, vect, marker->directions[1]);

					if (px >= 0 && py >= 0) {
						VEC_COPY_2(temp_vertices[0],
								marker->qlSet[i].ql[j].vertices[k]);
					} else if (px >= 0 && py <= 0) {
						VEC_COPY_2(temp_vertices[1],
								marker->qlSet[i].ql[j].vertices[k]);
					} else if (px <= 0 && py <= 0) {
						VEC_COPY_2(temp_vertices[2],
								marker->qlSet[i].ql[j].vertices[k]);
					} else if (px <= 0 && py >= 0) {
						VEC_COPY_2(temp_vertices[3],
								marker->qlSet[i].ql[j].vertices[k]);
					}
				}
			}
			for (int l = 0; l < QL_NB_VERTICES; l++)
				VEC_COPY_2(marker->qlSet[i].ql[j].vertices[l],
						temp_vertices[l]);
		}
	}
	return 0;
}

int getQlList(int listSize, double *list, quadrilateral *qlList) {

	double center_thr = 25;
	int listDim = 7;
	long int NP = listSize;
	int i, j, k, l;
	int I[4];

	double vertices[4][2];

	for (i = 0; i < NP; i += QL_NB_VERTICES) {
		I[0] = i;
		I[1] = i + 1;
		I[2] = i + 2;
		I[3] = i + 3;

		lineIntersection(list[0 + I[0] * listDim], list[1 + I[0] * listDim],
				list[2 + I[0] * listDim], list[3 + I[0] * listDim],
				list[0 + I[1] * listDim], list[1 + I[1] * listDim],
				list[2 + I[1] * listDim], list[3 + I[1] * listDim],
				&vertices[0][0], &vertices[0][1]);
		lineIntersection(list[0 + I[0] * listDim], list[1 + I[0] * listDim],
				list[2 + I[0] * listDim], list[3 + I[0] * listDim],
				list[0 + I[2] * listDim], list[1 + I[2] * listDim],
				list[2 + I[2] * listDim], list[3 + I[2] * listDim],
				&vertices[1][0], &vertices[1][1]);
		lineIntersection(list[0 + I[2] * listDim], list[1 + I[2] * listDim],
				list[2 + I[2] * listDim], list[3 + I[2] * listDim],
				list[0 + I[3] * listDim], list[1 + I[3] * listDim],
				list[2 + I[3] * listDim], list[3 + I[3] * listDim],
				&vertices[2][0], &vertices[2][1]);
		lineIntersection(list[0 + I[1] * listDim], list[1 + I[1] * listDim],
				list[2 + I[1] * listDim], list[3 + I[1] * listDim],
				list[0 + I[3] * listDim], list[1 + I[3] * listDim],
				list[2 + I[3] * listDim], list[3 + I[3] * listDim],
				&vertices[3][0], &vertices[3][1]);

		/* Segment configuration for coherent vertex extraction
		 *
		 * -Sides (x)
		 * -Vertices x
		 * -Two posible results:
		 *      	    (1)      			    (2)
		 * 			0----------3 			1----------2
		 * 			|		   | 			|		   |
		 * 		 (0)|          |(3) 	 (0)|          |(3)
		 * 			|          | 			|          |
		 * 			1----------2 			0----------3
		 * 			    (2)		 			    (1)
		 * */

		qlList[i / QL_NB_VERTICES] = quadrilateralNew(vertices);

		//patch to get coherent ql's
		for (int j=0;j<4;j++){
			if (vertices[j][0]<0 || vertices[j][0]>900 || vertices[j][1]<0 || vertices[j][1]>900 ){
				qlList[i / QL_NB_VERTICES].id = -1;
				break;
			}

		}
	}

	return 0;
}

int getIncompleteQlSetArr(int qlListSize, quadrilateral *qlList,
		quadrilateralSet *qlSet) {

	/*sanity check*/
	int markerIsComplete = 1;
	int markerIsSufficient = 0;
	int count = 0;
	for (int i = 0; i < MRKR_NB_QLSETS; i++) {
		markerIsComplete &= (qlSet[i].id == 1);
		markerIsSufficient |= (qlSet[i].id == 1);
		count += (qlSet[i].id == 1);
	}

	if (VERBOSE)
		printf("markerIsComplete: %d\n", markerIsComplete);
	if (VERBOSE)
		printf("markerIsSufficient: %d\n", markerIsSufficient);

	if (markerIsComplete == 1) {
		printf("MSG: MRKR_COMPLETE_FOUND\n");
		return MRKR_COMPLETE_FOUND;
	} else if (markerIsSufficient == 0) {
		printf("MSG: MRKR_NOT_SUFFICIENT\n");
		return MRKR_NOT_SUFFICIENT;
	}

	/*get mean perimeters*/
	double perimeter[3] = { 0, 0, 0 };
	for (int i = 0; i < MRKR_NB_QLSETS; i++) {
		if (qlSet[i].id == 1) {
			for (int j = 0; j < QLSET_NB_QLS; j++)
				perimeter[j] += qlSet[i].ql[j].perimeter;
		}
	}
	for (int j = 0; j < QLSET_NB_QLS; j++)
		perimeter[j] /= count;

	if (VERBOSE)
		printf("perimeters: %f %f %f\n", perimeter[0], perimeter[1],
				perimeter[2]);

	/*get QlSet*/
	int not_found = 0;
	for (int i = 0; i < MRKR_NB_QLSETS; i++) {
		if (qlSet[i].id == -1) {
			not_found |= getIncompleteQlSet(qlListSize, qlList, &qlSet[i], perimeter);
		}

		if (VERBOSE) printf("id %d: %d\n", i, (qlSet[i].id));
		if (VERBOSE) printf("ql ids: %d %d %d\n", qlSet[i].ql[0].id, qlSet[i].ql[1].id, qlSet[i].ql[2].id);
		if (VERBOSE) printf("perimeters good: %f %f %f\n", qlSet[i].ql[0].perimeter, qlSet[i].ql[1].perimeter, qlSet[i].ql[2].perimeter);
	}

	if (not_found==1){
		printf("MSG: MRKR_INCOMPLETE_NOT_FOUND\n");
		return MRKR_INCOMPLETE_NOT_FOUND;
	}

	printf("MSG: MRKR_INCOMPLETE_FOUND\n");
	return MRKR_INCOMPLETE_FOUND;
}

int getIncompleteQlSet(int qlListSize, quadrilateral *qlList,
		quadrilateralSet *qlSet, double perimeter[3]) {

	quadrilateral ql[QLSET_NB_QLS];

	double cicj[2];
	double dist_cicj;
	int found = 0;

	for (int i = 0; i < qlListSize; i++) {
		if (qlList[i].id == 0) {

			for (int j = i + 1; j < qlListSize; j++) {
				if (qlList[j].id == 0) {
					VEC_DIFF_2(cicj, qlList[i].center, qlList[j].center);
					VEC_LENGTH_2(dist_cicj, cicj);
					if (dist_cicj < QL_CENTER_TH) {

						qlList[i].id = QlId++;
						qlList[j].id = QlId++;
						ql[0] = qlList[i];
						ql[1] = qlList[j];

						orderIncompleteQlArr(ql, perimeter);
						(*qlSet) = quadrilateralSetNew(ql);
						(*qlSet).id = 2;
						found = 1;
						if (VERBOSE)
							printf("found incomplete\n");
						return 0;
					}
				}
			}
		}
	}
	return 1;
}

int orderIncompleteQlArr(quadrilateral *ql, double perimeter[3]) {

	double verticesDummy[4][2] = { { -1, -1 }, { -1, -1 }, { -1, -1 },
			{ -1, -1 } };
	quadrilateral qlTemp, qlDummy;
	qlDummy = quadrilateralNew(verticesDummy);
	qlDummy.id = -1;

/*	int checks[QLSET_NB_QLS] = { 0, 0, 0 };
	//match ql[0-1].perimeter with corresponding perimeters
	for (int i = 0; i < QLSET_NB_QLS - 1; i++) {
		for (int j = 0; j < QLSET_NB_QLS; j++) {
			if (fabs(ql[i].perimeter - perimeter[j]) < PERIMETER_TH) {
				checks[i] = 1;
				break;
			}
		}
	}
	//the one unmatched is assigned to qlDummy for correct sorting
	int found = 1;
	for (int i = 0; i < QLSET_NB_QLS; i++) {
		if (checks[i] != 1) {
			ql[2] = qlDummy;
			ql[2].perimeter = perimeter[i];
			found = 1;
			break;
		}

	}
*/
	//compute perimeter errors
	double perim_err[QLSET_NB_QLS-1][QLSET_NB_QLS] = { { 0, 0, 0 } , { 0, 0, 0 } };
	for (int i = 0; i < QLSET_NB_QLS-1; i++) {
		for (int j = 0; j < QLSET_NB_QLS; j++) {
			perim_err[i][j] =  fabs(ql[i].perimeter - perimeter[j]);
		}
	}
	//get matches by min perimeter error
	int checks[QLSET_NB_QLS] = { -1, -1, -1 };
	for (int i = 0; i < QLSET_NB_QLS-1; i++) {
		double perim_min_err = 10000;
		for (int j = 0; j < QLSET_NB_QLS; j++) {
			if (perim_err[i][j]<perim_min_err){
				checks[i]=j;
				perim_min_err = perim_err[i][j];
			}
		}
	}
	//the one unmatched is assigned to qlDummy for correct sorting
/*	int found = 1;
	for (int i = 0; i < QLSET_NB_QLS; i++) {
		if (checks[i] == -1) {
			ql[2] = qlDummy;
			ql[2].perimeter = perimeter[i];
			found = 1;
			break;
		}
	}
*/
	int found = 0;
	if ((checks[0]==0 && checks[1]==1) || (checks[0]==1 && checks[1]==0)){
		ql[2] = qlDummy;
		ql[2].perimeter = perimeter[2];
		found = 1;
	}else if ((checks[0]==1 && checks[1]==2) || (checks[0]==2 && checks[1]==1)){
		ql[2] = qlDummy;
		ql[2].perimeter = perimeter[0];
		found = 1;
	}else if ((checks[0]==0 && checks[1]==2) || (checks[0]==2 && checks[1]==0)){
		ql[2] = qlDummy;
		ql[2].perimeter = perimeter[1];
		found = 1;
	}
	/*sort*/
	if ((checks[0]!=checks[1]) && (found == 1)){
		qsort(ql, 3, sizeof(quadrilateral), compare_quadrilateral_perimeter);
		return 0;
	}

	return 1;
}

int getQlSetArr(int qlListSize, quadrilateral *qlList, quadrilateralSet *qlSet) {

	int not_found = 0;

	for (int i = 0; i < MRKR_NB_QLSETS; i++) {
		qlSet[i].id = -1;
		not_found |= getQlSet(qlListSize, qlList, &qlSet[i]);

		if (VERBOSE)
			printf("id %d: %d\n", i, (qlSet[i].id));
		if (VERBOSE)
			printf("ql ids: %d %d %d\n", qlSet[i].ql[0].id, qlSet[i].ql[1].id,
					qlSet[i].ql[2].id);
		if (VERBOSE)
			printf("perimeters good: %f %f %f\n", qlSet[i].ql[0].perimeter,
					qlSet[i].ql[1].perimeter, qlSet[i].ql[2].perimeter);

	}

	return not_found;
}

int getQlSet(int qlListSize, quadrilateral *qlList, quadrilateralSet *qlSet) {

	quadrilateral ql[QLSET_NB_QLS];
	//ql=(quadrilateral *)malloc(QLSET_NB_QLS * sizeof(quadrilateral));

	double cicj[2], cick[2];
	double dist_cicj, dist_cick;
	int found = 0;

	/*FIXME: find a more general way. store indexes. two nested for's not three*/
	for (int i = 0; i < qlListSize; i++) {
		if (qlList[i].id == 0) {

			for (int j = i + 1; j < qlListSize; j++) {
				if (qlList[j].id == 0) {
					VEC_DIFF_2(cicj, qlList[i].center, qlList[j].center);
					VEC_LENGTH_2(dist_cicj, cicj);
					if (dist_cicj < QL_CENTER_TH) {

						for (int k = j + 1; k < qlListSize; k++) {
							if (qlList[k].id == 0) {
								VEC_DIFF_2(cick, qlList[i].center,
										qlList[k].center);
								VEC_LENGTH_2(dist_cick, cick);
								if (dist_cick < QL_CENTER_TH) {

									qlList[i].id = QlId++;
									qlList[j].id = QlId++;
									qlList[k].id = QlId++;
									ql[0] = qlList[i];
									ql[1] = qlList[j];
									ql[2] = qlList[k];

									orderQlArr(ql);
									(*qlSet) = quadrilateralSetNew(ql);
									(*qlSet).id = 1;
									found = 1;
									if (VERBOSE)
										printf("found\n");

									return 0;
								}
							}
						}
					}
				}
			}
		}
	}

	return 1;
}

int orderQlArr(quadrilateral *ql) {
	/*FIXME: consider using std c function "qsort"
	 * http://www.gnu.org/software/libc/manual/html_node/Array-Sort-Function.html
	 * http://www.anyexample.com/programming/c/qsort__sorting_array_of_strings__integers_and_structs.xml
	 *
	 * Declarations:
	 * 		void qsort (void *array, size_t count, size_t size, comparison_fn_t compare)
	 * 		int comparison_fn_t (const void *, const void *)
	 *
	 * Usage:
	 * 		qsort (ql, 3, sizeof(quadrilateral), compare_qlarray_perimeter);
	 *
	 * 		int compare_quadrilateral_perimeter(const void* a, const void* b) {
	 * 		    struct quadrilateral* qa = (struct quadrilateral *)a;
	 *			struct quadrilateral* qb = (struct quadrilateral *)b;
	 *			return (int)( ( (*qa).perimeter > (*qb).perimeter ) - ( (*qa).perimeter < (*qb).perimeter) ) ;
	 * 		}
	 */

	qsort(ql, 3, sizeof(quadrilateral), compare_quadrilateral_perimeter);

	quadrilateral qlTemp;

	/*order quadrilaterals*/
	/*	if (( ql[0].perimeter < ql[1].perimeter) && ( ql[1].perimeter < ql[2].perimeter )){
	 // order already done
	 } else if (( ql[0].perimeter < ql[2].perimeter) && ( ql[2].perimeter < ql[1].perimeter )){
	 qlTemp = ql[1];
	 ql[1] = ql[2];
	 ql[2] = qlTemp;
	 } else if (( ql[1].perimeter < ql[0].perimeter) && ( ql[0].perimeter < ql[2].perimeter )){
	 qlTemp = ql[0];
	 ql[0] = ql[1];
	 ql[1] = qlTemp;
	 } else if (( ql[1].perimeter < ql[2].perimeter) && ( ql[2].perimeter < ql[0].perimeter )){
	 qlTemp = ql[0];
	 ql[0] = ql[1];
	 ql[1] = ql[2];
	 ql[2] = qlTemp;
	 } else if (( ql[2].perimeter < ql[0].perimeter) && ( ql[0].perimeter < ql[1].perimeter )){
	 qlTemp = ql[0];
	 ql[0] = ql[2];
	 ql[2] = ql[1];
	 ql[1] = qlTemp;
	 } else if (( ql[2].perimeter < ql[1].perimeter) && ( ql[1].perimeter < ql[0].perimeter )){
	 qlTemp = ql[0];
	 ql[0] = ql[2];
	 ql[2] = qlTemp;
	 } else	{	return 1;	}
	 */
	return 0;
}

int getMarker(quadrilateralSet *qlSet, markerQr *marker) {

	orderQlSetArr(qlSet);
	*marker = markerQrNew(qlSet);
	orderMarkerVertices(marker);

	return 0;
}

int orderQlSetArr(quadrilateralSet *qlSet) {
	quadrilateralSet qlSetTemp[MRKR_NB_QLSETS];
	double vect[MRKR_NB_QLSETS][2];
	double leng[MRKR_NB_QLSETS];
	double dirs[2][2];
	int ref_index = -1;

	/*compute the 3 posible principal directions*/
	for (int i = 0; i < MRKR_NB_QLSETS; i++) {
		VEC_DIFF_2(vect[i], qlSet[i].center,
				qlSet[(i+1)%MRKR_NB_QLSETS].center);
		VEC_LENGTH_2(leng[i], vect[i]);
		VEC_NORMALIZE_2(vect[i]);
	}
	/*find out y direction by minimum distance*/
	for (int i = 0; i < MRKR_NB_QLSETS; i++) {
		if ((leng[i] < leng[(i + 1) % MRKR_NB_QLSETS])
				&& (leng[i] < leng[(i + 2) % MRKR_NB_QLSETS])) {
			VEC_COPY_2(dirs[1], vect[i]);
			VEC_NORMALIZE_2(dirs[1]);
			ref_index = i;
			break;
		}
	}

	double cos_angle1, cos_angle2;
	/*find out origin by widest angle*/
	VEC_DOT_PRODUCT_2(cos_angle1, dirs[1], vect[(ref_index+1)%MRKR_NB_QLSETS]);
	VEC_DOT_PRODUCT_2(cos_angle2, dirs[1], vect[(ref_index+2)%MRKR_NB_QLSETS]);
	if (fabs(cos_angle1) < fabs(cos_angle2)) {
		qlSetTemp[0] = qlSet[(ref_index + 1) % MRKR_NB_QLSETS];
		qlSetTemp[1] = qlSet[(ref_index + 2) % MRKR_NB_QLSETS];
		qlSetTemp[2] = qlSet[(ref_index) % MRKR_NB_QLSETS];
	} else {
		qlSetTemp[0] = qlSet[(ref_index) % MRKR_NB_QLSETS];
		qlSetTemp[1] = qlSet[(ref_index + 2) % MRKR_NB_QLSETS];
		qlSetTemp[2] = qlSet[(ref_index + 1) % MRKR_NB_QLSETS];
	}

	for (int i = 0; i < MRKR_NB_QLSETS; i++)
		qlSet[i] = qlSetTemp[i];

	return 0;
}

int orderQlSetArr2(quadrilateralSet *qlSet) {

	quadrilateralSet qlSetTemp[MRKR_NB_QLSETS];
	double vect[MRKR_NB_QLSETS][2];
	double leng[MRKR_NB_QLSETS];
	double dirs[2][2];
	double angles[2] = { 0, 0 };
	double ref_angle = -1;
	double ref_index = -1;
	double test_angle[2];

	/*compute the 3 posible principal directions*/
	for (int i = 0; i < MRKR_NB_QLSETS; i++) {
		VEC_DIFF_2(vect[i], qlSet[i].center,
				qlSet[(i+1)%MRKR_NB_QLSETS].center);
		VEC_LENGTH_2(leng[i], vect[i]);
	}
	/*find out y direction by minimum distance criteria*/
	for (int i = 0; i < MRKR_NB_QLSETS; i++) {
		if ((leng[i] < leng[(i + 1) % MRKR_NB_QLSETS])
				&& (leng[i] < leng[(i + 2) % MRKR_NB_QLSETS])) {
			VEC_COPY_2(dirs[1], vect[i]);
			VEC_ANGLE_2(ref_angle, dirs[1]);
			ref_index = i;
			break;
		}
	}

	/*ahora vamos sacando dirección a dirección y clasificando con un threshold
	 * FIXME: se podría hacer en la función getQlSetDirections o cambiando nombre por getQlSetArrDirections*/
	for (int i = 0; i < MRKR_NB_QLSETS; i++) {
		for (int j = 0; j < QLSET_NB_QLS; j++) {
			for (int k = 0; k < QL_NB_VERTICES; k++) {
				if (fabs(qlSet[i].ql[j].dirs_deg[k] - ref_angle) < ANGLE_TH
						|| fabs(qlSet[i].ql[j].dirs_deg[k] - ref_angle)
								> (180 - ANGLE_TH))
					angles[1] += qlSet[i].ql[j].dirs_deg[k];
				else
					angles[0] += qlSet[i].ql[j].dirs_deg[k];
			}
		}
	}
	//mean angle acum
	angles[0] = angles[0] / (MRKR_NB_QLSETS * QLSET_NB_QLS * QL_NB_VERTICES);
	angles[1] = angles[1] / (MRKR_NB_QLSETS * QLSET_NB_QLS * QL_NB_VERTICES);

	for (int i = 0; i < MRKR_NB_QLSETS; i++) {
		VEC_DIFF_2(dirs[0], qlSet[i].center,
				qlSet[(i+1)%MRKR_NB_QLSETS].center);
		VEC_DIFF_2(dirs[1], qlSet[i].center,
				qlSet[(i+2)%MRKR_NB_QLSETS].center);
		VEC_ANGLE_2(test_angle[0], dirs[0]);
		VEC_ANGLE_2(test_angle[1], dirs[1]);

		if ((fabs(angles[0] - test_angle[0]) < ANGLE_TH
				|| fabs(angles[0] - test_angle[0]) > (180 - ANGLE_TH))
				&& (fabs(angles[1] - test_angle[1]) < ANGLE_TH
						|| fabs(angles[1] - test_angle[1]) > (180 - ANGLE_TH))) {
			qlSetTemp[0] = qlSet[i];
			qlSetTemp[1] = qlSet[(i + 1) % MRKR_NB_QLSETS];
			qlSetTemp[2] = qlSet[(i + 2) % MRKR_NB_QLSETS];
			break;
		} else if ((fabs(angles[0] - test_angle[1]) < ANGLE_TH
				|| fabs(angles[0] - test_angle[1]) > (180 - ANGLE_TH))
				&& (fabs(angles[1] - test_angle[0]) < ANGLE_TH
						|| fabs(angles[1] - test_angle[0]) > (180 - ANGLE_TH))) {
			qlSetTemp[0] = qlSet[i];
			qlSetTemp[1] = qlSet[(i + 2) % MRKR_NB_QLSETS];
			qlSetTemp[2] = qlSet[(i + 1) % MRKR_NB_QLSETS];
			break;
		}
	}
	/*
	 idx
	 for (int i=0;i<MRKR_NB_QLSETS;i++) {
	 qlSet[i] = qlSetTemp[i];
	 if (qlSet[i].id == -1)
	 }
	 */
	if (ref_index != -1)
		return 0;
	else
		return ref_index;
}

int findPointCorrespondances(int *listSize, double *list, double **imgPts) {

	int error_code;

	if (VERBOSE)
		printf("-------\n");
	if (VERBOSE)
		printf("number of segments: %d\n", *listSize);

	if (*listSize >= 28) {
		quadrilateral qlList[*listSize / 4];
		quadrilateralSet qlSet[QLSET_NB_QLS];
		markerQr marker;

		getQlList(*listSize, list, qlList);
		getQlSetArr(*listSize / 4, qlList, qlSet);

		error_code = getIncompleteQlSetArr(*listSize / 4, qlList, qlSet);

		if (error_code == MRKR_INCOMPLETE_FOUND || error_code == MRKR_COMPLETE_FOUND)
		{
			getMarker(qlSet, &marker);
			getMarkerVertices(marker, imgPts);
		}
	} else {
		for (int i = 0; i < MRKR_NP; i++) {
			imgPts[i][0] = 0;
			imgPts[i][1] = 0;
		}
		error_code = MRKR_NOT_ENOUGH_SEGMENTS;
		printf("MSG: MRKR_NOT_ENOUGH_SEGMENTS\n");
	}

	return error_code;

}

int getMarkerVertices(markerQr marker, double **imgPts) {

	int contador = 0;
	for (int i = 0; i < MRKR_NB_QLSETS; i++) {
		for (int j = 0; j < QLSET_NB_QLS; j++) {
			for (int k = 0; k < QL_NB_VERTICES; k++) {
				VEC_COPY_2(imgPts[contador], marker.qlSet[i].ql[j].vertices[k]);
				contador++;
			}
		}
	}

	return 0;
}

int getCropLists(double** imagePts, double** worldPts, double
                 **imagePtsCrop, double **worldPtsCrop){
    int k=0;
    for (int i=0; i<36; i++) {
        if ((imagePts[i][0]!=-1)&&(imagePts[i][1]!=-1)) {
            imagePtsCrop[k][0]=imagePts[i][0];
            imagePtsCrop[k][1]=imagePts[i][1];
            
            worldPtsCrop[k][0]=worldPts[i][0];
            worldPtsCrop[k][1]=worldPts[i][1];
            worldPtsCrop[k][2]=worldPts[i][2];
            k++;
        }
    }
    //    printf("IMG POINTS CROP: \n");
    //    for (int i=0; i<k; i++) {
    //        printf("%g\t%g\n",imagePtsCrop[i][0],imagePtsCrop[i][1]);
    //    }
    
    //    printf("\nWORLD POINTS CROP: \n");
    //
    //    for (int i=0; i<k; i++) {
    //        printf("%g\t%g\t%g\n",worldPtsCrop[i][0],worldPtsCrop[i][1],worldPtsCrop[i][2]);
    //    }
    
    return k;
    
}
