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

Name : EPtsToORTLine
Type : int
Written on   : 20-Nov-90     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/ORT/LPEG/src/MiscRoutines

==============================================================================

Input parameters    :
Following parameters are end points of lines. They could be line data produced
by the routine ReadHTLine

 StartCol	-- The column number of the start point of the line
 StartRow	-- The row number of the start point of the line
 EndCol	-- The column number of the end point of the line
 EndRow	-- The row number of the end point of the line

Output parameters   : 

 MidPoint_Col	-- The column number of the midpoint of the line
 MidPoint_Row	-- The row number of the midpoint of the line

 Length	-- Length of the line
 LengthParlVar-- The variance in direction  paral. to line direction 
 LengthPerpVar-- The variance in the direction perp. to line direction
 Theta		-- Orientation of the line in radians
 ThetaVar	-- The variance (empirical) of the line orientation 

Output result       : 

  0 = successful, 
 -1 = error, 

Called Functions:

 LineMidPoint
 LineLength
 LineLengthParlVar
 LineLengthPerpVar
 LineSegTheta
 LineSegThetaVar

Calling procedure:

 double StartCol;
 double StartRow;
 double EndCol;
 double EndRow;

 double MidPoint_Col;
 double MidPoint_Row;

 double Length;
 double LengthParlVar;
 double LengthPerpVar;
 double Theta;
 double ThetaVar;

 EPtsToORTLine( StartCol,
		  StartRow,
		  EndCol,
		  EndRow,
		  &MidPoint_Col,
		  &MidPoint_Row,
		  &Length,
		  &LengthParlVar,
		  &LengthPerpVar,
		  &Theta,
		  &ThetaVar)

Functionality: 

This function transforms line data represented by their end points 
to the ORT standard format for a line. The other parameters are computed 
from the end points of the line using the called functions (see above). 
Now the center of the image is used as the origin for the rows and columns. 
The orientation angle ranges from 0 to pi radians where pi/2 > theta > 0 
implies a +ve gradient, and pi > theta > pi/2 implies a -ve gradient. 
theta = pi/2 points along the y axis.

----------------------------------------------------------------------------*/

#include <stdio.h>     /* Standard C I/O library */
#include <math.h>      /* Standard C mathematics library */
#include <errno.h>     /* Standard C error handling routines */
/* #include <strings.h> */   /* Standard C string handling routines */
#include <ctype.h>     /* Standard C type identification routines */

#define PIBY2 1.570796

 int LineMidPoint();

 double LineLength();
 double LineLengthParlVar();
 double LineLengthPerpVar();
 double LineSegTheta();
 double LineSegThetaVar();

int EPtsToORTLine( StartCol,
		     StartRow,
		     EndCol,
		     EndRow,
		     MidPoint_Col,
		     MidPoint_Row,
		     Length,
		     LengthParlVar,
		     LengthPerpVar,
		     Theta,
		     ThetaVar)

 double StartCol;
 double StartRow;
 double EndCol;
 double EndRow;

 double *MidPoint_Col;
 double *MidPoint_Row;

 double *Length;
 double *LengthParlVar;
 double *LengthPerpVar;
 double *Theta;
 double *ThetaVar;

{

#ifdef debug
          fprintf(stderr," Start of function EPtsToORTLine \n");
#endif

/*
 First calculate the MidPoint of the line

*/

	if (LineMidPoint(StartCol,
                        StartRow,
                        EndCol,
                        EndRow,
                        MidPoint_Col,
                        MidPoint_Row) != 0)
       return(1);
/*
 Now calculate the length of the line. 

*/
	*Length = LineLength(StartCol,
                            StartRow,
			       EndCol,
                            EndRow);
/*
 Now calculate the parallel and perp. variances of the line. 

*/
	*LengthParlVar = LineLengthParlVar();
	*LengthPerpVar = LineLengthPerpVar();

/*
 Now calculate the orientation of the line

*/
	*Theta = LineSegTheta(StartCol,
			        StartRow,
			        EndCol,
			        EndRow);

/*
 Now calculate the variance of the orientation of the line

*/
	*ThetaVar = LineSegThetaVar(*Length);

         if ((float) *ThetaVar < PIBY2)
	       return(0);

	  return(-1);

#ifdef debug
          fprintf(stderr," End of function EPtsToORTLine \n");
#endif

}
