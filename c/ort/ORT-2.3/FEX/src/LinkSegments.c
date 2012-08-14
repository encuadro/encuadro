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

Name : LinkSegments
Type : int
Written on   : 8-Mar-91     By : A. Etemadi
Modified on  : 31-May-91    By : A.Etemadi 
		 Fixed problem with joining curves which were antiparallel
		 like in the letter S.
Directory    : ~atae/ORT/ORT/FEX/src

==============================================================================

Input parameters    : 

StringListSize	 -- Length, in pixels, of the string
StringListID		 -- ID number of the linked list
StringList		 -- Linked list of pixels making up the string

SegmentListSize	 -- Number of segments in the list
SegmentListID		 -- ID number of the linked list of segments
	SegmentList		 -- Linked list of segments found along the string

Output parameters    : 

List of segments which have been linked together as far as possible

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

 LinkSegments(StringListSize,
              StringListID,
              StringList,
		&SegmentListSize,
              &SegmentListID,
              &SegmentList);

Functionality: 


----------------------------------------------------------------------------*/
#include "ListeMacros.h"
#include "Liste.h"
#include "FEX.h"
#include "LPEG.h"

#define MaxDisparity 1.4142137

int LinkSegments(StringListSize,
	          StringListID,
		   StringList,
		   SegmentListSize,
	          SegmentListID,
		   SegmentList)

 int StringListSize;
 int *SegmentListSize;

 Liste StringListID;
 Liste *SegmentListID;

 struct ORTPoint *StringList;
 struct ORTSegment *(*SegmentList);

{

 int i;		/* Dummy variables */
 int JoinSegments;

 int OldSegmentID;
 int NewSegmentID;
 int OldNoOfSegments;
 int NewNoOfSegments;
 int OldSegmentCurvature;
 int NewSegmentCurvature;

 struct ORTSegment *OldSegment;
 struct ORTSegment *NewSegment;

 double OldSegmentTheta;
 double NewSegmentTheta;
 double OldGrad;
 double NewGrad;

 double JunctionPtCol;
 double JunctionPtRow;
 double InitJctCol;
 double InitJctRow;
 double Radius;

 double OldMidLength;
 double NewMidLength;
 double OldEndLength;
 double NewEndLength;
 double OldStartLength;
 double NewStartLength;

 double StringRow[MAXPOINT];
 double StringCol[MAXPOINT];

 double VLColIntercept;
 double VLRowIntercept;

 double OldHeight;
 double NewHeight;
 double OldEndHeight;

 int Length;
 double NewStartHeight;
 double Height;
 double Row,Col;
 double VLTheta;
 double MidPtCol;
 double MidPtRow;

 int LinkedSegmentLength;
 Liste LinkedSegmentListID;
 Liste BufferListID;
 struct ORTSegment *LinkedSegment;

#ifdef debug
          fprintf(stderr," Start of function LinkSegments \n");
#endif

/*
 String is too small to process
*/

 if (StringListSize < 3)
	return(-1);
/*
 Only one segment so no point linking it..
*/
 if ((*SegmentListSize) == 1)
	return(0);

 LinkedSegmentListID = CreatList();
/*
 Store string data in array
*/

 for (i=1;i<=StringListSize;i++) {
  StringList = MACCast(ORTPoint, (ElmNumList(StringListID,(long)i)) );
  StringRow[i] = StringList->Row;
  StringCol[i] = StringList->Col;
 }

/*
 Initialise variables
*/
	OldNoOfSegments = (*SegmentListSize);
	NewNoOfSegments = 2;
	OldSegmentID = 1;
	NewSegmentID = 2;
/*
 Loop until we can't link any more segments together
*/
 while (NewNoOfSegments < OldNoOfSegments &&
        NewNoOfSegments > 1 && OldNoOfSegments > 1) {
/*
 Loop until we've joined all segments we could in this pass
*/
   while (NewSegmentID <= (*SegmentListSize) && 
          (*SegmentListSize) > 1) {

/*
 Find the junction point (if any) between lines passing through the VL point
 and the midpoint of the segment, which should be perpendicular to the segment.
 This will 
	a) give us an idea of the relative curvature of the two segments 
	b) allow us to check if the two segments are co-curvilinear.
*/
	OldSegment = MACCast(ORTSegment, 
		      (ElmNumList( (*SegmentListID),(long)OldSegmentID)) );

	NewSegment = MACCast(ORTSegment, 
		      (ElmNumList( (*SegmentListID),(long)NewSegmentID)) );

/*
 First find the orientation of the lines joining the midpoint to the VL point.
 by rotating the VL by PIBY2. 
*/

		OldSegmentTheta = (OldSegment->VLTheta) + PIBY2;
		if (OldSegmentTheta > PI)
		    OldSegmentTheta = OldSegmentTheta - PI;

		NewSegmentTheta = (NewSegment->VLTheta) + PIBY2;
		if (NewSegmentTheta > PI)
		    NewSegmentTheta = NewSegmentTheta - PI;
/*
 Now we got the orientations of the perps to the segments we can find the
 junction point. We check first though to see if the segments are not collinear.
*/

 JoinSegments = 1;

/*
 Find the junction point
*/

	OldGrad = tan(OldSegmentTheta);
	NewGrad = tan(NewSegmentTheta);

  	if (fabs(OldSegmentTheta - NewSegmentTheta) < 0.001) {
		JunctionPtCol = HUGE;
		JunctionPtRow = HUGE;

	} else {

	InitJctCol = JunctionPtCol = ( (NewSegment->MidPoint.Row) -
			    (OldSegment->MidPoint.Row) - 
			    (NewGrad * (NewSegment->MidPoint.Col)) +
			    (OldGrad * (OldSegment->MidPoint.Col)) ) /
			    (OldGrad - NewGrad);

	InitJctRow = JunctionPtRow = (OldSegment->MidPoint.Row) + 
	 (OldGrad * (JunctionPtCol - (OldSegment->MidPoint.Col)));

       Radius   = LineLength(JunctionPtCol,JunctionPtRow,
			        StringCol[OldSegment->StringEnd],
			        StringRow[OldSegment->StringEnd]);

       if ( CircleLeastSq(StringCol,StringRow,
			     OldSegment->StringStart,
			     NewSegment->StringEnd,
			     &JunctionPtCol,&JunctionPtRow,&Radius) != 0) {
        JunctionPtCol = InitJctCol;
        JunctionPtRow = InitJctRow;
	}

	}
/*
 Find the heights associated with the segments
*/
	OldHeight = LineLength(OldSegment->VLPoint.Col,
			  	  OldSegment->VLPoint.Row,
			  	  OldSegment->MidPoint.Col,
			  	  OldSegment->MidPoint.Row);

	NewHeight = LineLength(NewSegment->VLPoint.Col,
			  	  NewSegment->VLPoint.Row,
			  	  NewSegment->MidPoint.Col,
			  	  NewSegment->MidPoint.Row);

/*
 Now find the curvatures of the segments relative to the junction point
*/

	OldMidLength =  LineLength(JunctionPtCol,
			  	      JunctionPtRow,
			  	      OldSegment->MidPoint.Col,
			  	      OldSegment->MidPoint.Row);

	NewMidLength =  LineLength(JunctionPtCol,
			  	      JunctionPtRow,
			  	      NewSegment->MidPoint.Col,
			  	      NewSegment->MidPoint.Row);

	OldEndLength =  LineLength(JunctionPtCol,
			  	      JunctionPtRow,
			  	      OldSegment->End.Col,
			  	      OldSegment->End.Row);

	NewEndLength =  LineLength(JunctionPtCol,
			  	      JunctionPtRow,
			  	      NewSegment->End.Col,
			  	      NewSegment->End.Row);

	OldStartLength =  LineLength(JunctionPtCol,
			  	        JunctionPtRow,
			  	        OldSegment->Start.Col,
			  	        OldSegment->Start.Row);

	NewStartLength =  LineLength(JunctionPtCol,
			  	        JunctionPtRow,
			  	        NewSegment->Start.Col,
			  	        NewSegment->Start.Row);
	 if ( OldMidLength >
	      LineLength(JunctionPtCol,
			   JunctionPtRow,
			   OldSegment->VLPoint.Col,
			   OldSegment->VLPoint.Row) ||
            OldHeight <= MaxDisparity) {
	     OldSegmentCurvature = 0;
	 } else {
	     OldSegmentCurvature = 1;
	 }

	 if ( NewMidLength >
	      LineLength(JunctionPtCol,
			   JunctionPtRow,
			   NewSegment->VLPoint.Col,
			   NewSegment->VLPoint.Row) ||
            NewHeight <= MaxDisparity) {
	     NewSegmentCurvature = 0;
	 } else {
	     NewSegmentCurvature = 1;
	 }

/*
 Check if segments are co-curvilinear and if so join them. The criterion is:

	1. They have same curvature which is not infinity (HUGE)
	2. The end point of the old segment is 3 pixels or less away from
	   the start point of the new segment
	3. The difference between any pair of the distances between
	   the points along the suspected curve and the center of curvature 
	   of the combined segments is less than MaxDisparity
*/

	if (( NewSegmentCurvature == OldSegmentCurvature &&
         abs(OldSegment->StringEnd - NewSegment->StringStart) <= 3 &&
	      fabs(OldMidLength - NewMidLength)   <= MaxDisparity &&
	      fabs(OldMidLength - NewStartLength) <= MaxDisparity &&
	      fabs(OldMidLength - NewEndLength)   <= MaxDisparity &&
	      fabs(OldMidLength - OldEndLength)   <= MaxDisparity &&
	      fabs(OldMidLength - OldStartLength) <= MaxDisparity &&
	      fabs(NewMidLength - NewStartLength) <= MaxDisparity &&
	      fabs(NewMidLength - NewEndLength)   <= MaxDisparity &&
	      fabs(NewMidLength - OldEndLength)   <= MaxDisparity &&
	      fabs(NewMidLength - OldStartLength) <= MaxDisparity) )
		JoinSegments = 0;
/*
 Check if the segments are collinear, and if so join them. The criterion is :

	1. The end point of the old segment is 2 pixels or less away from
	   the start point of the new segment
	2. They have the same curvature
	3. The joined segment is linear ie the heights of perps. dropped
	   onto the line joining the endpts of the joined segment is less 
	   than 2.0 (otherwise they'll be classified as curves)
*/

       LineSegColIntercept( OldSegment->Start.Col,
                            OldSegment->Start.Row,
                            NewSegment->End.Col,
                            NewSegment->End.Row,
                           &VLColIntercept);

       LineSegRowIntercept( OldSegment->Start.Col,
                            OldSegment->Start.Row,
                            NewSegment->End.Col,
                            NewSegment->End.Row,
                           &VLRowIntercept);

       VLTheta = LineSegTheta(OldSegment->Start.Col,
       			  OldSegment->Start.Row,
       			  NewSegment->End.Col,
       			  NewSegment->End.Row);

       PtLinePerpIntercept(OldSegment->End.Col,
                           OldSegment->End.Row,
                           VLColIntercept,
                           VLRowIntercept,
                           VLTheta,
                          &Col,&Row);

	OldEndHeight = LineLength(Col,Row,
			  	     OldSegment->End.Col,
			  	     OldSegment->End.Row);

       PtLinePerpIntercept(NewSegment->Start.Col,
			      NewSegment->Start.Row,
                           VLColIntercept,
                           VLRowIntercept,
                           VLTheta,
                          &Col,&Row);

	NewStartHeight = LineLength(Col,Row,
			  	     NewSegment->Start.Col,
			  	     NewSegment->Start.Row);

	Length = NewSegment->StringEnd - OldSegment->StringStart + 1;

       MidPtCol = 
	( StringCol[OldSegment->StringStart + (int)(Length/2)] +
         StringCol[NewSegment->StringEnd   - (int)(Length/2)])/2.0;

       MidPtRow = 
	( StringRow[OldSegment->StringStart + (int)(Length/2)] +
         StringRow[NewSegment->StringEnd   - (int)(Length/2)])/2.0;

       PtLinePerpIntercept(MidPtCol,
			      MidPtRow,
                           VLColIntercept,
                           VLRowIntercept,
                           VLTheta,
                          &Col,&Row);

	Height = LineLength(Col,Row,
			      MidPtCol,
			      MidPtRow);

	  if ( abs(OldSegment->StringEnd - NewSegment->StringStart) <= 3 &&
		NewSegmentCurvature == OldSegmentCurvature &&
		Height         < 2.0 &&
		OldEndHeight   < 2.0 &&
		NewStartHeight < 2.0)
		JoinSegments = 0;

/*
 If everything is OK then delete the segments from the List and replace them 
 with one segment
*/

	if (JoinSegments == 0) {

	       LinkedSegment = MACAllocateMem(ORTSegment);

		LinkedSegment->StringStart = OldSegment->StringStart;
		LinkedSegment->StringEnd   = NewSegment->StringEnd;
		LinkedSegment->Start.Col   = OldSegment->Start.Col;
		LinkedSegment->Start.Row   = OldSegment->Start.Row;
		LinkedSegment->End.Col     = NewSegment->End.Col;
		LinkedSegment->End.Row     = NewSegment->End.Row;

	LinkedSegmentLength = LinkedSegment->StringEnd - 
				 LinkedSegment->StringStart + 1;

       LinkedSegment->MidPoint.Col = 
	( StringCol[LinkedSegment->StringStart + (int)(LinkedSegmentLength/2)] +
         StringCol[LinkedSegment->StringEnd   - (int)(LinkedSegmentLength/2)])/2.0;

       LinkedSegment->MidPoint.Row = 
	( StringRow[LinkedSegment->StringStart + (int)(LinkedSegmentLength/2)] +
	  StringRow[LinkedSegment->StringEnd   - (int)(LinkedSegmentLength/2)])/2.0;

/*
 Compute the virtual line parameters
*/
       LineSegColIntercept( LinkedSegment->Start.Col,
                            LinkedSegment->Start.Row,
                            LinkedSegment->End.Col,
                            LinkedSegment->End.Row,
                           &VLColIntercept);

       LineSegRowIntercept( LinkedSegment->Start.Col,
                            LinkedSegment->Start.Row,
                            LinkedSegment->End.Col,
                            LinkedSegment->End.Row,
                           &VLRowIntercept);

       LinkedSegment->VLTheta = LineSegTheta(LinkedSegment->Start.Col,
       			  		   LinkedSegment->Start.Row,
       			  		   LinkedSegment->End.Col,
       			  		   LinkedSegment->End.Row);

       PtLinePerpIntercept(LinkedSegment->MidPoint.Col,
                           LinkedSegment->MidPoint.Row,
                           VLColIntercept,
                           VLRowIntercept,
                           LinkedSegment->VLTheta,
                          &LinkedSegment->VLPoint.Col,
                          &LinkedSegment->VLPoint.Row);

	   Height = LineLength(LinkedSegment->VLPoint.Col,
			  	  LinkedSegment->VLPoint.Row,
			  	  LinkedSegment->MidPoint.Col,
			  	  LinkedSegment->MidPoint.Row);

/*
 This is to get over problems with determining the center of
 complete circle, since the estimate of the center turn out to
 be infinity in this case
*/

	 InitJctCol = JunctionPtCol = (LinkedSegment->VLPoint.Col +  
		           		   LinkedSegment->MidPoint.Col)/2.0;
	 InitJctRow = JunctionPtRow = (LinkedSegment->VLPoint.Row +  
		           		   LinkedSegment->MidPoint.Row)/2.0;

       Radius   = LineLength(JunctionPtCol,JunctionPtRow,
				 LinkedSegment->MidPoint.Col,
				 LinkedSegment->MidPoint.Row);

       if ( CircleLeastSq(StringCol,StringRow,
			     LinkedSegment->StringStart,
			     LinkedSegment->StringEnd,
			     &JunctionPtCol,&JunctionPtRow,&Radius) != 0) {
        JunctionPtCol = HUGE;
        JunctionPtRow = HUGE;
	}

		 LinkedSegment->JctPoint.Col = JunctionPtCol;
		 LinkedSegment->JctPoint.Row = JunctionPtRow;
/*
 This is a botch to get around the fact that the Liste library adds elements to
 the end of a list and not where you want them. What I do is essentially 
 recreate the list and replaced the two linked segments by one segment. 
*/
	if (EmptyList(LinkedSegmentListID) != 1)
		DestList(&LinkedSegmentListID);

		LinkedSegmentListID = CreatList();

	for (i = 1 ; i < OldSegmentID ; i++) {
	     NewSegment = MACCast(ORTSegment, 
		      (ElmNumList( (*SegmentListID),(long)i)) );
	     AddElmList( LinkedSegmentListID, (long) NewSegment );
	}

      	     AddElmList( LinkedSegmentListID, (long) LinkedSegment );

	for (i = (NewSegmentID + 1) ; i <= (*SegmentListSize) ; i++) {
	     NewSegment = MACCast(ORTSegment, 
		      (ElmNumList( (*SegmentListID),(long)i)) );
	     AddElmList( LinkedSegmentListID, (long) NewSegment );
	}

	BufferListID = CopyList(LinkedSegmentListID);
	(*SegmentListSize) = (int) SizeList(BufferListID);
	NewNoOfSegments = (*SegmentListSize);
	(*SegmentListID) = BufferListID;
	(*SegmentList)   = LinkedSegment;

	OldSegmentID = 1;
	NewSegmentID = 2;

    } else {

	OldSegmentID = NewSegmentID;
	NewSegmentID = NewSegmentID + 1;

    }

  } /* while there are still segments pairs to join */

	 OldNoOfSegments = NewNoOfSegments;
	 OldSegmentID = 1;
	 NewSegmentID = 2;

 } /* while the list is still shrinking */
	return(0);

#ifdef debug
          fprintf(stderr," End of function LinkSegments \n");
#endif

}
