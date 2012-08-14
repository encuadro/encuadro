//
//  demo04AppDelegate.h
//  demo04
///Users/pablofloresguridi/Desktop/cml-1_0_2/examples/simple.cpp
//  Created by Pablo Flores Guridi on 28/06/12.
//  Copyright 2012 pablofloresguridi@gmail.com. All rights reserved.
//
#import "claseDibujar.h"
#import "simple.h"

@class Isgl3dViewController;

@interface demo04AppDelegate : NSObject <UIApplicationDelegate> {
    
@private
	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;
- (void) createViews ;

@end
