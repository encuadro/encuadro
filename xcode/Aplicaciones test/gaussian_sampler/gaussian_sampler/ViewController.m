//
//  ViewController.m
//  gaussian_sampler
//
//  Created by Pablo Flores Guridi on 26/09/12.
//  Copyright (c) 2012 Pablo Flores Guridi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *vista;

@end

@implementation ViewController

@synthesize vista = _vista;
FILE *in = 0 ;
int err = 0;
//VlPgmImage pim;
unsigned char *datachar  = 0;
float *datadouble = 0;
int width;
int height;
float* brillo;

time_t start,end,t;

- (void)viewDidLoad
{
    [super viewDidLoad];
	/*Aca levantamos la imagen, la pasamos a nivel de grises y la desplegamos*/
    
/*-------------------------|PARA CORRER DESDE EL IPAD|-----------------------*/
    UIImage* uiimage = [UIImage imageNamed:@"marker_0004.png"];
    
    CGImageRef image = [uiimage CGImage];
    width = CGImageGetWidth(image);
    height = CGImageGetHeight(image);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
   
    CGContextDrawImage(context, CGRectMake(0, 0, width, height),image);
    CGContextRelease(context);
    

    datadouble = malloc(width*height*sizeof(float));
    int cantidad =width*height;
     NSLog(@"Entra a rgb2gray\n");
    //rgb2gray(datadouble, rawData, width, height, 4);
    for(int pixelNr=0;pixelNr<cantidad;pixelNr++) datadouble[pixelNr] = 0.30*rawData[pixelNr*4+2] + 0.59*rawData[pixelNr*4+1] + 0.11*rawData[pixelNr*4];

     NSLog(@"Sale de rgb2gray\n");

/*-------------------------|PARA LEVANTAR EL PGM DESDE LA PC|-----------------------*/
    
    //char* nombre = "/Users/pablofloresguridi/repositorios/encuadro/xcode/Aplicaciones test/gaussian_sampler/gaussian_sampler/marker_0004.pgm";
    
    //datadouble = read_pgm_image_double(&width,&height,nombre);
    
    [self reconstruirImg:datadouble width:width height:height];
     
    //free(datachar);
    
}
- (IBAction)gaussian_oringinal:(id)sender {
    
    
    float sigma_scale = 0.6; /* Sigma for Gaussian filter is computed as sigma = sigma_scale/scale. */
    float scale = 0.5;
    image_double luminancia_sub;
    image_double image;
  
    image = new_image_double_ptr( (unsigned int) width, (unsigned int) height,(float*) datadouble );
    
    NSLog(@"Entra a gaussian_sampler\n");
    luminancia_sub = gaussian_sampler(image, scale, sigma_scale);
    NSLog(@"Sale de gaussian_sampler\n");
    [self reconstruirImg:luminancia_sub->data width:round(width*scale) height:round(height*scale)];
    
    free( (void *) image );
    free_image_double(luminancia_sub);

}
- (IBAction)gaussian_2:(id)sender {
    float sigma_scale = 0.6; /* Sigma for Gaussian filter is computed as sigma = sigma_scale/scale. */
    float scale = 0.5;
    image_double luminancia_sub;
    image_double image;
    
    image = new_image_double_ptr( (unsigned int) width, (unsigned int) height, (float*)datadouble );
    NSLog(@"Entra a gaussian_sampler 2\n");
    luminancia_sub = gaussian_sampler2(image, scale, sigma_scale);
    NSLog(@"Sale de gaussian_sampler 2\n");
    [self reconstruirImg:luminancia_sub->data width:round(width*scale) height:round(height*scale)];
    
    free( (void *) image );
    free_image_double(luminancia_sub);
    

    
}
- (IBAction)gaussian_3:(id)sender {
    float sigma_scale = 0.6; /* Sigma for Gaussian filter is computed as sigma = sigma_scale/scale. */
    float scale = 0.5;
    image_double luminancia_sub;
    image_double image;
    
    image = new_image_double_ptr( (unsigned int) width, (unsigned int) height, (float*)datadouble );
    NSLog(@"Entra a gaussian_sampler 3\n");
    luminancia_sub = gaussian_sampler3(image, scale, sigma_scale);
    NSLog(@"Sale de gaussian_sampler 3\n");
    [self reconstruirImg:luminancia_sub->data width:round(width*scale) height:round(height*scale)];
    
    free( (void *) image );
    free_image_double(luminancia_sub);
    
    

}


- (void) reconstruirImg: (float*)datadouble width: (int) width height: (int) height {

    printf("width: %d \t height: %d\n",width, height);
    
    unsigned char *result = (unsigned char *) malloc(width * height *sizeof(unsigned char) *4);
    
    // process the image back to rgb
    
    for(int i = 0; i < height * width; i++) {
        
        result[i*4]=datadouble[i];
        result[i*4+1]=datadouble[i];
        result[i*4+2]=datadouble[i];
        result[i*4+3]=0;
    }
    CGDataProviderRef provider  = CGDataProviderCreateWithData(NULL, result, width*height, NULL);
    // set up for CGImage creation
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4* width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    self.vista.image = [UIImage imageWithCGImage:imageRef];
    
   
    CGColorSpaceRelease(colorSpaceRef);
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
