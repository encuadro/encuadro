//
//  casoUso0400AppDelegate.h
//  casoUso0400
//
//  Created by Pablo Flores Guridi on 15/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "casoUso0400AppDelegate.h"
#import "Isgl3dViewController.h"
#import "Isgl3d.h"


@implementation casoUso0400AppDelegate

@synthesize window = _window;

bool verbose = FALSE;

- (void) applicationDidFinishLaunching:(UIApplication*)application {
    /*Lo primero que se corre es este metodo*/
    
    printf("applicationDidFinishLaunching (AppDelegate)\n");
    
	// Create the UIWindow
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Instantiate the Isgl3dDirector and set background color
	[Isgl3dDirector sharedInstance].backgroundColorString = @"333333ff";
    
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;
    
	// Set the director to display the FPS
	[Isgl3dDirector sharedInstance].displayFPS = NO;
    
	// Create the UIViewController
    /*El init que se esta invocando es el del padre UIViewController*/
	_viewController = [[Isgl3dViewController alloc] initWithNibName:nil bundle:nil];
	_viewController.wantsFullScreenLayout = YES;
    [self.window setRootViewController:_viewController];
    
	// Create OpenGL view (here for OpenGL ES 1.1)
	Isgl3dEAGLView * glView = [Isgl3dEAGLView viewWithFrameForES1:[_window bounds]];
    // UIBackgroundView* hwView = [[UIBackgroundView alloc] init];
    /*Esto anda bein*/
    
    /*Isgl3dEAGLView es un UIView*/
	// Set view in director
	[Isgl3dDirector sharedInstance].openGLView = glView;
    
	// Specify auto-rotation strategy if required (for example via the UIViewController and only landscape)
	[Isgl3dDirector sharedInstance].autoRotationStrategy = Isgl3dAutoRotationByUIViewController;
	[Isgl3dDirector sharedInstance].allowedAutoRotations = Isgl3dAllowedAutoRotationsLandscapeOnly;
	
	// Set the animation frame rate
	[[Isgl3dDirector sharedInstance] setAnimationInterval:1.0/60];
    
	// Add the OpenGL view to the view controller
    _viewController.view = glView;
    
	// Add view to window and make visible
    /* Esto es basicamente hacer el linkeo con flechitas*/
    [_window addSubview:glView];
	[_window makeKeyAndVisible];
    
    // Creates the view(s) and adds them to the director
	
    [self createViews];
    
	[[Isgl3dDirector sharedInstance] run];
    /*-------------------------------------------------------------------------------------------------------------------------------------------*/
    
    
    //    UIImageView* vistaImg = [[UIImageView alloc] init];
    //    //  vistaImg.image = [UIImage imageNamed:@"Calibrar10.jpeg"];
    //
    //
    //    //vistaImg.transform =CGAffineTransformMake(0, 1, -1, 0, 0, 0);
    //    /* Se ajusta la pantalla*/
    //
    //    UIScreen *screen = [UIScreen mainScreen];
    //    CGRect fullScreenRect = screen.bounds;
    //
    //    printf("%f \t %f\n",fullScreenRect.size.width, fullScreenRect.size.height);
    //    [vistaImg setCenter:CGPointMake(fullScreenRect.size.width/2, fullScreenRect.size.height/2)];
    //    [vistaImg setBounds:fullScreenRect];
    //
    //
    //
    //    //    [vistaImg setNeedsDisplay];
    //
    //
    //    [self.window addSubview:vistaImg];
    //	[self.window sendSubviewToBack:vistaImg];
    //
    //
    //    _viewController.videoView = vistaImg;
    //
    //
    //	// Make the opengl view transparent
    //	[Isgl3dDirector sharedInstance].openGLView.backgroundColor = [UIColor clearColor];
    //	[Isgl3dDirector sharedInstance].openGLView.opaque = NO;
    
    /*-------------------------------------------------------------------------------------------------------------------------------------------*/
    /*Corremos el metodo viewDidLoad del ViewController*/
    
    
    [_viewController viewDidLoad];
}

- (void) dealloc
{
	if (_viewController) {
		[_viewController release];
	}
	if (_window) {
		[_window release];
	}
	
	[super dealloc];
}

- (void) applicationWillResignActive:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] pause];
}

- (void) applicationDidBecomeActive:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] resume];
}

- (void) applicationDidEnterBackground:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] stopAnimation];
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] startAnimation];
}

- (void) applicationWillTerminate:(UIApplication *)application {
	// Remove the OpenGL view from the view controller
	[[Isgl3dDirector sharedInstance].openGLView removeFromSuperview];
	
	// End and reset the director
	[Isgl3dDirector resetInstance];
	
	// Release
	[_viewController release];
	_viewController = nil;
	[_window release];
	_window = nil;
}

- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] onMemoryWarning];
}

- (void) applicationSignificantTimeChange:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] onSignificantTimeChange];
}

- (void) createViews {
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationPortrait;
    
	// Set the background transparent
	[Isgl3dDirector sharedInstance].backgroundColorString = @"00000000";
    
	// Create view and add to Isgl3dDirector
	Isgl3dView * view = [HelloWorldView view];
    _viewController.isgl3DView = view;
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end