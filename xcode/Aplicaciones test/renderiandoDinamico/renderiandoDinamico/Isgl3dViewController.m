//
//  Isgl3dViewController.m
//  renderiandoDinamico
//
//  Created by Pablo Flores Guridi on 18/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Isgl3dViewController.h"
#import "isgl3d.h"


@interface Isgl3dViewController()




@end

@implementation Isgl3dViewController

@synthesize isgl3DView = _isgl3DView;
@synthesize imagenView = _imagenView;

int numero;

- (void) dealloc {
    [super dealloc];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
	isgl3dAllowedAutoRotations allowedAutoRotations = [Isgl3dDirector sharedInstance].allowedAutoRotations;
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
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	if ([Isgl3dDirector sharedInstance].autoRotationStrategy == Isgl3dAutoRotationByUIViewController) {
		CGRect screenRect = [[UIScreen mainScreen] bounds];
		CGRect rect = CGRectZero;
		
		if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			rect = screenRect;
            
		} else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
		}
		
		UIView * glView = [Isgl3dDirector sharedInstance].openGLView;
		float contentScaleFactor = [Isgl3dDirector sharedInstance].contentScaleFactor;
        
		if (contentScaleFactor != 1) {
			rect.size.width *= contentScaleFactor;
			rect.size.height *= contentScaleFactor;
		}
		glView.frame = rect;
	}
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) viewDidLoad{
    
    [super viewDidLoad];
    numero = 0;
   [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(setearFondos:) userInfo:nil repeats:YES];
    //[self setearFondos:numero];
    
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setearFondos: (NSTimer*) timer
{

    switch (numero) {
        case 0:
            self.imagenView.image = [UIImage imageNamed:@"marker_0000.png"];
            [self.isgl3DView cambiarCubos:0];
            break;
            
        case 1:
            self.imagenView.image = [UIImage imageNamed:@"marker_0001.png"];
            [self.isgl3DView cambiarCubos:1];
            break;
        case 2:
            self.imagenView.image = [UIImage imageNamed:@"marker_0002.png"];
            [self.isgl3DView cambiarCubos:2];
            break;
            
        case 3:
            self.imagenView.image = [UIImage imageNamed:@"marker_0003.png"];
            [self.isgl3DView cambiarCubos:3];
            break;
        case 4:
            self.imagenView.image = [UIImage imageNamed:@"marker_0004.png"];
            [self.isgl3DView cambiarCubos:4];
            break;
            
        case 5:
            self.imagenView.image = [UIImage imageNamed:@"marker_0005.png"];
            [self.isgl3DView cambiarCubos:5];
            break;
        case 6:
            self.imagenView.image = [UIImage imageNamed:@"marker_0006.png"];
            [self.isgl3DView cambiarCubos:6];
            break;
        case 7:
            self.imagenView.image = [UIImage imageNamed:@"marker_0007.png"];
            [self.isgl3DView cambiarCubos:7];
            break;
            
        case 8:
            self.imagenView.image = [UIImage imageNamed:@"marker_0008.png"];
            [self.isgl3DView cambiarCubos:8];
            break;

    }
    if (numero<8) numero++;
    else numero = 0;

}

@end


