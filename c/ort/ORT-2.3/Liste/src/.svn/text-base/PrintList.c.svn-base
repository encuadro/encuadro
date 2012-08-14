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
/* Function : PrintList.c
 * 
 * Author   : J.Paul Schmidt.
 * 
 * Cree le  : 88/04/12 Version  : 1.2
 * 
 * Modifications : 90/01/18 Author   : Reason   :
 * 
 * Implemented functionality : Impression du contenu d'une list a l'ecran
 * 
 * Input parameters : List identifier. (Ptr to 1st element). File where to print.
 * 
 * Output parameter : None. */
/* ****************************************************************** */

#include "ListeP.h"

long PrintList (
#if NeedFunctionPrototypes
  Liste s_idlist,		/* List to process indentifier */
  FILE *fptr			/* File where to print */
)
#else
s_idlist, fptr)
  Liste s_idlist;		/* List to process indentifier */
  FILE *fptr;			/* File where to print */
#endif

{
  ty_list *p_firstelem;		/* Pointer to the list to process */
  ty_node *p_next;

#ifdef debug
  (void) fprintf (stderr, " Function : PrintList \n");
#endif

  /* Parameter transformation */
  p_firstelem = (ty_list *) s_idlist;

  /* Test if existing list */
  Lst_TestPar (p_firstelem, "NULL POINTER AS PARAMETER \n", ERRNU);

  /* Test if empty list */
  Lst_TestPar (p_firstelem->p_first, "EMPTY LIST \n", ERRVI);

  (void) fprintf (fptr, "\n-> List defined by %d : \n", s_idlist);
  (void) fprintf (fptr, "\n   There is %d in the list : \n", p_firstelem->num);
  (void) fprintf (fptr, "\n   first one : %d \n", p_firstelem->p_first->s_elem);
  if (p_firstelem->p_cur == NULL)
    (void) fprintf (fptr, "\n   curent one : NIL \n");
  else
    (void) fprintf (fptr, "\n   curent one : \n", p_firstelem->p_cur->s_elem);
  (void) fprintf (fptr, "\n   last one : %d\n", p_firstelem->p_last->s_elem);
  p_next = p_firstelem->p_first;
  while (p_next != NULL) {
    (void) fprintf (fptr, "%d; ", p_next->s_elem);
    p_next = p_next->p_suiv;
  };				/* End of the while */
  (void) fprintf (fptr, "\n");

#ifdef debug
  (void) fprintf (stderr, " End of : PrintList \n");
#endif

  return (PASERR);
}				/* End of PrintList */
