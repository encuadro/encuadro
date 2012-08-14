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
/*
 Created by Jean-Paul Schmidt
 Modified by A. Etemadi to handle the types supported by LPEG and IPEG
 and all sorts of other bits and pieces too numerous to mention...
*/


#include "DisplayGrp.h"              /* Def of functios, types, ... */
#include "Liste.h"		         /* Def of Liste */

#define WinWidth  512
#define WinHeight 512

static XtCallbackProc Quit ();	  /* Quit application */
static XtCallbackProc Next ();	  /* Draw Next pair */
static XtCallbackProc LoadFile ();	  /* the callback of the load ok button */
static XtCallbackProc SetFeature (); /* A feature to compute is selected*/

static void MakeDraw ();             /* Widget making */
static void MakeCde ();
static void MakeList ();

static void ClearLists () ;          /* Cancel old lists */

/* ******************* GLOBAL VARIABLES ****************************/

int zoom = 1;			        /* Zoom factor */
int N_lne = 0;			 /* Number of lines */
int N_circ = 0;			 /* Number of circular arcs */
int N_elip = 0;			 /* Number of elliptical arcs */

Pixel Imge = 0;                     /* White */
Pixel Feature[100] = {4,5,3,4,5,6,7,8,9,10,     
                     11,12,13,14,15,16,17,18,19,20,
			21,22,23,24,25,26,27,28,29,30,
			31,32,33,34,35,36,37,38,39,40,
			41,42,43,44,45,46,47,48,49,50,
			51,52,53,54,55,56,57,58,59,60,
			61,62,63,64,65,66,67,68,69,70,
			71,72,73,74,75,76,77,78,79,80,
			81,82,83,84,85,86,87,88,89,90,
			91,92,93,94,95,96,97,98,99,100};   /* Colours of Features */
								/* Starts with yellow, red, yellow */
Widget draw;

C_Line     *Tab_lne  = NULL;		 /* Lines to process */
C_CircArc  *Tab_circ = NULL;		 /* Circular arcs to process */
C_ElipArc  *Tab_elip = NULL;		 /* Elliptical arcs to process */

Liste Lines   	= NULL;		 /* Line segments */
Liste CircArcs   	= NULL;		 /* Circular arcs */
Liste ElipArcs   	= NULL;		 /* Elliptical arcs */

Liste OVPar_lne   	= NULL;		 /* Overlapping Par. lines */
Liste NOVPar_lne  	= NULL;		 /* Non-overlapping Par. lines */
Liste Col_lne     	= NULL;		 /* Colinear lines */
Liste L_jcnt      	= NULL;		 /* L junction */
Liste V_jcnt      	= NULL;		 /* V junctions */
Liste T_jcnt      	= NULL;		 /* T junctions */
Liste Lambda_jcnt 	= NULL;		 /* Lambda Junctions */
Liste Triplet     	= NULL;		 /* Triplets of Junctions */
Liste Y_Corner     	= NULL;		 /* Triplets of Junctions forming corners */
Liste TLambda_Corner = NULL;		 /* Corners involving collinearity */
Liste ClosedPolygon  = NULL;		 /* IPEG Closed Polygons */

/* *****************************************************************/

static Liste CurList = NULL;	 /* Current List of features */
static int SelectedFeature;		 /* Current selected feature */
static int ReDraw;	 	 	/* Whether redrawing is required */

/* Link name/Action for Dialog widget */
 static XtActionsRec actionTable[] = {
   {"OkLoad", OkLoad},
   {"OkLoad", OkMess1},
   {"OkCol", OkCol}
 };

/* Standard Xt ressources */
 static String fallback_resources[] = {
   "*Viewport*allowVert: True",
   "*Viewport*allowHoriz: True",
   NULL,
 };

/* Parameters to set a dialog widget with MakeDial */
 static DialogArg loaddiag = {
  NULL,
  "File name to process ?",
  "",
  " <Key>Return: OkLoad()",
  OkLoad
 };

 static DialogArg errdiag = {
   NULL,
   NULL,
   NULL,
   NULL,
   OkMess1,
 };

static String meserr0 = {" (Re)Select a Feature First "} ;
static String meserr1 = {" Load a file "} ;
static String meserr2 = {" This feature \n is not implemented yet...  "} ;
static String meserr3 = {" There in no such feature \n in this data set."} ;

 static String selectfea[] = {  /* Feature selection */
    "Lines",
    "Circular-Arcs",
    "OV-Parallel",
    "NOV-Parallel",
    "Collinear",
    "L-Junctions",
    "V-Junctions  ",
    "T-Junctions ",
    "Lambda-Junctions",
    "Triplets",
    "Y-Corners",
    "TLambda-Corners",
    "Closed-Polygons",
    NULL
  };

/*****************************************************************************/

main (argc, argv)

  int argc;
  char **argv;

{

  static void Syntax ();                  /* Usage of the pgm */
  XtAppContext app_con;
  Arg Args_l[FIVE];
  Widget toplevel, frame, menu, viewbox;
  int n;			              /* Argument counter */

  toplevel = XtAppInitialize (&app_con, "DisplayPEG", NULL, ZERO, 
			         &argc, argv, NULL, NULL, ZERO);

  if (argc != 1) Syntax (app_con, argv[0]);

  XtAppAddActions (app_con, actionTable, XtNumber (actionTable));

/* Widget containing the menu and the viewport to draw inside */
  frame = XtCreateManagedWidget ("outerbox", formWidgetClass, toplevel,
				     NULL, ZERO);

/* Widget containing the menu */
  n = 0;
  XtSetArg (Args_l[n], XtNborderWidth, ZERO);  n++; /* no to see the border */
  XtSetArg (Args_l[n], XtNtop, XtChainTop);    n++;
  XtSetArg (Args_l[n], XtNbottom, XtChainTop); n++;
  menu = XtCreateManagedWidget ("menubox", boxWidgetClass, frame, Args_l, n);

/* Viewport Widget containing the drawing window  */
  n = 0;
  XtSetArg (Args_l[n], XtNallowVert,  TRUE); 	  n++;
  XtSetArg (Args_l[n], XtNallowHoriz, TRUE); 	  n++;
  XtSetArg (Args_l[n], XtNfromVert,   menu);   	  n++;
  XtSetArg (Args_l[n], XtNtop,        XtChainTop); n++;
  viewbox = XtCreateManagedWidget ("viewbox", viewportWidgetClass, frame,
				        Args_l, n);
/* Drawing window */
  n = 0;
  XtSetArg (Args_l[n], XtNheight, (XtArgVal) WinHeight);   n++;
  XtSetArg (Args_l[n], XtNwidth,  (XtArgVal) WinWidth);    n++; /* Background */
  XtSetArg (Args_l[n], XtNbackground, (XtArgVal) 1);       n++; /* colour = Black */
  draw = XtCreateManagedWidget ("draw", boxWidgetClass, viewbox, Args_l, n);

/* Menu making */
  MakeCde (" Quit ", Quit, menu, NULL);
  MakeCde (" Next ", Next, menu, "1");
  MakeCde (" Redisplay ", FlushPaper, menu, "1");
  MakeMenuColor (menu);
  MakeMenuZoom (menu, &zoom);

  n = 0;
  XtSetArg (Args_l[n], XtNlabel,(XtArgVal) " Load "); n++;
  loaddiag.father = XtCreateManagedWidget (" Load ", commandWidgetClass, menu,
					        Args_l, n);
  XtAddCallback (loaddiag.father, XtNcallback, MakeDial, (XtPointer)&loaddiag);

  MakeList (menu, selectfea, SetFeature, NULL);
  XtRealizeWidget (toplevel);
  InitDrawing ();
  XtAppMainLoop (app_con);
}

/*****************************************************************************/
/* Function Name: Syntax Description: Prints a the calling syntax for this
 * function to stdout. Arguments: app_con - the application context.
 *                                   call - the name of the application.
 *                     Returns: none - exits tho.
 */

static void Syntax (app_con, call)
  XtAppContext app_con;
  char *call;
{
  XtDestroyApplicationContext (app_con);
  fprintf (stderr, "Usage: %s\n", call);
  fprintf (stderr, "Version 1.2: %s\n", call);
  exit (1);
}

/*****************************************************************************/
static void MakeCde (name, func, fath, param)
  String name;			/* Name of the command widget */
  XtCallbackProc func;		/* Function to be called bu the command */
  Widget fath;			/* Father of the widget */
  XtPointer param;		       /* Parrameter sent to the function */

{
#define NBARG 1			/* Number of arg to create a command */
  Arg Args_l[NBARG];
  Widget cmd;			       /* Created Widget */
  int n = 0;

  XtSetArg (Args_l[n], XtNlabel, (XtArgVal) name); n++;
  cmd = XtCreateManagedWidget (name, commandWidgetClass, fath, Args_l, n);
  XtAddCallback (cmd, XtNcallback, func, param);

}				/* End of MakeCde */

/*****************************************************************************/

static void MakeList (fath, lst, func, client_data)
  Widget fath;			/* Father of the widget */
  String lst ;                     /* List of button names */
  XtCallbackProc func ;            /* func : Function called on selection */
  XtPointer client_data ;          /* func parameters */

{
  Arg args[1];
  Widget list;

  XtSetArg (args[0], XtNlist, lst);
  list = XtCreateManagedWidget ("listFeat", listWidgetClass, fath, args, ONE);
  XtAddCallback (list, XtNcallback, func, (XtPointer)client_data);

}				/* End of MakeList */

/*****************************************************************************/
/* Function Name: SetFeature Description:
 *
 * Called when a feature has been selected and set the current list.
 *           Arguments: w, cl_data - *** UNUSED ***.
 *                       call_data - a pointer to the list info structure.
 *           Returns: none
 */

static XtCallbackProc SetFeature (w, cl_data, call_data)
  Widget w;
  XtPointer cl_data, call_data;
{
  XawListReturnStruct *item = (XawListReturnStruct *) call_data;
  printf ("Selected item %d; \"%s\"\n", item->list_index, item->string);
  DisplayFeatures (Tab_lne, N_lne, Tab_circ, N_circ);
  ReDraw = -1;

  switch (item->list_index) {
  case 0:			/* Lines */
    CurList = Lines;
    SelectedFeature = 0;
    break;

  case 1:			/* Circular Arcs */
    CurList = CircArcs;
    SelectedFeature = 1;
    break;

  case 2:			/* Overlapping Parallel Lines */
    CurList = OVPar_lne;
    SelectedFeature = 2;
    break;

  case 3:			/* Non-overlapping parallel lines */
    CurList = NOVPar_lne;
    SelectedFeature = 3;
    break;

  case 4:			/* Collinear lines */
    CurList = Col_lne;
    SelectedFeature = 4;
    break;

  case 5:			/* L Junctions */
    CurList = L_jcnt;
    SelectedFeature = 5;
    break;

  case 6:			/* V Junctions */
    CurList = V_jcnt;
    SelectedFeature = 6;
    break;

  case 7:			/* T Junctions */
    CurList = T_jcnt;
    SelectedFeature = 7;
    break;

  case 8:			/* Lambda Junctions */
    CurList = Lambda_jcnt;
    SelectedFeature = 8;
    break;

  case 9:			/* Triplets */
    CurList = Triplet;
    SelectedFeature = 9;
    break;

  case 10:			/* Y-Corners */
    CurList = Y_Corner;
    SelectedFeature = 10;
    break;

  case 11:			/* TLambda-Corners */
    CurList = TLambda_Corner;
    SelectedFeature = 11;
    break;

  case 12:			/* Closed Polygon */
    CurList = ClosedPolygon;
    SelectedFeature = 12;
    break;

  }				/* End of switch */

}				/* End of SetFeature */


/*****************************************************************************/
/* Function Name: Quit
 *                     Description: This function prints a message to stdout.
 *                       Arguments: w - ** UNUSED **
 *                          call_data - ** UNUSED **
 *                        client_data - ** UNUSED **
 * Returns: none */

static XtCallbackProc Quit (w, call_data, client_data)
  Widget w;
  XtPointer call_data, client_data;
{

  XtDestroyApplicationContext (XtWidgetToApplicationContext (w));
  exit (0);
}				/* End of Quit */

/*****************************************************************************/
/* Function Name: Next
 *                     Description: This function prints a message to stdout.
 *                       Arguments: w - ** UNUSED **
 *                          call_data - ** UNUSED **
 *                        client_data - ** UNUSED **
 * Returns: none */

static XtCallbackProc Next (w, call_data, client_data)
  Widget w;
  XtPointer call_data, client_data;
{
  int i;
  int line;
  int circ;
  int elip;

  C_I_Pt    *pair;		/* Features */
  C_Triplet *triplet;
  C_Polygon *polygon;

  long val;			/* Buffer */
  static int old[100];	/* Previous features */

/*
 Find out which features are to be displayed
*/
  if (CurList == NULL) {
    errdiag.father = w;
    if (Tab_lne == NULL) errdiag.label = meserr1 ;
      else  errdiag.label = meserr0;
            MakeDial (w, &errdiag, NULL);
    return;
  }

  val = NextElmList (CurList);
  if (val == ERRVI) val = FirstElmList (CurList);
  if (val == ERRVI) {
    errdiag.father = w;
    errdiag.label = meserr3 ;
    MakeDial (w, &errdiag, NULL);
    return;
  }

/* 
 Redraw Lines
*/
   if (SelectedFeature == 0) {   /* Lines */
     if (ReDraw >= 0) {
    	  DrawLine (Tab_lne[old[0]].Start.x, Tab_lne[old[0]].Start.y,
	      	     Tab_lne[old[0]].End.x,   Tab_lne[old[0]].End.y, Imge);
     }
   }

/* 
 Redraw CircArcs
*/
   if (SelectedFeature == 1) {   /* CircularArcs */
     if (ReDraw >= 0) {
    	   DrawCircArc (Tab_circ[old[0]].Direction,  Tab_circ[old[0]].Origin.x, 
             		  Tab_circ[old[0]].Origin.y,   Tab_circ[old[0]].Start.x, 
            		  Tab_circ[old[0]].Start.y,    Tab_circ[old[0]].End.x,
            		  Tab_circ[old[0]].End.y,      Tab_circ[old[0]].Radius, Imge);
     }
   }

/* 
 Redraw LPEG groupings
*/
   if (SelectedFeature > 1 && SelectedFeature < 9) {   /* LPEG groupings */
     if (ReDraw >= 0) {
	for (i=0; i<2 ; i++) {
    	  DrawLine (Tab_lne[old[i]].Start.x, Tab_lne[old[i]].Start.y,
	      	     Tab_lne[old[i]].End.x,   Tab_lne[old[i]].End.y, Imge);
	}
     }
   }

/* 
 Redraw IPEG Triplet and Corner groupings
*/

   if (SelectedFeature >= 9 && 
       SelectedFeature < 12) { /* IPEG triplets, Y and Tlambda Corners */
     if (ReDraw >= 0) {
	for (i=0; i<3 ; i++) {
    	  DrawLine (Tab_lne[old[i]].Start.x, Tab_lne[old[i]].Start.y,
	      	     Tab_lne[old[i]].End.x,   Tab_lne[old[i]].End.y, Imge);
	}
     }
   }

/* 
 Redraw IPEG Polygon groupings
*/
   if (SelectedFeature == 12) { /* IPEG Polygons */
   polygon = (C_Polygon *) val;
     if (ReDraw >= 0) {
	for (i=0; i<(polygon->number); i++) {
    	  DrawLine (Tab_lne[old[i]].Start.x, Tab_lne[old[i]].Start.y,
	      	     Tab_lne[old[i]].End.x,   Tab_lne[old[i]].End.y, Imge);
	}
     }
   }
/* 
 Highlight Lines
*/

   if (SelectedFeature == 0) { /* Lines */
    ReDraw = 1;
    line = val;
    old[0] = line;
    	  DrawLine (Tab_lne[old[0]].Start.x, Tab_lne[old[0]].Start.y,
	      	     Tab_lne[old[0]].End.x,   Tab_lne[old[0]].End.y, Feature[0]);
    if (old[0] == 0) {
    	printf ("Start of List:\n");
    } else {
    	printf ("ID = %d \n", old[0]);
    }
    FlushPaper (NULL, NULL, NULL);
   }

/* 
 Highlight CircularArcs
*/

   if (SelectedFeature == 1) { /* Circular Arcs */
    ReDraw = 1;
    circ = val;
    old[0] = circ;
    	   DrawCircArc (Tab_circ[old[0]].Direction,  Tab_circ[old[0]].Origin.x, 
             		  Tab_circ[old[0]].Origin.y,   Tab_circ[old[0]].Start.x, 
            		  Tab_circ[old[0]].Start.y,    Tab_circ[old[0]].End.x,
            		  Tab_circ[old[0]].End.y,      Tab_circ[old[0]].Radius, Feature[1]);
    if (old[0] == 0) {
    	printf ("Start of List:\n");
    } else {
    	printf ("ID = %d \n", old[0]);
    }
    FlushPaper (NULL, NULL, NULL);
   }

/* 
 Highlight LPEG groupings
*/

   if (SelectedFeature > 1 && SelectedFeature < 9) { /* LPEG groupings */
    ReDraw = 1;
    pair = (C_I_Pt *) val;
    old[0] = pair->x;
    old[1] = pair->y;
    for (i=0; i<2 ; i++) {
    	  DrawLine (Tab_lne[old[i]].Start.x, Tab_lne[old[i]].Start.y,
	      	     Tab_lne[old[i]].End.x,   Tab_lne[old[i]].End.y, Feature[i]);
    }
    if (old[0] == 0) {
    	printf ("Start of List:\n");
    } else {
    	printf ("ID1 =   %d   ID2 =   %d\n", old[0],old[1]);
    }
    FlushPaper (NULL, NULL, NULL);
   }

/* 
 Highlight IPEG Triplet and Corner groupings
*/

   if (SelectedFeature >= 9 &&
       SelectedFeature < 12) { /* IPEG Groupings */
    ReDraw = 1;
    triplet = (C_Triplet *) val;
    old[0] = triplet->x;
    old[1] = triplet->y;
    old[2] = triplet->z;
    for (i=0; i<3 ; i++) {
    	  DrawLine (Tab_lne[old[i]].Start.x, Tab_lne[old[i]].Start.y,
	      	     Tab_lne[old[i]].End.x,   Tab_lne[old[i]].End.y, Feature[i]);
    }
    if (old[0] == 0) {
    	printf ("Start of List:\n");
    } else {
	printf ("ID1 =   %d   ID2 =   %d   ID3 =   %d  \n", old[0],old[1],old[2]);
    }
    FlushPaper (NULL, NULL, NULL);
   }
/* 
 Highlight IPEG Polygon groupings
*/

   fprintf(stderr,"New Set\n");
   if (SelectedFeature == 12) { /* IPEG Polygons */
    ReDraw = 1;
	for (i=0; i< (polygon->number); i++) {
    		old[i] = polygon->x[i];
	}
    for (i=0; i< (polygon->number); i++) {
    	  DrawLine (Tab_lne[old[i]].Start.x, Tab_lne[old[i]].Start.y,
	      	     Tab_lne[old[i]].End.x,   Tab_lne[old[i]].End.y, Feature[4]);
    }
    if (old[0] == 0)
    	printf ("Start of List:\n");
    FlushPaper (NULL, NULL, NULL);
   }

}				/* End of Next */

/*****************************************************************************/
void DisplayFeatures ()
{
  int i;			/* Loop index */

  InitDrawing ();

  if (N_lne != 0) {

  	for (i = 1; i <= N_lne; i++) {
    		DrawLine (Tab_lne[i].Start.x, Tab_lne[i].Start.y, 
              	   Tab_lne[i].End.x,   Tab_lne[i].End.y, Imge);
  	}

  }

  if (N_circ != 0) {

  	for (i = 1; i <= N_circ; i++) {
    	   DrawCircArc (Tab_circ[i].Direction,  Tab_circ[i].Origin.x, 
             		  Tab_circ[i].Origin.y,   Tab_circ[i].Start.x, 
            		  Tab_circ[i].Start.y,    Tab_circ[i].End.x,
            		  Tab_circ[i].End.y,      Tab_circ[i].Radius, Imge);
     	}
  }

	FlushPaper (NULL, NULL, NULL);

}				/* End of DisplayFeatures*/


/*****************************************************************************/
/* Function Name: OkLoad Description: An action routine that is invoked from
 * any child of the dialog widget.  This routine will also color the command
 * button that activated the popup.
 * Arguments: widget - the child of the dialog that caused this action.
 *            event, params, num_params - *** UNUSED ***.
 * Returns: none
 */

void OkLoad (widget, event, params, num_params)
  Widget widget;
  XEvent *event;
  String *params;
  Cardinal *num_params;
{
  Widget dialog = XtParent (widget);

  LoadFile (widget, (XtPointer) dialog, (XtPointer) NULL);
}

/*****************************************************************************/
/* Function Name: LoadFile Description: This is a callback function that
 * performs the actual task of coloring in the command button.
 * Arguments: w - *** UNUSED ***.
 *            client_data - a pointer to the dialog widget.
 *            call_data - *** * UNUSED ***.
 *            Returns: none
*/

static XtCallbackProc LoadFile (w, client_data, call_data)
  Widget w;
  XtPointer client_data, call_data;
{
  Widget dialog = (Widget) client_data;
  Widget button = XtParent (XtParent (dialog));
  String cname = XawDialogGetValueString (dialog);
  Arg args[3];
  int size;


  FILE *des = fopen (cname, "r");

  if (des != NULL) {
    ClearLists () ;
    ReadORTLines       (des, &Tab_lne,  &Lines,    "#Lines",        &N_lne);
    ReadORTCircularArcs(des, &Tab_circ, &CircArcs, "#CircularArcs", &N_circ);
    DisplayFeatures ();
    ReadLPEGPairs    (des, &OVPar_lne,  	 "#OVParallel");
    ReadLPEGPairs    (des, &Col_lne,    	 "#Collinear");
    ReadLPEGPairs    (des, &NOVPar_lne, 	 "#NOVParallel");
    ReadLPEGPairs    (des, &L_jcnt,     	 "#L_Junctions");
    ReadLPEGPairs    (des, &V_jcnt,     	 "#V_Junctions");
    ReadLPEGPairs    (des, &T_jcnt,     	 "#T_Junctions");
    ReadLPEGPairs    (des, &Lambda_jcnt,	 "#Lambda_Junctions");
    ReadIPEGTriplets (des, &Triplet,    	 "#Triplet");
    ReadIPEGTriplets (des, &Y_Corner,	 "#Y_Corner");
    ReadIPEGTriplets (des, &TLambda_Corner,"#TLambda_Corner");
    ReadIPEGPolygons (des, &ClosedPolygon, "#ClosedPolygon");
    DestroyDialog (NULL, (XtPointer) dialog, (XtPointer) NULL);
  }
  else {			/* des < 0  ==> error. */
    char str[BUFSIZ];
    (void) sprintf (str, "Can't open file \"%s\".", cname);

    XtSetArg (args[0], XtNlabel, str);
    XtSetArg (args[1], XtNvalue, "");
    XtSetValues (dialog, args, TWO);
  }
}				/* End of LoadFile */

void OkMess1 (widget, event, params, num_params)
  Widget widget;
  XEvent *event;
  String *params;
  Cardinal *num_params;
{
  Widget dialog = XtParent (widget);
  DestroyDialog (NULL, (XtPointer) dialog, (XtPointer) NULL);
}

static void  ClearLists (w) 
{
 if (Lines 		!= NULL) DestList (&Lines);
 if (CircArcs	 	!= NULL) DestList (&CircArcs);
 if (ElipArcs	 	!= NULL) DestList (&ElipArcs);
 if (OVPar_lne 	!= NULL) DestList (&OVPar_lne);
 if (NOVPar_lne 	!= NULL) DestList (&NOVPar_lne);
 if (Col_lne 		!= NULL) DestList (&Col_lne);
 if (L_jcnt 		!= NULL) DestList (&L_jcnt);
 if (V_jcnt 		!= NULL) DestList (&V_jcnt);
 if (T_jcnt 		!= NULL) DestList (&T_jcnt);
 if (Lambda_jcnt 	!= NULL) DestList (&Lambda_jcnt);
 if (Triplet 		!= NULL) DestList (&Triplet);
 if (Y_Corner 	!= NULL) DestList (&Y_Corner);
 if (TLambda_Corner 	!= NULL) DestList (&TLambda_Corner);
 if (ClosedPolygon	!= NULL) DestList (&ClosedPolygon);
 CurList = NULL ;
}
