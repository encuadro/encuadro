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

Name : SkipLines
Type : int
Written on   : 14-Nov-90     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/ORT/LPEG/src/MiscRoutines

==============================================================================

Input parameters    : 
 p_InFile 		-- Pointer to position in file
 LineLength		-- Maximum length of 1 line of header
 LinesToSkip		-- Number of lines to skip
 PrintFlag		-- 0 means print skipped lines 1 means do not print

Output parameters   : 
 None

Output result       : 
  0 = successful, 
 -1 = EOF 

Functions called:
 SkipLine

Calling procedure:

 int LineLength;
 int LinesToSkip;
 int PrintFlag;

 FILE *p_InFile;

 SkipLines(&p_InFile,LineLength,LinesToSkip,PrintFlag);

Functionality: 

This function skips LinesToSkip lines of data stored in a file 
from the position pointed to currently by the file pointer p_InFile.

----------------------------------------------------------------------------*/

#include <stdio.h>     /* Standard C I/O library */
#include <math.h>      /* Standard C mathematics library */
#include <errno.h>     /* Standard C error handling routines */
/* #include <strings.h> */   /* Standard C string handling routines */
#include <ctype.h>     /* Standard C type identification routines */

int SkipLines (p_InFile,
		  LineLength,
		  LinesToSkip,
		  PrintFlag)

 int LineLength;
 int LinesToSkip;
 int PrintFlag;

 FILE *(*p_InFile);

{
	int i;                       /* Loop index */
	char LineBuffer[100]; /* Just a buffer to store the characters */

#ifdef debug
          fprintf(stderr," Start of function SkipLines \n");
#endif

/*
 Skip LinesToSkip lines of Lines

*/
   for (i=0;i<LinesToSkip;i++) {

            if  ( (fgets(LineBuffer,LineLength,*p_InFile)) != NULL) {
                   if (PrintFlag == 0) 
                       fprintf(stderr,"-> %s",LineBuffer);
	     }
             else {
                   return(-1);
            }
   }

                   return(0);

#ifdef debug
          fprintf(stderr," End of function SkipLines \n");
#endif

}

