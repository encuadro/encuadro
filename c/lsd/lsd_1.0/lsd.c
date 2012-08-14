/*----------------------------------------------------------------------------

  LSD - Line Segment Detector on digital images

  Copyright 2007,2008,2009 rafael grompone von gioi (grompone@gmail.com)

  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either version 2
  of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
  MA 02110-1301, USA.

  ----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------

   This code can be compiled as a pure C language program
   or as a module for the MegaWave2 framework
   (http://megawave.cmla.ens-cachan.fr).

   To compile as a pure ANSI C language program use the following
   command:
     cc -DNO_MEGAWAVE -O3 -lm -o lsd lsd.c

   To compile with the MegaWave2 framework, use the following
   command:
     cmw2 -O3 lsd.c

   When executed as an independent program the input is given
   in a PGM gray-scale image format file. The name of the file
   must be given as the first parameter to the command. An
   optional second parameter can specify the output file
   (otherwise the output will be printed to standard output).
   The output of the program will be a list of line segments,
   one per line in the following format:
     x1 y1 x2 y2 width
   for a line segment from point (x1,y1) to point (x2,y2) and
   a width of 'width'. An optional third parameter can specify
   the file for a SVG output. Run LSD without arguments for help.

   The coordinates origin is at the center of pixel 0,0.

   LSD usually gives good results without the need of parameters
   tuning, the default values usually work well.

   Example of use:
     ./lsd myimage.pgm
     ./lsd myimage.pgm output.txt

   Example of output:
     28.0347 38.244 22.5263 32.4425 3
     3.74755 22.3012 6.92328 12.8189 1
     43.2815 26.4786 34.6753 23.8453 2

  ----------------------------------------------------------------------------*/

/*---------------------------- Commande MegaWave -----------------------------*/
/* mwcommand
  name = {lsd};
  function = {"Line Segment Detector"};
  author = {"rafael grompone von gioi"};
  version = {"1.0"};
  usage = {
    's':[s=1.0]->scale
        "Scale image by Gaussian filter before processing, only if s!=1.0",
    'c':[c=0.6]->sigma_scale
        "When using -s option, sigma = c/scale (default 0.6).",
    'q':[q=2.0]->q
        "Bound to quantization error on the gradient norm (default 2.0).",
    'd':[d=8.0]->d
        "Gradient angle tolerance, tau = 180 degree / d (default 8.0).",
    'e':[eps=0.]->eps "Detection threshold, -log10(max. NFA) (default 0.0).",
    'b':[num_bins=16256]->n_bins
        "# bins in 'ordering' of gradient modulus (default 16256)",
    'm':[max_grad=260100]->max_grad
        "Gradient modulus in the highest bin (default 260100).",
    'v'->verb "Verbose mode: print information while processing.",
    'x':x->x "Grow one region starting from point x,y (to be used with -y).",
    'y':y->y "Grow one region starting from point x,y (to be used with -x).",
    'r':reg<-regout "Show on Cimage 'reg' the pixels used by each detection.",
    'T'->ascii_reg
        "Print to standard output the list of points for each region.",
    'n':n->n "When using -r option, show just region number n.",
    'i':iout<-iout "Draw in Cimage 'iout' the line segments.",
    'F':fout<-fout "Line segment output for 'fkview' visualization (Flists).",
    'R':rout<-rout "Rectangles output for 'fkview' visualization (Flists).",
    'a'->arrow "Draw 'arrow heads' to rectangles when using -R option.",
    'A'->ascii "ASCII output to standard output as 'x1 y1 x2 y2 width'.",
    'S'->svg "Output a SVG file to standard output. May conflicts with -A.",
    in->image "Input image (Fimage).",
    out<-out "Line Segment output (5-Flist: x1,y1,x2,y2,width)."
  };
*/
/*
  When NO_MEGAWAVE is defined, this is a pure ANSI C language program,
  otherwise it's a Megawave2 module.
*/
#ifndef NO_MEGAWAVE
#include "mw.h"
#endif /* !NO_MEGAWAVE */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <float.h>

#ifndef M_LN10
#define M_LN10 2.30258509299404568402
#endif /* !M_LN10 */

#ifndef M_PI
#define M_PI   3.14159265358979323846
#endif /* !M_PI */

#ifndef FALSE
#define FALSE 0
#endif /* !FALSE */

#ifndef TRUE
#define TRUE 1
#endif /* !TRUE */

#define NOTDEF   -1000.0
#define BIG_NUMBER 1.0e+300
#define M_3_2_PI 4.71238898038
#define M_2__PI  6.28318530718
#define NOTUSED 0
#define USED    1
#define NOTINI  2

#define MY_ROUND(f) ( (float) floor( (double) (f) + 0.5 ) )

/* some global variables */
static int verbose = FALSE;

/*----------------------------------------------------------------------------*/
struct coorlist
{
  int x,y;
  struct coorlist * next;
};

/*----------------------------------------------------------------------------*/
struct point {int x,y;};

/*----------------------------------------------------------------------------*/
/* Global variables
 */
static float * sum_l;            /* weight sum on longitudinal direction */
static float * sum_w;            /* weight sum on lateral direction */
static int sum_res = 1;          /* resolution factor on weight sum */
static int sum_offset;           /* offset to center of weight sum */

/*----------------------------------------------------------------------------*/
static void error(char * msg)
{
  fprintf(stderr,"%s\n",msg);
  exit(EXIT_FAILURE);
}

/*----------------------------------------------------------------------------*/
static float dist(float x1, float y1, float x2, float y2)
{
  return (float) sqrt( (double) ((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1)) );
  /* return hypotf( x2-x1, y2-y1 ); */
}

/*----------------------------------------------------------------------------*/
/* Compare floats.
   Usually, == and != do not have the desired behavior for floats, see
   http://www.cygnus-software.com/papers/comparingfloats/comparingfloats.htm

   EPS_MAXULPS is the maximum allowed differences between floats in
   terms of "units in the last place".

   A gcc #pragma is required to enable a strict compilation,
   ie with -Werr -Wfloat-equal or -O2.
 */
#define NV_EPS_MAXULPS 10
#pragma GCC diagnostic ignored "-Wfloat-equal"
#pragma GCC diagnostic ignored "-Wstrict-aliasing"
static int float_equal(float a, float b)
{
  return (  (a == b)
         || (abs( (*(int *)&a) - (*(int *)&b) ) <= NV_EPS_MAXULPS) );
}
#pragma GCC diagnostic error "-Wfloat-equal"
#pragma GCC diagnostic error "-Wstrict-aliasing"


/*----------------------------------------------------------------------------*/
/*---------------------------- n-tuple DATA TYPES ----------------------------*/
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
typedef struct ntuple_float_s
{
  int size;
  int max_size;
  int dim;
  float * values;
} * ntuple_float;

/*----------------------------------------------------------------------------*/
static void free_ntuple_float(ntuple_float in)
{
  if( in == NULL ) error("free_ntuple_float: NULL input.");
  if( in->values == NULL ) error("free_ntuple_float: NULL values in input.");
  free((void *)in->values);
  free((void *)in);
}

/*----------------------------------------------------------------------------*/
static ntuple_float new_ntuple_float(int dim)
{
  ntuple_float n_tuple;

  n_tuple = (ntuple_float) malloc(sizeof(struct ntuple_float_s));
  if( n_tuple == NULL ) error("Not enough memory.");
  n_tuple->size = 0;
  n_tuple->max_size = 1;
  n_tuple->dim = dim;
  n_tuple->values = (float *) malloc( dim*n_tuple->max_size * sizeof(float) );
  if( n_tuple->values == NULL ) error("Not enough memory.");
  return n_tuple;
}

/*----------------------------------------------------------------------------*/
static void enlarge_ntuple_float(ntuple_float n_tuple)
{
  if( n_tuple->max_size <= 0 ) error("enlarge_ntuple_float: invalid n-tuple.");
  n_tuple->max_size *= 2;
  n_tuple->values =
    (float *) realloc( (void *) n_tuple->values,
                      n_tuple->dim * n_tuple->max_size * sizeof(float) );
  if( n_tuple->values == NULL ) error("Not enough memory.");
}

/*----------------------------------------------------------------------------*/
static void add_5tuple(ntuple_float out, float v1, float v2,
                       float v3, float v4, float v5)
{
  if( out == NULL ) error("add_5tuple: invalid n-tuple input.");
  if( out->size == out->max_size ) enlarge_ntuple_float(out);
  if( out->values == NULL ) error("add_5tuple: invalid n-tuple input.");
  out->values[ out->size * out->dim + 0 ] = v1;
  out->values[ out->size * out->dim + 1 ] = v2;
  out->values[ out->size * out->dim + 2 ] = v3;
  out->values[ out->size * out->dim + 3 ] = v4;
  out->values[ out->size * out->dim + 4 ] = v5;
  out->size++;
}


/*----------------------------------------------------------------------------*/
/*----------------------------- IMAGE DATA TYPES -----------------------------*/
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
typedef struct image_char_s
{
  unsigned char * data;
  int xsize,ysize;
} * image_char;

/*----------------------------------------------------------------------------*/
static void free_image_char(image_char i)
{
  if( i == NULL ) error("free_image_char: NULL input.");
  if( i->data == NULL ) error("free_image_char: input image have no data.");
  free((void *)i->data);
  free((void *)i);
}

/*----------------------------------------------------------------------------*/
static image_char new_image_char(int xsize,int ysize)
{
  image_char image;

  image = (image_char) malloc(sizeof(struct image_char_s));
  if( image == NULL ) error("Not enough memory.");
  image->data = (unsigned char *) calloc(xsize*ysize, sizeof(unsigned char));
  if( image->data == NULL ) error("Not enough memory.");

  image->xsize = xsize;
  image->ysize = ysize;

  return image;
}

/*----------------------------------------------------------------------------*/
static image_char new_image_char_ini(int xsize,int ysize,int ini)
{
  image_char image = new_image_char(xsize,ysize);
  int N = xsize*ysize;
  int i;

  for(i=0; i<N; i++) image->data[i] = ini;

  return image;
}

/*----------------------------------------------------------------------------*/
typedef struct image_float_s
{
  float * data;
  int xsize,ysize;
} * image_float;

/*----------------------------------------------------------------------------*/
static void free_image_float(image_float i)
{
  if( i == NULL ) error("free_image_float: NULL input.");
  if( i->data == NULL ) error("free_image_float: input image have no data.");
  free( (void *) i->data );
  free( (void *) i );
}

/*----------------------------------------------------------------------------*/
static image_float new_image_float(int xsize,int ysize)
{
  image_float image;

  image = (image_float) malloc(sizeof(struct image_float_s));
  if( image == NULL ) error("Not enough memory.");
  image->data = (float *) calloc(xsize*ysize, sizeof(float));
  if( image->data == NULL ) error("Not enough memory.");

  image->xsize = xsize;
  image->ysize = ysize;

  return image;
}

/*----------------------------------------------------------------------------*/
#ifdef CODE_NOT_USED
static image_float new_image_float_ini(int xsize,int ysize,float ini)
{
  image_float image = new_image_float(xsize,ysize);
  int N = xsize*ysize;
  int i;

  for(i=0; i<N; i++) image->data[i] = ini;

  return image;
}
#endif /* CODE_NOT_USED */


/*----------------------------------------------------------------------------*/
/*-------------------------------- IMAGE I/O ---------------------------------*/
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
#ifdef NO_MEGAWAVE
static int is_space(int c)
{
  return c==' ' || c=='\n' || c=='\t';
}
#endif /* NO_MEGAWAVE */

/*----------------------------------------------------------------------------*/
#ifdef NO_MEGAWAVE
static int is_digit(int c)
{
  return c>='0' && c<='9';
}
#endif /* NO_MEGAWAVE */

/*----------------------------------------------------------------------------*/
#ifdef NO_MEGAWAVE
static void skip_what_should_be_skipped(FILE * f)
{
  int c;
  do
    {
      while(is_space(c=getc(f))); /* skip spaces */
      if(c=='#') while((c=getc(f))!='\n'); /* skip comments */
    }
  while(c == '#');
  ungetc(c,f);
}
#endif /* NO_MEGAWAVE */

/*----------------------------------------------------------------------------*/
#ifdef NO_MEGAWAVE
static int get_num(FILE * f)
{
  int num, c;

  while(is_space(c=getc(f)));
  if(!is_digit(c)) error("Corrupted PGM file.");
  num = c - '0';
  while( is_digit(c=getc(f)) ) num = 10 * num + c - '0';

  return num;
}
#endif /* NO_MEGAWAVE */

/*----------------------------------------------------------------------------*/
#ifdef CODE_NOT_USED
static image_char read_pgm_image_char(char * name)
{
  FILE * f;
  int c,bin,x,y;
  int xsize,ysize,depth;
  image_char image;

  /* open file */
  f = fopen(name,"r");
  if( f == NULL ) error("Can't open input file.");

  /* read header */
  if( getc(f) != 'P' ) error("Not a PGM file!");
  if( (c=getc(f)) == '2' ) bin = FALSE;
  else if( c == '5' ) bin = TRUE;
  else error("Not a PGM file!");
  skip_what_should_be_skipped(f);
  c = fscanf(f,"%d",&xsize);      /* c is just to avoid unused result warning */
  skip_what_should_be_skipped(f);
  c = fscanf(f,"%d",&ysize);      /* c is just to avoid unused result warning */
  skip_what_should_be_skipped(f);
  c = fscanf(f,"%d",&depth);      /* c is just to avoid unused result warning */

  /* get memory */
  image = new_image_char(xsize,ysize);
  image->xsize = xsize;
  image->ysize = ysize;

  /* read data */
  skip_what_should_be_skipped(f);
  for(y=0;y<ysize;y++)
    for(x=0;x<xsize;x++)
      image->data[ x + y * xsize ] = bin ? getc(f) : get_num(f);

  if(verbose) fprintf(stderr,"input image: xsize %d ysize %d depth %d\n",
                      image->xsize,image->ysize,depth);

  /* close file */
  fclose(f);

  return image;
}
#endif /* CODE_NOT_USED */

/*----------------------------------------------------------------------------*/
#ifdef NO_MEGAWAVE
static image_float read_pgm_image_float(char * name)
{
  FILE * f;
  int c,bin,x,y;
  int xsize,ysize,depth;
  image_float image;

  /* open file */
  f = fopen(name,"r");
  if( f == NULL ) error("Can't open input file.");

  /* read header */
  if( getc(f) != 'P' ) error("Not a PGM file!");
  if( (c=getc(f)) == '2' ) bin = FALSE;
  else if( c == '5' ) bin = TRUE;
  else error("Not a PGM file!");
  skip_what_should_be_skipped(f);
  c = fscanf(f,"%d",&xsize);      /* c is just to avoid unused result warning */
  skip_what_should_be_skipped(f);
  c = fscanf(f,"%d",&ysize);      /* c is just to avoid unused result warning */
  skip_what_should_be_skipped(f);
  c = fscanf(f,"%d",&depth);      /* c is just to avoid unused result warning */

  /* get memory */
  image = new_image_float(xsize,ysize);
  image->xsize = xsize;
  image->ysize = ysize;

  /* read data */
  skip_what_should_be_skipped(f);
  for(y=0;y<ysize;y++)
    for(x=0;x<xsize;x++)
      image->data[ x + y * xsize ] = (float) (bin ? getc(f) : get_num(f));

  if(verbose) fprintf(stderr,"input image: xsize %d ysize %d depth %d\n",
                      image->xsize,image->ysize,depth);

  /* close file */
  fclose(f);

  return image;
}
#endif /* NO_MEGAWAVE */

/*----------------------------------------------------------------------------*/
#ifdef CODE_NOT_USED
static void write_pgm_image_char(image_char image, char * name)
{
  FILE * f;
  int x,y,n;

  /* open file */
  f = fopen(name,"w");
  if( f == NULL ) error("Can't open output file.");

  /* write header */
  fprintf(f,"P2\n");
  fprintf(f,"%d %d\n",image->xsize,image->ysize);
  fprintf(f,"255\n");

  /* write data */
  for(n=1,y=0; y<image->ysize; y++)
    for(x=0; x<image->xsize; x++,n++)
      {
        fprintf(f,"%d ",image->data[ x + y * image->xsize ]);
        if(n==16)
          {
            fprintf(f,"\n");
            n = 0;
          }
      }

  /* close file */
  fclose(f);
}
#endif /* CODE_NOT_USED */

/*----------------------------------------------------------------------------*/
#ifdef CODE_NOT_USED
static void write_pgm_image_float(image_float image, char * name)
{
  FILE * f;
  int x,y,n;

  /* open file */
  f = fopen(name,"w");
  if( f == NULL ) error("Can't open output file.");

  /* write header */
  fprintf(f,"P2\n");
  fprintf(f,"%d %d\n",image->xsize,image->ysize);
  fprintf(f,"255\n");

  /* write data */
  for(n=1,y=0; y<image->ysize; y++)
    for(x=0; x<image->xsize; x++,n++)
      {
        fprintf(f,"%d ",(int) image->data[ x + y * image->xsize ]);
        if(n==16)
          {
            fprintf(f,"\n");
            n = 0;
          }
      }

  /* close file */
  fclose(f);
}
#endif /* CODE_NOT_USED */


/*----------------------------------------------------------------------------*/
/*----------------------------- Image Operations -----------------------------*/
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
static void gaussian_kernel( ntuple_float kernel, float sigma, float offset )
{
  int i;
  float val;
  float sum = 0.0;

  /* compute gaussian kernel */
  kernel->size = 1;
  for(i=0;i<kernel->dim;i++)
    {
      val = ( (float) i - offset ) / sigma;
      kernel->values[i] = (float) exp( (double) -0.5 * val * val );
      sum += kernel->values[i];
    }

  /* normalization */
  for(i=0;i<kernel->dim;i++) kernel->values[i] /= sum;
}

/*----------------------------------------------------------------------------*/
static image_float gaussian_sampler( image_float in, float scale,
                                     float sigma_scale )
{
  int N = floor( (double) (in->xsize) * scale ); /* final x-size */
  int M = floor( (double) (in->ysize) * scale ); /* final y-size */
  image_float aux = new_image_float(N,in->ysize);
  image_float out = new_image_float(N,M);
  float sigma = scale < 1.0 ? sigma_scale / scale : sigma_scale;
  int h = ceil( (double) sigma * sqrt( log(10.0) * 6.0 ) );
  int n = 1+2*h;
  ntuple_float kernel = new_ntuple_float(n);
  int x,y,xc,yc,i,j;
  float xx,yy,sum;
  int nx2 = 2 * in->xsize;
  int ny2 = 2 * in->ysize;

  /* x axis convolution */
  for(x=0;x<aux->xsize;x++)
    {
      xx = (float) x / scale;           /* corresponding x */
      xc = floor( (double) xx + 0.5 );  /* corresponding x pixel */
      gaussian_kernel( kernel, sigma, (float) h + xx - (float) xc );

      for(y=0;y<aux->ysize;y++)
        {
          sum = 0.0;
          for(i=0;i<n;i++)
            {
              j = xc - h + i;
              while(j<0) j+=nx2;
              while(j>=nx2) j-=nx2;
              if(j>=in->xsize) j = nx2-1-j;
              sum += in->data[ j + y * in->xsize ] * kernel->values[i];
            }
          aux->data[ x + y * aux->xsize ] = sum;
        }
    }

  /* y axis convolution */
  for(y=0;y<out->ysize;y++)
    {
      yy = (float) y / scale;           /* corresponding y */
      yc = floor( (double) yy + 0.5 );  /* corresponding y pixel */
      gaussian_kernel( kernel, sigma, (float) h + yy - (float) yc );

      for(x=0;x<out->xsize;x++)
        {
          sum = 0.0;
          for(i=0;i<n;i++)
            {
              j = yc - h + i;
              while(j<0) j+=ny2;
              while(j>=ny2) j-=ny2;
              if(j>=in->ysize) j = ny2-1-j;
              sum += aux->data[ x + j * aux->xsize ] * kernel->values[i];
            }
          out->data[ x + y * out->xsize ] = sum;
        }
    }

  /* free memory */
  free_ntuple_float(kernel);
  free_image_float(aux);

  return out;
}

/*----------------------------------------------------------------------------*/
#ifdef CODE_NOT_USED
static void gaussian_filter(image_float image, float sigma)
{
  int offset = ceil( (double) sigma * sqrt( log(10.0) * 6.0 ) );
  int n = 1 + 2 * offset;
  ntuple_float kernel = new_ntuple_float(n);
  image_float tmp = new_image_float(image->xsize,image->ysize);
  int x,y,i,j;
  int nx2 = 2*image->xsize;
  int ny2 = 2*image->ysize;
  float val;

  /* compute gaussian kernel */
  kernel->size = 1;
  for(i=offset;i<n;i++)
    {
      val = (float)(i-offset) / sigma;
      kernel->values[i] = kernel->values[n-1-i] =
                                      (float) exp( (double) -0.5 * val * val );
    }
  /* normalization */
  for(val=0.0,i=n;i--;) val += kernel->values[i];
  for(i=n;i--;) kernel->values[i] /= val;

  /* x axis convolution */
  for(x=0;x<image->xsize;x++)
    for(y=0;y<image->ysize;y++)
      {
        val = 0.0;
        for(i=0;i<n;i++)
          {
            j = x - offset + i;
            while(j<0) j+=nx2;
            while(j>=nx2) j-=nx2;
            if(j>=image->xsize) j = nx2-1-j;
            val += image->data[ j + y * image->xsize ] * kernel->values[i];
          }
        tmp->data[ x + y * tmp->xsize ] = val;
      }

  /* y axis convolution */
  for(x=0;x<image->xsize;x++)
    for(y=0;y<image->ysize;y++)
      {
        val = 0.0;
        for(i=0;i<n;i++)
          {
            j = y - offset + i;
            while(j<0) j+=ny2;
            while(j>=nx2) j-=ny2;
            if(j>=image->ysize) j = ny2-1-j;
            val += tmp->data[ x + j * tmp->xsize ] * kernel->values[i];
          }
        image->data[ x + y * image->xsize ] = val;
      }

  /* free memory */
  free_ntuple_float(kernel);
  free_image_float(tmp);
}
#endif /* CODE_NOT_USED */


/*----------------------------------------------------------------------------*/
/*------------------------------ Gradient Angle ------------------------------*/
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/*
   compute the direction of the level line at each point.
   it returns:

   - an image_float with the angle at each pixel or NOTDEF.
   - the image_float 'modgrad' (a pointer is passed as argument)
     with the gradient magnitude at each point.
   - a list of pixels 'list_p' roughly ordered by gradient magnitude.
     (the order is made by classing points into bins by gradient magnitude.
      the parameters 'n_bins' and 'max_grad' specify the number of
      bins and the gradient modulus at the highest bin.)
   - a pointer 'mem_p' to the memory used by 'list_p' to be able to
     free the memory.
 */
static image_float ll_angle( image_float in, float threshold,
                             struct coorlist ** list_p, void ** mem_p,
                             image_float * modgrad, int n_bins, int max_grad )
{
  image_float g = new_image_float(in->xsize,in->ysize);
  int n,p,x,y,adr,i;
  float com1,com2,gx,gy,norm2;
  /* variables used in pseudo-ordering of gradient magnitude */
  float f_n_bins = (float) n_bins;
  float f_max_grad = (float) max_grad;
  int list_count = 0;
  struct coorlist * list;
  struct coorlist ** range_l_s;
  struct coorlist ** range_l_e;
  struct coorlist * start;
  struct coorlist * end;

  if(verbose) fprintf(stderr,"gradient magnitude threshold: %g\n",threshold);

  threshold *= 4.0 * threshold;

  n = in->ysize;
  p = in->xsize;

  /* get memory for the image of gradient modulus */
  *modgrad = new_image_float(in->xsize,in->ysize);

  /* get memory for "ordered" coordinate list */
  list = (struct coorlist *) calloc(n*p,sizeof(struct coorlist));
  *mem_p = (void *) list;
  range_l_s = (struct coorlist **) calloc(n_bins,sizeof(struct coorlist *));
  range_l_e = (struct coorlist **) calloc(n_bins,sizeof(struct coorlist *));
  if( !list || !range_l_s || !range_l_e ) error("Not enough memory.");
  for(i=0;i<n_bins;i++) range_l_s[i] = range_l_e[i] = NULL;

  /* undefined on downright boundary */
  for(x=0;x<p;x++) g->data[(n-1)*p+x] = NOTDEF;
  for(y=0;y<n;y++) g->data[p*y+p-1]   = NOTDEF;

  /*** remaining part ***/
  for(x=0;x<p-1;x++)
    for(y=0;y<n-1;y++)
      {
        adr = y*p+x;

        /* norm 2 computation */
        com1 = in->data[adr+p+1] - in->data[adr];
        com2 = in->data[adr+1]   - in->data[adr+p];
        gx = com1+com2;
        gy = com1-com2;
        norm2 = gx*gx+gy*gy;

        (*modgrad)->data[adr] = (float) sqrt( (double) norm2 / 4.0 );

        if(norm2 <= threshold) /* norm too small, gradient no defined */
          g->data[adr] = NOTDEF;
        else
          {
            /* angle computation */
            g->data[adr] = (float) atan2(gx,-gy);

            /* store the point in the right bin,
               according to its norm */
            i = (int) (norm2 * f_n_bins / f_max_grad);
            if(i>=n_bins) i = n_bins-1;
            if( range_l_e[i]==NULL )
              range_l_s[i] = range_l_e[i] = list+list_count++;
            else
              {
                range_l_e[i]->next = list+list_count;
                range_l_e[i] = list+list_count++;
              }
            range_l_e[i]->x = x;
            range_l_e[i]->y = y;
            range_l_e[i]->next = NULL;
          }
      }

  /* make the list of points "ordered" by norm value */
  for(i=n_bins-1; i>0 && range_l_s[i]==NULL; i--);
  start = range_l_s[i];
  end = range_l_e[i];
  if(start!=NULL)
    for(i--;i>0; i--)
      if( range_l_s[i] != NULL )
        {
          end->next = range_l_s[i];
          end = range_l_e[i];
        }
  *list_p = start;

  /* free memory */
  free(range_l_s);
  free(range_l_e);

  return g;
}

/*----------------------------------------------------------------------------*/
/*
   find if the point x,y in angles have angle theta up to precision prec
 */
static int isaligned(int x, int y, image_float angles, float theta, float prec)
{
  float a = angles->data[ x + y * angles->xsize ];

  if( float_equal(a,NOTDEF) ) return FALSE;

  /* it is assumed that theta and a are in the range [-pi,pi] */
  theta -= a;
  if( theta < 0.0 ) theta = -theta;
  if( theta > M_3_2_PI )
    {
      theta -= M_2__PI;
      if( theta < 0.0 ) theta = -theta;
    }

  return theta < prec;
}

/*----------------------------------------------------------------------------*/
static float angle_diff(float a, float b)
{
  a -= b;
  while( a <= -M_PI ) a += 2.0*M_PI;
  while( a >   M_PI ) a -= 2.0*M_PI;
  if( a < 0.0 ) a = -a;
  return a;
}


/*----------------------------------------------------------------------------*/
/*----------------------------- NFA computation ------------------------------*/
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/*
   Calculates the natural logarithm of the absolute value of
   the gamma function of x using the Lanczos approximation,
   see http://www.rskey.org/gamma.htm.

   The formula used is
     \Gamma(x) = \frac{ \sum_{n=0}^{N} q_n x^n }{ \Pi_{n=0}^{N} (x+n) }
                 (x+5.5)^(x+0.5) e^{-(x+5.5)}
   so
     \log\Gamma(x) = \log( \sum_{n=0}^{N} q_n x^n ) + (x+0.5) \log(x+5.5)
                     - (x+5.5) - \sum_{n=0}^{N} \log(x+n)
   and
     q0 = 75122.6331530
     q1 = 80916.6278952
     q2 = 36308.2951477
     q3 = 8687.24529705
     q4 = 1168.92649479
     q5 = 83.8676043424
     q6 = 2.50662827511
 */
static double log_gamma_lanczos(double x)
{
  static double q[7] = { 75122.6331530, 80916.6278952, 36308.2951477,
                         8687.24529705, 1168.92649479, 83.8676043424,
                         2.50662827511 };
  double a = (x+0.5) * log(x+5.5) - (x+5.5);
  double b = 0.0;
  int n;

  for(n=0;n<7;n++)
    {
      a -= log( x + (double) n );
      b += q[n] * pow( x, (double) n );
    }
  return a + log(b);
}

/*----------------------------------------------------------------------------*/
/*
   Calculates the natural logarithm of the absolute value of
   the gamma function of x using Robert H. Windschitl method,
   see http://www.rskey.org/gamma.htm.

   The formula used is
     \Gamma(x) = \sqrt(\frac{2\pi}{x}) ( \frac{x}{e}
                   \sqrt{ x\sinh(1/x) + \frac{1}{810x^6} } )^x
   so
     \log\Gamma(x) = 0.5\log(2\pi) + (x-0.5)\log(x) - x
                     + 0.5x\log( x\sinh(1/x) + \frac{1}{810x^6} ).

   This formula is good approximation when x > 15.
 */
static double log_gamma_windschitl(double x)
{
  return 0.918938533204673 + (x-0.5)*log(x) - x
         + 0.5*x*log( x*sinh(1/x) + 1/(810.0*pow(x,6.0)) );
}

/*----------------------------------------------------------------------------*/
/*
   Calculates the natural logarithm of the absolute value of
   the gamma function of x. When x>15 use log_gamma_windschitl(),
   otherwise use log_gamma_lanczos().
 */
#define log_gamma(x) ((x)>15.0?log_gamma_windschitl(x):log_gamma_lanczos(x))

/*----------------------------------------------------------------------------*/
/*
   Computes the logarithm of NFA to base 10.

   NFA = NT.b(n,k,p)
   the return value is log10(NFA)

   n,k,p - binomial parameters.
   logNT - logarithm of Number of Tests
 */
#define TABSIZE 100000
static double nfa(int n, int k, double p, double logNT)
{
  static double inv[TABSIZE];   /* table to keep computed inverse values */
  double tolerance = 0.1;       /* an error of 10% in the result is accepted */
  double log1term,term,bin_term,mult_term,bin_tail,err;
  double p_term = p / (1.0-p);
  int i;

  if( n<0 || k<0 || k>n || p<0.0 || p>1.0 )
    error("Wrong n, k or p values in nfa()");

  if( n==0 || k==0 ) return -logNT;
  if( n==k ) return -logNT - (double) n * log10(p);

  log1term = log_gamma((double)n+1.0) - log_gamma((double)k+1.0)
           - log_gamma((double)(n-k)+1.0)
           + (double) k * log(p) + (double) (n-k) * log(1.0-p);

  term = exp(log1term);
  if( float_equal(term,0.0) )              /* the first term is almost zero */
    {
      if( (double) k > (double) n * p )    /* at begin or end of the tail? */
        return -log1term / M_LN10 - logNT; /* end: use just the first term */
      else
        return -logNT;                     /* begin: the tail is roughly 1 */
    }

  bin_tail = term;
  for(i=k+1;i<=n;i++)
    {
      bin_term = (double) (n-i+1) * ( i<TABSIZE ?
                   ( float_equal(inv[i],0.0) ? inv[i] : (inv[i]=1.0/(double)i))
                   : 1.0/(double)i );
      mult_term = bin_term * p_term;
      term *= mult_term;
      bin_tail += term;
      if(bin_term<1.0)
        {
          /* when bin_term<1 then mult_term_j<mult_term_i for j>i.
             then, the error on the binomial tail when truncated at
             the i term can be bounded by a geometric series of form
             term_i * sum mult_term_i^j.                            */
          err = term * ( ( 1.0 - pow( mult_term, (double) (n-i+1) ) ) /
                         (1.0-mult_term) - 1.0 );

          /* one wants an error at most of tolerance*final_result, or:
             tolerance * abs(-log10(bin_tail)-logNT).
             now, the error that can be accepted on bin_tail is
             given by tolerance*final_result divided by the derivative
             of -log10(x) when x=bin_tail. that is:
             tolerance * abs(-log10(bin_tail)-logNT) / (1/bin_tail)
             finally, we truncate the tail if the error is less than:
             tolerance * abs(-log10(bin_tail)-logNT) * bin_tail        */
          if( err < tolerance * fabs(-log10(bin_tail)-logNT) * bin_tail ) break;
        }
    }
  return -log10(bin_tail) - logNT;
}


/*----------------------------------------------------------------------------*/
/*--------------------------- Rectangle structure ----------------------------*/
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
struct rect /* line segment with width */
{
  float x1,y1,x2,y2;  /* first and second point of the line segment */
  float width;        /* rectangle width */
  float x,y;          /* center of the rectangle */
  float theta;        /* angle */
  float dx,dy;        /* vector with the line segment angle */
  float prec;         /* tolerance angle */
  double p;           /* probability of a point with angle within prec */
};

/*----------------------------------------------------------------------------*/
static void rect_copy(struct rect * in, struct rect * out)
{
  out->x1 = in->x1;
  out->y1 = in->y1;
  out->x2 = in->x2;
  out->y2 = in->y2;
  out->width = in->width;
  out->x = in->x;
  out->y = in->y;
  out->theta = in->theta;
  out->dx = in->dx;
  out->dy = in->dy;
  out->prec = in->prec;
  out->p = in->p;
}

/*----------------------------------------------------------------------------*/
static void add2image( image_char out, struct rect * r )
{
  float x = r->x1;
  float y = r->y1;
  int len = ceil( (double) dist(r->x1,r->y1,r->x2,r->y2) );
  int n;

  for(n=0; n<len; n++, x+=r->dx, y+=r->dy)
    out->data[ (int) x + (int) y * out->xsize ] = 255;
}

/*----------------------------------------------------------------------------*/
/*
   rectangle points iterator
 */
typedef struct
{
  float vx[4];
  float vy[4];
  float ys,ye;
  int x,y;
} rect_iter;

/*----------------------------------------------------------------------------*/
static float inter_low(float x, float x1, float y1, float x2, float y2)
{
  if( x1 > x2 || x < x1 || x > x2 )
    {
      fprintf(stderr,"inter_low: x %g x1 %g x2 %g.\n",x,x1,x2);
      error("Impossible situation.");
    }
  if( float_equal(x1,x2) && y1<y2 ) return y1;
  if( float_equal(x1,x2) && y1>y2 ) return y2;
  return y1 + (x-x1) * (y2-y1) / (x2-x1);
}

/*----------------------------------------------------------------------------*/
static float inter_hi(float x, float x1, float y1, float x2, float y2)
{
  if( x1 > x2 || x < x1 || x > x2 )
    {
      fprintf(stderr,"inter_hi: x %g x1 %g x2 %g.\n",x,x1,x2);
      error("Impossible situation.");
    }
  if( float_equal(x1,x2) && y1<y2 ) return y2;
  if( float_equal(x1,x2) && y1>y2 ) return y1;
  return y1 + (x-x1) * (y2-y1) / (x2-x1);
}

/*----------------------------------------------------------------------------*/
static void ri_del(rect_iter * iter)
{
  free(iter);
}

/*----------------------------------------------------------------------------*/
static int ri_end(rect_iter * i)
{
  return (float)(i->x) > i->vx[2];
}

/*----------------------------------------------------------------------------*/
static void ri_inc(rect_iter * i)
{
  if( (float) (i->x) <= i->vx[2] ) i->y++;

  while( (float) (i->y) > i->ye && (float) (i->x) <= i->vx[2] )
    {
      /* new x */
      i->x++;

      if( (float) (i->x) > i->vx[2] ) return; /* end of iteration */

      /* update lower y limit for the line */
      if( (float) i->x < i->vx[3] )
        i->ys = inter_low((float)i->x,i->vx[0],i->vy[0],i->vx[3],i->vy[3]);
      else i->ys = inter_low((float)i->x,i->vx[3],i->vy[3],i->vx[2],i->vy[2]);

      /* update upper y limit for the line */
      if( (float)i->x < i->vx[1] )
        i->ye = inter_hi((float)i->x,i->vx[0],i->vy[0],i->vx[1],i->vy[1]);
      else i->ye = inter_hi( (float)i->x,i->vx[1],i->vy[1],i->vx[2],i->vy[2]);

      /* new y */
      i->y = (float) ceil( (double) i->ys );
    }
}

/*----------------------------------------------------------------------------*/
static rect_iter * ri_ini(struct rect * r)
{
  float vx[4],vy[4];
  int n,offset;
  rect_iter * i;

  i = (rect_iter *) malloc(sizeof(rect_iter));
  if(!i) error("ri_ini: Not enough memory.");

  vx[0] = r->x1 - r->dy * r->width / 2.0;
  vy[0] = r->y1 + r->dx * r->width / 2.0;
  vx[1] = r->x2 - r->dy * r->width / 2.0;
  vy[1] = r->y2 + r->dx * r->width / 2.0;
  vx[2] = r->x2 + r->dy * r->width / 2.0;
  vy[2] = r->y2 - r->dx * r->width / 2.0;
  vx[3] = r->x1 + r->dy * r->width / 2.0;
  vy[3] = r->y1 - r->dx * r->width / 2.0;

  if( r->x1 < r->x2 && r->y1 <= r->y2 ) offset = 0;
  else if( r->x1 >= r->x2 && r->y1 < r->y2 ) offset = 1;
  else if( r->x1 > r->x2 && r->y1 >= r->y2 ) offset = 2;
  else offset = 3;
  /* else if( r->x1 <= r->x2 && r->y1 > r->y2 ) offset = 3; */

  for(n=0; n<4; n++)
    {
      i->vx[n] = vx[(offset+n)%4];
      i->vy[n] = vy[(offset+n)%4];
    }

  /* starting point */
  i->x = ceil( (double) (i->vx[0]) ) - 1;
  i->y = ceil( (double) (i->vy[0]) );
  i->ys = i->ye = -BIG_NUMBER;

  /* advance to the first point */
  ri_inc(i);

  return i;
}

/*----------------------------------------------------------------------------*/
static double rect_nfa(struct rect * rec, image_float angles, double logNT)
{
  rect_iter * i;
  int pts = 0;
  int alg = 0;
  double nfa_val;

  for(i=ri_ini(rec); !ri_end(i); ri_inc(i))
    if( i->x>=0 && i->y>=0 && i->x<angles->xsize && i->y<angles->ysize )
      {
        if(verbose) fprintf(stderr,"| %d %d ",i->x,i->y);
        ++pts;
        if( isaligned(i->x,i->y,angles,rec->theta,rec->prec) )
          {
            if(verbose) fprintf(stderr,"yes ");
            ++alg;
          }
      }
  ri_del(i);

  nfa_val = nfa(pts,alg,rec->p,logNT);
  if(verbose) fprintf(stderr,"\npts %d alg %d p %g nfa %g\n",
                      pts,alg,rec->p,nfa_val);

  return nfa_val;
}


/*----------------------------------------------------------------------------*/
/*---------------------------------- REGIONS ---------------------------------*/
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
static float get_theta( struct point * reg, int reg_size, float x, float y,
                        image_float modgrad, float reg_angle, float prec,
                        float * elongation )
{
  int i;
  float Ixx = 0.0;
  float Iyy = 0.0;
  float Ixy = 0.0;
  float lambda1,lambda2,tmp;
  float theta;
  float weight,sum;

  if(reg_size <= 1) error("get_theta: region size <= 1.");


  /*----------- theta ---------------------------------------------------*/
  /*
      Region inertia matrix A:
         Ixx Ixy
         Ixy Iyy
      where
        Ixx = \sum_i y_i^2
        Iyy = \sum_i x_i^2
        Ixy = -\sum_i x_i y_i

      lambda1 and lambda2 are the eigenvalues, with lambda1 >= lambda2.
      They are found by solving the characteristic polynomial
      det(\lambda I - A) = 0.

      To get the line segment direction we want to get the eigenvector of
      the smaller eigenvalue. We have to solve a,b in:
        a.Ixx + b.Ixy = a.lambda2
        a.Ixy + b.Iyy = b.lambda2
      We want the angle theta = atan(b/a). I can be computed with
      any of the two equations:
        theta = atan( (lambda2-Ixx) / Ixy )
      or
        theta = atan( Ixy / (lambda2-Iyy) )

      When |Ixx| > |Iyy| we use the first, otherwise the second
      (just to get better numeric precision).
   */
  sum = 0.0;
  for(i=0; i<reg_size; i++)
    {
      weight = modgrad->data[ reg[i].x + reg[i].y * modgrad->xsize ];
      Ixx += ((float)reg[i].y - y) * ((float)reg[i].y - y) * weight;
      Iyy += ((float)reg[i].x - x) * ((float)reg[i].x - x) * weight;
      Ixy -= ((float)reg[i].x - x) * ((float)reg[i].y - y) * weight;
      sum += weight;
    }
  if( sum <= 0.0 ) error("get_theta: weights sum less or equal to zero.");
  Ixx /= sum;
  Iyy /= sum;
  Ixy /= sum;
  lambda1 = ( Ixx + Iyy + (float) sqrt( (double) (Ixx - Iyy) * (Ixx - Iyy)
                                        + 4.0 * Ixy * Ixy ) ) / 2.0;
  lambda2 = ( Ixx + Iyy - (float) sqrt( (double) (Ixx - Iyy) * (Ixx - Iyy)
                                        + 4.0 * Ixy * Ixy ) ) / 2.0;
  if( fabs(lambda1) < fabs(lambda2) )
    {
      fprintf(stderr,"Ixx %g Iyy %g Ixy %g lamb1 %g lamb2 %g - lamb1 < lamb2\n",
                      Ixx,Iyy,Ixy,lambda1,lambda2);
      tmp = lambda1;
      lambda1 = lambda2;
      lambda2 = tmp;
    }
  if(verbose) fprintf(stderr,"Ixx %g Iyy %g Ixy %g lamb1 %g lamb2 %g\n",
                      Ixx,Iyy,Ixy,lambda1,lambda2);

  *elongation = lambda1/lambda2;

  if( fabs(Ixx) > fabs(Iyy) )
    theta = (float) atan2( (double) lambda2 - Ixx, (double) Ixy );
  else
    theta = (float) atan2( (double) Ixy, (double) lambda2 - Iyy );

  /* the previous procedure don't cares orientations,
     so it could be wrong by 180 degrees.
     here is corrected if necessary */
  if( angle_diff(theta,reg_angle) > prec ) theta += M_PI;

  return theta;
}

/*----------------------------------------------------------------------------*/
static float region2rect( struct point * reg, int reg_size,
                          image_float modgrad, float reg_angle,
                          float prec, double p, struct rect * rec )
{
  float x,y,dx,dy,l,w,lf,lb,wl,wr,theta,weight,sum,sum_th,s,elongation;
  int i,n;
  int l_min,l_max,w_min,w_max;

  /* center */
  x = y = sum = 0.0;
  for(i=0; i<reg_size; i++)
    {
      weight = modgrad->data[ reg[i].x + reg[i].y * modgrad->xsize ];
      x += (float) reg[i].x * weight;
      y += (float) reg[i].y * weight;
      sum += weight;
    }
  if( sum <= 0.0 ) error("region2rect: weights sum equal to zero.");
  x /= sum;
  y /= sum;
  if(verbose) fprintf(stderr,"center x %g y %g\n",x,y);

  /* theta */
  theta = get_theta(reg,reg_size,x,y,modgrad,reg_angle,prec,&elongation);
  if(verbose) fprintf(stderr,"theta %g\n",theta);

  /* length and width */
  lf = lb = wl = wr = 0.5;
  l_min = l_max = w_min = w_max = 0;
  dx = (float) cos( (double) theta );
  dy = (float) sin( (double) theta );
  for(i=0; i<reg_size; i++)
    {
      l =  ((float)reg[i].x - x) * dx + ((float)reg[i].y - y) * dy;
      w = -((float)reg[i].x - x) * dy + ((float)reg[i].y - y) * dx;
      weight = modgrad->data[ reg[i].x + reg[i].y * modgrad->xsize ];

      n = (int) MY_ROUND( l * (float) sum_res );
      if(n<l_min) l_min = n;
      if(n>l_max) l_max = n;
      sum_l[sum_offset + n] += weight;

      n = (int) MY_ROUND( w * (float) sum_res );
      if(n<w_min) w_min = n;
      if(n>w_max) w_max = n;
      sum_w[sum_offset + n] += weight;
    }

  sum_th = 0.01 * sum; /* weight threshold for selecting region */
  for(s=0.0,i=l_min; s<sum_th && i<=l_max; i++) s += sum_l[sum_offset + i];
  lb = ( (float) (i-1) - 0.5 ) / (float) sum_res;
  for(s=0.0,i=l_max; s<sum_th && i>=l_min; i--) s += sum_l[sum_offset + i];
  lf = ( (float) (i+1) + 0.5 ) / (float) sum_res;

  sum_th = 0.01 * sum; /* weight threshold for selecting region */
  for(s=0.0,i=w_min; s<sum_th && i<=w_max; i++) s += sum_w[sum_offset + i];
  wr = ( (float) (i-1) - 0.5 ) / (float) sum_res;
  for(s=0.0,i=w_max; s<sum_th && i>=w_min; i--) s += sum_w[sum_offset + i];
  wl = ( (float) (i+1) + 0.5 ) / (float) sum_res;

  if(verbose) fprintf(stderr,"lb %g lf %g wr %g wl %g\n",lb,lf,wr,wl);

  /* free vector */
  for(i=l_min; i<=l_max; i++) sum_l[sum_offset + i] = 0.0;
  for(i=w_min; i<=w_max; i++) sum_w[sum_offset + i] = 0.0;

  rec->x1 = x + lb * dx;
  rec->y1 = y + lb * dy;
  rec->x2 = x + lf * dx;
  rec->y2 = y + lf * dy;
  rec->width = wl - wr;
  rec->x = x;
  rec->y = y;
  rec->theta = theta;
  rec->dx = dx;
  rec->dy = dy;
  rec->prec = prec;
  rec->p = p;

  if( rec->width < 1.0 ) rec->width = 1.0;

  return elongation;
}

/*----------------------------------------------------------------------------*/
static void region_grow( int x, int y, image_float angles, struct point * reg,
                         int * reg_size, float * reg_angle, image_char used,
                         float prec, int radius,
                         image_float modgrad, double p, int min_reg_size )
{
  float sumdx,sumdy;
  int xx,yy,i;

  /* first point of the region */
  *reg_size = 1;
  reg[0].x = x;
  reg[0].y = y;
  *reg_angle = angles->data[x+y*angles->xsize];
  sumdx = (float) cos( (double) (*reg_angle) );
  sumdy = (float) sin( (double) (*reg_angle) );
  used->data[x+y*used->xsize] = USED;

  /* try neighbors as new region points */
  for(i=0; i<*reg_size; i++)
    for(xx=reg[i].x-radius; xx<=reg[i].x+radius; xx++)
      for(yy=reg[i].y-radius; yy<=reg[i].y+radius; yy++)
        if( xx>=0 && yy>=0 && xx<used->xsize && yy<used->ysize &&
            used->data[xx+yy*used->xsize] != USED &&
            isaligned(xx,yy,angles,*reg_angle,prec) )
          {
            /* add point */
            used->data[xx+yy*used->xsize] = USED;
            reg[*reg_size].x = xx;
            reg[*reg_size].y = yy;
            ++(*reg_size);

            /* update reg_angle */
            sumdx += (float) cos( (double) angles->data[xx+yy*angles->xsize] );
            sumdy += (float) sin( (double) angles->data[xx+yy*angles->xsize] );
            *reg_angle = (float) atan2( (double) sumdy, (double) sumdx );
          }

  if(verbose) /* print region points */
    {
      fprintf(stderr,"region found: %d points\n",*reg_size);
      for(i=0; i<*reg_size; i++) fprintf(stderr,"| %d %d ",reg[i].x,reg[i].y);
      fprintf(stderr,"\n");
    }
}

/*----------------------------------------------------------------------------*/
static double rect_improve( struct rect * rec, image_float angles,
                            double logNT, double eps )
{
  struct rect r;
  double nfa_val,nfa_new;
  float delta = 0.5;
  float delta_2 = delta / 2.0;
  int n;

  nfa_val = rect_nfa(rec,angles,logNT);

  if( nfa_val > eps ) return nfa_val;

  rect_copy(rec,&r);
  for(n=0; n<5; n++)
    {
      r.p /= 2.0;
      r.prec = M_PI * r.p;
      nfa_new = rect_nfa(&r,angles,logNT);
      if( nfa_new > nfa_val )
        {
          nfa_val = nfa_new;
          rect_copy(&r,rec);
        }
    }

  if( nfa_val > eps ) return nfa_val;

  rect_copy(rec,&r);
  for(n=0; n<5; n++)
    {
      if( (r.width - delta) >= 0.5 )
        {
          r.width -= delta;
          nfa_new = rect_nfa(&r,angles,logNT);
          if( nfa_new > nfa_val )
            {
              rect_copy(&r,rec);
              nfa_val = nfa_new;
            }
        }
    }

  if( nfa_val > eps ) return nfa_val;

  rect_copy(rec,&r);
  for(n=0; n<5; n++)
    {
      if( (r.width - delta) >= 0.5 )
        {
          r.x1 += -r.dy * delta_2;
          r.y1 +=  r.dx * delta_2;
          r.x2 += -r.dy * delta_2;
          r.y2 +=  r.dx * delta_2;
          r.width -= delta;
          nfa_new = rect_nfa(&r,angles,logNT);
          if( nfa_new > nfa_val )
            {
              rect_copy(&r,rec);
              nfa_val = nfa_new;
            }
        }
    }

  if( nfa_val > eps ) return nfa_val;

  rect_copy(rec,&r);
  for(n=0; n<5; n++)
    {
      if( (r.width - delta) >= 0.5 )
        {
          r.x1 -= -r.dy * delta_2;
          r.y1 -=  r.dx * delta_2;
          r.x2 -= -r.dy * delta_2;
          r.y2 -=  r.dx * delta_2;
          r.width -= delta;
          nfa_new = rect_nfa(&r,angles,logNT);
          if( nfa_new > nfa_val )
            {
              rect_copy(&r,rec);
              nfa_val = nfa_new;
            }
        }
    }

  if( nfa_val > eps ) return nfa_val;

  rect_copy(rec,&r);
  for(n=0; n<5; n++)
    {
      r.p /= 2.0;
      r.prec = M_PI * r.p;
      nfa_new = rect_nfa(&r,angles,logNT);
      if( nfa_new > nfa_val )
        {
          nfa_val = nfa_new;
          rect_copy(&r,rec);
        }
    }

  return nfa_val;
}


/*----------------------------------------------------------------------------*/
/*-------------------------- LINE SEGMENT DETECTION --------------------------*/
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
static void LineSegmentDetection( image_float in, float q, float d,
                                  double eps, int * x, int * y,
                                  FILE * fout, FILE * arout, ntuple_float out,
                                  image_char iout, image_char reg_out,
                                  int * reg_n, int n_bins, int max_grad,
                                  float scale, float sigma_scale, FILE * svg )
{
  float rho = q / (float) sin( M_PI / (double) d );   /* gradient threshold */
  struct coorlist * list_p;
  void * mem_p;
  image_float modgrad;
  image_float filtered_in = NULL;
  image_float angles;
  image_char used;
  int xsize,ysize;
  struct point * reg;
  int reg_size;
  float reg_angle;
  float prec = M_PI / d;
  double p = 1.0 / (double) d;
  double nfa_val;
  double logNT;
  struct rect rec;
  int radius = 1;
  int i;
  int segnum = 0;
  int min_reg_size;

  /* scale (if necesary) and angles computation */
  if( !float_equal(scale,1.0) )
    {
      filtered_in = gaussian_sampler( in, scale, sigma_scale );
      angles = ll_angle( filtered_in, rho, &list_p, &mem_p,
                         &modgrad, n_bins, max_grad );
      xsize = filtered_in->xsize;
      ysize = filtered_in->ysize;
    }
  else
    {
      angles = ll_angle(in,rho,&list_p,&mem_p,&modgrad,n_bins,max_grad);
      xsize = in->xsize;
      ysize = in->ysize;
    }
  logNT = 5.0 * ( log10( (double) xsize ) + log10( (double) ysize ) ) / 2.0;
  min_reg_size = -logNT/log10(p); /* minimal number of point that can
                                     give a meaningful event */

  /* svg file header */
  if(svg)
    {
      fprintf(svg,"<?xml version=\"1.0\" standalone=\"no\"?>\n");
      fprintf(svg,"<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\"\n");
      fprintf(svg," \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">\n");
      fprintf(svg,"<svg width=\"%dpx\" height=\"%dpx\" ",in->xsize,in->ysize);
      fprintf(svg,"version=\"1.1\"\n xmlns=\"http://www.w3.org/2000/svg\" ");
      fprintf(svg,"xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n");
    }

  /* get memory */
  if(verbose) fprintf(stderr,"getting memory.\n");
  used = new_image_char_ini(xsize,ysize,NOTUSED);
  reg = (struct point *) calloc(xsize * ysize, sizeof(struct point));
  sum_offset = sum_res * ceil( sqrt( (double) xsize * xsize
                                     + (double) ysize * ysize) ) + 2;
  sum_l = (float *) calloc(2*sum_offset,sizeof(float));
  sum_w = (float *) calloc(2*sum_offset,sizeof(float));
  if( !reg || !sum_l || !sum_w ) error("Not enough memory!\n");
  for(i=0;i<2*sum_offset;i++) sum_l[i] = sum_w[i] = 0;

  /* just start at point x,y option */
  if( x && y && *x > 0 && *y > 0 && *x < (xsize-1) && *y < (ysize-1) )
    {
      if(verbose) fprintf(stderr,"starting only at point %d,%d.\n",*x,*y);
      list_p = (struct coorlist *) mem_p;
      list_p->x = *x;
      list_p->y = *y;
      list_p->next = NULL;
    }

  /* search for line segments */
  for(;list_p; list_p = list_p->next )
    if( ( used->data[ list_p->x + list_p->y * used->xsize ] == NOTUSED &&
          !float_equal(angles->data[ list_p->x + list_p->y * angles->xsize ],
                       NOTDEF) ) )
      {
        if(verbose)
          fprintf(stderr,"try to find a line segment starting on %d,%d.\n",
                  list_p->x,list_p->y);

        /* find the region of connected point and ~equal angle */
        region_grow( list_p->x, list_p->y, angles, reg, &reg_size,
                     &reg_angle, used, prec, radius,
                     modgrad, p, min_reg_size );

        /* just process regions with a minimum number of points */
        if( reg_size < min_reg_size )
          {
            if(verbose) fprintf(stderr,"region too small, discarded.\n");
            for(i=0; i<reg_size; i++)
              used->data[reg[i].x+reg[i].y*used->xsize] = NOTINI;
            continue;
          }

        if(verbose) fprintf(stderr,"rectangular approximation of region.\n");
        region2rect(reg,reg_size,modgrad,reg_angle,prec,p,&rec);

        if(verbose) fprintf(stderr,"improve rectangular approximation.\n");
        nfa_val = rect_improve(&rec,angles,logNT,eps);

        if( nfa_val > eps )
          {
            if(verbose) fprintf(stderr,"line segment found! num %d nfa %g\n",
                                segnum,nfa_val);

            /*
              0.5 must be added to compensate that the gradient was
              computed using a 2x2 window, so the computed gradient
              is valid at a point with offset (0.5,0.5). The coordinates
              origin is at the center of pixel 0,0.
            */
            rec.x1 += 0.5; rec.y1 += 0.5;
            rec.x2 += 0.5; rec.y2 += 0.5;

            if( !float_equal(scale,1.0) )
              {
                rec.x1 /= scale;
                rec.y1 /= scale;
                rec.x2 /= scale;
                rec.y2 /= scale;
                rec.width /= scale;
              }

            if(fout) fprintf(fout,"%f %f %f %f %f\n",
                             rec.x1,rec.y1,rec.x2,rec.y2,rec.width);
            if(svg)
              {
                fprintf(svg,"<line x1=\"%f\" y1=\"%f\" x2=\"%f\" y2=\"%f\" ",
                                                  rec.x1,rec.y1,rec.x2,rec.y2);
                fprintf(svg,"stroke=\"black\" />\n");
              }
            if(out) add_5tuple(out,rec.x1,rec.y1,rec.x2,rec.y2,rec.width);
            if(iout) add2image(iout,&rec);
            if( reg_out && (!reg_n || segnum == *reg_n) )
              for(i=0; i<reg_size; i++)
                  reg_out->data[reg[i].x+reg[i].y*reg_out->xsize] = 255;
            if(arout)
              {
                fprintf(arout,"region %d:",segnum);
                for(i=0; i<reg_size; i++)
                  fprintf(arout," %d,%d;",reg[i].x,reg[i].y);
                fprintf(arout,"\n");
              }

            ++segnum;
          }
        else
          for(i=0; i<reg_size; i++)
            used->data[reg[i].x+reg[i].y*used->xsize] = NOTINI;
      }

  /* end svg file */
  if(svg) fprintf(svg,"</svg>\n");

  /* free memory */
  if( filtered_in != NULL ) free_image_float(filtered_in);
  free_image_float(angles);
  free_image_float(modgrad);
  free_image_char(used);
  free( (void *) reg );
  free( (void *) sum_l );
  free( (void *) sum_w );
  free( (void *) mem_p );
}


/*----------------------------------------------------------------------------*/
/*------------------------ MEGAWAVE RELATED FUNCTIONS ------------------------*/
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
#ifdef CODE_NOT_USED
static image_char image_char_from_Cimage(Cimage in)
{
  image_char image;

  if(in == NULL) return NULL;
  image = (image_char) malloc(sizeof(struct image_char_s));
  if( image == NULL ) error("Not enough memory.");
  image->data = (unsigned char *) in->gray;
  image->xsize = in->ncol;
  image->ysize = in->nrow;

  return image;
}
#endif /* CODE_NOT_USED */

/*----------------------------------------------------------------------------*/
#ifndef NO_MEGAWAVE
static Cimage Cimage_from_image_char(Cimage out, image_char in)
{
  out = mw_change_cimage(out,0,0);
  if( out == NULL ) error("Not enough memory.");
  out->ncol = in->xsize;
  out->nrow = in->ysize;
  out->gray = in->data;
  return out;
}
#endif /* !NO_MEGAWAVE */

/*----------------------------------------------------------------------------*/
#ifndef NO_MEGAWAVE
static image_float image_float_from_Fimage(Fimage in)
{
  image_float image;

  if(in == NULL) return NULL;
  image = (image_float) malloc(sizeof(struct image_float_s));
  if( image == NULL ) error("Not enough memory.");
  image->data = (float *) in->gray;
  image->xsize = in->ncol;
  image->ysize = in->nrow;

  return image;
}
#endif /* !NO_MEGAWAVE */

/*----------------------------------------------------------------------------*/
#ifdef CODE_NOT_USED
static Fimage Fimage_from_image_float(Fimage out, image_float in)
{
  out = mw_change_fimage(out,0,0);
  if( out == NULL ) error("Not enough memory.");
  out->ncol = in->xsize;
  out->nrow = in->ysize;
  out->gray = in->data;
  return out;
}
#endif /* CODE_NOT_USED */

/*----------------------------------------------------------------------------*/
#ifndef NO_MEGAWAVE
static Flist Flist_from_n_tuple_float(Flist out, ntuple_float in)
{
  out = mw_change_flist(out,0,0,0);
  if( out == NULL ) error("Not enough memory.");
  out->size = in->size;
  out->max_size = in->max_size;
  out->dim = in->dim;
  out->values = in->values;
  return out;
}
#endif /* !NO_MEGAWAVE */

/*----------------------------------------------------------------------------*/
/*
  add a line segment given by start and end coordinates to a Flists
 */
#ifndef NO_MEGAWAVE
static void add2Flists(Flists out, float x1, float y1, float x2, float y2)
{
  Flist aux;

  aux = mw_change_flist( NULL, 2, 2, 2 );
  if( aux == NULL ) error("Not enough memory.");

  aux->values[0] = x1;
  aux->values[1] = y1;
  aux->values[2] = x2;
  aux->values[3] = y2;

  if( out->size == out->max_size )
    if( mw_enlarge_flists(out) == NULL ) error("Not enough memory.");
  out->list[out->size++] = aux;
}
#endif /* !NO_MEGAWAVE */

/*----------------------------------------------------------------------------*/
/*
  draw a rectangle to a Flists to be viewed by 'fkview'.
 */
#ifndef NO_MEGAWAVE
static void add_rect2Flists(Flists out, float * r, int arrow)
{
  Flist aux;
  int i;
  float theta = (float) atan2( (double) r[3] - r[1], (double) r[2] - r[0] );
  float dx = (float) cos( (double) theta );
  float dy = (float) sin( (double) theta );

  if(arrow) aux = mw_change_flist( NULL, 6, 6, 2 );
  else aux = mw_change_flist( NULL, 5, 5, 2 );
  if( aux == NULL ) error("Not enough memory.");

  i=0;

  /*
     An offset of 0.5,0.5 is added to the output value for a
     correct visualization in 'fkview', where the lower left
     corner of 0,0 pixel has coordinates 0,0.
  */

  aux->values[i++] = r[0] - dy * r[4] / 2.0 + 0.5;
  aux->values[i++] = r[1] + dx * r[4] / 2.0 + 0.5;
  aux->values[i++] = r[2] - dy * r[4] / 2.0 + 0.5;
  aux->values[i++] = r[3] + dx * r[4] / 2.0 + 0.5;

  if(arrow)
    {
      aux->values[i++] = r[2] + dx * r[4] / 2.0 + 0.5;
      aux->values[i++] = r[3] + dy * r[4] / 2.0 + 0.5;
    }

  aux->values[i++] = r[2] + dy * r[4] / 2.0 + 0.5;
  aux->values[i++] = r[3] - dx * r[4] / 2.0 + 0.5;
  aux->values[i++] = r[0] + dy * r[4] / 2.0 + 0.5;
  aux->values[i++] = r[1] - dx * r[4] / 2.0 + 0.5;
  aux->values[i++] = aux->values[0];
  aux->values[i++] = aux->values[1];

  if( out->size == out->max_size )
    if( mw_enlarge_flists(out) == NULL ) error("Not enough memory.");
  out->list[out->size++] = aux;
}
#endif /* !NO_MEGAWAVE */


/*----------------------------------------------------------------------------*/
/*                              MEGAWAVE2'S MAIN                              */
/*----------------------------------------------------------------------------*/
#ifndef NO_MEGAWAVE
void lsd( scale, sigma_scale, q, d, eps, n_bins, max_grad, verb, x, y,
          regout, ascii_reg, n, iout, fout, rout, arrow, ascii, svg,
          image, out )
float  *scale;
float  *sigma_scale;
float  *q;
float  *d;
double *eps;
int    *n_bins;
int    *max_grad;
char   *verb;
int    *x;
int    *y;
Cimage regout;
char   *ascii_reg;
int    *n;
Cimage iout;
Flists fout;
Flists rout;
char   *arrow;
char   *ascii;
char   *svg;
Fimage image;
Flist  out;
{
  image_float in = image_float_from_Fimage(image);
  image_char image_out = NULL;
  image_char image_reg = NULL;
  ntuple_float segs = new_ntuple_float(5);
  int i;
  if(verb) verbose = TRUE;
  if(iout) image_out = new_image_char_ini(image->ncol,image->nrow,0);
  if(regout) image_reg = new_image_char_ini(image->ncol,image->nrow,0);

  LineSegmentDetection( in, *q, *d, *eps, x, y, (ascii?stdout:NULL),
                        (ascii_reg?stdout:NULL), segs, image_out, image_reg,
                        n, *n_bins, *max_grad, *scale, *sigma_scale,
                        (svg?stdout:NULL) );

  /* ----------- the rest is to change the output format ----------- */

  /* Flist output */
  out = Flist_from_n_tuple_float(out,segs);

  /* 'fkview' line segment output (Flists) */
  /*
     An offset of 0.5,0.5 is added to the output value for a
     correct visualization in 'fkview', where the lower left
     corner of 0,0 pixel has coordinates 0,0.
  */
  if(fout)
    {
      fout = mw_change_flists(fout,0,0);
      if( fout == NULL ) error("Not enough memory.");
      for(i=0;i<segs->size;i++)
        add2Flists( fout, segs->values[i*segs->dim + 0]+0.5,
                          segs->values[i*segs->dim + 1]+0.5,
                          segs->values[i*segs->dim + 2]+0.5,
                          segs->values[i*segs->dim + 3]+0.5 );
    }

  /* 'fkview' rectangles output (Flists) */
  /*
     An offset of 0.5,0.5 is added (by function 'add_rect2Flists')
     to the output value for a correct visualization in 'fkview',
     where the lower left corner of 0,0 pixel has coordinates 0,0.
  */
  if(rout)
    {
      rout = mw_change_flists(rout,0,0);
      if( rout == NULL ) error("Not enough memory.");
      for(i=0;i<segs->size;i++)
        add_rect2Flists(rout,segs->values+i*segs->dim,(int)arrow);
    }

  /* image output */
  if(iout) iout = Cimage_from_image_char(iout,image_out);

  /* regions image output */
  if(regout) regout = Cimage_from_image_char(regout,image_reg);

  /* free memory */
  /* free_image_float(in); */ /* this is not good because free mw input image */
  free( (void *) in );        /* this is better */

  if(image_out) free(image_out); /* data should not be freed, used in output */
  if(image_reg) free(image_reg); /* data should not be freed, used in output */
}
#endif /* !NO_MEGAWAVE */


/*----------------------------------------------------------------------------*/
/*                                Ansi C Main                                 */
/*----------------------------------------------------------------------------*/
#ifdef NO_MEGAWAVE
int main(int argc, char ** argv)
{
  FILE * output;
  FILE * svgfile;
  image_float in;

  /* LSD parameters */
  float q = 2.0;           /* Bound to the quantization error on the
                              gradient norm.                                 */
  float d = 8.0;           /* Gradient angle tolerance, tau = 180 degree / d */
  double eps = 0.0;        /* Detection threshold, -log10(NFA).              */
  int n_bins = 16256;      /* Number of bins in pseudo-ordering of gradient
                              modulus. This default value is selected to work
                              well on images with gray levels in [0,255].    */
  int max_grad = 260100;   /* Gradient modulus in the highest bin. The default
                              value corresponds to the highest gradient modulus
                              on images with gray levels in [0,255].         */
  float scale = 1.0;       /* scale the image by Gaussian filter to 'scale'. */
  float sigma_scale = 0.6; /* sigma used in Gaussian filter when scale!=1.0
                              sigma = sigma_scale/scale.                     */

  if( argc <= 1 )
    {
      fprintf(stderr,"LSD - Line Segment Detector, version 1.0\n");
      fprintf(stderr,"Copyright 2009 rafael grompone von gioi\n");
      fprintf(stderr,"Use: lsd in.pgm [out.txt [out.svg]]\n");
      exit(EXIT_FAILURE);
    }

  /* read input file */
  in = read_pgm_image_float(argv[1]);

  /* output file */
  if( argc > 2 )
    {
      output = fopen(argv[2],"w");
      if( output == NULL ) error("Can't open output file.");
    }
  else output = stdout;

  /* svg output file */
  if( argc > 3 )
    {
      svgfile = fopen(argv[3],"w");
      if( svgfile == NULL ) error("Can't open SVG output file.");
    }
  else svgfile = NULL;

  /* execute LSD */
  LineSegmentDetection(in,q,d,eps,NULL,NULL,output,NULL,NULL,NULL,NULL,NULL,
                       n_bins,max_grad,scale,sigma_scale,svgfile);

  free_image_float(in);
  fclose(output);
  if( svgfile != NULL ) fclose(svgfile);

  return EXIT_SUCCESS;
}
#endif /* NO_MEGAWAVE */
/*----------------------------------------------------------------------------*/
