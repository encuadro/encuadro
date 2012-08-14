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

Name : fex
Version: 1.8
Written on   : 8-Mar-91      By : A. Etemadi
Modified on  : 11-Oct-91	 By : A. Etemadi
Modified on  : 31-Mar-92	 By : A. Etemadi
Modified on  : 16-Feb-93	 By : A. Etemadi

  1. Added more accurate determination of center of curvature
  2. Added support for rectangular images
  3. Added smoothing factor option

Directory    : ~atae/ORT/FEX/exe

==============================================================================


Usage:	

	fex < Chain-File > OutFile

Output result       : 

   0 = successful, 
  -1 = error, 

Functionality: 

Segment edge data into straight lines and circular arcs.

----------------------------------------------------------------------------*/

#include "ListeMacros.h"
#include "Liste.h"
#include "FEX.h"
#include "LPEG.h"

main(argc,argv)

 int  argc;
 char **argv;

{

/*
=======================================================================
===================== START OF DECLARATION ============================
=======================================================================
*/
 int i,NoOfRows,NoOfCols;
 int MaxJumpPixels;
 int Next;
 int LineCounter;
 int CurveCounter;

 FILE *p_InFile;		/* Pointers to start of files fo I/O */
 FILE *p_OutFile;

/* 
Number of lines in corresponding lists 

*/
  int StringListSize;	  /* Number of points in string */
  int SegmentListSize;	  /* Number of segments found along string */
  int StringID;
/* 
 ID numbers of appropriate lists 

*/
 Liste StringListID;	
 Liste SegmentListID;	
 Liste LineListID;	
 Liste CircularArcListID;	

/*
 Pointer to list

*/
 struct ORTPoint          *StringList;
 struct ORTSegment        *SegmentList;
 struct ORTLine    	     *Line;
 struct ORTCircularArc    *CircularArc;

/*
 Buffers for outputting result
*/

 int semicircle;
 int direction;

 long Buffer;
 long Segment;

 struct ORTSegment *SegmentBuffer;
 struct ORTPoint   *PointBuffer;

 double Length;
 double LengthParlVar;
 double LengthPerpVar;
 double ThetaVar;
 double Height;
 double Width;

 double StartCol,EndCol;
 double StartRow,EndRow;

 double side;
 double x1,x2,x3,x4;
 double y1,y2,y3,y4;
 double MidToVL;
 double MidToJct;

/*
=======================================================================
===================== START OF INITIALISATION =========================
=======================================================================
*/
 

/*
 Set defaults, process command line options, and initialise lists
*/

  Next = 0;
  MaxJumpPixels = 2;

  for (i=1;i<argc;i++) {
       if (argv[i][0] == '-') {
           switch (argv[i][1]) {
	    case 'v': Next++; fprintf(stderr,"%s: Version 1.8\n",argv[0]); return(-1);
	    default : fprintf(stderr,"Error: unrecognized option: %s \n",argv[i]); return(-1);
           case 'h': 
  fprintf(stderr,"USAGE : \n");
  fprintf(stderr," %s [-hv] < Chain-File > OutFile\n\n",argv[0]);
  fprintf(stderr,"WHERE : \n");
  fprintf(stderr," -h Gives usage information\n");
  fprintf(stderr," -v Gives version number\n");
  fprintf(stderr," InFile contains a list of strings produced by the program chainpix\n");
  fprintf(stderr," OutFile will contain ASCII list of FEX line segments and circular arcs\n");
  return(-1);
           }
        }
   }

/*
 Use standard input output I/O

*/
  p_InFile  = stdin ;
  p_OutFile = stdout ;

/*
=======================================================================
============================ MAIN LOOP ================================
=======================================================================
*/
 
/*
 Get one string from string file and store it in a linked list for processing
*/

LineListID 	    = CreatList();
CircularArcListID = CreatList();

LineCounter  = 0;
CurveCounter = 0;
StringID     = 0;

while (CreateStringList(&p_InFile,
			   &NoOfCols,
			   &NoOfRows,
             	    	   &StringListSize,
             	    	   &StringListID,
             	    	   &StringList) == 0) {
	StringID+=1;
/*
 Find segments along the string using Strider algorithm and store them in
 a list for linking
*/
  if (StringToSegments(MaxJumpPixels,
			  StringListSize,
	             	  StringListID,
			  StringList,
			 &SegmentListSize,
	             	 &SegmentListID,
			 &SegmentList) == 0) {

       if (LinkSegments(StringListSize,
	                 StringListID,
		          StringList,
		         &SegmentListSize,
	                &SegmentListID,
		         &SegmentList) == 0) {

       for (i = 1; i <= SegmentListSize ; i++) {

		Segment 	= ElmNumList ( SegmentListID, (long)i);
		SegmentBuffer = MACCast(ORTSegment,Segment);

/*
 Now classify the bloody things and output to appropriate files
*/

	 Height = LineLength(SegmentBuffer->MidPoint.Col,
			  	SegmentBuffer->MidPoint.Row,
			  	SegmentBuffer->VLPoint.Col,
			  	SegmentBuffer->VLPoint.Row);

	 Length = (double)(SegmentBuffer->StringEnd - 
			     SegmentBuffer->StringStart + 1);
/*
 Due to ambiguity at end points
*/
	 LengthParlVar = sqrt(2.0);
	 LengthPerpVar = sqrt(2.0);
	 ThetaVar = (2.0*LengthPerpVar)/Length;
/*
 This is the condition for a segment to be classified as a straight-line
*/
	if ( Height <= 2.0*LengthPerpVar || Height >= HUGE ||
	     SegmentBuffer->JctPoint.Col >= HUGE ||
	     SegmentBuffer->JctPoint.Row >= HUGE) {

	 LineCounter++;
/*
 Add these segments to the line list, removing ambiguous end points.
*/
  Line = MACAllocateMem(ORTLine);

  StringList = MACCast(ORTPoint, 
              (ElmNumList(StringListID,(long) SegmentBuffer->StringStart+1 )) );
 
  	Line->Start.Col 	= StringList->Col;
  	Line->Start.Row 	= StringList->Row;

  StringList = MACCast(ORTPoint, 
              (ElmNumList(StringListID,(long) SegmentBuffer->StringEnd-1 )) );
 
  	Line->End.Col 	= StringList->Col;
  	Line->End.Row 	= StringList->Row;

	 Line->ID 		= LineCounter;
	 Line->StringID 	= StringID;

	 Line->MidPoint.Col 	= SegmentBuffer->MidPoint.Col;
	 Line->MidPoint.Row 	= SegmentBuffer->MidPoint.Row;
	 Line->Length 	= LineLength(Line->Start.Col,
			       	      Line->Start.Row,
			       	      Line->End.Col,
			       	      Line->End.Row);

	 Line->LengthParlVar = 2.0*LengthParlVar;
	 Line->LengthPerpVar = LengthPerpVar;
	 Line->Theta 		= LineSegTheta(Line->Start.Col,
			       	        Line->Start.Row,
			       	        Line->End.Col,
			       	        Line->End.Row);
	 Line->ThetaVar 	= ThetaVar;
	 AddElmList (LineListID, (long) Line);

	 } else {

	 CurveCounter++;
	 CircularArc = MACAllocateMem(ORTCircularArc);
	 CircularArc->ID 		 = CurveCounter;
        CircularArc->StringID 	 = StringID;
	 CircularArc->Start.Col 	 = SegmentBuffer->Start.Col;
	 CircularArc->Start.Row 	 = SegmentBuffer->Start.Row;
	 CircularArc->End.Col 	 = SegmentBuffer->End.Col;
	 CircularArc->End.Row 	 = SegmentBuffer->End.Row;
	 CircularArc->MidPoint.Col   = SegmentBuffer->MidPoint.Col;
	 CircularArc->MidPoint.Row   = SegmentBuffer->MidPoint.Row;
	 CircularArc->VLPoint.Col 	 = SegmentBuffer->VLPoint.Col;
	 CircularArc->VLPoint.Row 	 = SegmentBuffer->VLPoint.Row;
	 CircularArc->Origin.Col 	 = SegmentBuffer->JctPoint.Col;
	 CircularArc->Origin.Row 	 = SegmentBuffer->JctPoint.Row;
	 CircularArc->Radius 	 = (1.0/3.0) * (
					   LineLength(CircularArc->Origin.Col,
							CircularArc->Origin.Row,
							CircularArc->Start.Col,
							CircularArc->Start.Row) + 
					   LineLength(CircularArc->Origin.Col,
							CircularArc->Origin.Row,
							CircularArc->MidPoint.Col,
							CircularArc->MidPoint.Row) +
					   LineLength(CircularArc->Origin.Col,
							CircularArc->Origin.Row,
							CircularArc->End.Col,
							CircularArc->End.Row) );
	 CircularArc->Length 	 = Length;
	 CircularArc->LengthParlVar  = 2.0*LengthParlVar;
	 CircularArc->LengthPerpVar  = LengthPerpVar;
	 CircularArc->Theta		 = LineSegTheta(CircularArc->Origin.Col,
							  CircularArc->Origin.Row,
							  CircularArc->MidPoint.Col,
							  CircularArc->MidPoint.Row);
	 CircularArc->Height 	 = Height;
	 CircularArc->Width 		 = LineLength(SegmentBuffer->Start.Col,
			       			SegmentBuffer->Start.Row,
			       			SegmentBuffer->End.Col,
			       			SegmentBuffer->End.Row);
/*
 First figure out whether curve is bigger or smaller than a semicircle
*/

 MidToVL  = LineLength( CircularArc->MidPoint.Col,
                        CircularArc->MidPoint.Row,
                        CircularArc->VLPoint.Col,
                        CircularArc->VLPoint.Row);  

 MidToJct = LineLength( CircularArc->MidPoint.Col,
                        CircularArc->MidPoint.Row,
                        CircularArc->Origin.Col,
                        CircularArc->Origin.Row);  
 semicircle = 0;
 if (MidToVL >= MidToJct)  semicircle = 1;
/*
 Now figure out whether to draw clockwise or anticlockwise
*/
  x1 = CircularArc->Start.Col; 
  y1 = CircularArc->Start.Row; 
  x2 = CircularArc->MidPoint.Col;
  y2 = CircularArc->MidPoint.Row;
  x3 = CircularArc->End.Col;
  y3 = CircularArc->End.Row;
  x4 = CircularArc->Origin.Col;
  y4 = CircularArc->Origin.Row;

   side = - (x4-x3)*(y1-y3) + (y4-y3)*(x1-x3) ;

   if (side <= 0.0 && semicircle != 1)
	direction = -1;

   if (side <= 0.0 && semicircle == 1)
	direction =  1;

   if (side  > 0.0 && semicircle != 1)
	direction = 1;

   if (side  > 0.0 && semicircle == 1)
	direction = -1;

	 CircularArc->Direction	 = direction;

 	 AddElmList (CircularArcListID, (long) CircularArc);
	 }
      }
    }

/*
 Free memory used by buffer lists
*/
	DestList(&StringListID);	
	DestList(&SegmentListID);	

  }

}

/*
 OutPut Results. First the line Segments.
*/
	LineCounter = (int) SizeList(LineListID);
 
 	fprintf(p_OutFile,"#%d %d\n",NoOfCols,NoOfRows);
 	fprintf(p_OutFile,"#Lines\n");
 	fprintf(stderr,"Number of LineSegments = %d\n",LineCounter);


/*
   Sort by theta and reassign ID numbers
*/
   SortList(LineListID, SortByThetaAscending);

   Buffer   = FirstElmList(LineListID);
   Line     = MACCast(ORTLine,Buffer);
   Line->ID = 1;

   for (i = 2 ; i <= LineCounter ;i++) {
            Buffer = NextElmList(LineListID);
            Line = MACCast(ORTLine,Buffer);
            Line->ID = i;
   }

	for (i=1; i<=LineCounter; i++) {
      	    Buffer  = ElmNumList ( LineListID, (long) i);
      	    Line    = MACCast(ORTLine,Buffer);

	fprintf(p_OutFile,"%d %d %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",
	 	Line->ID,
	 	Line->StringID,
	 	Line->Start.Col,
	 	Line->Start.Row,
	 	Line->End.Col,
	 	Line->End.Row,
	 	Line->MidPoint.Col,
	 	Line->MidPoint.Row,
	 	Line->Length,
	 	Line->LengthParlVar,
	 	Line->LengthPerpVar,
	 	Line->Theta,
	 	Line->ThetaVar);
	}

/*
 Now the circular Arcs
*/

	CurveCounter = (int) SizeList(CircularArcListID);
 
 	fprintf(p_OutFile,"#\n");
 	fprintf(p_OutFile,"#CircularArcs\n");
 	fprintf(stderr,"Number of CircularArcs = %d\n",CurveCounter);

	for (i=1; i<=CurveCounter; i++) {
      	    Buffer  	  = ElmNumList ( CircularArcListID, (long) i);
      	    CircularArc = MACCast(ORTCircularArc,Buffer);

	fprintf(p_OutFile,"%d %d %d %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",
	 CircularArc->ID,
    CircularArc->StringID,
    CircularArc->Direction,
	 CircularArc->Origin.Col, 	 
	 CircularArc->Origin.Row, 	 
	 CircularArc->Start.Col, 	 
	 CircularArc->Start.Row, 	 
	 CircularArc->MidPoint.Col,   
	 CircularArc->MidPoint.Row,   
	 CircularArc->End.Col, 	 
	 CircularArc->End.Row, 	 
	 CircularArc->VLPoint.Col, 	 
	 CircularArc->VLPoint.Row, 	 
	 CircularArc->Radius, 	 
	 CircularArc->Length,
	 CircularArc->LengthParlVar,  
	 CircularArc->LengthPerpVar,
	 CircularArc->Width,
	 CircularArc->Height, 	 
	 CircularArc->Theta);
   }

/*
 Free memory used by remaining lists
*/
	DestList(&LineListID);	
	DestList(&CircularArcListID);	

/*
 Close all files
*/
         fclose(p_InFile);
         fclose(p_OutFile);

	  return(0);
}
