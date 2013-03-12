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


@end
