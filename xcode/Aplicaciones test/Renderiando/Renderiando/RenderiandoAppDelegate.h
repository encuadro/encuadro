//
//  RenderiandoAppDelegate.h
//  Renderiando
//
//  Created by Pablo Flores Guridi on 23/08/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

@class Isgl3dViewController;

@interface RenderiandoAppDelegate : NSObject <UIApplicationDelegate> {

@private
	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;

- (void) createViews;

@end
