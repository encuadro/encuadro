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
#ifndef _DisplayGrp
#define _DisplayGrp

#include <stdio.h>

#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Shell.h>

#include <X11/Xaw/Box.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/List.h>
#include <X11/Xaw/Label.h>
#include <X11/Xaw/Viewport.h>
#include <X11/Xaw/Dialog.h>
#include <X11/Xaw/Cardinals.h>
#include <X11/Xaw/MenuButton.h>
#include <X11/Xaw/SimpleMenu.h>
#include <X11/Xaw/Sme.h>
#include <X11/Xaw/SmeBSB.h>

void DisplayFeatures ();                /* display Tables (eg Tab_lne) */

void OkLoad ();                         /* Valid Dialog question */
void OkMess1 ();                        /* Valid Dialog question */
void OkCol ();                          /* Valid Dialog question */

void ReadORTLines ();                   /* Read ORT Lines */
void ReadORTCircularArcs ();            /* Read ORT circular arcs */
void ReadLPEGPairs ();                  /* Read LPEG groupins of pairs of lines */
void ReadIPEGTriplets ();               /* Read IPEG groupings of sets of 3 lines */
void ReadIPEGPolygons ();               /* Read IPEG polygons */
void InitDrawing ();                    /* Clear the ``paper'' */
void MakeMenuZoom ();                   /* Creat zoom popup */

XtCallbackProc MakeDial ();             /* Make Dialog Widget */
XtCallbackProc DestroyDialog ();        /* Destroy Dialog Widget */
XtCallbackProc MakeMenuCol ();          /* Action done on Color */
XtCallbackProc FlushPaper ();           /* Redisplay drawing window */

void DrawLine ();                       /* Draw a line */
void DrawArc ();                        /* Draw an arc */

#define MAXSEGMENTS 3000

typedef struct {
   Widget father ;
   String label ;
   String value ;
   String translation ;
   XtCallbackProc Callback ;
} DialogArg ;

#endif
  
#ifndef _CPlusToCGrp
#define _CPlusToCGrp

#include <stdio.h>
#include "Liste.h"

/* Structures for interface C++ to C in Grouping */

typedef struct {
   int x ;
   int y ;
} C_I_Pt ;

typedef struct {
   C_I_Pt Start ;
   C_I_Pt End ;
} C_Line ;

typedef struct {
   C_I_Pt Origin ;
   C_I_Pt Start ;
   C_I_Pt Middle ;
   C_I_Pt End ;
   int Direction;
   int Radius;
} C_CircArc ;

typedef struct {
   C_I_Pt Origin ;
   C_I_Pt Start1 ;
   C_I_Pt Middle1 ;
   C_I_Pt End1 ;
   C_I_Pt Start2 ;
   C_I_Pt Middle2 ;
   C_I_Pt End2 ;
   int Direction;
} C_ElipArc ;

typedef struct {
   int x ;
   int y ;
   int z ;
} C_Triplet ;

typedef struct {
   int number;
   int x[MAXSEGMENTS] ;
} C_Polygon ;

#define _Cplus_plus
#ifdef _Cplus_plus
#else
/* -----------------------
 * Interface to Read Image
 */
int Im_Read_ToC (
#ifdef NeedFunctionPrototypes
char *name,                      /* File name where to read */
char *AddIm,                     /* RETURN : Image indentifier */
C_Line **Tab,                    /* RETURN : Table of lines */
long *Num                        /* RETURN : Number of lines */
#endif
) ;

/* ----------------------
 * Interface to Im_ParCol
 */
void Im_Par_ColToC (
#ifdef NeedFunctionPrototypes
char *AddImm,                      /* Image indentifier */
Liste *Par,                        /* RETURN : List of Parallel lines */
Liste *Col                         /* RETURN : List of Parallel lines */
#endif
) ;

#endif /* _Cplus_plus */
#endif /* _CPlusToCGrp */
