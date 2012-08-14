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
#include <stdio.h>
#define HEIGHT 512
#define WIDTH  512
int DrawCircularArc ( x2,y2, x1,y1, x0,y0, dir, rsq, 
			 ArcIntensity, ArcThickness,
			 EndPointIntensity, 
			 xsize, ysize, Image)

 int x0,x1,x2;
 int y0,y1,y2;
 int rsq;
 int ArcIntensity;
 int EndPointIntensity;
 int ArcThickness;
 int xsize;
 int ysize;
 int dir;
 char Image[HEIGHT][WIDTH];

/* procedure for drawing arc of a circle 
  x0,y0 : circle centre
  x1,y1 : start point of arc
  x2,y2 : end point of arc
  rsq   : radius squared
 source of algorithm is the optimal integer lattice formulation in 
 McIllroy paper on circle drawing  ACM Trans on Graphics, Vol 2, No 4,
 October 1983. pp 237-263  
*/

{
  int e,ex,ey,exy,dxe,dye,d2e,dx,dy,xpoint,ypoint;
  int dr;
  int done;
  int end_of_arc;
  int k,l;



              for(k =(x1-2); k<=(x1+2); k++){
               for(l =(y1-2); l<=(y1+2); l++){
                if (k >=0 && l >=0 && k <= xsize && l <= ysize)
		      Image[l][k] = (EndPointIntensity & 0377);
               }
             }

              for(k =(x2-2); k<=(x2+2); k++){
               for(l =(y2-2); l<=(y2+2); l++){
                if (k >=0 && l >=0 && k <= xsize && l <= ysize)
		      Image[l][k] = (EndPointIntensity & 0377);
               }
             }

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
          if ( (xpoint>=0) && (xpoint<=xsize) &&
               (ypoint>=0) && (ypoint<=ysize) ) {

		for (k=(xpoint-ArcThickness);k<=(xpoint+ArcThickness);k++) {
		   for (l=(ypoint-ArcThickness);l<=(ypoint+ArcThickness);l++) {
                	if (k >=0 && l >=0 && k <= xsize && l <= ysize)
		   	   Image[l][k] = (ArcIntensity & 0377);
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
}


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
