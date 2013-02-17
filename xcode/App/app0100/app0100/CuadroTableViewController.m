//
//  CuadroTableViewController.m
//  TableViewStory
//
//  Created by encuadro augmented reality on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CuadroTableViewController.h"



@interface CuadroTableViewController ()

@end

@implementation CuadroTableViewController
@synthesize cuadroImages=_cuadroImages;
@synthesize cuadroAutor=_cuadroAutor;
@synthesize cuadroObra=_cuadroObra;
@synthesize cuadroDescripcion=_cuadroDescripcion;
@synthesize nombre_audio = _nombre_audio;
@synthesize ARid = _ARid;
@synthesize ARType = _ARType;
@synthesize ARObj = _ARObj;


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
  
     if (opcionAutor==1) {//1--> Blanes
        
        NSLog(@"OPCION AUTOR ES 1---BLANES");
        self.cuadroAutor = [[NSArray alloc]
                            initWithObjects:
                            @"Blanes",
                            @"Blanes",
                            @"Blanes",
                            @"Blanes",
                            nil];
        
        self.cuadroObra = [[NSArray alloc]
                           initWithObjects:
                           @"Atardecer",
                           @"Un episodio de la fiebre amarilla en Buenos Aire",
                           @"La paraguaya",
                           @"Retrato de la Sra. Carlota F. de R.",
                           nil];
        
        self.cuadroImages = [[NSArray alloc]
                             initWithObjects:
                             @"Blanes_atardecer",
                             @"Blanes_fiebreAmarilla",
                             @"Blanes_laParaguaya",
                             @"Blanes_sraCarlota", 
                             nil];
        
        self.cuadroDescripcion = [[NSArray alloc]
                                  initWithObjects:
                                  @"Atardecer, c.1875-78. Óleo sobre tela. 36 x 30 cm",
                                  @"Un episodio de la fiebre amarilla en Buenos Aires, c.1871. Óleo sobre tela. 230 x 180 cm",
                                  @"La paraguaya, c.1879. Óleo sobre tela. 100 x 80 cm",
                                  @"Retrato de la Sra. Carlota F. de R., c.1883. Óleo sobre tela. 130 x 100 cm",
                                  nil];
         
         
         
         self.nombre_audio = [[NSArray alloc]
                              initWithObjects:
                              @"Blanes_atardecer.mp3",
                              @"Blanes_fiebreAmarilla.mp3",
                              @"Blanes_laParaguaya.mp3", 
                              @"Blanes_sraCarlota.mp3", 
                              nil];
         
         self.ARid = [[NSArray alloc]
                      initWithObjects:
                      [NSNumber numberWithInt:1],
                      [NSNumber numberWithInt:2],
                      [NSNumber numberWithInt:3],
                      [NSNumber numberWithInt:4],
                      nil];
         
         self.ARType = [[NSArray alloc]
                              initWithObjects:
                              @"modelo",
                              @"modelo",
                              @"modelo",
                              @"modelo",
                              nil];
         
         self.ARObj = [[NSArray alloc]
                              initWithObjects:
                              @"artigas",
                              @"artigas",
                              @"artigas",
                              @"artigas",
                              nil];
         
         
         
   
     }else if (opcionAutor==2) {//2--> Figari
         
         NSLog(@"OPCION AUTOR ES 2---FIGARI");
         self.cuadroAutor = [[NSArray alloc]
                             initWithObjects:
                             @"Figari",
                             @"Figari",
                             @"Figari",
                             @"Figari",
                             @"Figari",
                             @"Figari",
                             nil];
         
         self.cuadroObra = [[NSArray alloc]
                            initWithObjects:
                            @"Cambacuá",
                            @"Candombe",
                            @"Grito de Asencio",
                            @"Pericón en el patio de la estancia",
                            @"Pique nique",
                            @"Toque de oración",
                            nil];
         
         self.cuadroImages = [[NSArray alloc]
                              initWithObjects:
                              @"Figari_cambacua",
                              @"Figari_candombe",
                              @"Figari_gritoDeAsencio",
                              @"Figari_pericon",
                              @"Figari_pique",
                              @"Figari_toque",
                              nil];
         
         self.cuadroDescripcion = [[NSArray alloc]
                                   initWithObjects:
                                   @"Cambacuá, c.1923. Óleo sobre cartón. 69 x 99 cm",
                                   @"Candombe, c.1925. Oleo sobre cartón. 62 x 82 cm",
                                   @"Grito de Asencio, c.1925. Óleo sobre tela. 58 x 108 cm",
                                   @"Pericón en el patio de la estancia, c.1925. Óleo sobre cartón. 70 x 100 cm",
                                   @"Pique nique, c.1925. Oleo sobre cartón. 65 x 88 cm",
                                   @"Toque de oración, c.1925. Óleo sobre cartón. 69 x 99 cm",
                                   nil];
         
         
         
         self.nombre_audio = [[NSArray alloc]
                              initWithObjects:
                              @"Figari_cambacua.mp3",
                              @"Figari_candombe.mp3",
                              @"Figari_gritoDeAsencio.mp3", 
                              @"Figari_pericon.mp3",
                              @"Figari_pique.mp3",
                              @"Figari_toque.mp3",
                              nil];
         
         self.ARid = [[NSArray alloc]
                      initWithObjects:
                      [NSNumber numberWithInt:5],
                      [NSNumber numberWithInt:6],
                      [NSNumber numberWithInt:7],
                      [NSNumber numberWithInt:8],
                      [NSNumber numberWithInt:9],
                      [NSNumber numberWithInt:10],
                      nil];
         
         
         self.ARType = [[NSArray alloc]
                        initWithObjects:
                        @"modelo",
                        @"modelo",
                        @"modelo",
                        @"modelo",
                        @"modelo",
                        @"modelo",
                        nil];
         
         self.ARObj = [[NSArray alloc]
                       initWithObjects:
                       @"chihuahua",
                       @"chihuahua",
                       @"chihuahua",
                       @"chihuahua",
                       @"chihuahua",
                       @"chihuahua",
                       nil];
         
         
         
     } else if (opcionAutor==3) {//3--> Torres Garcia
         NSLog(@"OPCION AUTOR ES 3---TORRES GARCIA");
        self.cuadroAutor = [[NSArray alloc]
                            initWithObjects:
                            @"Torres Garcia",
                            @"Torres Garcia",
                            @"Torres Garcia",
                            @"Torres Garcia",
                            @"Torres Garcia",
                            nil];
        
        self.cuadroObra = [[NSArray alloc]
                           initWithObjects:
                           @"Pintura constructiva",
                           @"Pintura constructiva",                       
                           @"Interior",
                           @"Paisaje de ciudad",
                           @"Arte universal",
                           nil];
        
        self.cuadroImages = [[NSArray alloc]
                             initWithObjects:
                             @"Torres_constructiva",
                             @"Torres_constructiva2",
                             @"Torres_interior",
                             @"Torres_paisajeCiudad",
                             @"Torres_universal",
                             nil];
        
        self.cuadroDescripcion = [[NSArray alloc]
                                  initWithObjects:
                                  @"Pintura constructiva, 1929. Óleo sobre madera. 80 x 100 cm",
                                  @"Pintura constructiva, c.1929. Oleo sobre cartón. 44 x 35,5 cm",
                                  @"Interior, 1924. Óleo sobre cartón. 49,50 x 36 cm",
                                  @"Paisaje de ciudad, 1918. Óleo sobre cartón. 36 x 56 cm",
                                  @"Arte universal, 1943. Óleo sobre tela. 106 x 75 cm",
                                  nil];
         
         
         self.nombre_audio = [[NSArray alloc]
                              initWithObjects:
                              @"Torres_constructiva.mp3",
                              @"Torres_constructiva2.mp3",
                              @"Torres_interior.mp3",
                              @"Torres_paisajeCiudad.mp3",
                              @"Torres_universal.mp3",
                              nil];
         
         self.ARid = [[NSArray alloc]
                      initWithObjects:
                      [NSNumber numberWithInt:11],
                      [NSNumber numberWithInt:12],
                      [NSNumber numberWithInt:13],
                      [NSNumber numberWithInt:14],
                      [NSNumber numberWithInt:15],
                      nil];
        
         self.ARType = [[NSArray alloc]
                        initWithObjects:
                        @"video",
                        @"video",
                        @"video",
                        @"video",
                        @"video",
                        nil];
         
         
         self.ARObj = [[NSArray alloc]
                       initWithObjects:
                       @"videoplayback",
                       @"videoplayback",
                       @"GangnamStyle",
                       @"GangnamStyle",
                       @"GangnamStyle",
                       nil];
         
         
         
        
     }else if(opcionAutor==4){
         NSLog(@"OPCION AUTOR ES 4---ESCULTURAS DIGITALES");
         self.cuadroAutor = [[NSArray alloc]
                             initWithObjects:
                             @"enCuadro",
                             nil];
         
         self.cuadroObra = [[NSArray alloc]
                            initWithObjects:
                            @"Artigas",
                            nil];
         
         self.cuadroImages = [[NSArray alloc]
                              initWithObjects:
                              @"Esculturas_artigas",
                              nil];
         
         self.cuadroDescripcion = [[NSArray alloc]
                                   initWithObjects:
                                   @"Escultura digital de José Gervacio Artigas",
                                   nil];
         
         
         
         self.nombre_audio = [[NSArray alloc]
                              initWithObjects:
                              @"Blanes_atardecer.mp3",
                              nil];
         
         self.ARid = [[NSArray alloc]
                      initWithObjects:
                      [NSNumber numberWithInt:16],
                      nil];
         
         self.ARType = [[NSArray alloc]
                        initWithObjects:
                        @"animacion",
                        nil];
         
         
         self.ARObj = [[NSArray alloc]
                       initWithObjects:
                       @"artigas",
                       nil];
         
         
     
     }
    
     else {//else-->Todos los autores
         NSLog(@"OPCION AUTOR ES NINGUNO");
        self.cuadroAutor = [[NSArray alloc]
                            initWithObjects:
                            @"Blanes",
                            @"Blanes",
                            @"Blanes",
                            @"Blanes",
                            @"Figari",
                            @"Figari",
                            @"Figari",
                            @"Figari",
                            @"Figari",
                            @"Figari",
                            @"Torres Garcia",
                            @"Torres Garcia",
                            @"Torres Garcia",
                            @"Torres Garcia",
                            @"Torres Garcia",
                            @"enCuadro",
                            nil];
        
        self.cuadroObra = [[NSArray alloc]
                           initWithObjects:
                           @"Atardecer",
                           @"Un episodio de la fiebre amarilla en Buenos Aire",
                           @"La paraguaya",
                           @"Retrato de la Sra. Carlota F. de R.",
                           @"Cambacuá",
                           @"Candombe",
                           @"Grito de Asencio",
                           @"Pericón en el patio de la estancia",
                           @"Pique nique",
                           @"Toque de oración",
                           @"Pintura constructiva",
                           @"Pintura constructiva",                       
                           @"Interior",
                           @"Paisaje de ciudad",
                           @"Arte universal",
                           @"Artigas",
                           nil];
        
        self.cuadroImages = [[NSArray alloc]
                             initWithObjects:
                             @"Blanes_atardecer",
                             @"Blanes_fiebreAmarilla",
                             @"Blanes_laParaguaya",
                             @"Blanes_sraCarlota",
                             @"Figari_cambacua",
                             @"Figari_candombe",
                             @"Figari_gritoDeAsencio",
                             @"Figari_pericon",
                             @"Figari_pique",
                             @"Figari_toque",
                             @"Torres_constructiva",
                             @"Torres_constructiva2",
                             @"Torres_interior",
                             @"Torres_paisajeCiudad",
                             @"Torres_universal",
                             @"Esculturas_artigas",
                             nil];
        
        self.cuadroDescripcion = [[NSArray alloc]
                                  initWithObjects:
                                  @"Atardecer, c.1875-78. Óleo sobre tela. 36 x 30 cm",
                                  @"Un episodio de la fiebre amarilla en Buenos Aires, c.1871. Óleo sobre tela. 230 x 180 cm",
                                  @"La paraguaya, c.1879. Óleo sobre tela. 100 x 80 cm",
                                  @"Retrato de la Sra. Carlota F. de R., c.1883. Óleo sobre tela. 130 x 100 cm",
                                  @"Cambacuá, c.1923. Óleo sobre cartón. 69 x 99 cm",
                                  @"Candombe, c.1925. Oleo sobre cartón. 62 x 82 cm",
                                  @"Grito de Asencio, c.1925. Óleo sobre tela. 58 x 108 cm",
                                  @"Pericón en el patio de la estancia, c.1925. Óleo sobre cartón. 70 x 100 cm",
                                  @"Pique nique, c.1925. Oleo sobre cartón. 65 x 88 cm",
                                  @"Toque de oración, c.1925. Óleo sobre cartón. 69 x 99 cm",
                                  @"Pintura constructiva, 1929. Óleo sobre madera. 80 x 100 cm",
                                  @"Pintura constructiva, c.1929. Oleo sobre cartón. 44 x 35,5 cm",
                                  @"Interior, 1924. Óleo sobre cartón. 49,50 x 36 cm",
                                  @"Paisaje de ciudad, 1918. Óleo sobre cartón. 36 x 56 cm",
                                  @"Arte universal, 1943. Óleo sobre tela. 106 x 75 cm",
                                  @"Retrato de José Gervacio Artigas",
                                  nil];
        
        
//        self.nombre_audio = [[NSArray alloc]
//                               initWithObjects:
//                             @"Adele - Rolling In The Deep.mp3",nil];
        
        self.nombre_audio = [[NSArray alloc]
                             initWithObjects:
                             @"Blanes_atardecer.mp3",
                             @"Blanes_fiebreAmarilla.mp3",
                             @"Blanes_laParaguaya.mp3", 
                             @"Blanes_sraCarlota.mp3", 
                             @"Figari_cambacua.mp3",
                             @"Figari_candombe.mp3",
                             @"Figari_gritoDeAsencio.mp3", 
                             @"Figari_pericon.mp3",
                             @"Figari_pique.mp3",
                             @"Figari_toque.mp3",
                             @"Torres_constructiva.mp3", 
                             @"Torres_constructiva2.mp3",
                             @"Torres_interior.mp3",
                             @"Torres_paisajeCiudad.mp3",
                             @"Torres_universal.mp3",
                             @"Blanes_atardecer.mp3",
                             nil];
        
        
        self.ARid = [[NSArray alloc]
                     initWithObjects:
                     [NSNumber numberWithInt:1],
                     [NSNumber numberWithInt:2],
                     [NSNumber numberWithInt:3],
                     [NSNumber numberWithInt:4],
                     [NSNumber numberWithInt:5],
                     [NSNumber numberWithInt:6],
                     [NSNumber numberWithInt:7],
                     [NSNumber numberWithInt:8],
                     [NSNumber numberWithInt:9],
                     [NSNumber numberWithInt:10],
                     [NSNumber numberWithInt:11],
                     [NSNumber numberWithInt:12],
                     [NSNumber numberWithInt:13],
                     [NSNumber numberWithInt:14],
                     [NSNumber numberWithInt:15],
                     [NSNumber numberWithInt:16],
                     nil];
         
         
         self.ARType = [[NSArray alloc]
                        initWithObjects:
                        @"modelo",
                        @"modelo",
                        @"modelo",
                        @"modelo",
                        @"modelo",
                        @"modelo",
                        @"modelo",
                        @"modelo",
                        @"modelo",
                        @"modelo",
                        @"video",
                        @"video",
                        @"video",
                        @"video",
                        @"video",
                        @"animacion",
                        nil];
         
         
         self.ARObj = [[NSArray alloc]
                       initWithObjects:
                       @"artigas",
                       @"artigas",
                       @"artigas",
                       @"artigas",
                       @"chihuahua",
                       @"chihuahua",
                       @"chihuahua",
                       @"chihuahua",
                       @"chihuahua",
                       @"chihuahua",
                       @"videoplayback",
                       @"videoplayback",
                       @"GangnamStyle",
                       @"GangnamStyle",
                       @"GangnamStyle",
                       @"artigas",
                       nil];
         
        
        
        
    }    
   
                         
                         
                         
                         
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
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
   
    return 1;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.cuadroObra count];
}

- (CuadroTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cuadroTableCell";
    
    CuadroTableViewCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CuadroTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.autorLabel.text = [self.cuadroAutor 
                           objectAtIndex: [indexPath row]];
    
    cell.obraLabel.text = [self.cuadroObra 
                            objectAtIndex:[indexPath row]];
    
    NSString *nombreFotoAutor;
    
    if (opcionAutor==1) {//1--> Blanes
    
    nombreFotoAutor=@"AutorBlanes.jpeg";
    }else if (opcionAutor==2) {//2--> Figari
    
    nombreFotoAutor=@"AutorFigari.jpeg";
    }else if (opcionAutor==3) {//3--> Torres
    
    nombreFotoAutor=@"AutorTorres.jpeg";
    }else if (opcionAutor==4) {//3--> Esculturas
    nombreFotoAutor=@"esculturas.jpeg";
    
    }
    UIImage *cuadroPhoto = [UIImage imageNamed:nombreFotoAutor];
    
    cell.cuadroImage.image = cuadroPhoto;
  
    
    return cell;
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Detalle"])
    {
        manual=true;
        
        ObraCompletaViewController *obracompletaViewController = 
        [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView 
                                    indexPathForSelectedRow];
        
//        obracompletaViewController.descripcionObra = [[NSArray alloc]
//                                               initWithObjects: 
//                                            [self.cuadroAutor objectAtIndex:[myIndexPath row]],
//                                            [self.cuadroObra objectAtIndex:[myIndexPath row]],
//                                            [self.cuadroImages objectAtIndex:[myIndexPath row]],
//                                            [self.cuadroDescripcion objectAtIndex:[myIndexPath row]],
//                                            [self.nombre_audio objectAtIndex:[myIndexPath row]],
//                                            [self.ARid objectAtIndex:[myIndexPath row]],
//                                            [self.ARType objectAtIndex:[myIndexPath row]],
//                                            [self.ARObj objectAtIndex:[myIndexPath row]],
//                                            nil];
        
        
        NSString* returnString=[self.cuadroImages objectAtIndex:[myIndexPath row]];
        
        
        NSString* autor = @"http://192.168.1.111/autores/";
        autor = [autor stringByAppendingString:returnString];
        autor = [autor stringByAppendingString:@".txt"];
        
        
        NSString* obra = @"http://192.168.1.111/obras/";
        obra = [obra stringByAppendingString:returnString];
        obra = [obra stringByAppendingString:@".txt"];
        
        
        NSString* texto = @"http://192.168.1.111/textos/";
        texto = [texto stringByAppendingString:returnString];
        texto = [texto stringByAppendingString:@".txt"];
        NSLog(@"%@",returnString);
        NSString* imagen = @"http://192.168.1.111/imagenes/";
        imagen = [imagen stringByAppendingString:returnString];
        imagen = [imagen stringByAppendingString:@".jpg"];
        
        
        NSString* audio = returnString;
        audio = [audio stringByAppendingString:@".mp3"];
        
        
        
        NSString* ARid = @"http://192.168.1.111/ARid/";
        ARid = [ARid stringByAppendingString:returnString];
        ARid = [ARid stringByAppendingString:@".txt"];
        
        
        NSString* ARType = @"http://192.168.1.111/ARType/";
        ARType = [ARType stringByAppendingString:returnString];
        ARType = [ARType stringByAppendingString:@".txt"];
        
        
        NSString* ARObj = @"http://192.168.1.111/ARObj/";
        ARObj = [ARObj stringByAppendingString:returnString];
        ARObj = [ARObj stringByAppendingString:@".txt"];
        
        
        
        
        
        obracompletaViewController.descripcionObra = [[NSArray alloc]
                                                      initWithObjects:
                                                      autor,
                                                      obra,
                                                      imagen,
                                                      texto,
                                                      audio,
                                                      ARid,
                                                      ARType,
                                                      ARObj,
                                                      nil];
        
        

    }
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
}

@end
