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
#ifndef _MACROS
#define _MACROS

#include <errno.h>

/* ************************************************************************** */
/* Operators                                                                  */
/* ************************************************************************** */

#ifndef FABS
#define FABS(a)		( (float) fabs((float)a))
#endif

#ifndef ABS
#define ABS(a)		( (a) < 0 ? (-a) : (a) )
#endif

#ifndef MIN
#define MIN(a, b)	( (a) < (b) ? (a) : (b) )
#endif

#ifndef MAX
#define MAX(a, b)	( (a) > (b) ? (a) : (b) )
#endif

#define SIGNE(x, b)	( (x) > (b) ? (1) : (((x) < (-1*(b)) ? (-1) :  (0)) ) )


/* ************************************************************************** */
/* Error handling                                                             */
/* ************************************************************************** */

static char *MES[] = {
#ifdef FRENCH
" Allocation impossible dans ",                                 /* 00 */
", ligne ",                                                     /* 01 */
" : sans doute plus de memoire disponible  \n",                 /* 02 */
" Erreur pointeur a nil dans ",                                 /* 03 */
" retourne : Erreur systeme No ",                               /* 04 */
", dans ",                                                      /* 05 */
" Erreur de parametres dans "                                   /* 06 */
#else
" Unable to alloc memory in ",                                  /* 00 */
", line ",                                                      /* 01 */
" : probably no more available. \n",                            /* 02 */
" Error : null pointer in ",                                    /* 03 */
" returned : System error No ",                                 /* 04 */
", in ",                                                        /* 05 */
" Parameters error in "                                         /* 06 */
#endif  /* End of #ifdef FRENCH */
} ;

#define PRINT_ERR(m1, m2, m3) \
           fprintf (stderr, "%s%s%s%d%s",m1, __FILE__, m2, __LINE__, m3)

#define V_NOMEM(p)  { \
  if ((p) == NULL) { \
    PRINT_ERR (MES[0], MES[1], MES[2]) ; \
    return ; \
  } \
}  /* End of macros V_NOMEM */
 
#define NOMEM(p, r)  { \
  if ((p) == NULL) { \
    PRINT_ERR (MES[0], MES[1], MES[2]) ; \
    return (r) ; \
  } \
}  /* End of macros NOMEM */
 
#define V_TSTNULL(p, mess)  { \
  if ((p) == NULL) { \
    PRINT_ERR (MES[3], MES[1], mess) ; \
    return ; \
  } \
}  /* End of macros V_TSTNULL */
 
#define TSTNULL(p, mess, r)  { \
  if ((p) == NULL) { \
    PRINT_ERR (MES[3], MES[1], mess) ; \
    return (r) ; \
  } \
}  /* End of macros TSTNULL */
 
#define ERRNULL(p, mess)  { \
  if ((p) == NULL) { \
        PRINT_ERR (MES[3], MES[1], mess) ; \
    exit (-1) ; \
  } \
}  /* End of macros ERRNULL */

#define ERRPAR(mess)    { \
  PRINT_ERR (MES[6], MES[1], mess) ; \
  exit (-1) ;  \
}  /* End of macros ERRPAR */

#define ERRSY(n, mess)    { \
  if (n < 0) { \
   fprintf (stderr, "%d%s%d%s%s%s%d%s", \
      n, MES[4], errno, MES[5], __FILE__, MES[1], __LINE__, mess) ;\
   exit (n) ; \
  } \
}  /* End of macros ERRSY */ */

/* ************************************************************************** */
/* CONSTANTES                                                                 */
/* ************************************************************************** */


#ifndef TRUE
#define TRUE  1
#endif

#ifndef FALSE
#define FALSE 0
#endif        

#endif          /* _MACROS */

