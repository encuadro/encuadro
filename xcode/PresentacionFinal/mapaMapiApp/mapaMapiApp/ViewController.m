//
//  ViewController.m
//  mapaMapiApp
//
//  Created by encuadro on 12/11/12.
//  Copyright (c) 2012 encuadro. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize session = _session;
@synthesize videoDevice = _videoDevice;
@synthesize videoInput = _videoInput;
@synthesize frameOutput = _frameOutput;
@synthesize context = _context;
@synthesize videoView = _videoView;

@synthesize imagenViewMaya = _imagenViewMaya;
@synthesize imagenViewAzteca = _imagenViewAzteca;
@synthesize imagenViewZapoteca = _imagenViewZapoteca;
@synthesize audioPlayer = _audioPlayer;


/*Para HOMOGRAFIA*/
float **imagePoints3mayas; //para hacer la CGAffineTransform
float **imagePoints4;
float **imagePoints4Pro;
float **imagePoints3aztecas;
float **imagePoints3video;
float **imagePoints3mayasPro;


float *hmaya;
float *hazteca;
float *hvideo;

/*Sincronismo*/
int timer;


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
float **object, **objectCrop, f=589.141; /*f: focal length en pixels*/
bool PosJuani=true;

//modern coplanar requiere float** en lugar de [][]
float *Tras;
float **Rotmodern;                                 ///modern coplanar
float center[2]={240, 180};           ///modern coplanar
float* luminancia;
float* angles1;
float* angles2;
float**intrinsecos;
float** extrinsecos;
float** poseMatrix;

/* LSD parameters */
float scale_inv = 2; /*scale_inv= 1/scale, scale=0.5*/
float sigma_scale = 0.6; /* Sigma for Gaussian filter is computed as
                          sigma = sigma_scale/scale.                    */
float quant = 2.0;       /* Bound to the quantization error on the
                          gradient norm.                                */
float ang_th = 22.5;     /* Gradient angle tolerance in degrees.           */
float log_eps = 0.0;     /* Detection threshold: -log10(NFA) > log_eps     */
float density_th = 0.0; //0.7  /* Minimal density of region points in rectangle. */
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

- (CIContext* ) context
{
    
    if(!_context)
    {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
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
    
    [self sincronismo];
    
    imagen=[[UIImage alloc] initWithCGImage:ref scale:1.0 orientation:UIImageOrientationUp];
    

    [self performSelectorOnMainThread:@selector(setImage:) withObject: imagen waitUntilDone:NO];
    
    CGImageRelease(ref);
    CVPixelBufferUnlockBaseAddress(pb, 0);
    
    
   // [imagen release];
    
    
}

- (void) setImage: (UIImage*) imagen
{
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds;
    
    
    [self.videoView setCenter:CGPointMake(fullScreenRect.size.height/2, fullScreenRect.size.width/2)];
    [self.videoView setBounds:CGRectMake(0, 0, fullScreenRect.size.height, fullScreenRect.size.width)];
    
    self.videoView.image=imagen;
    
    
    
    
}

-(void)doVolumeFadeMainIn
{
    if (self.audioPlayer.volume < 1.0) {
        self.audioPlayer.volume = self.audioPlayer.volume + 0.1;
        [self performSelector:@selector(doVolumeFadeMainIn) withObject:nil afterDelay:0.2];
        
    } 
}

-(void)doVolumeFadeMainOut
{
    if (self.audioPlayer.volume > 0.1) {
        self.audioPlayer.volume = self.audioPlayer.volume - 0.1;
        [self performSelector:@selector(doVolumeFadeMainOut) withObject:nil afterDelay:0.2];
        
    }else{
        fadeVolOut=false;
    }
}





- (void) sincronismo
{
    // Si 0 < T < 5     ----> SOLO AUDIO
    
    
    // Si 5 < T < 15     ----> SOLO VIDEO
    if ((self.audioPlayer.currentTime>=5)&audioYvideo) {
        
        if (fadeVolOut) {
            [self doVolumeFadeMainOut];
        }else{
            audioYvideo=false;
            NSLog(@"deplegarvideo");
            //[self.audioPlayer stop];
            theMovie.view.hidden=NO;
            [theMovie play];
            //[[MPMusicPlayerController applicationMusicPlayer] setVolume:0];
            self.audioPlayer.volume=0;
        }
        
        
    }
    
    // Si 15 < T < 20     ----> AUDIO + MAYA
    if ((self.audioPlayer.currentTime>=15)&!audioYvideo) {
        [self doVolumeFadeMainIn];
        theMovie.view.hidden=YES;
        [theMovie stop];
        self.audioPlayer.volume=1.0;
        self.imagenViewMaya.hidden=NO;
    }
    
    // Si 20 < T < 25     ----> AUDIO + MAYA + AZTECA
    if ((self.audioPlayer.currentTime>=20)&!audioYvideo) {
        self.imagenViewAzteca.hidden=NO;
    }
    
    // Si 25 < T          ----> AUDIO + MAYA + AZTECA + ZAPOTECA
    if ((self.audioPlayer.currentTime>=25)&!audioYvideo) {
        self.imagenViewZapoteca.hidden=NO;
    }

}

- (void) AVFoundationSettings
{
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
   // dispatch_release(processQueue);
    
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

- (void) procesamiento
{
    
 if((pixels[0] != INFINITY)&(height!=0))
 {
        
        
        // NSLog(@"Procesando!\n");
        
        /*-------------------------------------|PROCESAMIENTO|-------------------------------------*/
        //NSLog(@"rgb2gray in\n");
        /*Se pasa la imagen a nivel de grises*/
        cantidad =width*height;
        for(int pixelNr=0;pixelNr<cantidad;pixelNr++) luminancia[pixelNr] = 0.30*pixels[pixelNr*4+2] + 0.59*pixels[pixelNr*4+1] + 0.11*pixels[pixelNr*4];
        /*Ahora luminancia es la imagen en nivel de grises*/
        //NSLog(@"rgb2gray out\n");
        
        /*Se pasa el filtro gaussiano y se obtiene una imagen de tamano scale*tmn_original*/
        image = new_image_float_ptr( (unsigned int) width, (unsigned int) height, luminancia );
        //NSLog(@"gaussian_sampler in\n");
        luminancia_sub = gaussian_sampler(image, 0.5, sigma_scale);
        //NSLog(@"gaussian_sampler out\n");
        
        /*Se corre el LSD a la imagen escalada y filtrada*/
        free(list);
        listSize =0;
        // NSLog(@"LSD in\n");
        list = LineSegmentDetection(&listSize, luminancia_sub->data, luminancia_sub->xsize, luminancia_sub->ysize,scale_inv, sigma_scale, quant, ang_th, log_eps, density_th, n_bins, NULL, NULL, NULL);
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
        
        
        //        printf("Tamano: %d\n", listSize);
        //        printf("Tamano filtrada: %d\n", listFiltradaSize);
        //
        
 if (!pose) {
         for (int i=0; i<4; i++) {
             
             imagePoints4[i][0]=imagePoints[i+4][0]*wSize/480;
             imagePoints4[i][1]=imagePoints[i+4][1]*hSize/360;
             
             imagePoints4Pro[i][0]=imagePoints[i+4][0]*wSize/480;
             imagePoints4Pro[i][1]=imagePoints[i+4][1]*hSize/360;
             
         }
     
     
         for (int i=4; i<8; i++) {
         
            imagePoints4Pro[i][0]=imagePoints[i+12][0]*wSize/480;
            imagePoints4Pro[i][1]=imagePoints[i+12][1]*hSize/360;
         
         }
     
        for (int i=8; i<12; i++) {
          
            imagePoints4Pro[i][0]=imagePoints[i+20][0]*wSize/480;
            imagePoints4Pro[i][1]=imagePoints[i+20][1]*hSize/360;
         
        }
     
         // solveAffineTransformation(imagePoints, imagePoints3, h);
         solveHomographie(imagePoints4, imagePoints3video, hvideo);
         solveHomographie(imagePoints4, imagePoints3mayas, hmaya);
        // solveHomographiePro(imagePoints4Pro, imagePoints3mayasPro, hmaya);
         solveHomographie(imagePoints4, imagePoints3aztecas, hazteca);
         
         [self performSelectorOnMainThread:@selector(actualizarBounds:) withObject: theMovie waitUntilDone:NO];
 }
     
 else {

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
                // printf("psi1: %g\ntheta1: %g\nphi1: %g\n",angles1[0],angles1[1],angles1[2]);
            }
            
            
            
        }
        
        
        
        
        //            printf("\nPARAMETROS DEL COPLANAR:R y T: \n");
        //            printf("\nRotacion: \n");
        //            printf("%f\t %f\t %f\n",Rotmodern[0][0],Rotmodern[0][1],Rotmodern[0][2]);
        //            printf("%f\t %f\t %f\n",Rotmodern[1][0],Rotmodern[1][1],Rotmodern[1][2]);
        //            printf("%f\t %f\t %f\n",Rotmodern[2][0],Rotmodern[2][1],Rotmodern[2][2]);
        //            printf("Traslacion: \n");
        //            printf("%f\t %f\t %f\n",Tras[0],Tras[1],Tras[2]);
        
        
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
        
        
        
        
        //            printf("\nPrimera solucion\n");
        //            printf("psi1: %g\ntheta1: %g\nphi1: %g\n",angles1[0],angles1[1],angles1[2]);
        //            printf("\nSegunda solicion\n");
        //            printf("psi2: %g\ntheta2: %g\nphi2: %g\n",angles2[0],angles2[1],angles2[2]);
        
//          NO HAY ISGL
//        [self.isgl3DView setRotacion:rotacion];
//        [self.isgl3DView setTraslacion:Tras];
     
     [self performSelectorOnMainThread:@selector(actualizarBounds:) withObject: theMovie waitUntilDone:NO];
        
        /*-------------------------------------|FIN DEL PROCESAMIENTO|-------------------------------------*/
     
 }
 }
    
}
    

-(void) actualizarBounds:(MPMoviePlayerController *) theMovieAux
{
    CALayer *layerVideo = theMovie.view.layer;
    CALayer *layerMaya = self.imagenViewMaya.layer;
    CALayer *layerAzteca = self.imagenViewAzteca.layer;
    CALayer *layerZapoteca = self.imagenViewZapoteca.layer;
    
    CATransform3D rotationAndPerspectiveTransform;
    CATransform3D rotationAndPerspectiveTransformVIDEO = CATransform3DIdentity;
    CATransform3D rotationAndPerspectiveTransformMAYA = CATransform3DIdentity;
    CATransform3D rotationAndPerspectiveTransformAZTECA = CATransform3DIdentity;
    
    if (!pose) {
        

        
        //VIDEO LAYER
        layerVideo.frame = CGRectMake(0*(1024/197),0*(768/148),60*(1024/197),60*(768/148));
        layerVideo.anchorPoint = CGPointMake(0.0,0.0);
        layerVideo.zPosition = 0;
        
        
        //IMAGEN MAYA LAYER
        layerMaya.frame = CGRectMake(0*(1024/197),0*(768/148),60*(1024/197),60*(768/148));
        layerMaya.anchorPoint = CGPointMake(0.0,0.0);
        layerMaya.zPosition = 0;
        
        //IMAGEN AZTECA LAYER
        layerAzteca.frame = CGRectMake(0*(1024/197),0*(768/148),60*(1024/197),60*(768/148));
        layerAzteca.anchorPoint = CGPointMake(0.0,0.0);
        layerAzteca.zPosition = 0;
        
        //IMAGEN ZAPOTECA LAYER
        layerZapoteca.frame = CGRectMake(0*(1024/197),0*(768/148),60*(1024/197),60*(768/148));
        layerZapoteca.anchorPoint = CGPointMake(0.0,0.0);
        layerZapoteca.zPosition = 0;
       
        

        
        
        
        rotationAndPerspectiveTransformVIDEO.m11 = hvideo[0];
        rotationAndPerspectiveTransformVIDEO.m12 = hvideo[3];
        rotationAndPerspectiveTransformVIDEO.m14 = hvideo[6];
        rotationAndPerspectiveTransformVIDEO.m21 = hvideo[1];
        rotationAndPerspectiveTransformVIDEO.m22 = hvideo[4];
        rotationAndPerspectiveTransformVIDEO.m24 = hvideo[7];
        rotationAndPerspectiveTransformVIDEO.m41 = hvideo[2];
        rotationAndPerspectiveTransformVIDEO.m42 = hvideo[5];
        rotationAndPerspectiveTransformVIDEO.m44 = 1;
        
        rotationAndPerspectiveTransformMAYA.m11 = hmaya[0];
        rotationAndPerspectiveTransformMAYA.m12 = hmaya[3];
        rotationAndPerspectiveTransformMAYA.m14 = hmaya[6];
        rotationAndPerspectiveTransformMAYA.m21 = hmaya[1];
        rotationAndPerspectiveTransformMAYA.m22 = hmaya[4];
        rotationAndPerspectiveTransformMAYA.m24 = hmaya[7];
        rotationAndPerspectiveTransformMAYA.m41 = hmaya[2];
        rotationAndPerspectiveTransformMAYA.m42 = hmaya[5];
        rotationAndPerspectiveTransformMAYA.m44 = 1;
        
        rotationAndPerspectiveTransformAZTECA.m11 = hazteca[0];
        rotationAndPerspectiveTransformAZTECA.m12 = hazteca[3];
        rotationAndPerspectiveTransformAZTECA.m14 = hazteca[6];
        rotationAndPerspectiveTransformAZTECA.m21 = hazteca[1];
        rotationAndPerspectiveTransformAZTECA.m22 = hazteca[4];
        rotationAndPerspectiveTransformAZTECA.m24 = hazteca[7];
        rotationAndPerspectiveTransformAZTECA.m41 = hazteca[2];
        rotationAndPerspectiveTransformAZTECA.m42 = hazteca[5];
        rotationAndPerspectiveTransformAZTECA.m44 = 1;
        
        
        
        
        
        
    }else{
    
        //VIDEO LAYER
        layerVideo.frame = CGRectMake(100,100,0.00006,0.000006);
        layerVideo.anchorPoint = CGPointMake(0.0,0.0);
        layerVideo.zPosition = 0;
        
        
//        //IMAGEN MAYA LAYER
//        layerMaya.frame = CGRectMake(0,100,0.6,0.6);
//        layerMaya.anchorPoint = CGPointMake(0.0,0.0);
//        layerMaya.zPosition = 0;
//        
//        //IMAGEN AZTECA LAYER
//        layerAzteca.frame = CGRectMake(190,0,0.6,0.6);
//        layerAzteca.anchorPoint = CGPointMake(0.0,0.0);
//        layerAzteca.zPosition = 0;
//        
//        //IMAGEN ZAPOTECA LAYER
//        layerZapoteca.frame = CGRectMake(0,0,6,6);
//        layerZapoteca.anchorPoint = CGPointMake(0.0,0.0);
//        layerZapoteca.zPosition = 0;
        
        extrinsecos[0][0] =Rotmodern[0][0];
        extrinsecos[0][1] =Rotmodern[0][1];
        extrinsecos[0][2] =Rotmodern[0][2];
        extrinsecos[0][3] =Tras[0];
        
        extrinsecos[1][0] =Rotmodern[1][0];
        extrinsecos[1][1] =Rotmodern[1][1];
        extrinsecos[1][2] =Rotmodern[1][2];
        extrinsecos[1][3] =Tras[1];;
        
        extrinsecos[2][0] =Rotmodern[2][0];
        extrinsecos[2][1] =Rotmodern[2][1];
        extrinsecos[2][2] =Rotmodern[2][2];
        extrinsecos[2][3] =Tras[2];
        
        extrinsecos[3][0] =0;
        extrinsecos[3][1] =0;
        extrinsecos[3][2] =0;
        extrinsecos[3][3] =1;
        
        SCALE_MATRIX_4X4(intrinsecos, wSize/480, intrinsecos);
        MATRIX_PRODUCT_4X4(poseMatrix,intrinsecos,extrinsecos);
        
        rotationAndPerspectiveTransform.m11 = poseMatrix[0][0]/poseMatrix[3][3];
        rotationAndPerspectiveTransform.m12 = poseMatrix[0][1]/poseMatrix[3][3];
        rotationAndPerspectiveTransform.m13 = poseMatrix[0][2]/poseMatrix[3][3];
        rotationAndPerspectiveTransform.m14 = poseMatrix[0][3]/poseMatrix[3][3];
        
        rotationAndPerspectiveTransform.m21 = poseMatrix[1][0]/poseMatrix[3][3];
        rotationAndPerspectiveTransform.m22 = poseMatrix[1][1]/poseMatrix[3][3];
        rotationAndPerspectiveTransform.m23 = poseMatrix[1][2]/poseMatrix[3][3];
        rotationAndPerspectiveTransform.m24 = poseMatrix[1][3]/poseMatrix[3][3];
        
        rotationAndPerspectiveTransform.m31 = poseMatrix[2][0]/poseMatrix[3][3];
        rotationAndPerspectiveTransform.m32 = poseMatrix[2][1]/poseMatrix[3][3];
        rotationAndPerspectiveTransform.m33 = poseMatrix[2][2]/poseMatrix[3][3];
        rotationAndPerspectiveTransform.m34 = poseMatrix[2][3]/poseMatrix[3][3];
        
        rotationAndPerspectiveTransform.m41 = poseMatrix[3][0]/poseMatrix[3][3];
        rotationAndPerspectiveTransform.m42 = poseMatrix[3][1]/poseMatrix[3][3];
        rotationAndPerspectiveTransform.m43 = poseMatrix[3][2]/poseMatrix[3][3];
        rotationAndPerspectiveTransform.m44 = 1;
        
        MAT_PRINT_4X4(poseMatrix);
    
    }
    
    
    theMovie.view.layer.transform=rotationAndPerspectiveTransformVIDEO;
    self.imagenViewMaya.layer.transform=rotationAndPerspectiveTransformMAYA;
    self.imagenViewAzteca.layer.transform=rotationAndPerspectiveTransformAZTECA;

    
    
}
-(void) deplegarImagen{
    
    UIImage *imageMaya = [UIImage imageNamed:@"mayas-temple.jpg"];
    UIImage *imageAzteca = [UIImage imageNamed:@"El-Tajín. ciudad azteca.jpg"];
    UIImage *imageZapoteca = [UIImage imageNamed:@"Urna_funeraria_zapoteca_(M._América_Inv.85-1-127)_01.jpg"];
    
    self.imagenViewMaya.image=imageMaya;
    self.imagenViewAzteca.image=imageAzteca;
    self.imagenViewZapoteca.image=imageZapoteca;
    self.imagenViewMaya.hidden=YES;
    self.imagenViewAzteca.hidden=YES;
    self.imagenViewZapoteca.hidden=YES;

}


-(void) desplegarVideo{
    
    /////////viendo commit
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"videoplayback" ofType:@"mov"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    theMovie = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    //Place it in subview, else it won’t work
    theMovie.view.frame = CGRectMake(0, 0, 60*1024/197,60*768/148);
    //theMovie.fullscreen=YES;
    theMovie.controlStyle=MPMovieControlStyleNone;
    //theMovie.view.contentMode=UIViewContentModeScaleToFill;
    theMovie.scalingMode=MPMovieScalingModeFill;
    
    [self.view addSubview:theMovie.view];
    theMovie.view.hidden=YES;
    //Resize window – a bit more practical
    UIWindow *moviePlayerWindow = nil;
    moviePlayerWindow = [[UIApplication sharedApplication] keyWindow];
    //[moviePlayerWindow setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    // Play the movie.
    //[theMovie play];
    
}

- (void) reservarMemoria {
    
    // printf("Reservamos memoria");
    
    free(pixels);
    free(Rotmodern);
    free(Tras);
    free(angles1);
    free(angles2);
    
    /*Reservamos memoria*/
    Rotmodern=(float**)malloc(3*sizeof(float*));
    for (i=0; i<3;i++) Rotmodern[i]=(float*)malloc(3*sizeof(float));
    
    poseMatrix=(float**)malloc(4*sizeof(float*));
    for (i=0; i<4;i++) poseMatrix[i]=(float*)malloc(4*sizeof(float));
    
    intrinsecos=(float**)malloc(4*sizeof(float*));
    for (i=0; i<4;i++) intrinsecos[i]=(float*)malloc(4*sizeof(float));
    
    intrinsecos[0][0]= 589.141;
    intrinsecos[0][1]= 0;
    intrinsecos[0][2]=240;
    intrinsecos[0][3]= 0;
    
    intrinsecos[1][0]=0;
    intrinsecos[1][1]=580.754;
	intrinsecos[1][2]=180;
    intrinsecos[1][3]=0;
    
    intrinsecos[2][0]=0;
    intrinsecos[2][1]=0;
    intrinsecos[2][2]=1;
    intrinsecos[2][3]=0;
    
    intrinsecos[3][0]=0;
    intrinsecos[3][1]=0;
    intrinsecos[3][2]=0;
    intrinsecos[3][3]=1;
    
    extrinsecos=(float**)malloc(4*sizeof(float*));
    for (i=0; i<4;i++) extrinsecos[i]=(float*)malloc(4*sizeof(float));

    
    Tras=(float*)malloc(3*sizeof(float));
    
    angles1=(float*)malloc(3*sizeof(float));
    angles2=(float*)malloc(3*sizeof(float));
    
    object=(float **)malloc(NumberOfPoints * sizeof(float *));
    for (i=0;i<NumberOfPoints;i++) object[i]=(float *)malloc(3 * sizeof(float));
    
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
    
    
    /*RESERVA MEMORIA PARA HOMOGRAFIA 2D: COMIENZO*/    
    //imagePoints3 reserva 4 puntos para hacer la CGAffineTransform
    imagePoints3video=(float **)malloc(4 * sizeof(float *));
    for (i=0;i<4;i++) imagePoints3video[i]=(float *)malloc(2 * sizeof(float));
    //197×148 mm
    //1024x768 px ipad
    
    imagePoints3video[0][0]=(60)*1024/197;
    imagePoints3video[0][1]=(60)*768/148;
    
    imagePoints3video[1][0]=(60)*1024/197;
    imagePoints3video[1][1]=(0)*768/148;
    
    imagePoints3video[2][0]=(0)*1024/197;
    imagePoints3video[2][1]=(0)*768/148;
    
    imagePoints3video[3][0]=(0)*1024/197;
    imagePoints3video[3][1]=(60)*768/148;
    
    
    imagePoints3mayas=(float **)malloc(4 * sizeof(float *));
    for (i=0;i<4;i++) imagePoints3mayas[i]=(float *)malloc(2 * sizeof(float));
    //197×148 mm
    //1024x768 px ipad
    
    imagePoints3mayas[0][0]=(60-190)*1024/197;
    imagePoints3mayas[0][1]=(60-100)*768/148;
    
    imagePoints3mayas[1][0]=(60-190)*1024/197;
    imagePoints3mayas[1][1]=(0-100)*768/148;
    
    imagePoints3mayas[2][0]=(0-190)*1024/197;
    imagePoints3mayas[2][1]=(0-100)*768/148;
    
    imagePoints3mayas[3][0]=(0-190)*1024/197;
    imagePoints3mayas[3][1]=(60-100)*768/148;
    
    imagePoints3aztecas=(float **)malloc(4 * sizeof(float *));
    for (i=0;i<4;i++) imagePoints3aztecas[i]=(float *)malloc(2 * sizeof(float));
    //197×148 mm
    //1024x768 px ipad
    
    imagePoints3aztecas[0][0]=(60)*1024/197;
    imagePoints3aztecas[0][1]=(60-100)*768/148;
    
    imagePoints3aztecas[1][0]=(60)*1024/197;
    imagePoints3aztecas[1][1]=(0-100)*768/148;
    
    imagePoints3aztecas[2][0]=(0)*1024/197;
    imagePoints3aztecas[2][1]=(0-100)*768/148;
    
    imagePoints3aztecas[3][0]=(0)*1024/197;
    imagePoints3aztecas[3][1]=(60-100)*768/148;
    
    
    //imagePoints4 guarda los puntos detectados con el ajuste de pantalla
    imagePoints4=(float **)malloc(4 * sizeof(float *));
    for (i=0;i<4;i++) imagePoints4[i]=(float *)malloc(2 * sizeof(float));
    
    imagePoints4Pro=(float **)malloc(12 * sizeof(float *));
    for (i=0;i<12;i++) imagePoints4Pro[i]=(float *)malloc(2 * sizeof(float));
    
    
    imagePoints3mayasPro=(float **)malloc(12 * sizeof(float *));
    for (i=0;i<12;i++) imagePoints3mayasPro[i]=(float *)malloc(2 * sizeof(float));
    //197×148 mm
    //1024x768 px ipad
    
    imagePoints3mayasPro[0][0]=(60)*1024/197;
    imagePoints3mayasPro[0][1]=(60)*768/148;
    
    imagePoints3mayasPro[1][0]=(600)*1024/197;
    imagePoints3mayasPro[1][1]=(0)*768/148;
    
    imagePoints3mayasPro[2][0]=(0)*1024/197;
    imagePoints3mayasPro[2][1]=(0)*768/148;
    
    imagePoints3mayasPro[3][0]=(0)*1024/197;
    imagePoints3mayasPro[3][1]=(60)*768/148;
/////
    imagePoints3mayasPro[4][0]=(60)*1024/197;
    imagePoints3mayasPro[4][1]=(60-100)*768/148;
    
    imagePoints3mayasPro[5][0]=(600)*1024/197;
    imagePoints3mayasPro[5][1]=(0-100)*768/148;
    
    imagePoints3mayasPro[6][0]=(0)*1024/197;
    imagePoints3mayasPro[6][1]=(0-100)*768/148;
    
    imagePoints3mayasPro[7][0]=(0)*1024/197;
    imagePoints3mayasPro[7][1]=(60-100)*768/148;
//////
    imagePoints3mayasPro[8][0]=(60-190)*1024/197;
    imagePoints3mayasPro[8][1]=(60)*768/148;
    
    imagePoints3mayasPro[9][0]=(60-190)*1024/197;
    imagePoints3mayasPro[9][1]=(0)*768/148;
    
    imagePoints3mayasPro[10][0]=(0-190)*1024/197;
    imagePoints3mayasPro[10][1]=(0)*768/148;
    
    imagePoints3mayasPro[11][0]=(0-190)*1024/197;
    imagePoints3mayasPro[11][1]=(60)*768/148;
    
  
    hmaya=(float *)malloc(8 * sizeof(float));
    hazteca=(float *)malloc(8 * sizeof(float));
    hvideo=(float *)malloc(8 * sizeof(float));
    /*RESERVA MEMORIA PARA HOMOGRAFIA 2D: FIN*/
    
    
    
    
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



    
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self reservarMemoria];
    fadeVolOut=true;
    audioYvideo=true;
    timer=0;
    UIAlertView *alertWithOkButton;
    alertWithOkButton = [[UIAlertView alloc] initWithTitle:@"Comenzar interacción mapaMAPI!"
                                                   message:@"Presione OK para comenzar" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertWithOkButton show];
    
    pose=false;
    iPhone=false;
    
    if (iPhone) {
        wSize=480;
        hSize=320;
    }else {
        wSize=1024;
        hSize=768;
    }
    [self AVFoundationSettings];
    [self deplegarImagen];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self play];
    [self desplegarVideo];
    

}

- (void) play{
    
    if (click==0) {
        // audioPlayer=nil;
        click=1;
        NSURL *url =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Adele - Rolling In The Deep.mp3", [[NSBundle mainBundle] resourcePath]]];
        NSError *error;
        self.audioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.audioPlayer.numberOfLoops=0;
        [self.audioPlayer play];
        
        //[self.start setTitle:@"Stop" forState:UIControlStateNormal];
        
    }else {
        //audioPlayer=nil;
        [self.audioPlayer stop];
        click=0;
        //[self.start setTitle:@"GUIA" forState:UIControlStateNormal];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
