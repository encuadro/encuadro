//
//  app01aAppDelegate.h
//  app01a
//
//  Created by encuadro augmented reality on 8/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

@class Isgl3dViewController;

@interface app01aAppDelegate : NSObject <UIApplicationDelegate> {
    
@private
	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;
- (void) createViews ;

@end
