//
//  EncuestaViewController.h
//  app0100
//
//  Created by encuadro on 2/19/14.
//
//
// -----

#import <UIKit/UIKit.h>
#import "AutorTableViewController.h"
//#import "conn.h"

@interface EncuestaViewController : UIViewController
{
    IBOutlet UIView *vista2;
	IBOutlet UITextField *nameInput;
	IBOutlet UILabel *greeting;
	NSMutableData *webData;
	NSMutableString *soapResults;
	NSXMLParser *xmlParser;
	BOOL *recordResults;
    IBOutlet UITextField *txtTipoVisita;
    IBOutlet UITextField *txtNacionalidad;
    IBOutlet UITextField *txtSexo;
    IBOutlet UITextField *txtRangoEdad;
}




@property(nonatomic, retain) IBOutlet UITextField *nameInput;
@property(nonatomic, retain) IBOutlet UILabel *greeting;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;


@property (retain, nonatomic) IBOutlet UISegmentedControl *SegTipoVisita;
@property (retain, nonatomic) IBOutlet UITextField *txtTipoVisita;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segNacionalidad;
@property (retain, nonatomic) IBOutlet UITextField *txtNacionalidad;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segSexo;
@property (retain, nonatomic) IBOutlet UITextField *txtSexo;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segRangoEdad;
@property (retain, nonatomic) IBOutlet UITextField *txtRangoEdad;


//@property (strong, nonatomic) IBOutlet UISegmentedControl *segCuestionario;
//@property (nonatomic, retain) IBOutlet UITextField *txtCuestionario;
-(IBAction) segmentedControlIndexTipoVisita;
-(IBAction) segmentedControlIndexNacionalidad;
-(IBAction) segmentedControlIndexSexo;
-(IBAction) segmentedControlIndexRangoEdad;
//-(IBAction) segmentedControlIndexCuestionario;
//probando vistas
//- (IBAction)btnVista2;
- (IBAction)btnPrueba:(id)sender;
- (IBAction)buttonClick:(id)sender;




@end
