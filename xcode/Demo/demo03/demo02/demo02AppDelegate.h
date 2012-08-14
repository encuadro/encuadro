//
//  demo02AppDelegate.h
//  demo02
//
//  Created by Pablo Flores Guridi on 27/06/12.
//  Copyright 2012 pablofloresguridi@gmail.com. All rights reserved.
//

@class Isgl3dViewController;

@interface demo02AppDelegate : NSObject <UIApplicationDelegate> {
    
@private
	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;
- (void) createViews ;

@end
