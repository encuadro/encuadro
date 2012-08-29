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
@synthesize HWview = _HWview;


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
    NSLog(@"BUTTON CLICKED");
     NSLog(@"BUTTON CLICKED");
     NSLog(@"BUTTON CLICKED");
     NSLog(@"BUTTON CLICKED");
     NSLog(@"BUTTON CLICKED");
     NSLog(@"BUTTON CLICKED");
   // _viewController.AugmReal=false;
    [self removeViews];  
    
    
    
//////////////////////////////////////////////////////    
    
    // applicationWillTerminate
    // applicationWillTerminate
    // applicationWillTerminate
    
    [[Isgl3dDirector sharedInstance].openGLView removeFromSuperview];

	// End and reset the director
	
	//[Isgl3dDirector resetInstance];
	
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
    
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];

    VistaViewController *mainViewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = mainViewController;
    
    //  code to configure the view controller would go here
    
    [_window makeKeyAndVisible];
    
    
}


- (IBAction)hacerRender:(id)sender
{

    
    
    app0dAppDelegate *appDelegate = (app0dAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.viewController=(Isgl3dViewController*)appDelegate.viewController;
    
    //agrego video
    [self.view addSubview:self.viewController.videoView];
    [self.view bringSubviewToFront:self.viewController.videoView];
    
    //agrego render
    [self.view addSubview:self.viewController.view];
    [self.view bringSubviewToFront:self.viewController.view];
    self.viewController.view.opaque = NO;
    
    [self createViews];
    
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
    
    [self.viewController.view removeFromSuperview];
   // [self.view removeFromSuperview:self.HWview];
    _viewController.isgl3DView = nil;
	[[Isgl3dDirector sharedInstance] removeView:self.HWview];
    [self.HWview release];
}



- (void) createViews {
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationPortrait;
    
	// Set the background transparent
	[Isgl3dDirector sharedInstance].backgroundColorString = @"00000000"; 
    
	// Create view and add to Isgl3dDirector
    self.HWview =[[Isgl3dView alloc] init];   
    
	self.HWview = [HelloWorldView view];
    _viewController.isgl3DView = self.HWview;
	[[Isgl3dDirector sharedInstance] addView:self.HWview];
}

//este metodo es igual a buttonclicked
- (void) buttonBACK {
NSLog(@"BUTTON CLICKED");
NSLog(@"BUTTON CLICKED");
NSLog(@"BUTTON CLICKED");
NSLog(@"BUTTON CLICKED");
NSLog(@"BUTTON CLICKED");
NSLog(@"BUTTON CLICKED");
// _viewController.AugmReal=false;
[self removeViews];  



//////////////////////////////////////////////////////    

// applicationWillTerminate
// applicationWillTerminate
// applicationWillTerminate

[[Isgl3dDirector sharedInstance].openGLView removeFromSuperview];

// End and reset the director

//[Isgl3dDirector resetInstance];

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


//_vistaImg =[[UIImageView alloc] init];
//
//_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

//UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//
//VistaViewController *mainViewController = [storyboard instantiateInitialViewController];
//self.window.rootViewController = mainViewController;

//  code to configure the view controller would go here

//[_window makeKeyAndVisible];


}




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Override back button action
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"backacka" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonClicked:)];
//    
//    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = item;
//    [item release];
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
  //  [self action:@selector(buttonClicked:)];

//[self buttonBACK];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        //[self.delegate setParentSelectedCity:self.selectedCity];
        [self buttonBACK];
    }
    [super viewWillDisappear:animated];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//   // [self.navigationController setNavigationBarHidden:YES animated:animated];
//    
//    [self buttonBACK];
//}
//
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    
//   // [self.navigationController setNavigationBarHidden:NO animated:animated];
//}






- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
