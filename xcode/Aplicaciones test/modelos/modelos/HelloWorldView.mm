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

- (id) init {
	
	if ((self = [super init])) {

        
		// Enable shadow rendering
		[Isgl3dDirector sharedInstance].shadowRenderingMethod = Isgl3dShadowPlanar;
		[Isgl3dDirector sharedInstance].shadowAlpha = 0.5;
        
		Isgl3dPODImporter * podImporter = [Isgl3dPODImporter podImporterWithFile:@"Scene_float.pod"];
        		[podImporter printPODInfo];
		
		// Add all meshes in POD to scene
		[podImporter addMeshesToScene:self.scene];
        
		// Add light to scene and fix the Sphere01 mesh to it
		Isgl3dShadowCastingLight * light  = [Isgl3dShadowCastingLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
		[self.scene addChild:light];
		[podImporter configureLight:light fromNode:@"Sphere01"];
        
		// Get the teapot for later use
		_teapot = [podImporter meshNodeWithName:@"Teapot01"];
		
		// POD data has non-normalised normals
		_teapot.mesh.normalizationEnabled = YES;
		[podImporter meshNodeWithName:@"Plane01"].mesh.normalizationEnabled = YES;
        
		// Make the teapot render shadows
		_teapot.enableShadowCasting = YES;
        
		//light.planarShadowsNode = [podImporter meshNodeWithName:@"Plane01"];
		light.planarShadowsNodeNormal = iv3(0, 1, 0);
        
		// Set the camera up as it has been saved in the POD
		// Remove camera created in super, added from POD later
		[self.camera removeFromParent];
		self.camera = [podImporter cameraAtIndex:0];
		[self.scene addChild:self.camera];
		
        self.camera.position = iv3(0,0, 400);
		[self setSceneAmbient:[Isgl3dColorUtil rgbString:[podImporter ambientColor]]];
		
		// Schedule updates
		
		[self schedule:@selector(tick:)];
	}
	return self;
}

- (void) dealloc {

	[super dealloc];
}


- (void) tick:(float)dt {
	// Rotate the text around the y axis
	_3dText.rotationY += 2;
}


@end

