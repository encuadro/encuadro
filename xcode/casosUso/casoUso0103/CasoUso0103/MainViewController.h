//
//  MainViewController.h
//  casoUso0102
//
//  Created by Juan Ignacio Braun on 10/19/12.
//
//

#import <UIKit/UIKit.h>
#import "Isgl3dViewController.h"
#import "casoUso0103AppDelegate.h"
#import "HelloWorldView.h"
#import <UIKit/UIView.h>

@interface MainViewController : UIViewController

@property (nonatomic, retain) UIWindow * window;
@property (nonatomic, retain) Isgl3dViewController <AVCaptureVideoDataOutputSampleBufferDelegate> * viewController;
@property (nonatomic,retain) Isgl3dView * HWview;
@property (nonatomic,retain) IBOutlet UIView* controlsView;





@end
