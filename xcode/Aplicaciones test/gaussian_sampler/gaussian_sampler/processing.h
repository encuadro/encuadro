///Users/pablofloresguridi/Desktop/tiempoReal/tiempoReal.xcodeproj
//  processing.h
//  prueba2
//
//  Created by Juan Cardelino on 18/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*--------------------------------------Definiciones de tipos-------------------------------------*/
typedef struct image_double_s
{
    double * data;
    unsigned int xsize,ysize;
} * image_double;

typedef struct ntuple_list_s
{
    unsigned int size;
    unsigned int max_size;
    unsigned int dim;
    double * values;
} * ntuple_list;


/*--------------------------------------Definiciones de tipos-------------------------------------*/

void rgb2gray(double* brillo, unsigned char *pixels, int w, int h, int d);

void free_image_double(image_double i);
image_double new_image_double_ptr( unsigned int xsize, unsigned int ysize, double * data );
static void gaussian_kernel(ntuple_list kernel, double sigma, double mean);
image_double gaussian_sampler( image_double in, double scale, double sigma_scale );
image_double gaussian_sampler2( image_double in, double scale, double sigma_scale );
image_double gaussian_sampler3( image_double in, double scale, double sigma_scale );