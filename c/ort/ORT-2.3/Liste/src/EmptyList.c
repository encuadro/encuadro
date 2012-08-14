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


/* ****************************************************************** */
/* Function : EmptyList.c
 * 
 * Author   : J.Paul Schmidt.
 * 
 * Cree le  : 88/04/12 Version  : 1.2
 * 
 * Modifications : 90/01/18 Author   : Reason   :
 * 
 * Implemented functionality : Test if a list is empty.
 * 
 * Input parameters : List identifier. (Pointer to le first element of the list.)
 * Output parameter : 1 if empty list, 0 else -1 if error... */
/* ****************************************************************** */

#include "ListeP.h"

long EmptyList (
#if NeedFunctionPrototypes
  Liste s_idlist		/* list to process indentifier */
)
#else
s_idlist)
  Liste s_idlist ;          /* list to process indentifier */
#endif

{
  ty_list *p_firstelem;		/* Pointer to the list to process */

#ifdef debug
  (void) fprintf (stderr, " Function : EmptyList \n");
#endif

  /* Parameter transformation */
  p_firstelem = (ty_list *) s_idlist;

  /* Prarameters checking */
  Lst_TestPar (p_firstelem, "NULL POINTER AS PARAMETER \n", ERRNU);

  /* Test si la list est vide */
  if (p_firstelem->num == 0) {

#ifdef debug
    (void) fprintf (stderr, " End of : EmptyList  : TRUE \n");
#endif

    return (1);
  }
  else {

#ifdef debug
    (void) fprintf (stderr, " End of : EmptyList  : FALSE  \n");
#endif

    return (0);
  };				/* End of the if (p_firstelem == NULL) */

}				/* End of EmptyList */
