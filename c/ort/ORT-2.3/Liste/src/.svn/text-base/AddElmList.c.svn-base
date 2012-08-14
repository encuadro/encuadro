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
/* Function : AddElmList.c
 * 
 * Author   : J.Paul Schmidt.
 * 
 * Cree le  : 88/04/12 Version  : 1.2
 * 
 * Modifications : 90/01/18 Author   : Reason   :
 * 
 * Implemented functionality : Append an element at the end of a list.
 * 
 * Input parameters : List identifier. (Ptr to 1st element). Element to insrt
 * value.
 * 
 * Output parameter : None. */
/* ****************************************************************** */

#include "ListeP.h"

long AddElmList (
#if NeedFunctionPrototypes
  Liste s_idlist,		/* Identifier of the list to process */
  long el			/* Element to insert */
)
#else
s_idlist, el)
  Liste s_idlist  ;              /* Identifier of the list to process */
  long el ;                     /* Element to insert */
#endif

{
  ty_list *p_firstelem;		/* Pointer to the list to process */
  ty_node *p_curent;

#ifdef debug
  (void) fprintf (stderr, " Function : AddElmList \n");
#endif

  /* Parameter transformation */
  p_firstelem = (ty_list *) s_idlist;
  Lst_TestPar (p_firstelem, "AddElmList : NULL POINTER AS PARAMETER \n", ERRNU);

  /* Bloc allocation and fields initialisation */
  p_curent = (ty_node *) malloc (sizeof (ty_node));

  /* Allocation checking */
  Lst_TestPar (p_curent, "AddElmList : NO MORE MEMORY AVAILABLE \n", ERRNU);

  p_curent->p_suiv = NULL;	/* Chain updating */
  p_curent->s_elem = el;	/* Elem value updating */

  /* Bloc allocation and fields initialisation */
  if (p_firstelem->num == 0) {	/* empty list */

#ifdef debug
    (void) fprintf (stderr, " empty list, AddElm \n ");
#endif

    p_firstelem->p_first = p_curent;
    p_firstelem->p_cur = p_curent;
  }
  else {			/* none empty list */
    p_firstelem->p_last->p_suiv = p_curent;
  };				/* End of the if p_firstelem->num == 0 */

  p_firstelem->p_last = p_curent;	/* End of chain updating */
  p_firstelem->num++;		/* Number of element updating */

#ifdef debug
  (void) fprintf (stderr, " End of : AddElmList \n");
#endif

  return (PASERR);

}				/* End of AddElmList */
