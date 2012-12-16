//
//  HelloWorldView.h
//  modelos
//
//  Created by Pablo Flores Guridi on 01/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "isgl3d.h"
#import "math.h"

@interface HelloWorldView : Isgl3dBasic3DView {
	float _angle;
	Isgl3dMeshNode * _teapot;
@private
	// The rendered text
	Isgl3dMeshNode * _3dText;
}

@end


