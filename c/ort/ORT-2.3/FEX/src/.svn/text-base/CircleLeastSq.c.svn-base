/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    ORT - Object Recognition Toolkit

Copyright (C) 1991,1992,1993

	Ataollah Etemadi,
	Space and Atmospheric Physics Group,
	Blackett Laboratory,
	Imperial College of Science, Technology and Medicine
	Prince Consort Road,
	London SW7 2BZ.

    Software Contributors:

	J-P. Schmidt,				(Liste, and Xwindows interface)
	G.A.W. West and P.L. Rosin,		(Pixel Chainning S/W)
	G. A. Jones,				(Least-squares circular-arc fitting)

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License as
    published by the Free Software Foundation; either version 1, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

    Note: This program has been exempted from the requirement of
	  paragraph 2c of the General Public License.

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
#include "ListeMacros.h"
#include "Liste.h"
#include "FEX.h"
#include "LPEG.h"

/* =============================================== */
/* 							  */
/* 	Circle Parameter Finding Algorithm		  */
/* 	----------------------------------		  */
/* 	using * Least Squared Error Method		  */
/* 							  */
/* ----------------------------------------------- */
/* 							  */
/*     Author    : Graeme A. Jones 	         */
/* 	Created   : 27th July '89			  */
/* 	Modified  : 10th Oct  '91	GAJ		  */
/* 							  */
/* 	Least Squared Error Subroutine		  */
/* =============================================== */

int CircleLeastSq(   StringCol,StringRow,
			StringStart,StringEnd,
			a,b,r)

       double StringCol[MAXPOINT];
       double StringRow[MAXPOINT];
	double  *a,*b,*r;
       int StringStart,StringEnd;
/*
Variable Definitions:
---------------------
  StringCol,StringRow  : String arrays
  StringStart,StringEnd: Start/end points of string
  a,b,r	         : input  : initial values of center pt and radius
          	         : output : final values of center pt and radius

*/

{
	int e,det_flag;
	double xx,yy;
	double xmatrix[MAXPOINT][3];
	double zmatrix[MAXPOINT];
	double parameters[3];
	double init_x,init_y;

	init_x = (*a);
	init_y = (*b);

    for (e = StringStart; e <= StringEnd; e++) {

	xx = StringCol[e]-init_x;
	yy = StringRow[e]-init_y;

	xmatrix[e][0] =   xx;
	xmatrix[e][1] =   yy;
	xmatrix[e][2] =  1.0;
	zmatrix[e]    =  0.5*(xx*xx+yy*yy); 
    }

    det_flag = 0;
    for (e = 0; e < 3 ; e++) {
	parameters[e] = 0.0;
    }

    PseudoInverse3n(StringStart,StringEnd,
                    &det_flag,xmatrix,zmatrix,parameters);

    if ( det_flag == 0 ) {
		*a = parameters[0];
		*b = parameters[1];
		*r = parameters[2];
		*r = 2.0*(*r) + (*a)*(*a)+ (*b)*(*b);
		if (*r <= 0.0 ) {
                     return(-1);
		} else {
			*r = sqrt((*r));
			*a = *a + init_x;
			*b = *b + init_y;
		}
    } else {
                return(-1);
   }
   return(0);
}

/* ===================================================== */
/* 	End of LEAST SQ ERROR subroutine			 */
/* ===================================================== */

/* ===================================================== */
/* 	Beginning of PSEUDO INVERSE subroutine		 */
/* ===================================================== */


int PseudoInverse3n( StringStart,StringEnd,
			det_flag,
		       a1,b1,c)

int StringStart,StringEnd;
int *det_flag;
double a1[MAXPOINT][3];
double b1[MAXPOINT];
double c[3];

{
    int ii,jj,n;
    double aa[4][4],bb[4][4];
    double cc[3];
    double det;

    for (ii = 0; ii < 3 ; ii++) {
       cc[ii] = 0.0;
       for (jj = 0; jj < 3 ; jj++) {
	  aa[ii][jj] = 0.0;
	  bb[ii][jj] = 0.0;
       }
    }

    for (ii = 0; ii < 3 ; ii++) {
       for (jj = 0; jj < 3 ; jj++) {
          for ( n = StringStart; n <= StringEnd ; n++) {
	    aa[ii][jj] = aa[ii][jj]+a1[n][ii]*a1[n][jj];
    } /* end for n */
   } /* end for jj */
  } /* end for ii */

    det = aa[0][0]*aa[1][1]*aa[2][2]-
          aa[0][0]*aa[1][2]*aa[2][1]+
          aa[0][1]*aa[1][2]*aa[2][0]-
          aa[0][1]*aa[1][0]*aa[2][2]+
          aa[0][2]*aa[1][0]*aa[2][1]-
          aa[0][2]*aa[1][1]*aa[2][0];

    if (det == 0.0 ) {
       *det_flag = 1;

    } else {

    bb[0][0] = (aa[1][1]*aa[2][2]-aa[2][1]*aa[1][2])/det;
    bb[0][1] = (aa[2][1]*aa[0][2]-aa[0][1]*aa[2][2])/det;
    bb[0][2] = (aa[0][1]*aa[1][2]-aa[1][1]*aa[0][2])/det;
    bb[1][0] = (aa[2][0]*aa[1][2]-aa[1][0]*aa[2][2])/det;
    bb[1][1] = (aa[0][0]*aa[2][2]-aa[2][0]*aa[0][2])/det;
    bb[1][2] = (aa[1][0]*aa[0][2]-aa[0][0]*aa[1][2])/det;
    bb[2][0] = (aa[1][0]*aa[2][1]-aa[2][0]*aa[1][1])/det;
    bb[2][1] = (aa[2][0]*aa[0][1]-aa[0][0]*aa[2][1])/det;
    bb[2][2] = (aa[0][0]*aa[1][1]-aa[1][0]*aa[0][1])/det;

    for (ii = 0; ii < 3; ii++) {
          for (n = StringStart; n <= StringEnd; n++) {
             	cc[ii] = cc[ii]+a1[n][ii]*b1[n];
          }
    }

    for (ii = 0; ii < 3; ii++) {
        for (jj = 0; jj < 3; jj++) {
		c[ii]=c[ii]+bb[jj][ii]*cc[jj];
        }
    }

  } /* end of else */

}
