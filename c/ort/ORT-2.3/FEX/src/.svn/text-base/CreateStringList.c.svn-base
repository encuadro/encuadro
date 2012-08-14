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

Name : CreateStringList
Type : int
Written on   : 8-Mar-90     By : A. Etemadi
Modified on  : 16-Feb-93    By : A. Etemadi

   Added support for rectangular images
   Removed print flag option

Directory    : ~atae/ORT/FEX/src

==============================================================================

Input parameters    :

 p_InFile 		-- Pointer to data file

Output parameters   : 

 StringListSize	-- Number of pixels in string
 StringListID		-- ID of Linked List of pixels belonging to string 
 StringList		-- Linked List of pixels belonging to string 

Output Result :

  0  Successful
  1  Error
 -1  EOF

Calling procedure:

 FILE *p_InFile;

 int StringListSize;

 Liste StringListID;

 struct ORTPoint *StringList;

 CreateStringList( &p_InFile,
                   &NoOfCols,
                   &NoOfRows,
	            &StringListSize,
	            &StringListID,
	            &StringList);

Functionality: 
 
 This function reads the positions of the pixels in the strings produced by the
CreateString program, stores them in a linked list and passes them back.
One string is read at a time (hence the **p_InFile buisness to keep track of
the position in the file).

******************
COORDINATE SYSTEM OF ROSIN'S STRING DATA IS NOT THE SAME AS THE ORT.
	A) ROWS AND COLS SHOULD BE SWAPPED
	B) WE SHOULD CENTER THINGS AT 0,0 BY SUBTACTING HALF THE SIZE OF THE IMAGE
THESE HAVE TO BE CHANGED IF WE USE ANOTHER STRING FINDER INSTEAD OF ROSIN'S
******************
----------------------------------------------------------------------------*/

#include "ListeMacros.h"
#include "Liste.h"
#include "FEX.h"
#include "LPEG.h"

int  CreateStringList( p_InFile,
                 NoOfCols,
                 NoOfRows,
	      	   StringListSize,
	      	   StringListID,
	      	   StringList)

 FILE *(*p_InFile);

 int *NoOfRows;
 int *NoOfCols;

 int *StringListSize;

 Liste *StringListID;

 struct ORTPoint *(*StringList);

{

 int flag;
 int Row,Col;

#ifdef debug
          fprintf(stderr," Start of function CreateStringList \n");
#endif

/*
 Read Image dimensions
*/

 fscanf((*p_InFile),"%d %d\n",NoOfCols,NoOfRows);

 if (SkipLines (&(*p_InFile),100,1,1) != 0) {
    fprintf(stderr,"Reached the end of the file...\n");
    return(-1);
 }

 *StringListID = CreatList();
 *StringListSize = 0;

 flag = 1;
 while (flag > 0) {

/*
 Allocate some memory for the StringList structure

*/

 *StringList = MACAllocateMem(ORTPoint);

/* 
 Now read a String record 

*/

 flag = fscanf( (*p_InFile), "%4d %4d\n",&Row,&Col);

   if (flag == 0)
       return(1);

   if (flag == EOF)
       return(-1);

   if (Row == -1)
   	return(0);

/* 
******************
COORDINATE SYSTEM OF ROSIN'S STRING DATA IS NOT THE SAME AS THE ORT.
	A) ROWS AND COLS SHOULD BE SWAPPED
	B) WE SHOULD CENTER THINGS AT 0,0 BY SUBTACTING HALF THE SIZE OF THE IMAGE
THESE HAVE TO BE CHANGED IF WE USE ANOTHER STRING FINDER INSTEAD OF ROSIN'S
*****************
*/

	(*StringList)->Col = (double) Row - ((double) (*NoOfCols))/2.0;
	(*StringList)->Row = (double) Col - ((double) (*NoOfRows))/2.0;
/*
 Now add this element to the list

*/
	AddElmList( *StringListID, (long)*StringList ); 
	(*StringListSize)++;

}

#ifdef debug
          fprintf(stderr," End of function CreateStringList \n");
#endif

}

