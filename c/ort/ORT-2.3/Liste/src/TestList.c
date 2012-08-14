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
#include "ListeMacros.h"
#include "Liste.h"

int greater (a, b)
  int *a, *b;
{
  return (*a - *b);
}

main ()
{
  Liste l1, l2, l3;
  int el;

  l1 = CreatList ();
  printf (" Empty List : \n");
  PrintList (l1, stdout);
  AddElmList (l1, 1);
  AddElmList (l1, 2);
  AddElmList (l1, 3);
  AddElmList (l1, 4);
  PrintList (l1, stdout);
  printf (" ---------------------------------------------- \n");

  l2 = CreatList ();
  AddElmList (l2, 40);
  AddElmList (l2, 30);
  AddElmList (l2, 20);
  AddElmList (l2, 10);
  printf (" l2 : \n");
  PrintList (l2, stdout);
  printf (" ---------------------------------------------- \n");

  l3 = AppendList (l1, l2);
  printf (" l3 After first appending l1 and l2\n");
  PrintList (l3, stdout);
  printf (" ---------------------------------------------- \n");

  printf (" l2 before attempting to destroy an element: \n");
  PrintList (l2, stdout);
  printf (" Destroy a non-existant elm of l2: %d \n", DestElmList (l2, 124345));
  printf (" l2 after attempting to destroy an element: \n");
  PrintList (l2, stdout);

  printf (" ---------------------------------------------- \n");
  DestList (&l2);
  printf (" l2 After Desroying  it\n");
  PrintList (l2, stdout);
  printf (" ---------------------------------------------- \n");

  l2 = CopyList (l3);
  printf (" l2 After first copy l3\n");
  PrintList (l2, stdout);
  printf (" ---------------------------------------------- \n");

  SortList (l2, greater);
  printf (" l2 After sorting \n");
  PrintList (l2, stdout);
  printf (" ---------------------------------------------- \n");

  printf (" l2 before destroying an element: \n");
  PrintList (l2, stdout);
  printf (" Destroy an existing elm of l2: %d \n", DestElmList (l2, 4));
  printf (" l2 after destroying an element: \n");
  PrintList (l2, stdout);
  printf (" ---------------------------------------------- \n");

  printf ("List l2 :\n");
  el = FirstElmList (l2);
  while (el != ERRVI) {
    printf ("%d, ", el);
    el = NextElmList (l2);
  }
  printf (" ---------------------------------------------- \n");

  DestList (&l3);
  l3 = CreatList ();
  printf ("List l3 :\n");
  el = FirstElmList (l3);
  while (el != ERRVI) {
    printf ("%d, ", el);
    el = NextElmList (l3);
  }
  printf (" ---------------------------------------------- \n\n");

  printf ("List l3 : 0th elm : %d\n", ElmNumList (l3, 0));
  printf ("List l3 : 10th elm : %d\n", ElmNumList (l3, 10));
  printf ("List l2 : 2nd elm : %d\n", ElmNumList (l2, 2));


}
