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

Name : WriteLPEGLists.c
Type : function
Written on   : 16-Feb-93     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/IPEG/src

==============================================================================

Input parameters    : 

InFile		-- Pointer to data file 

   Type	-- Type of list to be written where:

     0 Lines             
     1 CircularArcs             
     2 OVParallel        
     3 NOVParallel       
     4 Collinear         
     5 L_Junctions       
     6 V_Junctions       
     7 T_Junctions       
     8 LambdaJunctions   

LinkedListID	-- Liste library ID number of the list to be writen 

Output parameters   : 

NList		-- Number of nodes in the list
LinkedListID	-- Liste library ID number of the list that to be writen

Output result       : 
  0 = successful, 
  1 = error, 

Calling procedure:

 FILE *InFile;

 int Type;
 int NList;

 Liste LinkedListID;

 WriteLPEGLists (OutFile, Type, LinkedListID, NList)

Functionality: 

Outputs by the data from a linked list produced by the lpeg program 

----------------------------------------------------------------------------*/

#include "ListeMacros.h"
#include "Liste.h"
#include "FEX.h"
#include "LPEG.h"

#define MAXCHAR 200

static char *LPEG_TYPE[] = {
"#Lines",             /* Type 0 */
"#CircularArcs",      /*      1 */
"#OVParallel",        /*      2 */
"#NOVParallel",       /*      3 */
"#Collinear",         /*      4 */
"#L_Junctions",       /*      5 */
"#V_Junctions",       /*      6 */
"#T_Junctions",       /*      7 */
"#Lambda_Junctions"   /*      8 */
};

int WriteLPEGLists (OutFile, Type, LinkedListID, NList)

  FILE *OutFile;
  int Type;			/* *LPEG_TYPE[] above for correspondences */
  int NList;			/* Number of structures in the list */
  Liste  LinkedListID;	/* List to fill in */

{

  int i,flag;
  long Buffer;

  char text[MAXCHAR];

  struct ORTLine           *Line;
  struct ORTCircularArc    *CircArc;
  struct ORTParallelOV     *OVPar;
  struct ORTParallelNOV    *NOVPar;
  struct ORTCollinear      *Colln;
  struct ORTLJunction      *LJct;
  struct ORTVJunction      *VJct;
  struct ORTTJunction      *TJct;
  struct ORTLambdaJunction *LambdaJct;

/*
 Write out the data into the linked list
*/
  switch (Type) {

/* ========================ORT lines========================== */
    case 0: 

 fprintf(OutFile,"#Lines\n");

      for (i = 1 ; i <= NList; i++) {

           Buffer  = ElmNumList (LinkedListID, (long) i);
           Line = MACCast(ORTLine,Buffer);

           fprintf(OutFile,"%d %d %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",
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

	} /* endfor */ 
       break;

/* ========================ORT circular arcs========================== */
    case 1: 

 fprintf(OutFile,"#\n");
 fprintf(OutFile,"#CircularArcs\n");

      for (i = 1 ; i <= NList; i++) {

           Buffer  = ElmNumList (LinkedListID, (long) i);
           CircArc = MACCast(ORTCircularArc, Buffer);

        fprintf(OutFile,"%d %d %d %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",
                        CircArc->ID,
                        CircArc->StringID,
                        CircArc->Direction,
                        CircArc->Origin.Col,
                        CircArc->Origin.Row,
                        CircArc->Start.Col,
                        CircArc->Start.Row,
                        CircArc->MidPoint.Col,
                        CircArc->MidPoint.Row,
                        CircArc->End.Col,
                        CircArc->End.Row,
                        CircArc->VLPoint.Col,
                        CircArc->VLPoint.Row,
                        CircArc->Radius,
                        CircArc->Length,
                        CircArc->LengthParlVar,
                        CircArc->LengthPerpVar,
                        CircArc->Width,
                        CircArc->Height,
                        CircArc->Theta);

	} /* eof while */ 
       break;

/* ========================Overlapping parallel========================== */
    case 2: 

 fprintf(OutFile,"#\n");
 fprintf(OutFile,"#OVParallel\n");

      for (i = 1 ; i <= NList; i++) {

           Buffer  = ElmNumList (LinkedListID, (long) i);
           OVPar = MACCast(ORTParallelOV, Buffer);


	  fprintf(OutFile,"%d %d %lf %lf %lf %lf %lf %lf %lf %lf\n",
                       OVPar->FirstID,
                       OVPar->SecondID,
                       OVPar->VLLine.Start.Col,
                       OVPar->VLLine.Start.Row,
                       OVPar->VLLine.End.Col,
                       OVPar->VLLine.End.Row,
                       OVPar->VLLine.Length,
                       OVPar->VLLine.Theta,
                       OVPar->WidthOverHeight,
                       OVPar->Quality);

	} /* eof while */ 
       break;

/* ========================non-Overlapping parallel======================== */

    case 3: /* non-Overlapping parallel */

 fprintf(OutFile,"#\n");
 fprintf(OutFile,"#NOVParallel\n");

      for (i = 1 ; i <= NList; i++) {

           Buffer  = ElmNumList (LinkedListID, (long) i);
           NOVPar = MACCast(ORTParallelNOV, Buffer);

	  fprintf(OutFile,"%d %d %lf %lf %lf %lf %lf %lf %lf %lf\n",
                       NOVPar->FirstID,
                       NOVPar->SecondID,
                       NOVPar->VLLine.Start.Col,
                       NOVPar->VLLine.Start.Row,
                       NOVPar->VLLine.End.Col,
                       NOVPar->VLLine.End.Row,
                       NOVPar->VLLine.Length,
                       NOVPar->VLLine.Theta,
                       NOVPar->WidthOverHeight,
                       NOVPar->Quality);

	} /* eof while */ 
       break;

/* ================================Collinear============================== */
    case 4: 

 fprintf(OutFile,"#\n");
 fprintf(OutFile,"#Collinear\n");

      for (i = 1 ; i <= NList; i++) {

           Buffer  = ElmNumList (LinkedListID, (long) i);
           Colln = MACCast(ORTCollinear, Buffer);

	  fprintf(OutFile,"%d %d %lf %lf %lf %lf %lf %lf %lf\n",
                       Colln->FirstID,
                       Colln->SecondID,
                       Colln->VLLine.Start.Col,
                       Colln->VLLine.Start.Row,
                       Colln->VLLine.End.Col,
                       Colln->VLLine.End.Row,
                       Colln->VLLine.Length,
                       Colln->VLLine.Theta,
                       Colln->Quality);

	} /* eof while */ 
       break;

/* ============================L Junctions============================== */
    case 5: 

 fprintf(OutFile,"#\n");
 fprintf(OutFile,"#L_Junctions\n");

      for (i = 1 ; i <= NList; i++) {

           Buffer  = ElmNumList (LinkedListID, (long) i);
           LJct = MACCast(ORTLJunction, Buffer);

	  fprintf(OutFile,"%d %d %d %d %d %lf %lf %lf\n",
                       LJct->FirstID,
                       LJct->SecondID,
                       LJct->ip,
                       LJct->jp1,
                       LJct->jp2,
                       LJct->JunctionPt.Col,
                       LJct->JunctionPt.Row,
                       LJct->Quality);

	} /* eof while */ 
       break;

/* ============================V Junctions============================== */
    case 6: 

 fprintf(OutFile,"#\n");
 fprintf(OutFile,"#V_Junctions\n");

      for (i = 1 ; i <= NList; i++) {

           Buffer  = ElmNumList (LinkedListID, (long) i);
           VJct = MACCast(ORTVJunction, Buffer);

	  fprintf(OutFile,"%d %d %d %d %d %lf %lf %lf\n",
                       VJct->FirstID,
                       VJct->SecondID,
                       VJct->ip,
                       VJct->jp1,
                       VJct->jp2,
                       VJct->JunctionPt.Col,
                       VJct->JunctionPt.Row,
                       VJct->Quality);

	} /* eof while */ 
       break;

/* ============================T Junctions============================== */
    case 7: 

 fprintf(OutFile,"#\n");
 fprintf(OutFile,"#T_Junctions\n");

      for (i = 1 ; i <= NList; i++) {

           Buffer  = ElmNumList (LinkedListID, (long) i);
           TJct = MACCast(ORTTJunction, Buffer);

	  fprintf(OutFile,"%d %d %d %d %d %lf %lf %lf\n",
                       TJct->FirstID,
                       TJct->SecondID,
                       TJct->ip,
                       TJct->jp1,
                       TJct->jp2,
                       TJct->JunctionPt.Col,
                       TJct->JunctionPt.Row,
                       TJct->Quality);

	} /* eof while */ 
       break;

/* ============================Lambda Junctions============================== */
    case 8: 

 fprintf(OutFile,"#\n");
 fprintf(OutFile,"#Lambda_Junctions\n");

      for (i = 1 ; i <= NList; i++) {

           Buffer  = ElmNumList (LinkedListID, (long) i);
           LambdaJct = MACCast(ORTLambdaJunction, Buffer);

	  fprintf(OutFile,"%d %d %d %d %d %lf %lf %lf\n",
                       LambdaJct->FirstID,
                       LambdaJct->SecondID,
                       LambdaJct->ip,
                       LambdaJct->jp1,
                       LambdaJct->jp2,
                       LambdaJct->JunctionPt.Col,
                       LambdaJct->JunctionPt.Row,
                       LambdaJct->Quality);

	} /* eof while */ 
       break;

  } /* endof switch */

  return;

}
