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

Name : FEX.h
Type : header file
Written on   : 5-Mar-90     By : A. Etemadi
Modified on  :              By : 
Directory    : ~atae/ORT/ORT/FEX/inc

All Constants are in uppercase. 
All Macro names start with the letters MAC

----------------------------------------------------------------------------*/

/*
                           	INCLUDES
*/

#include <stdio.h>     /* Standard C I/O library */
#include <math.h>      /* Standard C mathematics library */
#include <errno.h>     /* Standard C error handling routines */
#include <ctype.h>     /* Standard C type identification routines */

/*
				CONSTANTS
*/

#define MAXPOINT 10000

/* 
 				TYPES
*/ 

/* 
 A ORT point. 0,0 is the center of the image, and +x, and +y are rightward, and
upward.

*/

  struct ORTPoint {  		
     double Col,Row;			/* Position of the point */ 
  };

/*
 A Segment
*/

 struct ORTSegment {
   int    StringStart;        /* Start of segment along string */
   int    StringEnd;          /* End of segment along string */
   struct ORTPoint Start;     /* Start point of the segment */
   struct ORTPoint End;       /* End point of the segment */
   struct ORTPoint MidPoint;  /* Midpoint of the segment */
   struct ORTPoint VLPoint;   /* Midpoint of the line joining end points */
   struct ORTPoint JctPoint;  /* Junction point signifying center of curvature */
   double VLTheta;         	  /* Orientation of line joining end points */
  };

/* 
  A ORT line. 0,0 is the center of the image, and +x, and +y are rightward, and
upward. Theta = 0, and 180 are along the x axis, Theta = 90 is along the y axis. 

*/

  struct ORTLine {
		int 	  ID;	  	/* ID number associated with the line */
		int 	  StringID;	/* ID of String from which the line was extracted*/
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
 Circular Arcs
*/

 struct ORTCircularArc {
	 int 	 ID;			/* ID number associated with circular arc */
        int 	 StringID;		/* ID number of the String the arc came from */
        int 	 Direction;		/* -1 clockwise, 1 anti-clockwise */
	 struct ORTPoint Origin;	/* Origin of the circular arc */ 
	 struct ORTPoint Start;	/* Start point of the arc */
	 struct ORTPoint End;	/* End point of the arc */
	 struct ORTPoint MidPoint;	/* Midpoint of the arc */
	 struct ORTPoint VLPoint;	/* Midpoint of line joining end points */
	 double Radius; 		/* Radius of the arc in pixels */
	 double Length; 		/* Length of the arc in pixels */
	 double LengthParlVar; 	/* Variance in the length of the arc in the // direction */
	 double LengthPerpVar;  	/* Variance in the length of the arc in the perp. direction */
	 double Width;		/* Distance between the end points of the arc */
	 double Height; 		/* Distance between midpoint of the arc and line joining its end points */
	 double Theta; 		/* Orientation of line joining origin to midpoint */
 };
/* 
 				FUNCTIONS

*/ 

int CircleLeastSq();
int LineLeastSq();
int ReadRawImageData();
int CreateStringList();
int LinkSegments();
int StringToSegments();
int DrawBezierLine();
int DrawCircularArc();
