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

Name : SortCornersByQuality
Type : long
Written on   : 14-Oct-91     By : A. Etemadi
Modified on  :               By : 
Directory    : ~atae/ORT/ORT/IPEG/src

==============================================================================

Input parameters    : 

Output parameters   : 

Output result       : 

  TRUE 		-- Values used by Liste library for sorting
  FALSE

Calling procedure:

#include "Liste.h"
#include "LPEG.h"
#include "ListeMacros.h"

Liste ORTCornerListID;

	SortList ( ORTCornerListID ,SortCornersByID);

Functionality: 
 After creating a list of ORT junctions using the Liste library we use this
 dummy routine to sort the junctions in the list in ascending order of ID.

----------------------------------------------------------------------------*/

#include "ListeMacros.h"
#include "Liste.h"
#include "FEX.h"
#include "LPEG.h"
#include "IPEG.h"

long  SortCornersByQuality (a, b)

  long *a, *b;	/* Dummy variables */

{
  struct ORTCorner *element1;
  struct ORTCorner *element2;

/*
 First we must cast the dummy variables into ORTJunction structures

*/
  	element1 = MACCast(ORTCorner, *a);
  	element2 = MACCast(ORTCorner, *b);
/*
 Now introduce the sorting criterion

*/

  if (element2->Quality  >  element1->Quality) {
	return(TRUE);
  } else {
  	return(FALSE);
  }
}
