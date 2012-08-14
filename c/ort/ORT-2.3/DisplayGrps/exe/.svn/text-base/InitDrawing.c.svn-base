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

int ConvertColor ();		/* String to color translation */

extern Widget draw;
extern int zoom;

static GC fgGC;			/* Graphic Context */
static Pixmap pp;		/* Pixmap flushed in the box widget */

#define WinWidth  512
#define WinHeight 512
#define WinDepth 8

/*****************************************************************************/
/* Create a Pixmap, a GC, clear the window */
void InitDrawing ()
{
  XGCValues myXGCV;
  static int first_pass = 1;
  Display *dpy = XtDisplay (draw);
  Arg Args_l[ONE];
  Pixel oldbck;

  /* Get old background */
  XtSetArg (Args_l[ZERO], XtNbackground, &oldbck);
  XtGetValues (draw, Args_l, ONE);

  if (first_pass) {
    /* Create a Pixmap, a GC  */
    pp = XCreatePixmap (dpy, XtWindow (draw),  WinWidth, WinHeight, WinDepth);
    myXGCV.foreground = oldbck;	/* To clear the ``paper'' */
    fgGC = XCreateGC (dpy, pp, GCForeground, &myXGCV);
    first_pass = 0;
  }
  else
    XSetForeground (dpy, fgGC, oldbck);

  /* clear the window */
  XFillRectangle (dpy, pp, fgGC, 0, 0, WinWidth * zoom, WinHeight * zoom);
}				/* End of InitDrawing */

/*****************************************************************************/
/* Draw in the pixmap the line defined by the parameters */
void DrawLine (x1, y1, x2, y2, color)
  int x1, y1, x2, y2;
  Pixel color;
{
  Display *dpy = XtDisplay (draw);

  XSetForeground (dpy, fgGC, color);
  XDrawLine (dpy, pp, fgGC, x1 * zoom, y1 * zoom, x2 * zoom, y2 * zoom);
}				/* End of  DrawLine */

/*****************************************************************************/
/* Draw in the pixmap the arc defined by the parameters */
void DrawCircArc (dir, y0,x0, y1,x1, y2,x2, radius, color)
  int dir, x0,y0, x1,y1, x2,y2, radius;
  Pixel color;
{
  int rsq;
  int size;
  int e,ex,ey,exy,dxe,dye,d2e,dx,dy,xpoint,ypoint;
  int dr;
  int done;
  int end_of_arc;
  int k,l;
  int ArcThickness ;

  Display *dpy = XtDisplay (draw);

  ArcThickness = 1;
  XSetForeground (dpy, fgGC, color);

	size = 512;
	rsq = radius*radius;

    x1 = x1 - x0; y1 = y1 - y0;
    e = x1*x1 + y1*y1 - rsq ;
    dr = -sgn(e) ;

    done = 0;
    while (done != 1) {
 
     if (abs(y1) > abs(x1)) {
           dx = 0 ; 
           dy = sgn(y1)*dr;
     } else {
        if (x1 != 0) {
            dx = sgn(x1)*dr ; 
            dy = 0 ;
        } else {
          dx = 1 ;
          dy = 0 ;
        }
     }

      exy = e + 2*(x1*dx + y1*dy) + 1 ;
      done = (abs(exy) > abs(e)) ;

      if (done == 0) {
          x1 = x1 + dx ;
          y1 = y1 + dy ;
          e = exy ;
      }
   }

    x2 = x2 - x0 ; y2 = y2 - y0 ;
    e = x2*x2 + y2*y2 - rsq ;
    dr = -sgn(e) ;
    done = 0;
    while (done != 1) {
 
     if (abs(y2) > abs(x2)) {
           dx = 0 ; 
           dy = sgn(y2)*dr;
     } else {
        if (x2 != 0) {
            dx = sgn(x2)*dr ; 
            dy = 0 ;
        } else {
          dx = 1 ;
          dy = 0 ;
        }
     }

      exy = e + 2*(x2*dx + y2*dy) + 1 ;
      done = (abs(exy) > abs(e)) ;

      if (done == 0) {
          x2 = x2 + dx ;
          y2 = y2 + dy ;
          e = exy ;
      }
   }

    dx = sgn2(-y1*dir,-x1) ;
    dy = sgn2(x1*dir,-y1) ;
    e = x1*x1 + y1*y1 - rsq ;
    dxe = 2*x1*dx ;
    dye = 2*y1*dy ;
    d2e = 2 ;

    if (dx*dy*dir > 0 ) {
        e = -e ;
        dxe = - dxe ;
        dye = - dye ;
        d2e = - d2e ;
    }

    end_of_arc = 0 ;
    while (end_of_arc != 1) {

          xpoint = x0 + x1 ;
          ypoint = y0 + y1 ;
          if ( (xpoint>=0) && (xpoint<=size) &&
               (ypoint>=0) && (ypoint<=size) ) {

		for (k=(xpoint-ArcThickness);k<=(xpoint+ArcThickness);k++) {
		   for (l=(ypoint-ArcThickness);l<=(ypoint+ArcThickness);l++) {
                	if (k >=0 && l >=0 && k <= size && l <= size)
		  	XDrawPoint (dpy, pp, fgGC, l ,k );
		   }
		}

          }

      ex = e + dxe ;
      ey = e + dye ;
      exy = e + dxe + dye ;

      if  (-exy < ey) {
          x1 = x1 + dx ;
          e = e + dxe ;
          dxe = dxe + d2e ;
      }

      if (exy < -ex) {
          y1 = y1 + dy ;
          e = e + dye ;
          dye = dye + d2e ;
      }

      if (x1 == 0) {
          dy = -dy ;
          dye = -dye + d2e ;
          e = -e ;
          dxe = - dxe ;
          dye = - dye ;
          d2e = - d2e ;
      }

      if (y1 == 0) {
          dx = -dx ; 
          dxe = -dxe + d2e ;
          e = -e ;
          dxe = - dxe ;
          dye = - dye ;
          d2e = - d2e ;
      }
         if ( abs(x1-x2) <= 1 && abs(y1-y2) <= 1)
              end_of_arc = 1;
   }


}				/* End of  DrawCircArc */

int sgn2( x,y )

int x,y;

{
   if (x != 0) {
       return(sgn(x));
   } else {
       return(sgn(y));
   }

}

int sgn( x )

int x;

{  
   if (x <  0) return(-1) ;
   if (x == 0) return( 0) ;
   if (x >  0) return( 1) ;

}

/*****************************************************************************/
/* Flush all the pixmap on the window
 *                                   Arguments: w - ** UNUSED **
 *                                              call_data - *** UNUSED **
 *                                              client_data - ** UNUSED **
 *                                     Returns: none
 */
XtCallbackProc FlushPaper (w, call_data, client_data)
  Widget w;
  XtPointer call_data, client_data;
{
  Display *dpy = XtDisplay (draw);
  Arg Args_l[TWO];
  int hei = WinHeight * zoom;
  int wei = WinWidth * zoom;

  XtSetArg (Args_l[ZERO], XtNheight, (XtArgVal) hei);
  XtSetArg (Args_l[ONE], XtNwidth, (XtArgVal) wei);
  XtSetValues (draw, Args_l, TWO);
  XCopyArea (dpy, pp, XtWindow (draw), fgGC, 0, 0, hei, wei, 0, 0);
}				/* End of FlushPaper */


/*****************************************************************************/
/* Private function to convert String to color */
int ConvertColor (w, color_name)
  Widget w;
  char *color_name;
{
  XrmValue from, to;

  from.size = strlen (color_name) + 1;
  from.addr = color_name;

  /* This conversion accepts a colorname from rgb.txt, or a #rrrgggbbb rgb
   * color definition, or the special toolkit strings "XtDefaultForeground" and
   * "XtDefaultBackground". */

  XtConvert (w, XtRString, (XrmValuePtr) & from, XtRPixel, (XrmValuePtr) & to);
  if (to.addr == NULL) {
    return (-1);
  }

  printf ("Res color :%s =  %d \n", color_name, (int) *((Pixel *) to.addr)) ;
  return ((int) *((Pixel *) to.addr));
};
