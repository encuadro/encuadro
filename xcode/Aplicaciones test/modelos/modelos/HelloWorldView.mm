//
//  HelloWorldView.m
//  modelos
//
//  Created by Pablo Flores Guridi on 01/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"
#include "Isgl3dPODImporter.h"




@implementation HelloWorldView

Isgl3dSkeletonNode * _model;
Isgl3dSkeletonNode * _model2;
Isgl3dSkeletonNode * _model3;
Isgl3dNode * _container;
Isgl3dKeyframeMesh * _mesh;

Isgl3dPODImporter * podImporter;
Isgl3dPODImporter * podImporter2;
Isgl3dPODImporter * podImporter3;
Isgl3dGLMesh* _artigasMesh;
Isgl3dGLMesh* _artigasMesh2;
Isgl3dGLMesh* _artigasMesh3;


int i;
double k;

- (id) init {
	
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
        printf("1\n");

        
        _artigasMesh = [podImporter meshAtIndex:0 ];
        _artigasMesh2 = [podImporter2 meshAtIndex:0 ];
        _artigasMesh3 = [podImporter3 meshAtIndex:0 ];

        

        _mesh = [Isgl3dKeyframeMesh keyframeMeshWithMesh:_artigasMesh2];
        [_mesh addKeyframeMesh:_artigasMesh3];
        [_mesh addKeyframeMesh:_artigasMesh];
        
        [_mesh addKeyframeAnimationData:0 duration:1.0f];
        [_mesh addKeyframeAnimationData:1 duration:1.0f];
		[_mesh addKeyframeAnimationData:2 duration:1.0f];
		[_mesh addKeyframeAnimationData:2 duration:2.0f];
        [_mesh addKeyframeAnimationData:1 duration:1.0f];
        [_mesh addKeyframeAnimationData:0 duration:2.0f];
	

		
        
		// Start the automatic mesh animation
		//[_mesh startAnimation];
        
        
        Isgl3dNode * node = [_container createNodeWithMesh:_mesh andMaterial:[podImporter2 materialWithName:@"material_0"]];
		node.position = iv3(0, -60, -120);
        [podImporter2 addMeshesToScene:node];
        
 
        node.scaleX=1.5;
        node.scaleY=1.5;
        node.scaleZ=1.5;

        Isgl3dNode * node2 = [_container createNodeWithMesh:_artigasMesh2 andMaterial:[podImporter2 materialWithName:@"material_0"]];
		node2.position = iv3(0, -60, -120);
        node2.alpha =0.0;
        node2.scaleX=1.5;
        node2.scaleY=1.5;
        node2.scaleZ=1.5;

        node2.interactive =YES;
        [node2 addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];


        self.camera.position=iv3(0,0,75);
        
/*------------------------------------------ LUCES -----------------------------------------*/
        
        Isgl3dShadowCastingLight * light  = [Isgl3dLight lightWithHexColor:@"777777" diffuseColor:@"777777" specularColor:@"7777777" attenuation:0.00];
		[self.scene addChild:light];
        light.position = iv3(-2, 2, 0);
        
        
//        Isgl3dShadowCastingLight * light2  = [Isgl3dLight lightWithHexColor:@"777777" diffuseColor:@"777777" specularColor:@"7777777" attenuation:0.00];
//		[self.scene addChild:light2];
//        light2.position = iv3(2, 2, 0);
        
        
        Isgl3dShadowCastingLight * light3  = [Isgl3dLight lightWithHexColor:@"777777" diffuseColor:@"777777" specularColor:@"7777777" attenuation:0.00];
		[self.scene addChild:light3];
        light3.position = iv3(-2, -2, 0);
        
        
        Isgl3dShadowCastingLight * light4  = [Isgl3dLight lightWithHexColor:@"777777" diffuseColor:@"777777" specularColor:@"7777777" attenuation:0.00];
		[self.scene addChild:light4];
        light4.position = iv3(2, -2, 0);

		
		// Schedule updates
		
		//[self schedule:@selector(tick:)];
        
	}

	return self;
}

- (void) dealloc {

	[super dealloc];
}

- (void) tick:(float)dt {
	// Rotate the text around the y axis
	//_3dText.rotationY += 2;
}

-(void) objectTouched:(Isgl3dEvent3D *)event {
    
    i=0;
   

    [self schedule:@selector(stop)];

}

- (void) stop{

    k = ((double)i)/60;

    if(k<1) [_mesh interpolateMesh1:0 andMesh2:1 withFactor:k];
    if(1<=k && k<2) [_mesh interpolateMesh1:1 andMesh2:2 withFactor:fmod(k, 1.0)];
    
    if(4<=k && k<5) [_mesh interpolateMesh1:2 andMesh2:1 withFactor:fmod(k, 1.0)];
    if(5<=k && k<6) [_mesh interpolateMesh1:1 andMesh2:0 withFactor:fmod(k, 1.0)];
    if(k==6) [self unschedule];
    i++;
}

@end

