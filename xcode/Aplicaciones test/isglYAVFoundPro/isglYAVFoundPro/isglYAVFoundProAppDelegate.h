//
//  isglYAVFoundProAppDelegate.h
//  isglYAVFoundPro
//
//  Created by Pablo Flores Guridi on 12/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

@class Isgl3dViewController;

@interface isglYAVFoundProAppDelegate : NSObject <UIApplicationDelegate> {

@private
	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;

@end
