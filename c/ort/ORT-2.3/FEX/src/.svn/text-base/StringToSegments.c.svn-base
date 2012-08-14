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

Name : StringToSegments
Type : int
Written on   : 8-Mar-90     By : A. Etemadi
Modified on  :              By : 
Directory    : ~atae/ORT/ORT/FEX/src

==============================================================================

Input parameters    : 

StringListSize	-- Length, in pixels, of the string
StringListID		-- ID number of the linked list
StringList		-- Linked list of pixels making up the string

Output parameters    : 

SegmentListSize	-- Number of segments in the list
SegmentListID		-- ID number of the linked list of segments
SegmentList		-- Linked list of segments found along the string

Output result       : 

 0  = OK
 -1 = Error

Called Functions :



Calling procedure:

 int StringListSize;
 int SegmentListSize;

 Liste StringListID;
 Liste SegmentListID;

 struct ORTPoint *StringList;
 struct ORTSegment *SegmentList;

 StringToSegments(StringListSize,
                  StringListID,
                  StringList,
		   &SegmentListSize,
                 &SegmentListID,
                 &SegmentList);

Functionality: 

This function extracts symmetric segments, using the "Strider" algorithm as 
explained in ../TeX/IHaven'tWrittenItYet.tex, from the string and stores them 
in a linked list. 

----------------------------------------------------------------------------*/
#include "ListeMacros.h"
#include "Liste.h"
#include "FEX.h"
#include "LPEG.h"

#define MinSegmentLength 3

int StringToSegments(MaxJumpPixels,
			StringListSize,
	             	StringListID,
			StringList,
			SegmentListSize,
	             	SegmentListID,
			SegmentList)

 int StringListSize;
 int MaxJumpPixels;
 int *SegmentListSize;

 Liste StringListID;
 Liste *SegmentListID;

 struct ORTPoint *StringList;
 struct ORTSegment *(*SegmentList);

{

 int i;		/* Dummy variables */
 int StartPosition;
 int EndPosition;
 int FoundSegment;
 int AsymmetryFlag;
 int Step;

 double StringRow[10000];
 double StringCol[10000];

 double BodyCol;
 double BodyRow;
 double StartCol;
 double StartRow;
 double EndCol;
 double EndRow;

 double LeftArmLength;
 double RightArmLength;
 double Length;

 double LeftArmTheta;
 double RightArmTheta;
 double LeftArmGrad;
 double RightArmGrad;
 double LeftArmCol;
 double LeftArmRow;
 double RightArmCol;
 double RightArmRow;
 double JctPtCol;
 double JctPtRow;
 double InitJctCol;
 double InitJctRow;
 double Radius;
 double CRight;
 double CLeft;

 double VLColIntercept;
 double VLRowIntercept;
 double VLPtCol;
 double VLPtRow;
 double VLTheta;

 double OldTotalArmLength;
 double CurrentTotalArmLength;
 double SegmentLength;

 double Disparity;

#ifdef debug
          fprintf(stderr," Start of function StringToSegments \n");
#endif
/*
 String is too small to process
*/

 if (StringListSize < 3)
	return(-1);

/*
 Create linked list to put segments in
*/
 *SegmentListID = CreatList();
 *SegmentListSize = 0;

/*
 Store string data in array
*/

 for (i=1;i<=StringListSize;i++) {
  StringList = MACCast(ORTPoint, (ElmNumList(StringListID,(long)i)) );
  StringRow[i] = StringList->Row;
  StringCol[i] = StringList->Col;
 }

/* 
Can start anywhere along the Segment as long as the position is more than 
1 pixel from end points. This point will be treated as an end point. Since 
we set the min Segmentlength to 3 we start at the 2nd pixel along.
*/

    StartPosition = 1; 
    EndPosition = 3; 
    AsymmetryFlag = 0; 
    FoundSegment = 0;
    LeftArmTheta = 0.0;
    RightArmTheta = 0.0;
    CurrentTotalArmLength = 0.0;
    OldTotalArmLength = 0.0;

/*
 Loop until the whole Segment is processed or we have only 2 pixel bits left
*/

 while ( EndPosition <= StringListSize) {

    Step = 0;
    while (FoundSegment == 0 ) {

/*
 Now use the end points of the line segments forming the arms, and the position
 of the body to find the the virtual line parameters
*/
    LineSegColIntercept( StringCol[StartPosition],
                         StringRow[StartPosition],
                         StringCol[EndPosition],
                         StringRow[EndPosition],
                        &VLColIntercept);

    LineSegRowIntercept( StringCol[StartPosition],
                         StringRow[StartPosition],
                         StringCol[EndPosition],
                         StringRow[EndPosition],
                        &VLRowIntercept);

    VLTheta = LineSegTheta(StringCol[StartPosition],
	    		      StringRow[StartPosition],
		    	      StringCol[EndPosition],
			      StringRow[EndPosition]);

    BodyCol = (StringCol[StartPosition + (Step/2)] +
               StringCol[EndPosition - (Step/2)])/2.0;
    BodyRow = (StringRow[StartPosition + (Step/2)] +
               StringRow[EndPosition - (Step/2)])/2.0;

    PtLinePerpIntercept(BodyCol,
                        BodyRow,
                        VLColIntercept,
                        VLRowIntercept,
                        VLTheta,
                       &VLPtCol,
                       &VLPtRow);
/*
 Find if we are roughly symmetric by comparing arm lengths (could compare diff.
in Heights of arms below intercept point)
*/

    LeftArmLength  = LineLength(VLPtCol,VLPtRow,
			          StringCol[StartPosition],
			          StringRow[StartPosition]);

    RightArmLength = LineLength(VLPtCol,VLPtRow,
			          StringCol[EndPosition],
			          StringRow[EndPosition]);

    CurrentTotalArmLength = LeftArmLength + RightArmLength;

    Length = (double)(EndPosition - StartPosition + 1);
    Disparity =(sqrt(2.0)/(sqrt(Length*Length+1.0)));

   if ( fabs(RightArmLength - LeftArmLength) >= Disparity ||
        CurrentTotalArmLength < OldTotalArmLength) {
        AsymmetryFlag++;
   } else {
     	 AsymmetryFlag = 0;
   }

    OldTotalArmLength = CurrentTotalArmLength;
/*
 If still near-symmetric move body by one position, and extend the arms 
*/

     if (AsymmetryFlag > MaxJumpPixels || EndPosition == StringListSize) {
         EndPosition = EndPosition - AsymmetryFlag;
 	  FoundSegment = 1; 
     } else {
     EndPosition++;
     Step++;
     }
    } /* While segment not found */

/*
 If we reached an end point then stop, store the result and continue
*/
    SegmentLength = EndPosition - StartPosition + 1;
    if (SegmentLength > 2) {

    if (AsymmetryFlag == 0) {

       BodyCol = ( StringCol[StartPosition + (int)(SegmentLength/2)] +
		     StringCol[EndPosition   - (int)(SegmentLength/2)] )/2.0;
       BodyRow = ( StringRow[StartPosition + (int)(SegmentLength/2)] +
		     StringRow[EndPosition   - (int)(SegmentLength/2)] )/2.0;

	StartCol = StringCol[StartPosition];
	StartRow = StringRow[StartPosition];
	EndCol   = StringCol[EndPosition];
	EndRow   = StringRow[EndPosition];
/*
 Compute the virtual line parameters
*/

       LineSegColIntercept( StartCol,
                            StartRow,
                            EndCol,
                            EndRow,
                           &VLColIntercept);

       LineSegRowIntercept( StartCol,
                            StartRow,
                            EndCol,
                            EndRow,
                           &VLRowIntercept);

       VLTheta = LineSegTheta(StartCol,
       			  StartRow,
       			  EndCol,
       			  EndRow);

       PtLinePerpIntercept(BodyCol,
                           BodyRow,
                           VLColIntercept,
                           VLRowIntercept,
                           VLTheta,
                          &VLPtCol,
                          &VLPtRow);

/*
 Now find the rough position of the center of curvature
*/

      LeftArmTheta  = LineSegTheta(StartCol,
	                            StartRow,
                                   BodyCol,
                                   BodyRow);

      RightArmTheta = LineSegTheta(EndCol,
	                            EndRow,
                                   BodyCol,
                                   BodyRow);

      LeftArmCol  = (StartCol + BodyCol)/2.0;
      LeftArmRow  = (StartRow + BodyRow)/2.0;
      RightArmCol = (EndCol + BodyCol)/2.0;
      RightArmRow = (EndRow + BodyRow)/2.0;

	RightArmTheta = RightArmTheta + PIBY2;
	if (RightArmTheta > PI)
	    RightArmTheta = RightArmTheta - PI;

	LeftArmTheta  = LeftArmTheta + PIBY2;
	if (LeftArmTheta > PI)
	    LeftArmTheta = LeftArmTheta - PI;

      RightArmGrad = tan(RightArmTheta);
      LeftArmGrad  = tan(LeftArmTheta);

      CRight = RightArmRow - RightArmGrad*RightArmCol;
      CLeft  = LeftArmRow  - LeftArmGrad*LeftArmCol;

    if (fabs(LeftArmTheta - RightArmTheta) < 0.001) {
         JctPtCol = HUGE;
         JctPtRow = HUGE;
     } else {

     if (MACCompareWithPIBY2(LeftArmTheta)) {
         InitJctCol = JctPtCol = LeftArmCol;
         InitJctRow = JctPtRow = RightArmGrad*LeftArmCol + CRight;
         Radius   = LineLength(JctPtCol,JctPtRow,
		      StringCol[(int)((EndPosition - StartPosition)/2)],
		      StringRow[(int)((EndPosition - StartPosition)/2)]);

         if ( CircleLeastSq(StringCol,StringRow,
		    	       StartPosition,EndPosition,
			       &JctPtCol,&JctPtRow,&Radius) != 0) {
        JctPtCol = InitJctCol;
        JctPtRow = InitJctRow;
	 }

     }

     if (MACCompareWithPIBY2(RightArmTheta)) {
         InitJctCol = JctPtCol = RightArmCol;
         InitJctRow = JctPtRow = LeftArmGrad*RightArmCol + CLeft;

         Radius   = LineLength(JctPtCol,JctPtRow,
		      StringCol[(int)((EndPosition - StartPosition)/2)],
		      StringRow[(int)((EndPosition - StartPosition)/2)]);

         if ( CircleLeastSq(StringCol,StringRow,
		    	       StartPosition,EndPosition,
			       &JctPtCol,&JctPtRow,&Radius) != 0) {
        JctPtCol = InitJctCol;
        JctPtRow = InitJctRow;
	 }

     }

    if (!MACCompareWithPIBY2(RightArmTheta) && 
        !MACCompareWithPIBY2(LeftArmTheta)) {
         InitJctCol = JctPtCol = (CRight - CLeft)/(LeftArmGrad - RightArmGrad);
         InitJctRow = JctPtRow = RightArmGrad*JctPtCol + CRight;
         Radius   = LineLength(JctPtCol,JctPtRow,
		      StringCol[(int)((EndPosition - StartPosition)/2)],
		      StringRow[(int)((EndPosition - StartPosition)/2)]);

         if ( CircleLeastSq(StringCol,StringRow,
		    	       StartPosition,EndPosition,
			       &JctPtCol,&JctPtRow,&Radius) != 0) {
        JctPtCol = InitJctCol;
        JctPtRow = InitJctRow;
	 }
    }
   }
/*
Allocate memory for the segment
*/

	      *SegmentList = MACAllocateMem(ORTSegment);

	      (*SegmentList)->StringStart  = StartPosition;
	      (*SegmentList)->StringEnd    = EndPosition;
	      (*SegmentList)->Start.Col    = StartCol;
	      (*SegmentList)->Start.Row    = StartRow;
	      (*SegmentList)->End.Col      = EndCol;
	      (*SegmentList)->End.Row	= EndRow;
	      (*SegmentList)->MidPoint.Col = BodyCol;
	      (*SegmentList)->MidPoint.Row = BodyRow;
	      (*SegmentList)->JctPoint.Col = JctPtCol;
	      (*SegmentList)->JctPoint.Row = JctPtRow;
	      (*SegmentList)->VLPoint.Col  = VLPtCol;
	      (*SegmentList)->VLPoint.Row  = VLPtRow;
	      (*SegmentList)->VLTheta      = VLTheta;
/*
 Add element to list
*/

             AddElmList( *SegmentListID, (long)*SegmentList );
             (*SegmentListSize)++;
   } else {

       BodyCol = ( StringCol[StartPosition + (int)(SegmentLength/2)] + 
		     StringCol[EndPosition   - (int)(SegmentLength/2)] )/2.0;
       BodyRow = ( StringRow[StartPosition + (int)(SegmentLength/2)] +
		     StringRow[EndPosition   - (int)(SegmentLength/2)] )/2.0;

	StartCol = StringCol[StartPosition];
	StartRow = StringRow[StartPosition];
	EndCol   = StringCol[EndPosition];
	EndRow   = StringRow[EndPosition];
/*
 Compute the virtual line parameters
*/

       LineSegColIntercept( StartCol,
                            StartRow,
                            EndCol,
                            EndRow,
                           &VLColIntercept);

       LineSegRowIntercept( StartCol,
                            StartRow,
                            EndCol,
                            EndRow,
                           &VLRowIntercept);

       VLTheta = LineSegTheta(StartCol,
       			  StartRow,
       			  EndCol,
       			  EndRow);

       PtLinePerpIntercept(BodyCol,
                           BodyRow,
                           VLColIntercept,
                           VLRowIntercept,
                           VLTheta,
                          &VLPtCol,
                          &VLPtRow);
/*
 Now find the rough position of the center of curvature
*/

      LeftArmTheta  = LineSegTheta(StartCol,
	                            StartRow,
                                   BodyCol,
                                   BodyRow);

      RightArmTheta = LineSegTheta(EndCol,
	                            EndRow,
                                   BodyCol,
                                   BodyRow);

      LeftArmCol  = (StartCol + BodyCol)/2.0;
      RightArmCol = (EndCol + BodyCol)/2.0;
      LeftArmRow  = (StartRow + BodyRow)/2.0;
      RightArmRow = (EndRow + BodyRow)/2.0;

		RightArmTheta = RightArmTheta + PIBY2;
		if (RightArmTheta > PI)
		    RightArmTheta = RightArmTheta - PI;

		LeftArmTheta = LeftArmTheta + PIBY2;
		if (LeftArmTheta > PI)
		    LeftArmTheta = LeftArmTheta - PI;

      RightArmGrad = tan(RightArmTheta);
      LeftArmGrad  = tan(LeftArmTheta);

      CRight = RightArmRow - RightArmGrad*RightArmCol;
      CLeft  = LeftArmRow  - LeftArmGrad*LeftArmCol;

    if (fabs(LeftArmTheta - RightArmTheta) < 0.001) {
         JctPtCol = HUGE;
         JctPtRow = HUGE;
     } else {

     if (MACCompareWithPIBY2(LeftArmTheta)) {
         InitJctCol = JctPtCol = LeftArmCol;
         InitJctRow = JctPtRow = RightArmGrad*LeftArmCol + CRight;
         Radius   = LineLength(JctPtCol,JctPtRow,
		      StringCol[(int)((EndPosition - StartPosition)/2)],
		      StringRow[(int)((EndPosition - StartPosition)/2)]);

         if ( CircleLeastSq(StringCol,StringRow,
		    	       StartPosition,EndPosition,
			       &JctPtCol,&JctPtRow,&Radius) != 0) {
        JctPtCol = InitJctCol;
        JctPtRow = InitJctRow;
	 }
     }

     if (MACCompareWithPIBY2(RightArmTheta)) {
         InitJctCol = JctPtCol = RightArmCol;
         InitJctRow = JctPtRow = LeftArmGrad*RightArmCol + CLeft;
         Radius   = LineLength(JctPtCol,JctPtRow,
		      StringCol[(int)((EndPosition - StartPosition)/2)],
		      StringRow[(int)((EndPosition - StartPosition)/2)]);

         if ( CircleLeastSq(StringCol,StringRow,
		    	       StartPosition,EndPosition,
			       &JctPtCol,&JctPtRow,&Radius) != 0) {
        JctPtCol = InitJctCol;
        JctPtRow = InitJctRow;
	 }

     }

    if (!MACCompareWithPIBY2(RightArmTheta) && 
        !MACCompareWithPIBY2(LeftArmTheta)) {
         InitJctCol = JctPtCol = (CRight - CLeft)/(LeftArmGrad - RightArmGrad);
         InitJctRow = JctPtRow = RightArmGrad*JctPtCol + CRight;
         Radius   = LineLength(JctPtCol,JctPtRow,
		      StringCol[(int)((EndPosition - StartPosition)/2)],
		      StringRow[(int)((EndPosition - StartPosition)/2)]);

         if ( CircleLeastSq(StringCol,StringRow,
		    	       StartPosition,EndPosition,
			       &JctPtCol,&JctPtRow,&Radius) != 0) {
        JctPtCol = InitJctCol;
        JctPtRow = InitJctRow;
	 }
    }
   }
/*
Allocate memory for the segment
*/

	      *SegmentList = MACAllocateMem(ORTSegment);

	      (*SegmentList)->StringStart  = StartPosition;
	      (*SegmentList)->StringEnd    = EndPosition;
	      (*SegmentList)->Start.Col    = StartCol;
	      (*SegmentList)->Start.Row    = StartRow;
	      (*SegmentList)->End.Col      = EndCol;
	      (*SegmentList)->End.Row	= EndRow;
	      (*SegmentList)->MidPoint.Col = BodyCol;
	      (*SegmentList)->MidPoint.Row = BodyRow;
	      (*SegmentList)->JctPoint.Col = JctPtCol;
	      (*SegmentList)->JctPoint.Row = JctPtRow;
	      (*SegmentList)->VLPoint.Col  = VLPtCol;
	      (*SegmentList)->VLPoint.Row  = VLPtRow;
	      (*SegmentList)->VLTheta      = VLTheta;
/*
 Add element to list
*/
             AddElmList( *SegmentListID, (long)*SegmentList );
             (*SegmentListSize)++;

   } /* depending on asymmetry make correction and add segment to the list */
 }
       StartPosition = EndPosition + 1;
       EndPosition = StartPosition + 2;
    	OldTotalArmLength = 0.0;
    	CurrentTotalArmLength = 0.0;
       AsymmetryFlag = 0;
       FoundSegment = 0;

} /* while the string is not completely processed */

   if ((*SegmentListSize) > 0) {
	return(0);
   } else {
	return(-1);
   }	
#ifdef debug
          fprintf(stderr," End of function StringToSegments \n");
#endif

}
