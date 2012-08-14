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
#include "DisplayGrp.h"                 /* Def of functios, types, ... */
#include "ListeMacros.h"                /* Def of Liste */
#include "Liste.h" 

#define NXT '#'
#define EOLN '\n'

void ReadPolygons (des, Lst, mark)
  FILE *des;
  Liste *Lst;			/* List to fill_in */
  char *mark;			/* Mark to begin the list */

{
#define MAXLINE 500
  int int_first;		/* Value of first index in a pair */
  int flag;
  int i;

  char first[5];		/* First index */
  char textline[MAXLINE];	/* textline buffer */
  static char whites[] = " \t\n";
  char *ret;
  C_Polygon *new_pair;		/* Created Pair */

  fseek(des,0,0);
/*
  Skip text to relevant section of LPEG output
*/
     flag = fscanf(des,"%s",textline);
     while  ( strcmp(textline,mark) && flag != 0 && flag != EOF) {
              flag = fscanf(des,"%s",textline);
     }
     *Lst = CreatList ();

  /* read 1st index */
  while ((ret = fgets (textline, MAXLINE, des)) && (ret[0] != NXT)) {
    new_pair = (C_Polygon *) malloc (sizeof (C_Polygon));
    fscanf (des, "%d", &(new_pair->number));
	for (i=1;i<=(new_pair->number);i++) {
    		fscanf (des, "%d", &(new_pair->x[i]));
	}
						
    	AddElmList (*Lst, new_pair);
 }

  return;

}				/* End of ReadPair */
