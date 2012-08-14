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

Name : ReadRawImageData
Type : int
Written on   : 5-Mar-90     By : A. Etemadi
Modified on  :              By : 
Directory    : ~atae/ORT/ORT/FEX/src

==============================================================================

Input parameters    : 
 p_InFile	--   Pointer to start of data file

Output parameters   : 
 Image		--   512x512 image

Output result       : 
  0 = successful, 
 -1 = error

Calling procedure:

 int Rows,cols;

 char Image[512][512];

 FILE *p_InFile; 

 ReadRawImageData(&p_InFile,
                  Rows,
		    Cols,
                  Image)

Functionality: 
 Read image data from input file pointed to by stream p_InFile

----------------------------------------------------------------------------*/

#include <stdio.h>     /* Standard C I/O library */
#include <math.h>      /* Standard C mathematics library */
#include <errno.h>     /* Standard C error handling routines */
#include <ctype.h>     /* Standard C type identification routines */

#define HEIGHT 512
#define WIDTH  512

int ReadRawImageData (p_InFile,
			 Rows,
			 Cols,
			 Image)

	int Rows,Cols;		/* Parameters indicating size of image */

       char Image[HEIGHT][WIDTH]; 	/* Image data buffer */

	FILE *(*p_InFile);		/* Pointer to start of file */
     
 { 

   int i,j;

#ifdef debug
	  fprintf(stderr," Start of function ReadRawImageData \n");
#endif

	for (i=0;i<Rows;i++) {
		for (j=0;j<Cols;j++) {
		Image[i][j] = getc((*p_InFile));
		}
	}

#ifdef debug
	  fprintf(stderr," End of function ReadRawImageData \n");
#endif
	return(0);
    	
 }
