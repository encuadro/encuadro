//
//  HelloWorldView.h
//  renderiandoDinamico
//
//  Created by Pablo Flores Guridi on 18/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "isgl3d.h"
#include "vvector.h"

@interface HelloWorldView : Isgl3dBasic3DView {

@private
	// The rendered text

	Isgl3dMeshNode * _cube1;
    Isgl3dMeshNode * _cube2;
    Isgl3dMeshNode * _cube3;
	//Isgl3dDemoCameraController * _cameraController;
}
- (void) cambiarCubos: (int) numero;
@end


