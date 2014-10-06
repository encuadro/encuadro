//
//  AutorTableViewController.h
//  app0c
//
//  Created by encuadro augmented reality on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CuadroTableViewCell.h"
#import "CuadroTableViewController.h"
#import "obtObras.h"
#import "obtSalas.h"
#import "EstadoJuego.h"

obtObras *oo;
@interface AutorTableViewController : UITableViewController{
    IBOutlet UIActivityIndicatorView *actInd;
    IBOutlet UITableView *tableView;
    IBOutlet UILabel *load;
    obtSalas *o;
}
//@property (nonatomic, retain) IBOutlet UIImageView *autorLabelImagen;
//@property (nonatomic, retain) IBOutlet UILabel *autorLabelNombre;
//@property (nonatomic, retain) IBOutlet UILabel *autorLabelDescripcion;
@property (nonatomic, retain) NSArray *autorImagen;
@property (nonatomic, retain) NSArray *autorNombre;
@property (nonatomic, retain) NSArray *autorDescripcion;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actInd;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *load;
-(void)cargarDatos;
@property (nonatomic, retain) NSString *AuxSiguienteP;
@property (nonatomic, retain) NSString *AuxJ;
@property (nonatomic, retain) NSString *AuxContarJ;
@property (nonatomic, retain) NSString *AuxHoraJ;

@property (nonatomic, retain) EstadoJuego * juego;
//

@end
