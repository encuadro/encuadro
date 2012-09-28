//
//  HelloWorldView.h
//  InertialSensor
//
//  Created by Juan Ignacio Braun on 8/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "isgl3d.h"
#import <CoreMotion/CoreMotion.h>

@interface HelloWorldView : Isgl3dBasic3DView {

    CMMotionManager *motionManager;
	CMDeviceMotion *dm;

    
@private
	// The rendered text
	Isgl3dMeshNode * _3dText;
}

@end


