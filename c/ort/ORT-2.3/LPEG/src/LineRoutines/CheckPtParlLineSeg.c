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

Name :  CheckPtParlLineSeg
Type : int
Written on   : 20-Nov-90     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/ORT/LPEG/src/LineRoutines

==============================================================================

Input parameters    : 

 PtCol			-- Col pos. of point
 PtRow			-- Row pos. of point

 LengthParlVar	-- Variance of line parallel direction
 LengthPerpVar	-- Variance of line perp direction
 Length		-- Length of the line
 Theta			-- Orientation of the line
 StartCol            -- The column number of the start point of the line
 StartRow            -- The row number of the start point of the line
 EndCol         	-- The column number of the end point of the line
 EndRow         	-- The row number of the end point of the line


Output result       : 

-1 = point is not on the line segment
 0 = point is on the line segment

Called Functions :

Calling procedure:

 double PtCol;
 double PtRow;

 double LengthParlVar;
 double LengthPerpVar;
 double Line;
 double Theta;
 double StartCol;
 double StartRow;
 double EndCol;
 double EndRow;

      CheckPtParlLineSeg(  PtCol,
			      PtRow,
			      LengthParlVar,
			      LengthPerpVar,
			      Line,
			      Theta,
			      StartCol,
                           StartRow,
                           EndCol,
                           EndRow);

Functionality: 

This function finds whether a point is on a line segment or not. By "off the
line segment" we mean that the point is more than 1 LengthParlVar away from the
end points of the line 

			******** NOTE *********
Its is assumed that the point already lies on the line passing through both end
points of the line segment
			******** NOTE *********

----------------------------------------------------------------------------*/

#include <stdio.h>     /* Standard C I/O library */
#include <math.h>      /* Standard C mathematics library */
#include <errno.h>     /* Standard C error handling routines */
/* #include <strings.h> */   /* Standard C string handling routines */
#include <ctype.h>     /* Standard C type identification routines */

int  CheckPtParlLineSeg(PtCol,
			   PtRow,
			   LengthParlVar,
			   LengthPerpVar,
			   Length,
			   Theta,
			   StartCol,
                        StartRow,
                        EndCol,
                        EndRow)


 double PtCol;
 double PtRow;

 double LengthParlVar;
 double LengthPerpVar;
 double Length;
 double Theta;
 double StartCol;
 double StartRow;
 double EndCol;
 double EndRow;

{

 double DeltaCols; /* Amount by which end point cols. have to be changed */
 double DeltaRows; /* Amount by which end point rows. have to be changed */

 double Ecol,Erow; /* Buffers to hold end points of line Shorteneded by LengthParlVar */
 double Scol,Srow;

#ifdef debug
          fprintf(stderr," Start of function  CheckPtParlLineSeg \n");
#endif

/*
 Copy column lengths to buffers in case we need to change them, and set 
 defaults

*/

 Scol = StartCol; Ecol = EndCol; 
 Srow = StartRow; Erow = EndRow; 
 DeltaCols = 0.0; 
 DeltaRows = 0.0;

/* 
Now we have to change the end points by more than usual
to make it preceptually correct
*/

    if (Scol == Ecol) {  	 /* Line is vertical */
	 DeltaCols = 0.0; 
	 DeltaRows = - (LengthParlVar + LengthPerpVar);
    }

    if (Srow == Erow) {      /* Line is horizontal */ 
	 DeltaCols = - (LengthParlVar + LengthPerpVar); 
	 DeltaRows = 0.0;
    }

   if (Srow != Erow && Scol != Ecol) {
	 DeltaCols = - (LengthParlVar + LengthPerpVar) * cos(Theta);
	 DeltaRows = - (LengthParlVar + LengthPerpVar) * sin(Theta);
   }

/*
 Now change the line at both ends by the length implied by the variance.
 First make sure its not bothered if the start point is furthest away from the
 origin 

*/ 
	if (Scol > Ecol) {
	    Scol = Scol + DeltaCols;
	    Ecol = Ecol - DeltaCols;
	} else {
	    Scol = Scol - DeltaCols;
	    Ecol = Ecol + DeltaCols;
	}

	if (Srow > Erow) {
	    Srow = Srow + DeltaRows;
	    Erow = Erow - DeltaRows;
	} else {
	    Srow = Srow - DeltaRows;
	    Erow = Erow + DeltaRows;
	}

/*
 Now check where the point lies relative to the end points of the line
 The 0.00001 factors are because of BLOODY rounding errors
*/

         if ( ( (PtRow >= (Srow-0.00001) && PtRow <= (Erow+0.00001)) ||   
		  (PtRow <  (Srow+0.00001) && PtRow >  (Erow-0.00001)) ) && 
		( (PtCol >= (Scol-0.00001) && PtCol <= (Ecol+0.00001)) ||
		  (PtCol <  (Scol+0.00001) && PtCol >  (Ecol-0.00001)) ) ) {
	  		return(0);
	  		} else {
			return(-1);
	  }

#ifdef debug
          fprintf(stderr," End of function  CheckPtParlLineSeg \n");
#endif

}
