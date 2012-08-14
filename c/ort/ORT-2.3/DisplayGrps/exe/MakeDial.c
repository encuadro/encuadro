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


/* Function Name: MakeDial Description: Make a dialog widget Arguments: button
 * - the menu item that was selected. call_data - *** unused ***. client_data,
 * Function to call on Ok; Label Value father Returns: */

/* ARGSUSED */
XtCallbackProc MakeDial (button, client_data, call_data)
  Widget button;
  XtPointer client_data, call_data;
{

  Arg args[5];
  Widget popup, dialog;
  Position x, y;
  Dimension width, height;
  Cardinal n;

  DialogArg *darg = (DialogArg *) client_data;
  /* This will position the upper left hand corner of the popup at the center
   * of the widget which invoked this callback, which will also become the
   * parent of the popup.  I don't deal with the possibility that the popup
   * will be all or partially off the edge of the screen. */

  n = 0;
  XtSetArg (args[0], XtNwidth, &width);
  n++;
  XtSetArg (args[1], XtNheight, &height);
  n++;
  XtGetValues (button, args, n);
  XtTranslateCoords (button, (Position) (width / 2), (Position) (height / 2),
		     &x, &y);

  n = 0;
  XtSetArg (args[n], XtNx, x);
  n++;
  XtSetArg (args[n], XtNy, y);
  n++;

  popup = XtCreatePopupShell ("Load", transientShellWidgetClass, darg->father,
			      args, n);

  /* The popup will contain a dialog box, prompting the user for input. */

  n = 0;
  XtSetArg (args[n], XtNlabel, (XtArgVal) darg->label);
  n++;
  XtSetArg (args[n], XtNresizable, (XtArgVal) TRUE);
  n++;
  XtSetArg (args[n], XtNinput, (XtArgVal) TRUE);
  n++;
  if (darg->value != NULL) {
    XtSetArg (args[n], XtNvalue, (XtArgVal) "");
    n++;
  }
  dialog = XtCreateManagedWidget (XtName (button), dialogWidgetClass, popup,
				  args, n);

  XawDialogAddButton (dialog, "ok", darg->Callback, (XtPointer) dialog);

  if (darg->translation != NULL) {	/* Only display message */
    XtOverrideTranslations (XtNameToWidget (dialog, "value"),
			    XtParseTranslationTable (darg->translation));
    XawDialogAddButton (dialog, "cancel", DestroyDialog, (XtPointer) dialog);
  }

  XtPopup (popup, XtGrabExclusive);
}

/* Function Name: DestroyDialog Description: Destroys the popup dialog widget.
 * Arguments: w - *** UNUSED ***. client_data - the dialog widget.  This widget
 * is a direct child of the popup shell to destroy. call_data - *** UNUSED **.
 * Returns: none. */

/* ARGSUSED */
XtCallbackProc DestroyDialog (widget, client_data, call_data)
  Widget widget;
  XtPointer client_data, call_data;
{
  Widget popup = XtParent ((Widget) client_data);
  XtDestroyWidget (popup);
}
