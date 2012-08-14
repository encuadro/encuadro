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
/* Function : DestList.c
 * 
 * Author   : J.Paul Schmidt.
 * 
 * Cree le  : 88/04/12 Version  : 1.2
 * 
 * Modifications : 90/01/18 Author   : Reason   :
 * 
 * Implemented functionality : List of interger destruction.
 * 
 * Input parameters : List indentifier address. Output parameter : None. */
/* ****************************************************************** */

#include "ListeP.h"

long DestList (
#if NeedFunctionPrototypes
  Liste *s_idlist /* address of the list to process indentifier */
/* RETOUR */
)
#else
s_idlist)
  Liste *s_idlist ; /* address of the list to process indentifier */
#endif

{
  ty_list *p_firstelem;		/* Pointer to the list to process */
  ty_node *p_next, *p_curent;

#ifdef debug
  (void) fprintf (stderr, " Function : DestList \n");
#endif

  /* Parameter transformation */
  p_firstelem = (ty_list *) * s_idlist;

  /* Prarameters checking */
  Lst_TestPar (p_firstelem, "NULL POINTER AS PARAMETER \n", ERRNU);

  /* Deletion of all the elements of the list */
  p_curent = p_firstelem->p_first;
  free (p_firstelem);
  *s_idlist = NULL;		/* Update identifier */

  while (p_curent != NULL) {
    p_next = p_curent->p_suiv;
    free (p_curent);
    p_curent = p_next;
  };

#ifdef debug
  (void) fprintf (stderr, " End of : DestList \n");
#endif

  return (PASERR);

}				/* End of DestList */
