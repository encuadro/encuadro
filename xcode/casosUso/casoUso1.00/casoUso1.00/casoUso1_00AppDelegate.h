//
//  casoUso1_00AppDelegate.h
//  casoUso1.00
//
//  Created by Pablo Flores Guridi on 14/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

@class Isgl3dViewController;

@interface casoUso1_00AppDelegate : NSObject <UIApplicationDelegate> {

@private
	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;

@end
