//
//  VistaViewController.m
//  demo05
//
//  Created by encuadro augmented reality on 7/21/12.
//  Copyright (c) 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#import "VistaViewController.h"



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
    NSLog(@"INIT VISTA");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self addChildViewController:_viewController];
        [Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeRight;
        // Specify auto-rotation strategy if required (for example via the UIViewController and only landscape)
        [Isgl3dDirector sharedInstance].autoRotationStrategy =Isgl3dAutoRotationByUIViewController;
        [Isgl3dDirector sharedInstance].allowedAutoRotations = Isgl3dAllowedAutoRotationsLandscapeOnly;
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


//- (IBAction)hacerRender:(id)sender
- (void) hacerRender 
{
    NSLog(@"HACER RENDER VISTA");
    app0100AppDelegate *appDelegate = (app0100AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.viewController=(Isgl3dViewController*)appDelegate.viewController;
    
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    [_viewController viewDidLoad];
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////

    
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
    
//    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [self.button addTarget:self 
//               action:@selector(buttonClicked:)
//     forControlEvents:UIControlEventTouchDown];
//    [self.button setTitle:@"Back to Story" forState:UIControlStateNormal];
//    self.button.frame = CGRectMake(50,50, 120.0, 50.0);
//    [self.viewController.view addSubview:self.button];
  

    ////////BOTON
    
   // [[Isgl3dDirector sharedInstance] startAnimation];
}


- (void) hacerRenderPro
{
 
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSLog(@"hacerRender PRO VISTA");
    
    //    isglYAVFoundProAppDelegate *appDelegate = (isglYAVFoundProAppDelegate *)[[UIApplication sharedApplication] delegate];
    //     NSLog(@"appdelegate1");
    //    self.viewController=(Isgl3dViewController*)appDelegate.viewController;
    //     NSLog(@"appdelegate2");
    self.viewController=[[Isgl3dViewController alloc] init];
    self.viewController.wantsFullScreenLayout=YES;
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    
    [_window makeKeyAndVisible];
    
    Isgl3dEAGLView * glView = [Isgl3dEAGLView viewWithFrameForES1:[_window bounds]];
    [Isgl3dDirector sharedInstance].openGLView = glView;
    _viewController.view = glView;
    [_window addSubview:glView];
    [self createViews];
    [self.viewController createVideoWindow:_window];
    [self.viewController viewDidLoad];
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    //    UIView* vista =self.viewController.view;
    //    UIView* vista2=self.view;
    //    [self.view addSubview:vista];
    //
    //    [self.view bringSubviewToFront:vista];
    //    [self.view sendSubviewToBack:vista2];
    
    //    //agrego video
    //    [self.view addSubview:self.viewController.videoView];
    //    [self.view bringSubviewToFront:self.viewController.videoView];
    //
    //    //agrego render
    //    [self.view addSubview:self.viewController.view];
    //    [self.view bringSubviewToFront:self.viewController.view];
    //    self.viewController.view.opaque = NO;
    //
    //    [self createViews];
    //
    //    //activo procesamiento
    //   // _viewController.AugmReal=true;
    
    
    ////////BOTON
    
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.button addTarget:self
                   action:@selector(buttonClicked:)
         forControlEvents:UIControlEventTouchDown];
        [self.button setTitle:@"Back to Story" forState:UIControlStateNormal];
        self.button.frame = CGRectMake(50,50, 120.0, 50.0);
        [_window addSubview:self.button];
    
    
    ////////BOTON
    
    // [[Isgl3dDirector sharedInstance] startAnimation];
}


- (void) removeViews {
	   
    NSLog(@"REMOVE VIEWS VISTA");
	// Create view and add to Isgl3dDirector
	//Isgl3dView * view = [HelloWorldView view];
    
    [self.viewController.view removeFromSuperview];
   // [self.view removeFromSuperview:self.HWview];
    _viewController.isgl3DView = nil;
	[[Isgl3dDirector sharedInstance] removeView:self.HWview];
    [self.HWview release];
}



- (void) createViews {
    printf("CREATE VIEWS\n");
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;
    
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
NSLog(@"BUTTON BACK");
NSLog(@"BUTTON BACK");
NSLog(@"BUTTON BACK");
NSLog(@"BUTTON BACK");
NSLog(@"BUTTON BACK");
NSLog(@"BUTTON BACK");
// _viewController.AugmReal=false;

    [self removeViews];

    [self.viewController.session stopRunning];


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
    NSLog(@"VIEW DID LOAD VISTA");
    //NSLog(@"ARID OBRA ES: %@",self.ARidObra);
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

//- (void)viewWillDisappear:(BOOL)animated
//{
//    NSLog(@"TERMINANDO AR");
//    NSLog(@"TERMINANDO AR");
//    NSLog(@"TERMINANDO AR");
//    NSLog(@"TERMINANDO AR");
//    
//    [self buttonBACK];
////    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
////        //[self.delegate setParentSelectedCity:self.selectedCity];
////        NSLog(@"TERMINANDO AR");
////        NSLog(@"TERMINANDO AR");
////        NSLog(@"TERMINANDO AR");
////        NSLog(@"TERMINANDO AR");
////        
////        [self buttonBACK];
////    }
//    [super viewWillDisappear:animated];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
   // [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self buttonBACK];
}
//
//
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"VIEW WILL APPEAR VISTA");
    [super viewWillAppear:animated];
    [self hacerRender];
    
   // [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
 
    NSLog(@"WILL Autorotate VISTA");
    [_viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{


     NSLog(@"DID Autorotate VISTA");

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"SHOULD Autorotate VISTA");
    return YES;
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//    [_viewController willRotateToInterfaceOrientation:interfaceOrientation duration:0.2];
//    BOOL autorotate;
//    autorotate=[_viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
//    return autorotate;
    
    
    
}

@end
