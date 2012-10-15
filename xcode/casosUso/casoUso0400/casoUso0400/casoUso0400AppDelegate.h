//
//  casoUso0400AppDelegate.h
//  casoUso0400
//
//  Created by Pablo Flores Guridi on 15/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

//#import "configuration.h"

@class Isgl3dViewController;

@interface casoUso0400AppDelegate : NSObject <UIApplicationDelegate> {
    
@private
	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;
- (void) createViews ;

@end


