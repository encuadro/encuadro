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

Name : PtLinePerpDistance
Type : double
Written on   : 20-Nov-90     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/C/src/LineRoutines

==============================================================================

Input parameters    : 

Point Data:

 PtCol			-- Column position of point
 PtRow			-- Column position of point

Line data:

 ColIntercept		-- Intercepts of the line
 RowIntercept		-- 
 Theta			-- Orientation of the line

Output parameters    : 

Output result       : 

 Distance		-- Perpendicular distance between the point and the line

Called functions :

 PtLinePerpIntercept
 LineLength

Calling procedure:

 double PtCol;
 double PtRow;

 double ColIntercept;
 double RowIntercept;
 double Theta;

 double Distance;
 
 distance = PtLinePerpDistance(PtCol,
		      		   PtRow,
		      		   ColIntercept,
		      		   RowIntercept,
		      		   Theta);

Functionality: 

This function finds the perpendicular distance from a point to a line.

----------------------------------------------------------------------------*/

#include <stdio.h>     /* Standard C I/O library */
#include <math.h>      /* Standard C mathematics library */
#include <errno.h>     /* Standard C error handling routines */
/* #include <strings.h> */   /* Standard C string handling routines */
#include <ctype.h>     /* Standard C type identification routines */

int PtLinePerpIntercept();
double LineLength();

double PtLinePerpDistance(PtCol,
		      	     PtRow,
		            ColIntercept,
		            RowIntercept,
		            Theta)

 double PtCol;
 double PtRow;

 double ColIntercept;
 double RowIntercept;
 double Theta;

{

 double InterceptPtCol;
 double InterceptPtRow;

 double Distance;

#ifdef debug
          fprintf(stderr," Start of function PtLinePerpDistance \n");
#endif

/*
 Find the intercept point of perpendicular dropped onto the line

*/

   PtLinePerpIntercept(PtCol,
                       PtRow,
                       ColIntercept,
                       RowIntercept,
                       Theta,
                       &InterceptPtCol,
                       &InterceptPtRow); 


    Distance = LineLength(InterceptPtCol,InterceptPtRow,
			     PtCol,PtRow);
    return(Distance);

#ifdef debug
          fprintf(stderr," End of function PtLinePerpDistance \n");
#endif

}

