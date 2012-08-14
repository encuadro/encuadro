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

Name : CPEG.h
Type : header file
Written on   : 14-July-91    By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/ORT/Incs

All Constants are in uppercase. 
All Macro names start with the letters MAC

----------------------------------------------------------------------------*/

/* 
 				TYPES
*/ 

/* 
  A ORT line. 0,0 is the center of the image, and +x, and +y are rightward, and
upward. Theta = 0, and 180 are along the x axis, Theta = 90 is along the y axis. 

*/

  struct ORTCurve {
		int 	  ID;	  	/* ID number associated with the line */
		int 	  RC;	  	/* Recency of the line */
	struct ORTPoint Start;	/* Start point of the line */
	struct ORTPoint End;	  	/* End point of the line */
	struct ORTPoint MidPoint; 	/* Midpoint of the line */
	double	Length;		/* Length of the line in pixels */
	double	LengthParlVar;	/* Variance in the length of the line */
					/* parallel to the direction of the line (empirical) */
	double	LengthPerpVar;	/* Variance in the length of the line */
					/* perpendicular to the direction of the line (empirical) */
	double	Theta;		  	/* Orientation of the line pi < Theta <= 0 */
	double	ThetaVar;		/* Variance in the line orientation (empirical) */
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

