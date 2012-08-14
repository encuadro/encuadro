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

Name : CrtORTLineList
Type : int
Written on   : 20-Nov-90     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/ORT/LPEG/src/ListRoutines

==============================================================================

Input parameters    : 

 p_InFile		-- Pointer to input file
 MinLineLength	-- Minimum length of line acceptable

Output parameters    : 

 ORTLineList		-- The structure containing the ORT lines
 ORTLineListID	-- The List ID of the ORT Lines
 Nlist			-- Number of items in the List

Output result       : 

  0 = End of file with no errors 
 -1 = Error during read

Called Functions :

ReadORTLine		-- From libLPEG
AddElmList		-- From libListe
CreateList		-- From libListe

Calling procedure:

#include "LPEG.h" 		 Header for ORT library
#include "ListeMacros.h"     Macros the Liste library
#include "Liste.h"           Header file for the Liste library

 double MinLineLength;

 FILE *p_InFile;

 int   Nlist

 Liste ORTLineListID;

 struct ORTLine *ORTLineList;

	CrtORTLineList(  &p_InFile,
			   MinLineLength,
                        &ORTLineList,
                        &ORTLineListID,
			   &Nlist);


Functionality: 

This function creates a List of ORT line structures using functions from the 
Liste library. All memory allocation for structures is done within this 
routine. The lines data is also filtered by length.

----------------------------------------------------------------------------*/

#include "ListeMacros.h"
#include "Liste.h"
#include "FEX.h"
#include "LPEG.h"

#define MAXLINE 100

int CrtORTLineList(  p_InFile,
			MinLineLength,
			ORTLineList,
			ORTLineListID,
			Nlist)

 double MinLineLength;

 FILE *(*p_InFile);

 struct ORTLine *(*ORTLineList);

 Liste *ORTLineListID;

 int *Nlist;

{

 int flag;
 char text[MAXLINE];

 int  ID;
 int  StringID;
 double  StartCol;
 double  StartRow;
 double  EndCol;
 double  EndRow;
 double  MidPointCol;
 double  MidPointRow;
 double  Length;
 double  LengthParlVar;
 double  LengthPerpVar;
 double  Theta;
 double  ThetaVar;

#ifdef debug
          fprintf(stderr," Start of function CrtORTLineList \n");
#endif


/* 
  Skip text to relevant section of FEX output
*/
     flag = fscanf((*p_InFile),"%s",text);
     while  ( strcmp(text,"#Lines") && flag != 0 && flag != EOF) {
              flag = fscanf((*p_InFile),"%s",text);
     }

/*
 Create an empty list to store the ORT lines

*/

 *ORTLineListID = CreatList();
 *Nlist = 0;

      while (flag != 0 && flag != EOF) {

        *ORTLineList = MACAllocateMem(ORTLine);
        flag = fscanf((*p_InFile),"%d %d %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",
 					&ID,
 					&StringID,
 					&StartCol,
 					&StartRow,
 					&EndCol,
 					&EndRow,
 					&MidPointCol,
 					&MidPointRow,
 					&Length,
 					&LengthParlVar,
 					&LengthPerpVar,
 					&Theta,
 					&ThetaVar);

  if (flag != 0 && flag != EOF)  {

	if (Length >= MinLineLength) {

		(*Nlist)++;
		(*ORTLineList)->ID 		  = (*Nlist);
              (*ORTLineList)->StringID 	  = StringID;
              (*ORTLineList)->Start.Col 	  = StartCol;
              (*ORTLineList)->Start.Row 	  = StartRow;
              (*ORTLineList)->End.Col 	  = EndCol;
              (*ORTLineList)->End.Row 	  = EndRow;
              (*ORTLineList)->MidPoint.Col  = MidPointCol;
              (*ORTLineList)->MidPoint.Row  = MidPointRow;
              (*ORTLineList)->Length 	  = Length;
              (*ORTLineList)->LengthParlVar = LengthParlVar;
              (*ORTLineList)->LengthPerpVar = LengthPerpVar;
              (*ORTLineList)->Theta 	  = Theta;
              (*ORTLineList)->ThetaVar 	  = ThetaVar;

         	AddElmList (*ORTLineListID, (long) (*ORTLineList) );

         }
      }
  }

	if (flag == -1) {
	    return(0);
	} else {
	    return(-1);
       }

#ifdef debug
          fprintf(stderr," End of function CrtORTLineList \n");
#endif

}

