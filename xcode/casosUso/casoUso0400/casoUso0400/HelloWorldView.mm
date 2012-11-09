//
//  HelloWorldView.m
//  casoUso0400
//
//  Created by Pablo Flores Guridi on 15/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"
#import "Isgl3dViewController.h"
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

@end


@implementation HelloWorldView


@synthesize traslacion = _traslacion;
@synthesize eulerAngles = _eulerAngles;
@synthesize audioPlayer = _audioPlayer;

float punto3D1[3], punto3D2[3], punto3D3[3], punto3D4[3], puntoModelo3D1[4] = {0,0,0,1}, puntoModelo3D2[4] = {190,0,-30,1}, puntoModelo3D3[4] = {0,100,-30,1};// puntoModelo3D4[4] = {0,0,-60,1};
/*Si queremos meter cubos*/
//puntoModelo3D2[4] = {187.5,0,35/2,1}, puntoModelo3D3[4] = {0,105,35/2,1},
Isgl3dMatrix4 Matriz;
Isgl3dVector3 angles;
float rotacion[3][3];


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
- (id) init {
	/*"Si el init del padre anduvo bien..."*/
	if ((self = [super init])) {
        
        
        // printf("init del HelloWorldView\n");
        corners=NO;
        segments=NO;
        reproyected=NO;
        
        /* Create a container node as a parent for all scene objects.*/
        _container = [self.scene createNode];
        
        // Create the primitive
//		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithTextureFile:@"red_checker.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
//        Isgl3dCube* cubeMesh = [Isgl3dCube  meshWithGeometry:60 height:60 depth:60 nx:40 ny:40];
//        _cubito1 = [_container createNodeWithMesh:cubeMesh andMaterial:material];
//        _cubito1.position = iv3(0,0,0);
        
        
        
        /*--------------|INTRODUCIMOS EL MODELO|------------------*/
        
        Isgl3dPODImporter * podImporter = [Isgl3dPODImporter podImporterWithFile:@"artigas.pod"];
        Isgl3dPODImporter * podImporter2 = [Isgl3dPODImporter podImporterWithFile:@"chihua.pod"];
        
		_model = [_container createSkeletonNode];
		_model2 = [_container createSkeletonNode];
        
    //    _model.scaleX=5;
      //  _model.scaleY=5;
        //_model.scaleZ=5;
       // _model.rotationX = 90;
        
        _model2.scaleX=5;
        _model2.scaleY=5;
        _model2.scaleZ=5;
        _model2.rotationY = 90;
        
        [podImporter printPODInfo];
        
        
		[podImporter addMeshesToScene:_model];
        [podImporter2 addMeshesToScene:_model2];;
		
//		_animationController = [[Isgl3dAnimationController alloc] initWithSkeleton:_model andNumberOfFrames:[podImporter numberOfFrames]];
//		[_animationController start];
        
        _model.position = iv3(0, -100, 0);
        _model2.position = iv3(190,-100,0);

        Isgl3dShadowCastingLight * light  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
		[self.scene addChild:light];
        light.position = iv3(-2, 2, -10);

        //light.renderLight = YES;
        
        Isgl3dShadowCastingLight * light2  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
		[self.scene addChild:light2];
        light2.position = iv3(2, 2, -10);
        
        //light2.renderLight = YES;
        
        Isgl3dShadowCastingLight * light3  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
		[self.scene addChild:light3];
        light3.position = iv3(-2, -2, -10);
        
        //light3.renderLight = YES;

        
        Isgl3dShadowCastingLight * light4  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
		[self.scene addChild:light4];
        light4.position = iv3(2, -2, -10);
        
        //light4.renderLight = YES;


        /*--------------|INTRODUCIMOS EL MODELO|------------------*/

        /* Generamos el boton para dibujar los segmentos detectados */
        
        Isgl3dTextureMaterial * segmentsMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"detected_segments.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dGLUIButton * segmentsButton = [Isgl3dGLUIButton buttonWithMaterial:segmentsMaterial width:14.4 height:9.8];
		[self.scene addChild:segmentsButton];
        
        [segmentsButton setX:30 andY:20];
        segmentsButton.interactive = YES;
        [segmentsButton addEvent3DListener:self method:@selector(segmentsTouched:) forEventType:TOUCH_EVENT];
        
        /* Generamos el boton para dibujar las esquinas detectadas */
        
        Isgl3dTextureMaterial * cornersMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"detected_points.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dGLUIButton * cornersButton = [Isgl3dGLUIButton buttonWithMaterial:cornersMaterial width:14.4 height:9.8];
		[self.scene addChild:cornersButton];
        
        [cornersButton setX:30 andY:10];
        cornersButton.interactive = YES;
        [cornersButton addEvent3DListener:self method:@selector(cornersTouched:) forEventType:TOUCH_EVENT];
        
        /* Generamos el boton para dibujar las esquinas reproyectadas */
        
        Isgl3dTextureMaterial * reproyectedMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"reproyected_points.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dGLUIButton * reproyectedButton = [Isgl3dGLUIButton buttonWithMaterial:reproyectedMaterial width:14.4 height:9.8];
		[self.scene addChild:reproyectedButton];
        
        [reproyectedButton setX:30 andY:0];
        reproyectedButton.interactive = YES;
        [reproyectedButton addEvent3DListener:self method:@selector(reproyectedTouched:) forEventType:TOUCH_EVENT];

        
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
        
//        printf("\nisgl3d solucion\n");
//        printf("psi1: %f\ntheta1: %f\nphi1: %f\n",angles.x,angles.y,angles.z);
        
        
        /*project CoplanarPosit*/
        float a[3],b[3];
        b[0]=puntoModelo3D1[0];
        b[1]=puntoModelo3D1[1];
        b[2]=puntoModelo3D1[2];
        MAT_DOT_VEC_3X3(a, rotacion, b);
        VEC_SUM(punto3D1,a,self.traslacion);
        
//        /*project CoplanarPosit*/
//        b[0]=puntoModelo3D2[0];
//        b[1]=puntoModelo3D2[1];
//        b[2]=puntoModelo3D2[2];
//        MAT_DOT_VEC_3X3(a, rotacion, b);
//        VEC_SUM(punto3D2,a,self.traslacion);
//        
//        /*project CoplanarPosit*/
//        b[0]=puntoModelo3D3[0];
//        b[1]=puntoModelo3D3[1];
//        b[2]=puntoModelo3D3[2];
//        MAT_DOT_VEC_3X3(a, rotacion, b);
//        VEC_SUM(punto3D3,a,self.traslacion);
        
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


- (void) segmentsTouched:(id)sender {
    
    if (segments==YES) {
        segments =NO;
    }
    else if (segments==NO) {
        segments=YES;
    }
}

- (void) cornersTouched:(id)sender {
    
    if (corners==YES) {
        corners =NO;
    }
    else if (corners==NO) {
        corners=YES;
    }
}

- (void) reproyectedTouched:(id)sender {
    
    if (reproyected==YES) {
        reproyected =NO;
    }
    else if (reproyected==NO) {
        reproyected=YES;
    }
}


@end

