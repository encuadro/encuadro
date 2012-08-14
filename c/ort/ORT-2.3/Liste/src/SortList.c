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
/* Function : SortList.c
 * 
 * Author   : J.Paul Schmidt.
 * 
 * Cree le  : 88/04/12 Version  : 1.2
 * 
 * Modifications : 90/01/18 Author   : Reason   :
 * 
 * Implemented functionality : Sort a list.
 * 
 * Input parameters : List identifier. (Ptr to 1st element). Address of the
 * function used to compar 2 elements. Access function on which the sorting is
 * based. function(a,b)  should return :  1 if a > b 0 if a = b -1 if a < b
 * 
 * Output parameter : None. */
/* ****************************************************************** */

#include "ListeP.h"

long SortList (
#if NeedFunctionPrototypes
  Liste s_idlist,		/* list to process indentifier */
  long (*function) ()		/* function used to compar the elements */
)
#else
s_idlist, function)
  Liste s_idlist;		/* list to process indentifier */
  long (*function) ();		/* function used to compar the elements */
#endif

{
  ty_list *p_firstelem;		/* Pointer to the list to process */
  ty_node *p_curent;
  int *table;			/* table where to put the list to sort */
  int i;			/* Table index */

#ifdef debug
  (void) fprintf (stderr, " Function : SortList \n");
#endif

  /* Parameter transformation */
  p_firstelem = (ty_list *) s_idlist;

  Lst_TestPar (p_firstelem, "NULL POINTER AS PARAMETER \n", ERRNU);

  if (p_firstelem->num == 0) {	/* empty list */

#ifdef debug
    (void) fprintf (stderr, " End of : SortList \n");
#endif

    return (PASERR);
  }

  /* Creation of the table and fill it */
  table = (int *) calloc (p_firstelem->num, sizeof (long));
  i = 0;
  p_curent = p_firstelem->p_first;
  do {
    table[i++] = p_curent->s_elem;
    p_curent = p_curent->p_suiv;
  } while (p_curent != NULL);


  qsort (table, p_firstelem->num, sizeof (int), function);

  /* Uptadte the list */
  p_curent = p_firstelem->p_first;
  p_curent->s_elem = table[0];

  /* case of the next elements */
  for (i = 1; i < p_firstelem->num; i++) {
    p_curent = p_curent->p_suiv;/* Next element */
    p_curent->s_elem = table[i];
  }				/* End of the for (i=1 ; i==p_firstelem->num ;
				 * i++) */

#ifdef debug
  (void) fprintf (stderr, " End of : SortList \n");
#endif

  return (PASERR);

}				/* End of SortList */
