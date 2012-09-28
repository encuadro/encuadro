//
//  Isgl3dViewController.m
//  oneThread
//
//  Created by Pablo Flores Guridi on 13/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
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
@synthesize theMovie = _theMovie;

//para DIBUJAR
//claseDibujar *cgvista;

double **imagePoints3; //para hacer la CGAffineTransform

double *h;

/*Variables para la imagen*/
unsigned char* pixels;
size_t width;
size_t height;
size_t bitsPerComponent;
size_t bitsPerPixel;
double* luminancia;
int d;
int dProcesamiento;
UIImage *imagen;

/*Variables para el procesamiento*/
double* list;
double*listFiltrada;
//double** esquinas;

double **imagePoints,**imagePointsCrop;
int listSize;
int listFiltradaSize;
float distance_thr=20;
double rotacion[9];
double traslacion[3];
int errorMarkerDetection; //Codigo de error del findPointCorrespondence

/*Variables para el Coplanar*/
int NumberOfPoints=36;
int cantPtosDetectados;
long int i;
double **object, **objectCrop, f=615; //con 630 andaba bien /*f: focal length en pixels*/
bool PosJuani=true;

//modern coplanar requiere double** en lugar de [][]
double *Tras;
double **Rotmodern;                                 ///modern coplanar
double center[2]={240, 180};           ///modern coplanar
bool verbose;
double* luminancia;

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
    
    //NSLog(@"Capture output");
    
    CVPixelBufferRef pb  = CMSampleBufferGetImageBuffer(sampleBuffer);
    //CVPixelBufferRetain(pb);
    CIImage* ciImage = [CIImage imageWithCVPixelBuffer:pb];
    CGImageRef ref = [self.context createCGImage:ciImage fromRect:ciImage.extent];
    
    
    /*Obtengo algunas catacteristicas de la imagen de interes*/
    width = CGImageGetWidth(ref);
    height = CGImageGetHeight(ref);
    bitsPerComponent     = CGImageGetBitsPerComponent(ref);
    bitsPerPixel         = CGImageGetBitsPerPixel(ref);
    d= bitsPerPixel/bitsPerComponent;
    
    
    CVPixelBufferLockBaseAddress(pb, 0);
    pixels = (unsigned char *)CVPixelBufferGetBaseAddress(pb);
    
    [self procesamiento];
    
    imagen=[[UIImage alloc] initWithCGImage:ref scale:1.0 orientation:UIImageOrientationRight];
    
    [self performSelectorOnMainThread:@selector(setImage:) withObject: imagen waitUntilDone:NO];
    
    CGImageRelease(ref);
    CVPixelBufferUnlockBaseAddress(pb, 0);
    //CVPixelBufferRelease(pb);
    [imagen release];
    
    
}

- (void) setImage: (UIImage*) imagen
{
    self.videoView.image = imagen;
    
}

- (void) procesamiento
{
    
    if((luminancia != NULL)&(height!=0))
    {
        
        
        if (verbose) NSLog(@"Procesando!\n");
        
        /******************PROCESAMIENTO********************************************/
        /***************************************************************************/
        /*Esto es para solucionar el problema de memoria*/
        //free(luminancia);
        
        /*Obtengo la imagen en nivel de grises en luminancia*/
        if (verbose) NSLog(@"rgb2gray in\n");
        
        rgb2gray(luminancia, pixels,width,height,d);
        if (verbose) NSLog(@"rgb2gray out\n");
        
        free(list);
        free(listFiltrada);
        
        //            free(imagePoints);
        
        listSize =0;
        listFiltradaSize =0;
        
        /************************************************LSD*/
        
        /*Se corre el LSD*/
        if (verbose) NSLog(@"LSD in\n");
        list = lsd_scale(&listSize, luminancia, width, height,0.50);
        
        if (verbose) NSLog(@"LSD out\n");
        /************************************************FILTRADO*/
        
        
        /*Filtrado de segmentos detectados por el LSD */
        listFiltrada = filterSegments(&listFiltradaSize , &listSize ,list, distance_thr);
        //    esquinas = getMarkerCorners(&listFiltradaSize, listFiltrada);
        
        /************************************************CORRESPONDENCIAS*/
        /*Correspondencias entre marcador real y puntos detectados*/
        errorMarkerDetection = findPointCorrespondances(&listFiltradaSize, listFiltrada,imagePoints);


        
        solveHomographie(imagePoints, imagePoints3, h);
        
        [self performSelectorOnMainThread:@selector(actualizarBounds:) withObject: theMovie waitUntilDone:NO];

        
        
        if (verbose){
            printf("Tamano: %d\n", listSize);
            printf("Tamano filtrada: %d\n", listFiltradaSize);
        }
        
        
        if (errorMarkerDetection>=0) {
            
            cantPtosDetectados=getCropLists(imagePoints, object, imagePointsCrop, objectCrop);
            
            /* eleccion de algoritmo de pose*/
            if (PosJuani){
                CoplanarPosit(cantPtosDetectados, imagePointsCrop, objectCrop, f, center, Rotmodern, Tras);
                //                    for(int i=0;i<3;i++){
                //                        for(int j=0;j<3;j++) Rota[i][j]=Rotmodern[i][j];
                //                        Transa[i]=Tras[i];
                //                    }
                
            }
            else {
                for (int k=0;k<36;k++)
                {
                    imagePointsCrop[k][0]=imagePointsCrop[k][0]-center[0];
                    imagePointsCrop[k][1]=imagePointsCrop[k][1]-center[1];
                }
                Composit(cantPtosDetectados,imagePointsCrop,objectCrop,f,Rotmodern,Tras);
            }
        }
        
        if (verbose){
            printf("\nPARAMETROS DEL COPLANAR:R y T: \n");
            printf("\nRotacion: \n");
            printf("%f\t %f\t %f\n",Rotmodern[0][0],Rotmodern[0][1],Rotmodern[0][2]);
            printf("%f\t %f\t %f\n",Rotmodern[1][0],Rotmodern[1][1],Rotmodern[1][2]);
            printf("%f\t %f\t %f\n",Rotmodern[2][0],Rotmodern[2][1],Rotmodern[2][2]);
            printf("Traslacion: \n");
            printf("%f\t %f\t %f\n",Tras[0],Tras[1],Tras[2]);
        }
        
        /************************************************POSIT COPLANAR*/
        /*Algoritmo de estimacion de pose en base a esquinas en forma correspondiente*/
        /*Este algoritmo devuelve una matriz de rotacion y un vector de rotacion*/
        //
        //            Composit(NumberOfPoints,imagePointsCambiados,object,f,Rot1,Trans1);
        //            free(imagePointsCambiados);
        // ModernPosit( NumberOfPoints,imagePoints, object,f,center, Rotmodern, Trans1);
        
        
        
        
        /************************************************SPINCALC*/
        /*En base a una matriz de rotacion calcula los angulos de Euler que se corresponden*/
        
        
        
        /*Ahora asignamos la rotacion y la traslacion a las propiedades rotacion y traslacion del view*/
        
        
        rotacion[0]=Rotmodern[0][0];
        rotacion[1]=Rotmodern[0][1];
        rotacion[2]=Rotmodern[0][2];
        rotacion[3]=Rotmodern[1][0];
        rotacion[4]=Rotmodern[1][1];
        rotacion[5]=Rotmodern[1][2];
        rotacion[6]=Rotmodern[2][0];
        rotacion[7]=Rotmodern[2][1];
        rotacion[8]=Rotmodern[2][2];
        
        
        double angles1[3],angles2[3];
        Matrix2Euler(Rotmodern,angles1,angles2);
        //            self.isgl3DView.eulerAngles = angles1;
        
        if (verbose){
            printf("\nPrimera solucion\n");
            printf("psi1: %g\ntheta1: %g\nphi1: %g\n",angles1[0],angles1[1],angles1[2]);
            printf("\nSegunda solicion\n");
            printf("psi2: %g\ntheta2: %g\nphi2: %g\n",angles2[0],angles2[1],angles2[2]);
        }
        
        [self.isgl3DView setRotacion:rotacion];
        [self.isgl3DView setTraslacion:Tras];
        [self performSelectorOnMainThread:@selector(actualizarBounds:) withObject: theMovie waitUntilDone:NO];
        
        //self.traslacion = traslacion;
        
        /*************FIN DEL PROCESAMIENTO********************************************/
        /******************************************************************************/
        //    bandera = false;
        
    }
    
}
-(void) actualizarBounds:(MPMoviePlayerController *) theMovieAux{
    bool CGaffine=true;
    
    if (CGaffine) {
        theMovie.view.frame = CGRectMake(10, 10, 50, 50);
        //  CGAffineTransform currentMatrix =  theMovie.view.transform;
        //  CGAffineTransform translate = CGAffineTransformTranslate(theMovie.view.transform,h[2],h[5]);
        //theMovie.view.transform = CGAffineTransformTranslate(theMovie.view.transform,h[2],h[5]); 
        CGAffineTransform affine = CGAffineTransformMake(h[0], h[3], h[1], h[4], h[2], h[5]);
        CGAffineTransform rotation = CGAffineTransformMake(h[0], h[3], h[1], h[4], 0, 0);
        CGAffineTransform translation = CGAffineTransformMake(1, 0 , 0, 1, h[2], h[5]);
        
        //CGAffineTransform translate = CGAffineTransformMakeTranslation(200, 50);
        // theMovie.view.transform=CGAffineTransformConcat(currentMatrix, newMatrix);
        //     theMovie.view.transform=newMatrix;
        //    theMovie.view.transform=translate;
        theMovie.view.transform=rotation;
        // theMovie.view.transform = CGAffineTransformTranslate(rotation,h[2],h[5]);
        
        CGFloat x,y;
        x=imagePoints[5][0]+imagePoints[6][0];
        y=imagePoints[5][1]+imagePoints[6][1];
        //  theMovie.view.frame.origin=CGPointMake(x,y);
        [theMovie.view setCenter:CGPointMake(x/2, y/2)];
        printf("imagePoints[5][0] %f",imagePoints[5][0]);
        printf("imagePoints[6][0] %f",imagePoints[6][0]);
        // theMovie.view.transform=newMatrix;
        // theMovie.view.layer.transform=CATransform3DMakeAffineTransform(newMatrix);
        //theMovie.view.frame=CGRectApplyAffineTransform(CGRectMake(10, 10, 50, 50), newMatrix);

    }else {
        CALayer *layer = theMovie.view.layer;
        
        layer.frame = CGRectMake(0, 0,480,320);
        layer.anchorPoint = CGPointMake(0.0,0.0);
        layer.zPosition = 0;
        
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        
        rotationAndPerspectiveTransform.m11 = h[0];
        rotationAndPerspectiveTransform.m12 = h[3];
        rotationAndPerspectiveTransform.m14 = h[6];
        rotationAndPerspectiveTransform.m21 = h[1];
        rotationAndPerspectiveTransform.m22 = h[4];
        rotationAndPerspectiveTransform.m24 = h[7];
        rotationAndPerspectiveTransform.m41 = h[2];
        rotationAndPerspectiveTransform.m42 = h[5];
        rotationAndPerspectiveTransform.m44 = 1;
    }   
   


}
-(void) desplegarVideo{

    
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"marker_lo" ofType:@"mov"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    theMovie = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    //Place it in subview, else it won’t work
    theMovie.view.frame = CGRectMake(10, 10, 50, 50);
    //theMovie.fullscreen=YES;
    theMovie.controlStyle=MPMovieControlStyleNone;
    //theMovie.view.contentMode=UIViewContentModeScaleToFill;
    theMovie.scalingMode=MPMovieScalingModeFill;
    
    [self.view addSubview:theMovie.view];
    //Resize window – a bit more practical
    UIWindow *moviePlayerWindow = nil;
    moviePlayerWindow = [[UIApplication sharedApplication] keyWindow];
    //[moviePlayerWindow setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    // Play the movie.
    [theMovie play];

}

- (void) reservarMemoria {
    
    if (verbose) printf("Reservamos memoria");
    
    free(pixels);
    free(Rotmodern);
    free(Tras);
    
    /*Reservamos memoria*/
    Rotmodern=(double**)malloc(3*sizeof(double*));
    for (i=0; i<3;i++) Rotmodern[i]=(double*)malloc(3*sizeof(double));
    
    Tras=(double*)malloc(3*sizeof(double));
    
    object=(double **)malloc(NumberOfPoints * sizeof(double *));
    for (i=0;i<NumberOfPoints;i++) object[i]=(double *)malloc(3 * sizeof(double));
    
    objectCrop=(double **)malloc(NumberOfPoints * sizeof(double *));
    for (i=0;i<NumberOfPoints;i++) objectCrop[i]=(double *)malloc(3 * sizeof(double));
    
    imagePointsCrop=(double **)malloc(NumberOfPoints * sizeof(double *));
    for (i=0;i<NumberOfPoints;i++) imagePointsCrop[i]=(double *)malloc(2 * sizeof(double));
    
    imagePoints=(double **)malloc(NumberOfPoints * sizeof(double *));
    for (i=0;i<NumberOfPoints;i++) imagePoints[i]=(double *)malloc(2 * sizeof(double));
    
    //imagePoints3 reserva 4 puntos para hacer la CGAffineTransform
    imagePoints3=(double **)malloc(4 * sizeof(double *));
    for (i=0;i<4;i++) imagePoints3[i]=(double *)malloc(2 * sizeof(double));
    
    imagePoints3[0][0]=60;
    imagePoints3[0][1]=60;
    
    imagePoints3[1][0]=60;
    imagePoints3[1][1]=10;
    
    imagePoints3[2][0]=10;
    imagePoints3[2][1]=10;
    
    imagePoints3[3][0]=10;
    imagePoints3[3][1]=60;
    
    
    
    h=(double *)malloc(8 * sizeof(double));
   // for (i=0;i<8;i++) h[i]=(double *)malloc(sizeof(double));
    
    
    //    coplMatrix=(double **)malloc(3 * sizeof(double *));
    //    for (i=0;i<3;i++) coplMatrix[i]=(double *)malloc(NumberOfPoints * sizeof(double));
    
    pixels = (unsigned char*) malloc(480*360*4*sizeof(unsigned char));
    for (int i=0;i<360*480*4;i++)
    {
        pixels[i]= INFINITY;
    }
    
    luminancia = (double *) malloc(480*360*sizeof(double));
    
    
    
    /* BEGIN MARKER */
    //QlSet0
    object[0][0] = 15;
    object[0][1] = 15;
    object[0][2] = 0;
    object[1][0] = 15;
    object[1][1] = -15;
    object[1][2] = 0;
    object[2][0] = -15;
    object[2][1] = -15;
    object[2][2] = 0;
    object[3][0] = -15;
    object[3][1] = 15;
    object[3][2] = 0;
    object[4][0] = 30;
    object[4][1] = 30;
    object[4][2] = 0;
    object[5][0] = 30;
    object[5][1] = -30;
    object[5][2] = 0;
    object[6][0] = -30;
    object[6][1] = -30;
    object[6][2] = 0;
    object[7][0] = -30;
    object[7][1] = 30;
    object[7][2] = 0;
    object[8][0] = 45;
    object[8][1] = 45;
    object[8][2] = 0;
    object[9][0] = 45;
    object[9][1] = -45;
    object[9][2] = 0;
    object[10][0] = -45;
    object[10][1] = -45;
    object[10][2] = 0;
    object[11][0] = -45;
    object[11][1] = 45;
    object[11][2] = 0;
    //QlSet1
    object[12][0] = 205;
    object[12][1] = 15;
    object[12][2] = 0;
    object[13][0] = 205;
    object[13][1] = -15;
    object[13][2] = 0;
    object[14][0] = 175;
    object[14][1] = -15;
    object[14][2] = 0;
    object[15][0] = 175;
    object[15][1] = 15;
    object[15][2] = 0;
    object[16][0] = 220;
    object[16][1] = 30;
    object[16][2] = 0;
    object[17][0] = 220;
    object[17][1] = -30;
    object[17][2] = 0;
    object[18][0] = 160;
    object[18][1] = -30;
    object[18][2] = 0;
    object[19][0] = 160;
    object[19][1] = 30;
    object[19][2] = 0;
    object[20][0] = 235;
    object[20][1] = 45;
    object[20][2] = 0;
    object[21][0] = 235;
    object[21][1] = -45;
    object[21][2] = 0;
    object[22][0] = 145;
    object[22][1] = -45;
    object[22][2] = 0;
    object[23][0] = 145;
    object[23][1] = 45;
    object[23][2] = 0;
    //QlSet2
    object[24][0] = 15;
    object[24][1] = 115;
    object[24][2] = 0;
    object[25][0] = 15;
    object[25][1] = 85;
    object[25][2] = 0;
    object[26][0] = -15;
    object[26][1] = 85;
    object[26][2] = 0;
    object[27][0] = -15;
    object[27][1] = 115;
    object[27][2] = 0;
    object[28][0] = 30;
    object[28][1] = 130;
    object[28][2] = 0;
    object[29][0] = 30;
    object[29][1] = 70;
    object[29][2] = 0;
    object[30][0] = -30;
    object[30][1] = 70;
    object[30][2] = 0;
    object[31][0] = -30;
    object[31][1] = 130;
    object[31][2] = 0;
    object[32][0] = 45;
    object[32][1] = 145;
    object[32][2] = 0;
    object[33][0] = 45;
    object[33][1] = 55;
    object[33][2] = 0;
    object[34][0] = -45;
    object[34][1] = 55;
    object[34][2] = 0;
    object[35][0] = -45;
    object[35][1] = 145;
    object[35][2] = 0;
    /* END MARKER*/
    
    
    
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

    
    if (verbose) printf("viewDidLoad\n");
    
    [super viewDidLoad];
    
    /*Creamos y seteamos la captureSession*/
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetMedium;
    
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
    dispatch_queue_t processQueue = dispatch_queue_create("procesador", NULL);
    [self.frameOutput setSampleBufferDelegate:self queue:processQueue];
    dispatch_release(processQueue);
    
    /*Sin esta linea de codigo el context apunta siempre a nil*/
    self.context =  [CIContext contextWithOptions:nil];
    
    //    /*Para probar con el simulador*/
    //    self.videoView.image = [UIImage imageNamed:@"Calibrar10.jpg"];
    [self reservarMemoria];
    
    /*Mandamos el procesamiento a otro thread*/
    //dispatch_queue_t processQueue = dispatch_queue_create("procesador", NULL);
    //dispatch_async(processQueue, ^{[self.session startRunning];});
    /*Comenzamos a capturar*/
    
    //NSLog(@"FORMATOS POSIBLES %@",self.frameOutput.availableVideoCVPixelFormatTypes);
    
    [self.session startRunning];
    [self desplegarVideo];
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


