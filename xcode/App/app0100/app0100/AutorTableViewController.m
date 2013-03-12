//
//  AutorTableViewController.m
//  app0c
//
//  Created by encuadro augmented reality on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AutorTableViewController.h"

@interface AutorTableViewController ()

@end

@implementation AutorTableViewController

//@synthesize autorLabelImagen = _autorLabelImagen;
//@synthesize autorLabelNombre = _autorLabelNombre;
//@synthesize autorLabelDescripcion = _autorLabelDescripcion;

@synthesize autorImagen = _autorImagen;
@synthesize autorNombre = _autorNombre;
@synthesize autorDescripcion = _autorDescripcion;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    /*
    self.autorNombre = [[NSArray alloc]
                        initWithObjects:
                        @"Blanes",
                        @"Figari",
                        @"Torres Garcia",
                        @"Esculturas",
                        nil];
    
    self.autorImagen = [[NSArray alloc]
                       initWithObjects:
                       @"AutorBlanes.jpeg",
                       @"AutorFigari.jpeg",
                       @"AutorTorres.jpeg",
                       @"esculturas.jpeg",
                       nil];
    
    self.autorDescripcion = [[NSArray alloc]
                         initWithObjects:
                         @"Juan Manuel Blanes (Montevideo, 8 de junio de 1830 — Pisa, Italia, 15 de abril de 1901)",
                         @"Pedro Figari Solari (n. Montevideo, 29 de junio de 1861 - íbidem, 24 de julio de 1938)",
                         @"Joaquín Torres García (Montevideo, 28 de julio de 1874 - Montevideo, 8 de agosto de 1949)",
                         @"Recorrido por la zona de esculturas digitales interactivas.",
                         nil];*/
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.autorNombre count];
}

- (CuadroTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AutorCell";
    
    CuadroTableViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CuadroTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.autorLabel.text = [self.autorNombre 
                            objectAtIndex: [indexPath row]];
    
    cell.obraLabel.text = [self.autorDescripcion 
                           objectAtIndex:[indexPath row]];
    UIImage *cuadroPhoto = [UIImage imageWithContentsOfFile:
                            [self.autorImagen objectAtIndex: [indexPath row]]];
    
    cell.cuadroImage.image = cuadroPhoto;    
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated{
    [actInd startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        self.autorNombre = [o getNom];
        self.autorDescripcion = [o getDesc];
        self.autorImagen = [o getIma];
        if(self.autorNombre != NULL){
            [actInd stopAnimating];
            [self.tableView reloadData];
        }
    });
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ObrasAutor"])
    {
        
      
        

    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
    NSMutableArray *salas = [o getSalas];
    opcionAutor = [salas objectAtIndex:[myIndexPath row]];
    oo = [[obtObras alloc] initConId:opcionAutor];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
