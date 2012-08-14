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

Name : ort2image
Version: 1.0
Written on   :  5-Apr-92     By : A. Etemadi
Modified on  :  16-Feb-93    By : A. Etemadi

	Added rectangular image support

Directory    : ~atae/ORT/FEX/exe

==============================================================================


Usage:	
	ort2image -r <No. of Rows> -c <No. of Columns> max 512x512
			-b <Background Intensity>
		      	-l <Intensity> <LineThickness> <EndPointIntensity>
		      	-i <Intensity> <LineThickness> <EndPointIntensity>
		      	-m <MinLength>
			-L Line segments Only
			-C Curved Segments Only
                    	 < <ORT line ASCII data file> > ImageFile

Where
 The  image outputted is rectangle of side "XSize by YSize" pixels
 and intensity is the value given to the line pixels in the image

Output result       : 

   0 = successful, 
  -1 = error, 

Functionality: 

This program converts ORT lines to a  image

----------------------------------------------------------------------------*/

#include "ListeMacros.h"
#include "Liste.h"
#include "FEX.h"
#include "LPEG.h"

#define HEIGHT 512
#define WIDTH  512

main(argc,argv)

 int  argc;
 char **argv;

{

/*
=======================================================================
===================== START OF DECLARATION ============================
=======================================================================
*/
 int i,j;			/* Loop indecies */
 int Next;

 FILE *p_InFile;		/* Pointers to start of files fo I/O */
 FILE *p_OutFile;

/* 
 Create buffer for image
*/
 char Image [HEIGHT][WIDTH];

/*
 Parameters associated with images
*/

 int WritePGM;
 int XSize;
 int YSize;
 int OutPutStatus;
 int Background;
 int LineIntensity;
 int LineEndPointIntensity;
 int LineThickness;
 int ArcIntensity;
 int ArcEndPointIntensity;
 int ArcThickness;

/*
 Liste data
*/
 int  N_ListORTLine;
 long Line;
 Liste ID_ListORTLine;
 struct ORTLine        	*ListORTLine;

 int N_ListORTCircularArc;
 long Arc;
 Liste ID_ListORTCircularArc;
 struct ORTCircularArc 	*ListORTCircularArc;

/*
 Other parameters
*/

 int CurveCounter;
 int RadiusSquared;

 double MinLength;
 double r1,r2,r3;

 double junkf,side;
 double x1,x2,x3,x4,y1,y2,y3,y4;
 double XCenter;
 double YCenter;

 char text;
/*
=======================================================================
===================== START OF INITIALISATION =========================
=======================================================================
*/
 
/*
 Set defaults, process command line options, and initialise lists

*/

  Next = 0;
  OutPutStatus  		= -1; 
  Background 			= 0;
  LineIntensity 		= 255;
  LineThickness 		= 1;
  LineEndPointIntensity	= 128;
  ArcIntensity 		= 255;
  ArcThickness 		= 2;
  ArcEndPointIntensity	= 128;
  MinLength  			= 3.0;
  WritePGM 			= TRUE;
  
  for (i=1;i<argc;i++) {
       if (argv[i][0] == '-') {
           switch (argv[i][1]) {
           case 'L': Next++ ;  OutPutStatus = 0    ; continue;
           case 'C': Next++ ;  OutPutStatus = 1    ; continue;
           case 'r': Next++;   WritePGM   = FALSE  ; continue;
           case 'b': Next+=2;  Background = (atoi(argv[++i])); continue;
           case 'l': Next+=4;  
			LineIntensity 	= (atoi(argv[++i])); 
			LineThickness 	= (atoi(argv[++i])); 
			LineEndPointIntensity= (atoi(argv[++i])); continue;
           case 'c': Next+=4;  
			ArcIntensity 		= (atoi(argv[++i])); 
			ArcThickness 		= (atoi(argv[++i])); 
			ArcEndPointIntensity	= (atoi(argv[++i])); continue;
           case 'm': Next+=2;  MinLength  = ((double)atof(argv[++i])); continue;
	    case 'v': Next++; fprintf(stderr,"%s: Version 1.1\n",argv[0]); return(-1);
	    default : fprintf(stderr,"Error: unrecognized option: %s \n",argv[i]); return(-1);
	    case 'h':
 		fprintf(stderr,"USAGE :\n");
		fprintf(stderr,"  %s [-hvLCr] [-bclm Paramter List] < InFile > OutFile\n",argv[0]);
		fprintf(stderr,"WHERE:\n");
              fprintf(stderr," -h Gives usage information \n");
              fprintf(stderr," -v Gives version number \n");
		fprintf(stderr," -L Display line segments only (default all)\n");
		fprintf(stderr," -C Display circular arc segments only (default all)\n");
		fprintf(stderr," -r Output raw image instead of PGM\n");
		fprintf(stderr," -b <Background intensity> (max 255, default 255)\n");
		fprintf(stderr," -c <Intensity Thickness EndpointIntensity> for Arcs (default 0 2 128)\n");
		fprintf(stderr," -l <Intensity Thickness EndpointIntensity> for Lines (default 0 1 128)\n");
		fprintf(stderr," -m <Minimum length of segment> (default 5.0)\n");
		fprintf(stderr,"   InFile should contain ASCII lists of line segments produced by FEX\n");
		fprintf(stderr,"   OutFile will contain PGM or Raw image\n");
		return(-1);
	}
    }
  }

/*
 Use standard input/output
*/
       p_InFile  = stdin;
       p_OutFile = stdout;

/*
 Get image size from data header
*/
     text = getc(p_InFile);
     fscanf(p_InFile,"%d %d",&XSize,&YSize);
     XCenter = ((double) (XSize))/2.0;
     YCenter = ((double) (YSize))/2.0;
     LineThickness--;
     ArcThickness--;

/*
  Set image pixels to background value
*/
  for (i=0;i<YSize;i++) {
      for (j=0;j<XSize;j++) {
 	    Image[i][j] = (char) Background;
	}
  }

if (OutPutStatus == -1 || OutPutStatus == 0) {

/*
 Read the ORT line data and draw the line on the image
*/

CrtORTLineList( &p_InFile,
   	 	  MinLength,
                &ListORTLine,
                &ID_ListORTLine,
		  &N_ListORTLine);

for (i=1 ; i<=N_ListORTLine; i++ ) {

  Line = ElmNumList ( ID_ListORTLine, (long)i);
  ListORTLine = MACCast(ORTLine,Line);

  DrawBezierLine ( (int) (ListORTLine->Start.Col + XCenter), 
                   (int) (ListORTLine->Start.Row + YCenter), 
                   (int) (ListORTLine->End.Col   + XCenter), 
                   (int) (ListORTLine->End.Row   + YCenter), 
		     LineIntensity, LineThickness, LineEndPointIntensity, 
		     XSize, YSize, Image);
 }

} /* endif OutPutStatus */

if (OutPutStatus == -1 || OutPutStatus == 1) {

/*
 Read the ORT Curve data and draw the Curve on the image
*/

CrtORTCircularArcList( &p_InFile,
               	  &ListORTCircularArc,
                       &ID_ListORTCircularArc,
			  &N_ListORTCircularArc);

for (i=1 ; i<=N_ListORTCircularArc; i++ ) {

  Arc = ElmNumList ( ID_ListORTCircularArc, (long)i);
  ListORTCircularArc = MACCast(ORTCircularArc,Arc);

 if ( ListORTCircularArc->Length >= MinLength) {

  x1 = ( ListORTCircularArc->Start.Col    + XCenter); 
  y1 = ( ListORTCircularArc->Start.Row    + YCenter); 
  x2 = ( ListORTCircularArc->MidPoint.Col + XCenter); 
  y2 = ( ListORTCircularArc->MidPoint.Row + YCenter); 
  x3 = ( ListORTCircularArc->End.Col      + XCenter); 
  y3 = ( ListORTCircularArc->End.Row      + YCenter); 
  x4 = ( ListORTCircularArc->Origin.Col   + XCenter); 
  y4 = ( ListORTCircularArc->Origin.Row   + YCenter); 

  RadiusSquared = (int) (ListORTCircularArc->Radius *  ListORTCircularArc->Radius); 

  DrawCircularArc  ( ((int)x1),((int)y1),
			((int)x3),((int)y3),
			((int)x4),((int)y4),
			ListORTCircularArc->Direction,    /* -1 clockwise 1 counterclockwise */
			RadiusSquared,
 			ArcIntensity, ArcThickness, ArcEndPointIntensity, 
			XSize, YSize, Image);

  }

 }

} /* endif OutPutStatus */

/*
  Output the image data
*/

  if (WritePGM == TRUE)
	fprintf(p_OutFile,"P5\n%d %d\n255\n",XSize,YSize);

  for (i=0;i<YSize;i++) {
      for (j=0;j<XSize;j++) {
	   putc(Image[i][j],p_OutFile);
	}
  }

/*
 Close all files
*/
         fclose(p_InFile);
         fclose(p_OutFile);

	  return(0);
}
