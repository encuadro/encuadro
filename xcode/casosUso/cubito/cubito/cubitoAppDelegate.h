//
//  cubitoAppDelegate.h
//  cubito
//
//  Created by Pablo Flores Guridi on 19/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

@class Isgl3dViewController;

@interface cubitoAppDelegate : NSObject <UIApplicationDelegate> {
    
@private
	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;
- (void) createViews ;

@end


