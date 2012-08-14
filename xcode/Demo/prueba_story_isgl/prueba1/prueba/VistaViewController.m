//
//  VistaViewController.m
//  prueba
//
//  Created by encuadro augmented reality on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "pruebaAppDelegate.h"
#import "VistaViewController.h"
#import "Isgl3dViewController.h"
#import "HelloWorldView.h"
#import "Isgl3d.h"

@interface VistaViewController ()

@end

@implementation VistaViewController
@synthesize window = _window;
@synthesize vistaStory = _vistaStory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)buttonClicked:(id)sender{
    [_window release];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    VistaViewController *mainViewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = mainViewController;
    
    //  code to configure the view controller would go here
    
    [_window makeKeyAndVisible];
    

    

    //   [self dismissViewControllerAnimated:YES completion:NULL];

       [[Isgl3dDirector sharedInstance] end];



}
- (IBAction)hacerRender:(id)sender
{
    //respaldo vista story
    self.vistaStory=self.view;
    
    // Create the UIWindow
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];    
    
    // Create OpenGL view (here for OpenGL ES 1.1)
	Isgl3dEAGLView * glView = [Isgl3dEAGLView viewWithFrameForES1:[_window bounds]];
    
	// Set view in director
	[Isgl3dDirector sharedInstance].openGLView = glView;

    // Specify auto-rotation strategy if required (for example via the UIViewController and only landscape)
	[Isgl3dDirector sharedInstance].autoRotationStrategy = Isgl3dAutoRotationByUIViewController;
	[Isgl3dDirector sharedInstance].allowedAutoRotations = Isgl3dAllowedAutoRotationsLandscapeOnly;
	
	// Enable retina display : uncomment if desired
    //	[[Isgl3dDirector sharedInstance] enableRetinaDisplay:YES];
    
	// Enables anti aliasing (MSAA) : uncomment if desired (note may not be available on all devices and can have performance cost)
    //	[Isgl3dDirector sharedInstance].antiAliasingEnabled = YES;
	
	// Set the animation frame rate
	[[Isgl3dDirector sharedInstance] setAnimationInterval:1.0/30];
    
	// Add the OpenGL view to the view controller
	self.view = glView;
    
    ////////BOTON
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self 
               action:@selector(buttonClicked:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Back to Story" forState:UIControlStateNormal];
    button.frame = CGRectMake(50, 50, 120.0, 50.0);
    [self.view addSubview:button];
    ////////BOTON
    
    
    
    // Add view to window and make visible
    //	[_window addSubview:_viewController.view];
    //	[_window makeKeyAndVisible];
    
	// Creates the view(s) and adds them to the director
	 [[Isgl3dDirector sharedInstance] addView:[HelloWorldView view]];
	
    
    //    VistaViewController *vistaStory=[[VistaViewController alloc] init];
    //    [_window addSubview:vistaStory.view];
    //	[_window sendSubviewToBack:_viewController.view];
    //    [_window bringSubviewToFront:vistaStory.view];
    
    // Run the director
	[[Isgl3dDirector sharedInstance] run];

    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
