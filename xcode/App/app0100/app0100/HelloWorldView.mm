//
//  HelloWorldView.m
//  casoUso0101
//
//  Created by Pablo Flores Guridi on 01/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"
#import "Isgl3dViewController.h"
#import "VistaViewController.h"
#include "Isgl3dPODImporter.h"
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
@property(nonatomic, retain) Isgl3dNode* cubito2;
@property(nonatomic, retain) Isgl3dMeshNode * ufo;

@end


@implementation HelloWorldView

@synthesize cubito1 = _cubito1;
@synthesize cubito2 = _cubito2;
@synthesize ufo = _ufo;
@synthesize traslacion = _traslacion;
@synthesize eulerAngles = _eulerAngles;
@synthesize audioPlayer = _audioPlayer;





float punto3D1[3], punto3D2[3], punto3D3[3], punto3D4[3], puntoModelo3D1[4] = {0,0,-30,1}, puntoModelo3D2[4] = {190,0,-30,1}, puntoModelo3D3[4] = {0,100,-30,1};// puntoModelo3D4[4] = {0,0,-60,1};
/*Si queremos meter cubos*/
//puntoModelo3D2[4] = {187.5,0,35/2,1}, puntoModelo3D3[4] = {0,105,35/2,1},
Isgl3dMatrix4 Matriz;
Isgl3dVector3 angles;
float rotacion[3][3];
bool verbose;
int cantidadToques;
NSString *estring;

bool dibujar;
Isgl3dKeyframeMesh * _mesh;
Isgl3dPODImporter * podImporter;
Isgl3dPODImporter * podImporter2;
Isgl3dPODImporter * podImporter3;
Isgl3dPODImporter * podImporter4;
Isgl3dPODImporter * podImporter5;
Isgl3dGLMesh* _artigasMesh;
Isgl3dGLMesh* _artigasMesh2;
Isgl3dGLMesh* _artigasMesh3;
Isgl3dGLMesh* _artigasMesh4;
Isgl3dGLMesh* _artigasMesh5;
Isgl3dNode * node;

int i;
double k;
bool touched;

- (bool) getDibujar
{
    return dibujar;
}



- (void) setRotacion:(float*) rot
{
    rotacion[0][0] = rot[0];
    rotacion[0][1] = rot[1];
    rotacion[0][2] = rot[2];
    
    rotacion[1][0] = rot[3];
    rotacion[1][1] = rot[4];
    rotacion[1][2] = rot[5];
    
    rotacion[2][0] = rot[6];
    rotacion[2][1] = rot[7];
    rotacion[2][2] = rot[8];
    
}
//- (id) init {
//	/*"Si el init del padre anduvo bien..."*/
//	if ((self = [super init])) {
//        
//        
//        if (true) NSLog(@"INIT del HelloWorldView");
//        dibujar=NO;
//        
//        /* Create a container node as a parent for all scene objects.*/
//        _container = [self.scene createNode];
//        
//        // Create the primitive
//		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithTextureFile:@"red_checker.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
//        Isgl3dCube* cubeMesh = [Isgl3dCube  meshWithGeometry:60 height:60 depth:60 nx:40 ny:40];
//        
//        _cubito1 = [_container createNodeWithMesh:cubeMesh andMaterial:material];
//        _cubito1.position = iv3(0,0,0);
//        
//        if (DosCubos) {
//            _cubito2 = [_container createNodeWithMesh:cubeMesh andMaterial:material];
//            _cubito2.position = iv3(190,0,0);
//        }
//        else{
//        //UN CUBO Y modelos POD
//            /*--------------|INTRODUCIMOS EL MODELO|------------------*/
//            
//            Isgl3dPODImporter * podImporter = [Isgl3dPODImporter podImporterWithFile:@"chihuahua.pod"];
//            Isgl3dPODImporter * podImporter2 = [Isgl3dPODImporter podImporterWithFile:@"sofa.pod"];
//            
//            _model = [_container createSkeletonNode];
//            _model2 = [_container createSkeletonNode];
//            
//            _model.scaleX=5;
//            _model.scaleY=5;
//            _model.scaleZ=5;
//            _model.rotationZ = 90;
//            
//            _model2.scaleX=15;
//            _model2.scaleY=15;
//            _model2.scaleZ=15;
//            
//            
//            
//            [podImporter addMeshesToScene:_model];
//           // [podImporter printPODInfo];
//            [podImporter2 addMeshesToScene:_model2];;
//            
//            //		_animationController = [[Isgl3dAnimationController alloc] initWithSkeleton:_model andNumberOfFrames:[podImporter numberOfFrames]];
//            //		[_animationController start];
//            
//            _model.position = iv3(0, -100, 0);
//            _model2.position = iv3(190,-100,0);
//            
//            Isgl3dShadowCastingLight * light  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
//            [self.scene addChild:light];
//            light.position = iv3(-2, 2, -10);
//            
//            //light.renderLight = YES;
//            
//            Isgl3dShadowCastingLight * light2  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
//            [self.scene addChild:light2];
//            light2.position = iv3(2, 2, -10);
//            
//            //light2.renderLight = YES;
//            
//            Isgl3dShadowCastingLight * light3  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
//            [self.scene addChild:light3];
//            light3.position = iv3(-2, -2, -10);
//            
//            //light3.renderLight = YES;
//            
//            
//            Isgl3dShadowCastingLight * light4  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
//            [self.scene addChild:light4];
//            light4.position = iv3(2, -2, -10);
//            
//            //light4.renderLight = YES;
//            
//            
//            /*--------------|INTRODUCIMOS EL MODELO|------------------*/
//        
//        
//        }
//        
//        
//        /*--------------------| PROBAMOS CREAR UN UFO|------------------------*/
//        // Create texture and color materials and meshes for UFOs
//        //		Isgl3dMaterial * hullMaterial = [Isgl3dAnimatedTextureMaterial materialWithTextureFilenameFormat:@"ufo%02d.png" textureFirstID:0 textureLastID:15 animationName:@"ufo" shininess:0.7 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
//        //		Isgl3dMaterial * shellMaterial = [Isgl3dColorMaterial materialWithHexColors:@"9999CC" diffuse:@"9999CC" specular:@"FFFFFF" shininess:0.7];
//        //
//        //        // PAra hacer los UFOs usa una elipsoide y un hovoide
//        //		Isgl3dEllipsoid *hullMesh = [Isgl3dEllipsoid meshWithGeometry:30 radiusY:5 radiusZ:30 longs:32 lats:8];
//        //		Isgl3dOvoid * shellMesh = [Isgl3dOvoid meshWithGeometry:16 b:11 k:0.0 longs:16 lats:16];
//        //        _ufo = [_container createNodeWithMesh:hullMesh andMaterial:hullMaterial];
//        //        Isgl3dMeshNode * ufoShell = [_ufo createNodeWithMesh:shellMesh andMaterial:shellMaterial];
//        //
//        //        ufoShell.position = iv3(0, 4, 0);
//        //
//        //        // Make shell transparent
//        //        ufoShell.alpha = 0.7;
//        //
//        //        _ufo.position = iv3(0,32.5,0);
//        /*--------------------| PROBAMOS CREAR UN UFO|------------------------*/
//        
//        Isgl3dTextureMaterial * esquinasMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"esquinas.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
//		Isgl3dGLUIButton * esquinasButton = [Isgl3dGLUIButton buttonWithMaterial:esquinasMaterial width:14.4 height:9.8];
//		[self.scene addChild:esquinasButton];
//        //esquinasButton.position = iv3(-15,-20,0);
//        [esquinasButton setX:25 andY:15];
//        esquinasButton.interactive = YES;
//        [esquinasButton addEvent3DListener:self method:@selector(buttonTouched:) forEventType:TOUCH_EVENT];
//        
//        cantidadToques = 0;
//        
//        _cubito1.interactive =YES;
//        [_cubito1 addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];
//        
//        self.camera.position = iv3(0,0,0.1);
//        [self.camera setLookAt:iv3(self.camera.x, self.camera.y,0) ];
//        
//        /*Seteamos el fov.*/
//        self.camera.fov = 32;
//        
//        [self schedule:@selector(tick:)];
//	}
//	return self;
//}



- (id) init {
	/*"Si el init del padre anduvo bien..."*/
	if ((self = [super init])) {
        
        
        
        /* Create a container node as a parent for all scene objects.*/
        _container = [self.scene createNode];
        
        
        /*--------------|INTRODUCIMOS EL MODELO|------------------*/
        
        podImporter = [Isgl3dPODImporter podImporterWithFile:@"artigas1.pod"];
        [podImporter buildSceneObjects];
        podImporter2 = [Isgl3dPODImporter podImporterWithFile:@"artigas2.pod"];
        [podImporter2 buildSceneObjects];
        podImporter3 = [Isgl3dPODImporter podImporterWithFile:@"artigas3.pod"];
        [podImporter3 buildSceneObjects];
        podImporter4 = [Isgl3dPODImporter podImporterWithFile:@"artigas6.pod"];
        [podImporter4 buildSceneObjects];
        podImporter5 = [Isgl3dPODImporter podImporterWithFile:@"artigas5.pod"];
        [podImporter5 buildSceneObjects];
        
        
        
        _artigasMesh = [podImporter meshAtIndex:0 ];
        _artigasMesh2 = [podImporter2 meshAtIndex:0 ];
        _artigasMesh3 = [podImporter3 meshAtIndex:0 ];
        _artigasMesh4 = [podImporter4 meshAtIndex:0 ];
        _artigasMesh5 = [podImporter5 meshAtIndex:0 ];
        
        
        
        _mesh = [Isgl3dKeyframeMesh keyframeMeshWithMesh:_artigasMesh2];
        [_mesh addKeyframeMesh:_artigasMesh5];
        [_mesh addKeyframeMesh:_artigasMesh4];
        [_mesh addKeyframeMesh:_artigasMesh];
        [_mesh addKeyframeMesh:_artigasMesh3];
        
        //        [_mesh addKeyframeAnimationData:0 duration:1.0f];
        //        [_mesh addKeyframeAnimationData:1 duration:1.0f];
        //		[_mesh addKeyframeAnimationData:2 duration:2.0f];
        //		[_mesh addKeyframeAnimationData:3 duration:2.0f];
        //        [_mesh addKeyframeAnimationData:4 duration:1.0f];
        //        [_mesh addKeyframeAnimationData:0 duration:2.0f];
        
        [_mesh addKeyframeAnimationData:0 duration:1.0f];
        [_mesh addKeyframeAnimationData:4 duration:1.0f];
		[_mesh addKeyframeAnimationData:3 duration:2.0f];
        [_mesh addKeyframeAnimationData:4 duration:1.0f];
        [_mesh addKeyframeAnimationData:0 duration:2.0f];
        
        
		
        
		// Start the automatic mesh animation
		//[_mesh startAnimation];
        
        
        node = [_container createNodeWithMesh:_mesh andMaterial:[podImporter2 materialWithName:@"material_0"]];
		node.position = iv3(0,-50, 0);
        [podImporter2 addMeshesToScene:node];
        node.rotationX=90;
        node.rotationZ=90;
        
        node.scaleX=5;
        node.scaleY=5;
        node.scaleZ=5;
        
        Isgl3dNode * node2 = [_container createNodeWithMesh:_artigasMesh2 andMaterial:[podImporter2 materialWithName:@"material_0"]];
		node2.position = iv3(0, -50, 0);
        node2.rotationX=90;
        node2.rotationZ=90;
        node2.alpha =0.0;
        node2.scaleX=5;
        node2.scaleY=5;
        node2.scaleZ=5;
        
        /*----------------------------------|LUCES|----------------------------------*/
        
        node2.interactive =YES;
        [node2 addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];
        Isgl3dShadowCastingLight * light  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
		[self.scene addChild:light];
        light.position = iv3(-2, 2, -10);
        
        //light.renderLight = YES;
        
        Isgl3dShadowCastingLight * light2  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
		[self.scene addChild:light2];
        light2.position = iv3(2, 2, -10);
        
        //light2.renderLight = YES;
        //
        //        Isgl3dShadowCastingLight * light3  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
        //		[self.scene addChild:light3];
        //        light3.position = iv3(-2, -2, -10);
        //
        //light3.renderLight = YES;
        
        
        Isgl3dShadowCastingLight * light4  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
		[self.scene addChild:light4];
        light4.position = iv3(2, -2, -10);
        
        //light4.renderLight = YES;
        /*----------------------------------|CAMARA|----------------------------------*/
        
        self.camera.position = iv3(0,0,0.01);
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
    if (self.traslacion != nil & rotacion!=nil)
    {
        Matriz.sxx = rotacion[0][0];
        Matriz.sxy = rotacion[0][1];
        Matriz.sxz = rotacion[0][2];
        Matriz.tx = self.traslacion[0];
        
        Matriz.syx = rotacion[1][0];
        Matriz.syy = rotacion[1][1];
        Matriz.syz = rotacion[1][2];
        Matriz.ty = self.traslacion[1];
        
        Matriz.szx = rotacion[2][0];
        Matriz.szy = rotacion[2][1];
        Matriz.szz = rotacion[2][2];
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
        MAT_DOT_VEC_3X3(a, rotacion, b);
        VEC_SUM(punto3D1,a,self.traslacion);
        
        /*project CoplanarPosit*/
        b[0]=puntoModelo3D2[0];
        b[1]=puntoModelo3D2[1];
        b[2]=puntoModelo3D2[2];
        MAT_DOT_VEC_3X3(a, rotacion, b);
        VEC_SUM(punto3D2,a,self.traslacion);
        
        /*project CoplanarPosit*/
        b[0]=puntoModelo3D3[0];
        b[1]=puntoModelo3D3[1];
        b[2]=puntoModelo3D3[2];
        MAT_DOT_VEC_3X3(a, rotacion, b);
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
    
    
    
    
    if(touched)
    {
        
        k = ((double)i)/60;
        
        /*Levantando la mano*/
        
        if(k<0.5) [_mesh interpolateMesh1:0 andMesh2:1 withFactor:2*k];
        if(0.5<=k && k<1) [_mesh interpolateMesh1:1 andMesh2:2 withFactor:fmod(2*k, 1.0)];
        if(1<=k && k<2) [_mesh interpolateMesh1:2 andMesh2:3 withFactor:fmod(k, 1.0)];
        
        if(4<=k && k<5) [_mesh interpolateMesh1:3 andMesh2:4 withFactor:fmod(k, 1.0)];
        if(5<=k && k<6) [_mesh interpolateMesh1:4 andMesh2:0 withFactor:fmod(k, 1.0)];
        if(k==6) touched=false;
        
        /*Sin levantar la mano*/
        
        //    if(k<1) [_mesh interpolateMesh1:0 andMesh2:4 withFactor:k];
        //    if(1<=k && k<2) [_mesh interpolateMesh1:4 andMesh2:3 withFactor:fmod(k, 1.0)];
        //
        //    if(4<=k && k<5) [_mesh interpolateMesh1:3 andMesh2:4 withFactor:fmod(k, 1.0)];
        //    if(5<=k && k<6) [_mesh interpolateMesh1:4 andMesh2:0 withFactor:fmod(k, 1.0)];
        //    if(k==6) touched=false;
        
        
        
        i++;
    }

    
    
    
    
}
-(void) objectTouched:(Isgl3dEvent3D *)event {
    
    i=0;
    
    
    
    touched = true;
}

- (void) objectTouched2:(Isgl3dEvent3D *)event {
	
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
    NSError *error;
    self.audioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.numberOfLoops=0;
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
    
    
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    
    if (cantidadToques ==0){_cubito1.position = iv3(190,0,0); cantidadToques =1;
    }
    else if (cantidadToques ==1) {_cubito1.position = iv3(0,-100,0); cantidadToques =2;
    }
    else if (cantidadToques ==2) {_cubito1.position = iv3(0,0,0); cantidadToques =0;}
    
}

- (void) buttonTouched:(id)sender {
    
    if (dibujar==YES) {
        dibujar =NO;
    }
    else if (dibujar==NO) {
        dibujar=YES;
    }
}


@end

