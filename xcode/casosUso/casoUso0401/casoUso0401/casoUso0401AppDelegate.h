//
//  casoUso0401AppDelegate.h
//  casoUso0401
//
//  Created by Pablo Flores Guridi on 18/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

@class Isgl3dViewController;

@interface casoUso0401AppDelegate : NSObject <UIApplicationDelegate> {
    
@private
	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;
- (void) createViews ;

@end


