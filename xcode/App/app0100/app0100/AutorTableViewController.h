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
#import "InicioViewController.h"
#import "obtObras.h"

obtObras *oo;
@interface AutorTableViewController : UITableViewController{
    IBOutlet UIActivityIndicatorView *actInd;
    IBOutlet UITableView *tableView;
}
//@property (nonatomic, retain) IBOutlet UIImageView *autorLabelImagen;
//@property (nonatomic, retain) IBOutlet UILabel *autorLabelNombre;
//@property (nonatomic, retain) IBOutlet UILabel *autorLabelDescripcion;
@property (nonatomic, retain) NSArray *autorImagen;
@property (nonatomic, retain) NSArray *autorNombre;
@property (nonatomic, retain) NSArray *autorDescripcion;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actInd;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@end
