//
//  Isgl3dViewController.m
//  isgl3DYAVFoundation
//
//  Created by Pablo Flores Guridi on 12/05/12.
//  Copyright 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#import "Isgl3dViewController.h"
#import "isgl3d.h"


@interface Isgl3dViewController()

@property(nonatomic, retain) AVCaptureSession * session;
@property(nonatomic, retain) AVCaptureDevice * videoDevice;
@property(nonatomic, retain) AVCaptureDeviceInput * videoInput;
@property(nonatomic, retain) AVCaptureVideoDataOutput * frameOutput;
@property(nonatomic, retain) CIContext* context; 

//@property(nonatomic, retain) CIImage* ciImage;
//@property(nonatomic, retain) CVPixelBufferRef pb;
//@property(nonatomic, retain) CGImageRef ref;

@end

@implementation Isgl3dViewController

@synthesize session = _session;
@synthesize videoDevice = _videoDevice;
@synthesize videoInput = _videoInput;
@synthesize frameOutput = _frameOutput;
@synthesize context = _context;
@synthesize videoView = _videoView;
@synthesize isgl3DView = _isgl3DView;

/*La traslacion y la rotacion cuadro a cuadro*/
@synthesize rotacion = _rotacion;
@synthesize traslacion = _traslacion;

/*Variables para la imagen*/
unsigned char* pixels;
unsigned char* pixelsProcesamiento;
size_t width;
size_t height;
size_t widthProcesamiento;
size_t heightProcesamiento;
size_t bitsPerComponent;
size_t bitsPerPixel; 
double* luminancia;
int d;
int dProcesamiento;

/*Variables para el procesamiento*/
double* list;
double*listFiltrada;
//double** esquinas;
double **imagePoints;
int listSize;
int listFiltradaSize;
float distance_thr=16;
double rotacion[3];
double traslacion[3];
bool bandera;

/*Variables para el Coplanar*/
int NumberOfPoints=36;  
long int i;
double **object, f=448;/*f: focal length en pixels*/
//double **imagePts;
double **coplMatrix;
double Rot1[3][3],Trans1[3],Rot2[3][3],Trans2[3];
double *nbsol;


- (CIContext* ) context
{
    if(!_context)
    {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

- (void) dealloc {    
    [super dealloc];
}


-(void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    //  NSLog(time(tiempo));
    //printf("captureOutput\n");
   // NSLog(@"Empieza");
    
    CVPixelBufferRef pb  = CMSampleBufferGetImageBuffer(sampleBuffer);  
    CIImage* ciImage = [CIImage imageWithCVPixelBuffer:pb];
    CGImageRef ref = [self.context createCGImage:ciImage fromRect:ciImage.extent];
    NSData* data = (NSData *) CGDataProviderCopyData(CGImageGetDataProvider(ref));
    
    /*Obtengo algunas catacteristicas de la imagen de interes*/
    width = CGImageGetWidth(ref);
    height = CGImageGetHeight(ref);
    bitsPerComponent     = CGImageGetBitsPerComponent(ref);
    bitsPerPixel         = CGImageGetBitsPerPixel(ref);
    d= bitsPerPixel/bitsPerComponent;
    
    if (bandera == false)
    {
    /*Esto es para solucionar el problema de memoria*/
    free(pixels); 
    //printf("Bandera\n");
    /*Obtenemos los pixeles como unsigned char en pixeles*/
    pixels = (unsigned char *)[data bytes];
    }

    
       
    /*El procesamiento se hace en otro hilo de ejecucion*/

    

    
    //[self.isgl3DView actualizar:rotacion traslacion:traslacion];
    
    self.videoView.image = [UIImage imageWithCGImage:ref scale:1.0 orientation:UIImageOrientationRight];
    
    [self.videoView setNeedsDisplay];
    
    CGImageRelease(ref);
    //NSLog(@"Termina");
    
    
}

- (void) procesamiento
{
    while(1){
        
   
    if(pixels!=nil)
    {
        bandera = true;
  //  pixelsProcesamiento = (unsigned char*)malloc(width*height*d*sizeof(unsigned char));
    //    pixelsProcesamiento = pixels;
       // NSLog(@"Procesando!\n");
    /*Esto es para solucionar el problema de memoria*/
    free(luminancia);

    widthProcesamiento = width;
    heightProcesamiento = height;
    dProcesamiento = d;
        /******************PROCESAMIENTO********************************************/
    /***************************************************************************/
    
    
    /*Obtengo la imagen en nivel de grises en luminancia*/
    luminancia = rgb2gray(pixels,width,height,d);
        bandera = false;
    free(list);
    free(listFiltrada);
    // free(esquinas);
    free(imagePoints);
    
    listSize =0;
    listFiltradaSize =0;
    
    /************************************************LSD*/
    
    /*Se corre el LSD*/	
    
    list = lsd(&listSize, luminancia, width, height );
    
    /************************************************FILTRADO*/
    
    /*Filtrado de segmentos detectados por el LSD */	
    listFiltrada = filterSegments(&listFiltradaSize , &listSize ,list, distance_thr);
    //    esquinas = getMarkerCorners(&listFiltradaSize, listFiltrada);
//        printf("Tamano: %d\n", listSize);
//        printf("Tamano filtrada: %d\n", listFiltradaSize);
    /************************************************CORRESPONDENCIAS*/
    /*Correspondencias entre marcador real y puntos detectados*/
    imagePoints = findPointCorrespondances(&listFiltradaSize, listFiltrada);  
    
    
    /*Para este punto tenemos las esquinas (x,y) en "imagePoints" ordenadas en forma correspondiente con el marcador real. La cantidad de esquinas se supone que coincide con la cantidad de segmentos detectados.*/
    /*La hipótesis de trabajo es que detecto todos los segmentos.*/
    
    
    /************************************************POSIT COPLANAR*/
    /*Algoritmo de estimacion de pose en base a esquinas en forma correspondiente*/
    /*Este algoritmo devuelve una matriz de rotacion y un vector de rotacion*/
    
    Composit(NumberOfPoints,imagePoints,object,f,Rot1,Trans1);    
//    
//    printf("\nPARAMETROS DEL COPLANAR:R y T: \n");
//    printf("\nRotacion: \n");
//    printf("%f\t %f\t %f\n",Rot1[0][0],Rot1[0][1],Rot1[0][2]);
//    printf("%f\t %f\t %f\n",Rot1[1][0],Rot1[1][1],Rot1[1][2]);
//    printf("%f\t %f\t %f\n",Rot1[2][0],Rot1[2][1],Rot1[2][2]);
//    printf("Traslacion: \n");
//    printf("%f\t %f\t %f\n",Trans1[0],Trans1[1],Trans1[2]);
//    
//    
    
    /************************************************SPINCALC*/
    /*En base a una matriz de rotacion calcula los angulos de Euler que se corresponden*/
    
    
    
    
        
        rotacion[0] = 0;
        rotacion[1] = 0;
        rotacion[2] = 0;
        
        traslacion[0] = Trans1[0];
        traslacion[1] = Trans1[1];
        traslacion[2] = Trans1[2];
        
        
        /*Ahora asignamos la rotacion y la traslacion a las propiedades rotacion y traslacion del view*/
        if (rotacion[0]< INFINITY)
        {
        [self.isgl3DView setRotacion: rotacion];
        }
        if (traslacion[0] < INFINITY)
        {
            [self.isgl3DView setTraslacion:traslacion];
        }
        //self.traslacion = traslacion;
    
    
    
    /*************FIN DEL PROCESAMIENTO********************************************/
    /******************************************************************************/
      bandera = false;
    }

    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
	isgl3dAllowedAutoRotations allowedAutoRotations = [Isgl3dDirector sharedInstance].allowedAutoRotations;
	if ([Isgl3dDirector sharedInstance].autoRotationStrategy == Isgl3dAutoRotationNone) {
		return NO;
        
	} else if ([Isgl3dDirector sharedInstance].autoRotationStrategy == Isgl3dAutoRotationByIsgl3dDirector) {
		
		if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft && allowedAutoRotations != Isgl3dAllowedAutoRotationsPortraitOnly) {
			[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeRight;
            
		} else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight && allowedAutoRotations != Isgl3dAllowedAutoRotationsPortraitOnly) {
			[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;
            
		} else if (interfaceOrientation == UIInterfaceOrientationPortrait && allowedAutoRotations != Isgl3dAllowedAutoRotationsLandscapeOnly) {
			[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationPortrait;
            
		} else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown && allowedAutoRotations != Isgl3dAllowedAutoRotationsLandscapeOnly) {
			[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationPortraitUpsideDown;
		}
        
		// Return true only for portrait
		return  (interfaceOrientation == UIInterfaceOrientationPortrait);
        
	} else if ([Isgl3dDirector sharedInstance].autoRotationStrategy == Isgl3dAutoRotationByUIViewController) {
		if (UIInterfaceOrientationIsLandscape(interfaceOrientation) && allowedAutoRotations != Isgl3dAllowedAutoRotationsPortraitOnly) {
			return YES;
			
		} else if (UIInterfaceOrientationIsPortrait(interfaceOrientation) && allowedAutoRotations != Isgl3dAllowedAutoRotationsLandscapeOnly) {
			return YES;
			
		} else {
			return NO;
		}
		
	} else {
		NSLog(@"Isgl3dViewController:: ERROR : Unknown auto rotation strategy of Isgl3dDirector.");
		return NO;
	}
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	if ([Isgl3dDirector sharedInstance].autoRotationStrategy == Isgl3dAutoRotationByUIViewController) {
		CGRect screenRect = [[UIScreen mainScreen] bounds];
		CGRect rect = CGRectZero;
		
		if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {		
			rect = screenRect;
            
		} else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
		}
		
		UIView * glView = [Isgl3dDirector sharedInstance].openGLView;
		float contentScaleFactor = [Isgl3dDirector sharedInstance].contentScaleFactor;
        
		if (contentScaleFactor != 1) {
			rect.size.width *= contentScaleFactor;
			rect.size.height *= contentScaleFactor;
		}
		glView.frame = rect;
	}	
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) viewDidLoad{
    
    printf("viewDidLoad\n");
    
    
    [super viewDidLoad];    
    
    /*Creamos y seteamos la captureSession*/
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPreset352x288;
    
    /*Creamos al videoDevice*/
    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    /*Creamos al videoInput*/
    self.videoInput  = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil];
    
    /*Creamos y seteamos al frameOutpt*/
    self.frameOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    self.frameOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id) kCVPixelBufferPixelFormatTypeKey];
    
    /*Ahora conectamos todos los objetos*/
    /*Primero le agregamos a la sesion el videoInput y el videoOutput*/
    
    [self.session addInput: self.videoInput];
    [self.session addOutput: self.frameOutput];
    
    /*Le decimos al método que nuestro sampleBufferDelegate (al que se le pasan los pixeles por el metodo captureOutput) es el mismo*/
    [self.frameOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    /*Sin esta linea de codigo el context apunta siempre a nil*/
    self.context =  [CIContext contextWithOptions:nil];
    
    //    /*Para probar con el simulador*/
    //    self.videoView.image = [UIImage imageNamed:@"Calibrar10.jpg"];
    [self reservarMemoria];
    /*Mandamos el procesamiento a otro thread*/
    dispatch_queue_t processQueue = dispatch_queue_create("procesador", NULL);
    dispatch_async(processQueue, ^{[self procesamiento];});
    /*Comenzamos a capturar*/
    [self.session startRunning]; 
    
}

- (void) reservarMemoria {
    
    printf("Reservamos memoria");
    free(object);
    free(coplMatrix);
    
    
    /*Reservamos memoria*/
    object=(double **)malloc(NumberOfPoints * sizeof(double *));
    for (i=0;i<NumberOfPoints;i++) object[i]=(double *)malloc(3 * sizeof(double));
    
    
    coplMatrix=(double **)malloc(3 * sizeof(double *));
    for (i=0;i<3;i++) coplMatrix[i]=(double *)malloc(NumberOfPoints * sizeof(double));
    
    
    /* Modelo marcador */
    int a = 10;
    
    // Marcador 1
    
    object[0][0]=0.0*a;
    object[0][1]=0.0*a;
    object[0][2]=0.0*a;
    
    object[1][0]=0.0*a;   
    object[1][1]=9.5*a;
    object[1][2]=0.0*a;
    
    object[2][0]=9.5*a;
    object[2][1]=9.5*a;
    object[2][2]=0.0*a;
    
    object[3][0]=9.5*a; 
    object[3][1]=0.0*a;   
    object[3][2]=0.0*a;
    
    object[4][0]=1.5*a;
    object[4][1]=1.5*a;
    object[4][2]=0.0*a;
    
    object[5][0]=1.5*a;
    object[5][1]=8.0*a;
    object[5][2]=0.0*a;
    
    object[6][0]=8.0*a;
    object[6][1]=8.0*a;
    object[6][2]=0.0*a;
    
    object[7][0]=8.0*a;
    object[7][1]=1.5*a;
    object[7][2]=0.0*a;
    
    object[8][0]=3.0*a;
    object[8][1]=3.0*a;
    object[8][2]=0.0*a;
    
    object[9][0]=3.0*a;   
    object[9][1]=6.5*a;
    object[9][2]=0.0*a;
    
    object[10][0]=6.5*a;
    object[10][1]=6.5*a;
    object[10][2]=0.0*a;
    
    object[11][0]=6.5*a; 
    object[11][1]=0.0*a;  
    object[11][2]=0.0*a;
    
    // Marcador 2
    
    object[12][0]=10.5*a;
    object[12][1]=0.0*a;
    object[12][2]=0.0*a;
    
    object[13][0]=10.5*a;
    object[13][1]=9.5*a;
    object[13][2]=0.0*a;
    
    object[14][0]=20.0*a;
    object[14][1]=9.5*a;
    object[14][2]=0.0*a;
    
    object[15][0]=20.0*a;
    object[15][1]=0.0*a;
    object[15][2]=0.0*a;
    
    object[16][0]=12.0*a;
    object[16][1]=1.5*a;
    object[16][2]=0.0*a;
    
    object[17][0]=12.0*a;   
    object[17][1]=8.0*a;
    object[17][2]=0.0*a;
    
    object[18][0]=18.5*a;
    object[18][1]=8.0*a;
    object[18][2]=0.0*a;
    
    object[19][0]=18.5*a; 
    object[19][1]=1.5*a;   
    object[19][2]=0.0*a;
    
    object[20][0]=13.5*a;
    object[20][1]=3.0*a;
    object[20][2]=0.0*a;
    
    object[21][0]=13.5*a;
    object[21][1]=6.5*a;
    object[21][2]=0.0*a;
    
    object[22][0]=17.0*a;
    object[22][1]=6.5*a;
    object[22][2]=0.0*a;
    
    object[23][0]=17.0*a;
    object[23][1]=3.0*a;
    object[23][2]=0.0*a;
    
    // Marcador3
    
    object[24][0]=0.0*a;
    object[24][1]=19.0*a;
    object[24][2]=0.0*a;
    
    object[25][0]=0.0*a;   
    object[25][1]=28.5*a;
    object[25][2]=0.0*a;
    
    object[26][0]=9.5*a;
    object[26][1]=28.5*a;
    object[26][2]=0.0*a;
    
    object[27][0]=9.5*a;
    object[27][1]=19.0*a;   
    object[27][2]=0.0*a;
    
    object[28][0]=1.5*a;
    object[28][1]=20.5*a;
    object[28][2]=0.0*a;
    
    object[29][0]=1.5*a;
    object[29][1]=27.0*a;
    object[29][2]=0.0*a;
    
    object[30][0]=8.0*a;
    object[30][1]=27.0*a;
    object[30][2]=0.0*a;
    
    object[31][0]=8.0*a;
    object[31][1]=20.5*a;
    object[31][2]=0.0*a;
    
    object[32][0]=3.0*a;
    object[32][1]=22.0*a;
    object[32][2]=0.0*a;
    
    object[33][0]=3.0*a;
    object[33][1]=25.5*a;
    object[33][2]=0.0*a;
    
    object[34][0]=6.5*a;
    object[34][1]=25.5*a;
    object[34][2]=0.0*a;
    
    object[35][0]=6.5*a;
    object[35][1]=22.0*a;
    object[35][2]=0.0*a;
    
    
    
}
- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


