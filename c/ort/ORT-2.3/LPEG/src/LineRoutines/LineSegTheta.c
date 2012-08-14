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

Name : LineSegTheta
Type : double
Written on   : 20-Nov-90     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/ORT/LPEG/src/LineRoutines

==============================================================================

Input parameters    : 
Following parameters are end points of lines. They could be line data produced
by the routine ReadHTLine

 StartCol		-- The column number of the start point of the line
 StartRow		-- The row number of the start point of the line
 EndCol		-- The column number of the end point of the line
 EndRow		-- The row number of the end point of the line

Output result       : 

 Theta			-- Orientation of the line in radians (see below for more detail)

Calling procedure:

 double StartCol;
 double StartRow;
 double EndCol;
 double EndRow;

 Orientation = LineSegTheta(  StartCol,
				  StartRow,
				  EndCol,
                              EndRow)

Functionality: 

This function finds the orientation of a line given its end points.
Note: the center of the image is used as the origin for the rows and columns. 
The orientation angle ranges from 0 to pi radians where pi/2 => theta => 0  
implies a +ve gradient, and pi > theta > pi/2 implies a -ve gradient. 
pi/2 points along the y axis. There's no error checking ie overflow, 
underflow etc.. Want to include it yourself ?

----------------------------------------------------------------------------*/

#include <stdio.h>     /* Standard C I/O library */
#include <math.h>      /* Standard C mathematics library */
#include <errno.h>     /* Standard C error handling routines */
/* #include <strings.h> */   /* Standard C string handling routines */
#include <ctype.h>     /* Standard C type identification routines */

#define PI     3.141593
#define PIBY2  1.570796

double LineSegTheta(StartCol,
		     StartRow,
		     EndCol,
	            EndRow)

 double StartCol;
 double StartRow;
 double EndCol;
 double EndRow;

{

 double dx,dy; 			/* Buffers */

 double Orientation;

#ifdef debug
          fprintf(stderr," Start of function LineSegTheta \n");
#endif

  dx = EndCol - StartCol;
  dy = EndRow - StartRow;

  if (dx == 0.0) return(PIBY2); 	/* Line is vertical */
  if (dy == 0.0) return(0.0);     	/* Line is Horizontal */

  Orientation =  atan2( dy, dx );

/*
 Make it so line orientation is always between 0 and pi.

*/

  if (Orientation < 0.0 )
      Orientation = Orientation + PI;

  if (Orientation > PI)
      Orientation = Orientation - PI;

  return(Orientation);

#ifdef debug
          fprintf(stderr," End of function LineSegTheta \n");
#endif

}
