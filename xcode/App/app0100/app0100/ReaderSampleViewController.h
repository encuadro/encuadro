//
//  ReaderSampleViewController.h
//  ReaderSample
//
//  Created by spadix on 4/14/11.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import <AVFoundation/AVFoundation.h>
#import "CuadroTableViewController.h"
#import "app0cAppDelegate.h"


int click;
NSString *room;
NSString *cad;

@interface ReaderSampleViewController
    : UIViewController
    // ADD: delegate protocol
< ZBarReaderDelegate > 

{
    UIImageView *resultImage;
    UITextView *resultText;

    
   // UITextView *resultSite;
}
@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
@property (nonatomic, retain) IBOutlet UITextView *resultText;
@property (nonatomic, retain) IBOutlet NSString *site;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) UIButton *start;




- (IBAction) scanButtonTapped;
//- (IBAction) enCuadroSite: (id) sender;  
- (IBAction) play;

@end
