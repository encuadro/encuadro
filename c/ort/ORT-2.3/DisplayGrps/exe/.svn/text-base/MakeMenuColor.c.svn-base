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

extern Pixel Imge;		/* Main lines color */
extern Pixel Feature[100];	/* Highlighted line color */
extern Widget draw;		/* Drawing widget */

static void ColorTheButton ();	/* Color the menu and set the line color */
static void InitForeground ();	/* As indicated */


#define BCK_NME " Background "
#define BCK_NUM 0
#define LNE_NME " Lines "
#define LNE_NUM 1

#define FEA_NME1  " Feature1 "
#define FEA_NUM1 2

#define FEA_NME2  " Feature2 "
#define FEA_NUM2 3

#define FEA_NME3  " Feature3 "
#define FEA_NUM3 4

#define FEA_NME4  " Corner "
#define FEA_NUM4 5

#define FEA_NME5  " Polygon "
#define FEA_NUM5 6

static char *menu_item_names[] = {
  BCK_NME, LNE_NME, FEA_NME1, FEA_NME2, FEA_NME3, FEA_NME4, FEA_NME5,
};
static Arg NewBckrd[XtNumber (menu_item_names)][ONE];
static Widget entry[XtNumber (menu_item_names)];
static DialogArg dargs = {
  NULL,
  "What color to be set ?",
  "",
  " <Key>Return: OkCol()",
  OkCol
};


void MakeMenuColor (top)
  Widget top;
{
#define LABEL "What color to be set ?"
#define VALUE ""
#define TRANS " <Key>Return: OkCol()"

#define NBARG 1			/* Number of arg to create the widgets */
  Arg Args_l[NBARG];
  Widget command, menu;

  static first = 1;
  int n = 0;

  if (first) {
    InitForeground ();
    first = 0;
  }


  XtSetArg (Args_l[n], XtNlabel, (XtArgVal) " Color ");
  n++;
  command = XtCreateManagedWidget ("menuColor", menuButtonWidgetClass, top,
				   Args_l, n);

  n = 0; XtSetArg (Args_l[n], XtNlabel, (XtArgVal) " Color "); n++;
  menu = XtCreatePopupShell ("menu", simpleMenuWidgetClass, command,
			        Args_l, n);

  dargs.father = menu;

  for (n = 0; n < (int) XtNumber (menu_item_names); n++) {
    char *item = menu_item_names[n];

    entry[n] = XtCreateManagedWidget (item, smeBSBObjectClass, menu,
				      NewBckrd[n], ONE);
    XtAddCallback (entry[n], XtNcallback, MakeDial, (XtPointer) & dargs);

  }

}

/* Function Name: ColorTheButton Description: This is a callback function that
 * performs the actual task of coloring in the command button. Arguments: w - ***
 * UNUSED ***. client_data - a pointer to the dialog widget. call_data - ***
 * UNUSED ***. Returns: none */

/* ARGSUSED */
static void ColorTheButton (w, client_data, call_data)
  Widget w;
  XtPointer client_data, call_data;
{
  Widget dialog = (Widget) client_data;
  Widget button = XtParent (XtParent (dialog));
  int pixel;
  String cname = XawDialogGetValueString (dialog);
  Arg args[3];

  pixel = ConvertColor (button, cname);

  if (pixel > 0) {
    if (strncmp (BCK_NME, XtName (dialog), strlen (BCK_NME)) == 0) {
      XtSetArg (NewBckrd[BCK_NUM][0], XtNbackground, pixel);
      XtSetValues (draw, NewBckrd[BCK_NUM], ONE);
      NewBckrd[BCK_NUM][0].name = XtNforeground;
      XtSetValues (entry[BCK_NUM], NewBckrd[BCK_NUM], ONE);
      DisplayFeatures ();
    } /* else */
    if (strncmp (LNE_NME, XtName (dialog), strlen (LNE_NME)) == 0) {
      Imge = pixel;
      XtSetArg (NewBckrd[LNE_NUM][0], XtNforeground, (XtArgVal) Imge);
      XtSetValues (entry[LNE_NUM], NewBckrd[LNE_NUM], ONE);
      DisplayFeatures ();
    } /* else */
    if (strncmp (FEA_NME1, XtName (dialog), strlen (FEA_NME1)) == 0) {
      Feature[0] = pixel;
      XtSetArg (NewBckrd[FEA_NUM1][0], XtNforeground, (XtArgVal) Feature[0]);
      XtSetValues (entry[FEA_NUM1], NewBckrd[FEA_NUM1], ONE);
    } /* else */
    if (strncmp (FEA_NME2, XtName (dialog), strlen (FEA_NME2)) == 0) {
      Feature[1] = pixel;
      XtSetArg (NewBckrd[FEA_NUM2][0], XtNforeground, (XtArgVal) Feature[1]);
      XtSetValues (entry[FEA_NUM2], NewBckrd[FEA_NUM2], ONE);
    } /* else */
    if (strncmp (FEA_NME3, XtName (dialog), strlen (FEA_NME3)) == 0) {
      Feature[2] = pixel;
      XtSetArg (NewBckrd[FEA_NUM3][0], XtNforeground, (XtArgVal) Feature[2]);
      XtSetValues (entry[FEA_NUM3], NewBckrd[FEA_NUM3], ONE);
    } /* else */
    if (strncmp (FEA_NME4, XtName (dialog), strlen (FEA_NME4)) == 0) {
      Feature[3] = pixel; 
      XtSetArg (NewBckrd[FEA_NUM4][0], XtNforeground, (XtArgVal) Feature[3]);
      XtSetValues (entry[FEA_NUM4], NewBckrd[FEA_NUM4], ONE);
    } /* else */
    if (strncmp (FEA_NME5, XtName (dialog), strlen (FEA_NME5)) == 0) {
      Feature[4] = pixel; 
      XtSetArg (NewBckrd[FEA_NUM5][0], XtNforeground, (XtArgVal) Feature[4]);
      XtSetValues (entry[FEA_NUM5], NewBckrd[FEA_NUM5], ONE);
    } /* else */
    DestroyDialog (NULL, (XtPointer) dialog, (XtPointer) NULL);
  }
  else {			/* pixel < 0  ==> error. */
    char str[BUFSIZ];
    (void) sprintf (str, "Can't get color \"%s\".  Try again.", cname);

    XtSetArg (args[0], XtNlabel, str);
    XtSetArg (args[1], XtNvalue, "");
    XtSetValues (dialog, args, TWO);
  }
}

/* Function Name: OkCol Description: An action routine that is invoked from any
 * child of the dialog widget.  This routine will also color the command button
 * that activated the popup. Arguments: widget - the child of the dialog that
 * caused this action. event, params, num_params - *** UNUSED ***. Returns:
 * none */

/* ARGSUSED */
void OkCol (widget, event, params, num_params)
  Widget widget;
  XEvent *event;
  String *params;
  Cardinal *num_params;
{
  ColorTheButton (widget, (XtPointer) XtParent (widget), (XtPointer) NULL);
}

static void InitForeground ()
{
  Pixel bck;			/* drawing widget backgound */

  XtSetArg (NewBckrd[BCK_NUM][0], XtNbackground,  (XtArgVal) & bck);
  XtGetValues (draw, NewBckrd[BCK_NUM], ONE);
  XtSetArg (NewBckrd[BCK_NUM][0], XtNbackground,  (XtArgVal) bck);
  NewBckrd[BCK_NUM][0].name = XtNforeground;
  XtSetArg (NewBckrd[LNE_NUM][0],  XtNforeground, (XtArgVal) Imge);
  XtSetArg (NewBckrd[FEA_NUM1][0], XtNforeground, (XtArgVal)Feature[0]);
  XtSetArg (NewBckrd[FEA_NUM2][0], XtNforeground, (XtArgVal)Feature[1]);
  XtSetArg (NewBckrd[FEA_NUM3][0], XtNforeground, (XtArgVal)Feature[2]);
  XtSetArg (NewBckrd[FEA_NUM4][0], XtNforeground, (XtArgVal)Feature[3]);
  XtSetArg (NewBckrd[FEA_NUM5][0], XtNforeground, (XtArgVal)Feature[4]);
}
