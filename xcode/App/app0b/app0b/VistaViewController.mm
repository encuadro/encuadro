//
//  VistaViewController.m
//  demo05
//
//  Created by encuadro augmented reality on 7/21/12.
//  Copyright (c) 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#import "VistaViewController.h"
#import "Isgl3dViewController.h"
#import "HelloWorldView.h"
#import "Isgl3d.h"


@interface VistaViewController ()

@end

@implementation VistaViewController
@synthesize window = _window;
@synthesize vistaStory = _vistaStory;
@synthesize vistaImg =_vistaImg;
@synthesize button = _button;


@synthesize viewController = _viewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)buttonClicked:(id)sender{
    
    _viewController.AugmReal=false;
    [self removeViews];  
    
    
    
//////////////////////////////////////////////////////    
    
    // applicationWillTerminate
    // applicationWillTerminate
    // applicationWillTerminate
    
    [[Isgl3dDirector sharedInstance].openGLView removeFromSuperview];
	
	// End and reset the director
	
	[Isgl3dDirector resetInstance];
	
	// Release
	[_viewController release];
	_viewController = nil;
	[_window release];
	_window = nil;
    
    
    // applicationWillTerminate
    // applicationWillTerminate
    // applicationWillTerminate

    
//////////////////////////////////////////////////////    
    [[Isgl3dDirector sharedInstance] resume];
    
    
    //self.view=Nil;

    
    [_button release];
    _button=nil;
    
        
    _vistaImg =[[UIImageView alloc] init];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    VistaViewController *mainViewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = mainViewController;
    
    //  code to configure the view controller would go here
    
    [_window makeKeyAndVisible];
    
    
}


- (IBAction)hacerRender:(id)sender
{

    
    
    app0bAppDelegate *appDelegate = (app0bAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.viewController=(Isgl3dViewController*)appDelegate.viewController;
    
    //agrego video
    [self.view addSubview:self.viewController.videoView];
    [self.view bringSubviewToFront:self.viewController.videoView];
    
    //agrego render
    [self.view addSubview:self.viewController.view];
    [self.view bringSubviewToFront:self.viewController.view];
    self.viewController.view.opaque = NO;

    //activo procesamiento
   // _viewController.AugmReal=true;
    
    
    ////////BOTON
    
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button addTarget:self 
               action:@selector(buttonClicked:)
     forControlEvents:UIControlEventTouchDown];
    [self.button setTitle:@"Back to Story" forState:UIControlStateNormal];
    self.button.frame = CGRectMake(50,50, 120.0, 50.0);
    [self.viewController.view addSubview:self.button];
  

    ////////BOTON
    
    
}


- (void) removeViews {
	    
	// Create view and add to Isgl3dDirector
	//Isgl3dView * view = [HelloWorldView view];
    _viewController.isgl3DView = nil;
	[[Isgl3dDirector sharedInstance] removeView:_viewController.isgl3DView];
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
