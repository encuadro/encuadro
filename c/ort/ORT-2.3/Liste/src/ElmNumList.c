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
/* Function : ElmNumList.c
 * 
 * Author   : J.Paul Schmidt.
 * 
 * Cree le  : 88/04/12 Version  : 1.2
 * 
 * Modifications : 90/01/18 Author   : Reason   :
 * 
 * Implemented functionality : Find the  le Jth element of a list.
 * 
 * Input parameters : List identifier. (Ptr to 1st element). # of the element
 * looked for.
 * 
 * Output parameter : Jth element of the list or error. */
/* ****************************************************************** */

#include "ListeP.h"

long ElmNumList (
#if NeedFunctionPrototypes
  Liste s_idlist,		/* list to process indentifier */
  int j				/* looked for element */
)
#else
s_idlist, j)
  Liste s_idlist ;		/* list to process indentifier */
  int j ;			/* looked for element */
#endif

{
  ty_list *p_firstelem;		/* Pointer to the list to process */
  ty_node *p_curent;
  int cpteur;


#ifdef debug
  (void) fprintf (stderr, " Function : ElmNumList \n");
#endif

  /* Parameter transformation */
  p_firstelem = (ty_list *) s_idlist;

  Lst_TestPar (p_firstelem, "NULL POINTER AS PARAMETER \n", ERRNU);
  Lst_TestPar (p_firstelem->p_first, "EMPTY LIST \n", ERRVI);

  if (p_firstelem->num < j || j == 0) {	/* Unexisting element */

#ifdef debug
    (void) fprintf (stderr, " ERREUR, Innexisting element \n ");
    (void) fprintf (stderr, "         J was : %d \n", j);
    (void) fprintf (stderr, " And there is  %d elements only in the list \n",
		    p_firstelem->num);
    (void) fprintf (stderr, " End of : ElmNumList \n");
#endif

    return (ERRVI);
  };

  if (p_firstelem->num == j) {	/* last element */

#ifdef debug
    (void) fprintf (stderr, " End of : ElmNumList \n");
#endif

    return (p_firstelem->p_last->s_elem);
  };

  p_curent = p_firstelem->p_first;
  for (cpteur = 1; cpteur < j; cpteur++)
    p_curent = p_curent->p_suiv;

#ifdef debug
  (void) fprintf (stderr, " End of : ElmNumList \n");
#endif

  return (p_curent->s_elem);

}				/* End of ElmNumList */
