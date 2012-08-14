//
//  Isgl3dViewController.m
//  test-isgl3d-1
//
//  Created by Juan Cardelino on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Isgl3dViewController.h"
#import "isgl3d.h"
#import "HelloWorldView.h"

#import "GameViewController.h"

@implementation Isgl3dViewController

@synthesize mainView=_mainView;
@synthesize ui=_ui;
@synthesize uiView=_uiView;

- (void) dealloc {   
	NSLog(@"View Controller dealloc");
    [super dealloc];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"Isgl3dViewController:: shouldAutorotateToInterfaceOrientation : ");
#ifdef OLD_ISGL3D
	//isgl3dAllowedAutoRotations allowedAutoRotations = false;
	isgl3dAllowedAutoRotations allowedAutoRotations = [Isgl3dDirector sharedInstance].allowedAutoRotations;
	//[Isgl3dDirector sharedInstance].autoRotationStrategy = Isgl3dAutoRotationNone;
	if ([Isgl3dDirector sharedInstance].autoRotationStrategy == Isgl3dAutoRotationNone) {
		return NO;
        
	} else if ([Isgl3dDirector sharedInstance].autoRotationStrategy == Isgl3dAutoRotationByIsgl3dDirector) {
		
		if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft && allowedAutoRotations != Isgl3dAllowedAutoRotationsPortraitOnly) {
			[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeRight;
            
		} else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight && allowedAutoRotations != Isgl3dAllowedAutoRotationsPortraitOnly) {
			[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;
            
		} else if (interfaceOrientation == UIInterfaceOrientationPortrait && allowedAutoRotations != Isgl3dAllowedAutoRotationsLandscapeOnly) {
			[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationPortrait;
            
		} else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown && allowedAutoRotations != Isgl3dAllowedAutoRotationsLandscapeOnly) {
			[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationPortraitUpsideDown;
		}
        
		// Return true only for portrait
		return  (interfaceOrientation == UIInterfaceOrientationPortrait);
        
	} else if ([Isgl3dDirector sharedInstance].autoRotationStrategy == Isgl3dAutoRotationByUIViewController) {
		if (UIInterfaceOrientationIsLandscape(interfaceOrientation) && allowedAutoRotations != Isgl3dAllowedAutoRotationsPortraitOnly) {
			return YES;
			
		} else if (UIInterfaceOrientationIsPortrait(interfaceOrientation) && allowedAutoRotations != Isgl3dAllowedAutoRotationsLandscapeOnly) {
			return YES;
			
		} else {
			return NO;
		}
		
	} else {
		NSLog(@"Isgl3dViewController:: ERROR : Unknown auto rotation strategy of Isgl3dDirector.");
		return NO;
	}
#else
	return NO;
#endif
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	NSLog(@"Isgl3dViewController:: willRotateToInterfaceOrientation");
	CGRect rect = CGRectZero;
	UIView * glView = [Isgl3dDirector sharedInstance].openGLView;
#ifdef OLD_ISGL3D
	if ([Isgl3dDirector sharedInstance].autoRotationStrategy == Isgl3dAutoRotationByUIViewController) {
		CGRect screenRect = [[UIScreen mainScreen] bounds];
		
		
		if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {		
			rect = screenRect;
            
		} else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
		}
		
		
		float contentScaleFactor = [Isgl3dDirector sharedInstance].contentScaleFactor;
		
		if (contentScaleFactor != 1) {
			rect.size.width *= contentScaleFactor;
			rect.size.height *= contentScaleFactor;
		}
        
	}
	//rect.size.width=50;
	//rect.size.height=50;
	glView.frame = rect;
#endif
	//FIXME: this should not be an explicit call
#if 0
	NSArray *children=[self childViewControllers];
	UIViewController *vc=[children lastObject];
	[vc willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	vc=[children objectAtIndex:0];
	[vc willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
#endif
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL) automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers
{
	return YES;
}





#ifdef IFC_OLD_UI

- (void)displayEndGame2:(NSString *)msg
{
	[self.ui setMainMessage:msg];
	
	self.mainView.pause_menu_background.isVisible=YES;
	self.mainView.pause_menu_foreground.isVisible=YES;
	
	[[Isgl3dDirector sharedInstance] pause];
}


- (void)displayStartGame2
{
	NSLog(@"displayStartGame");
	[self.ui clearMessage];
	
	self.mainView.pause_menu_background.isVisible=NO;
	self.mainView.pause_menu_foreground.isVisible=NO;
	
	//[[Isgl3dDirector sharedInstance] pause];
}
#endif
@end
