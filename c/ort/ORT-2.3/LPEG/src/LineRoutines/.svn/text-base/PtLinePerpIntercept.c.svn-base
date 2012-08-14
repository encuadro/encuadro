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
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Name : PtLinePerpIntercept
Type : int
Written on   : 20-Nov-90     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/C/src/LineRoutines

==============================================================================

Input parameters    : 

Point Data:

 PtCol			-- Column position of point
 PtRow			-- Column position of point

Line data:

 RowIntercept		-- Intercepts of the line
 ColIntercept		-- 
 Theta			-- Orientation of the line

Output parameters    : 

 InterceptPtCol	-- The column position of the intercept 
 InterceptPtRow	-- The row position of the intercept 

Output result       : 

 0  = Intercept point located

Called functions :

Calling procedure:

 double PtCol;
 double PtRow;

 double ColIntercept;
 double RowIntercept;

 double InterceptPtCol;
 double InterceptPtRow;
 
 PtLinePerpIntercept(PtCol,
		    	PtRow,
		    	ColIntercept,
		    	RowIntercept,
			Theta,
		    	&InterceptPtCol,
		    	&InterceptPtRow);


Functionality: 

This function finds the point of intercept of the perpendicular dropped from a
point on to a line.

----------------------------------------------------------------------------*/

#include <stdio.h>     /* Standard C I/O library */
#include <math.h>      /* Standard C mathematics library */
#include <errno.h>     /* Standard C error handling routines */
/* #include <strings.h> */   /* Standard C string handling routines */
#include <ctype.h>     /* Standard C type identification routines */

#define PI     3.141593
#define PIBY2  1.570796

/* Compare with PIBY2 with a little leaway to avoid infinities */
#define MACCompareWithPIBY2(a) (a > (PIBY2-0.001) && a < (PIBY2+0.001) )

int PtLinePerpIntercept(PtCol,
		      	   PtRow,
		          ColIntercept,
		          RowIntercept,
			   Theta,
		          InterceptPtCol,
		          InterceptPtRow)

 double PtCol;
 double PtRow;

 double ColIntercept;
 double RowIntercept;
 double Theta;

 double *InterceptPtCol;
 double *InterceptPtRow;

{

 double Grad;
 double GradSquared;
 double OnePlusGradSquared;

#ifdef debug
          fprintf(stderr," Start of function PtLinePerpIntercept \n");
#endif


	if (MACCompareWithPIBY2(Theta)) { /* Line is vertical */
		*InterceptPtRow = PtRow;
		*InterceptPtCol = ColIntercept;
	}

	if (Theta < 0.001 || Theta > (PI-0.001)) { /*Line is horizontal */
		*InterceptPtRow = RowIntercept;
		*InterceptPtCol = PtCol;
	}

/*
 Otherwise we have to work things out...

*/
      if (!MACCompareWithPIBY2(Theta) && Theta >= 0.001 && Theta <= (PI-0.001)) {

      Grad = tan(Theta);
      GradSquared = Grad*Grad;
      OnePlusGradSquared = 1.0 + GradSquared;

	  *InterceptPtRow = (RowIntercept  /(OnePlusGradSquared)) + 
		(Grad*PtCol/(OnePlusGradSquared)) + 
		(GradSquared*PtRow/(OnePlusGradSquared));

	  *InterceptPtCol = (*InterceptPtRow - RowIntercept)/Grad;
      }

	return(0);

#ifdef debug
          fprintf(stderr," End of function PtLinePerpIntercept \n");
#endif

}

