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

Name : IntersectionPt.c
Type : int
Written on   : 20-Apr-92     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/IPEG/src

==============================================================================

Input parameters    : 

 StartCol1,StartRow1	-- First Virtual Line endpoints
 EndCol1,EndRow1	

 StartCol2,StartRow2	-- Second Virtual Line endpoints
 EndCol2,EndRow2	

Output result       : 

-1  = Lines are parallel
 0  = Junction point exists and is not on either line segment,
 1  = Junction point exists and is on the first line segment  OR
      Junction point exists and is on the second line segment OR
      Junction point exists and is on both line segments

Called Functions :

 LineLength
 LineSegTheta
 LineSegRowIntercept
 CheckPtParlLineSeg

Functionality: 

This function computes the intercept point of 2 virtual lines and determines
the position of the intercept point relative to the virtual lines.

----------------------------------------------------------------------------*/

#include "FEX.h"
#include "LPEG.h"

int InterceptPt(StartCol1,StartRow1,
                EndCol1  ,EndRow1,
                StartCol2,StartRow2,
                EndCol2  ,EndRow2,
                JunctionPtCol,
                JunctionPtRow)
		
 double StartCol1,StartRow1;
 double EndCol1  ,EndRow1;
 double StartCol2,StartRow2;
 double EndCol2  ,EndRow2;

 double *JunctionPtCol;
 double *JunctionPtRow;

{

/* 
 Return status (see header) 
*/
 int Status;

/*
 Line parameters (y = m*x +c) these are c's for the two lines
*/

 double Line1RowIntercept;
 double Line2RowIntercept;

 double Theta1,Theta2;
 double Length1,Length2;

#ifdef debug
          fprintf(stderr," Start of function CheckJunctionType \n");
#endif

/*
 First compute all the line parameters required using the endpoints of the 
 lines.
*/


 Theta1 = LineSegTheta(StartCol1,StartRow1,
                       EndCol1  ,EndRow1);

 Theta2 = LineSegTheta(StartCol2,StartRow2,
                       EndCol2  ,EndRow2);

 Length1 = LineLength(StartCol1,StartRow1,
                      EndCol1  ,EndRow1);

 Length2 = LineLength(StartCol2,StartRow2,
                      EndCol2  ,EndRow2);

 LineSegRowIntercept(StartCol1,StartRow1,
		       EndCol1  ,EndRow1,
		       &Line1RowIntercept);

 LineSegRowIntercept(StartCol2,StartRow2,
		       EndCol2  ,EndRow2,
		       &Line2RowIntercept);

/*
 Check if Junction point exists. In the case of lines close in angle the
 junction point is too uncertain so forget it.
*/

 if ( fabs(Theta1 - Theta2) < 0.001 ||
      fabs(Theta1 - Theta2) > (PI - 0.001) ) {
     return(-1);
 }

/*
 Now if one of the lines is vertical, then its real easy to find the 
 Junction point.
*/

   if (MACCompareWithPIBY2(Theta1)) {	/* 1st line is vertical */
	*JunctionPtCol = StartCol1;		/* Find the Junction point */
       *JunctionPtRow = tan(Theta2)*StartCol1 + Line2RowIntercept;
   }

   if (MACCompareWithPIBY2(Theta2)) {	/* 2nd line is vertical */
	*JunctionPtCol = StartCol2;		/* Find the Junction point */
       *JunctionPtRow = tan(Theta1)*StartCol2 + Line1RowIntercept;
   }

/*
 Otherwise we have to really work it all out...
*/

   if (!MACCompareWithPIBY2(Theta1) && !MACCompareWithPIBY2(Theta2)) {
 	*JunctionPtCol = (Line2RowIntercept - Line1RowIntercept)/
			     (tan(Theta1) - tan(Theta2));
	*JunctionPtRow = tan(Theta1)*(*JunctionPtCol) + Line1RowIntercept;
   }

/*
 Now we check where the intercept point is relative to the two lines
 to set the flags for junction types.
*/

	if (CheckPtParlLineSeg(*JunctionPtCol,
                              *JunctionPtRow,
                               0.01,0.01,
                               Length1, Theta1,
                               StartCol1,StartRow1,
                               EndCol1  ,EndRow1) == 0 &&

	    CheckPtParlLineSeg(*JunctionPtCol,
                              *JunctionPtRow,
                               0.01,0.01,
                               Length2, Theta2,
                               StartCol2,StartRow2,
                               EndCol2  ,EndRow2) == 0) {
	    return(1);
       } else {
	    return(0);
	}

#ifdef debug
          fprintf(stderr," End of function CheckJunctionType \n");
#endif

}

