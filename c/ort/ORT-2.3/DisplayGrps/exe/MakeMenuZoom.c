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

#include "DisplayGrp.h"

extern Widget draw;

static void ChangeZoom ();
static XtCallbackProc MyScrolProc ();	/* Scollbar update */

void MakeMenuZoom (top, newzoom)
  Widget top;
  int *newzoom;
{
  Widget command, menu, entry;
#define NBARG 1			/* Number of arg to create the widgets */
  Arg Args_l[NBARG];

  int n = 0;

  static char *menu_item_names[] = {
    " 1 X ", " 2 X ", " 3 X ", " 4 X ", " 5 X ", " 6 X ",
  };

  XtSetArg (Args_l[n], XtNlabel, (XtArgVal) " Zoom ");
  n++;
  command = XtCreateManagedWidget ("menuZoom", menuButtonWidgetClass, top,
				   Args_l, n);

  n = 0;
  XtSetArg (Args_l[n], XtNlabel, (XtArgVal) " Zoom ");
  n++;
  menu = XtCreatePopupShell ("menu", simpleMenuWidgetClass, command,
			     Args_l, n);

  for (n = 0; n < (int) XtNumber (menu_item_names); n++) {
    char *item = menu_item_names[n];

    entry = XtCreateManagedWidget (item, smeBSBObjectClass, menu,
				   NULL, ZERO);
    XtAddCallback (entry, XtNcallback, ChangeZoom, (XtPointer) newzoom);

  }

}

/* Function Name: ChangeZoom Description: called whenever a menu item is
 * selected. Arguments: w - the menu item that was selected. junk, garbage - ***
 * unused ***. Returns: */

/* ARGSUSED */
static void ChangeZoom (w, junk, garbage)
  Widget w;
  XtPointer junk, garbage;
{
  int *newval = (int *) junk;
  char name[15];
  Arg Args_l[ONE];
  Widget scrl;			/* Scrollbar Widget */
  int n = 0;

  strncpy (name, XtName (w), strlen (XtName (w)));

  InitDrawing ();
  FlushPaper (w, junk, garbage);
  sscanf (XtName (w), "%d", newval);
  DisplayFeatures ();


  if ((scrl = XtNameToWidget (XtParent (draw), "vertical")) != NULL) {
    XtAddCallback (scrl, XtNscrollProc, MyScrolProc, NULL) ;
    XtAddCallback (scrl, XtNjumpProc, MyScrolProc, NULL) ;
  }
  if ((scrl = XtNameToWidget (XtParent (draw), "horizontal")) != NULL) {
    XtAddCallback (scrl, XtNscrollProc, MyScrolProc, NULL) ;
    XtAddCallback (scrl, XtNjumpProc, MyScrolProc, NULL) ;
  }
}

/*****************************************************************************/
/* Function Name: MyScrolProc Description: This function prints a message to
 * stdout. Arguments: w - ** UNUSED ** call_data - ** UNUSED ** client_data - **
 * UNUSED ** Returns: none */

static XtCallbackProc MyScrolProc (w, call_data, client_data)
  Widget w;
  XtPointer call_data, client_data;
{
  FlushPaper () ;
}				/* End of MyScrolProc */
