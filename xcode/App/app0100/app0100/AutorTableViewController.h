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

@interface AutorTableViewController : UITableViewController
//@property (nonatomic, retain) IBOutlet UIImageView *autorLabelImagen;
//@property (nonatomic, retain) IBOutlet UILabel *autorLabelNombre;
//@property (nonatomic, retain) IBOutlet UILabel *autorLabelDescripcion;


@property (nonatomic, retain) NSArray *autorImagen;
@property (nonatomic, retain) NSArray *autorNombre;
@property (nonatomic, retain) NSArray *autorDescripcion;

@end
