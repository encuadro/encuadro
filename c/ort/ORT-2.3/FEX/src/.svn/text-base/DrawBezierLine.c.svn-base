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
#include <stdio.h>     /* Standard C I/O library */
#include <math.h>      /* Standard C mathematics library */
#include <errno.h>     /* Standard C error handling routines */
#include <ctype.h>     /* Standard C type identification routines */

#define HEIGHT 512
#define WIDTH  512

int DrawBezierLine ( x1, y1, x2, y2, 
			LineIntensity, LineThickness,
			EndPointIntensity,
			xsize, ysize, Image)

	int x1,x2,y1,y2;
	int LineIntensity;
	int LineThickness;
	int EndPointIntensity;
	int xsize;
	int ysize;
	char Image[HEIGHT][WIDTH];
{
	int temp, deltax, deltay, xincrement, yincrement, e, a, b, i;
       int k,l;

              for(k =(x1-1); k<=(x1+1); k++){
               for(l =(y1-1); l<=(y1+1); l++){
		  if (l <= ysize && k <= xsize && l >= 0 && k >= 0) {
	          	Image[l][k] = (EndPointIntensity & 0377);
                }
               }
              }

              for(k =(x2-1); k<=(x2+1); k++){
               for(l =(y2-1); l<=(y2+1); l++){
		  if (l <= ysize && k <= xsize && l >= 0 && k >= 0) {
	          	Image[l][k] = (EndPointIntensity & 0377);
                }
               }
              }

if (abs(x2-x1) > abs(y2-y1)) {
   if (x1 > x2) {
      temp = x1; x1 = x2; x2 = temp;
      temp = y1; y1 = y2; y2 = temp;
   }
   deltax = x2 - x1;
   deltay = abs (y2 - y1);
   e = (2 * deltay) - deltax;
   a = (2 * deltay) - (2 * deltax);
   b = (2 * deltay);
   if (y2 > y1) { 
	yincrement = 1;
   } else {
	yincrement = -1;
   }
   for (i= 0;i<=deltax;i++) {

      if ((x1>0) && (x1<=xsize) && (y1>0) && (y1<=ysize)) {
             for(k =(x1-LineThickness); k<=(x1+LineThickness); k++){
               for(l =(y1-LineThickness); l<=(y1+LineThickness); l++){
	          	Image[l][k] = (LineIntensity & 0377);
               }
             }
      }
      if (e > 0) {
         y1 = y1 + yincrement;
         e = e + a;
      } else {
         e = e + b;
      }
         x1 = x1 + 1;
   }
} else {
   if (y1 > y2) {
      temp = x1; x1 = x2; x2 = temp;
      temp = y1; y1 = y2; y2 = temp;
   }
   deltay = y2 - y1;
   deltax = abs(x2 - x1);
   e = (2 * deltax) - deltay;
   a = (2 * deltax) - (2 * deltay);
   b = (2 * deltax);
   if (x2 > x1) {
	xincrement = 1; 
   } else {
	xincrement = -1;
   }
   for (i= 0;i<=deltay;i++) {

      if ((x1>0) && (x1<=xsize) && (y1>0) && (y1<=ysize)) {
              for(k =(x1-LineThickness); k<=(x1+LineThickness); k++){
               for(l =(y1-LineThickness); l<=(y1+LineThickness); l++){
	          	Image[l][k] = (LineIntensity & 0377);
               }
             }
      }
      if (e > 0) {
         x1 = x1 + xincrement;
         e = e + a;
      } else {
         e = e + b;
      }
      	  y1 = y1 + 1;
   }
 }
	return(0);
}
