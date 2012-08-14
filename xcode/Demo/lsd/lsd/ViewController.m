//
//  ViewController.m
//  lsd
//
//  Created by Pablo Flores Guridi on 17/07/12.
//  Copyright (c) 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#import "ViewController.h"
#include "lsd.h" 


@interface ViewController ()

@property(nonatomic, strong) AVCaptureSession* session;
@property(nonatomic, strong) AVCaptureDevice* videoDevice;
@property(nonatomic, strong) AVCaptureInput* videoInput;
@property(nonatomic, strong) AVCaptureVideoDataOutput* frameOutput;
@property(nonatomic, strong) IBOutlet UIImageView* imgView;
@property(nonatomic, strong) CIContext* context;


@end

@implementation ViewController
@synthesize session = _session;
@synthesize videoDevice = _videoDevice;
@synthesize videoInput = _videoIntup;
@synthesize frameOutput = _frameOutput;
@synthesize imgView = _imgView;
@synthesize context = _context;

claseDibujar *cgvista;
int listFiltradaSize;

double* luminancia;
unsigned char* pixels;
size_t width;
size_t height;
size_t bitsPerComponent;
size_t bitsPerPixel; 
size_t bytesPerRow;  
int d;
float distance_thr=16;
double* list;
int listSize;

/*Variables para el Coplanar*/
int NumberOfPoints=36;  
long int i;
double **object;
double f=460.42666; // Para el ipod y para el ipad tambien sirve /*f: focal length en pixels*/
double **coplMatrix;
double Rot1[3][3],Trans1[3],Rot2[3][3],Trans2[3], Matriz[4][4];
double* objectCamera[36];
//distancia entre marcadores, a segun x (eje largo), b segun y (eje corto)
int a=182.5, b=98;

CVPixelBufferRef pb;
CIImage* ciImage;
CGImageRef ref;
NSData* data;

double MatrizIntrinsic[3][4]={{460.42666,       0,     141.53333,      0},
    {0,           451.47707,  134.55233,      0},
    {0,               0,          1,          0},
};


double* puntos2D[36];
bool bandera, pasandoValores;
struct CGDataProvider* dataProvider;

- (CIContext*) context
{
    if (!_context)
    {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    printf("captureOutput\n");
    
    CVPixelBufferRef pb  = CMSampleBufferGetImageBuffer(sampleBuffer);  
    CIImage* ciImage = [CIImage imageWithCVPixelBuffer:pb];
    CGImageRef ref = [self.context createCGImage:ciImage fromRect:ciImage.extent];
    NSData* data = (__bridge NSData *) CGDataProviderCopyData(CGImageGetDataProvider(ref));
   
  
    width = CGImageGetWidth(ref);
    height = CGImageGetHeight(ref);
    bitsPerComponent     = CGImageGetBitsPerComponent(ref);
    bitsPerPixel         = CGImageGetBitsPerPixel(ref);
    //bytesPerRow          = CGImageGetBytesPerRow(ref);
    d= bitsPerPixel/bitsPerComponent;
    
    
       
//    if (bandera==false)
//    {
//  
//        free(pixels); // Esto es medio cerdo
//        pixels = (unsigned char *)[data bytes];
//        /*Aca tenemos los píxeles de la imagen*/
//    }    

    if (bandera==false)
    {
        
    printf("pixles");   
    free(pixels); // Esto es medio cerdo
    pixels = (unsigned char *)[data bytes];
    /*Aca tenemos los píxeles de la imagen*/

        
    }
   
    pasandoValores = true;
    
    [self.imgView addSubview:cgvista];
    
    pasandoValores = false;
    
    cgvista.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
    /*Para el iPhone:*/
    cgvista.bounds=CGRectMake(0, 0, 480, 320); 
    /*Para el iPad:*/
   //cgvista.bounds=CGRectMake(0, 0, 1024, 768); 
    
    self.imgView.image = [UIImage imageWithCGImage:ref scale:1.0 orientation:UIImageOrientationUp];
    
    CGImageRelease(ref); 
    //CGDataProviderRelease(dataProvider);
    
}

-(void) procesamiento{
    

    
    while(1){
        
        
        if(pixels!=nil)
        {
            bandera = true;
            free(luminancia);
            printf("Luminancia in\n");
            printf("width: %zu\n",width);
            printf("height: %zu\n",height);
            
            luminancia = rgb2gray(pixels,width,height,d);
            /*Luminancia es la señal en niveles de grises. pixeles es la señal en RGB y permanece intacta.*/
            printf("luminancia out\n");
            
            bandera = false; /*Ahora ya se puede variar el valor de pixels*/
 
            
            /*run LSD*/
            
            /*Definimos variables locales, asi no afectan valores globales*/
           
            
            free(list);
            
            listSize =0;
            listFiltradaSize =0;
            printf("LSD in\n");
            list = lsd(&listSize, luminancia, width, height );
            printf("LSD out\n");
         
            [cgvista removeFromSuperview];
            cgvista=[[claseDibujar alloc] initWithFrame:self.imgView.frame];
                
            cgvista.segmentos = list;
                
            cgvista.cantidadSegmentos = listSize;
                
            /*Para el iPhone::*/
            cgvista.bounds=CGRectMake(0, 0, 480, 320); 
            /*Para el iPad:*/
            //cgvista.bounds=CGRectMake(0, 0, 1024, 768); 
            
            
        }
        
    }
    
}

-(void) reservarMemoria
{
    pixels = (unsigned char*) malloc(4*288*352*sizeof(unsigned char));

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPreset352x288;
    
    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil]; 
    
    self.frameOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.frameOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt: kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    [self.session addInput:self.videoInput];
    [self.session addOutput:self.frameOutput];
    
    [self.frameOutput setSampleBufferDelegate:self  queue:dispatch_get_main_queue()];
    
    dispatch_queue_t processQueue = dispatch_queue_create("procesador", NULL);
    dispatch_async(processQueue, ^{[self procesamiento];});
    [self.session startRunning]; 
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

