//
//  Isgl3dViewController.m
//  demo05
//
//  Created by Pablo Flores Guridi on 17/07/12.
//  Copyright 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#import "Isgl3dViewController.h"
#import "isgl3d.h"
//#import "simple.h"

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
@synthesize liberar = _liberar;
@synthesize finAvCapture = _finAvCapture;
//para DIBUJAR
claseDibujar *cgvista;


/*Variables para la imagen*/
unsigned char* pixels;
size_t width;
size_t height;
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
double rotacion[9];
double traslacion[3];
bool bandera;

/*Variables para el Coplanar*/
int NumberOfPoints=36;  
long int i;
double **object, f=460.43; /*f: focal length en pixels*/

//double **imagePts;
double **coplMatrix;
double Rot1[3][3],Trans1[3],Rot2[3][3],Trans2[3], Matriz[4][4];
//modern coplanar requiere double** en lugar de [][]
double **Rotmodern;                                 ///modern coplanar
double center[2]={144,146};           ///modern coplanar

/*Variables auxiliares*/
double **imagePointsCambiados;

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
        
        /*Obtenemos los pixeles como unsigned char en pixeles*/
        pixels = (unsigned char *)[data bytes];
    }
    
    /*El procesamiento se hace en otro hilo de ejecucion*/
    
    self.videoView.image = [UIImage imageWithCGImage:ref scale:1.0 orientation:UIImageOrientationRight];
    
    [self.videoView setNeedsDisplay];
    
    CGImageRelease(ref);
    
}

- (void) procesamiento
{
    while(1){
        
        
        if(pixels!=nil)
        {
            bandera = true;
            
            // NSLog(@"Procesando!\n");
            
            /******************PROCESAMIENTO********************************************/
            /***************************************************************************/
            /*Esto es para solucionar el problema de memoria*/
            free(luminancia);
            
            /*Obtengo la imagen en nivel de grises en luminancia*/
            luminancia = rgb2gray(pixels,width,height,d);
            bandera = false;
            
            if (self.liberar==true) {
                
                //la bandera liberar se agrega para poder destruir el Isgl3dViewController
                //en la navegacion de la apliacion. Si no se pone esta bandera se corre el riesgo de querer entrar a la apliacion por 2da vez y querer hacer un free de algo que no se hizo malloc y trancar el Isgl3dViewController
                free(list);
                free(listFiltrada);
                // free(esquinas);
                free(imagePoints);
            }  
            
            
            listSize =0;
            listFiltradaSize =0;
            
            /************************************************LSD*/
            
            /*Se corre el LSD*/	
            
            list = lsd(&listSize, luminancia, width, height );
            
            /************************************************FILTRADO*/
            
            /*Filtrado de segmentos detectados por el LSD */	
            listFiltrada = filterSegments(&listFiltradaSize , &listSize ,list, distance_thr);
            //    esquinas = getMarkerCorners(&listFiltradaSize, listFiltrada);
            
            /************************************************CORRESPONDENCIAS*/
            /*Correspondencias entre marcador real y puntos detectados*/
            imagePoints = findPointCorrespondances(&listFiltradaSize, listFiltrada);  
            
            
            
            imagePointsCambiados = imagePoints;
            if (listFiltradaSize == 36)
            {
                imagePointsCambiados=(double **)malloc(listFiltradaSize* sizeof(double *));
                for (int i=0;i<listFiltradaSize;i++){
                    imagePointsCambiados[i]=(double *)malloc(2 * sizeof(double));
                }
                
                for (int k=0;k<listFiltradaSize;k++)
                {
                    imagePointsCambiados[k][0]=imagePoints[k][1]-141.53333;
                    imagePointsCambiados[k][1]=imagePoints[k][0]-134.55233;
                }
                
            }
            
            printf("Tamano: %d\n", listSize);
            printf("Tamano filtrada: %d\n", listFiltradaSize);
            
            /*Para este punto tenemos las esquinas (x,y) en "imagePoints" ordenadas en forma correspondiente con el marcador real. La cantidad de esquinas se supone que coincide con la cantidad de segmentos detectados.*/
            /*La hipótesis de trabajo es que detecto todos los segmentos.*/
            
            
            printf("Problema1\n");
            Composit(NumberOfPoints,imagePointsCambiados,object,f,Rot1,Trans1);
            printf("Problema2\n");
            
            /************************************************POSIT COPLANAR*/
            /*Algoritmo de estimacion de pose en base a esquinas en forma correspondiente*/
            /*Este algoritmo devuelve una matriz de rotacion y un vector de rotacion*/
            //
            //            Composit(NumberOfPoints,imagePointsCambiados,object,f,Rot1,Trans1);
            //            free(imagePointsCambiados);
            // ModernPosit( NumberOfPoints,imagePoints, object,f,center, Rotmodern, Trans1); 
            
            
            //                printf("\nPARAMETROS DEL COPLANAR:R y T: \n");
            //                printf("\nRotacion: \n");
            //                printf("%f\t %f\t %f\n",Rot1[0][0],Rot1[0][1],Rot1[0][2]);
            //                printf("%f\t %f\t %f\n",Rot1[1][0],Rot1[1][1],Rot1[1][2]);
            //                printf("%f\t %f\t %f\n",Rot1[2][0],Rot1[2][1],Rot1[2][2]);
            //                printf("Traslacion: \n");
            //                printf("%f\t %f\t %f\n",Trans1[0],Trans1[1],Trans1[2]);
            //                
            
            
            /************************************************SPINCALC*/
            /*En base a una matriz de rotacion calcula los angulos de Euler que se corresponden*/
            
            
            
            /*Ahora asignamos la rotacion y la traslacion a las propiedades rotacion y traslacion del view*/
            
            if(Rot1[0][0]<INFINITY)
            {
                
                //                printf("Solo declaro\n");
                //                double rotacion[9];
                //                printf("declare\n");
                
                rotacion[0]=Rot1[0][0];
                rotacion[1]=Rot1[0][1];
                rotacion[2]=Rot1[0][2];
                rotacion[3]=Rot1[1][0];
                rotacion[4]=Rot1[1][1];
                rotacion[5]=Rot1[1][2];
                rotacion[6]=Rot1[2][0];
                rotacion[7]=Rot1[2][1];
                rotacion[8]=Rot1[2][2];
                
                self.isgl3DView.eulerAngles = euler(Rot1);
                
                [self.isgl3DView setRotacion:rotacion];
            }
            
            // MODERN COPLANAR POSIT
            //            if(Rotmodern[0][0]<INFINITY)
            //            {
            //                
            //                printf("Solo declaro\n");
            //                double rotacion[9];
            //                printf("declare\n");
            //                
            //                rotacion[0]=Rotmodern[0][0];
            //                rotacion[1]=Rotmodern[0][1];
            //                rotacion[2]=Rotmodern[0][2];
            //                rotacion[3]=Rotmodern[1][0];
            //                rotacion[4]=Rotmodern[1][1];
            //                rotacion[5]=Rotmodern[1][2];
            //                rotacion[6]=Rotmodern[2][0];
            //                rotacion[7]=Rotmodern[2][1];
            //                rotacion[8]=Rotmodern[2][2];
            //                
            //                [self.isgl3DView setRotacion:rotacion];
            //            }
            //
            
            
            
            if (Trans1[0] < INFINITY)
            {
                printf("Nueva traslacion\n");
                [self.isgl3DView setTraslacion:Trans1];
                
            }
            //self.traslacion = traslacion;
            
            /*************FIN DEL PROCESAMIENTO********************************************/
            /******************************************************************************/
            bandera = false;
        }
        
    }
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
    
    int a=182, b=98;
    
    /* MODELO MARCADOR */
    
    // Marcador 0
    
    object[0][0]=17.5;
    object[0][1]=17.5;
    object[0][2]=0.0;
    
    object[1][0]=17.5;   
    object[1][1]=-17.5;
    object[1][2]=0.0;
    
    object[2][0]=-17.5;
    object[2][1]=-17.5;
    object[2][2]=0.0;
    
    object[3][0]=-17.5; 
    object[3][1]=17.5;   
    object[3][2]=0.0;
    
    object[4][0]=32.5;
    object[4][1]=32.5;
    object[4][2]=0.0;
    
    object[5][0]=32.5;
    object[5][1]=-32.5;
    object[5][2]=0.0;
    
    object[6][0]=-32.5;
    object[6][1]=-32.5;
    object[6][2]=0.0;
    
    object[7][0]=-32.5;
    object[7][1]=32.5;
    object[7][2]=0.0;
    
    object[8][0]=47.5;
    object[8][1]=47.5;
    object[8][2]=0.0;
    
    object[9][0]=47.5;   
    object[9][1]=-47.5;
    object[9][2]=0.0;
    
    object[10][0]=-47.5;
    object[10][1]=-47.5;
    object[10][2]=0.0;
    
    object[11][0]=-47.5; 
    object[11][1]=47.5;  
    object[11][2]=0.0;
    
    // Marcador 1 
    
    object[12][0]=17.5+a;
    object[12][1]=17.5;
    object[12][2]=0.0;
    
    object[13][0]=17.5+a;   
    object[13][1]=-17.5;
    object[13][2]=0.0;
    
    object[14][0]=-17.5+a;
    object[14][1]=-17.5;
    object[14][2]=0.0;
    
    object[15][0]=-17.5+a; 
    object[15][1]=17.5;   
    object[15][2]=0.0;
    
    object[16][0]=32.5+a;
    object[16][1]=32.5;
    object[16][2]=0.0;
    
    object[17][0]=32.5+a;
    object[17][1]=-32.5;
    object[17][2]=0.0;
    
    object[18][0]=-32.5+a;
    object[18][1]=-32.5;
    object[18][2]=0.0;
    
    object[19][0]=-32.5+a;
    object[19][1]=32.5;
    object[19][2]=0.0;
    
    object[20][0]=47.5+a;
    object[20][1]=47.5;
    object[20][2]=0.0;
    
    object[21][0]=47.5+a;   
    object[21][1]=-47.5;
    object[21][2]=0.0;
    
    object[22][0]=-47.5+a;
    object[22][1]=-47.5;
    object[22][2]=0.0;
    
    object[23][0]=-47.5+a; 
    object[23][1]=47.5;  
    object[23][2]=0.0;    
    
    // Marcador 2 
    
    object[24][0]=17.5;
    object[24][1]=17.5+b;
    object[24][2]=0.0;
    
    object[25][0]=17.5;   
    object[25][1]=-17.5+b;
    object[25][2]=0.0;
    
    object[26][0]=-17.5;
    object[26][1]=-17.5+b;
    object[26][2]=0.0;
    
    object[27][0]=-17.5; 
    object[27][1]=17.5+b;   
    object[27][2]=0.0;
    
    object[28][0]=32.5;
    object[28][1]=32.5+b;
    object[28][2]=0.0;
    
    object[29][0]=32.5;
    object[29][1]=-32.5+b;
    object[29][2]=0.0;
    
    object[30][0]=-32.5;
    object[30][1]=-32.5+b;
    object[30][2]=0.0;
    
    object[31][0]=-32.5;
    object[31][1]=32.5+b;
    object[31][2]=0.0;
    
    object[32][0]=47.5;
    object[32][1]=47.5+b;
    object[32][2]=0.0;
    
    object[33][0]=47.5;   
    object[33][1]=-47.5+b;
    object[33][2]=0.0;
    
    object[34][0]=-47.5;
    object[34][1]=-47.5+b;
    object[34][2]=0.0;
    
    object[35][0]=-47.5; 
    object[35][1]=47.5+b;  
    object[35][2]=0.0;
    
    
    
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
    if (_finAvCapture==false) {
        [self.session startRunning]; 
    }else {
        [self.session stopRunning];
    }
    
    
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


