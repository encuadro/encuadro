//
//  InertialSensorAppDelegate.h
//  InertialSensor
//
//  Created by Juan Ignacio Braun on 8/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

@class Isgl3dViewController;

@interface InertialSensorAppDelegate : NSObject <UIApplicationDelegate> {

@private
	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;

@end
