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

Name : OpenInFile
Type : int
Written on   : 14-Nov-90     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/ORT/LPEG/src/MiscRoutines

==============================================================================

Input parameters    : 
 InFileName	--   Name of Input file 

Output parameters   : 
 p_InFile	--   Pointer to start of data file

Output result       : 
 0 = successful, 
 1 = error

Calling procedure:

 char *InFileName;
 FILE *p_InFile; 

 OpenInFile(InFileName, &p_InFile)

Functionality: 
 Open a file for read access.  On successfull completion this function 
 returns a pointer to the start of the file via p_InFile.

----------------------------------------------------------------------------*/

#include <stdio.h>     /* Standard C I/O library */
#include <math.h>      /* Standard C mathematics library */
#include <errno.h>     /* Standard C error handling routines */
/* #include <strings.h> */   /* Standard C string handling routines */
#include <ctype.h>     /* Standard C type identification routines */

int OpenInFile (InFileName,
		  p_InFile)

       char *InFileName; 	/* Name of input file */
	FILE *(*p_InFile);	/* Pointer to start of file */
     
 { 

#ifdef debug
	  fprintf(stderr," Start of function OpenInFile \n");
#endif

/*
 Open file for reading
*/
	  *p_InFile = fopen(InFileName,"r");

	  if ( (*p_InFile) == NULL) {
             fprintf(stderr," NULL pointer returned when opening file %s \n",InFileName);
             exit(-1);
	  }
	  
         return(0);	  

#ifdef debug
	  fprintf(stderr," End of function OpenInFile \n");
#endif

 }
