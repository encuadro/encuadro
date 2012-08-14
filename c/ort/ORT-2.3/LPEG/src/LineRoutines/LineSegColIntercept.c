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

Name : LineSegColIntercept
Type : int
Written on   : 20-Nov-90     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/ORT/LPEG/src/LineRoutines

==============================================================================

Input parameters    : 

 StartCol		-- The column number of the start point of the line
 StartRow		-- The row number of the start point of the line
 EndCol		-- The column number of the end point of the line
 EndRow		-- The row number of the end point of the line 

Output result       : 

 -1 = Intercept point is at infinity (ie line is horizontal)
  0 = successful in calculating gradient

Output parameters   :

 ColIntercept		-- Intercept of the line (y = m.x + c) with x axis

Calling procedure:

 double StartCol;
 double StartRow;
 double EndCol;
 double EndRow;

 double ColIntercept;

 LineSegColIntercept( StartCol,
  		     StartRow,
		     EndCol,
                   EndRow,
		    &ColIntercept)

Functionality: 

This function finds the Intercept point of a line with the x axis, given 
any two points that lie along the line. 

----------------------------------------------------------------------------*/

#include <stdio.h>     /* Standard C I/O library */
#include <math.h>      /* Standard C mathematics library */
#include <errno.h>     /* Standard C error handling routines */
/* #include <strings.h> */   /* Standard C string handling routines */
#include <ctype.h>     /* Standard C type identification routines */

#ifndef HUGE
#define HUGE 999999999.0
#endif

int LineSegColIntercept(StartCol,
		       StartRow,
		       EndCol,
		       EndRow,
		       ColIntercept)

 double StartCol;
 double StartRow;
 double EndCol;
 double EndRow;

 double *ColIntercept;

{

#ifdef debug
          fprintf(stderr," Start of function LineSegColIntercept \n");
#endif

    if (EndCol == StartCol) { 	/* Line is vertical */
	*ColIntercept = StartCol; 
	return(0);
    }

    if ( EndRow != StartRow) {	/* Line is not horizontal */
	*ColIntercept = (StartCol*EndRow - EndCol*StartRow)/
			      (EndRow - StartRow); 
	return(0);
    }

  *ColIntercept = HUGE;     /* Line is horizontal */
  return(-1);

#ifdef debug
          fprintf(stderr," End of function LineSegColIntercept \n");
#endif

}

