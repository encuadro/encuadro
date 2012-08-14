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

Name : lpeg
Version: 2.0
Written on   : 14-Dec-90     By : A. Etemadi
Modified on  : 12-Dec-91     By : A. Etemadi
Modified on  : 16-Feb-93     By : A. Etemadi
  1. Modified junction loop to stop n*n search
  2. Modified output to include all computed parameters (Quality etc...
  3. Fixed bug in CheckParallelCollinear
  4. Added warning messages when the Quality factor exceeds 1.0 which
     can be invoked with -DGiveWarning
  5. Changed definition of Lambda junction so that we check to see if the
     end points of the lines are close (suggested by KCW)
  6. Changed quality factors so they're always < 1.0 and > 0.0
  7. Added StringID to line parameteres, and removed the RC factor altogether
  8. Fixed problem due to bug in cc compiler.
  9. Added options for outputting results
 10. Quality factor for L/V junctions changed so that it is now additive
 11. Now default driven and gives help with -h switch
 12. Added option to consider collinear lines as real lines
 14. Added support for rectangular images
 15. Fixed problem with not being able to pipe
 
Directory    : ~atae/ORT/LPEG/exe

==============================================================================

Usage:
        LPEG -[l p1] [-t p2] [-q p3] < InFile > OutFile

Command line parameters:

p1 = MinLineLength      -- Minimum acceptable line length
p2 = MinDeltaTheta      -- The angle between two lines. This parameter
                           decides which lines maybe parallel/collinear,
p3 = MinQuality -- Minimum acceptable Quality level

 
Output result       : 

   0 = successful, 
  -1 = error, 

Functionality: 

This program groups line features extracted from an image. The groupings 
are:

	NonOverlapping Parallel lines
	Overlapping Parallel lines
	Collinear lines
	L junctions
	V junctions
	T junctions
	Lambda junctions

See LPEG.ps for fuller details.

***
Note X junctions are not implemented at this level since Edge detectors 
always break junctions 
****

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

 FILE *p_InFile;		/* Pointers to start of files fo I/O */
 FILE *p_OutFile;

 int i,j,k;			/* Loop indecies */
 int Status;			/* Status flag */
 int OutPutStatus;		/* Output Status flag */
 int CollinearToReal;	/* Consider Collinear lines as "real" lines */
 int Next;			/* Next argument */
 int Number;

 char cbuf[100];
/* 
Number of lines in corresponding lists 

*/
 int N_ListORTLine;		  /* ORT line data */
 int N_ListORTCircularArc;	  /* ORT arc data */
 int N_ListORTParallelNOV;	  /* ORT Parallel non-overlapping line data */
 int N_ListORTParallelOV;	  /* ORT Parallel overlapping line data */
 int N_ListORTCollinear;	  /* ORT collinear line data */
 int N_ListORTLJunction;	  /* ORT L junction data */
 int N_ListORTVJunction;	  /* ORT V junction data */
 int N_ListORTTJunction;	  /* ORT T junction data */
 int N_ListORTLambdaJunction; /* ORT Lambda junction data */

 int N_ListCollinearLine;	  /* Collinear lines considered as "real" */

/* 
 ID numbers of appropriate lists 

*/
 Liste ID_ListORTLine;	
 Liste ID_ListORTCircularArc;	
 Liste ID_ListORTParallelNOV;
 Liste ID_ListORTParallelOV;
 Liste ID_ListORTCollinear;
 Liste ID_ListORTLJunction;
 Liste ID_ListORTVJunction;
 Liste ID_ListORTTJunction;
 Liste ID_ListORTLambdaJunction;
/*
 Pointers to lists

*/

 struct VirtualLine        	*VLine;
 struct ORTLine        	*CollinearLine;

 struct ORTLine        	*ListORTLine;
 struct ORTCircularArc     	*ListORTCircularArc;
 struct ORTParallelNOV 	*ListORTParallelNOV;
 struct ORTParallelOV  	*ListORTParallelOV;
 struct ORTCollinear   	*ListORTCollinear;
 struct ORTLJunction   	*ListORTLJunction;
 struct ORTVJunction   	*ListORTVJunction;
 struct ORTTJunction   	*ListORTTJunction;
 struct ORTLambdaJunction   *ListORTLambdaJunction;

/*
 Command line parameters

*/
 double MinLineLength;
 double MinDeltaThetaPC;
 double MinDeltaThetaJ;
 double MinDeltaTheta;

 double MinQualityPC;
 double MinQualityJ;
 double MinQuality;

 double MaxWidthOverHeight;
 double WidthOverHeight;

 long Line;			/* Buffers for elements in the Lists */
 long Arc;
 long Line1;
 long Line2;
 long Junction;

 struct ORTLine        	*BufferLine1;
 struct ORTLine        	*BufferLine2;

 double JunctionPtCol;	/* Junction point parameters */
 double JunctionPtRow;

 double DeltaTheta;		/* Dummy variable */
 double Quality;		/* Quality associated with grouping */

 int ID1,ID2;			/* Buffer to store line IDs */
 int jp1,jp2;			/* Buffer to store closest junction pt indicator */

 Liste ID_ListBuffer;
 long Buffer;

/*
=======================================================================
===================== START OF INITIALISATION =========================
=======================================================================
*/
 
/*
 Set defaults, process command line options, and initialise lists

*/

  Next = 0;
  CollinearToReal = FALSE;
  MaxWidthOverHeight = 2.0;
  MinLineLength      = 8.0;
  MinDeltaTheta      = 0.06;
  MinQuality		= 0.8;
  OutPutStatus 	= -1;  /* All */
  for (i=1;i<argc;i++) {
       if (argv[i][0] == '-') {
           switch (argv[i][1]) {
           case 'p': Next++; OutPutStatus = 0; continue;
           case 'j': Next++; OutPutStatus = 1; continue;
           case 'r': Next++; OutPutStatus = 2; continue;
           case 'c': Next++; OutPutStatus = 3; continue;
           case 'g': Next++; CollinearToReal = TRUE; continue;
           case 'w': Next+=2; MaxWidthOverHeight = ((double)atof(argv[++i])); continue;
           case 'l': Next+=2; MinLineLength      = ((double)atof(argv[++i])); continue ;
           case 't': Next+=2; MinDeltaTheta      = ((double)atof(argv[++i])); continue ;
           case 'q': Next+=2; MinQuality         = ((double)atof(argv[++i])); continue ;
	    case 'v': Next++; fprintf(stderr,"%s: Version 2.0\n",argv[0]); return(-1);
	    default : fprintf(stderr,"Error: unrecognized option: %s \n",argv[i]); return(-1);
           case 'h': 
fprintf(stderr,"USAGE :\n");
fprintf(stderr," %s [-hvpgjrck] [-w p0 ] [-l p1] [-t p2] [-q p3] < InFile > OutFile\n",argv[0]);
fprintf(stderr,"WHERE:\n");
fprintf(stderr," -h Gives usage information\n");
fprintf(stderr," -v Gives version number\n");
fprintf(stderr," -p Paral. only              -r Paral./Colin. only \n");
fprintf(stderr," -c Junctions/Colin. only    -j Junctions only\n");
fprintf(stderr," -g Consider Collinear lines as real lines when forming junctions\n");
fprintf(stderr," -q Minimum allowed quality factor\n");
fprintf(stderr," -w Max(Width/Height) for Overlap. = Min(Width/Height) for NonOverlap. Parallel\n");
fprintf(stderr," p0: inf >  Max(Width/Height) >  0.0           default: 2.0\n");
fprintf(stderr," p1:        MinLineLength     >= 0.0 (pixels)  default: 8.0\n");
fprintf(stderr," p2: 0.1 >= MinDeltaTheta     >= 0.0 (radians) default: 0.06\n");
fprintf(stderr," p3: 1.0 >= MinQuality        >= 0.0           default: 0.8\n");
fprintf(stderr," InFile should contain an ASCII list of line segments in fex format\n");
fprintf(stderr," OutFile will contain an ASCII list of line segments and groupings.\n"); 
return(-1);

           }
        }
   }
	if (MaxWidthOverHeight < 0.0) {
	 	fprintf(stderr,"Error: Minimum Width/Height must be >= 0.0\n");
		return(-1);
	}

	if (MinLineLength < 4.0) {
	 	fprintf(stderr,"Error: MinLineLength must be  >= 4.0\n");
		return(-1);
	}

	MinDeltaThetaPC = MinDeltaThetaJ = MinDeltaTheta;

	if (MinDeltaThetaPC > 0.1) {
	 	fprintf(stderr,"Error: MinDeltaThetaParallel/Collinear must be <= 0.1radians\n");
		return(-1);
	}

	if (MinDeltaThetaJ > 0.1) {
	 	fprintf(stderr,"Error: MinDeltaThetaJunctions must be <= 0.1radians\n");
		return(-1);
	}

	MinQualityPC = MinQualityJ = MinQuality;

	if (MinQualityPC < 0.0 || MinQualityPC > 1.0) {
	 	fprintf(stderr,"Error: MinQuality level for parallel lines must be >= 0.0 and <= 1.0\n");
		return(-1);
	}

	if (MinQualityJ < 0.0 || MinQualityJ > 1.0) {
	 	fprintf(stderr,"Error: MinQuality level for junc. must be >= 0.0 and <= 1.0\n");
		return(-1);
	}

/*
 Use standard input output I/O

*/

  p_InFile  = stdin ;     p_OutFile = stdout;

/*
 * Write out the original image dimensions at the top of the file
 */
	fgets(cbuf, 100, p_InFile);
	fprintf(p_OutFile,"%s",cbuf);

/*
 Read in ORTLine data filtered by length and store in a linked list.

*/
        CrtORTLineList( &p_InFile,
			   MinLineLength,
                        &ListORTLine,
                        &ID_ListORTLine,
			   &N_ListORTLine);

        CrtORTCircularArcList( &p_InFile,
                        	   &ListORTCircularArc,
                               &ID_ListORTCircularArc,
			          &N_ListORTCircularArc);

	 if (N_ListORTLine < 2){
 		fprintf(stderr,"Error: Insufficient number of lines in the list\n");
		return(-1);
	}

/*
 Copy the list to a buffer to speedup processing
*/

 ID_ListBuffer = CopyList (ID_ListORTLine);

/*
 Create empty lists for features to be grouped

*/

 ID_ListORTParallelNOV      = CreatList();
 ID_ListORTParallelOV       = CreatList();
 ID_ListORTCollinear        = CreatList();
 ID_ListORTLJunction        = CreatList();
 ID_ListORTVJunction        = CreatList();
 ID_ListORTTJunction        = CreatList();
 ID_ListORTLambdaJunction   = CreatList();

 N_ListORTParallelNOV    = 0;
 N_ListORTParallelOV     = 0;
 N_ListORTCollinear      = 0;
 N_ListORTLJunction      = 0;
 N_ListORTVJunction      = 0;
 N_ListORTTJunction      = 0;
 N_ListORTLambdaJunction = 0;

/*
=======================================================================
===================== PARALLEL/COLLINEAR ==============================
=======================================================================
*/

/*
 Find which pairs of lines Maybe 

||||	Overlapping parallel, 		||||
||||   non-overlapping parallel, or 	||||
||||	collinear				||||

 By checking the ACUTE angle between the lines. Note when we get to the end 
 of the list we wrap around back to the start. 

*/

 Line1 = FirstElmList(ID_ListORTLine);  

 for (i = 1; i <= N_ListORTLine ; i++) {

   j = i;  DeltaTheta = 0.0; k = 0;

  if (OutPutStatus == -1 || OutPutStatus == 0 || 
      OutPutStatus ==  2 || OutPutStatus == 3 || CollinearToReal == TRUE) {

   while (DeltaTheta <= MinDeltaThetaPC && k < N_ListORTLine ) {

	   j++; if ( j > N_ListORTLine ) j = 1; k++;
	
   if ( j != i) {

     Line2 = ElmNumList ( ID_ListBuffer, (long) j);
     DeltaTheta =  fabs(  MACCast(ORTLine,Line1)->Theta - 
			     MACCast(ORTLine,Line2)->Theta);

     if (DeltaTheta >  PIBY2) DeltaTheta = fabs(PI - DeltaTheta);
/* 
 Lines maybe parallel (overlapping/non-overlapping) or collinear 

*/
      if (DeltaTheta <= MinDeltaThetaPC) { 
          VLine = MACAllocateMem(VirtualLine); 
  	   Status = CheckParallelOrCollinear(
			   	    MACCast(ORTLine,Line1),
				    MACCast(ORTLine,Line2),
				    VLine,
				    MinQualityPC,
				    &WidthOverHeight,
				    &Quality);

            switch (Status) {

	     case -1:

	     break;

            case 0:		/* Parallel non-overlapping lines */

               ListORTParallelNOV = MACAllocateMem(ORTParallelNOV); 
		 ListORTParallelNOV->FirstID    = MACCast(ORTLine,Line1)->ID;
		 ListORTParallelNOV->SecondID   = MACCast(ORTLine,Line2)->ID;
		 ListORTParallelNOV->VLLine     = *VLine;
		 ListORTParallelNOV->WidthOverHeight = WidthOverHeight;
		 ListORTParallelNOV->Quality         = Quality;

               AddElmList( ID_ListORTParallelNOV, (long)ListORTParallelNOV );
               N_ListORTParallelNOV++;

            break;

            case 1:		/* Parallel overlapping lines */

               ListORTParallelOV = MACAllocateMem(ORTParallelOV);
		 ListORTParallelOV->FirstID    = MACCast(ORTLine,Line1)->ID;
		 ListORTParallelOV->SecondID   = MACCast(ORTLine,Line2)->ID;
		 ListORTParallelOV->VLLine     = *VLine;
		 ListORTParallelOV->WidthOverHeight = WidthOverHeight;
		 ListORTParallelOV->Quality         = Quality;

               AddElmList( ID_ListORTParallelOV, (long)ListORTParallelOV );
               N_ListORTParallelOV++;

            break;

            case 2:		/* Collinear lines */

               ListORTCollinear = MACAllocateMem(ORTCollinear); 
		 ListORTCollinear->FirstID    = MACCast(ORTLine,Line1)->ID;
		 ListORTCollinear->SecondID   = MACCast(ORTLine,Line2)->ID;
		 ListORTCollinear->VLLine     = *VLine;
		 ListORTCollinear->Quality    = Quality;

               AddElmList( ID_ListORTCollinear, (long)ListORTCollinear );
               N_ListORTCollinear++;

	     break;

		} /* j != i */

            } /* End switch */

      } /* Endif DeltaTheta */

   } /* End while */

 } /* End OutPutStatus */

/*
=======================================================================
===================== JUNCTION TYPES ==================================
=======================================================================
*/
/*
 Find which pairs of lines Maybe 

||||	L or T 	 		||||

 By checking the angle between the lines. For Junctions the angle (thetamin)
 is derived from that used for Parallel/Collinear lines. In the case of L/T
 junctions the angle is PIBY2 - MinDeltaThetaJ -- PIBY2 + MinDeltaThetaJ. In the
 case of V/Lambda junctions it is MinDeltaThetaJ -- PIBY2 - MinDeltaThetaJ and
 PIBY2 + MinDeltaThetaJ -- PI - MinDeltaThetaJ. Note when we get to the end 
 of the list we wrap around back to the start. 

*/

if (OutPutStatus == -1 || OutPutStatus == 1 || 
    OutPutStatus == 3  || OutPutStatus == 4 || CollinearToReal == TRUE) {

   for (j = (i+1); j <= N_ListORTLine ; j++) {

     Line2 = ElmNumList ( ID_ListBuffer, (long) j);
     DeltaTheta =  fabs(  MACCast(ORTLine,Line1)->Theta - 
			     MACCast(ORTLine,Line2)->Theta);
/* 
 Lines maybe T or L junctions

*/
      if (DeltaTheta <= (PIBY2 + MinDeltaThetaJ) &&
          DeltaTheta >= (PIBY2 - MinDeltaThetaJ) ) { 

  	   Status = CheckJunctionType(
			   	    MACCast(ORTLine,Line1),
				    MACCast(ORTLine,Line2),
				    &jp1,
				    &jp2,
				    &JunctionPtCol,
				    &JunctionPtRow,
				    MinQualityJ,
				    &Quality);

              if (Status == 0 || Status == 4) {		/* L junction */

               ListORTLJunction = MACAllocateMem(ORTLJunction); 
		 ListORTLJunction->FirstID    = MACCast(ORTLine,Line1)->ID;
		 ListORTLJunction->SecondID   = MACCast(ORTLine,Line2)->ID;
		 ListORTLJunction->ip         = Status;
		 ListORTLJunction->jp1        = jp1;
		 ListORTLJunction->jp2        = jp2;
		 ListORTLJunction->JunctionPt.Col = JunctionPtCol;
		 ListORTLJunction->JunctionPt.Row = JunctionPtRow;
		 ListORTLJunction->Quality        = Quality;

               AddElmList( ID_ListORTLJunction, (long)ListORTLJunction );
               N_ListORTLJunction++;

              }

              if (Status > 0 && Status != 4) { /* T junction */
               ListORTTJunction = MACAllocateMem(ORTTJunction); 
		 ListORTTJunction->FirstID    = MACCast(ORTLine,Line1)->ID;
		 ListORTTJunction->SecondID   = MACCast(ORTLine,Line2)->ID;
		 ListORTTJunction->ip         = Status;
		 ListORTTJunction->jp1        = jp1;
		 ListORTTJunction->jp2        = jp2;
		 ListORTTJunction->JunctionPt.Col = JunctionPtCol;
		 ListORTTJunction->JunctionPt.Row = JunctionPtRow;
		 ListORTTJunction->Quality        = Quality;

               AddElmList( ID_ListORTTJunction, (long)ListORTTJunction );
               N_ListORTTJunction++;

              }

       } /* Endif DeltaTheta */
/*
 Find which pairs of lines Maybe 

||||	V or Lambda 	 		||||

 By checking the angle between the lines. For Junctions the angle (thetamin)
 is derived from that used for Parallel/Collinear lines. In the case of L/T
 junctions the angle is PIBY2 - MinDeltaThetaJ -- PIBY2 + MinDeltaThetaJ. In the
 case of V/Lambda junctions it is MinDeltaThetaJ -- PIBY2 - MinDeltaThetaJ and
 PIBY2 + MinDeltaThetaJ -- PI - MinDeltaThetaJ. Note when we get to the end 
 of the list we wrap around back to the start. 

*/

/* 
 Lines maybe V or Lambda junctions

*/
     if (DeltaTheta >  PIBY2) DeltaTheta = fabs(PI - DeltaTheta);

      if (DeltaTheta <= (PIBY2 - MinDeltaThetaJ) &&
          DeltaTheta >= (MinDeltaThetaJ) ) { 

  	   Status = CheckJunctionType(
			   	    MACCast(ORTLine,Line1),
				    MACCast(ORTLine,Line2),
				    &jp1,
				    &jp2,
		 		    &JunctionPtCol,
		 		    &JunctionPtRow,
				    MinQualityJ,
				    &Quality);

              if (Status == 0 || Status == 4) {		/* V junction */

               ListORTVJunction = MACAllocateMem(ORTVJunction); 
		 ListORTVJunction->FirstID    = MACCast(ORTLine,Line1)->ID;
		 ListORTVJunction->SecondID   = MACCast(ORTLine,Line2)->ID;
		 ListORTVJunction->ip         = Status;
		 ListORTVJunction->jp1        = jp1;
		 ListORTVJunction->jp2        = jp2;
		 ListORTVJunction->JunctionPt.Col = JunctionPtCol;
		 ListORTVJunction->JunctionPt.Row = JunctionPtRow;
		 ListORTVJunction->Quality        = Quality;

               AddElmList( ID_ListORTVJunction, (long)ListORTVJunction );
               N_ListORTVJunction++;

              }

              if (Status > 0 && Status != 4) {		/* Lambda junction */

               ListORTLambdaJunction = MACAllocateMem(ORTLambdaJunction); 
		 ListORTLambdaJunction->FirstID    = MACCast(ORTLine,Line1)->ID;
		 ListORTLambdaJunction->SecondID   = MACCast(ORTLine,Line2)->ID;
		 ListORTLambdaJunction->ip         = Status;
		 ListORTLambdaJunction->jp1        = jp1;
		 ListORTLambdaJunction->jp2        = jp2;
		 ListORTLambdaJunction->JunctionPt.Col = JunctionPtCol;
		 ListORTLambdaJunction->JunctionPt.Row = JunctionPtRow;
		 ListORTLambdaJunction->Quality        = Quality;

               AddElmList( ID_ListORTLambdaJunction, (long)ListORTLambdaJunction );
               N_ListORTLambdaJunction++;

              }

      } /* Endif DeltaTheta */

    } /* End for j */

  } /* End OutPutStatus */

   Line1 = NextElmList(ID_ListORTLine);

} /* End for i */

/*
=======================================================================
	 Consider Collinear lines as real lines
=======================================================================

 Take pairs of collinear lines and combine them into new hypothesized lines.
 This is so we can take into account collinearities when it comes to finding
 triplets and polygons.
*/

if (CollinearToReal == TRUE) {

  N_ListCollinearLine = N_ListORTLine;
  for (i = 1; i <= N_ListORTCollinear; i++) {

      	Buffer = ElmNumList (ID_ListORTCollinear, (long) i);
      	ListORTCollinear = MACCast(ORTCollinear,Buffer);
      	N_ListORTLine++;
      	CollinearLine = MACAllocateMem(ORTLine);
      	CollinearLine->ID 		= N_ListORTLine;
      	CollinearLine->StringID 	= -1; /* not valid for these */
      	CollinearLine->Start.Col 	= ListORTCollinear->VLLine.Start.Col;
      	CollinearLine->Start.Row 	= ListORTCollinear->VLLine.Start.Row;
      	CollinearLine->End.Col 	= ListORTCollinear->VLLine.End.Col;
      	CollinearLine->End.Row 	= ListORTCollinear->VLLine.End.Row;
      	CollinearLine->MidPoint.Col = (CollinearLine->Start.Col +
					   CollinearLine->End.Col)/2.0;
      	CollinearLine->MidPoint.Row = (CollinearLine->Start.Row +
					   CollinearLine->End.Row)/2.0;
      	CollinearLine->Length 	= ListORTCollinear->VLLine.Length;
      	CollinearLine->LengthPerpVar= LineLengthPerpVar();
      	CollinearLine->LengthParlVar= LineLengthParlVar();
      	CollinearLine->Theta 	= ListORTCollinear->VLLine.Theta;
      	CollinearLine->ThetaVar 	= LineSegThetaVar(CollinearLine->Length);
       AddElmList (ID_ListORTLine, (long) CollinearLine);

  } /* endfor i */

/*
 Now create the new junctions including collinearities
*/
 for (i = N_ListCollinearLine; i <= N_ListORTLine ; i++) {

   Line1 = ElmNumList (ID_ListORTLine, (long) i);  

   for (j = 1; j <= N_ListORTLine ; j++) {

    if (i != j) {

     Line2 = ElmNumList (ID_ListORTLine, (long) j);  

     DeltaTheta =  fabs(  MACCast(ORTLine,Line1)->Theta - 
			     MACCast(ORTLine,Line2)->Theta);
/* 
 Lines maybe T or L junctions
*/
      if (DeltaTheta <= (PIBY2 + MinDeltaThetaJ) &&
          DeltaTheta >= (PIBY2 - MinDeltaThetaJ) ) { 

  	   Status = CheckJunctionType(
			   	    MACCast(ORTLine,Line1),
				    MACCast(ORTLine,Line2),
				    &jp1,
				    &jp2,
				    &JunctionPtCol,
				    &JunctionPtRow,
				    MinQualityJ,
				    &Quality);

              if (Status == 0 || Status == 4) {		/* L junction */

               ListORTLJunction = MACAllocateMem(ORTLJunction); 
		 ListORTLJunction->FirstID    = MACCast(ORTLine,Line1)->ID;
		 ListORTLJunction->SecondID   = MACCast(ORTLine,Line2)->ID;
		 ListORTLJunction->ip         = Status;
		 ListORTLJunction->jp1        = jp1;
		 ListORTLJunction->jp2        = jp2;
		 ListORTLJunction->JunctionPt.Col = JunctionPtCol;
		 ListORTLJunction->JunctionPt.Row = JunctionPtRow;
		 ListORTLJunction->Quality        = Quality;

               AddElmList( ID_ListORTLJunction, (long)ListORTLJunction );
               N_ListORTLJunction++;

              }

              if (Status > 0 && Status != 4) { /* T junction */
               ListORTTJunction = MACAllocateMem(ORTTJunction); 
		 ListORTTJunction->FirstID    = MACCast(ORTLine,Line1)->ID;
		 ListORTTJunction->SecondID   = MACCast(ORTLine,Line2)->ID;
		 ListORTTJunction->ip         = Status;
		 ListORTTJunction->jp1        = jp1;
		 ListORTTJunction->jp2        = jp2;
		 ListORTTJunction->JunctionPt.Col = JunctionPtCol;
		 ListORTTJunction->JunctionPt.Row = JunctionPtRow;
		 ListORTTJunction->Quality        = Quality;

               AddElmList( ID_ListORTTJunction, (long)ListORTTJunction );
               N_ListORTTJunction++;

              }

       } /* Endif DeltaTheta */

/* 
 Lines maybe V or Lambda junctions

*/
     if (DeltaTheta >  PIBY2) DeltaTheta = fabs(PI - DeltaTheta);

      if (DeltaTheta <= (PIBY2 - MinDeltaThetaJ) &&
          DeltaTheta >= (MinDeltaThetaJ) ) { 

  	   Status = CheckJunctionType(
			   	    MACCast(ORTLine,Line1),
				    MACCast(ORTLine,Line2),
				    &jp1,
				    &jp2,
		 		    &JunctionPtCol,
		 		    &JunctionPtRow,
				    MinQualityJ,
				    &Quality);

              if (Status == 0 || Status == 4) {		/* V junction */

               ListORTVJunction = MACAllocateMem(ORTVJunction); 
		 ListORTVJunction->FirstID    = MACCast(ORTLine,Line1)->ID;
		 ListORTVJunction->SecondID   = MACCast(ORTLine,Line2)->ID;
		 ListORTVJunction->ip         = Status;
		 ListORTVJunction->jp1        = jp1;
		 ListORTVJunction->jp2        = jp2;
		 ListORTVJunction->JunctionPt.Col = JunctionPtCol;
		 ListORTVJunction->JunctionPt.Row = JunctionPtRow;
		 ListORTVJunction->Quality        = Quality;

               AddElmList( ID_ListORTVJunction, (long)ListORTVJunction );
               N_ListORTVJunction++;

              }

              if (Status > 0 && Status != 4) {		/* Lambda junction */

               ListORTLambdaJunction = MACAllocateMem(ORTLambdaJunction); 
		 ListORTLambdaJunction->FirstID    = MACCast(ORTLine,Line1)->ID;
		 ListORTLambdaJunction->SecondID   = MACCast(ORTLine,Line2)->ID;
		 ListORTLambdaJunction->ip         = Status;
		 ListORTLambdaJunction->jp1        = jp1;
		 ListORTLambdaJunction->jp2        = jp2;
		 ListORTLambdaJunction->JunctionPt.Col = JunctionPtCol;
		 ListORTLambdaJunction->JunctionPt.Row = JunctionPtRow;
		 ListORTLambdaJunction->Quality        = Quality;

               AddElmList( ID_ListORTLambdaJunction, (long)ListORTLambdaJunction );
               N_ListORTLambdaJunction++;

              }

      } /* Endif DeltaTheta */

     } /* if i != j */

   } /* End for j */

 } /* End for i */

} /* endif collineartoreal */

/*
=======================================================================
===================== OUTPUTING RESULTS ===============================
=======================================================================
*/
/* 
 Put headers in data file so 
	DisplayGrp : Program used to display the groupings
	InsertLowLevelTokens : Program used to insert tokens into Oracle
 Can read the individual groupings

*/
	fprintf(p_OutFile,"#Lines\n");
	for (i = 1 ; i <= N_ListORTLine ; i++) {
	 Line = ElmNumList ( ID_ListORTLine, (long)i);
        ListORTLine = MACCast(ORTLine,Line);

        fprintf(p_OutFile,"%d %d %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",
			ListORTLine->ID,
			ListORTLine->StringID,
			ListORTLine->Start.Col,
			ListORTLine->Start.Row,
			ListORTLine->End.Col,
			ListORTLine->End.Row,
			ListORTLine->MidPoint.Col,
			ListORTLine->MidPoint.Row,
			ListORTLine->Length,
			ListORTLine->LengthParlVar,
			ListORTLine->LengthPerpVar,
                     ListORTLine->Theta,
                     ListORTLine->ThetaVar);
       }


 	fprintf(p_OutFile,"#\n");
 	fprintf(p_OutFile,"#CircularArcs\n");

	for (i=1; i<=N_ListORTCircularArc; i++) {
      	    Arc  	  = ElmNumList ( ID_ListORTCircularArc, (long) i);
      	    ListORTCircularArc = MACCast(ORTCircularArc,Arc);

	fprintf(p_OutFile,"%d %d %d %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",
	 ListORTCircularArc->ID,
        ListORTCircularArc->StringID,
        ListORTCircularArc->Direction,
	 ListORTCircularArc->Origin.Col, 	 
	 ListORTCircularArc->Origin.Row, 	 
	 ListORTCircularArc->Start.Col, 	 
	 ListORTCircularArc->Start.Row, 	 
	 ListORTCircularArc->MidPoint.Col,   
	 ListORTCircularArc->MidPoint.Row,   
	 ListORTCircularArc->End.Col, 	 
	 ListORTCircularArc->End.Row, 	 
	 ListORTCircularArc->VLPoint.Col, 	 
	 ListORTCircularArc->VLPoint.Row, 	 
	 ListORTCircularArc->Radius, 	 
	 ListORTCircularArc->Length, 	 
	 ListORTCircularArc->LengthParlVar,  
	 ListORTCircularArc->LengthPerpVar,
	 ListORTCircularArc->Width,
	 ListORTCircularArc->Height, 	 
	 ListORTCircularArc->Theta);
   }

/*
 Now output the parallel/collinear data
*/
  
  if (OutPutStatus == -1 || OutPutStatus == 0 || OutPutStatus == 2) { 

	fprintf(p_OutFile,"#\n");
	fprintf(p_OutFile,"#OVParallel\n");

	Number = 0;
	for (i = 1 ; i <= N_ListORTParallelOV ; i++) {

	     Line = ElmNumList ( ID_ListORTParallelOV, (long)i);
            ListORTParallelOV = MACCast(ORTParallelOV,Line);
            ID1 = ListORTParallelOV->FirstID;
            ID2 = ListORTParallelOV->SecondID;

	     if (ListORTParallelOV->WidthOverHeight <= MaxWidthOverHeight) {
	     Number++;
	     fprintf(p_OutFile,"%d %d %lf %lf %lf %lf %lf %lf %lf %lf\n",
				ID1,ID2,
				ListORTParallelOV->VLLine.Start.Col,
				ListORTParallelOV->VLLine.Start.Row,
				ListORTParallelOV->VLLine.End.Col,
				ListORTParallelOV->VLLine.End.Row,
				ListORTParallelOV->VLLine.Length,
				ListORTParallelOV->VLLine.Theta,
				ListORTParallelOV->WidthOverHeight,
				ListORTParallelOV->Quality);
            }
       }
       fprintf(stderr," Number of Parallel OV pairs =  %d \n",
	                 Number);
} /* Output Status */

  if (OutPutStatus == -1 || OutPutStatus == 0 || OutPutStatus == 2) { 

	fprintf(p_OutFile,"#\n");
	fprintf(p_OutFile,"#NOVParallel\n");

	Number = 0;
	for ( i = 1 ; i <= N_ListORTParallelNOV ; i++) {

	     Line = ElmNumList ( ID_ListORTParallelNOV, (long)i);
            ListORTParallelNOV = MACCast(ORTParallelNOV,Line);
            ID1 = ListORTParallelNOV->FirstID;
            ID2 = ListORTParallelNOV->SecondID;

 	     if (ListORTParallelNOV->WidthOverHeight <= MaxWidthOverHeight) {
	     Number++;
	     fprintf(p_OutFile,"%d %d %lf %lf %lf %lf %lf %lf %lf %lf\n",
				ID1,ID2,
				ListORTParallelNOV->VLLine.Start.Col,
				ListORTParallelNOV->VLLine.Start.Row,
				ListORTParallelNOV->VLLine.End.Col,
				ListORTParallelNOV->VLLine.End.Row,
				ListORTParallelNOV->VLLine.Length,
				ListORTParallelNOV->VLLine.Theta,
				ListORTParallelNOV->WidthOverHeight,
				ListORTParallelNOV->Quality);
            }
       }
       fprintf(stderr," Number of Parallel NOV pairs =  %d \n",
	                 Number);
 } /* Output Status */

  if (OutPutStatus == 2 || OutPutStatus == 3 || OutPutStatus == -1) { 

	fprintf(p_OutFile,"#\n");
	fprintf(p_OutFile,"#Collinear\n");

       fprintf(stderr," Number of Collinear pairs =  %d \n",
		          N_ListORTCollinear);	

	for ( i = 1 ; i <= N_ListORTCollinear ; i++) {

	     Line = ElmNumList ( ID_ListORTCollinear, (long)i);
            ListORTCollinear = MACCast(ORTCollinear,Line);
            ID1 = ListORTCollinear->FirstID;
            ID2 = ListORTCollinear->SecondID;
	     fprintf(p_OutFile,"%d %d %lf %lf %lf %lf %lf %lf %lf\n",
				ID1,ID2,
				ListORTCollinear->VLLine.Start.Col,
				ListORTCollinear->VLLine.Start.Row,
				ListORTCollinear->VLLine.End.Col,
				ListORTCollinear->VLLine.End.Row,
				ListORTCollinear->VLLine.Length,
				ListORTCollinear->VLLine.Theta,
				ListORTCollinear->Quality);
       }

   } /* OutPut Status */

/*
 Now the Junctions
*/

  if (OutPutStatus == 1  || OutPutStatus == 3 || OutPutStatus == -1) { 

	fprintf(p_OutFile,"#\n");
	fprintf(p_OutFile,"#L_Junctions\n");

       fprintf(stderr," Number of L junctions =  %d \n", 
		          N_ListORTLJunction);	

	for (i = 1 ; i <= N_ListORTLJunction ; i++) {

	     Line = ElmNumList ( ID_ListORTLJunction, (long)i);
            ListORTLJunction = MACCast(ORTLJunction,Line);
            ID1 = ListORTLJunction->FirstID;
            ID2 = ListORTLJunction->SecondID;
	     fprintf(p_OutFile,"%d %d %d %d %d %lf %lf %lf\n",
				ID1,ID2,
				ListORTLJunction->ip,
				ListORTLJunction->jp1,
				ListORTLJunction->jp2,
				ListORTLJunction->JunctionPt.Col,
				ListORTLJunction->JunctionPt.Row,
				ListORTLJunction->Quality);
       }

 } /* Output Status */

  if (OutPutStatus == 1 || OutPutStatus == 3 || OutPutStatus == -1) { 

	fprintf(p_OutFile,"#\n");
	fprintf(p_OutFile,"#V_Junctions\n");

       fprintf(stderr," Number of V junctions =  %d \n",
		          N_ListORTVJunction);	

	for (i = 1; i <= N_ListORTVJunction ; i++) {

	     Line = ElmNumList ( ID_ListORTVJunction, (long)i);
            ListORTVJunction = MACCast(ORTVJunction,Line);
            ID1 = ListORTVJunction->FirstID;
            ID2 = ListORTVJunction->SecondID;
	     fprintf(p_OutFile,"%d %d %d %d %d %lf %lf %lf\n",
				ID1,ID2,
				ListORTVJunction->ip,
				ListORTVJunction->jp1,
				ListORTVJunction->jp2,
				ListORTVJunction->JunctionPt.Col,
				ListORTVJunction->JunctionPt.Row,
				ListORTVJunction->Quality);
       }
 } /* Output Status */

  if (OutPutStatus == 1 || OutPutStatus == 3 || OutPutStatus == -1) { 

	fprintf(p_OutFile,"#\n");
	fprintf(p_OutFile,"#T_Junctions\n");

       fprintf(stderr," Number of T junctions =  %d \n",
		          N_ListORTTJunction);	

	for (i = 1 ; i <= N_ListORTTJunction ; i++) {

	     Line = ElmNumList ( ID_ListORTTJunction, (long)i);
            ListORTTJunction = MACCast(ORTTJunction,Line);
            ID1 = ListORTTJunction->FirstID;
            ID2 = ListORTTJunction->SecondID;
	     fprintf(p_OutFile,"%d %d %d %d %d %lf %lf %lf\n",
				ID1,ID2,
				ListORTTJunction->ip,
				ListORTTJunction->jp1,
				ListORTTJunction->jp2,
				ListORTTJunction->JunctionPt.Col,
				ListORTTJunction->JunctionPt.Row,
				ListORTTJunction->Quality);
       }
 } /* Output Status */

  if (OutPutStatus == 1 || OutPutStatus == 3 || OutPutStatus == -1) { 

	fprintf(p_OutFile,"#\n");
	fprintf(p_OutFile,"#Lambda_Junctions\n");

       fprintf(stderr," Number of Lambda junctions =  %d \n",
			   N_ListORTLambdaJunction);	

	for (i = 1 ; i <= N_ListORTLambdaJunction; i++) {

	     Line = ElmNumList ( ID_ListORTLambdaJunction, (long)i);
            ListORTLambdaJunction = MACCast(ORTLambdaJunction,Line);
            ID1 = ListORTLambdaJunction->FirstID;
            ID2 = ListORTLambdaJunction->SecondID;
	     fprintf(p_OutFile,"%d %d %d %d %d %lf %lf %lf\n",
				ID1,ID2,
				ListORTLambdaJunction->ip,
				ListORTLambdaJunction->jp1,
				ListORTLambdaJunction->jp2,
				ListORTLambdaJunction->JunctionPt.Col,
				ListORTLambdaJunction->JunctionPt.Row,
				ListORTLambdaJunction->Quality);
       }
   } /* OutPut Status */

/*
 Close all files
*/
         fclose(p_InFile);
         fclose(p_OutFile);
/*
 Free memory used by lists
*/

	  DestList(&ID_ListBuffer);	
	  DestList(&ID_ListORTLine);	
	  DestList(&ID_ListORTParallelNOV);
	  DestList(&ID_ListORTParallelOV);
	  DestList(&ID_ListORTCollinear);
	  DestList(&ID_ListORTLJunction);
	  DestList(&ID_ListORTVJunction);
	  DestList(&ID_ListORTTJunction);
	  DestList(&ID_ListORTLambdaJunction);

	  return(0);
}
