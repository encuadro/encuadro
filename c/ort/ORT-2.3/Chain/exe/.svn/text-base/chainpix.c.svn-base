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
   Original name = link.c
   Previous name = RW_ChainPixels
   Current  name = chainpix 
   Version 1.3

   A G.A.W.West/P.L.Rosin production. Copyright 1990

   Reads in an image and then links adjacent pixels to forms lists which it
   then stores in a file. An improved version of link.c adaptef from link.pas 
   as run on the Viglen PC/ To save memory, writes to a file each pixel as it 
   is found, then erases pixel from screen so it cannot be used again.

Modified By A.Etemadi '92, added PGM support, and converted it to a filter.
Modified By A.Etemadi '93, to support rectangular images.
Modified By A.Etemadi '93, to skip any comment lines added by xv

*/

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#define MAX_PIX 10000
#define BLACK 0           /* Canny output edge pixel 1   RC91 */
#define WHITE 255         /* WHITE left as orig - never used RC91 */
#define TRUE 1
#define FALSE !TRUE
#define MAXBUFF 100       /* Buffer to store characters when reading file */

/*
 * Change these to replace maximum image size (AE '93)
 */
#define WIDTH  512        /* Orig. was 256   RC91   */
#define HEIGHT 512        /* Orig. was 256   RC91   */

int loop1,loop2;
int list_no;
int xpix[MAX_PIX],ypix[MAX_PIX];
int loopindex;
int thresh_sig;
int weight;
int flag;
int no_lists_written;
int set_aspect,set_threshold,set_file_out,set_file_in;
int closed_only;
int height,width;

//#ifndef HPUX11
//int round();
//#endif

int ImageType;
int Next;

FILE *fp_out,*fp_in;;

unsigned char image[HEIGHT][WIDTH];

float aspect_ratio;   /* defined as y/x and divide y value by this */

main(argc,argv)
int argc;
char *argv[];
{

    int i,count;
    char *temp;
    char ch;
    int  intbuf;
    char stringbuf[MAXBUFF];

    set_aspect    = FALSE;
    set_file_out  = TRUE;
    set_file_in   = TRUE;
    set_threshold = FALSE;
    closed_only   = FALSE;
    aspect_ratio  = 1.0;
    thresh_sig    = 1000;

  Next      = 0;
  ImageType = 1;  /* 0 for Raw image, 1 for PGM image */
  height    = width = 256;

  for (i=1;i<argc;i++) {
       if (argv[i][0] == '-') {
           switch (argv[i][1]) {
	    case 'r': Next+=2; ImageType = 0; height = (atoi(argv[++i])); continue;
	    case 'c': Next+=2; ImageType = 0; width  = (atoi(argv[++i])); continue;
	    case 'v': Next++; fprintf(stderr,"%s: Version 1.3\n",argv[0]); return(-1);
	    default : fprintf(stderr,"Error: unrecognized option: %s \n",argv[i]); return(-1);
	    case 'h': 
        	fprintf(stderr,"USAGE : \n");
        	fprintf(stderr," %s [-hv] [-r NoOfRows -c NoOfCols] < EdgeImage > ChainList\n",argv[0]);
        	fprintf(stderr,"WHERE: \n");
        	fprintf(stderr," -h Gives usage information \n");
        	fprintf(stderr," -v Gives version number \n");
              fprintf(stderr," -r NoOfRows for Raw (ie byte array) Edge Image \n");
        	fprintf(stderr," -c NoOfCols for Raw (ie byte array) Edge Image \n");
        	fprintf(stderr,"DEFAULTS : \n");
        	fprintf(stderr," PGM format Edge Image Max 512x512\n");
        	fprintf(stderr," Edge pixels set to non-zero values and background set to 0.\n");
        	return(-1);
	    }
	}
  }

   if (ImageType == 1) {
    fscanf(stdin,"%s\n",stringbuf);

/* 
 * All this is to avoid problems with xv adding 
 * a comment line aaaaaaaaaaaaaaaaaaaaaaaargh!!!!!!
 */ 

    i = fscanf(stdin,"%d %d\n",&width,&height);
    if (i != 2) {   
        fgets(stringbuf,MAXBUFF,stdin);
        if (fscanf(stdin,"%d %d\n",&width,&height) != 2) {
           fprintf(stderr,"This is not a PGM image %d %d\n",width,height);
           exit(-1);
        }
     }

    fscanf(stdin,"%d\n",&intbuf);

   }

	link_and_save(0,ImageType);

}

link_and_save(option,ImageType)
int option;
/*
   option used to determine if all lists (0) or only the strongest (1)
   are saved to disk

*/
{
    int i,j;
    char cbuffer;

    flag = FALSE;  /* at start only - no lists */
    no_lists_written = 0;
    fp_in = stdin;


    for (i=0;i<height;i++) {
       for (j=0;j<width;j++) {
	  cbuffer = getc(fp_in);
         if ( (cbuffer & 0377) != 0) { 
		image[i][j] = (char) WHITE;
	  } else {
		image[i][j] = (char) 0;
	  }
       }
    }
    fclose(fp_in);

    /* clean up image, make all object 8 connected */
    clean();
    
    /* remove isolated points - of no interest to us here */
    remove_isolated();
    fp_out = stdout;
    fprintf(fp_out,"%d %d\n",width, height);
    
    /* link open edges */
    list_no = 0;
    link_open(option);
    
    /* remove isolated points - of no interest to us here */
    remove_isolated();
    
    /* link closed edges */
    link_closed(option);
    
    /* remove isolated points - of no interest to us here */
    remove_isolated();
    
    fprintf(fp_out,"  -1   -1\n");
    close(fp_out);
    printf("total number of lists: %d\n",list_no);
}

clean()
{
   int loop1,loop2;
   unsigned char i1,i2,i3,i4;
   int number;

    /* clear border */
    for(loop1=0;loop1<height;loop1++){
        image[loop1][0] = BLACK;
        image[loop1][width-1] = BLACK;
    }
    for(loop1=0;loop1<width;loop1++){
        image[0][loop1] = BLACK;
        image[height-1][loop1] = BLACK;
    }
    counting_pixels();
    for(loop1=1;loop1<height-1;loop1++)
        for(loop2=1;loop2<width-1;loop2++)
            if(image[loop1][loop2] != BLACK){
          	i1 = image[loop1-1][loop2];
          	i2 = image[loop1][loop2-1];
          	i3 = image[loop1+1][loop2];
          	i4 = image[loop1][loop2+1];
          	if((i1 != BLACK) && (i2 != BLACK)){
             	    image[loop1][loop2] = BLACK;
          	}
		else if((i2 != BLACK) && (i3 != BLACK)){
		    image[loop1][loop2] = BLACK;
          	}
		else if((i3 != BLACK) && (i4 != BLACK)){
             	    image[loop1][loop2] = BLACK;
          	}
		else if((i4 != BLACK) && (i1 != BLACK)){
             	    image[loop1][loop2] = BLACK;
		}
	    }
    counting_pixels();
}


counting_pixels()
{
    int loop1,loop2;
    long number;

    number = 0;
    for(loop1=0;loop1<height;loop1++)
	for(loop2=0;loop2<width;loop2++)
	    if(image[loop1][loop2] != BLACK)
		number++;
}


remove_isolated()
{
   int loop1,loop2;
   unsigned char i1,i2,i3,i4,i6,i7,i8,i9;
   long number;

    number = 0;
    for(loop1=1;loop1<height-1;loop1++)
   	for(loop2=1;loop2<width-1;loop2++)
      	    if(image[loop1][loop2] != BLACK){
          	i1 = image[loop1-1][loop2-1];
          	i2 = image[loop1][loop2-1];
          	i3 = image[loop1+1][loop2-1];
          	i4 = image[loop1-1][loop2];
          	i6 = image[loop1+1][loop2];
          	i7 = image[loop1-1][loop2+1];
          	i8 = image[loop1][loop2+1];
          	i9 = image[loop1+1][loop2+1];
          	if((i1+i2+i3+i4+i6+i7+i8+i9) == (8*BLACK)){
             	    image[loop1][loop2] = BLACK;
             	    number++;
             	}
            } 
}


link_open(option)
int option;
/*
   option = 0  write list to disk
   option = 1  write significant lines to disk
*/

{
    int loop1,loop2,loop3;
    unsigned char i1,i2,i3,i4,i6,i7,i8,i9;
    int xp,yp;
    int end_of_line;

    for(loop1=0;loop1<height;loop1++)         /* for each row y */
   	for(loop2=0;loop2<width;loop2++){     /* for each column x */
      	    /* find pixel at end of line */
      	    if(image[loop1][loop2] != BLACK){
         	i1 = 0;
         	i2 = 0;
         	i3 = 0;
         	i4 = 0;
         	i6 = 0;
         	i7 = 0;
         	i8 = 0;
         	i9 = 0;
         	if(image[loop1-1][loop2-1] != BLACK)
            	    i1 = 1;
                if(image[loop1][loop2-1] != BLACK)
            	    i2 = 1;
         	if(image[loop1+1][loop2-1] != BLACK)
            	    i3 = 1;
         	if(image[loop1-1][loop2] != BLACK)
            	    i4 = 1;
         	if(image[loop1+1][loop2] != BLACK)
            	    i6 = 1;
         	if(image[loop1-1][loop2+1] != BLACK)
            	    i7 = 1;
         	if(image[loop1][loop2+1] != BLACK)
            	    i8 = 1;
         	if(image[loop1+1][loop2+1] != BLACK)
            	    i9 = 1;
         	if((i1+i2+i3+i4+i6+i7+i8+i9) == 1){
            	    weight = 0;
            	    loopindex  = 0;
            	    list_no++;
            	    end_of_line = FALSE;
            	    /* track to end of line */
            	    xp = loop2;
            	    yp = loop1;
            	    do{
               		weight = weight + image[yp][xp];
               		loopindex++;
               		xpix[loopindex] = xp;
               		ypix[loopindex] = round(yp/aspect_ratio);
               		image[yp][xp] = BLACK;
               		/* goto next pixel if an edge pixel */
               		i1 = image[yp-1][xp-1];
               		i2 = image[yp][xp-1];
               		i3 = image[yp+1][xp-1];
               		i4 = image[yp-1][xp];
               		i6 = image[yp+1][xp];
               		i7 = image[yp-1][xp+1];
               		i8 = image[yp][xp+1];
               		i9 = image[yp+1][xp+1];
               		if(i1 != BLACK){
                  	    xp--;
                  	    yp--;
                  	}
               		else if(i2 != BLACK){
                  	    xp--;
			}
               		else if(i3 != BLACK){
                  	    yp++;
                  	    xp--;
                  	}
               		else if(i4 != BLACK){
                  	    yp--;
               		}
			else if(i6 != BLACK){
                  	    yp++;
			}
               		else if(i7 != BLACK){
                  	    yp--;
                  	    xp++;
                  	}
               		else if(i8 != BLACK){
                  	    xp++;
			}
               		else if(i9 != BLACK){
                  	    xp++;
                  	    yp++;
                  	}
               		else
                  	    end_of_line = TRUE;
               	    }while(end_of_line == FALSE);
            	    if(option == 1){
               	        /* only write if significant */
               	        if(weight > thresh_sig){
                  	    if(closed_only == FALSE){
                  	        no_lists_written++;
                     	        if(flag == TRUE)
                        	    fprintf(fp_out,"  -1    0\n");
                     	        flag = TRUE;
                        	fprintf(fp_out,"list:  %d\n ",list_no);
                                for(loop3=1;loop3<=loopindex;loop3++)
                           	    fprintf(fp_out,"%4d %4d\n",
					    xpix[loop3],ypix[loop3]);
                            }
		        }
		    }
                    else{ /* option = 0 */
               	        /* write all lines */
               	        if(closed_only == FALSE){
               	            no_lists_written++;
                  	    if(flag == TRUE)
                     	        fprintf(fp_out,"  -1    0\n");
                  	    flag = TRUE;
                     	    fprintf(fp_out,"list:   %d\n",list_no);
                     	    for(loop3=1;loop3<=loopindex;loop3++)
                                fprintf(fp_out,"%4d %4d\n",xpix[loop3],ypix[loop3]);
               		}
	    	    }
		}
    	    }
	}
    }


link_closed(option)
int option;
/*
   option = 0  write list to disk
   option = 1  write significant lines to disk
*/
{
   int loop1,loop2,loop3;
   unsigned char i1,i2,i3,i4,i6,i7,i8,i9;
   int xp,yp;
   int end_of_line;

    for(loop1=0;loop1<height;loop1++)       /* for each row */
	for(loop2=0;loop2<width;loop2++){   /* for each column */
      	    /* find any remaining pixel */
      	    if(image[loop1][loop2] != BLACK){
         	/* at beginning of a line */
         	weight = 0;
         	loopindex = 0;
         	list_no++;
         	end_of_line = FALSE;
         	/* track to end of line */
         	xp = loop2;
         	yp = loop1;
         	do{
            	    loopindex++;
            	    xpix[loopindex] = xp;
            	    ypix[loopindex] = round(yp / aspect_ratio);
            	    weight = weight + image[yp][xp];
            	    image[yp][xp] = BLACK;
            	    /* goto next edge pixel */
            	    i1 = image[yp-1][xp-1];
            	    i2 = image[yp][xp-1];
            	    i3 = image[yp+1][xp-1];
            	    i4 = image[yp-1][xp];
            	    i6 = image[yp+1][xp];
            	    i7 = image[yp-1][xp+1];
            	    i8 = image[yp][xp+1];
            	    i9 = image[yp+1][xp+1];
            	    if(i1 != BLACK){
               		xp--;
               		yp--;
                    }
            	    else if(i2 != BLACK){
               		xp--;
		    }
            	    else if(i3 != BLACK){
               		yp++;
               		xp--;
               	    }
            	    else if(i4 != BLACK){
               		yp--;
		    }
            	    else if(i6 != BLACK){
               		yp++;
		    }
            	    else if(i7 != BLACK){
               		yp--;
               		xp++;
		    }
            	    else if(i8 != BLACK){
               		xp++;
		    }
            	    else if(i9 != BLACK){
               		xp++;
               		yp++;
		    }
                    else
               	        end_of_line = TRUE;
                }while(end_of_line != TRUE);
         if(option == 1){
            /* only write if signoficant */
            if(weight > thresh_sig){
               no_lists_written++;
               if(flag == TRUE)
                  fprintf(fp_out,"  -1    0\n");
               flag = TRUE;
               fprintf(fp_out,"list:   %d\n",list_no);
               for(loop3=1;loop3<=loopindex;loop3++)
                  fprintf(fp_out,"%4d %4d\n",xpix[loop3],ypix[loop3]);
            }
         }
         else{ /* option = 0 */
            /* write all lines */
            no_lists_written++;
            if(flag == TRUE)
               fprintf(fp_out,"  -1    0\n");
            flag = TRUE;
            fprintf(fp_out,"list:   %d\n",list_no);
            for(loop3=1;loop3<=loopindex;loop3++)
               fprintf(fp_out,"%4d %4d\n",xpix[loop3],ypix[loop3]);
         }
     }
    }
}
/*#ifndef HPUX11
int round(x)
float x;
{
   return floor(x + 0.5);
}
#endif*/
