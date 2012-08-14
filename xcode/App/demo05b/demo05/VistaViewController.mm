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



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)buttonClicked:(id)sender{
    self.view=NULL;
    [_window release];
    [_vistaImg release];
    _vistaImg =[[UIImageView alloc] init];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    VistaViewController *mainViewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = mainViewController;
    
    //  code to configure the view controller would go here
    
    [_window makeKeyAndVisible];
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    //[[Isgl3dDirector sharedInstance] pause];
    [[Isgl3dDirector sharedInstance] end];
    
    
    
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
//	_viewController = [[Isgl3dViewController alloc] initWithNibName:nil bundle:nil];
	_viewController.wantsFullScreenLayout = YES;
	
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
    self.view = glView;
    
	// Add view to window and make visible
    /* Esto es basicamente hacer el linkeo con flechitas*/
    [_window addSubview:glView];
	[_window makeKeyAndVisible];
    
    // Creates the view(s) and adds them to the director
	
    [self createViews];
    
	[[Isgl3dDirector sharedInstance] run];
    /*-------------------------------------------------------------------------------------------------------------------------------------------*/
    
    
    //UIImageView* vistaImg = [[UIImageView alloc] init];
    //  vistaImg.image = [UIImage imageNamed:@"Calibrar10.jpeg"];
    
    
    //vistaImg.transform =CGAffineTransformMake(0, 1, -1, 0, 0, 0);  
    /* Se ajusta la pantalla*/
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds; 
    
    printf("%f \t %f\n",fullScreenRect.size.width, fullScreenRect.size.height);
    [_vistaImg setCenter:CGPointMake(fullScreenRect.size.width/2, fullScreenRect.size.height/2)];  
    [_vistaImg setBounds:fullScreenRect];
    
    
    
    //    [vistaImg setNeedsDisplay];
    
    
    [_window addSubview:_vistaImg];
	[_window sendSubviewToBack:_vistaImg];
    
    
    _viewController.videoView = _vistaImg;
    
    
	// Make the opengl view transparent
	[Isgl3dDirector sharedInstance].openGLView.backgroundColor = [UIColor clearColor];
	[Isgl3dDirector sharedInstance].openGLView.opaque = NO;
    
    /*-------------------------------------------------------------------------------------------------------------------------------------------*/
    /*Corremos el metodo viewDidLoad del ViewController*/
    
    //    [[Isgl3dDirector sharedInstance] pause];
    //    [[Isgl3dDirector sharedInstance] end];
 
    ////////BOTON
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self 
               action:@selector(buttonClicked:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Back to Story" forState:UIControlStateNormal];
    button.frame = CGRectMake(50,50, 120.0, 50.0);
    [_window addSubview:button];
    
    ////////BOTON
    
   // [self.view addSubview:_viewController.view];    
    [_viewController viewDidLoad];
    


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
   // self.view=_viewController.view;
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
