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

Name : CheckJunctionType
Type : int
Written on   : 20-Nov-90     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/LPEG/src/LineGrouping

==============================================================================

Input parameters    : 

 Line1			-- First ORT line segment
 Line2			-- Second ORT line segment

Output parameters    : 

 jp1			-- Flag indicating which end point of line1 the
			   junction point is nearest to
 jp2			-- Flag indicating which end point of line2 the
			   junction point is nearest to

 0 = Junction point is nearest start point of line
 1 = Junction point is nearest end point of line

Where start point and end point are defined by Start.Col, and End.Col

 JunctionPtCol	-- Junction point params
 JunctionPtRow	--

 MinQuality		-- Min. acceptable Quality
 Quality		-- Quality in the junction type

Output result       : 

-1  = Quality is 0 since position of Junction point is highly uncertain
 0  = Junction point exists and is not on either line segment,
 1  = Junction point exists and is on the first line segment
 2  = Junction point exists and is on the second line segment
 3  = Junction point exists and is on both line segments
 4  = Junction point exists and is very close to the end points of the lines

Called Functions :

 LineSegRowIntercept
 CheckPtParlLineSeg

Calling procedure:

 int jp1;
 int jp2;

 struct ORTLine Line1;
 struct ORTLine Line2;

 double JunctionPtCol;
 double JunctionPtRow;

 double MinQuality;
 double Quality;

 CheckJunctionType(Line1,
		     Line2,
		     &jp1,
		     &jp2,
		     &JunctionPtCol,
		     &JunctionPtRow,
		     MinQuality,
		     &Quality);

Functionality: 

This function computes the intercept point of 2 lines. The lines are extensions
of two ORT line segments. The function returns a different value depending on 
where the intercept point is relative to the lines (see Output result section 
for details). Whether a point is on the line or not is computed using
the function CheckPtParlLineSeg so please look there so you undertand what the
output results really mean. We assign a Quality factor based on how far the
intercept point is from the end points of the lines closet to the junction
point. In The case of T and Lambda junctions this distance is computed using
the line on which the junction point does NOT lie.

----------------------------------------------------------------------------*/

#include "ListeMacros.h"
#include "Liste.h"
#include "FEX.h"
#include "LPEG.h"

int CheckJunctionType(Line1,
		        Line2,
			 jp1,
			 jp2,
			 JunctionPtCol,
			 JunctionPtRow,
		        MinQuality,
		        Quality)

 int *jp1;
 int *jp2;

 struct ORTLine *Line1;
 struct ORTLine *Line2;

 double *JunctionPtCol;
 double *JunctionPtRow;

 double MinQuality;
 double *Quality;


{

/* 
 Return status (see above) 

*/
 int Status;

/*
 Line parameters (y = m*x +c) these are c's for Line1 and 2

*/

 double Line1RowIntercept;
 double Line2RowIntercept;

/*
 Buffers

*/

 int iflag1,iflag2;

 double ECol1,ECol2,ERow1,ERow2;
 double Col1,Col2,Row1,Row2,Dmax; /* Dummay variables for checking Lambda junctions */
 double dtheta;

#ifdef debug
          fprintf(stderr," Start of function CheckJunctionType \n");
#endif

/*
 Check if Junction point exists. In the case of lines close in angle the
 junction point is too uncertain so forget it.

*/

 if ( fabs(Line1->Theta - Line2->Theta) < 0.001 ||
      fabs(Line1->Theta - Line2->Theta) > (PI - 0.001) ) {
     *Quality = 0.0;
     return(-1);
 }

/*
 Check to make sure the position of the Junction point is not ambiguous
 due to variances.
*/

     dtheta = fabs(Line1->Theta - Line2->Theta);
 if (dtheta > PIBY2)		/* Acute angle is what we want */
     dtheta = PI - dtheta;

 if (dtheta <= (Line1->ThetaVar + Line2->ThetaVar) && 
               (Line1->ThetaVar + Line2->ThetaVar) != 0.0) {
     *Quality = 0.0;
     return(-1);
 }

/*
 First calculate the row intercepts of the lines.

*/

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

/*
 Now if one of the lines is vertical, then its real easy to find the 
 Junction point.

*/

   if (MACCompareWithPIBY2(Line1->Theta)) {	/* 1st line is vertical */
	*JunctionPtCol = Line1->Start.Col;		/* Find the Junction point */
       *JunctionPtRow = tan(Line2->Theta)*Line1->Start.Col + Line2RowIntercept;
   }

   if (MACCompareWithPIBY2(Line2->Theta)) {	/* 2nd line is vertical */
	*JunctionPtCol = Line2->Start.Col;		/* Find the Junction point */
       *JunctionPtRow = tan(Line1->Theta)*Line2->Start.Col + Line1RowIntercept;
   }

/*
 Otherwise we have to really work it all out...

*/

   if (!MACCompareWithPIBY2(Line1->Theta) && 
	!MACCompareWithPIBY2(Line2->Theta)) {
 	*JunctionPtCol = (Line2RowIntercept - Line1RowIntercept)/
			     (tan(Line1->Theta) - tan(Line2->Theta));
	*JunctionPtRow = tan(Line1->Theta)*(*JunctionPtCol) + Line1RowIntercept;
   }
/*
 Now we check where the intercept point is relative to the two lines
 to set the flags for junction types. Note that we use the perp variance of the
 second lines as this is the param. that shifts the junction point along the
 first line.
*/

	iflag1 = CheckPtParlLineSeg( *JunctionPtCol,
                                    *JunctionPtRow,
                                    Line1->LengthParlVar,
                                    Line2->LengthPerpVar,
                                    Line1->Length,
                                    Line1->Theta,
                                    Line1->Start.Col,
                                    Line1->Start.Row,
                                    Line1->End.Col,
                                    Line1->End.Row);

	iflag2 = CheckPtParlLineSeg( *JunctionPtCol,
                                    *JunctionPtRow,
                                    Line2->LengthParlVar,
                                    Line1->LengthPerpVar,
                                    Line2->Length,
                                    Line2->Theta,
                                    Line2->Start.Col,
                                    Line2->Start.Row,
                                    Line2->End.Col,
                                    Line2->End.Row);

	if (iflag1 != 0 && iflag2 != 0)
	    Status = 0;

	if (iflag1 == 0 && iflag2 != 0)
	    Status = 1;

	if (iflag1 != 0 && iflag2 == 0)
	    Status = 2;

	if (iflag1 == 0 && iflag2 == 0)
	    Status = 3;

/*
 Now the remaining end points of the VLs are the ones of the above intercept 
 points which are furthest away from the junction point. This is true for V 
 and  L junctions, but for T and Lambda junctions there is only one virtual 
 line. The end points are also marked with the jp parameter which indicates
 which end point is the one closest to the junction point. This is very useful
 when we want to make larger sets.
*/

   if (LineLength(Line1->Start.Col,Line1->Start.Row,
	          *JunctionPtCol,*JunctionPtRow) >
	LineLength(Line1->End.Col,Line1->End.Row,
	          *JunctionPtCol,*JunctionPtRow) ) {
       *jp1 = 1;  /* Don't forget this means the Start is FURTHEST away from Junction */
       Col1 = Line1->End.Col;
       Row1 = Line1->End.Row;
       ECol1 = Line1->Start.Col;
       ERow1 = Line1->Start.Row;
    } else {
       *jp1 = 0;
       Col1 = Line1->Start.Col;
       Row1 = Line1->Start.Row;
       ECol1 = Line1->End.Col;
       ERow1 = Line1->End.Row;
    }

   if (LineLength(Line2->Start.Col,Line2->Start.Row,
	          *JunctionPtCol,*JunctionPtRow) >
	LineLength(Line2->End.Col,Line2->End.Row,
	          *JunctionPtCol,*JunctionPtRow) ) {
       *jp2 = 1;
       Col2 = Line2->End.Col;
       Row2 = Line2->End.Row;
       ECol2 = Line2->Start.Col;
       ERow2 = Line2->Start.Row;
    } else {
       *jp2 = 0;
       Col2 = Line2->Start.Col;
       Row2 = Line2->Start.Row;
       ECol2 = Line2->End.Col;
       ERow2 = Line2->End.Row;
    }


/*
 This check suggested by KC to avoid problems with Lambda junctions where the
 end points of the lines are very close together. These junctions are called V
 or L  junctions despite the fact that the junction point lies on one of the 
 lines.
*/

   Dmax = LineLength(Col1,Row1,Col2,Row2);
   if ( Dmax <= (Line1->LengthParlVar + Line2->LengthPerpVar) &&
        Dmax <= (Line2->LengthParlVar + Line1->LengthPerpVar) )
       Status = 4;

/*
 At last we can compute the Quality factor. OK OK so I could have used a case
 statement.. In some cases we subtract the variances so that the Quality 
 factor is always below 1.0 and greater than 0.0

*/

/*
 Note that we use line2perpvar and line1perpvar assymmetrically since
 that is the factor which decides whether a point is considered to be on or off
 a line segment
*/

 if (Status == 0)
    *Quality = (Line1->Length + Line2->Length ) /
		 (LineLength((*JunctionPtCol),(*JunctionPtRow),ECol2,ERow2) +
		  LineLength((*JunctionPtCol),(*JunctionPtRow),ECol1,ERow1));

 if (Status == 1)
    *Quality = (Line2->Length)/
		 (LineLength((*JunctionPtCol),(*JunctionPtRow),ECol2,ERow2));

 if (Status == 2)
    *Quality = (Line1->Length)/
		 (LineLength((*JunctionPtCol),(*JunctionPtRow),ECol1,ERow1));

 if (Status == 3 || Status == 4)
    *Quality = (Line1->Length + Line2->Length)/
		 (LineLength((*JunctionPtCol),(*JunctionPtRow),ECol1,ERow1) +
           	  LineLength((*JunctionPtCol),(*JunctionPtRow),ECol2,ERow2));

    if ( (*Quality) < MinQuality)
	  return(-1);

    if ( (*Quality) > 1.0) {
	  (*Quality) = 1.0;
#ifdef GiveWarning
     	fprintf(stderr,"Error in CheckJunctionType: Quality factor > 1.0\n");
     	fprintf(stderr,"This means your lines intersect to form an X shape.\n");
       fprintf(stderr,"Status %d: Quality factor %lf for Lines %d, %d exceeds 1.0 \n",
	Status,(*Quality),Line1->ID,Line2->ID,Status);
	return(-1);
#endif
    }

	return(Status);

#ifdef debug
          fprintf(stderr," End of function CheckJunctionType \n");
#endif

}

