//
//  isgl3DYAVFoundationAppDelegate.h
//  isgl3DYAVFoundation
//
//  Created by Pablo Flores Guridi on 12/05/12.
//  Copyright 2012 pablofloresguridi@gmail.com. All rights reserved.
//

@class Isgl3dViewController;

@interface demo01AppDelegate : NSObject <UIApplicationDelegate> {
    
@private
	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;
- (void) createViews ;

@end
