//
//  ViewController.m
//  siftSinCamara
//
//  Created by Pablo Flores Guridi on 12/07/12.
//  Copyright (c) 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "math.h"
#import "assert.h"

//#import "vl/stringop.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize dir;
@synthesize despliegue;
@synthesize leer;
@synthesize leerPuntoC;

unsigned char* pixels;
//vl_sift_pix pixelsGray[262144];
int err=0;
FILE            *in    = 0 ;
VlPgmImage pim ;
vl_uint8        *data  = 0 ;
vl_sift_pix     *fdata = 0 ;




- (IBAction)leerPuntoC:(id)sender
{
    
    int nKeyPoints =0;
    double* keyPoints = 0;
    int* descriptors = 0;
    
    int nKeyPoints2 =0;
    double* keyPoints2 = 0;
    int* descriptors2 = 0;
    
    [dir resignFirstResponder];
    const char* direccion = [dir.text UTF8String];

    /*---------------------------------------------------Levantamos la imagen PNG y obtenemos los pixels--------------------------------------------*/
    
    in = fopen (direccion, "rb") ;
    
    /* read PGM header */
    err = vl_pgm_extract_head (in, &pim) ;
    
    /* allocate buffer */
    data  = malloc(vl_pgm_get_npixels (&pim) *
                   vl_pgm_get_bpp       (&pim) * sizeof (vl_uint8)   ) ;
    fdata = malloc(vl_pgm_get_npixels (&pim) *
                   vl_pgm_get_bpp       (&pim) * sizeof (vl_sift_pix)) ;
    
    
    err  = vl_pgm_extract_data (in, &pim, data) ;
    
    /* convert data type */
    for (int q = 0 ; q < (unsigned) (pim.width * pim.height) ; ++q) {
        fdata [q] = data [q] ;
    }
    
    /*------------------------------------------ Tenemos los pixeles de la imagen en fdata --------------------------------------------------*/
    
    int width = pim.width;
    int height = pim.height;

    
    sift(fdata, width, height,&nKeyPoints,&keyPoints,&descriptors);
    printf("%d \t %d \t %d\n",nKeyPoints,width, height);
    //sift(fdata, width, height,&nKeyPoints2,&keyPoints2,&descriptors2);
    
    escribirDescriptor("/Users/pablofloresguridi/Desktop/Figari1.txt", descriptors, nKeyPoints*128);
    
    //descriptors = levantarDescriptor("/Users/pablofloresguridi/Desktop/descriptors/Blanes1.txt", &nKeyPoints);
    descriptors2 = levantarDescriptor("/Users/pablofloresguridi/Desktop/descriptors/Blanes2.txt", &nKeyPoints2);
 
    Pair* pairs_begin = (Pair*) malloc(sizeof(Pair) * (nKeyPoints+nKeyPoints)) ;
    Pair* pairs_iterator = pairs_begin;
    int correspondencias;
    pairs_iterator = compare (pairs_iterator, descriptors, descriptors2,nKeyPoints,nKeyPoints2, 128, 2   ,&correspondencias);
    printf("%d\n",correspondencias);
    
}

- (IBAction)leer:(id)sender
{
    [dir resignFirstResponder];
    
    const char* direccion = [dir.text UTF8String];
    
    /*---------------------------------------------------Levantamos la imagen PNG y obtenemos los pixels--------------------------------------------*/
    
    in = fopen (direccion, "rb") ;
    
    /* read PGM header */
    err = vl_pgm_extract_head (in, &pim) ;
    
    /* allocate buffer */
    data  = malloc(vl_pgm_get_npixels (&pim) *
                   vl_pgm_get_bpp       (&pim) * sizeof (vl_uint8)   ) ;
    fdata = malloc(vl_pgm_get_npixels (&pim) *
                   vl_pgm_get_bpp       (&pim) * sizeof (vl_sift_pix)) ;
    
    
    err  = vl_pgm_extract_data (in, &pim, data) ;
    
    /* convert data type */
    for (int q = 0 ; q < (unsigned) (pim.width * pim.height) ; ++q) {
        fdata [q] = data [q] ;
    }
    
    /*------------------------------------------ Tenemos los pixeles de la imagen en fdata --------------------------------------------------*/
    
    int width = pim.width;
    int height = pim.height;
    

    /*Definimos los parametros*/

    int	noctaves = 5;
    int	nlevels =3;
    int o_min = 0;
    int nikeys = -1;
    
    double             edge_thresh = 10;
    double             peak_thresh = 0;
    double             norm_thresh = 0;
    double             magnif      = 3;
    double             window_size = 2;
    
    VlSiftFilt* filtroSift = vl_sift_new(width,height,noctaves, nlevels, o_min);
	
    vl_sift_set_peak_thresh(filtroSift, peak_thresh);
    vl_sift_set_edge_thresh(filtroSift, edge_thresh);
    vl_sift_set_norm_thresh(filtroSift, norm_thresh);
    vl_sift_set_magnif(filtroSift, magnif);
    vl_sift_set_window_size(filtroSift,window_size);

    
    double* frames = 0;
    int nframes =0;
    int reserved = 0;
    vl_uint8* descr  = 0;
    
    /*Procesamos cada octava*/
    int i     = 0 ;
    vl_bool first = 1 ;
    while (1)
    {
        int                   err ;
        VlSiftKeypoint const* keys  = 0 ;
        int                   nkeys = 0 ;
        
        
        /* Calculate the GSS for the next octave .................... */
        if (first)
        {
            err   = vl_sift_process_first_octave (filtroSift, fdata) ;
            first = 0 ;
        } else {
            err   = vl_sift_process_next_octave  (filtroSift) ;
        }
        
        if (err) break ;
        
        
        /* Run detector ............................................. */
        if (nikeys < 0) {
            vl_sift_detect (filtroSift) ;
            
            keys  = vl_sift_get_keypoints(filtroSift) ;
            nkeys = vl_sift_get_nkeypoints(filtroSift) ;
            i     = 0 ;
        } else {
            nkeys = nikeys ;
        }
        
        /* For each keypoint ........................................ */
        for (; i < nkeys ; ++i) {
            double                angles [4] ;
            int                   nangles ;
            VlSiftKeypoint const *k ;
            
            /* Obtain keypoint orientations ........................... */

                k = keys + i ;
                nangles = vl_sift_calc_keypoint_orientations(filtroSift, angles, k) ;
            
            /* For each orientation ................................... */
            for (int q = 0 ; q < nangles ; ++q) {
                vl_sift_pix  buf [128] ;
                vl_sift_pix rbuf [128] ;
                
                /* compute descriptors*/
                vl_sift_calc_keypoint_descriptor (filtroSift, buf, k, angles [q]) ;
                transpose_descriptor (rbuf, buf);
            
                
                /* make enough room for all these keypoints and more */
                if (reserved < nframes + 1) {
                    reserved += 2 * nkeys ;
                    frames = malloc(4 * sizeof(double) * reserved) ;
                     descr  = malloc (128 * sizeof(vl_uint8) * reserved) ;
                }
                
                /* Save back with MATLAB conventions. Notice tha the input
                 * image was the transpose of the actual image. */
                frames [4 * nframes + 0] = k -> y + 1 ;
                frames [4 * nframes + 1] = k -> x + 1 ;
                frames [4 * nframes + 2] = k -> sigma ;
                frames [4 * nframes + 3] = VL_PI / 2 - angles [q] ;
                
                
                for (int j = 0 ; j < 128 ; ++j) {
                    float x = 512.0F * rbuf [j] ;
                    x = (x < 255.0F) ? x : 255.0F ;
                    ((vl_uint8*)descr) [128 * nframes + j] = (vl_uint8) x ;
                }


                ++ nframes ;
            } /* next orientation */
        } /* next keypoint */
    } /*next octave*/
    vl_sift_delete (filtroSift);
    printf("Mira que es la ultima\n");
   // despliegue.image = image;
}

VL_INLINE void transpose_descriptor (vl_sift_pix* dst, vl_sift_pix* src)
{
    int const BO = 8 ;  /* number of orientation bins */
    int const BP = 4 ;  /* number of spatial bins     */
    int i, j, t ;
    
    for (j = 0 ; j < BP ; ++j) {
        int jp = BP - 1 - j ;
        for (i = 0 ; i < BP ; ++i) {
            int o  = BO * i + BP*BO * j  ;
            int op = BO * i + BP*BO * jp ;
            dst [op] = src[o] ;
            for (t = 1 ; t < BO ; ++t)
                dst [BO - t + op] = src [t + o] ;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
