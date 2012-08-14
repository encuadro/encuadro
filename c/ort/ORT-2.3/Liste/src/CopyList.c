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
/* Function : CopyList.c
 * 
 * Author   : J.Paul Schmidt.
 * 
 * Cree le  : 88/04/12 Version  : 1.2
 * 
 * Modifications : 90/01/18 Author   : Reason   :
 * 
 * Implemented functionality : Copy of a list.
 * 
 * Input parameters : List identifier. (Ptr to 1st element).
 * 
 * Output parameter : List identifier. (Ptr to 1st element). */
/* ****************************************************************** */

#include "ListeP.h"

Liste CopyList (
#if NeedFunctionPrototypes
  Liste s_idlist		/* list to process indentifier */
)
#else
s_idlist)
Liste s_idlist ;        /* list to process indentifier */
#endif

{
  ty_list *p_firstelem;		/* Pointer to the list to process */
  ty_node *p_curent,		/* Working pointer in the original list */
   *p_curentbis,		/* Working pointer in the new list */
   *p_nextbis;			/* Working pointer in the new list */
  ty_list *p_newprem;		/* obtained list identifier */

#ifdef debug
  (void) fprintf (stderr, " Function : CopyList \n");
#endif

  /* Parameter transformation */
  p_firstelem = (ty_list *) s_idlist;

  Lst_TestPar (p_firstelem, "NULL POINTER AS PARAMETER \n", ERRNU);

  /* Bloc allocation and fields initialisation */
  p_newprem = (ty_list *) malloc (sizeof (ty_list));

  /* Allocation checking */
  Lst_TestPar (p_newprem, "NO MORE MEMORY AVAILABLE \n", ERRNU);

  p_newprem->num = p_firstelem->num;	/* initialisation */
  p_curent = p_firstelem->p_first;	/* First el. of the list to Copy */
  if (p_curent == NULL) {	/* empty list */
    p_newprem->p_first = NULL;	/* initialisation */
    p_newprem->p_cur = NULL;	/* initialisation */
    p_newprem->p_last = NULL;	/* initialisation */
  }
  else {			/* none empty list */
    /* case of the first element */
    p_curentbis = (ty_node *) malloc (sizeof (ty_node));

    /* Allocation checking */
    Lst_TestPar (p_curentbis, "NO MORE MEMORY AVAILABLE \n", ERRNU);

    p_newprem->p_first = p_curentbis;	/* initialisation */
    p_newprem->p_cur = NULL;	/* initialisation */
    p_curentbis->s_elem = p_curent->s_elem;
    p_curent = p_curent->p_suiv;

    /* case of the next elements */
    while (p_curent != NULL) {
      p_nextbis = (ty_node *) malloc (sizeof (ty_node));

      /* Allocation checking */
      Lst_TestPar (p_nextbis, "NO MORE MEMORY AVAILABLE \n", ERRNU);

      p_nextbis->s_elem = p_curent->s_elem;	/* copie de l'el. courant */
      p_curentbis->p_suiv = p_nextbis;	/* Chain updating */
      p_curent = p_curent->p_suiv;
      p_curentbis = p_nextbis;
    }				/* End of the while (p_curent != NULL)  */

    p_newprem->p_last = p_curentbis;	/* initialisation */
    p_curentbis->p_suiv = NULL;	/* initialisation */
  };				/* End of the if p_curent == NULL */


#ifdef debug
  (void) fprintf (stderr, " End of : CopyList \n");
#endif

  return ((Liste) p_newprem);

}				/* End of CopyList */
