//
//  DatosJuegosViewController.h
//  app0100
//
//  Created by encuadro on 3/14/14.
//
//

#import <UIKit/UIKit.h>
#import "ObraCompletaViewController.h"
#import "ReaderSampleViewController.h"
#import "conn.h"

#import "EstadoJuego.h"

@interface DatosJuegosViewController : UIViewController
{
	IBOutlet UITextField *nameInput;
	IBOutlet UILabel *greeting;
	NSMutableData *webData;
	NSMutableString *soapResults;
	NSXMLParser *xmlParser;
	BOOL *recordResults;
    NSString *AuxJuego;
    
}


@property (retain, nonatomic) NSString *VariablePasarIdJuego;
@property (retain, nonatomic) NSString *VariablePasarIdObra;
@property (retain, nonatomic) NSString *IdPistaSiguiente;

@property (nonatomic) NSInteger *Suma;
@property (retain, nonatomic) NSString *Aux1;

@property (retain, nonatomic) NSString *AuxJuego;
@property (retain, nonatomic) NSString *AuxContarObras;
@property (retain, nonatomic) NSString *AuxObrasJuego;
//-(void)obtDatosObraConNombreObra:(NSString*)nombreObra;
//-(void) setApellidos: (NSString *) _Apellidos;

-(void)Juego:(NSString *)VariablePasarIdJuego;


@property (retain, nonatomic) IBOutlet UILabel *lblIdJuego;
@property (retain, nonatomic) IBOutlet UILabel *lblIdObra;
@property (retain, nonatomic) IBOutlet UILabel *lblJuego;
@property (retain, nonatomic) IBOutlet UILabel *lblObraSiguiente;
@property (retain, nonatomic) IBOutlet UILabel *lblContarObra;
@property (retain, nonatomic) IBOutlet UILabel *lblFechaJuego;

@property(nonatomic, retain) IBOutlet UITextField *nameInput;
@property(nonatomic, retain) IBOutlet UILabel *greeting;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;
//@property (nonatomic) int *AuxContarObras;
//@property (nonatomic) int ContarObras;
@property (nonatomic) int AuxSuma;
@property (retain, nonatomic) IBOutlet UILabel *lblObrasTotal;
@property (retain, nonatomic) NSString *ObrasTotal;

@property (retain, nonatomic) NSString *FechaJuego;
@property (retain, nonatomic) NSString *HoraComienzo;
@property (retain, nonatomic) NSString *auxHora;
@property (retain, nonatomic) NSString *HoraFinJuego;
@property (nonatomic) int TotalJuego;

@property (nonatomic, retain) NSString *AuxTipoRecorridoDJVC;


//@property (, nonatomic) IBOutlet UILabel *lblUno;
/*
 @property (nonatomic, strong) NSString *text;
 
 @property (weak, nonatomic) IBOutlet UILabel *label;
 ------
 @property (weak, nonatomic) IBOutlet UILabel *lblUno;
 @property (weak, nonatomic) IBOutlet UILabel *lblDos;
 
 @property (nonatomic, retain) NSString *lblUnoString,  *lblDosString;
 */
- (IBAction)btnCantidadObras:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnCantidadObras;
@property (retain, nonatomic) IBOutlet UIButton *btnIrSalas;
@property (retain, nonatomic) IBOutlet UIButton *btnEscanearObras;

@property (retain,nonatomic) EstadoJuego * juego;

@end
