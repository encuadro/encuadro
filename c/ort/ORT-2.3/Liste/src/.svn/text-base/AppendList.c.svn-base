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
/* Function : AppendList.c
 * 
 * Author   : J.Paul Schmidt.
 *
 * Cree le  : 88/04/12
 * Version  : 1.2
 * 
 * Modifications : 90/01/18
 * Author   :
 * Reason   :
 *
 * Implemented functionality : Concatenation of 2 lists in a third one.
 *
 * Input parameters : 2 list identifiers.
 *   
 * Output parameter : New list identifier.
 *                    (Address of its first element)
 */  
/* ****************************************************************** */

#include "ListeP.h"

long AppendList (
#if NeedFunctionPrototypes
 Liste s_idlist1, Liste s_idlist2   /* list identifiers */
)
#else
 s_idlist1, s_idlist2)
Liste s_idlist1, s_idlist2 ;	 /* list identifiers */
#endif

{ 
  ty_list *p_premlist1,
          *p_premlist2 ;      /* pointer to the originals lists */
  ty_list *p_newprem;         /* pointer to the new list */
  ty_node *p_curent,          /* Working pointer in the original list */
          *p_curentbis,       /* Working pointer in the new list */  
          *p_nextbis;         /* Working pointer in the new list */

#ifdef debug
	  (void)fprintf(stderr," Function : AppendList \n");
#endif

  /* Parameters transformation */
  p_premlist1 = (ty_list *)s_idlist1 ;
  p_premlist2 = (ty_list *)s_idlist2 ;

  /* Prarameters checking */
  Lst_TestPar (p_premlist1, "NULL POINTER AS 1st PARAMETER \n", ERRNU) ;
  Lst_TestPar (p_premlist2, "NULL POINTER AS 2nd PARAMETER \n", ERRNU) ;

  /* Bloc allocation and fields initialisation */
  
  /* List identifier */
  p_newprem = (ty_list *)malloc (sizeof(ty_list));

  /* Allocation checking */
  Lst_TestPar (p_newprem, "NO MORE MEMORY AVAILABLE \n", ERRNU) ;

  p_newprem->num = p_premlist1->num + p_premlist2->num ;  /* initialisation */
  p_curent = p_premlist1->p_first ;
  
  if (p_curent == NULL)   /* the first list is empty */
    {
     p_newprem->p_first = NULL ;        /* initialisation */
     p_newprem->p_cur = NULL ;         /* initialisation */
     p_newprem->p_last = NULL ;         /* initialisation */
    }
  else                    /* the first list isn't empty */
    {

     /* first element */
     p_curentbis = (ty_node *)malloc (sizeof(ty_node)) ;

     /* Allocation checking */
     Lst_TestPar (p_curentbis, "NO MORE MEMORY AVAILABLE \n", ERRNU) ;

     p_newprem->p_first = p_curentbis ;         /* initialisation */
     p_newprem->p_cur = NULL ;           /* initialisation */
     p_curentbis->s_elem = p_curent->s_elem ;
     p_curent = p_curent->p_suiv ;

     /* next elements */
     while (p_curent != NULL)
      {
       p_nextbis = (ty_node *)malloc (sizeof(ty_node)) ;

       /* Allocation checking */
       Lst_TestPar (p_nextbis, "NO MORE MEMORY AVAILABLE \n", ERRNU) ;

       p_nextbis->s_elem = p_curent->s_elem ;  /* curent elm. copy */
       p_curentbis->p_suiv = p_nextbis ;       /* chain updating */
       p_curent = p_curent->p_suiv ;
       p_curentbis = p_nextbis ;
      } /* End of the while (p_curent != NULL)  */

     /* last element initialisation */
     p_newprem->p_last = p_curentbis ;
     p_curentbis->p_suiv = NULL ;
    } ;  /* End of the if p_curent == NULL */
 

 /* second list */ 

  p_curent = p_premlist2->p_first ;
  if (p_curent != NULL)  /* the second list isn't empty */
    {
     if (p_newprem->p_first == NULL ) /* 1st list was empty */
       {
        /* first element of the new list */
        p_curentbis = (ty_node *)malloc (sizeof(ty_node)) ;

        /* Allocation checking */
        Lst_TestPar (p_curentbis, "NO MORE MEMORY AVAILABLE \n", ERRNU) ;
        p_newprem->p_first = p_curentbis ;
        p_newprem->p_cur = NULL ;
        p_curentbis->s_elem = p_curent->s_elem ;
        p_curent = p_curent->p_suiv ;
       } /* End of the if p_newprem->p_first == NULL */

     /* next elements of the new list */
     while (p_curent != NULL)
      {
       p_nextbis = (ty_node *)malloc (sizeof(ty_node)) ;

       /* Allocation checking */
       Lst_TestPar (p_nextbis, "NO MORE MEMORY AVAILABLE \n", ERRNU) ;
       p_nextbis->s_elem = p_curent->s_elem ;  /* copie de l'el. courant */
       p_curentbis->p_suiv = p_nextbis ;       /* m.a.j. du chainage */
       p_curent = p_curent->p_suiv ;
       p_curentbis = p_nextbis ;
      } /* End of the while (p_curent != NULL)  */

     /* last element initialisation */
     p_newprem->p_last = p_curentbis ;
     p_curentbis->p_suiv = NULL ; 
    } ;  /* End of the if p_curent != NULL */
 

#ifdef debug
	(void)fprintf(stderr," End of : AppendList \n");
#endif

  return ((long)p_newprem) ;
  
 } /* End of AppendList */
