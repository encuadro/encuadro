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

Name : CreateLPEGLists.c
Type : function
Written on   : 21-Oct-91     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/ORT/IPEG/src

==============================================================================

Input parameters    : 

InFile		-- Pointer to data file 

   Type	-- Type of list to be created where:

     0 Lines             
     1 CircularArcs             
     2 OVParallel        
     3 NOVParallel       
     4 Collinear         
     5 L_Junctions       
     6 V_Junctions       
     7 T_Junctions       
     8 LambdaJunctions   

LinkedListID	-- Liste library ID number of the list to be created 

Output parameters   : 

NList		-- Number of nodes in the list
LinkedListID	-- Liste library ID number of the list that has been created 

Output result       : 
  0 = successful, 
  1 = error, 
 -1 = EOF etc..

Calling procedure:

 FILE *InFile;

 int Type;
 int NList;

 Liste LinkedListID;

 CreateLPEGLists (InFile, Type, &LinkedListID, &NList)

Functionality: 

Reads the data output by the LPEG program and stores them in a number of linked
lists. 

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

int CreateLPEGLists (InFile, Type, LinkedListID, NList)

  FILE *InFile;
  int Type;			/* *LPEG_TYPE[] above for correspondences */
  int *NList;			/* Number of structures in the list */
  Liste  *LinkedListID;	/* List to fill in */

{

  int flag;
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
 Start at the top of the file
*/
   *NList = 0;
/* 
  Skip text to relevant section of LPEG output
*/
     flag = fscanf(InFile,"%s",text);
     while  ( strcmp(text,LPEG_TYPE[Type]) && flag != 0 && flag != EOF) {
              flag = fscanf(InFile,"%s",text);
     }
/*
 Read in the data into the linked list
*/
  switch (Type) {

/* ========================ORT lines========================== */
    case 0: 

      while (flag != 0 && flag != EOF) {

        Line = MACAllocateMem(ORTLine);
        flag = fscanf(InFile,"%d %d %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",
			   &Line->ID,
                        &Line->StringID,
                        &Line->Start.Col,
                        &Line->Start.Row,
                        &Line->End.Col,
                        &Line->End.Row,
                        &Line->MidPoint.Col,
                        &Line->MidPoint.Row,
                        &Line->Length,
                        &Line->LengthParlVar,
                        &Line->LengthPerpVar,
                        &Line->Theta,
                        &Line->ThetaVar);

	  if (flag != 0 && flag != EOF)  {
         	AddElmList (*LinkedListID, (long) Line );
		(*NList)++;
         }

	} /* eof while */ 
       break;

/* ========================ORT circular arcs========================== */
    case 1: 

      while (flag != 0 && flag != EOF) {

        CircArc = MACAllocateMem(ORTCircularArc);
        flag = fscanf(InFile,"%d %d %d %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",
                        &CircArc->ID,
                        &CircArc->StringID,
                        &CircArc->Direction,
                        &CircArc->Origin.Col,
                        &CircArc->Origin.Row,
                        &CircArc->Start.Col,
                        &CircArc->Start.Row,
                        &CircArc->MidPoint.Col,
                        &CircArc->MidPoint.Row,
                        &CircArc->End.Col,
                        &CircArc->End.Row,
                        &CircArc->VLPoint.Col,
                        &CircArc->VLPoint.Row,
                        &CircArc->Radius,
                        &CircArc->Length,
                        &CircArc->LengthParlVar,
                        &CircArc->LengthPerpVar,
                        &CircArc->Width,
                        &CircArc->Height,
                        &CircArc->Theta);

	  if (flag != 0 && flag != EOF)  {
         	AddElmList (*LinkedListID, (long) CircArc );
		(*NList)++;
         }

	} /* eof while */ 
       break;

/* ========================Overlapping parallel========================== */
    case 2: 

      while (flag != 0 && flag != EOF) {

         OVPar = MACAllocateMem(ORTParallelOV);
	  flag = fscanf(InFile,"%d %d %lf %lf %lf %lf %lf %lf %lf %lf\n",
                       &OVPar->FirstID,
                       &OVPar->SecondID,
                       &OVPar->VLLine.Start.Col,
                       &OVPar->VLLine.Start.Row,
                       &OVPar->VLLine.End.Col,
                       &OVPar->VLLine.End.Row,
                       &OVPar->VLLine.Length,
                       &OVPar->VLLine.Theta,
                       &OVPar->WidthOverHeight,
                       &OVPar->Quality);
	  if (flag != 0 && flag != EOF)  {
         	AddElmList (*LinkedListID, (long) OVPar );
		(*NList)++;
         }

	} /* eof while */ 
       break;

/* ========================non-Overlapping parallel======================== */

    case 3: /* non-Overlapping parallel */

      while (flag != 0 && flag != EOF) {

         NOVPar = MACAllocateMem(ORTParallelNOV);
	  flag = fscanf(InFile,"%d %d %lf %lf %lf %lf %lf %lf %lf %lf\n",
                       &NOVPar->FirstID,
                       &NOVPar->SecondID,
                       &NOVPar->VLLine.Start.Col,
                       &NOVPar->VLLine.Start.Row,
                       &NOVPar->VLLine.End.Col,
                       &NOVPar->VLLine.End.Row,
                       &NOVPar->VLLine.Length,
                       &NOVPar->VLLine.Theta,
                       &NOVPar->WidthOverHeight,
                       &NOVPar->Quality);
	  if (flag != 0 && flag != EOF)  {
         	AddElmList (*LinkedListID, (long) NOVPar );
		(*NList)++;
         }

	} /* eof while */ 
       break;

/* ================================Collinear============================== */
    case 4: 

      while (flag != 0 && flag != EOF) {

         Colln = MACAllocateMem(ORTCollinear);
	  flag = fscanf(InFile,"%d %d %lf %lf %lf %lf %lf %lf %lf\n",
                       &Colln->FirstID,
                       &Colln->SecondID,
                       &Colln->VLLine.Start.Col,
                       &Colln->VLLine.Start.Row,
                       &Colln->VLLine.End.Col,
                       &Colln->VLLine.End.Row,
                       &Colln->VLLine.Length,
                       &Colln->VLLine.Theta,
                       &Colln->Quality);
	  if (flag != 0 && flag != EOF)  {
         	AddElmList (*LinkedListID, (long) Colln );
		(*NList)++;
         }

	} /* eof while */ 
       break;

/* ============================L Junctions============================== */
    case 5: 

      while (flag != 0 && flag != EOF) {

         LJct = MACAllocateMem(ORTLJunction);
	  flag = fscanf(InFile,"%d %d %d %d %d %lf %lf %lf\n",
                       &LJct->FirstID,
                       &LJct->SecondID,
                       &LJct->ip,
                       &LJct->jp1,
                       &LJct->jp2,
                       &LJct->JunctionPt.Col,
                       &LJct->JunctionPt.Row,
                       &LJct->Quality);
	  if (flag != 0 && flag != EOF)  {
         	AddElmList (*LinkedListID, (long) LJct );
		(*NList)++;
         }

	} /* eof while */ 
       break;

/* ============================V Junctions============================== */
    case 6: 

      while (flag != 0 && flag != EOF) {

         VJct = MACAllocateMem(ORTVJunction);
	  flag = fscanf(InFile,"%d %d %d %d %d %lf %lf %lf\n",
                       &VJct->FirstID,
                       &VJct->SecondID,
                       &VJct->ip,
                       &VJct->jp1,
                       &VJct->jp2,
                       &VJct->JunctionPt.Col,
                       &VJct->JunctionPt.Row,
                       &VJct->Quality);
	  if (flag != 0 && flag != EOF)  {
         	AddElmList (*LinkedListID, (long) VJct );
		(*NList)++;
         }

	} /* eof while */ 
       break;

/* ============================T Junctions============================== */
    case 7: 

      while (flag != 0 && flag != EOF) {

         TJct = MACAllocateMem(ORTTJunction);
	  flag = fscanf(InFile,"%d %d %d %d %d %lf %lf %lf\n",
                       &TJct->FirstID,
                       &TJct->SecondID,
                       &TJct->ip,
                       &TJct->jp1,
                       &TJct->jp2,
                       &TJct->JunctionPt.Col,
                       &TJct->JunctionPt.Row,
                       &TJct->Quality);
	  if (flag != 0 && flag != EOF)  {
         	AddElmList (*LinkedListID, (long) TJct );
		(*NList)++;
         }

	} /* eof while */ 
       break;

/* ============================Lambda Junctions============================== */
    case 8: 

      while (flag != 0 && flag != EOF) {

         LambdaJct = MACAllocateMem(ORTLambdaJunction);
	  flag = fscanf(InFile,"%d %d %d %d %d %lf %lf %lf\n",
                       &LambdaJct->FirstID,
                       &LambdaJct->SecondID,
                       &LambdaJct->ip,
                       &LambdaJct->jp1,
                       &LambdaJct->jp2,
                       &LambdaJct->JunctionPt.Col,
                       &LambdaJct->JunctionPt.Row,
                       &LambdaJct->Quality);
	  if (flag != 0 && flag != EOF)  {
         	AddElmList (*LinkedListID, (long) LambdaJct );
		(*NList)++;
         }

	} /* eof while */ 
       break;

  } /* endof switch */

  return;

}
