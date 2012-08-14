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
/** Bibliotheque libList
 * 
 * Auteur : J.Paul Schmidt.
 * Version : 1.1            date : 88/04/14
 * 
 * Modifications : 
 * Auteur : 
 * Reason : 
 * Implemented functionality : Lists handler.
 *
 Interface functions : CreatList
 *                     AddElmList
 *                     AppendList
 *                     CopyList
 *                     CreatList
 *                     DestElmList
 *                     DestList
 *                     ElmNumList
 *                     <PrintList> (pour traces)
 *                     InsertSortList
 *                     EmptyList
 *                     MapList
 *                     FirstElmList
 *                     NextElmList
 *                     SizeList 
 *                     SortList
 **/  
/* ****************************************************************** */

#ifndef _EngListeP 
#define _EngListeP
#include <stdio.h>

/* List node */
typedef struct _st_elem
 {
  long   s_elem ;             /* List element */
  struct _st_elem *p_suiv ;   /* Next element */
  } ty_node ;


/* List */
typedef struct 
 {
  ty_node *p_first ;          /* First node */
  ty_node *p_cur ;            /* Curent node */
  ty_node *p_last ;           /* Last node */
  long num ;                  /* # of elm in the list */
 } ty_list ;

/* Constantes */
#define ERRVI -999999990
#define ERRNU -999999991
#define PASERR 0

/* Macros */
#ifdef debug

#define Lst_TestPar(ptr, mess, err)  \
   { if (ptr == NULL) { \
       fprintf(stderr, mess) ; \
       fprintf(stderr, "file : %s, line : %d \n", __FILE__, __LINE__) ; \
       return (err) ; \
     } ; /* end of the if (ptr == NULL) */ \
   }

#else 

#define Lst_TestPar(ptr, mess, err)   { if (ptr == NULL) return (err) ;}

#endif

/* type */
typedef long Liste ;
#endif
