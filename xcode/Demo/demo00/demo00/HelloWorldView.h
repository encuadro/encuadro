//
//  HelloWorldView.h
//  demo00
//
//  Created by encuadro augmented reality on 6/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "isgl3d.h"


@interface videoView : UIImageView {

}
@property(nonatomic,readwrite) int i ;

- (void) actualizar:(UIImage *)img;
@end

@class Isgl3dDemoCameraController;
@interface HelloWorldView : Isgl3dBasic3DView {
    
@private
	// The rendered text
	Isgl3dMeshNode * _3dText;
	Isgl3dDemoCameraController * _cameraController;
}
//- (void) actualizar:(UIImage*)imagen;


@end

/*
 * Principal class to be instantiated in main.h. 
 */
#import "demo00AppDelegate.h"
@interface AppDelegate : demo00AppDelegate
- (void) createViews;
@end

