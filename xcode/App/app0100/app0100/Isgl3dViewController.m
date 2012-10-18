//
//  Isgl3dViewController.m
//  casoUso0101
//
//  Created by Pablo Flores Guridi on 01/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Isgl3dViewController.h"
#import "isgl3d.h"
#import "claseDibujar.h"


@interface Isgl3dViewController()



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


/*para DIBUJAR*/
claseDibujar *cgvista;
float **reproyectados;
float aux[3];

/*Variables para la imagen*/
unsigned char* pixels;
size_t width;
size_t height;
size_t bitsPerComponent;
size_t bitsPerPixel;
float* luminancia;
int d;
int dProcesamiento;
UIImage *imagen;

/*Variables para el procesamiento*/
float* list;
float*listFiltrada;
//float** esquinas;

float **imagePoints,**imagePointsCrop;
int listSize;
int listFiltradaSize;
float distance_thr=36;
float rotacion[9];
float traslacion[3];
int errorMarkerDetection; //Codigo de error del findPointCorrespondence

/*Variables para el Coplanar*/
int NumberOfPoints=36;
int cantPtosDetectados;
long int i;
float **object, **objectCrop, f=615; //con 630 andaba bien /*f: focal length en pixels*/
bool PosJuani=true;

//modern coplanar requiere float** en lugar de [][]
float *Tras;
float **Rotmodern;                                 ///modern coplanar
float center[2]={240, 180};           ///modern coplanar
bool verbose;
float* luminancia;
float* angles1;
float* angles2;

/* LSD parameters */
float sigma_scale = 0.6; /* Sigma for Gaussian filter is computed as
                          sigma = sigma_scale/scale.                    */
float quant = 2.0;       /* Bound to the quantization error on the
                          gradient norm.                                */
float ang_th = 22.5;     /* Gradient angle tolerance in degrees.           */
float log_eps = 0.0;     /* Detection threshold: -log10(NFA) > log_eps     */
float density_th = 0.7;  /* Minimal density of region points in rectangle. */
int n_bins = 1024;        /* Number of bins in pseudo-ordering of gradient
                           modulus.                                       */
/*Up to here */
image_float luminancia_sub;
image_float image;
int cantidad;

/*Kalman variables*/
kalman_state thetaState,psiState,phiState,xState,yState,zState;
bool kalman=true;
bool init=true;
float** measureNoise;
float** processNoise;
float** stateEvolution;
float** measureMatrix;
float** errorMatrix;
float** kalmanGain;
float* states;
kalman_state_3 state;

/* video rotation for App*/
UIImageOrientation orientation;



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
    
  //  NSLog(@"Capture output");
    //self.context=[self context];
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
    
    //orientation=UIImageOrientationUp;
    
    imagen=[[UIImage alloc] initWithCGImage:ref scale:1.0 orientation:orientation];
    
    
    [self performSelectorOnMainThread:@selector(setImage:) withObject: imagen waitUntilDone:NO];
    
    CGImageRelease(ref);
    CVPixelBufferUnlockBaseAddress(pb, 0);
    
    
    [imagen release];
    
    
}

- (void) setImage: (UIImage*) imagen
{
    self.videoView.image = imagen;
    
    
    
    if (cgvista.dealloc==0)
    {
        [cgvista removeFromSuperview];
        cgvista.dealloc=1;
    }
//    /*-------------------------------| Clase dibujar | ----------------------------------*/
//    if ([self.isgl3DView getDibujar])
//    {
//        
//        /*Reproyectamos los puntos*/
//        
//        //        for (int i=0;i<NumberOfPoints;i++)
//        //
//        //        {
//        //
//        //            MAT_DOT_VEC_3X3(aux, rotacion, object[i]);
//        //            VEC_SUM(reproyectados[i],aux,Tras);
//        //
//        //        }
//        
//        // Para terminar bien esto hay que calibrar bien la camara del ipad.
//        
//        /*Reproyectamos los puntos*/
//        
//        cgvista.cantidadSegmentos = listFiltradaSize;
//        cgvista.cantidadEsquinas = listFiltradaSize;
//        
//        cgvista.segmentos = listFiltrada;
//        cgvista.esquinas = imagePoints;
//        
//        [self.videoView addSubview:cgvista];
//        
//        
//        cgvista.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
//        
//        cgvista.bounds=CGRectMake(0, 0, 1024, 768);
//        
//        [cgvista setNeedsDisplay];
//        
//        cgvista.dealloc=0;
//        
//    }
//    /*-------------------------------| Clase dibujar | ----------------------------------*/
    
}




- (void) procesamiento
{
    
    if((pixels[0] != INFINITY)&(height!=0))
    {
        
        
        if (verbose) NSLog(@"Procesando!\n");
        
        /******************PROCESAMIENTO********************************************/
        /***************************************************************************/
        //NSLog(@"rgb2gray in\n");
        /*Se pasa la imagen a nivel de grises*/
        cantidad =width*height;
        for(int pixelNr=0;pixelNr<cantidad;pixelNr++) luminancia[pixelNr] = 0.30*pixels[pixelNr*4+2] + 0.59*pixels[pixelNr*4+1] + 0.11*pixels[pixelNr*4];
        /*Ahora luminancia es la imagen en nivel de grises*/
        //NSLog(@"rgb2gray out\n");
        
        /*Se pasa el filtro gaussiano y se obtiene una imagen de tamano scale*tmn_original*/
        image = new_image_float_ptr( (unsigned int) width, (unsigned int) height, luminancia );
        //        NSLog(@"gaussian_sampler in\n");
        luminancia_sub = gaussian_sampler(image, 0.5, sigma_scale);
        //        NSLog(@"gaussian_sampler out\n");
        
        /*Se corre el LSD a la imagen escalada y filtrada*/
        free(list);
        listSize =0;
       // NSLog(@"LSD in\n");
        list = LineSegmentDetection(&listSize, luminancia_sub->data, luminancia_sub->xsize, luminancia_sub->ysize,2, sigma_scale, quant, ang_th, log_eps, density_th, n_bins, NULL, NULL, NULL);
       // NSLog(@"LSD out\n");
        
        /*Se libera memoria*/
        free( (void *) image );
        free_image_float(luminancia_sub);
        
        
        /*-------------------------------------|FILTRADO|-------------------------------------*/
        free(listFiltrada);
        listFiltradaSize =0;
        /*Filtrado de segmentos detectados por el LSD */
        listFiltrada = filterSegments(&listFiltradaSize , &listSize ,list, distance_thr);
        
        
        /*-------------------------------------|CORRESPONDENCIAS|-------------------------------------*/
        /*Correspondencias entre marcador real y puntos detectados*/
        errorMarkerDetection = findPointCorrespondances(&listFiltradaSize, listFiltrada,imagePoints);
        
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
            
            if (kalman){
                Matrix2Euler(Rotmodern, angles1, angles2);
                if(false){
                    if(init){
                        thetaState = kalman_init(1, 4, 1, angles1[0]);
                        psiState = kalman_init(1, 7, 1, angles1[1]);
                        phiState = kalman_init(1, 0.1, 1, angles1[2]);
                        //                        xState = kalman_init(1, 8, 1, Tras[0]);
                        //                        yState = kalman_init(1, 8, 1, Tras[1]);
                        //                        zState = kalman_init(1, 8, 1, Tras[2]);
                        init=false;
                    }
                    kalman_update(&thetaState, angles1[0]);
                    kalman_update(&psiState, angles1[1]);
                    kalman_update(&phiState, angles1[2]);
                    //                     kalman_update(&xState, Tras[0]);
                    //                     kalman_update(&yState, Tras[1]);
                    //                     kalman_update(&zState, Tras[2]);
                    
                    angles1[0]=thetaState.x;
                    angles1[1]=psiState.x;
                    angles1[2]=phiState.x;
                    //                     Tras[0]=xState.x;
                    //                     Tras[1]=yState.x;
                    //                     Tras[2]=zState.x;
                    
                    
                    
                }
                else{
                    if(init){
                        
                        /* kalman correlacionado */
                        IDENTITY_MATRIX_3X3(stateEvolution);
                        IDENTITY_MATRIX_3X3(measureMatrix);
                        IDENTITY_MATRIX_3X3(processNoise);
                        IDENTITY_MATRIX_3X3(errorMatrix);
                        SCALE_MATRIX_3X3(errorMatrix, 1, errorMatrix);
                        
                        measureNoise[0][0] =4.96249572803608;
                        measureNoise[0][1]=4.31450588099769;
                        measureNoise[0][2]=-0.0459669868120827;
                        measureNoise[1][0]=4.31450588099769;
                        measureNoise[1][1]=7.02354899298729;
                        measureNoise[1][2]=-0.0748919339531972;
                        measureNoise[2][0]=-0.0459669868120827;
                        measureNoise[2][1]=-0.0748919339531972;
                        measureNoise[2][2]=0.00106230567668207;
                        //                        measureNoise[0][0]=1;
                        //                        measureNoise[0][1]=0;
                        //                        measureNoise[0][2]=0;
                        //                        measureNoise[1][0]=0;
                        //                        measureNoise[1][1]=1;
                        //                        measureNoise[1][2]=0;
                        //                        measureNoise[2][0]=0;
                        //                        measureNoise[2][1]=0;
                        //                        measureNoise[2][2]=1;
                        SCALE_MATRIX_3X3(measureNoise, 2, measureNoise);
                        
                        state = kalman_init_3x3(processNoise,measureNoise, errorMatrix,kalmanGain,angles1);
                        
                        xState = kalman_init(1, 0.2, 1, Tras[0]);
                        yState = kalman_init(1, 0.2, 1, Tras[1]);
                        zState = kalman_init(1, 0.2, 1, Tras[2]);
                        
                        
                        init=false;
                    }
                    /* kalman correlacionado */
                    kalman_update_3x3(&state, angles1, stateEvolution, measureMatrix);
                    
                    kalman_update(&xState, Tras[0]);
                    kalman_update(&yState, Tras[1]);
                    kalman_update(&zState, Tras[2]);
                    
                    Tras[0]=xState.x;
                    Tras[1]=yState.x;
                    Tras[2]=zState.x;
                    
                    //                    VEC_PRINT(angles1);
                    //                    VEC_PRINT(Tras);
                    
                }
                Euler2Matrix(angles1, Rotmodern);
                if(verbose) printf("psi1: %g\ntheta1: %g\nphi1: %g\n",angles1[0],angles1[1],angles1[2]);
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
        
        /*-------------------------------------|POSIT COPLANAR|-------------------------------------*/
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
        
        
        
        if (verbose){
            printf("\nPrimera solucion\n");
            printf("psi1: %g\ntheta1: %g\nphi1: %g\n",angles1[0],angles1[1],angles1[2]);
            printf("\nSegunda solicion\n");
            printf("psi2: %g\ntheta2: %g\nphi2: %g\n",angles2[0],angles2[1],angles2[2]);
        }
        
        [self.isgl3DView setRotacion:rotacion];
        [self.isgl3DView setTraslacion:Tras];
        
        
        /*-------------------------------------|FIN DEL PROCESAMIENTO|-------------------------------------*/
        
    }
    
}

- (void) reservarMemoria {
    
    if (verbose) printf("Reservamos memoria");
    
    free(pixels);
    free(Rotmodern);
    free(Tras);
    free(angles1);
    free(angles2);
    
    /*Reservamos memoria*/
    Rotmodern=(float**)malloc(3*sizeof(float*));
    for (i=0; i<3;i++) Rotmodern[i]=(float*)malloc(3*sizeof(float));
    
    Tras=(float*)malloc(3*sizeof(float));
    
    angles1=(float*)malloc(3*sizeof(float));
    angles2=(float*)malloc(3*sizeof(float));
    
    object=(float **)malloc(NumberOfPoints * sizeof(float *));
    for (i=0;i<NumberOfPoints;i++) object[i]=(float *)malloc(3 * sizeof(float));
    
    reproyectados=(float **)malloc(NumberOfPoints * sizeof(float *));
    for (i=0;i<NumberOfPoints;i++) reproyectados[i]=(float *)malloc(3 * sizeof(float));
    
    objectCrop=(float **)malloc(NumberOfPoints * sizeof(float *));
    for (i=0;i<NumberOfPoints;i++) objectCrop[i]=(float *)malloc(3 * sizeof(float));
    
    imagePointsCrop=(float **)malloc(NumberOfPoints * sizeof(float *));
    for (i=0;i<NumberOfPoints;i++) imagePointsCrop[i]=(float *)malloc(2 * sizeof(float));
    
    imagePoints=(float **)malloc(NumberOfPoints * sizeof(float *));
    for (i=0;i<NumberOfPoints;i++) imagePoints[i]=(float *)malloc(2 * sizeof(float));
    
    //    coplMatrix=(float **)malloc(3 * sizeof(float *));
    //    for (i=0;i<3;i++) coplMatrix[i]=(float *)malloc(NumberOfPoints * sizeof(float));
    
    pixels = (unsigned char*) malloc(360*480*4*sizeof(unsigned char));
    for (int i=0;i<360*480*4;i++)
    {
        pixels[i]= INFINITY;
    }
    
    luminancia = (float *) malloc(360*480*sizeof(float));
    cgvista=[[claseDibujar alloc] initWithFrame:self.videoView.frame];
    
    /* READ MARKER MODEL */
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MarkerQR" ofType:@"txt"];
    
    FILE *filePuntos;
    
    filePuntos=fopen(filePath.UTF8String, "r");
    
    if (filePuntos==NULL)
    {
        printf("Could not open file!");
    }
    else {
        
        for(int i=0; i<36; i++)fscanf(filePuntos,"%f %f %f\n",&object[i][0],&object[i][1],&object[i][2]);
    }
    fclose(filePuntos);
    
    /* END MARKER */
    
    
    /*Reservo memoria para kalman*/
    
    measureNoise=(float **)malloc(3 * sizeof(float *));
    for (int k=0;k<3;k++) measureNoise[k]=(float *)malloc(3 * sizeof(float));
    
    processNoise=(float **)malloc(3 * sizeof(float *));
    for (int k=0;k<3;k++) processNoise[k]=(float *)malloc(3 * sizeof(float));
    
    stateEvolution=(float **)malloc(3 * sizeof(float *));
    for (int k=0;k<3;k++) stateEvolution[k]=(float *)malloc(3 * sizeof(float));
    
    measureMatrix=(float **)malloc(3 * sizeof(float *));
    for (int k=0;k<3;k++) measureMatrix[k]=(float *)malloc(3 * sizeof(float));
    
    errorMatrix=(float **)malloc(3 * sizeof(float *));
    for (int k=0;k<3;k++) errorMatrix[k]=(float *)malloc(3 * sizeof(float));
    
    kalmanGain=(float **)malloc(3 * sizeof(float *));
    for (int k=0;k<3;k++) kalmanGain[k]=(float *)malloc(3 * sizeof(float));
    
    states=(float *)malloc(3 * sizeof(float));
    
    
    
    
}

-(BOOL)shouldAutorotate
{
    NSLog(@"shouldAutorotate ISGL");
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"supportedInterfaceOrientations ISGL");
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    NSLog(@"preferredInterfaceOrientationForPresentation ISGL");
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"SHOULD Autorotate ISGL");
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
	
    NSLog(@"WILL Autorotate ISGL");
	if ([Isgl3dDirector sharedInstance].autoRotationStrategy == Isgl3dAutoRotationByUIViewController) {
		CGRect screenRect = [[UIScreen mainScreen] bounds];
		CGRect rect = CGRectZero;
		NSLog(@"BY UIVIEWCONTROLLER");
        
		if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			rect = screenRect;
            NSLog(@"PORTRAIT");
//            self.videoView.frame=CGRectMake(0, 0,screenRect.size.width, screenRect.size.height );
//            orientation=UIImageOrientationRight;
            
		} else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
//            self.videoView.frame=CGRectMake(0, 0,screenRect.size.height, screenRect.size.width );
//            orientation=UIImageOrientationUp;
            NSLog(@"LANDSCAPE");
            
        }
		
		UIView * glView = [Isgl3dDirector sharedInstance].openGLView;
		float contentScaleFactor = [Isgl3dDirector sharedInstance].contentScaleFactor;
        
		if (contentScaleFactor != 1) {
			rect.size.width *= contentScaleFactor;
			rect.size.height *= contentScaleFactor;
            NSLog(@"contentScaleFactor!=1");
		}
		glView.frame = rect;
	}
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"WILL APPEAR ISGL");
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"WILL DIS ISGL");
    [super viewWillDisappear:animated];
}


-(void)createVideoWindow:(UIWindow *)window{
    
    
    ///self.viewController=(Isgl3dViewController*)appDelegate.viewController;
    
    UIImageView* vistaImg = [[UIImageView alloc] init];
    //  vistaImg.image = [UIImage imageNamed:@"Calibrar10.jpeg"];
    
    
    //vistaImg.transform =CGAffineTransformMake(0, 1, -1, 0, 0, 0);
    /* Se ajusta la pantalla*/
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds;
    
    printf("%f \t %f\n",fullScreenRect.size.width, fullScreenRect.size.height);
    [vistaImg setCenter:CGPointMake(fullScreenRect.size.width/2, fullScreenRect.size.height/2)];
    [vistaImg setBounds:fullScreenRect];
    
    
    
    //    [vistaImg setNeedsDisplay];
    
    
    [window addSubview:vistaImg];
	[window sendSubviewToBack:vistaImg];
    
    
    self.videoView = vistaImg;
    
    
	// Make the opengl view transparent
	[Isgl3dDirector sharedInstance].openGLView.backgroundColor = [UIColor clearColor];
	[Isgl3dDirector sharedInstance].openGLView.opaque = NO;
    
    
    
    
}


- (void) viewDidLoad{
    
    if (verbose) printf("viewDidLoad\n");
    
    printf("VIEWDIDLOAD ISGL\n");
    
    orientation=UIImageOrientationUp;
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
   // [self reservarMemoria];
    
    /*Mandamos el procesamiento a otro thread*/
    //dispatch_queue_t processQueue = dispatch_queue_create("procesador", NULL);
    //dispatch_async(processQueue, ^{[self.session startRunning];});
    /*Comenzamos a capturar*/
    
    //NSLog(@"FORMATOS POSIBLES %@",self.frameOutput.availableVideoCVPixelFormatTypes);
    
    [self.session startRunning];
    
}

//- (void) viewDidUnload {
//	[super viewDidUnload];
//}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


