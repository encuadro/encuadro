//
//  HelloWorldView.h
//  isgl3DYAVFoundation
//
//  Created by Pablo Flores Guridi on 12/05/12.
//  Copyright 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#import "isgl3d.h"


@interface videoView : UIImageView {
}

@end


@class Isgl3dDemoCameraController;
@interface HelloWorldView : Isgl3dBasic3DView {
    
@private
	// The rendered text
    Isgl3dMeshNode * _3dText;
    Isgl3dDemoCameraController * _cameraController;
}
@property (nonatomic) double* rotacion;
@property (nonatomic) double* traslacion;

- (void) actualizar:(double*)rotacion traslacion: (double*)traslacion;


@end

/*
 * Principal class to be instantiated in main.h. 
 */
#import "demo03AppDelegate.h"
@interface AppDelegate : demo03AppDelegate
- (void) createViews;
@end

