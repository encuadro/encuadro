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

Name : LPEG.h
Type : header file
Written on   : 14-Nov-90     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/ORT/LPEG/inc

All Constants are in uppercase. 
All Macro names start with the letters MAC

The Quality factor which appears in the groupings reflects the amount of
information available about the grouping. In the case of overlapping parallel
and V/L junction line pairs the quality factor is defined by:

	Line1->Length/LengthOfOverlapWithVirtualLine *
	Line2->Length/LengthOfOverlapWithVirtualLine 

In the case of non-overlapping parallel/collinear the factor is:

 	Line1->Length + Line2->Length/
       LengthOfOverlapWithVirtualLine

In the case of T and Lambda junctions the factor is: 

	Line(i)->Length/LengthOfOverlapWithVirtualLine

Where Line(i) is the line segment which does not go thorough the junction 
point. The end points of the Virtual line in these cases are the junction point
and the end point of Line(i) furthest away from the junction point.

----------------------------------------------------------------------------*/

/* 
 				CONSTANTS
*/ 

#ifndef PI
#define PI     3.141593
#endif

#ifndef PIBY2
#define PIBY2  1.570796
#endif

#ifndef HUGE
#define HUGE 9999999.0
#endif

/*
				MACROS
*/

/* Cast variables into required form */
#define MACCast(a,b) ( (struct a *) b )

#include <stdlib.h>
/* Allocate memory for a structure */
#define MACAllocateMem(a)  (struct a *) malloc(sizeof(struct a));

/* Compare with PIBY2 with a little leaway to avoid infinities */
#define MACCompareWithPIBY2(a) (a > (PIBY2-0.001) && a < (PIBY2+0.001) )

/* 
 				TYPES
*/ 

/*
 A Virtual line used in the definition of grouped features
*/
  struct VirtualLine {
	struct ORTPoint Start;	/* Start point of the line */
	struct ORTPoint End;	  	/* End point of the line */
	double	Length;		/* Length of the line in pixels */
	double	Theta;		  	/* Orientation of the line pi < Theta <= 0 */
  };

/* 
 A pair of overlapping parallel lines

*/

  struct ORTParallelOV {  		
	int 	  FirstID;  		/* ID number associated with the 1st line */
	int 	  SecondID;  		/* ID number associated with the 2nd line */
       struct VirtualLine VLLine;  /* Associated Virtual line parameters */
	double	  WidthOverHeight; 	/* Ratio of width to height */
	double	  Quality; 		/* Quality of overlapping parallelism */
  };

/* 
 A pair of non-overlapping parallel lines

*/

  struct ORTParallelNOV {  		
	int 	  FirstID;  		/* ID number associated with the 1st line */
	int 	  SecondID;  		/* ID number associated with the 2nd line */
       struct VirtualLine VLLine;  /* Associated Virtual line parameters */
	double	  WidthOverHeight; 	/* Ratio of width to height */
	double	  Quality; 		/* Quality of non-overlapping parallelism */
  };

/* 
 A pair of collinear lines

*/

  struct ORTCollinear {  		
	int 	  FirstID;  		/* ID number associated with the 1st line */
	int 	  SecondID;  		/* ID number associated with the 2nd line */
       struct VirtualLine VLLine;  /* Associated Virtual line parameters */
	double	  Quality; 		/* Quality of collinearity */
  };

/*
 A pair of lines forming an L junction.

*/

  struct ORTLJunction {  		
	int 	  FirstID;  		/* ID number associated with the 1st line */
	int 	  SecondID;  		/* ID number associated with the 2nd line */
       int 	  ip;			/* ip=0 junction pt not on either line */
       				/* ip=3 junction pt on both lines */
       int 	  jp1;			/* jp=0 junction pt is closest to StartCol,StartRow of line 1*/
					/* jp=1 junction pt is closest to EndCol,EndRow of line 1 */
	int 	  jp2;			/* jp=0 junction pt is closest to StartCol,StartRow of line 2 */
					/* jp=1 junction pt is closest to EndCol,EndRow of line 2 */
       struct ORTPoint JunctionPt; /* Junction point */
	double	  Quality; 		/* Quality of L junction */
  };

/* 
 A pair of lines forming a V junction. 

*/

  struct ORTVJunction {  		
	int 	  FirstID;  		/* ID number associated with the 1st line */
	int 	  SecondID;  		/* ID number associated with the 2nd line */
       int 	  ip;			/* ip=0 junction pt not on either line */
       				/* ip=3 junction pt on both lines */
       int 	  jp1;			/* jp=0 junction pt is closest to StartCol,StartRow of line 1*/
					/* jp=1 junction pt is closest to EndCol,EndRow of line 1 */
	int 	  jp2;			/* jp=0 junction pt is closest to StartCol,StartRow of line 2 */
					/* jp=1 junction pt is closest to EndCol,EndRow of line 2 */
       struct ORTPoint JunctionPt; /* Junction point */
	double	  Quality; 		/* Quality in of V junction */
  };

/* 
 A pair of lines forming a T junction. 

*/

  struct ORTTJunction {  		
	int 	  FirstID;  		/* ID number associated with the 1st line */
	int 	  SecondID;  		/* ID number associated with the 2nd line */
       int 	  ip;			/* ip=1 junction pt on 1st line */
       				/* ip=2 junction pt on 2nd line */
       				/* ip=3 junction pt on both lines */
       int 	  jp1;			/* jp=0 junction pt is closest to StartCol,StartRow of line 1*/
					/* jp=1 junction pt is closest to EndCol,EndRow of line 1 */
	int 	  jp2;			/* jp=0 junction pt is closest to StartCol,StartRow of line 2 */
					/* jp=1 junction pt is closest to EndCol,EndRow of line 2 */
       struct ORTPoint JunctionPt; /* Junction point */
	double	  Quality; 		/* Quality of T junction */
  };

/* 
 A pair of lines forming a Lambda junction.

*/

  struct ORTLambdaJunction {  	
	int 	  FirstID;  		/* ID number associated with the 1st line */
	int 	  SecondID;  		/* ID number associated with the 2nd line */
       int 	  ip;			/* ip=1 junction pt on 1st line */
       				/* ip=2 junction pt on 2nd line */
       				/* ip=3 junction pt on both lines */
       int 	  jp1;			/* jp=0 junction pt is closest to StartCol,StartRow of line 1*/
					/* jp=1 junction pt is closest to EndCol,EndRow of line 1 */
	int 	  jp2;			/* jp=0 junction pt is closest to StartCol,StartRow of line 2 */
					/* jp=1 junction pt is closest to EndCol,EndRow of line 2 */
       struct ORTPoint JunctionPt; /* Junction point */
	double	  Quality; 		/* Quality of Lambda junction */
  };

/* 
 				FUNCTIONS

*/ 

/*--------   LineRoutines   --------*/

int CheckPtParlLineSeg();
int LineSegColIntercept();
int LineSegRowIntercept();
int LineMidPoint();
int LineSegGradient();
int PtLinePerpIntercept();

double LineLength();
double LineLengthParlVar();
double LineLengthPerpVar();
double LineSegTheta();
double LineSegThetaVar();
double PtLinePerpDistance();

/*--------   ListRoutines   --------*/

int CrtORTLineList();
long SortByThetaAscending();

/*-------- GroupingRoutines --------*/

int CheckParallelOrCollinear();
int CheckJunctionType();

/*--------   MiscRoutines   --------*/

int OpenInFile();
int OpenOutFile();
int ReadHTLine();
int ReadORTLine();
int EPtsToORTLine();
int EPtsToORTLineOut();
int SkipLines();
