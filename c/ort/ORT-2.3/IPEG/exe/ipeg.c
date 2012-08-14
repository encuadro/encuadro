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

Name : ipeg
Version: 2.1
Written on   : 21-Oct-91     By : A. Etemadi
Modified on  : 16-Mar-92     By : A. Etemadi
               21-Mar-92     By : A. Etemadi
               29-Mar-92     By : A. Etemadi
               14-Apr-92     By : A. Etemadi
               21-Apr-92     By : A. Etemadi
               16-Feb-93     By : A. Etemadi

   Added piping capability
   Fixed problem using bcopy (C bug not mine !!)
   Added support for rectagular images

Directory    : ~atae/ORT/IPEG/exe

==============================================================================


Usage:	
	IPEG [-htcp] < InFile > OutFile

Command line parameters:

Options: 
	-h Give Usage info.
	-t Triplets only
	-c Corners only
	-p Closed Polygons only

InFile			-- Name of file containing results of lines grouped by LPEG
OutFile		-- Name of file containing results of intermediate level
			   groupings of line segments formed by IPEG

Output result       : 

   0 = successful, 
  -1 = error, 

Functionality: 

This program groups pairs of line segments already grouped by LPEG. The
groupings produced here are at the intermediate level and comprise:

	Triplets of lines, two of which share a segment.

	Triplets of lines, any pair of which form a V or L junction,
	and "share" a junction point (dubbed a Corner).

	N-sided (N >= 3) Closed Polygons.

Bugs:

     1. Currently does not take collinearities into account properly although 
        they are included through the use of the Quality factor within LPEG.

----------------------------------------------------------------------------*/

#include <stdlib.h>
#include "ListeMacros.h"
#include "Liste.h"
#include "FEX.h"
#include "LPEG.h"
#include "IPEG.h"

main(argc,argv)

 int  argc;
 char **argv;

{

/*
=======================================================================
===================== START OF DECLARATION ============================
=======================================================================
*/

/*
 Command line parameters
*/

 FILE *InFile;		/* Pointers to start of files fo I/O */
 FILE *OutFile;

/*
 Loop indecies and Flags
*/
 
 int i,j,k,l,m,n;
 int Next;			/* Next option */
 int OutPutStatus;
 int Whistle;
 int Status;
/*
 Flags for terminating loops
*/

 int Sorted;
 int NDuplicate;
 int FoundTriplet;
 int FoundJunction;
 int FoundCorner;
 int FoundYCorner;
 int FoundTLambdaCorner;
 int FoundLeftTriplet;
 int FoundRightTriplet;
 int FoundOpenPolygon;
 int FoundClosedPolygon;
 int PrunePolygon;

/* 
Number of lines in corresponding lists 

*/

 int N_ListORTLine;		/* ORT line data */
 int N_ListCollinear;	/* LPEG groupings */
 int N_ListLJunction;	  
 int N_ListVJunction;	  
 int N_ListTJunction;	  
 int N_ListLambdaJunction;	  

 int N_ListVLJunction;	/* LPEG V,L and T,Lambda junctions combined */
 int N_ListTLambdaJunction;	  

 int N_ListTriplet;	  	/* IPEG lists */
 int N_ListYCorner;	  	
 int N_ListTLambdaCorner;	  	
 int N_ListClosedPolygon;

/* 
 ID numbers of appropriate lists 

*/
 Liste ID_ListORTLine;	/* Original Line set */
 Liste ID_ListCollinear;	/* LPEG groupings */
 Liste ID_ListLJunction;	  
 Liste ID_ListVJunction;	  
 Liste ID_ListVLJunction;	  
 Liste ID_ListTJunction;	  
 Liste ID_ListLambdaJunction;
 Liste ID_ListTLambdaJunction;

 Liste ID_ListTriplet;		/* IPEG groupings */
 Liste ID_ListYCorner;
 Liste ID_ListTLambdaCorner;
 Liste ID_ListClosedPolygon;

/*
 Pointers to elements of the lists

*/
 struct ORTLine        	*Line[4];	/* Items from Original ORTLine set */
 struct ORTCollinear		*Collinear;	/* Items from LPEG groupings */
 struct ORTVJunction		*VLJunction;	  
 struct ORTTJunction		*TLambdaJunction;

 struct ORTTriplet			*Triplet;	/* Items from IPEG sets */
 struct ORTCorner			*YCorner;
 struct ORTCorner			*TLambdaCorner;
 struct ORTClosedPolygon		*ClosedPolygon;

/*
 Buffers
*/

 char c;
 char cbuf[100];

 struct ORTVJunction		*OldVLJunction;
 struct ORTVJunction		*NewVLJunction;

 struct ORTTriplet		*OldTriplet;
 struct ORTTriplet		*NewTriplet;

 struct ORTOpenPolygon	*OldLeftOpenPolygon;
 struct ORTOpenPolygon	*OldRightOpenPolygon;
 struct ORTOpenPolygon	*NewLeftOpenPolygon;
 struct ORTOpenPolygon	*NewRightOpenPolygon;

 struct ORTClosedPolygon	*OldClosedPolygon;
 struct ORTClosedPolygon	*NewClosedPolygon;

 Liste ID_OldLeft;
 Liste ID_OldRight;
 Liste ID_NewLeft;
 Liste ID_NewRight;
 Liste ID_ListBuffer;
 Liste ID_ListNewBuffer;

 int N_OldLeft;
 int N_OldRight;
 int N_NewLeft;
 int N_NewRight;
 int N_ListBuffer;
 int N_ListNewBuffer;

 long Buffer;
 long Old,New;

 long *LineArray;
 long *VLJunctionArray;
 long *TLambdaJunctionArray;
 long *CollinearArray;
 long *TripletArray;

 int id[4];
 int jp1,jp2;
 int Start,End;
 int triplet_id;

 double center_col,center_row;
 double radius;
 double mean_length;
 double circumference;
 double length;
 double colbuffer;
 double rowbuffer;

 double JunctionPtCol;
 double JunctionPtRow;

 double ColBuffer[MAXSEGMENTS+1];
 double RowBuffer[MAXSEGMENTS+1];
 double SegmentBuffer[MAXSEGMENTS+1];

/*
=======================================================================
===================== START OF INITIALISATION =========================
=======================================================================
*/
 
/*
 Set defaults, process command line options, and initialise lists

*/
  Next  = 0;
  OutPutStatus = -1; /* All */
  Whistle = FALSE;     /* Whistle as you work */
  for (i=1;i<argc;i++) {
       if (argv[i][0] == '-') {
           switch (argv[i][1]) {

           case 't': Next++ ; OutPutStatus = 0; continue;
           case 'c': Next++ ; OutPutStatus = 1; continue;
           case 'p': Next++ ; OutPutStatus = 2; continue;
           case 'w': Next++ ; Whistle = TRUE ; continue;
	    case 'v': Next++; fprintf(stderr,"%s: Version 2.1\n",argv[0]); return(-1);
	    default : fprintf(stderr,"Error: unrecognized option: %s \n",argv[i]); return(-1);
	    case 'h':
 		fprintf(stderr,"USAGE :\n");
		fprintf(stderr," %s[-hvtcpw] < InFile > OutFile\n",argv[0]);
		fprintf(stderr,"WHERE:\n");
  		fprintf(stderr," -h Gives usage information\n");
  		fprintf(stderr," -v Gives version number\n");
		fprintf(stderr," -t Triplets only\n");
		fprintf(stderr," -c Corners  only\n");
		fprintf(stderr," -p Polygons only\n");
		fprintf(stderr," -w Whistle as you work (for polygons only)\n");
		fprintf(stderr," InFile should contain ASCII lists of line segments grouped by lpeg\n");
		fprintf(stderr," OutFile will contains separate ASCII lists for the following:\n");
		fprintf(stderr,"         Triplets of connected segments\n");
		fprintf(stderr,"         Y and T-Lambda Corners\n");
		fprintf(stderr,"         N-Sided Closed Polygons (N>=3)\n");
		return(-1); 
           }
        }
   }

/*
 Use standard input output I/O
*/

  InFile  = stdin ;     OutFile = stdout;


/*
 * Write out the original image dimensions at the top of the file
 */
        fgets(cbuf, 100, InFile);
        fprintf(OutFile,"%s",cbuf);

/*
 Read in LPEG data into linked lists

	LPEG Grouping	    |  Type
	==========================
	Line		    |    0
	CircularArc	    |    1
	OVParallel        |    2 
	NOVParallel       |    3 
	Collinear         |    4 
	L_Junctions       |    5 
	V_Junctions       |    6 
	T_Junctions       |    7 
	Lambda_Junctions  |    8 

*/

/*
 Create lists used for storing the data, and combine V and L junctions, 
 and T and Lambda junctions into single lists for the purposes of polygon
 finding
*/
    ID_ListORTLine 		= CreatList();
    CreateLPEGLists (InFile, 0, &ID_ListORTLine,   	&N_ListORTLine);
    WriteLPEGLists (OutFile, 0, ID_ListORTLine,        N_ListORTLine);

	 if (N_ListORTLine < 2){
 	    fprintf(stderr,"Error: Insufficient number of lines in the list\n");
	    return(-1);
	 }


    ID_ListBuffer 	= CreatList();
    CreateLPEGLists (InFile, 1, &ID_ListBuffer, &N_ListBuffer);
    WriteLPEGLists  (OutFile,1, ID_ListBuffer,   N_ListBuffer);
    DestList(&ID_ListBuffer); 

    ID_ListBuffer 	= CreatList();
    CreateLPEGLists (InFile, 2, &ID_ListBuffer, &N_ListBuffer);
    WriteLPEGLists  (OutFile,2, ID_ListBuffer,   N_ListBuffer);
    DestList(&ID_ListBuffer); 

    ID_ListBuffer 	= CreatList();
    CreateLPEGLists (InFile, 3, &ID_ListBuffer, &N_ListBuffer);
    WriteLPEGLists  (OutFile,3, ID_ListBuffer,   N_ListBuffer);
    DestList(&ID_ListBuffer); 

    ID_ListCollinear 	= CreatList();
    CreateLPEGLists (InFile, 4, &ID_ListCollinear, 	&N_ListCollinear);
    WriteLPEGLists (OutFile, 4, ID_ListCollinear,      N_ListCollinear);

    ID_ListLJunction 	= CreatList();
    CreateLPEGLists (InFile, 5, &ID_ListLJunction, 	&N_ListLJunction);
    WriteLPEGLists (OutFile, 5, ID_ListLJunction,      N_ListLJunction);

    ID_ListVJunction 	= CreatList();
    CreateLPEGLists (InFile, 6, &ID_ListVJunction, 	&N_ListVJunction);
    WriteLPEGLists (OutFile, 6, ID_ListVJunction,      N_ListVJunction);

    ID_ListTJunction 	= CreatList();
    CreateLPEGLists (InFile, 7, &ID_ListTJunction, 	&N_ListTJunction);
    WriteLPEGLists (OutFile, 7, ID_ListTJunction,      N_ListTJunction);

    ID_ListLambdaJunction 	= CreatList();
    CreateLPEGLists (InFile, 8, &ID_ListLambdaJunction, &N_ListLambdaJunction);
    WriteLPEGLists (OutFile, 8, ID_ListLambdaJunction, N_ListLambdaJunction);

/*
 If not enough data then terminate
*/
    if ( (N_ListVJunction + N_ListLJunction) <= 2) {
	fprintf(stderr," Insufficient number of junctions... \n");
	return(-1);
    }

/*
 Combine V & L and T & Lambda Junctions into new lists and get rid of the
 old lists.
*/

    ID_ListVLJunction = CreatList();
    ID_ListVLJunction = AppendList (ID_ListVJunction,ID_ListLJunction);
     N_ListVLJunction = (int) SizeList(ID_ListVLJunction);

    DestList(&ID_ListVJunction); DestList(&ID_ListLJunction);

    ID_ListTLambdaJunction = CreatList();
    ID_ListTLambdaJunction = AppendList (ID_ListTJunction,ID_ListLambdaJunction);
     N_ListTLambdaJunction = (int) SizeList(ID_ListTLambdaJunction);

    DestList(&ID_ListTJunction); DestList(&ID_ListLambdaJunction);

/*
 Sort the junction list in ascending order of ID
*/
	SortList (ID_ListVLJunction ,SortByIDVLJunctions);

/*
 Create empty lists for features to be grouped
*/

 ID_ListTriplet       	= CreatList();
 ID_ListYCorner       	= CreatList(); 
 ID_ListTLambdaCorner 	= CreatList(); 
 ID_ListClosedPolygon 	= CreatList();

/*
 Store lists as arrays for faster access
*/

 LineArray = (long *) calloc((N_ListORTLine+1),sizeof(long));
 for (i = 1; i <= N_ListORTLine ; i++) {
   Buffer = ElmNumList (ID_ListORTLine, (long) i);
   LineArray[i]= Buffer;
 }
 DestList(&ID_ListORTLine);

 VLJunctionArray = (long *) calloc((N_ListVLJunction+1),sizeof(long));
 for (i = 1; i <= N_ListVLJunction ; i++) {
   Buffer = ElmNumList (ID_ListVLJunction, (long) i);
   VLJunctionArray[i]= Buffer;
 }
 DestList(&ID_ListVLJunction);

 TLambdaJunctionArray = (long *) calloc((N_ListTLambdaJunction+1),sizeof(long));
 for (i = 1; i <= N_ListTLambdaJunction ; i++) {
   Buffer = ElmNumList (ID_ListTLambdaJunction, (long) i);
   TLambdaJunctionArray[i]= Buffer;
 }
 DestList(&ID_ListTLambdaJunction);

 CollinearArray = (long *) calloc((N_ListCollinear+1),sizeof(long));
 for (i = 1; i <= N_ListCollinear ; i++) {
   Buffer = ElmNumList (ID_ListCollinear, (long) i);
   CollinearArray[i]= Buffer;
 }
 DestList(&ID_ListCollinear);

/*
============================================================================
====================MAIN LOOP FOR FINDING TRIPLETS =========================
============================================================================
*/

/*
 We find the triplet by checking whether two junctions share a line segment
 using that the end points of this line segment are marked with different jp
 values (see LPEG.h) for each junction. For simplicity we always include the 
 ID of the shared segment in the middle of the triplet list of ID's. Note we 
 can exclude some cases since the junction list is sorted by ID number, and 
 therefore there are only 3 cases to consider. 
*/

if (OutPutStatus != 1) {

 for (i = 1; i <= N_ListVLJunction ; i++) {

     OldVLJunction = MACCast(ORTVJunction,VLJunctionArray[i]);

 for (j = (i+1); j <= N_ListVLJunction ; j++) {

      NewVLJunction = MACCast(ORTVJunction,VLJunctionArray[j]);

/*
  ******CASE 1******
*/
  if (OldVLJunction->FirstID == NewVLJunction->FirstID &&
      OldVLJunction->jp1     != NewVLJunction->jp1) {

      Line[1]= MACCast(ORTLine,LineArray[OldVLJunction->SecondID]);
      Line[2]= MACCast(ORTLine,LineArray[OldVLJunction->FirstID]);
      Line[3]= MACCast(ORTLine,LineArray[NewVLJunction->SecondID]);

/*
 Now find out if either of the two lines which connect to the middle segment 
 form a T or Lambda junction. If so reject this triplet. Otherwise include 
 the triplet in the list.
*/

	FoundTriplet = TRUE;
	for (k = 1; k <= N_ListTLambdaJunction ; k++) {

      		TLambdaJunction = MACCast(ORTTJunction,TLambdaJunctionArray[k]);

		if ( (Line[1]->ID == TLambdaJunction->FirstID  &&
		      Line[3]->ID == TLambdaJunction->SecondID) ||
		     (Line[1]->ID == TLambdaJunction->SecondID &&
		      Line[3]->ID == TLambdaJunction->FirstID) )
			FoundTriplet = FALSE;

	 } /* endfor k */

  if (FoundTriplet == TRUE) {

/*
 Now compute lengths
	a) Find the total length of the line segments, and subtract variances
	b) Find Total length of virtual lines
*/

      Triplet = MACAllocateMem(ORTTriplet);

      Triplet->SegmentID = (int *) calloc(4, sizeof(int));
      Triplet->SegmentID[1] = Line[1]->ID;
      Triplet->SegmentID[2] = Line[2]->ID;
      Triplet->SegmentID[3] = Line[3]->ID;

      	if (OldVLJunction->jp2 == 0) {
      		Triplet->Start.Col = Line[1]->End.Col;
      		Triplet->Start.Row = Line[1]->End.Row;
      	} else {
      		Triplet->Start.Col = Line[1]->Start.Col;
      		Triplet->Start.Row = Line[1]->Start.Row;
      	}

      	if (NewVLJunction->jp2 == 0) {
      		Triplet->End.Col = Line[3]->End.Col;
      		Triplet->End.Row = Line[3]->End.Row;
      	} else {
      		Triplet->End.Col = Line[3]->Start.Col;
      		Triplet->End.Row = Line[3]->Start.Row;
      	}

       Triplet->Junction = (struct ORTPoint *) calloc(3, sizeof(struct ORTPoint));
      	Triplet->Junction[1].Col = OldVLJunction->JunctionPt.Col;
      	Triplet->Junction[1].Row = OldVLJunction->JunctionPt.Row;
      	Triplet->Junction[2].Col = NewVLJunction->JunctionPt.Col;
      	Triplet->Junction[2].Row = NewVLJunction->JunctionPt.Row;

      Triplet->Length = 
	  Line[1]->Length + Line[2]->Length + Line[3]->Length;

      Triplet->VirtualLength = LineLength(Triplet->Start.Col,
		   				Triplet->Start.Row,
		   				OldVLJunction->JunctionPt.Col,
		   				OldVLJunction->JunctionPt.Row) +
				   LineLength(NewVLJunction->JunctionPt.Col,
		   				NewVLJunction->JunctionPt.Row,
		   				OldVLJunction->JunctionPt.Col,
		   				OldVLJunction->JunctionPt.Row) +
				   LineLength(Triplet->End.Col,
		   				Triplet->End.Row,
		   				NewVLJunction->JunctionPt.Col,
		   				NewVLJunction->JunctionPt.Row);

      Triplet->Quality = Triplet->Length/Triplet->VirtualLength;
      AddElmList (ID_ListTriplet, (long) Triplet);

      } /* if valid triplet */

    } /* endif case 1 */

/*
 ******CASE 2******
*/
    if (OldVLJunction->SecondID == NewVLJunction->SecondID &&
	 OldVLJunction->jp2      != NewVLJunction->jp2) {

      Line[1]= MACCast(ORTLine,LineArray[OldVLJunction->FirstID]);
      Line[2]= MACCast(ORTLine,LineArray[OldVLJunction->SecondID]);
      Line[3]= MACCast(ORTLine,LineArray[NewVLJunction->FirstID]);

/*
 Now find out if either of the two lines which connect to the middle segment 
 form a T or Lambda junction. If so reject this triplet. Otherwise include 
 the triplet in the list.
*/

	FoundTriplet = TRUE;
	for (k = 1; k <= N_ListTLambdaJunction ; k++) {

      		TLambdaJunction = MACCast(ORTTJunction,TLambdaJunctionArray[k]);

		if ( (Line[1]->ID == TLambdaJunction->FirstID  &&
		      Line[3]->ID == TLambdaJunction->SecondID) ||
		     (Line[1]->ID == TLambdaJunction->SecondID &&
		      Line[3]->ID == TLambdaJunction->FirstID) )
			FoundTriplet = FALSE;

	 } /* endfor k */

  if (FoundTriplet == TRUE) {

/*
 Now compute lengths
	a) Find the total length of the line segments, and subtract variances
	b) Find Total length of virtual lines
*/

      Triplet = MACAllocateMem(ORTTriplet);

      Triplet->SegmentID = (int *) calloc(4, sizeof(int));
      Triplet->SegmentID[1] = Line[1]->ID;
      Triplet->SegmentID[2] = Line[2]->ID;
      Triplet->SegmentID[3] = Line[3]->ID;

      	if (OldVLJunction->jp1 == 0) {
      		Triplet->Start.Col = Line[1]->End.Col;
      		Triplet->Start.Row = Line[1]->End.Row;
      	} else {
      		Triplet->Start.Col = Line[1]->Start.Col;
      		Triplet->Start.Row = Line[1]->Start.Row;
      	}

      	if (NewVLJunction->jp1 == 0) {
      		Triplet->End.Col = Line[3]->End.Col;
      		Triplet->End.Row = Line[3]->End.Row;
      	} else {
      		Triplet->End.Col = Line[3]->Start.Col;
      		Triplet->End.Row = Line[3]->Start.Row;
      	}

       Triplet->Junction = (struct ORTPoint *) calloc(3, sizeof(struct ORTPoint));
      	Triplet->Junction[1].Col = OldVLJunction->JunctionPt.Col;
      	Triplet->Junction[1].Row = OldVLJunction->JunctionPt.Row;
      	Triplet->Junction[2].Col = NewVLJunction->JunctionPt.Col;
      	Triplet->Junction[2].Row = NewVLJunction->JunctionPt.Row;

      Triplet->Length = 
	  Line[1]->Length + Line[2]->Length + Line[3]->Length;

      Triplet->VirtualLength = LineLength(Triplet->Start.Col,
		   				Triplet->Start.Row,
		   				OldVLJunction->JunctionPt.Col,
		   				OldVLJunction->JunctionPt.Row) +
				   LineLength(NewVLJunction->JunctionPt.Col,
		   				NewVLJunction->JunctionPt.Row,
		   				OldVLJunction->JunctionPt.Col,
		   				OldVLJunction->JunctionPt.Row) +
				   LineLength(Triplet->End.Col,
		   				Triplet->End.Row,
		   				NewVLJunction->JunctionPt.Col,
		   				NewVLJunction->JunctionPt.Row);

      Triplet->Quality = Triplet->Length/Triplet->VirtualLength;
      AddElmList (ID_ListTriplet, (long) Triplet);

      } /* if valid triplet */

    } /* endif case 2 */

/*
 ******CASE 3******
*/
  if (OldVLJunction->SecondID == NewVLJunction->FirstID &&
      OldVLJunction->jp2      != NewVLJunction->jp1) {

      Line[1]= MACCast(ORTLine,LineArray[OldVLJunction->FirstID]);
      Line[2]= MACCast(ORTLine,LineArray[OldVLJunction->SecondID]);
      Line[3]= MACCast(ORTLine,LineArray[NewVLJunction->SecondID]);

/*
 Now find out if either of the two lines which connect to the middle segment 
 form a T or Lambda junction. If so reject this triplet. Otherwise include 
 the triplet in the list.
*/

	FoundTriplet = TRUE;
	for (k = 1; k <= N_ListTLambdaJunction ; k++) {

      		TLambdaJunction = MACCast(ORTTJunction,TLambdaJunctionArray[k]);

		if ( (Line[1]->ID == TLambdaJunction->FirstID  &&
		      Line[3]->ID == TLambdaJunction->SecondID) ||
		     (Line[1]->ID == TLambdaJunction->SecondID &&
		      Line[3]->ID == TLambdaJunction->FirstID) )
			FoundTriplet = FALSE;

	 } /* endfor k */

  if (FoundTriplet == TRUE) {

/*
 Now compute lengths
	a) Find the total length of the line segments, and subtract variances
	b) Find Total length of virtual lines
*/

      Triplet = MACAllocateMem(ORTTriplet);

      Triplet->SegmentID = (int *) calloc(4, sizeof(int));
      Triplet->SegmentID[1] = Line[1]->ID;
      Triplet->SegmentID[2] = Line[2]->ID;
      Triplet->SegmentID[3] = Line[3]->ID;

      	if (OldVLJunction->jp1 == 0) {
      		Triplet->Start.Col = Line[1]->End.Col;
      		Triplet->Start.Row = Line[1]->End.Row;
      	} else {
      		Triplet->Start.Col = Line[1]->Start.Col;
      		Triplet->Start.Row = Line[1]->Start.Row;
      	}

      	if (NewVLJunction->jp2 == 0) {
      		Triplet->End.Col = Line[3]->End.Col;
      		Triplet->End.Row = Line[3]->End.Row;
      	} else {
      		Triplet->End.Col = Line[3]->Start.Col;
      		Triplet->End.Row = Line[3]->Start.Row;
      	}

       Triplet->Junction = (struct ORTPoint *) calloc(3, sizeof(struct ORTPoint));
      	Triplet->Junction[1].Col = OldVLJunction->JunctionPt.Col;
      	Triplet->Junction[1].Row = OldVLJunction->JunctionPt.Row;
      	Triplet->Junction[2].Col = NewVLJunction->JunctionPt.Col;
      	Triplet->Junction[2].Row = NewVLJunction->JunctionPt.Row;

      Triplet->Length = 
	  Line[1]->Length + Line[2]->Length + Line[3]->Length ;

      Triplet->VirtualLength = LineLength(Triplet->Start.Col,
		   				Triplet->Start.Row,
		   				OldVLJunction->JunctionPt.Col,
		   				OldVLJunction->JunctionPt.Row) +
				   LineLength(NewVLJunction->JunctionPt.Col,
		   				NewVLJunction->JunctionPt.Row,
		   				OldVLJunction->JunctionPt.Col,
		   				OldVLJunction->JunctionPt.Row) +
				   LineLength(Triplet->End.Col,
		   				Triplet->End.Row,
		   				NewVLJunction->JunctionPt.Col,
		   				NewVLJunction->JunctionPt.Row);

	 Triplet->Quality = Triplet->Length/Triplet->VirtualLength;
      	 AddElmList (ID_ListTriplet, (long) Triplet);

      } /* if valid triplet */

    } /* endif case 3 */

   } /* endfor j */

  } /* endfor i */

 N_ListTriplet = (int) SizeList(ID_ListTriplet);

/*
 Now sort the list in ascending order of the Middle ID number,
 and reassign ID numbers
*/

 SortList (ID_ListTriplet ,SortTripletsByID);
 for (i = 1; i <= N_ListTriplet; i++) {
        Buffer          = ElmNumList (ID_ListTriplet,(long) i);
        Triplet         = MACCast(ORTTriplet,Buffer);
        Triplet->ID   = i;
 }

 } /* endif outputstatus */

/*
============================================================================
====================MAIN LOOP FOR FINDING Corners  =========================
============================================================================
*/

if (OutPutStatus == -1 || OutPutStatus == 1) {


/*
 We find the corners by looking for sets of lines all of which form junctions 
 with each other. Using the end point labels we also check these segments 
 don't form any triplets.
*/
     Start = 1;
     N_ListYCorner = 0;
     N_ListTLambdaCorner = 0;

     while (Start <= N_ListVLJunction) {

	OldVLJunction = MACCast(ORTVJunction,VLJunctionArray[Start]);

/*
 First find a possible candidate for a corner
*/
	Start++;
	for (i = Start; i <= N_ListVLJunction; i++) {

	  FoundJunction = FALSE;	 

	  NewVLJunction = MACCast(ORTVJunction,VLJunctionArray[i]);
	 
	 	if (OldVLJunction->FirstID == NewVLJunction->FirstID &&
	     	    OldVLJunction->jp1     == NewVLJunction->jp1) {
			FoundJunction = TRUE;
			id[1] = OldVLJunction->FirstID;
			id[2] = OldVLJunction->SecondID;
			id[3] = NewVLJunction->SecondID;
			jp1   = OldVLJunction->jp2;
			jp2   = NewVLJunction->jp2;

	 	} /* endif foundjunction */

/*
 Check if all segments within the set form junctions with each other
*/
	   if (FoundJunction == TRUE) {
/*
 Now look for Y corners
*/

		for (j = i+1; j <= N_ListVLJunction ; j++) {

          		FoundYCorner = FALSE;
	 		VLJunction = MACCast(ORTVJunction,VLJunctionArray[j]);

			if ( (VLJunction->FirstID  == id[2] &&
			      VLJunction->SecondID == id[3]) ||
			     (VLJunction->FirstID  == id[3] &&
			      VLJunction->SecondID == id[2]) ) {

	 		  	if ( (VLJunction->jp1 == jp1 &&
			             VLJunction->jp2 == jp2))
					 FoundYCorner = TRUE;
			} /* endif foundcorner */

/*
 Include the new corner in the list
*/
	if (FoundYCorner == TRUE) {
      	    YCorner = MACAllocateMem(ORTCorner);
           N_ListYCorner++;
	    YCorner->ID = N_ListYCorner;

           YCorner->SegmentID = (int *) calloc(4, sizeof(int));
	    YCorner->SegmentID[1] = id[1];
	    YCorner->SegmentID[2] = id[2];
	    YCorner->SegmentID[3] = id[3];

           Line[1]= MACCast(ORTLine,LineArray[id[1]]);
           Line[2]= MACCast(ORTLine,LineArray[id[2]]);
           Line[3]= MACCast(ORTLine,LineArray[id[3]]);

		    center_col = (OldVLJunction->JunctionPt.Col +
		                  NewVLJunction->JunctionPt.Col +
		                     VLJunction->JunctionPt.Col)/3.0;
		    center_row = (OldVLJunction->JunctionPt.Row +
		                  NewVLJunction->JunctionPt.Row +
		                     VLJunction->JunctionPt.Row)/3.0;
		    radius     = 0.0;

		  if ( OldVLJunction->jp1 == 0) {
		       radius+= LineLength(center_col,
					      center_row,
					      Line[1]->Start.Col,
					      Line[1]->Start.Row);
		  } else {
		       radius+= LineLength(center_col,
					      center_row,
					      Line[1]->End.Col,
					      Line[1]->End.Row);
		  }

		  if ( OldVLJunction->jp2 == 0) {
		       radius+= LineLength(center_col,
					      center_row,
					      Line[2]->Start.Col,
					      Line[2]->Start.Row);
		  } else {
		       radius+= LineLength(center_col,
					      center_row,
					      Line[2]->End.Col,
					      Line[2]->End.Row);
		  }

		  if ( NewVLJunction->jp2 == 0) {
		       radius+= LineLength(center_col,
					      center_row,
					      Line[3]->Start.Col,
					      Line[3]->Start.Row);
		  } else {
		       radius+= LineLength(center_col,
					      center_row,
					      Line[3]->End.Col,
					      Line[3]->End.Row);
		  }

		    YCorner->Center.Col = center_col;
		    YCorner->Center.Row = center_row;
		    YCorner->Radius     = radius/3.0;
		    mean_length = (Line[1]->Length + 
				     Line[2]->Length +
				     Line[3]->Length)/3.0;
		    YCorner->Quality  = exp(-1.0*(YCorner->Radius/mean_length));
	    	    AddElmList (ID_ListYCorner, (long) YCorner);

       	} /* endif we have found a Y corner */
           } /* endfor j (vljunctions) */ 
/*
 Now look for TLambda corners
*/
   for (j = 1; j <= N_ListCollinear ; j++) {

   	FoundTLambdaCorner = FALSE;
	Collinear = MACCast(ORTCollinear,CollinearArray[j]);

	if ( (Collinear->FirstID  == id[2] &&
	      Collinear->SecondID == id[3]) ||
	     (Collinear->FirstID  == id[3] &&
	      Collinear->SecondID == id[2]) ) {
/*
 Now we make sure that the junction point is also closest to the "junction
 point" of the two collinear segments. Otherwise we would form a V or L 
 junction instead of a corner
*/
      		Line[2]= MACCast(ORTLine,LineArray[id[2]]);
      		Line[3]= MACCast(ORTLine,LineArray[id[3]]);

  	  	if (jp1 == 0 && jp2 == 0) {
		  if ((LineLength(Line[2]->Start.Col,  Line[2]->Start.Row,
			  	    Line[3]->Start.Col,  Line[3]->Start.Row) <=
		       LineLength(Line[2]->End.Col,    Line[2]->End.Row,
			  	    Line[3]->Start.Col,  Line[3]->Start.Row)) &&

		      (LineLength(Line[2]->Start.Col,  Line[2]->Start.Row,
			  	    Line[3]->Start.Col,  Line[3]->Start.Row) <=
		       LineLength(Line[3]->End.Col,    Line[3]->End.Row,
			  	    Line[2]->Start.Col,  Line[2]->Start.Row)) )
			FoundTLambdaCorner = TRUE;
		}

  	  	if (jp1 == 1 && jp2 == 1) {
		  if ((LineLength(Line[2]->End.Col,    Line[2]->End.Row,
			  	    Line[3]->End.Col,    Line[3]->End.Row) <=
		       LineLength(Line[2]->Start.Col,  Line[2]->Start.Row,
			  	    Line[3]->End.Col,    Line[3]->End.Row)) &&

		      (LineLength(Line[2]->End.Col,    Line[2]->End.Row,
			  	    Line[3]->End.Col,    Line[3]->End.Row) <=
		       LineLength(Line[3]->Start.Col,  Line[3]->Start.Row,
			  	    Line[2]->End.Col,    Line[2]->End.Row)) )
			FoundTLambdaCorner = TRUE;
		}

  	  	if (jp1 == 0 && jp2 == 1) {
		  if ((LineLength(Line[2]->Start.Col,  Line[2]->Start.Row,
			  	    Line[3]->End.Col,    Line[3]->End.Row) <=
		       LineLength(Line[2]->End.Col,    Line[2]->End.Row,
			  	    Line[3]->End.Col,    Line[3]->End.Row)) &&

		      (LineLength(Line[2]->Start.Col,  Line[2]->Start.Row,
			  	    Line[3]->End.Col,    Line[3]->End.Row) <=
		       LineLength(Line[3]->End.Col,    Line[3]->End.Row,
			  	    Line[2]->End.Col,    Line[2]->End.Row)) )
			FoundTLambdaCorner = TRUE;
		}

  	  	if (jp1 == 1 && jp2 == 0) {
		  if ((LineLength(Line[2]->End.Col,    Line[2]->End.Row,
			  	    Line[3]->Start.Col,  Line[3]->Start.Row) <=
		       LineLength(Line[2]->Start.Col,  Line[2]->Start.Row,
			  	    Line[3]->Start.Col,  Line[3]->Start.Row)) &&

		      (LineLength(Line[2]->End.Col,    Line[2]->End.Row,
			  	    Line[3]->Start.Col,  Line[3]->Start.Row) <=
		       LineLength(Line[3]->Start.Col,  Line[3]->Start.Row,
			  	    Line[2]->Start.Col,  Line[2]->Start.Row)) )
			FoundTLambdaCorner = TRUE;
		}


	} /* endif foundtlabmdacorner */

/*
 Include the new corner in the list
*/
	if (FoundTLambdaCorner == TRUE) {

      	    TLambdaCorner = MACAllocateMem(ORTCorner);
           N_ListTLambdaCorner++;
	    TLambdaCorner->ID = N_ListTLambdaCorner;

           TLambdaCorner->SegmentID = (int *) calloc(4, sizeof(int));
	    TLambdaCorner->SegmentID[1] = id[1];
	    TLambdaCorner->SegmentID[2] = id[2];
	    TLambdaCorner->SegmentID[3] = id[3];

      		Line[1] = MACCast(ORTLine,LineArray[id[1] ]);

		    center_col = (OldVLJunction->JunctionPt.Col +
		                  NewVLJunction->JunctionPt.Col)/2.0;
		    center_row = (OldVLJunction->JunctionPt.Row +
		                  NewVLJunction->JunctionPt.Row)/2.0;
		    radius     = 0.0;


		  if ( OldVLJunction->jp1 == 0) {
		       radius+= LineLength(center_col,
					      center_row,
					      Line[1]->Start.Col,
					      Line[1]->Start.Row);
		  } else {
		       radius+= LineLength(center_col,
					      center_row,
					      Line[1]->End.Col,
					      Line[1]->End.Row);
		  }

		  if ( OldVLJunction->jp2 == 0) {
		       radius+= LineLength(center_col,
					      center_row,
					      Line[2]->Start.Col,
					      Line[2]->Start.Row);
		  } else {
		       radius+= LineLength(center_col,
					      center_row,
					      Line[2]->End.Col,
					      Line[2]->End.Row);
		  }

		  if ( NewVLJunction->jp2 == 0) {
		       radius+= LineLength(center_col,
					      center_row,
					      Line[3]->Start.Col,
					      Line[3]->Start.Row);
		  } else {
		       radius+= LineLength(center_col,
					      center_row,
					      Line[3]->End.Col,
					      Line[3]->End.Row);
		  }

	    TLambdaCorner->Center.Col = center_col;
	    TLambdaCorner->Center.Row = center_row;
	    TLambdaCorner->Radius     = radius/3.0;
	    mean_length = (Line[1]->Length + 
			     Line[2]->Length +
			     Line[3]->Length)/3.0;
	    TLambdaCorner->Quality = exp(-1.0*(TLambdaCorner->Radius/mean_length));
	    AddElmList (ID_ListTLambdaCorner, (long) TLambdaCorner);

         } /* endif we have found a TLambda corner */
	} /* endfor j (collinear) */

	  } /* endif foundjunction */

       } /* endfor i */

   } /* endwhile */

 N_ListYCorner       = (int) SizeList(ID_ListYCorner);
 N_ListTLambdaCorner = (int) SizeList(ID_ListTLambdaCorner);

/*
 Now sort the lists in decending order of quality.
*/

 SortList (ID_ListYCorner 	    ,SortCornersByQuality);
 SortList (ID_ListTLambdaCorner ,SortCornersByQuality);

/*
 Reassign ID numbers
*/

 for (i = 1; i <= N_ListYCorner; i++) {
	Buffer  	= ElmNumList (ID_ListYCorner,(long) i);
	YCorner 	= MACCast(ORTCorner,Buffer);
	YCorner->ID 	= i;
 }

 for (i = 1; i <= N_ListTLambdaCorner; i++) {
	Buffer  	= ElmNumList (ID_ListTLambdaCorner,(long) i);
	TLambdaCorner 	= MACCast(ORTCorner,Buffer);
	TLambdaCorner->ID 	= i;
 }

 } /* endif outputstatus */

/*
============================================================================
====================MAIN LOOP FOR FINDING Polygons  ========================
============================================================================
*/

if (OutPutStatus == -1 || OutPutStatus == 2) {

  ID_ListBuffer = CopyList (ID_ListTriplet);
   N_ListBuffer = N_ListTriplet;

/*
 Now get rid of any triplets which are open at one end as they will 
 never form closed polygons
*/

FoundTriplet = TRUE;
while (FoundTriplet == TRUE) {

if (Whistle == TRUE)
fprintf(stderr,"POLYGONS: There are now %d Triplets to prune\n", N_ListBuffer); 

 FoundTriplet = FALSE;
 for (i = 1; i <= N_ListBuffer; i++) {

	Old = ElmNumList (ID_ListBuffer,(long) i);
	OldTriplet = MACCast(ORTTriplet,Old);

	  FoundLeftTriplet  = FALSE;
	  FoundRightTriplet = FALSE;
	  End		      = FALSE;

         New = FirstElmList (ID_ListBuffer);
	  for (j = 1; j <= N_ListBuffer && End == FALSE && 
  		      (FoundLeftTriplet  == FALSE ||
		       FoundRightTriplet == FALSE)
			; j++) {
   
	    NewTriplet = MACCast(ORTTriplet,New);

/*
 This checks for open-ness of  triplets
*/
		if (OldTriplet->SegmentID[1] == NewTriplet->SegmentID[2] &&
		    i != j) 
			FoundLeftTriplet = TRUE;

		if (OldTriplet->SegmentID[3] == NewTriplet->SegmentID[2] &&
		    i != j) 
			FoundRightTriplet = TRUE;

           	if (OldTriplet->SegmentID[3] < NewTriplet->SegmentID[2] &&
	           OldTriplet->SegmentID[1] < NewTriplet->SegmentID[2] &&
		    i != j)
			 End = TRUE;

         New = NextElmList (ID_ListBuffer);

	  } /* endfor j */

	if (FoundLeftTriplet == FALSE || FoundRightTriplet == FALSE) {
		DestElmList(ID_ListBuffer, (long) OldTriplet); 
		N_ListBuffer--;
		FoundTriplet = TRUE;	/* terminate inner loop */
	}

   } /* endfor i */

} /* endwhile */

/*
 Reassign ID's
*/

 for (i = 1; i <= N_ListBuffer; i++) {
        Buffer          = ElmNumList (ID_ListBuffer,(long) i);
        Triplet         = MACCast(ORTTriplet,Buffer);
        Triplet->ID   = i;
 }

/*
 Store lists as arrays for faster access
*/

 TripletArray = (long *) calloc((N_ListBuffer+1),sizeof(long));
 for (i = 1; i <= N_ListBuffer ; i++) {
   Buffer = ElmNumList (ID_ListBuffer, (long) i);
   TripletArray[i]= Buffer;
 }

 DestList(&ID_ListBuffer);

for (i = 1; i <= N_ListBuffer; i++) {

if (Whistle == TRUE)
fprintf(stderr,"POLYGONS: Processing Triplet %d \n",i);

/*
 Initialize parameters
*/
	OldTriplet = MACCast(ORTTriplet,TripletArray[i]);

 	ID_OldLeft  = CreatList();
 	ID_OldRight = CreatList();
 	ID_NewLeft  = CreatList();
 	ID_NewRight = CreatList();

       OldLeftOpenPolygon 	       = MACAllocateMem(ORTOpenPolygon);
       OldLeftOpenPolygon->NumID   = 1;
       OldLeftOpenPolygon->TripletID[0] = 0;
       OldLeftOpenPolygon->TripletID[OldLeftOpenPolygon->NumID] = OldTriplet->ID;
	OldLeftOpenPolygon->Start   = OldTriplet->SegmentID[1];
	OldLeftOpenPolygon->Middle  = OldTriplet->SegmentID[2];
	OldLeftOpenPolygon->End     = OldTriplet->SegmentID[3];

       OldRightOpenPolygon 	       = MACAllocateMem(ORTOpenPolygon);
       OldRightOpenPolygon->NumID  = 1;
       OldRightOpenPolygon->TripletID[0] = 0;
       OldRightOpenPolygon->TripletID[OldRightOpenPolygon->NumID] = OldTriplet->ID;
	OldRightOpenPolygon->Start  = OldTriplet->SegmentID[1];
	OldRightOpenPolygon->Middle = OldTriplet->SegmentID[2];
	OldRightOpenPolygon->End    = OldTriplet->SegmentID[3];

       AddElmList (ID_OldLeft, (long) OldLeftOpenPolygon);
       AddElmList (ID_OldRight,(long) OldRightOpenPolygon);
       N_OldLeft  = N_OldRight = 1;

  FoundLeftTriplet   = TRUE;
  FoundRightTriplet  = TRUE;
  FoundClosedPolygon = FALSE;

if (Whistle == TRUE)
fprintf(stderr,"POLYGONS: Initialization Complete\n");

  while (FoundLeftTriplet   == TRUE  && 
	  FoundRightTriplet  == TRUE  &&
         FoundClosedPolygon == FALSE &&
         N_OldLeft* N_OldRight  <= MAXBRANCHES) {

/*
 Now look for open polygons which can be extended to the left
*/

 FoundLeftTriplet = FALSE;
 for (j = 1; j <= N_OldLeft; j++) {

if (Whistle == TRUE)
fprintf(stderr,"POLYGONS: Processing Left Polygon %d\n",j);

	Old      	     = ElmNumList (ID_OldLeft,(long) j);
	OldLeftOpenPolygon = MACCast(ORTOpenPolygon,Old);
	FoundJunction      = TRUE;


  for (k = 1; (k <= N_ListBuffer && FoundJunction == TRUE); k++) {

    NewTriplet = MACCast(ORTTriplet,TripletArray[k]);

/* 
 Since the Triplets are sorted we need look no further than
 when this condition is satisfied.
*/
    if (NewTriplet->SegmentID[2] > OldLeftOpenPolygon->Start)
	 FoundJunction = FALSE;

    if (NewTriplet->ID != OldLeftOpenPolygon->TripletID[OldLeftOpenPolygon->NumID-1] &&
	 OldLeftOpenPolygon->NumID < (MAXTRIPLETS/2) 		&&
	 FoundJunction == TRUE 			   		&&
	 NewTriplet->SegmentID[1] == OldLeftOpenPolygon->Middle && 
        NewTriplet->SegmentID[2] == OldLeftOpenPolygon->Start) {

  NewLeftOpenPolygon = MACAllocateMem(ORTOpenPolygon);
  NewLeftOpenPolygon->Start  = OldLeftOpenPolygon->Start;
  NewLeftOpenPolygon->Middle = OldLeftOpenPolygon->Middle;
  NewLeftOpenPolygon->End    = OldLeftOpenPolygon->End;
  NewLeftOpenPolygon->NumID  = OldLeftOpenPolygon->NumID;
  for (n=0; n <= (MAXTRIPLETS+1); n++)
       NewLeftOpenPolygon->TripletID[n] = OldLeftOpenPolygon->TripletID[n];

       	NewLeftOpenPolygon->NumID   = OldLeftOpenPolygon->NumID + 1;
      		NewLeftOpenPolygon->TripletID[NewLeftOpenPolygon->NumID] = NewTriplet->ID;
		NewLeftOpenPolygon->Start   = NewTriplet->SegmentID[3];
		NewLeftOpenPolygon->Middle  = NewTriplet->SegmentID[2];
		NewLeftOpenPolygon->End     = NewTriplet->SegmentID[1];
       	AddElmList (ID_NewLeft,(long) NewLeftOpenPolygon);
 		FoundLeftTriplet = TRUE;
     }

     if (NewTriplet->ID != OldLeftOpenPolygon->TripletID[OldLeftOpenPolygon->NumID-1] &&
	  OldLeftOpenPolygon->NumID < (MAXTRIPLETS/2) 		 &&
	  FoundJunction == TRUE 			    		 &&
	  NewTriplet->SegmentID[3] == OldLeftOpenPolygon->Middle &&
         NewTriplet->SegmentID[2] == OldLeftOpenPolygon->Start) {

  NewLeftOpenPolygon = MACAllocateMem(ORTOpenPolygon);
  NewLeftOpenPolygon->Start  = OldLeftOpenPolygon->Start;
  NewLeftOpenPolygon->Middle = OldLeftOpenPolygon->Middle;
  NewLeftOpenPolygon->End    = OldLeftOpenPolygon->End;
  NewLeftOpenPolygon->NumID  = OldLeftOpenPolygon->NumID;
  for (n=0; n <= (MAXTRIPLETS+1); n++)
       NewLeftOpenPolygon->TripletID[n] = OldLeftOpenPolygon->TripletID[n];

       	NewLeftOpenPolygon->NumID   = OldLeftOpenPolygon->NumID + 1;
      		NewLeftOpenPolygon->TripletID[NewLeftOpenPolygon->NumID] = NewTriplet->ID;
		NewLeftOpenPolygon->Start   = NewTriplet->SegmentID[1];
		NewLeftOpenPolygon->Middle  = NewTriplet->SegmentID[2];
		NewLeftOpenPolygon->End     = NewTriplet->SegmentID[3];
       	AddElmList (ID_NewLeft,(long) NewLeftOpenPolygon);
 		FoundLeftTriplet = TRUE;
       }

   } /* endfor k (triplets) */

  } /* endfor j (open polygons) */

/*
 Now look for open polygons which can be extended to the right.
*/

 FoundRightTriplet  = FALSE;
 for (j = 1; j <= N_OldRight; j++) {

	Old      	      = ElmNumList (ID_OldRight, (long) j);
	OldRightOpenPolygon = MACCast(ORTOpenPolygon,Old);
	FoundJunction = TRUE;

if (Whistle == TRUE)
fprintf(stderr,"POLYGONS: Processing Right Polygon %d\n",j);

  for (k = 1; (k <= N_ListBuffer && FoundJunction == TRUE); k++) {

    NewTriplet = MACCast(ORTTriplet,TripletArray[k]);
/* 
 Since the Triplets are sorted we need look no further than
 when this condition is satisfied.
*/

    if (NewTriplet->SegmentID[2] > OldRightOpenPolygon->End)
	 FoundJunction = FALSE;

    if (NewTriplet->ID != OldRightOpenPolygon->TripletID[OldRightOpenPolygon->NumID-1] &&
	 OldRightOpenPolygon->NumID < (MAXTRIPLETS/2) 		 &&
	 FoundJunction == TRUE 					 &&
	 NewTriplet->SegmentID[1] == OldRightOpenPolygon->Middle &&
        NewTriplet->SegmentID[2] == OldRightOpenPolygon->End) {


  NewRightOpenPolygon = MACAllocateMem(ORTOpenPolygon);
  NewRightOpenPolygon->Start  = OldRightOpenPolygon->Start;
  NewRightOpenPolygon->Middle = OldRightOpenPolygon->Middle;
  NewRightOpenPolygon->End    = OldRightOpenPolygon->End;
  NewRightOpenPolygon->NumID  = OldRightOpenPolygon->NumID;
  for (n=0; n <= (MAXTRIPLETS+1); n++)
       NewRightOpenPolygon->TripletID[n] = OldRightOpenPolygon->TripletID[n];


       	NewRightOpenPolygon->NumID   = OldRightOpenPolygon->NumID + 1;
      		NewRightOpenPolygon->TripletID[NewRightOpenPolygon->NumID] = NewTriplet->ID;
		NewRightOpenPolygon->Start   = NewTriplet->SegmentID[1];
		NewRightOpenPolygon->Middle  = NewTriplet->SegmentID[2];
		NewRightOpenPolygon->End     = NewTriplet->SegmentID[3];
       	AddElmList (ID_NewRight,(long) NewRightOpenPolygon);
 		FoundRightTriplet = TRUE;
     }

     if (NewTriplet->ID != OldRightOpenPolygon->TripletID[OldRightOpenPolygon->NumID-1] &&
	  OldRightOpenPolygon->NumID < (MAXTRIPLETS/2) 		  &&
	  FoundJunction == TRUE 					  &&
	  NewTriplet->SegmentID[3] == OldRightOpenPolygon->Middle && 
         NewTriplet->SegmentID[2] == OldRightOpenPolygon->End) {

  NewRightOpenPolygon = MACAllocateMem(ORTOpenPolygon);
  NewRightOpenPolygon->Start  = OldRightOpenPolygon->Start;
  NewRightOpenPolygon->Middle = OldRightOpenPolygon->Middle;
  NewRightOpenPolygon->End    = OldRightOpenPolygon->End;
  NewRightOpenPolygon->NumID  = OldRightOpenPolygon->NumID;
  for (n=0; n <= (MAXTRIPLETS+1); n++)
       NewRightOpenPolygon->TripletID[n] = OldRightOpenPolygon->TripletID[n];

       	NewRightOpenPolygon->NumID   = OldRightOpenPolygon->NumID + 1;
      		NewRightOpenPolygon->TripletID[NewRightOpenPolygon->NumID] = NewTriplet->ID;
		NewRightOpenPolygon->Start   = NewTriplet->SegmentID[3];
		NewRightOpenPolygon->Middle  = NewTriplet->SegmentID[2];
		NewRightOpenPolygon->End     = NewTriplet->SegmentID[1];
       	AddElmList (ID_NewRight,(long) NewRightOpenPolygon);
 		FoundRightTriplet = TRUE;
       }

    } /* endfor k (triplets) */

   } /* endfor j (open polygons) */

/*
 Now look in the lists of left and right open polygons to see whether they 
 close. Ofcourse we don't need to check anything if no triplets were found 
 to extend the old ones.
*/

N_NewLeft  = (int) SizeList(ID_NewLeft);
N_NewRight = (int) SizeList(ID_NewRight);

if (Whistle == TRUE)
fprintf(stderr,"POLYGONS: Processing Open Polygons %d %d\r",N_NewLeft,N_NewRight);


   for (j = 1; j <= N_NewLeft; j++) {


     New     	          = ElmNumList (ID_NewLeft, (long) j);
     NewLeftOpenPolygon = MACCast(ORTOpenPolygon, New);

     for (k = 1; k <= N_NewRight ; k++) {


	New      	      = ElmNumList (ID_NewRight, (long) k);
	NewRightOpenPolygon = MACCast(ORTOpenPolygon,New);

	if (NewLeftOpenPolygon->NumID   >= MAXTRIPLETS/2 &&
 	    NewRightOpenPolygon->NumID  >= MAXTRIPLETS/2) {
		FoundClosedPolygon = TRUE;
	}

	if (NewLeftOpenPolygon->NumID  >= MAXTRIPLETS/2) {
	    if (DestElmList(ID_NewLeft,  (long) NewLeftOpenPolygon)  != ERRVI)
		N_NewLeft--;
	}

	if (NewRightOpenPolygon->NumID  >= MAXTRIPLETS/2) {
	    if (DestElmList(ID_NewRight, (long) NewRightOpenPolygon) != ERRVI)
		N_NewRight--;
	}
/*
 Now if the two arms meet we have identified a possible closed polygon.
*/

 	if (NewLeftOpenPolygon->NumID   < MAXTRIPLETS/2			 &&
	    NewRightOpenPolygon->NumID  < MAXTRIPLETS/2			 &&
	    
	   ((NewLeftOpenPolygon->Middle ==  NewRightOpenPolygon->Middle &&
	     NewLeftOpenPolygon->Start  ==  NewRightOpenPolygon->Start  &&
	     NewLeftOpenPolygon->End    ==  NewRightOpenPolygon->End    &&
            NewLeftOpenPolygon->NumID  ==  NewRightOpenPolygon->NumID))) {

/*
 Now expand the triplets as segments, and add them to the
 closed polygon list
*/
	ClosedPolygon         = MACAllocateMem(ORTClosedPolygon);
	ClosedPolygon->NumSeg = 0;
	ClosedPolygon->NumJct = 0;

  	for (l = 1; l <= NewLeftOpenPolygon->NumID; l++) {

	    Triplet = MACCast(ORTTriplet,TripletArray[NewLeftOpenPolygon->TripletID[l]]);

  	    ClosedPolygon->NumSeg++; 
	    ClosedPolygon->SegmentID[ClosedPolygon->NumSeg] = Triplet->SegmentID[2];

  	    ClosedPolygon->NumJct++; 
	    ClosedPolygon->JunctionPt[ClosedPolygon->NumJct].Col = Triplet->Junction[1].Col;
	    ClosedPolygon->JunctionPt[ClosedPolygon->NumJct].Row = Triplet->Junction[1].Row;

  	    ClosedPolygon->NumJct++; 
	    ClosedPolygon->JunctionPt[ClosedPolygon->NumJct].Col = Triplet->Junction[2].Col;
	    ClosedPolygon->JunctionPt[ClosedPolygon->NumJct].Row = Triplet->Junction[2].Row;

        }

	  for (l = (NewRightOpenPolygon->NumID - 1); l >= 1 ; l--) {

      	    Triplet = MACCast(ORTTriplet,TripletArray[NewRightOpenPolygon->TripletID[l]]);

  	    ClosedPolygon->NumSeg++; 
	    ClosedPolygon->SegmentID[ClosedPolygon->NumSeg] = Triplet->SegmentID[2];

  	    ClosedPolygon->NumJct++; 
	    ClosedPolygon->JunctionPt[ClosedPolygon->NumJct].Col = Triplet->Junction[1].Col;
	    ClosedPolygon->JunctionPt[ClosedPolygon->NumJct].Row = Triplet->Junction[1].Row;

  	    ClosedPolygon->NumJct++; 
	    ClosedPolygon->JunctionPt[ClosedPolygon->NumJct].Col = Triplet->Junction[2].Col;
	    ClosedPolygon->JunctionPt[ClosedPolygon->NumJct].Row = Triplet->Junction[2].Row;
        }

/*
 Now make sure that none of the Virtual lines composing the Polygon
 cross. This is to avoid shapes like this:

               ------
               |    |
               |
               |--------
                        |
                        |
                    ----
 
 being accepted as polygons
*/

 PrunePolygon = FALSE;
 for (l = 1; l <= ClosedPolygon->NumJct-1 && PrunePolygon == FALSE; l+=2)  {

   for (m = 1; m <= ClosedPolygon->NumJct-1 && PrunePolygon == FALSE; m+=2) {

	if (l != m &&  
	ClosedPolygon->JunctionPt[l].Col   != ClosedPolygon->JunctionPt[m].Col   &&
	ClosedPolygon->JunctionPt[l].Row   != ClosedPolygon->JunctionPt[m].Row   &&
	ClosedPolygon->JunctionPt[l+1].Col != ClosedPolygon->JunctionPt[m+1].Col &&
	ClosedPolygon->JunctionPt[l+1].Row != ClosedPolygon->JunctionPt[m+1].Row &&
	InterceptPt(ClosedPolygon->JunctionPt[l].Col,
             	     ClosedPolygon->JunctionPt[l].Row,
             	     ClosedPolygon->JunctionPt[l+1].Col,
             	     ClosedPolygon->JunctionPt[l+1].Row,
		     ClosedPolygon->JunctionPt[m].Col,
                   ClosedPolygon->JunctionPt[m].Row,
                   ClosedPolygon->JunctionPt[m+1].Col,
                   ClosedPolygon->JunctionPt[m+1].Row,
                   &JunctionPtCol,&JunctionPtRow) == 1) {
					PrunePolygon = TRUE;
					free(ClosedPolygon);
	} /* endif */
   } /* endfor m */
 } /* endfor l */

 if (PrunePolygon == FALSE) {

if (Whistle == TRUE)
fprintf(stderr,"POLYGONS: Pruning Detected Polygons\n");

/* 
 Now make sure that the polygon does not have internal loops by ensuring that
 the number of junctions is the same as the number of segments. This is
 to avoid cases like this:

             -----                -----
            |     |              |     |
             -----                -----
                  |              |
                  |              |
                   --------------
*/

    for (l = 1 ;l < ClosedPolygon->NumSeg; l++) {
	    for (m = l+1 ;m < ClosedPolygon->NumSeg; m++) {

        if (ClosedPolygon->SegmentID[l] == ClosedPolygon->SegmentID[m])
	     ClosedPolygon->SegmentID[m] = 0;

    } /* endfor m */
  } /* endfor l */

/* 
 Remove any duplicate segments 
*/

    Start = 0;
    for (l = 1 ;l <= ClosedPolygon->NumSeg; l++) {		
      if (ClosedPolygon->SegmentID[l] != 0) {
         	Start++;
	  	SegmentBuffer[Start] =ClosedPolygon->SegmentID[l];
      } /* endif */
    } /* endfor l */

    ClosedPolygon->NumSeg = Start - 1;

    for (l = 1 ;l <= ClosedPolygon->NumSeg; l++) {		
	  	ClosedPolygon->SegmentID[l] = SegmentBuffer[l] ;
    } /* endfor l */

/*
 Now a similar procedure for the junctions
*/

    for (l = 1 ;l <= ClosedPolygon->NumJct; l++) {
	    for (m = l+1 ;m < ClosedPolygon->NumJct; m++) {

        if (ClosedPolygon->JunctionPt[l].Col == 
	     ClosedPolygon->JunctionPt[m].Col &&
            ClosedPolygon->JunctionPt[l].Row == 
            ClosedPolygon->JunctionPt[m].Row) {
	      ClosedPolygon->JunctionPt[m].Col = -999999.0;
	      ClosedPolygon->JunctionPt[m].Row = -999999.0;
	 } /* endif */

      } /* endfor m */
    } /* endfor l */

/* 
 Remove any duplicate junctions
*/
    Start = 0;
    for (l = 1 ;l <= ClosedPolygon->NumJct; l++) {		
      if (ClosedPolygon->JunctionPt[l].Col !=  -999999.0 &&
          ClosedPolygon->JunctionPt[l].Row !=  -999999.0) {
         	Start++;
	  	ColBuffer[Start] =ClosedPolygon->JunctionPt[l].Col;
	  	RowBuffer[Start] =ClosedPolygon->JunctionPt[l].Row;
      } /* endif */
    } /* endfor l */

    ClosedPolygon->NumJct = Start - 1;

    for (l = 1 ;l <= ClosedPolygon->NumJct; l++) {		
	  	ClosedPolygon->JunctionPt[l].Col = ColBuffer[l] ;
	  	ClosedPolygon->JunctionPt[l].Row = RowBuffer[l];
    } /* endfor l */

/*
 Here we prune the polygons with internal loops
*/

    if (ClosedPolygon->NumSeg == ClosedPolygon->NumJct) {
   	AddElmList (ID_ListClosedPolygon, (long) ClosedPolygon);
       FoundClosedPolygon = TRUE;
    } else {
	free(ClosedPolygon);
    }

  } /* endif prunepolygon == false */

       } /* endif (foundclosedpolygon) */

     } /* endfor k (right) */

   } /* endfor j (left) */

if (Whistle == TRUE)
fprintf(stderr,"POLYGONS: Cleaning up before next step\n");

/*
 Destroy the old lists and swap them with the new ones
*/

  ID_OldLeft  = CopyList(ID_NewLeft);
  ID_OldRight = CopyList(ID_NewRight);

  DestList(&ID_NewLeft);
  DestList(&ID_NewRight);
  ID_NewLeft  = CreatList();
  ID_NewRight = CreatList();

  N_OldLeft  = (int) SizeList(ID_OldLeft);
  N_OldRight = (int) SizeList(ID_OldRight);
  N_NewLeft  = 0;
  N_NewRight = 0;

 } /* end while */

  DestList(&ID_OldLeft);
  DestList(&ID_OldRight);
  DestList(&ID_NewLeft);
  DestList(&ID_NewRight);

} /* endfor i */

/*
 Now sort the polygons in ascending order of NumSeg and get rid of any:

	1. Duplicate polygons
	2. Or polygons which fully contain other smaller polygons
          (ie the set of segments forming the smaller polygon is 
           a sub-set of the segment-set for the larger polygon).
*/

N_ListClosedPolygon = (int) SizeList(ID_ListClosedPolygon);
 SortList (ID_ListClosedPolygon ,SortPolygonsByNumSeg);

 for (i = 1 ; i <= N_ListClosedPolygon; i++) {

  Old              = ElmNumList (ID_ListClosedPolygon, (long) i);
  OldClosedPolygon = MACCast(ORTClosedPolygon, Old);

if (Whistle == TRUE)
fprintf(stderr,"POLYGONS: Pruning Closed Polygon %d\n",i);

     NDuplicate = 0;   
     for (j = i+1 ; j <= N_ListClosedPolygon; j++) {

      New              = ElmNumList (ID_ListClosedPolygon, (long) j);
      NewClosedPolygon = MACCast(ORTClosedPolygon, New);
	
      	n = m = 0;
	for (k = 1; k <= NewClosedPolygon->NumSeg; k++) {
	  for (l = 1; l <= OldClosedPolygon->NumSeg; l++) {
	    if (OldClosedPolygon->SegmentID[l] ==
		 NewClosedPolygon->SegmentID[k] &&
	        NewClosedPolygon->NumSeg > OldClosedPolygon->NumSeg) 
	        n++;
	    if (OldClosedPolygon->SegmentID[l] ==
		 NewClosedPolygon->SegmentID[k] &&
               NewClosedPolygon->NumSeg == OldClosedPolygon->NumSeg) 
	        m++;
         }
       }
/*
 New polygon fully contains old one
*/
	if (n == OldClosedPolygon->NumSeg) { 
	    if (DestElmList(ID_ListClosedPolygon, (long) NewClosedPolygon) != ERRVI)
		 N_ListClosedPolygon--; j--;
       }

/*
 New polygon is a duplicate of the old one
*/
	if (m == OldClosedPolygon->NumSeg)  {
        if (DestElmList(ID_ListClosedPolygon, (long) NewClosedPolygon) != ERRVI)
            N_ListClosedPolygon--; j--;
            NDuplicate++;
       }

   } /* endfor j */


} /* endfor i */

/*
 Now we rank the hypotheses according to their quality factor, which is the
 ratio of the polygon circumference to the length of the segments composing it.
*/

for (i = 1; i <= N_ListClosedPolygon; i++) {


  	Buffer        = ElmNumList (ID_ListClosedPolygon, (long) i);
	ClosedPolygon = MACCast(ORTClosedPolygon, Buffer);
       circumference = 0.0;
       length        = 0.0;

   for (j = 1; j <= ClosedPolygon->NumSeg; j++) {

	Line[1] = MACCast(ORTLine, LineArray[ClosedPolygon->SegmentID[j]]);
	length        += Line[1]->Length;

       if (j <  ClosedPolygon->NumSeg) {
	circumference += LineLength(ClosedPolygon->JunctionPt[j].Col,
					ClosedPolygon->JunctionPt[j].Row,
					ClosedPolygon->JunctionPt[j+1].Col,
					ClosedPolygon->JunctionPt[j+1].Row);
       } else {
	circumference += LineLength(ClosedPolygon->JunctionPt[j].Col,
					ClosedPolygon->JunctionPt[j].Row,
					ClosedPolygon->JunctionPt[1].Col,
					ClosedPolygon->JunctionPt[1].Row);
	}

    } /* endfor j */


 ClosedPolygon->Quality = length/circumference;

} /* endfor i */

} /* endif outputstatus */
/*
=======================================================================
======================== OUTPUTTING RESULTS ===========================
=======================================================================
*/
 
/*
	First the set of triplets
*/
if (Whistle == TRUE)
fprintf(stderr,"\n");

if (OutPutStatus == -1 || OutPutStatus == 0) {
 
 fprintf(OutFile,"#\n");
 fprintf(OutFile,"#Triplet\n");
 fprintf(stderr,"  Number of Triplets = %d\n",N_ListTriplet);

 for (i=1; i<=N_ListTriplet ; i++) {
      Buffer  = ElmNumList ( ID_ListTriplet, (long) i);
      Triplet = MACCast(ORTTriplet,Buffer);
      fprintf(OutFile,"%d %d %d %d %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",
					Triplet->ID,
					Triplet->SegmentID[1],
					Triplet->SegmentID[2],
					Triplet->SegmentID[3],
					Triplet->Start.Col,
					Triplet->Start.Row,
					Triplet->End.Col,
					Triplet->End.Row,
					Triplet->Junction[1].Col,
					Triplet->Junction[1].Row,
					Triplet->Junction[2].Col,
					Triplet->Junction[2].Row,
					Triplet->Length,
					Triplet->VirtualLength,
					Triplet->Quality);
   }

 } /* endif outputstatus */

/*
	 Now the set of Y corners
*/

if (OutPutStatus == -1 || OutPutStatus == 1) {

 fprintf(OutFile,"#\n");
 fprintf(OutFile,"#Y_Corner\n");
 fprintf(stderr,"  Number of Y Corners = %d\n",N_ListYCorner);

 for (i=1; i<=N_ListYCorner ; i++) {
      Buffer  = ElmNumList ( ID_ListYCorner, (long) i);
      YCorner = MACCast(ORTCorner,Buffer);

      fprintf(OutFile,"%d %d %d %d %lf %lf %lf %lf\n",
					YCorner->ID,
					YCorner->SegmentID[1],
					YCorner->SegmentID[2],
					YCorner->SegmentID[3],
					YCorner->Center.Col,
					YCorner->Center.Row,
					YCorner->Radius,
					YCorner->Quality);
  }

/*
 Now the T-Lambda corners
*/

 fprintf(OutFile,"#\n");
 fprintf(OutFile,"#TLambda_Corner\n");
 fprintf(stderr,"  Number of TLambda Corners = %d\n",N_ListTLambdaCorner);

 for (i=1; i<=N_ListTLambdaCorner ; i++) {
      Buffer  = ElmNumList ( ID_ListTLambdaCorner, (long) i);
      TLambdaCorner = MACCast(ORTCorner,Buffer);

      fprintf(OutFile,"%d %d %d %d %lf %lf %lf %lf\n",
					TLambdaCorner->ID,
					TLambdaCorner->SegmentID[1],
					TLambdaCorner->SegmentID[2],
					TLambdaCorner->SegmentID[3],
					TLambdaCorner->Center.Col,
					TLambdaCorner->Center.Row,
					TLambdaCorner->Radius,
					TLambdaCorner->Quality);
  }

 } /* endif outputstatus */

/*
	 Now the set of closed polygons
*/

if (OutPutStatus == -1 || OutPutStatus == 2) {

 fprintf(OutFile,"#\n");
 fprintf(OutFile,"#ClosedPolygon\n");
 fprintf(stderr,"  Number of Closed Polygons = %d\n",N_ListClosedPolygon);

 for (i=1; i<=N_ListClosedPolygon ; i++) {

      Buffer  = ElmNumList ( ID_ListClosedPolygon, (long) i);
      ClosedPolygon = MACCast(ORTClosedPolygon,Buffer);

      		fprintf(OutFile,"%d ",ClosedPolygon->NumSeg);
	for (j = 1; j <= ClosedPolygon->NumSeg ; j++) {
      		fprintf(OutFile,"%d ",ClosedPolygon->SegmentID[j]);
       }

      		fprintf(OutFile,"%d ",ClosedPolygon->NumJct);

	for (j = 1; j <= ClosedPolygon->NumJct ; j++) {
      		fprintf(OutFile,"%lf %lf ",ClosedPolygon->JunctionPt[j].Col,
					      ClosedPolygon->JunctionPt[j].Row);
       }
      		fprintf(OutFile,"%lf\n",ClosedPolygon->Quality);
  }

 }  /* endif outputstatus */


/*
 Free memory used by lists and arrays
*/

	 free(LineArray);
	 free(VLJunctionArray);
	 free(TLambdaJunctionArray);
	 free(CollinearArray);
	 free(TripletArray);

	  DestList(&ID_ListTriplet);
	  DestList(&ID_ListYCorner);
	  DestList(&ID_ListClosedPolygon);

	  return(0);
}

