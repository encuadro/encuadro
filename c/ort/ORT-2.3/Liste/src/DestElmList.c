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
/* Function : DestElmList.c
 * 
 * Author   : J.Paul Schmidt.
 * 
 * Cree le  : 88/04/12 Version  : 1.2
 * 
 * Modifications : 90/01/18 Author   : Reason   :
 * 
 * Implemented functionality : Remove from the list the first found instance of
 * the input parameter.
 * 
 * Input parameters : List identifier. (Ptr to 1st element). Element to remove
 * value.
 * 
 * Output parameter : None. ( or error if unfound element ) */
/* ****************************************************************** */

#include "ListeP.h"

long DestElmList (
#if NeedFunctionPrototypes
  Liste s_idlist,		/* list to process indentifier */
  long el			/* element to remove from the list */
)
#else
s_idlist, el)
  Liste s_idlist ;		/* list to process indentifier */
  long el ;			/* element to remove from the list */
#endif

{
  ty_list *p_firstelem;		/* Pointer to the list to process */
  ty_node *p_curent, *p_next;

#ifdef debug
  (void) fprintf (stderr, " Function : DestElmList \n");
#endif

  /* Parameter transformation */
  p_firstelem = (ty_list *) s_idlist;
  Lst_TestPar (p_firstelem, "NULL POINTER AS PARAMETER \n", ERRNU);

  /* Test if the list is empty */
  Lst_TestPar (p_firstelem->p_first, "EMPTY LIST \n", ERRVI);

#ifdef debug
  (void) fprintf (stderr, " DestElmList : all right none empty list \n");
#endif

  p_next = p_firstelem->p_first;
  if (p_next->s_elem == el) {	/* case of the first element */
    p_firstelem->p_first = p_next->p_suiv;
    if (p_firstelem->p_cur == p_next) p_firstelem->p_cur = p_next->p_suiv;
    if (p_firstelem->p_last == p_next) p_firstelem->p_last = NULL;
    free (p_next);
    p_firstelem->num--;

#ifdef debug
    (void) fprintf (stderr, " none empty list, DestElm \n ");
    (void) fprintf (stderr, " End of : DestElmList \n");
#endif

    return (PASERR);
  };				/* End of the if p_next->s_elem == el) */

  /* case of any element */
  while ((p_next != NULL) && (p_next->s_elem != el)) {

#ifdef debug
    (void) fprintf (stderr, " none empty list, DestElm \n ");
#endif

    p_curent = p_next;
    p_next = p_next->p_suiv;
  };				/* End of the while ((p_next != NULL) && (elem
				 * != el) */
  if (p_next == NULL) {		/* The element isn't in the list */

#ifdef debug
    (void) fprintf (stderr, " End of : DestElmList (erreur empty list or unfound el.)\n");
#endif

    /* update error unfound element */
    return (ERRVI);
  };				/* End of the if p_next == NULL */

  /* element is found */
  p_curent->p_suiv = p_next->p_suiv;	/* chain updating */
  if (p_firstelem->p_cur == p_next) p_firstelem->p_cur = p_curent;
  if (p_firstelem->p_last == p_next) p_firstelem->p_last = p_curent;
  free (p_next);
  p_firstelem->num--;

#ifdef debug
  (void) fprintf (stderr, " End of : DestElmList \n");
#endif

  return (PASERR);

}				/* End of DestElmList */
