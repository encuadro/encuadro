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
/* #include <string.h> */
#include <math.h>      /* Standard C mathematics library */
#include "DisplayGrp.h"                 /* Def of functios, types, ... */
#include "Liste.h"                      /* Def of Liste */

#define NXT '#'
#define EOLN '\n'
#define PI   (180.0*64.0/3.141592654)

void ReadORTCircularArcs (des, Table, Lst, mark, Num)

  FILE *des;
  C_CircArc **Table;			/* Table to fill_in */
  Liste *Lst;
  char *mark;
  int *Num;
{

#define MAXLINE 500
#define MAXLISTSIZE 10000

  int flag;
  int jnki;
  int direction;
  double radius;

  char textline[MAXLINE];	/* textline buffer */
  char *ret;

  double junkf;
  double x1,y1,x2,y2,x3,y3,xo,yo;

/*
  Start at the top and, skip text to relevant section of FEX output
*/
     fseek(des,0,0);
     flag = fscanf(des,"%s",textline);
     while  ( strcmp(textline,mark) && flag != 0 && flag != EOF) {
              flag = fscanf(des,"%s",textline);
     }

  cfree (*Table);
  (*Table) = (C_CircArc *) calloc (MAXLISTSIZE, sizeof (C_CircArc));
  *Num = 0;
  *Lst = CreatList ();

  while ((ret = fgets (textline, MAXLINE, des)) && (ret[0] != NXT)) {

	flag = sscanf (ret, "%d %d %d %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf ",
                      &jnki,  &jnki, &direction,
                      &xo,&yo,&x1,&y1,&x2,&y2,&x3,&y3,
			 &junkf,&junkf,&radius);

	if (flag != 0 && flag != EOF)  {
                (*Num)++;
                ((*Table)[*Num]).Direction= (int) direction;
                ((*Table)[*Num]).Origin.x = (int) (xo + 256.0);
                ((*Table)[*Num]).Origin.y = (int) (yo + 256.0);
                ((*Table)[*Num]).Start.x  = (int) (x1 + 256.0);
                ((*Table)[*Num]).Start.y  = (int) (y1 + 256.0);
                ((*Table)[*Num]).Middle.x = (int) (x2 + 256.0);
                ((*Table)[*Num]).Middle.y = (int) (y2 + 256.0);
                ((*Table)[*Num]).End.x    = (int) (x3 + 256.0);
                ((*Table)[*Num]).End.y    = (int) (y3 + 256.0);
                ((*Table)[*Num]).Radius   = (int) (radius);
		  AddElmList (*Lst, (*Num));
	}
 }
  return;

}				/* End of ReadPair */
