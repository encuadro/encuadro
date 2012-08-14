//
//  Isgl3dViewController.h
//  test-isgl3d-1
//
//  Created by Juan Cardelino on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HelloWorldView.h"

@class HelloWorldView;
@class ControlPanelView;

@interface Isgl3dViewController : UIViewController {

	//ControlPanelView *_ui; 


}
@property (nonatomic,retain) HelloWorldView *mainView;
@property (nonatomic,retain) ControlPanelView *ui;
@property (nonatomic,retain) UIView *uiView;

- (BOOL) automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers;



#ifdef IFC_OLD_UI
#endif

@end
