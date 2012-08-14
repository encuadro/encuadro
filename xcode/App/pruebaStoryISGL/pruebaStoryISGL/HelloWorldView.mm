//
//  HelloWorldView.m
//  test-isgl3d-1
//
//  Created by Juan Cardelino on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"
#import "Isgl3dPODImporter.h"
#import "Isgl3dCylinder.h"
#import "Isgl3dSphere.h"
#import "Isgl3dVector.h"
#import "Isgl3dAppDelegate.h"





@implementation HelloWorldView



#ifndef OLD_ISGL3D
+ (id<Isgl3dCamera>)createDefaultSceneCameraForViewport:(CGRect)viewport {
	Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"creating default camera with perspective projection. Viewport size = %@", NSStringFromCGSize(viewport.size));
	
	float fovyRadians = Isgl3dMathDegreesToRadians(45.0f);
	Isgl3dPerspectiveProjection *perspectiveLens = [[Isgl3dPerspectiveProjection alloc] initFromViewSize:viewport.size fovyRadians:fovyRadians nearZ:1.0f farZ:10000.0f];
	
	Isgl3dVector3 cameraPosition = Isgl3dVector3Make(0.0f, 0.0f, 10.0f);
	Isgl3dVector3 cameraLookAt = Isgl3dVector3Make(0.0f, 0.0f, 0.0f);
	Isgl3dVector3 cameraLookUp = Isgl3dVector3Make(0.0f, 1.0f, 0.0f);
	Isgl3dLookAtCamera *standardCamera = [[Isgl3dLookAtCamera alloc] initWithLens:perspectiveLens
																									 eyeX:cameraPosition.x eyeY:cameraPosition.y eyeZ:cameraPosition.z
																								 centerX:cameraLookAt.x centerY:cameraLookAt.y centerZ:cameraLookAt.z
																									  upX:cameraLookUp.x upY:cameraLookUp.y upZ:cameraLookUp.z];
	[perspectiveLens release];
	return [standardCamera autorelease];
}
#endif

- (id) init 
{
		
	if ((self = [super init])) {
		
		//configure camera
		//float factor=0.75;
		//float factor=0.5;
#ifdef OLD_ISGL3D
		[self.camera setFov:33.1418];
		// Translate the camera.
		[self.camera setPosition:iv3(0, 00, 150)];
		[self.camera lookAt:0 y:0 z:-45];
		[self.camera setFar:550];
#endif
		
		
	
		// Create directional white light and add to scene
		
		Isgl3dLight * light = [Isgl3dLight lightWithHexColor:@"444444" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.01];
		light.lightType = DirectionalLight;
		[light setDirection:-1 y:-1 z:0.1];
		//light.position = iv3(5, 10, 5);
		//light.renderLight=YES;
		[self.scene addChild:light];	
		//[self setSceneAmbient:@"444444"];
		
#if 1
		[self drawTestBubble];
#endif
		
		
			
		[self schedule:@selector(tick:)];
		
	}
	NSLog(@"HelloWorldView init");
	return self;
}

- (void) dealloc
{
	[super dealloc];
	NSLog(@"View dealloc");
}

- (void)drawTestBubble
{
	//test bubble
	float bubble_alpha=0.5;
	float bubble_shine=0.7;
	NSString *color=@"00DDFF";
	Isgl3dMaterial * bubbleRed2 = [Isgl3dColorMaterial materialWithHexColors:color diffuse:color specular:@"FFFFFF" shininess:bubble_shine];
	Isgl3dSphere * bubble = [Isgl3dSphere meshWithGeometry:5 longs:64 lats:64];
	Isgl3dMeshNode *bubbleNode = [self.scene createNodeWithMesh:bubble andMaterial:bubbleRed2];
	bubbleNode.alpha = bubble_alpha;
	[bubbleNode setScale:2];
	//esto prueba que un nodo se puede agregar y quitar cuantas veces se quiera
	/*
	[bubbleNode removeFromParent];
	bubbleNode.alpha = 0.7;
	[self.scene addChild:bubbleNode];
	[bubbleNode removeFromParent];
	[bubbleNode setScale:2];
	[self.scene addChild:bubbleNode];
*/
	 }



- (void) tick:(float)dt 
{
}







@end


