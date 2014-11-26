//
//  ObraCompletaViewController.h
//  TableViewStory
//
//  Created by encuadro augmented reality on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VistaViewController.h"

#import "Isgl3dViewController.h"
#import "Isgl3d.h"
#import "app0100AppDelegate.h"
#import "HelloWorldView.h"

#import "TouchVista.h"
#import "DrawSign.h"
#import "AutorTableViewController.h"
//#import "Pista.h"
#import "DatosJuegosViewController.h"

#import "EstadoJuego.h"
#import "Parser.h"
#import "conn.h"


int click;
bool justLoaded;
bool manual;
bool conUpsi;
NSMutableArray *descripcionObra;
@interface ObraCompletaViewController : UIViewController{
    //
    IBOutlet UITextField *nameInput;
    IBOutlet UILabel *greeting;
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSXMLParser *xmlParser;
    BOOL *recordResults;
    //
    IBOutlet UIActivityIndicatorView *actInd;
    IBOutlet UIBarButtonItem *start;
    IBOutlet UIBarButtonItem *AR;
    IBOutlet UIBarButtonItem *tw;
}
@property (retain, nonatomic) IBOutlet UILabel *autor;
@property (retain, nonatomic) IBOutlet UILabel *obra;
@property (retain, nonatomic) IBOutlet UITextView *detalle;
@property (retain, nonatomic) IBOutlet UITextView *texto;
@property (retain, nonatomic) IBOutlet UIImageView *imagenObra;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *actInd;
@property (assign) IBOutlet UIImageView *mano1;
@property (assign) IBOutlet UIImageView *mano4;
@property (assign) IBOutlet UIImageView *upsi;
@property (nonatomic, retain) TouchVista *vistaTouch;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *start;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *AR;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *tw;
@property (nonatomic, retain) NSMutableArray *descripcionObra;
- (IBAction) play;
-(IBAction)tweet;
//
@property(nonatomic, retain) IBOutlet UITextField *nameInput;
@property(nonatomic, retain) IBOutlet UILabel *greeting;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;

@property(nonatomic, retain) NSString *AyudaPista;
@property(nonatomic, retain) NSString *IdObraPista;
- (IBAction)btnPista:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *txtPista;
@property (retain, nonatomic) IBOutlet UITextField *txtJuego;

@property(nonatomic, retain) NSString *aux;
@property(nonatomic, retain) NSString *auxidpista;
@property(nonatomic, retain) NSString *BusquedaPista;
//
@property(nonatomic) NSInteger *pis1;
@property(nonatomic) NSInteger *pis2;
@property(nonatomic) NSInteger *AuxSuma;

@property(nonatomic, retain) NSString *pis3;
@property(nonatomic, retain) NSString *auxpista;
@property(nonatomic, retain) NSString *idsiguiente;
- (IBAction)btnPista2:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *txtObtenerPista;
//botones
@property (retain, nonatomic) IBOutlet UIButton *btnPista;
@property (retain, nonatomic) IBOutlet UIButton *btnObtPista;
//
- (IBAction)btnRepetirPista:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnRepetirPista;
//extern NSString * const STR_1;

//extern NSString *Jugando;
@property (nonatomic, retain) NSString *Cantidad;

@property(nonatomic, retain) NSString *ContarObrasJuego;

//@property (nonatomic, copy) NSString *AuxCantidad;
//extern NSString *AuxCantidad;

- (IBAction)btnDatosJuegos:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblPista;
//
@property(nonatomic, retain) NSString *IdPistaSiguiente;
@property(nonatomic, retain) NSString *AuxPistaSiguiente;
@property(nonatomic, retain) NSString *AuxJuego;
@property (retain, nonatomic) IBOutlet UITextField *txtObraSiguiente;
//
@property (nonatomic, retain) NSString *AuxJuegoId;
@property (nonatomic, retain) NSString *AuxIdPistaSiguiente;
@property (nonatomic, retain) NSString *AuxIdObra;
@property (nonatomic) int ContarObras;
@property (nonatomic, retain) NSString *AuxContarO;
@property (retain, nonatomic) IBOutlet UITextField *TxtComparar;
@property (retain, nonatomic) IBOutlet UIButton *btnEstadoJuego;
@property (retain, nonatomic) NSString *HoraJuego;
@property (retain, nonatomic) NSString *AuxTipoRecorridoOCVC;
//
@property (retain, nonatomic) NSString *Auxiliar;

@property(retain,nonatomic) EstadoJuego *juego;
@property(retain,nonatomic) Parser * parsed;
@property (retain,nonatomic) NSString * nombreObra;

@property(nonatomic, retain) NSString *pedidoActual;
@end



