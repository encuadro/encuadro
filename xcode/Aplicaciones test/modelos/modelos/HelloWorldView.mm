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


- (id) init {
	
	if ((self = [super init])) {

    
        
        /* Create a container node as a parent for all scene objects.*/
        _container = [self.scene createNode];
        
        // Create the primitive
        //		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithTextureFile:@"red_checker.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
        //        Isgl3dCube* cubeMesh = [Isgl3dCube  meshWithGeometry:60 height:60 depth:60 nx:40 ny:40];
        //        _cubito1 = [_container createNodeWithMesh:cubeMesh andMaterial:material];
        //        _cubito1.position = iv3(0,0,0);
        
        
        
        /*--------------|INTRODUCIMOS EL MODELO|------------------*/
        
        Isgl3dPODImporter * podImporter = [Isgl3dPODImporter podImporterWithFile:@"artigas_animado01.pod"];
        [podImporter buildSceneObjects];
        Isgl3dPODImporter * podImporter2 = [Isgl3dPODImporter podImporterWithFile:@"artigas_animado02.pod"];
        [podImporter2 buildSceneObjects];
        Isgl3dPODImporter * podImporter3 = [Isgl3dPODImporter podImporterWithFile:@"artigas_animado03.pod"];
        
		//_model = [_container createSkeletonNode];
        _model2 = [_container createSkeletonNode];
        _model3 = [_container createSkeletonNode];
        
        Isgl3dGLMesh* _artigasMesh = [podImporter meshAtIndex:0 ];
        Isgl3dGLMesh* _artigasMesh2 = [podImporter2 meshAtIndex:0 ];
        
//        _model.scaleX=1.5;
//        _model.scaleY=1.5;
//        _model.scaleZ=1.5;
        
        _model2.scaleX=1.5;
        _model2.scaleY=1.5;
        _model2.scaleZ=1.5;
        
        _model3.scaleX=1.5;
        _model3.scaleY=1.5;
        _model3.scaleZ=1.5;
        //  _model.rotationX = 90;
        

        Isgl3dKeyframeMesh * _mesh = [Isgl3dKeyframeMesh keyframeMeshWithMesh:_artigasMesh];
       [_mesh addKeyframeMesh:_artigasMesh2];
        
        [_mesh addKeyframeAnimationData:0 duration:1.0f];
		[_mesh addKeyframeAnimationData:0 duration:2.0f];
		[_mesh addKeyframeAnimationData:1 duration:1.0f];
		[_mesh addKeyframeAnimationData:1 duration:2.0f];
		
        
        
		// Start the automatic mesh animation
		[_mesh startAnimation];
        
        [podImporter printPODInfo];
        
        [podImporter2 addMeshesToScene:_model2];
        [podImporter3 addMeshesToScene:_model3];
        
        Isgl3dNode * node = [_container createNodeWithMesh:_mesh andMaterial:[podImporter materialWithName:@"material_0"]];
		node.position = iv3(-90, -60, -150);
        [podImporter addMeshesToScene:node];
        
        node.scaleX=1.5;
        node.scaleY=1.5;
        node.scaleZ=1.5;
		
        //		_animationController = [[Isgl3dAnimationController alloc] initWithSkeleton:_model andNumberOfFrames:[podImporter numberOfFrames]];
        //		[_animationController start];
        
        //_model.position = iv3(-90, -60, -150);
        
        _model2.position = iv3(0, -60, -150);
//        _model2.rotationY = 90;
        
        _model3.position = iv3(90, -60, -150);
//        _model.rotationY = -30;

        self.camera.position=iv3(0,0,100);
        
        Isgl3dShadowCastingLight * light  = [Isgl3dLight lightWithHexColor:@"777777" diffuseColor:@"777777" specularColor:@"7777777" attenuation:0.00];
		[self.scene addChild:light];
        light.position = iv3(-2, 2, 0);
        
        //light.renderLight = YES;
        
//        Isgl3dShadowCastingLight * light2  = [Isgl3dLight lightWithHexColor:@"777777" diffuseColor:@"777777" specularColor:@"7777777" attenuation:0.00];
//		[self.scene addChild:light2];
//        light2.position = iv3(2, 2, 0);
        
        //light2.renderLight = YES;
        
        Isgl3dShadowCastingLight * light3  = [Isgl3dLight lightWithHexColor:@"777777" diffuseColor:@"777777" specularColor:@"7777777" attenuation:0.00];
		[self.scene addChild:light3];
        light3.position = iv3(-2, -2, 0);
        
        //light3.renderLight = YES;
        
        
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

- (Isgl3dGLMesh *) createNewMeshFromPODMesh:(Isgl3dGLMesh *)podMesh {
	
	// This simply creates a new mesh from the original pod data but modifies the vertex postions
	// For this test we simply map the vertices down onto a sphere using their normal vector data
	Isgl3dGLMesh * mesh = [[Isgl3dGLMesh alloc] init];
	[mesh setVertices:podMesh.vertexData withVertexDataSize:podMesh.vertexDataSize andIndices:podMesh.indices withIndexDataSize:podMesh.indexDataSize
  andNumberOfElements:podMesh.numberOfElements andVBOData:podMesh.vboData];

    
	Isgl3dGLVBOData * vboData = mesh.vboData;
	unsigned int stride = vboData.stride;
	unsigned int positionOffsetX = vboData.positionOffset;
	unsigned int positionOffsetY = vboData.positionOffset + sizeof(float);
	unsigned int positionOffsetZ = vboData.positionOffset + 2 * sizeof(float);
	unsigned int normalOffsetX = vboData.normalOffset;
	unsigned int normalOffsetY = vboData.normalOffset + sizeof(float);
	unsigned int normalOffsetZ = vboData.normalOffset + 2 * sizeof(float);
	unsigned int numberOfVertices = mesh.numberOfVertices;
	

    
	// Get raw vertex data array from mesh
	unsigned char * vertexData = mesh.vertexData;
    
	// Create some "dummy" data, here just use the normal data to map all the vertices onto a shere
	float nx, ny, nz;
	float length;
	float radius = 20.0f;
	for (unsigned int i = 0; i < numberOfVertices; i++) {
		nx = *((float*)&vertexData[stride * i + normalOffsetX]);
		ny = *((float*)&vertexData[stride * i + normalOffsetY]);
		nz = *((float*)&vertexData[stride * i + normalOffsetZ]);
		length = sqrt(nx*nx + ny*ny + nz*nz);
		
		
		*((float*)&vertexData[stride * i + positionOffsetX]) = radius * nx / length;
		*((float*)&vertexData[stride * i + positionOffsetY]) = radius * ny / length;
		*((float*)&vertexData[stride * i + positionOffsetZ]) = radius * nz / length;
	}
	
	return [mesh autorelease];
}

@end

