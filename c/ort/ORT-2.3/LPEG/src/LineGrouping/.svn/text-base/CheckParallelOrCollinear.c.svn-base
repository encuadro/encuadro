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

Name : CheckParallelOrCollinear
Type : int
Written on   : 15-Dec-90     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/ORT/LPEG/src/LineGrouping

==============================================================================

Input parameters    : 
 
 Line1 		-- ORT line structure containing data for 1st line
 Line2 		-- ORT line structure containing data for 1st line
 MinQuality		-- Min acceptable Quality level

Output parameters    : 

 VLLine			-- Virtual Line and associated parameters
 Quality		-- Quality level in the grouping

Output result       : 

 0  = Lines are // and non overlapping
 1  = Lines are // and overlapping
 2  = Lines are collinear
-1  = None of the above

Called Functions :

PtLinePerpIntercept
LineLength
LineSegColIntercept
LineSegRowIntercept

Calling procedure:

 struct ORTLine *Line1;
 struct ORTLine *Line2;
 struct VirtualLine *VLLine;

 double MinQuality;
 double WidthOverHeight;
 double Quality;

 CheckParallelOrCollinear(	Line1,
				Line2,
			       VLLine,
				MinQuality,
				&WidthOverHeight,
				&Quality);

Functionality: 

This function finds lines which are "Perceptually" parallel non-overlapping,
parallel overlapping and collinear. The Perceptual part comes from deciding the
difference between the luine angles. A Quality value is associated with the
lines. Please see below on how it is computed. Essentially it peanalises lines
that do not have significant overlaps with the virtual line.

----------------------------------------------------------------------------*/

#include "ListeMacros.h"
#include "Liste.h"
#include "FEX.h"
#include "LPEG.h"

int CheckParallelOrCollinear( Line1,
				  Line2,
				  VLLine,
				  MinQuality,
				  WidthOverHeight,
			         Quality)

 struct ORTLine *Line1;
 struct ORTLine *Line2;
 struct VirtualLine *VLLine;

 double MinQuality;
 double *WidthOverHeight;
 double *Quality;

{

 int i,imax;		/* Dummy variables */

 int Status;		/* Return Status */

 double VLPtCol; 	   /* The initial point through which the VL passes */
 double VLPtRow;  	   /* and is used for collinearity check */

 double VLColIntercept; /* Column intercept of VL */
 double VLRowIntercept; /* Row intercept of VL */

 double Theta1,Theta2;

/* 
 The following are intercept points of the perps. dropped from the line
 segments onto the virtual line, and buffers for manipulating them.

*/

 double Line1StartInterceptCol;
 double Line1StartInterceptRow;
 double Line1EndInterceptCol;
 double Line1EndInterceptRow;

 double Line2StartInterceptCol;
 double Line2StartInterceptRow;
 double Line2EndInterceptCol;
 double Line2EndInterceptRow;

/*
 Lenghts of the projections of the lines onto the Virtual Line
*/

 double Line1ProjectedLength;
 double Line2ProjectedLength;

/* 
 Dummy vars. to store distances 
*/

 double D[5],Dmax;	

/*
 The following are the row and col intercept of the two lines used for
 collinearity check, and the distance from the VL initial point to the two
 lines

*/

 double Line1ColIntercept;
 double Line1RowIntercept;
 double Line2ColIntercept;
 double Line2RowIntercept;

 double d1,d2;

/*
 Some buffers to speed things up a bit
*/

 double SumLength;
 double Grad;

#ifdef debug
          fprintf(stderr," Start of function CheckParallelOrCollinear \n");
#endif


/*
 Find the point through which the virtual line passes weighted by the line 
 lengths. These values will also be used later to check collinearity.

*/

*WidthOverHeight = 0.0;
SumLength = (Line1->Length) + (Line2->Length);

VLPtCol = (  ((Line1->MidPoint.Col)  * (Line1->Length)) + 
	      ((Line2->MidPoint.Col)  * (Line2->Length)) ) /
	       SumLength;

VLPtRow = ( ((Line1->MidPoint.Row)  * (Line1->Length)) + 
	     ((Line2->MidPoint.Row)  * (Line2->Length)) ) /
	       SumLength;

/*
 Find the mean orientation of the virtual line weighted by the 
 line lengths, (could also inversely weight by the theta variances)

*/

 Theta1 = Line1->Theta; Theta2 = Line2->Theta;
 if (fabs(Theta1 - Theta2) > PIBY2) {
     if (Theta1 > PIBY2)
         Theta1 = PI-Theta1; 
     if (Theta2 > PIBY2)
         Theta2 = PI-Theta2; 
 }

	VLLine->Theta =  ( ( (Theta1)*(Line1->Length) ) + 
		            ( (Theta2)*(Line2->Length) ) ) / SumLength;

if ( (float)(VLLine->Theta) > PI)
      VLLine->Theta = (VLLine->Theta) - PI;

if ( (VLLine->Theta) < 0.0)
      VLLine->Theta = (VLLine->Theta) + PI;
/*
 Find other parameters associated with the virtual line

*/

if ( (VLLine->Theta) < 0.001) { 		/* If VL is horizontal */
    VLRowIntercept = VLPtRow;
}

if (MACCompareWithPIBY2(VLLine->Theta))		/* If VL is vertical */
    VLColIntercept = VLPtCol;

/* So we have to work things out */
if ( !MACCompareWithPIBY2(VLLine->Theta) && (VLLine->Theta) >= 0.001) {	
    Grad = tan(VLLine->Theta);
    VLRowIntercept = VLPtRow -  ( Grad * VLPtCol );
    VLColIntercept = -VLRowIntercept/Grad;

}

/*
Find intercept point between perp. dropped from the end points of the first
line onto the virtual line

*/

    PtLinePerpIntercept(Line1->Start.Col,
             	          Line1->Start.Row,
                        VLColIntercept,
                        VLRowIntercept,
                        VLLine->Theta,
                        &Line1StartInterceptCol,
                        &Line1StartInterceptRow);

    PtLinePerpIntercept(Line1->End.Col,
                        Line1->End.Row,
                        VLColIntercept,
                        VLRowIntercept,
                        VLLine->Theta,
                        &Line1EndInterceptCol,
                        &Line1EndInterceptRow);

/*
Find intercept point between perp. dropped from the end points of the second
line onto the virtual line

*/
    PtLinePerpIntercept(Line2->Start.Col,
             	          Line2->Start.Row,
                        VLColIntercept,
                        VLRowIntercept,
                        VLLine->Theta,
                        &Line2StartInterceptCol,
                        &Line2StartInterceptRow);

    PtLinePerpIntercept(Line2->End.Col,
                        Line2->End.Row,
                        VLColIntercept,
                        VLRowIntercept,
                        VLLine->Theta,
                        &Line2EndInterceptCol,
                        &Line2EndInterceptRow);

/*
 Now find the longest distance between the intercept points of the perps
 dropped from the two line segments onto the virtual line. 

*/
   D[1] = LineLength(Line1StartInterceptCol,Line1StartInterceptRow,
                     Line2StartInterceptCol,Line2StartInterceptRow);

   D[2] = LineLength(Line1StartInterceptCol,Line1StartInterceptRow,
                     Line2EndInterceptCol,Line2EndInterceptRow);

   D[3] = LineLength(Line1EndInterceptCol,Line1EndInterceptRow,
                     Line2StartInterceptCol,Line2StartInterceptRow);

   D[4] = LineLength(Line1EndInterceptCol,Line1EndInterceptRow,
                     Line2EndInterceptCol,Line2EndInterceptRow);

   imax = 1;
   Dmax = D[1];   
   for (i=2 ;i<=4; i++) {
       if (D[i] > Dmax) {
           Dmax = D[i];
           imax = i;
       }
   }

  switch (imax) {
     case 1: 
       VLLine->Start.Col = Line1StartInterceptCol;
	VLLine->Start.Row = Line1StartInterceptRow;
	VLLine->End.Col   = Line2StartInterceptCol;
	VLLine->End.Row   = Line2StartInterceptRow;
       break;
     case 2: 
       VLLine->Start.Col = Line1StartInterceptCol;
	VLLine->Start.Row = Line1StartInterceptRow;
	VLLine->End.Col   = Line2EndInterceptCol;
	VLLine->End.Row   = Line2EndInterceptRow;
       break;
     case 3: 
       VLLine->Start.Col = Line1EndInterceptCol;
	VLLine->Start.Row = Line1EndInterceptRow;
	VLLine->End.Col   = Line2StartInterceptCol;
	VLLine->End.Row   = Line2StartInterceptRow;
       break;
     case 4: 
       VLLine->Start.Col = Line1EndInterceptCol;
	VLLine->Start.Row = Line1EndInterceptRow;
	VLLine->End.Col   = Line2EndInterceptCol;
	VLLine->End.Row   = Line2EndInterceptRow;
       break;

	}

/*
 Based on these points we can now compute the Length of the Virtual line which
 is also the length of the Overlap

*/

   VLLine->Length = LineLength((VLLine->Start.Col),
			          (VLLine->Start.Row),
			          (VLLine->End.Col),
			          (VLLine->End.Row));

/*
 Now if there is a significant overlap then the lines are parallel overlapping.
 Otherwise we have to check to see if they are collinear or non-overlapping
 parallel 

*/

    Line1ProjectedLength = LineLength(Line1StartInterceptCol,
		                        Line1StartInterceptRow,
                        		   Line1EndInterceptCol,
                        		   Line1EndInterceptRow);

    Line2ProjectedLength = LineLength(Line2StartInterceptCol,
		                        Line2StartInterceptRow,
                        		   Line2EndInterceptCol,
                        		   Line2EndInterceptRow);


 if ( (VLLine->Length) <= (Line1ProjectedLength + Line2ProjectedLength - 
		      (Line1->LengthParlVar + Line2->LengthParlVar)
      ) ) { 	/* Significant overlap */

	Status = 1;
/*
 Compute the ratio of the width to the height for parallel lines
*/
 LineSegColIntercept(Line2->Start.Col,
                     Line2->Start.Row,
                     Line2->End.Col,
                     Line2->End.Row,
                    &Line2ColIntercept);

 LineSegRowIntercept(Line2->Start.Col,
                     Line2->Start.Row,
                     Line2->End.Col,
                     Line2->End.Row,
                    &Line2RowIntercept);

       *WidthOverHeight = PtLinePerpDistance(Line1->MidPoint.Col,
						   Line1->MidPoint.Row,  
                          			   Line2ColIntercept,
                          			   Line2RowIntercept,
                          			   Line2->Theta)/
	                         (VLLine->Length);

 } else {  	/* No significant overlap */

/*
 So now we check if the lines are collinear or non-overlapping parallel
 based on how far the VL Col and Row are from the line segments. We first
 compute some required parameters, and then we check the VLPtCol etc..

*/

 LineSegColIntercept(Line1->Start.Col,
                     Line1->Start.Row,
                     Line1->End.Col,
                     Line1->End.Row,
                    &Line1ColIntercept);

 LineSegColIntercept(Line2->Start.Col,
                     Line2->Start.Row,
                     Line2->End.Col,
                     Line2->End.Row,
                    &Line2ColIntercept);

 LineSegRowIntercept(Line1->Start.Col,
                     Line1->Start.Row,
                     Line1->End.Col,
                     Line1->End.Row,
                    &Line1RowIntercept);

 LineSegRowIntercept(Line2->Start.Col,
                     Line2->Start.Row,
                     Line2->End.Col,
                     Line2->End.Row,
                    &Line2RowIntercept);

  d1 = PtLinePerpDistance(VLPtCol,
                          VLPtRow,
                          Line1ColIntercept,
                          Line1RowIntercept,
                          Line1->Theta);

  d2 = PtLinePerpDistance(VLPtCol,
                          VLPtRow,
                          Line2ColIntercept,
                          Line2RowIntercept,
                          Line2->Theta);

	if (d1 < Line1->LengthPerpVar && d2 < Line2->LengthPerpVar) {
		Status = 2;
	} else {
	Status = 0;
/*
 Compute the ratio of the width to the height for parallel lines
*/
 LineSegColIntercept(Line2->Start.Col,
                     Line2->Start.Row,
                     Line2->End.Col,
                     Line2->End.Row,
                    &Line2ColIntercept);

 LineSegRowIntercept(Line2->Start.Col,
                     Line2->Start.Row,
                     Line2->End.Col,
                     Line2->End.Row,
                    &Line2RowIntercept);

       *WidthOverHeight = PtLinePerpDistance(Line1->MidPoint.Col,
						   Line1->MidPoint.Row,  
                          			   Line2ColIntercept,
                          			   Line2RowIntercept,
                          			   Line2->Theta)/
	                         (VLLine->Length);

	}

}

/*
 Now we compute the Quality level. We use the projected lengths to avoid the
 Quality factor going over 1.0.
*/

 if (Status == 1) {
	   *Quality = (Line1ProjectedLength + Line2ProjectedLength)/
		       (2.0*VLLine->Length);
 } else {

/* 
 The lines are parallel and non-overlapping collinear. In this case the 
 confidence level is based on the ratio of the part of the VL which overlaps
 with the lines and the length of the VL
*/
	   *Quality = (Line1ProjectedLength + Line2ProjectedLength)/
		                         VLLine->Length;

 }

/*
 No minimum quality for collinear lines
*/

          if ( (*Quality) < MinQuality)
		  return(-1);

          if ( (*Quality) > 1.0) {
		 (*Quality) = 1.0;
#ifdef GiveWarning
         	fprintf(stderr,"CheckParallelOrCollinear:\n");
              fprintf(stderr,"Status %d : Quality factor %lf for Lines %d, %d exceeds 1.0 \n",
		Status,(*Quality),Line1->ID,Line2->ID);
#endif
          }

          if (Status == 0 ||  Status == 1 || Status == 2) {
	   	return(Status);
          } else {
              return(-1);
	   }

#ifdef debug
          fprintf(stderr," End of function CheckParallelOrCollinear \n");
#endif

}
