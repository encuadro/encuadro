//
//  helloWorldISGLAppDelegate.h
//  helloWorldISGL
//
//  Created by encuadro augmented reality on 9/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

@class Isgl3dViewController;

@interface helloWorldISGLAppDelegate : NSObject <UIApplicationDelegate> {

@private
	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;

@end
