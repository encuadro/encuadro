//
//  ViewController.m
//  lsd_optimizer
//
//  Created by Pablo Flores Guridi on 10/10/12.
//  Copyright (c) 2012 Pablo Flores Guridi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *vista;

@end

@implementation ViewController

@synthesize vista = _vista;

/*Para levantar la imagen*/
FILE *in = 0 ;
int err = 0;
//VlPgmImage pim;
unsigned char *datachar  = 0;
double *datadouble = 0;
int width;
int height;


/*Para el LSD*/
double* list;
int listSize;

/*para DIBUJAR*/
//claseDibujar *cgvista;

- (void)viewDidLoad
{
    [super viewDidLoad];
	/*Aca levantamos la imagen, la pasamos a nivel de grises y la desplegamos*/
    
    /*-------------------------|PARA CORRER DESDE EL IPAD|-----------------------*/
    UIImage* uiimage = [UIImage imageNamed:@"marker_0007.png"];
    
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
    
    
    datadouble = malloc(width*height*sizeof(double));
    int cantidad =width*height;
    NSLog(@"Entra a rgb2gray\n");
    //rgb2gray(datadouble, rawData, width, height, 4);
    for(int pixelNr=0;pixelNr<cantidad;pixelNr++) datadouble[pixelNr] = 0.30*rawData[pixelNr*4+2] + 0.59*rawData[pixelNr*4+1] + 0.11*rawData[pixelNr*4];
    NSLog(@"Sale de rgb2gray\n");
    
   /*En datadouble tenemos los pixeles de la imagen*/
    
       
    [self reconstruirImg:datadouble width:width height:height];
    
    
    

     //cgvista=[[claseDibujar alloc] initWithFrame:self.vista.frame];

}
- (IBAction)imagen_1:(id)sender {
    
    UIImage* uiimage = [UIImage imageNamed:@"marker_0007.png"];
    
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
    
    
    datadouble = malloc(width*height*sizeof(double));
    int cantidad =width*height;
    NSLog(@"Entra a rgb2gray\n");
    //rgb2gray(datadouble, rawData, width, height, 4);
    for(int pixelNr=0;pixelNr<cantidad;pixelNr++) datadouble[pixelNr] = 0.30*rawData[pixelNr*4+2] + 0.59*rawData[pixelNr*4+1] + 0.11*rawData[pixelNr*4];
    NSLog(@"Sale de rgb2gray\n");
    
    /*En datadouble tenemos los pixeles de la imagen*/
    
    
    [self reconstruirImg:datadouble width:width height:height];
    

}


- (IBAction)imagen_2:(id)sender {
    
    UIImage* uiimage = [UIImage imageNamed:@"zebras.png"];
    
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
    
    
    datadouble = malloc(width*height*sizeof(double));
    int cantidad =width*height;
    NSLog(@"Entra a rgb2gray\n");
    //rgb2gray(datadouble, rawData, width, height, 4);
    for(int pixelNr=0;pixelNr<cantidad;pixelNr++) datadouble[pixelNr] = 0.30*rawData[pixelNr*4+2] + 0.59*rawData[pixelNr*4+1] + 0.11*rawData[pixelNr*4];
    NSLog(@"Sale de rgb2gray\n");
    
    /*En datadouble tenemos los pixeles de la imagen*/
    
    
    [self reconstruirImg:datadouble width:width height:height];
    

}

- (IBAction)lsd_original:(id)sender {
    
    NSLog(@"LSD_original in\n");
    list = lsd(&listSize, datadouble, width, height);
    NSLog(@"LSD_original out\n");
    
    printf("listSize_original: %d\n",listSize);
    
    [self reconstruirImg:datadouble width:width height:height];
    
    free(list);
    
    
    
}
- (IBAction)lsd_optimizado:(id)sender {

    NSLog(@"LSD_encuadro in\n");
    list = lsd_encuadro(&listSize, datadouble, width, height);
    NSLog(@"LSD_encuadro out\n");

    printf("listSize_encuadro: %d\n",listSize);
    
    [self reconstruirImg:datadouble width:width height:height];
    
    free(list);

}



- (void) dibujarSegmentos{

//    [cgvista removeFromSuperview];
// 
//    cgvista.cantidadSegmentos = listSize;
//    cgvista.segmentos_lsd = list;
//
//    [self.vista addSubview:cgvista];
//    
//    cgvista.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
//    
//    cgvista.bounds=CGRectMake(0, 0, 1024, 768);
//    
//    [cgvista setNeedsDisplay];




}

- (void) reconstruirImg: (double*)datadouble width: (int) width height: (int) height {
    
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
