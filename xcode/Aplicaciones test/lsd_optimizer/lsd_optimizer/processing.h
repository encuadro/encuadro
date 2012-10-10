///Users/pablofloresguridi/Desktop/tiempoReal/tiempoReal.xcodeproj
//  processing.h
//  prueba2
//
//  Created by Juan Cardelino on 18/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <float.h>
#include <math.h>
#include <string.h>
#include <ctype.h>

/*--------------------------------------Definiciones de tipos-------------------------------------*/
typedef struct image_float_s
{
    float * data;
    unsigned int xsize,ysize;
} * image_float;

typedef struct ntuple_list_s
{
    unsigned int size;
    unsigned int max_size;
    unsigned int dim;
    float * values;
} * ntuple_list;


/*--------------------------------------Definiciones de tipos-------------------------------------*/

void rgb2gray(float* brillo, unsigned char *pixels, int w, int h, int d);

void free_image_float(image_float i);
image_float new_image_float_ptr( unsigned int xsize, unsigned int ysize, float * data );


void skip_whites_and_comments(FILE * f);
int get_num(FILE * f);
float * read_pgm_image_float(int * X, int * Y, char * name);

static void gaussian_kernel(ntuple_list kernel, float sigma, float mean);
image_float gaussian_sampler( image_float in, float scale, float sigma_scale );
