//
//  PauseMenuViewController.h
//  simon2
//
//  Created by Juan Cardelino on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIView *foregroundMenuView;
@property (retain, nonatomic) IBOutlet UIView *backgroundMenuView;
@property (retain, nonatomic) IBOutlet UIView *hudView;
@property (retain, nonatomic) IBOutlet UIView *levelEndedView;
@property (retain, nonatomic) IBOutlet UIView *levelStartedView;
@property (retain, nonatomic) IBOutlet UIView *gameEndedView;

@property (retain, nonatomic) IBOutlet UILabel *hudLabel;

@property (nonatomic, assign) int level;

- (IBAction) startGameTime;
- (IBAction) exitButton;
- (IBAction) showPauseMenu;
- (IBAction) skipLevel;
- (IBAction) resumePause;
- (IBAction) continueToNextLevel;
- (IBAction) buttonAugment;


- (IBAction)cameraLeft:(id)sender;
- (IBAction)cameraRight:(id)sender;
- (IBAction)cameraL:(id)sender;
- (IBAction)cameraR:(id)sender;


- (void) updateHUD:(NSString *)msg;



@end
