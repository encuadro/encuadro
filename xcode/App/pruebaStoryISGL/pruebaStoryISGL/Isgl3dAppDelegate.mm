/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "Isgl3dAppDelegate.h"
#import "Isgl3dViewController.h"
#import "Isgl3d.h"
#import "HelloWorldView.h"



@implementation Isgl3dAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;


- (void)applicationDidFinishLaunching:(UIApplication*)application 
{
	NSLog(@"Starting app delegate");
	// Create the UIWindow
	//_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Instantiate the Isgl3dDirector and set background color
	[Isgl3dDirector sharedInstance].backgroundColorString = @"00000000"; 
#ifdef OLD_ISGL3D
	[Isgl3dDirector sharedInstance].autoRotationStrategy = Isgl3dAutoRotationByUIViewController;
	[Isgl3dDirector sharedInstance].allowedAutoRotations = Isgl3dAllowedAutoRotationsPortraitOnly;
#endif
	// Create the UIViewController
	self.viewController = [[Isgl3dViewController alloc] initWithNibName:nil bundle:nil];
	self.viewController.wantsFullScreenLayout = YES;
	
	
#ifdef USE_LATEST_GLES
    // Create OpenGL view with autodetection of the latest available version
	Isgl3dEAGLView * glView = [Isgl3dEAGLView viewWithFrame:[_window bounds]];
#else
	// Create OpenGL ES 1.1 view
    Isgl3dEAGLView * glView = [Isgl3dEAGLView viewWithFrameForES1:[self.window bounds]];
    
#endif
   
   
	
	// Set view in director
	[Isgl3dDirector sharedInstance].openGLView = glView;
    
	// Enable retina display : uncomment if desired
	//[[Isgl3dDirector sharedInstance] enableRetinaDisplay:YES];

	// Enables anti aliasing (MSAA) : uncomment if desired (note may not be available on all devices and can have performance cost)
	//[Isgl3dDirector sharedInstance].antiAliasingEnabled = YES;
	
	// Set the animation frame rate
	[[Isgl3dDirector sharedInstance] setAnimationInterval:2.0/60];

	// Add the OpenGL view to the view controller
	self.viewController.view = glView;

	// Add view to window and make visible
	//[_window addSubview:glView];
	//[_window makeKeyAndVisible];

    HelloWorldView *view = [HelloWorldView view];
	[[Isgl3dDirector sharedInstance] addView:view];
    
	//self.viewController.ui = [ControlPanelView view];
	//[[Isgl3dDirector sharedInstance] addView:self.viewController.ui];
    
    
    self.viewController.mainView = view;
    
  
    
	//[_viewController addChildViewController:m_CameraController];
	//[_viewController addChildViewController:m_MaskController];
    
    
    
    // Create UI and add to Isgl3dDirector
	
	// Creates the view(s) and adds them to the director
	//[self createViews];
	
	// Run the director
	[[Isgl3dDirector sharedInstance] run];
	
	[[Isgl3dDirector sharedInstance] pause];
}

- (void)dealloc {
	if (_viewController) {
		[_viewController release];
	}
	if (_window) {
		[_window release];
	}
	
	[super dealloc];
}

- (void)createViews {
	// Implement in sub-classes
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] resume];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] stopAnimation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] onMemoryWarning];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] onSignificantTimeChange];
}

@end
