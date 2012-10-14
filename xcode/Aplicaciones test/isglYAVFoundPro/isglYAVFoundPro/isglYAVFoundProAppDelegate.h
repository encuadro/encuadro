//
//  casoUso0101AppDelegate.h
//  casoUso0101
//
//  Created by Pablo Flores Guridi on 01/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@class Isgl3dViewController;

@interface isglYAVFoundProAppDelegate : NSObject <UIApplicationDelegate> {
    
@private
//	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;
@property (nonatomic, retain) Isgl3dViewController* viewController;
- (void) createViews ;

@end

