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

#ifndef _EngListe
#define _EngListe
#include <stdio.h>

/* Constantes */
#define ERRVI -999999990
#define ERRNU -999999991
#define PASERR 0

typedef long Liste ;

#ifdef _Cplus_plus

#else

/* Availlable functions */
extern long AddElmList (
#if NeedFunctionPrototypes
  Liste s_idlist,                /* Identifier of the list to process */
  long el                       /* Element to insert */
#endif
);

extern Liste AppendList (
#if NeedFunctionPrototypes
  Liste s_idlist1, Liste s_idlist2   /* list identifiers */
#endif
);

extern Liste CopyList (
#if NeedFunctionPrototypes
  Liste s_idlist         /* list to process indentifier */
#endif
);

extern Liste CreatList (
#if NeedFunctionPrototypes
#endif
);

extern long DestElmList (
#if NeedFunctionPrototypes
  Liste s_idlist,                /* list to process indentifier */
  long el                       /* element to remove from the list */
#endif
);

extern long DestList (
#if NeedFunctionPrototypes
  long *s_idlist /* address of the list to process indentifier */
/* RETOUR */
#endif
);

extern long ElmNumList (
#if NeedFunctionPrototypes
  Liste s_idlist,                /* list to process indentifier */
  int j                         /* looked for element */
#endif
);

extern long EmptyList (
#if NeedFunctionPrototypes
  Liste s_idlist         /* list to process indentifier */
#endif
);

extern long FirstElmList (
#if NeedFunctionPrototypes
  Liste s_idlist                 /* list to process indentifier */
#endif
);

extern long InsertSortList (
#if NeedFunctionPrototypes
  Liste s_idlist,                /* list to process indentifier */
  long el,                      /* element to insert */
  long (*function) ()           /* Acces function */
#endif
);

extern long MapList (
#if NeedFunctionPrototypes
  Liste s_idlist,                /* list to process indentifier */
  void (*function) ()           /* Called function */
#endif
);

extern long NextElmList (
#if NeedFunctionPrototypes
  Liste s_idlist         /* List identifier */
#endif
);

extern long PrintList (
#if NeedFunctionPrototypes
  Liste s_idlist,                /* List to process indentifier */
  FILE *fptr                    /* File where to print */
#endif
);

extern long SizeList (
#if NeedFunctionPrototypes
  Liste s_idlist                 /* list to process indentifier */
#endif
);

extern long SortList (
#if NeedFunctionPrototypes
  Liste s_idlist,                /* list to process indentifier */
  long (*function) ()           /* function used to compar the elements */
#endif
);
#endif  /* End of  _Cplus_plus */
#endif  /* End of  _EngListe */
