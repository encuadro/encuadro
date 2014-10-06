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
#import "app0100AppDelegate.h"
#import "obtSalas.h"
#import "ImagenServerViewController.h"
#import "DatosJuegosViewController.h"

#import "EstadoJuego.h"

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
    IBOutlet UILabel *nombreSala;
    
   // UITextView *resultSite;
}
@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
@property (nonatomic, retain) IBOutlet UITextView *resultText;
@property (nonatomic, retain) IBOutlet NSString *site;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) UIButton *start;
@property (assign) IBOutlet UIImageView *backround;
@property (nonatomic, retain) IBOutlet UILabel *nombreSala;
@property (nonatomic,retain) NSString *string;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *identObra;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *tweet;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actInd;
- (IBAction) scanButtonTapped;
//- (IBAction) enCuadroSite: (id) sender;  
- (IBAction) play;
-(IBAction)tweeti;
//tipo recorrido
@property (nonatomic, retain) NSString *AuxTipoRecorridoSVC;
//variables juego
@property (nonatomic, retain) NSString *AuxSiguientePEscanear;
@property (nonatomic, retain) NSString *AuxJEscanear;
@property (nonatomic, retain) NSString *AuxContarJEscanear;
@property (nonatomic, retain) NSString *AuxHoraJEscanear;

@property (retain,nonatomic) EstadoJuego * juego;

@end
