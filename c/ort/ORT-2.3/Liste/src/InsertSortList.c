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
/* Function : InsertSortList.c
 * 
 * Author   : J.Paul Schmidt.
 * 
 * Cree le  : 88/04/12 Version  : 1.2
 * 
 * Modifications : 90/01/18 Author   : Florence Maraninchi Reason   : Erreur
 * d'algorithme, cas d'insertion en tete --> creait un bouclage.
 * 
 * Implemented functionality : Add an element in a sorted list.
 * 
 * Input parameters : List identifier. (Ptr to 1st element). El to insert. Access
 * function on which the sorting is based. function(a,b)  should return :  1 if
 * a > b 0 if a = b -1 if a < b
 * 
 * Output parameter : None. */
/* ****************************************************************** */

#include "ListeP.h"

long InsertSortList (
#if NeedFunctionPrototypes
  Liste s_idlist,		/* list to process indentifier */
  long el,			/* element to insert */
  long (*function) ()		/* Acces function */
)
#else
s_idlist, el, function)
  Liste s_idlist;		/* list to process indentifier */
  long el;			/* element to insert */
  long (*function) () ;		/* Acces function */
#endif

{
  ty_list *p_firstelem;		/* Pointer to the list to process */
  ty_node *p_curent, *p_next, *p_intermede;	/* Working pointers */
  int found;			/* To leave the loop */

#ifdef debug
  (void) fprintf (stderr, " Function : InsertSortList \n");
#endif

  /* Parameter transformation */
  p_firstelem = (ty_list *) s_idlist;

  Lst_TestPar (p_firstelem, "NULL POINTER AS PARAMETER \n", ERRNU);


  /* Empty list ---------- */
  if (p_firstelem->num == 0) {

#ifdef debug
    (void) fprintf (stderr, " empty list, InsertSortList \n ");
#endif

    p_curent = (ty_node *) malloc (sizeof (ty_node));

    /* Allocation checking */
    Lst_TestPar (p_curent, "NO MORE MEMORY AVAILABLE \n", ERRNU);

    p_curent->p_suiv = NULL;	/* chain updating */
    p_curent->s_elem = el;	/* elem value updating */
    p_firstelem->p_first = p_curent;
    p_firstelem->p_cur = NULL;
    p_firstelem->p_last = p_curent;
  }

  /* None empty list --------------- */

  else {
    /* Scan the list until insertion or end of list */
    found = 0;
    p_next = p_firstelem->p_first;
    p_curent = NULL;
    while ((found == 0) && (p_next != NULL)) {
      if ((function) (&el, &(p_next->s_elem)) < 0) {
	found = 1;		/* Position of the element found */

	/* Creation and intialisation of the bloc */
	p_intermede = (ty_node *) malloc (sizeof (ty_node));

	/* Allocation checking */
	Lst_TestPar (p_intermede, "NO MORE MEMORY AVAILABLE \n", ERRNU);

	if (p_curent == NULL)	/* insertion en tete */
	  p_firstelem->p_first = p_intermede;
	else			/* insertion au milieu */
	  p_curent->p_suiv = p_intermede;
	p_intermede->p_suiv = p_next;
	p_intermede->s_elem = el;
      }				/* End of the if ((function)(&el,
				 * &(p_next->s_elem)) == -1) */

      p_curent = p_next;
      p_next = p_next->p_suiv;
    }				/* End of the while (p_next != NULL) && (
				 * p_next->s_elem != el) */


    /* Insertion at the end -------------------- */
    if (found == 0) {
      p_intermede = (ty_node *) malloc (sizeof (ty_node));

      Lst_TestPar (p_curent, "NO MORE MEMORY AVAILABLE \n", ERRNU);

      p_curent->p_suiv = p_intermede;
      p_firstelem->p_last = p_intermede;
      p_intermede->p_suiv = NULL;
      p_intermede->s_elem = el;
    }				/* End of the if  found == 0 */

  }				/* End of the else p_firstelem->num == 0 */

#ifdef debug
  (void) fprintf (stderr, " End of : InsertSortList \n");
#endif

  p_firstelem->num++;
  return (PASERR);

}				/* End of InsertSortList */
