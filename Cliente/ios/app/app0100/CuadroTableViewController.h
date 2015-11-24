//
//  CuadroTableViewController.h
//  TableViewStory
//
//  Created by encuadro augmented reality on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CuadroTableViewCell.h"
#import "ObraCompletaViewController.h"
#import "AutorTableViewController.h"
#import "EstadoJuego.h"
#import "Configuracion.h"
//#import "conn.h"
//#import "Global.h"

NSString *opcionAutor;
/* opcionAutor
1--> Blanes
2--> Figari
3--> Torres Garcia
else-->Todos los autores 
 
*/

@interface CuadroTableViewController : UITableViewController{
    IBOutlet UIActivityIndicatorView *actInd;
    IBOutlet UITableView *tableView;
    //
    IBOutlet UITextField *nameInput;
    IBOutlet UILabel *greeting;
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSXMLParser *xmlParser;
    BOOL *recordResults;
    NSString *AyudaPista;
    NSString *Nan;
}

@property (nonatomic, retain) NSArray *cuadroImages;
@property (nonatomic, retain) NSArray *cuadroAutor;
@property (nonatomic, retain) NSArray *cuadroObra;
@property (nonatomic, retain) NSArray *cuadroDescripcion;
@property (nonatomic, retain) NSArray *nombre_audio;
@property (nonatomic, retain) NSArray *ARid;
@property (nonatomic, retain) NSArray *ARType; //modelo, animacion, video
@property (nonatomic, retain) NSArray *ARObj;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actInd;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
//
@property(nonatomic, retain) IBOutlet UITextField *nameInput;
@property(nonatomic, retain) IBOutlet UILabel *greeting;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSString *AyudaPista;
//
@property (nonatomic, retain) NSString *AuxPistaSig;
@property (nonatomic, retain) NSString *AuxIdJuego;
@property (nonatomic, retain) NSString *AyudaIdObra;
@property (nonatomic, retain) NSString *AuxSumaJ;
@property (nonatomic, retain) NSString *AuxHoraJuego;
//tipo recorrido
@property (nonatomic, retain) NSString *AuxTipoRecorridoCTVC;
@property (nonatomic, retain) NSString *auxobrita;

@property (nonatomic, retain) EstadoJuego * juego;

@end
