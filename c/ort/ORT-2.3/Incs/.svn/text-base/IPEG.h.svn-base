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

Name : IPEG.h
Type : header file
Written on   : 26-Apr-92     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/Incs

All Constants are in uppercase. 
All Macro names start with the letters MAC

----------------------------------------------------------------------------*/
/*
 Constants
*/
#define MAXTRIPLETS 12          /* The max. number of sides of
                                   polygon is MAXTRIPLETS - 4 */
#define MAXSEGMENTS 3*MAXTRIPLETS

#define MAXBRANCHES 10000      /* This is the maximum number of search branches
                                 points allowed for a given polygon hypothesis */
/*
 Triplet
*/

  struct ORTTriplet {
       int    ID;			/* ID number associated with triplet */
       int    *SegmentID;		/* IDs of lines forming triplet */
	struct ORTPoint *Junction;  /* The junctions along the triplet */
	struct ORTPoint Start;      /* Start point of the triplet */
	struct ORTPoint End;		/* End point of the triplet */
	double Length;		/* Total length of segments */
	double VirtualLength;	/* Total length of triplet inc. gaps */
	double Quality;		/* Associated quality factor */

  };

/*
 Corner
*/

  struct ORTCorner {
	int    ID;		/* ID number associated with corner */
       int    *SegmentID;	/* ID numbers of lines forming corner */
	double Radius;	/* Radius of circle enclosing junction point */
	double Quality; 	/* EXP(-(Radius/Mean_Length_Of_Lines)) */
	struct ORTPoint Center;	/* Center of circle enclosing junction point */
  };

/* 
 Open Polygon

*/

  struct ORTOpenPolygon {
	int    Start;
	int    Middle;
	int    End;
       int    NumID;				/* Number of triplets forming open polygon */
       int    TripletID[MAXTRIPLETS+1];   /* ID numbers of triplets forming open polygon */
  };

/* 
 Closed Polygon

*/

  struct ORTClosedPolygon {
       int    NumSeg;	/* Number of segments forming closed polygon */
       int    NumJct;	/* Number of junctions forming closed polygon */
       int    SegmentID[MAXSEGMENTS+1];   	/* ID numbers of segments forming closed polygon */
       struct ORTPoint JunctionPt[MAXSEGMENTS+1];/* Junction points along the polygon */
	double Quality;
  };

/* 
 				FUNCTIONS

*/ 
long SortByIDVLJunctions();
long SortCornersByQuality();
long SortTripletsByID();
long SortPolygonsByNumSeg();
int  CreateLPEGLists();
int  InterceptPt();

