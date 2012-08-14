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

Name : CrtORTCircularArcList
Type : int
Written on   : 20-Nov-90     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/ORT/LPEG/src/ListRoutines

==============================================================================

Input parameters    : 

 p_InFile			-- Pointer to input file

Output parameters    : 

 ORTCircularArcList		-- The structure containing the ORT CircularArcs
 ORTCircularArcListID	-- The List ID of the ORT CircularArcs
 Nlist			-- Number of items in the List

Output result       : 

  0 = End of file with no errors 
 -1 = Error during read

Called Functions :

AddElmList		-- From libListe
CreateList		-- From libListe

Calling procedure:

#include "LPEG.h" 		 Header for ORT library
#include "ListeMacros.h"     Macros the Liste library
#include "Liste.h"           Header file for the Liste library

 double MinCircularArcLength;

 FILE *p_InFile;

 int   Nlist

 Liste ORTCircularArcListID;

 struct ORTCircularArc *ORTCircularArcList;

	CrtORTCircularArcList(  &p_InFile,
                        	   &ORTCircularArcList,
                        	   &ORTCircularArcListID,
			   	   &Nlist);


Functionality: 

This function creates a List of ORT CircularArc structures using functions from the 
Liste library. All memory allocation for structures is done within this 
routine. The CircularArcs data is also filtered by length.

----------------------------------------------------------------------------*/

#include "ListeMacros.h"
#include "Liste.h"
#include "FEX.h"
#include "LPEG.h"

#define MAXLINE 100

int CrtORTCircularArcList(  p_InFile,
				ORTCircularArcList,
				ORTCircularArcListID,
				Nlist)

 FILE *(*p_InFile);

 struct ORTCircularArc *(*ORTCircularArcList);

 Liste *ORTCircularArcListID;

 int *Nlist;

{

 int flag;
 char text[MAXLINE];
 long element;

#ifdef debug
          fprintf(stderr," Start of function CrtORTCircularArcList \n");
#endif


/* 
  Skip text to relevant section of FEX output
*/
     flag = fscanf((*p_InFile),"%s",text);
     while  ( strcmp(text,"#CircularArcs") && flag != 0 && flag != EOF) {
              flag = fscanf((*p_InFile),"%s",text);
     }

/*
 Create an empty list to store the ORT CircularArcs

*/

 *ORTCircularArcListID = CreatList();
 *Nlist = 0;

      while (flag != 0 && flag != EOF) {

        *ORTCircularArcList = MACAllocateMem(ORTCircularArc);
        flag = fscanf((*p_InFile),"%d %d %d %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",
			   &(*ORTCircularArcList)->ID,
                        &(*ORTCircularArcList)->StringID,
                        &(*ORTCircularArcList)->Direction,
                        &(*ORTCircularArcList)->Origin.Col,
                        &(*ORTCircularArcList)->Origin.Row,
                        &(*ORTCircularArcList)->Start.Col,
                        &(*ORTCircularArcList)->Start.Row,
                        &(*ORTCircularArcList)->MidPoint.Col,
                        &(*ORTCircularArcList)->MidPoint.Row,
                        &(*ORTCircularArcList)->End.Col,
                        &(*ORTCircularArcList)->End.Row,
                        &(*ORTCircularArcList)->VLPoint.Col,
                        &(*ORTCircularArcList)->VLPoint.Row,
                        &(*ORTCircularArcList)->Radius,
                        &(*ORTCircularArcList)->Length,
                        &(*ORTCircularArcList)->LengthParlVar,
                        &(*ORTCircularArcList)->LengthPerpVar,
                        &(*ORTCircularArcList)->Width,
                        &(*ORTCircularArcList)->Height,
                        &(*ORTCircularArcList)->Theta);

	  if (flag != 0 && flag != EOF)  {
         	AddElmList (*ORTCircularArcListID, (long) (*ORTCircularArcList) );
		(*Nlist)++;
         }
  }

	if (flag == -1) {
	    return(0);
	} else {
	    return(-1);
       }

#ifdef debug
          fprintf(stderr," End of function CrtORTCircularArcList \n");
#endif

}

