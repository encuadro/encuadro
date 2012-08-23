//
//  processing.c
//  prueba2
//
//  Created by Juan Cardelino on 18/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "processing.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>



double* rgb2gray(unsigned char *pixels, int w, int h, int d)
{
        printf("w: %-3d h: %-3d\n",w,h);
        double* luminancia;
        luminancia = (double *) malloc(w*h*sizeof(double));
        
        unsigned long int  pixelNr;
        for(int j=0;j<h;j++)
        {
            
        for(int i=0;i<w;i=i++)
        {
                    //pixelNr = i*h+j;
                    pixelNr = j*w+i;
                    int blue                = pixelNr*d;
                    int green               = pixelNr*d+1;
                    int red                = pixelNr*d+2;
            int r,g,b;
            r=pixels[red];
            g=pixels[green];
            b=pixels[blue];
                   //convert each pixel to gray
         
            double fvalue=0.30*r + 0.59*g + 0.11*b;
      
            
            //for debugging purpose only 
            //printf(" %g",fvalue);
            //printf(" (%d,%d,%d)",r,g,b);
            luminancia[pixelNr] = rint(fvalue);
            }
        }
        return luminancia;
      
}   


    
