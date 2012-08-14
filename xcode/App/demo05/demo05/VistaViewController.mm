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
#import "demo05AppDelegate.h"

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
    
    
    self.view=Nil;
   //[self.viewController.session startRunning];
     self.viewController.finAvCapture=true;
    self.viewController.liberar=false;
    self.viewController=Nil;
    self.viewController.liberar=false;
    [_window release];
    [_vistaImg release];
    [_viewController release];
    self.viewController.liberar=false;
    [_button release];
    
    
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

    // Create the UIWindow
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Instantiate the Isgl3dDirector and set background color
	[Isgl3dDirector sharedInstance].backgroundColorString = @"333333ff"; 
    
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;
    
	// Set the director to display the FPS
	[Isgl3dDirector sharedInstance].displayFPS = YES; 
    
	// Create the UIViewController
    /*El init que se esta invocando es el del padre UIViewController*/
	self.viewController = [[Isgl3dViewController alloc] initWithNibName:nil bundle:nil];
	self.viewController.wantsFullScreenLayout = YES;
	self.viewController.liberar=true;//para correr la aplicacion normalmente liberando la memoria
    self.viewController.finAvCapture=false;
    
    
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
    self.viewController.view = glView;
    
	// Add view to window and make visible
    /* Esto es basicamente hacer el linkeo con flechitas*/
    [_window addSubview:glView];
	[_window makeKeyAndVisible];
    
    // Creates the view(s) and adds them to the director
	
    [self createViews];
    
	[[Isgl3dDirector sharedInstance] run];
    /*-------------------------------------------------------------------------------------------------------------------------------------------*/
    
    
    self.vistaImg = [[UIImageView alloc] init];
    //  vistaImg.image = [UIImage imageNamed:@"Calibrar10.jpeg"];
    
    
    //vistaImg.transform =CGAffineTransformMake(0, 1, -1, 0, 0, 0);  
    /* Se ajusta la pantalla*/
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds; 
    
    printf("%f \t %f\n",fullScreenRect.size.width, fullScreenRect.size.height);
    [self.vistaImg setCenter:CGPointMake(fullScreenRect.size.width/2, fullScreenRect.size.height/2)];  
    [self.vistaImg setBounds:fullScreenRect];
    
    
    
    //    [vistaImg setNeedsDisplay];
    
    
    [self.window addSubview:self.vistaImg];
	[self.window sendSubviewToBack:self.vistaImg];
    
    
    _viewController.videoView = self.vistaImg;
    
    
	// Make the opengl view transparent
	[Isgl3dDirector sharedInstance].openGLView.backgroundColor = [UIColor clearColor];
	[Isgl3dDirector sharedInstance].openGLView.opaque = NO;
    
    /*-------------------------------------------------------------------------------------------------------------------------------------------*/
//    [[Isgl3dDirector sharedInstance] pause];
//    [[Isgl3dDirector sharedInstance] end];
    /*Corremos el metodo viewDidLoad del ViewController*/
    
    
    [_viewController viewDidLoad];

    
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
