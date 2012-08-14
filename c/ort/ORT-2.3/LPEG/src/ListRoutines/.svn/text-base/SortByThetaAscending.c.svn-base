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

Name : SortByThetaAscending
Type : long
Written on   : 14-Dec-90     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/ORT/LPEG/src/ListRoutines

==============================================================================

Input parameters    : 

Output parameters   : 

Output result       : 

  TRUE 		-- Values used by Liste library for sorting
  FALSE

Calling procedure:

#include "FEX.h"
#include "LPEG.h"
#include "ListeMacros.h"
#include "Liste.h"

Liste ORTLineListID;

	SortList ( ORTLineListID ,SortByThetaAscending);

Functionality: 
 After creating a list of ORT lines using the Liste library we use this
 dummy routine to sort the lines in the list in ascending order of Theta.

----------------------------------------------------------------------------*/

#include "ListeMacros.h"
#include "Liste.h"
#include "FEX.h"
#include "LPEG.h"

long  SortByThetaAscending (a, b)

  long *a, *b;	/* Dummy variables */

{
  struct ORTLine *element1;
  struct ORTLine *element2;

/*
 First we must cast the dummy variables into ORTLine structures

*/

  	element1 = MACCast(ORTLine, *a);
  	element2 = MACCast(ORTLine, *b);

/*
 First we must cast the dummy variables into ORTLine structures

*/

  if (element1->Theta > element2->Theta) {
	return(TRUE);
  } else {
  	return(FALSE);
  }
}
