//
//  HelloWorldView.m
//  casoUso0101
//
//  Created by Pablo Flores Guridi on 01/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"
#import "Isgl3dViewController.h"

/*viewView*/
@implementation videoView


- (id) init {
	
	if ((self = [super init])) {
        
	}
	
	return self;
}



- (void) dealloc {
    
	[super dealloc];
}

@end


/*HelloWorldView*/
@interface HelloWorldView()
@property(nonatomic, retain) Isgl3dNode* cubito1;
@property(nonatomic, retain) Isgl3dMeshNode * ufo;
@end


@implementation HelloWorldView

@synthesize cubito1 = _cubito1;
@synthesize ufo = _ufo;
@synthesize traslacion = _traslacion;
@synthesize Rotacion = _Rotacion;
@synthesize eulerAngles = _eulerAngles;
@synthesize distanciaMarcador = _distanciaMarcador;
@synthesize audioPlayer = _audioPlayer;


float punto3D1[3], punto3D2[3], punto3D3[3], punto3D4[3], puntoModelo3D1[4] = {0,0,-30,1}, puntoModelo3D2[4] = {190,0,-30,1}, puntoModelo3D3[4] = {0,100,-30,1};// puntoModelo3D4[4] = {0,0,-60,1};
/*Si queremos meter cubos*/
//puntoModelo3D2[4] = {187.5,0,35/2,1}, puntoModelo3D3[4] = {0,105,35/2,1},
Isgl3dMatrix4 Matriz;
Isgl3dVector3 angles;
bool verbose;
int cantidadToques;
NSString *estring;



bool corners, segments, reproyected;

- (bool) getSegments
{
    return segments;
}

- (bool) getCorners
{
    return corners;
}

- (bool) getReproyected
{
    return reproyected;
}

- (id) init {
	/*"Si el init del padre anduvo bien..."*/
	if ((self = [super init])) {
        
        
        if (verbose) printf("init del HelloWorldView\n");
        corners=NO;
        segments=NO;
        reproyected=NO;
        
        /* Create a container node as a parent for all scene objects.*/
        _container = [self.scene createNode];
        
        // Create the primitive
		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithTextureFile:@"red_checker.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
        Isgl3dCube* cubeMesh = [Isgl3dCube  meshWithGeometry:60 height:60 depth:60 nx:40 ny:40];
        
        _cubito1 = [_container createNodeWithMesh:cubeMesh andMaterial:material];
        _cubito1.position = iv3(0,0,0);
        
                
        cantidadToques = 0;
        
        _cubito1.interactive =YES;
        [_cubito1 addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];
   
        self.camera.position = iv3(0,0,0.1);
        [self.camera setLookAt:iv3(self.camera.x, self.camera.y,0) ];
        
        /*Seteamos el fov.*/
        self.camera.fov = 34.441;
        
        [self schedule:@selector(tick:)];
	}
	return self;
}

- (void) dealloc {
    
	[super dealloc];
}


- (void) tick:(float)dt {
	// Rotate the text around the y axis
    //NSLog(@"tick\n");
    if (self.traslacion != nil & self.Rotacion!=nil)
    {
        Matriz.sxx = self.Rotacion[0][0];
        Matriz.sxy = self.Rotacion[0][1];
        Matriz.sxz = self.Rotacion[0][2];
        Matriz.tx = self.traslacion[0];
        
        Matriz.syx = self.Rotacion[1][0];
        Matriz.syy = self.Rotacion[1][1];
        Matriz.syz = self.Rotacion[1][2];
        Matriz.ty = self.traslacion[1];
        
        Matriz.szx = self.Rotacion[2][0];
        Matriz.szy = self.Rotacion[2][1];
        Matriz.szz = self.Rotacion[2][2];
        Matriz.tz = self.traslacion[2];
        
        Matriz.swx = 0;
        Matriz.swy = 0;
        Matriz.swz = 0;
        Matriz.tw = 1;
        
        angles = im4ToEulerAngles(&Matriz);
        if (verbose){
            printf("\nisgl3d solucion\n");
            printf("psi1: %f\ntheta1: %f\nphi1: %f\n",angles.x,angles.y,angles.z);
        }
        
        /*project CoplanarPosit*/
        float a[3],b[3];
        b[0]=puntoModelo3D1[0];
        b[1]=puntoModelo3D1[1];
        b[2]=puntoModelo3D1[2];
        MAT_DOT_VEC_3X3(a, self.Rotacion, b);
        VEC_SUM(punto3D1,a,self.traslacion);
        
        /*project CoplanarPosit*/
        b[0]=puntoModelo3D2[0];
        b[1]=puntoModelo3D2[1];
        b[2]=puntoModelo3D2[2];
        MAT_DOT_VEC_3X3(a, self.Rotacion, b);
        VEC_SUM(punto3D2,a,self.traslacion);
        
        /*project CoplanarPosit*/
        b[0]=puntoModelo3D3[0];
        b[1]=puntoModelo3D3[1];
        b[2]=puntoModelo3D3[2];
        MAT_DOT_VEC_3X3(a, self.Rotacion, b);
        VEC_SUM(punto3D3,a,self.traslacion);
        
        if (punto3D1[0] < INFINITY)
        {
            
            _container.position = iv3(punto3D1[0], -punto3D1[1], -punto3D1[2]);
            
            _container.rotationX =0;
            _container.rotationY = 0;
            _container.rotationZ = 0;
            
            [_container roll:-angles.z];
            [_container yaw:-angles.y];
            [_container pitch:angles.x];
            
            
        }
    }
    
}

- (void) objectTouched:(Isgl3dEvent3D *)event {
	
	// Get the object associated with the 3D event.
	Isgl3dNode * object = event.object;
	
	// Create a tween to move the object vertically (0.5s duration, callback to "tweenEnded" on completion).
	[Isgl3dTweener addTween:object withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSNumber numberWithFloat:0.5], TWEEN_DURATION,
                                                   TWEEN_FUNC_EASEOUTSINE, TWEEN_TRANSITION,
                                                   [NSNumber numberWithFloat:object.z + 100], @"z", self, TWEEN_ON_COMPLETE_TARGET,
                                                   @"tweenEnded1:", TWEEN_ON_COMPLETE_SELECTOR,
                                                   nil]];
    
    
}
/*
 * Callback when tween ended
 */
- (void) tweenEnded1:(id)sender {
    Isgl3dNode * object = sender;
	// Create a new tween to move the object back to original position (duration 1.5s).
	[Isgl3dTweener addTween:object withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSNumber numberWithFloat:0.5], TWEEN_DURATION,
                                                   TWEEN_FUNC_EASEINSINE, TWEEN_TRANSITION,
                                                   [NSNumber numberWithFloat:object.z - 100], @"z", self, TWEEN_ON_COMPLETE_TARGET,
                                                   @"tweenAgain1:", TWEEN_ON_COMPLETE_SELECTOR, nil]];
    
}

- (void) tweenAgain1:(id)sender {
    Isgl3dNode * object = sender;
	// Create a new tween to move the object back to original position (duration 1.5s).
	[Isgl3dTweener addTween:object withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSNumber numberWithFloat:0.5], TWEEN_DURATION,
                                                   TWEEN_FUNC_EASEOUTSINE, TWEEN_TRANSITION,
                                                   [NSNumber numberWithFloat:object.z + 80], @"z", self, TWEEN_ON_COMPLETE_TARGET,
                                                   @"tweenEnded2:", TWEEN_ON_COMPLETE_SELECTOR, nil]];
    
}

- (void) tweenEnded2:(id)sender {
    Isgl3dNode * object = sender;
	// Create a new tween to move the object back to original position (duration 1.5s).
	[Isgl3dTweener addTween:object withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSNumber numberWithFloat:0.5], TWEEN_DURATION,
                                                   TWEEN_FUNC_EASEINSINE, TWEEN_TRANSITION,
                                                   [NSNumber numberWithFloat:object.z - 80], @"z", self, TWEEN_ON_COMPLETE_TARGET,
                                                   @"tweenAgain2:", TWEEN_ON_COMPLETE_SELECTOR, nil]];
    
}

- (void) tweenAgain2:(id)sender {
    Isgl3dNode * object = sender;
	// Create a new tween to move the object back to original position (duration 1.5s).
	[Isgl3dTweener addTween:object withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSNumber numberWithFloat:0.5], TWEEN_DURATION,
                                                   TWEEN_FUNC_EASEOUTSINE, TWEEN_TRANSITION,
                                                   [NSNumber numberWithFloat:object.z + 30], @"z", self, TWEEN_ON_COMPLETE_TARGET,
                                                   @"tweenEnded3:", TWEEN_ON_COMPLETE_SELECTOR, nil]];
    
}

- (void) tweenEnded3:(id)sender {
    Isgl3dNode * object = sender;
	// Create a new tween to move the object back to original position (duration 1.5s).
	[Isgl3dTweener addTween:object withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSNumber numberWithFloat:0.5], TWEEN_DURATION,
                                                   TWEEN_FUNC_EASEINSINE, TWEEN_TRANSITION,
                                                   [NSNumber numberWithFloat:object.z - 30], @"z", nil]];
    
    
    
    if (cantidadToques ==0){
        estring=@"arriba_izq.mp3";
        
        
    }
    else if (cantidadToques ==1) {
        estring=@"arriba_der.mp3";
        
        
    }
    else if (cantidadToques ==2) {
        estring=@"abajo.mp3";
        
        
    }
    
    NSURL *url =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],estring]];
    //NSError *error;
    self.audioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.numberOfLoops=0;
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];

    
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    //    if (cantidadToques ==0){_cubito1.position = iv3(-distanciaMarcador[0]/2,-distanciaMarcador[1]/2,0); cantidadToques =1;
    //    }
    //    else if (cantidadToques ==1) {_cubito1.position = iv3(distanciaMarcador[0]/2,distanciaMarcador[1]/2,0); cantidadToques =2;
    //    }
    //    else if (cantidadToques ==2) {_cubito1.position = iv3(distanciaMarcador[0]/2,-distanciaMarcador[1]/2,0); cantidadToques =0;}
    
    if (cantidadToques ==0){_cubito1.position = iv3(190,0,0); cantidadToques =1;
    }
    else if (cantidadToques ==1) {_cubito1.position = iv3(0,-100,0); cantidadToques =2;
    }
    else if (cantidadToques ==2) {_cubito1.position = iv3(0,0,0); cantidadToques =0;}
}






@end

