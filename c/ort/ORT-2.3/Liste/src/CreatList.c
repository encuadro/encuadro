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
/* Function : CreatList.c
 * 
 * Author   : J.Paul Schmidt.
 * 
 * Cree le  : 88/04/12 Version  : 1.2
 * 
 * Modifications : 90/01/18 Author   : Reason   :
 * 
 * Implemented functionality : List of intergers creation.
 * 
 * Input parameters : None. Output parameter : List identifier (Pointer to le
 * first elements address). */
/* ****************************************************************** */

#include "ListeP.h"

long CreatList ()
{
  ty_list *p_pteur;

#ifdef debug
  (void) fprintf (stderr, " Function : CreatList \n");
#endif

  /* Bloc allocation and fields initialisation */
  p_pteur = (ty_list *) malloc (sizeof (ty_list));

  /* Allocation checking */
  Lst_TestPar (p_pteur, "NO MORE MEMORY AVAILABLE \n", ERRNU);

  /* initialisation */
  p_pteur->p_first = NULL;
  p_pteur->p_cur = NULL;
  p_pteur->p_last = NULL;
  p_pteur->num = 0 ;

#ifdef debug
  (void) fprintf (stderr, " End of : CreatList \n");
#endif

  return ((long) p_pteur);

}				/* End of CreatList */
