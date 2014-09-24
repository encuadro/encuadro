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
@synthesize tableView, load;
@synthesize AuxSiguienteP;
@synthesize AuxJ;
@synthesize AuxContarJ;
@synthesize AuxHoraJ;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
        NSLog(@"Mostrando en autorTableViewController Pista sig: %@ y Id Juego: %@ y la suma va en: %@",AuxSiguienteP,AuxJ,AuxContarJ);
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
    o = [[obtSalas alloc]init];
    while(!finSal) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    if([[[o getNom] objectAtIndex:0] isEqualToString:@"-1"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención!" message:@"Ocurrió un error al obtener los datos o no existen salas." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        self.autorNombre = [o getNom];
        self.autorDescripcion = [o getDesc];
        self.autorImagen = [o getIma];
        if(self.autorNombre != NULL){
            [actInd stopAnimating];
            [self.tableView reloadData];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ok"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ObrasAutor"]){
        NSLog(@"toque");
        [actInd startAnimating];
        [load setHidden:NO];
        [load setTextAlignment:UITextAlignmentCenter];
        [tableView setUserInteractionEnabled:NO];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        NSMutableArray *salas = [o getSalas];
        opcionAutor = [salas objectAtIndex:[myIndexPath row]];
        [tableView setUserInteractionEnabled:YES];
        [load setHidden:YES];
        [actInd stopAnimating];
        /*
         ObraCompletaViewController *VistaObra = [segue destinationViewController];
         //[VistaObra setAuxPistaSig:[NSString stringWithString:_IdPistaSiguiente]];
         if (_AuxIdJuego != NULL) {
         [VistaObra setAuxJuegoId:[NSString stringWithString:_AuxIdJuego]];
         [VistaObra setAuxIdPistaSiguiente:[NSString stringWithString:_AuxPistaSig]];
         }
         //////-----/////
           NSLog(@"Mostrando Pista sig: %@ y Id Juego: %@",_AuxPistaSig,_AuxIdJuego);
         */
         
        CuadroTableViewController *ObrasV = [segue destinationViewController];
        
        if (AuxSiguienteP != NULL) {
        [ObrasV setAuxPistaSig:[NSString stringWithString:AuxSiguienteP]];
        [ObrasV setAuxIdJuego:[NSString stringWithString:AuxJ]];
        [ObrasV setAuxSumaJ:[NSString stringWithString:AuxContarJ]];
        [ObrasV setAuxHoraJuego:[NSString stringWithString:AuxHoraJ]];
        }
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
