//
//  demo06mouAppDelegate.h
//  demo06mou
//
//  Created by Pablo Flores Guridi on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

//#import "claseDibujar.h"
//#import "simple.h"
#import "configuration.h"

@class Isgl3dViewController;

@interface demo06mouAppDelegate : NSObject <UIApplicationDelegate> {
    
@private
	Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, retain) UIWindow * window;
- (void) createViews ;

@end

