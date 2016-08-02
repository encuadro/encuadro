//
//  ObraCompletaViewController.m
//  TableViewStory
//
//  Created by encuadro augmented reality on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObraCompletaViewController.h"
#include "xml_log.h"
#include "Configuracion.h"

@interface ObraCompletaViewController ()

@end

@implementation ObraCompletaViewController
@synthesize lblPista = _lblPista;
@synthesize btnRepetirPista;
@synthesize txtObtenerPista;
@synthesize btnPista;
@synthesize btnObtPista;
@synthesize txtPista;
@synthesize txtJuego;
@synthesize obra = _obra;
@synthesize autor = _autor;
@synthesize imagenObra = _imagenObra;
@synthesize detalle = _detalle;
@synthesize texto = _texto;
@synthesize audioPlayer = _audioPlayer;
@synthesize start, AR, tw;
@synthesize mano1;
@synthesize mano4;
@synthesize upsi;
@synthesize vistaTouch;
@synthesize greeting, nameInput, webData, soapResults, xmlParser;
@synthesize AyudaPista;
@synthesize IdObraPista;
@synthesize aux;
@synthesize auxidpista;
@synthesize BusquedaPista;
@synthesize pis1;
@synthesize pis2;
@synthesize pis3;
@synthesize auxpista;
//@synthesize AuxCantidad;
@synthesize Cantidad = _Cantidad;
@synthesize idsiguiente;
@synthesize AuxSuma = _AuxSuma;
@synthesize IdPistaSiguiente;
@synthesize AuxPistaSiguiente;
@synthesize AuxJuego;
@synthesize txtObraSiguiente;
@synthesize AuxJuegoId;
@synthesize AuxIdPistaSiguiente;
@synthesize AuxIdObra;
@synthesize ContarObras;
@synthesize TxtComparar;
@synthesize btnEstadoJuego;
@synthesize ContarObrasJuego;
@synthesize AuxContarO;
@synthesize HoraJuego;
@synthesize AuxTipoRecorridoOCVC;
@synthesize Auxiliar;
@synthesize pedidoActual;

@synthesize juego;
@synthesize parsed;
@synthesize nombreObra;

BOOL *elementFound;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"TOUCH OBRA ");
    
    if (self.vistaTouch.touchman) {
        //call segue
        //DrawSign *drawS = [[DrawSign alloc] init];
        
        // do any setup you need for myNewVC
        //[self performSegueWithIdentifier: @"todraw" sender: self];
        //[self presentViewController:drawS animated:YES completion:NO];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtPista.enabled = false;
    // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
// NSString *nombre = [defaults stringForKey:@"kMiNombre"];
    //DatosJuegosViewController *Suma =[DatosJuegosViewController new];
    
    //Suma = [defaults integerForKey:@"0"];
    NSLog(@"OCVC-->Mostrando valores si tiene de Id Juego %@ y pista %@ y suma:%@",AuxJuegoId, AuxIdPistaSiguiente, AuxContarO);
    NSLog(@"OCVC-->Mostrando Tipo Recorrido --> %@",AuxTipoRecorridoOCVC);
    NSLog(@"OCVC-->Mostrando Auxiliar --> %@",Auxiliar);
    //_AuxSuma = [defaults integerForKey:@"1"];
    //txtPista.text = AuxIdObra;
    // int value = [string intValue];
    if (juego.idJuego!=0){//AuxJuegoId != NULL) {
        ContarObras = [AuxContarO intValue];
        //[juego setContar:[AuxContarO intValue]];
    }else{
        juego = [[EstadoJuego alloc] init];

        NSLog(@"INICIALIZANDO JUEGO");
    }
    parsed = [[Parser alloc] init];
    //TxtComparar.text = AuxIdPistaSiguiente;
    btnPista.hidden = true;
    btnObtPista.hidden = true;
    btnRepetirPista.hidden = true;
    btnEstadoJuego.hidden = true;
    //txt`s
    TxtComparar.hidden = TRUE;
    txtJuego.hidden = TRUE;
    txtObraSiguiente.hidden = TRUE;
    txtObtenerPista.hidden = TRUE;
    txtPista.hidden = TRUE;
    
    //if (TxtComparar.text != NULL){
       
        //     miCadena = [NSMutableString stringWithString: @"Hola soy una cadena"];
       // ContarObras = [NSMutableString stringWithString:@"1"];
     //   NSLog(@"contar obras --> %@",ContarObras);
   // }
    
    //[_lblPista setText:[NSString stringWithFormat:@"%@",_Cantidad]];
    // [_lblIdJuego setText:[NSString stringWithFormat:@"%@",_VariablePasarIdJuego]];
    //txtPista.text = Cantidad;
    //    [_lblIdJuego setText:[NSString stringWithFormat:@"%@",_VariablePasarIdJuego]];
   // [txtPista setText:[NSString stringWithFormat:@"%@",Cantidad]];
   
    if(juego.idJuego!=0)
        pis3=@"1";
    else
        pis3=@"0";
    
	// Do any additional setup after loading the view.
    conUpsi=true;
    //    if (manual==true) {
    //
    //        //CAMINO MANUAL
    //        self.autor.text = [self.descripcionObra objectAtIndex:0];
    //
    //        // self.obra.text = [self.descripcionObra objectAtIndex:1];
    //
    //        self.imagenObra.image = [UIImage imageNamed:
    //                                 [self.descripcionObra objectAtIndex:2]];
    //        self.detalle.text=[self.descripcionObra objectAtIndex:3];
    //
    //
    //
    //    }else {
    //CAMINO AUTOMATICO
	
    /*NSString *filePath = [self.descripcionObra objectAtIndex:0];
     NSData* textData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:filePath]];
     NSString* text = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
     self.autor.text=text;
     
     filePath= [self.descripcionObra objectAtIndex:1];
     textData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:filePath]];
     text = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
     self.obra.text=text;
     
     
     filePath= [self.descripcionObra objectAtIndex:2];
     textData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:filePath]];
     UIImage *imagen =  [[UIImage alloc] initWithData:textData];
     self.imagenObra.image=imagen;
     
     
     filePath= [self.descripcionObra objectAtIndex:3];
     textData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:filePath]];
     text = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
     self.detalle.text=text;*/
    //    }
    
    justLoaded=true;
    
    
    //    [UIView animateWithDuration:1
    //                          delay:0.3
    //                        options: UIViewAnimationCurveEaseOut
    //                     animations:^{
    //                         mano1.center=CGPointMake(-100,150);
    //                         mano4.center=CGPointMake(700,150);
    //                     }
    //                     completion:^(BOOL finished){
    //                         NSLog(@"Done!");
    //                     }];
    //    //agrego vistaTouch
    //    self.vistaTouch = [[TouchVista alloc] init];
    //    self.vistaTouch.obraCompleta=true;
    //    self.vistaTouch.frame=CGRectMake(600,650,500, 500);
    //    [self.view addSubview:self.vistaTouch];
    //
    //    upsi.center=CGPointMake(950,1000);
    //    if (conUpsi) {
    //        [UIView animateWithDuration:2
    //                              delay:0.6
    //                            options: UIViewAnimationCurveEaseOut
    //                         animations:^{
    //
    //                             upsi.center=CGPointMake(950,950);
    //
    //
    //                         }
    //                         completion:^(BOOL finished){
    //                             NSLog(@"Done!");
    //                             self.vistaTouch.frame=CGRectMake(900,650,500, 500);
    //                             [self UpsiAppear];
    //                         }];
    //    }
}

- (void)UpsiAppear
{
    //upsi.center=CGPointMake(950,1000);
    if (conUpsi) {
        [UIView animateWithDuration:2
                              delay:0.6
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             upsi.center=CGPointMake(950,700);
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                             // self.vistaTouch.frame=CGRectMake(750,500,200, 200);
                             // [self UpsiUpMoveLeft];
                         }];
    }
}

- (void)UpsiUpMoveLeft
{
    [UIView animateWithDuration:1
                          delay:0.6
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         //upsi.transform=CGAffineTransformRotate(upsi.transform, M_PI);
                         upsi.center=CGPointMake(400,700);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                         //upsi.transform=CGAffineTransformRotate(upsi.transform, M_PI);
                         self.vistaTouch.frame=CGRectMake(200,500, 200, 200);
                         [self UpsiDownMoveLeft];
                     }];
}

- (void)UpsiDownMoveLeft
{
    [UIView animateWithDuration:1
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         //upsi.transform=CGAffineTransformRotate(upsi.transform, M_PI);
                         upsi.center=CGPointMake(950,1500);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                         //upsi.transform=CGAffineTransformRotate(upsi.transform, M_PI);
                         self.vistaTouch.frame=CGRectMake(1000,1000, 100, 100);
                         [self UpsiAppear];
                     }];
}

- (void)UpsiDisAppear
{
    [UIView animateWithDuration:1
                          delay:1
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         upsi.center=CGPointMake(400,340);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                         self.vistaTouch.frame=CGRectMake(370,320, 100, 100);
                         [self UpsiAppear];
                     }];
}

- (void)viewDidUnload
{
    [self setTxtPista:nil];
    [self setTxtJuego:nil];
    [self setTxtObtenerPista:nil];
    [self setBtnPista:nil];
    [self setBtnObtPista:nil];
    //[self setBtnMostrarPista:nil];
    [self setBtnRepetirPista:nil];
    [self setLblPista:nil];
    [self setTxtObraSiguiente:nil];
    [self setTxtComparar:nil];
    [self setBtnEstadoJuego:nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) play{
    if([[descripcionObra objectAtIndex:4] isEqualToString:@"null"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atención!" message:@"No esta disponible ningun audio para esta obra." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        if (click==0 || justLoaded) {
            // audioPlayer=nil;
            justLoaded=false;
            click=1;
            NSString *estring=[descripcionObra objectAtIndex:4];
            //NSURL *url =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],estring]];
            NSURL *url = [NSURL fileURLWithPath:estring];
            //  NSURL *url = [[NSURL alloc] initFileURLWithPath:@"/Users/encuadro/Music/CAMPO/02 1987.mp3"];
            // NSURL *url =[NSURL fileURLWithPath:@"/Users/encuadro/Music/CAMPO/02 1987.mp3"];
            // NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/Users/encuadro/Music/CAMPO/02 1987.mp3"]];
            NSError *error;
            self.audioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            self.audioPlayer.numberOfLoops=0;
            [self.audioPlayer play];
            [self.start setTitle:@"Stop"/* forState:UIControlStateNormal*/];
        }else {
            //audioPlayer=nil;
            [self.audioPlayer stop];
            click=0;
            [self.start setTitle:@"Audio"/* forState:UIControlStateNormal*/];
        }
    }
    
}

-(IBAction)tweet{
    if([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *controller = [[TWTweetComposeViewController alloc] init];
        UIImage *img = self.imagenObra.image;
        [controller addImage:img];
        [controller setInitialText:[NSString stringWithFormat:@"Arte Interactivo. Tweeting desde App! @encuadroAR #%@ #%@", [descripcionObra objectAtIndex:0], [descripcionObra objectAtIndex:1]]];
        //UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        //[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        //UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        //[controller addImage:[UIImage imageNamed:@"jessica.jpeg"]];
        //UIGraphicsEndImageContext();
        controller.completionHandler = ^(TWTweetComposeViewControllerResult result)  {
            [self dismissModalViewControllerAnimated:YES];
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    NSLog(@"Twitter Result: cancelled");
                    break;
                case TWTweetComposeViewControllerResultDone:
                    NSLog(@"Twitter Result: sent");
                    break;
                default:
                    NSLog(@"Twitter Result: default");
                    break;
            }
        };
        [self presentModalViewController:controller animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWILL APPEAR");
    self.vistaTouch.touchman=false;
    [actInd startAnimating];
    NSMutableString *autorNombre = [[NSMutableString alloc] init];
    [autorNombre appendString:[descripcionObra objectAtIndex:0]];
    [autorNombre appendString:@" - "];
    [autorNombre appendString:[descripcionObra objectAtIndex:1]];
    self.autor.text=autorNombre;
    self.obra.text=[descripcionObra objectAtIndex:1];
    UIImage *imagen =  [UIImage imageWithContentsOfFile:[descripcionObra objectAtIndex:2]];
    self.imagenObra.image=imagen;
    self.detalle.text = [descripcionObra objectAtIndex:3];
    [descripcionObra addObject:[oo getAudio]];
    [descripcionObra addObject:[oo getVideo]];
    [descripcionObra addObject:[oo getTexto]];
    self.texto.text = [descripcionObra objectAtIndex:6];
    [descripcionObra addObject:[oo getModelo]];
    [descripcionObra addObject:[[oo getAnimaciones] objectAtIndex:0]];
    [descripcionObra addObject:[[oo getAnimaciones] objectAtIndex:1]];
    [descripcionObra addObject:[[oo getAnimaciones] objectAtIndex:2]];
    [descripcionObra addObject:[[oo getAnimaciones] objectAtIndex:3]];
    [descripcionObra addObject:[[oo getAnimaciones] objectAtIndex:4]];
    if(oo.nombreObra!=nil)
        nombreObra = [NSString stringWithString:oo.nombreObra];
    if([descripcionObra objectAtIndex:12] != NULL){
        [actInd stopAnimating];
        [self.imagenObra setHidden:NO];
        [self.autor setHidden:NO];
        [self.autor setTextAlignment:UITextAlignmentCenter];
        [self.detalle setHidden:NO];
        [self.start setEnabled:YES];
        [self.AR setEnabled:YES];
        [self.tw setEnabled:YES];
        if(![[descripcionObra objectAtIndex:6] isEqualToString:@"null"])
            [self.texto setHidden:NO];
    }
    //probando
    /*AyudaPista = self.obra.text=[descripcionObra objectAtIndex:1];
    NSLog(@"AyudaPista: %@",AyudaPista);*/
	
	NSString *parameters = [Configuracion soapMethodInvocationVariable:@"getDataObra", @"nombre_obra", nombreObra, nil];
	NSString *soapMessage = [Configuracion SOAPMESSAGE:(parameters)];	
	
    NSMutableString *u = [NSMutableString stringWithString:[Configuracion kPostURL]];
	[u setString:[u stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:u];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: ([Configuracion soapMethodInvocationVariable:@"getDataObra", nil]) forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if( theConnection ){
        webData = [[NSMutableData data] retain];
    }
	else{
		NSLog(@"theConnection is NULL");
	}
	
    //IdObraPista = [soapResults substringToIndex:3];
   // AuxIdObra = txtPista.text;
//    NSLog(@"mostrar txt %@",AuxIdObra);
//    if ([txtPista.text isEqual:(AuxIdPistaSiguiente)]) {
//        ContarObras =@"1";
//        txtPista.text = AuxIdPistaSiguiente;
//        self.btnPista.enabled = false;
//    }else{
//        ContarObras = @"0";
//    }
    
    // llave del viewWILL APPEAR
}


- (void) viewDidAppear :(BOOL)animated
{
    if (juego.idobraSig == juego.idObraActual && juego.idJuego !=0){//TxtComparar.text == NULL && txtJuego.text !=NULL) {
        ContarObras = 1;
        //[juego setContar:juego.contar+1];
    }
        //aux = txtPista.text;

	NSString *idObraActual = [NSString stringWithFormat:@"%d", (juego.idObraActual)];
	NSString *parameters = [Configuracion soapMethodInvocationVariable:@"ObraPerteneceAJuego", @"id_Obra", idObraActual, nil];
	NSString *soapMessage = [Configuracion SOAPMESSAGE:(parameters)];
	
    NSMutableString *u = [NSMutableString stringWithString:[Configuracion kPostURL]];
	[u setString:[u stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:u];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: ([Configuracion soapMethodInvocationVariable:@"ObraPerteneceAJuego", nil]) forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if( theConnection ){
        webData = [[NSMutableData data] retain];
    }
	else{
		NSLog(@"theConnection is NULL");
	}

}//llave viewDidAppear

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (click!=0) {
        [self.audioPlayer stop];
        click=0;
        [self.start setTitle:@"Start"/* forState:UIControlStateNormal*/];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    XML_IN;
    if ([[segue identifier] isEqualToString:@"AR"])
    {
        if (click!=0) {
            [self.audioPlayer stop];
            click=0;
            [self.start setTitle:@"Start" forState:UIControlStateNormal];
        }
		 
#ifdef USE_ISGL
        VistaViewController *ARVistaViewController =
        [segue destinationViewController];
#endif
		 
        /*
         NSString *filePath = [self.descripcionObra objectAtIndex:5];
         NSData* textData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:filePath]];
         NSString* text = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
         ARVistaViewController.ARidObra=text;
         
         filePath = [self.descripcionObra objectAtIndex:6];
         textData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:filePath]];
         text = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
         ARVistaViewController.ARType=text;
         
         filePath = [self.descripcionObra objectAtIndex:7];
         textData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:filePath]];
         text = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
         ARVistaViewController.ARObj=text;
         
         */
    }
    /*if ([[segue identifier]isEqualToString:[NSString stringWithFormat:@"elNombreDelSegue"]])
     {
     
     ClaseB *B   = [segue destinationViewController];
     
     [B setlblUnoString:[NSString stringWithFormat:@"Contenido Label Uno"]];
     
     [B setlblDosString:[NSString stringWithFormat:@"Contenido Label Dos"]];
 */
    //if ([[segue identifier]isEqualToString:[@"DatosJuegosViewController"]])
        if ([[segue identifier] isEqualToString:@"DatosJuego"])
    {
        DatosJuegosViewController *vista = [segue destinationViewController];
        //NSLog(@"hora hora hora a pasar pasar pasar : %@",HoraJuego);
        //[vista setVariablePasar1:[NSString stringWithFormat:@"label label"]];
        //[vista setVariablePasarIdJuego:[NSString stringWithFormat:@"%d",juego.idJuego]];//,txtJuego.text]];
        //[vista setVariablePasarIdObra:[NSString stringWithFormat:@"%d",juego.idObraActual]];//txtPista.text]];
        //[vista setIdPistaSiguiente:[NSString stringWithFormat:@"%d",juego.idobraSig]];//txtObraSiguiente.text]];
        //NSLog(@"DATOS JUEGO::CONTAR :%d%@%d",ContarObras,@" Estado juego: ",juego.contar);
        //setValue:[NSNumber numberWithInt:200] forKey:@"jCode"];
        //[vista setAuxContarObras:[NSString stringWithString:ContarObras]];
        //[vista setAuxContarObras:[NSString stringWithFormat:@"%i",ContarObras]];
        //[vista setAuxTipoRecorridoDJVC:[NSString stringWithFormat:@"%@",AuxTipoRecorridoOCVC]];
        [vista setJuego: juego];
        if (juego.idObraActual==juego.idObraPrimera &&  juego.contar==0){//[TxtComparar.text isEqualToString:@""]){//== NULL){
            //NSDate *hoy = [NSDate date];
            NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                  dateStyle:NSDateFormatterShortStyle
                                                                  timeStyle:NSDateFormatterFullStyle];
            NSLog(@"XXX: %@",dateString);
            HoraJuego = [dateString substringFromIndex:8];
            HoraJuego = [HoraJuego substringToIndex:8];
            [juego setHoraInicio:HoraJuego];
            NSDateFormatter *hoy = [[NSDateFormatter alloc]init];
            [hoy setDateFormat:@"yyyy/mm/dd"];
            NSLog(@"PRUEBA FECHA HOY: ",hoy);
            NSDate * hora_inicio = [[NSDate alloc]init];
            NSString *stringFromDate = [hoy stringFromDate:hora_inicio];
            CFTimeInterval startTime = CACurrentMediaTime();
            [juego setStart:startTime];
        }
        //[vista setHoraComienzo:[NSString stringWithFormat:@"%@",HoraJuego]];
        
        NSLog(@" mostrando Tipo Recorrido a pasar --> %@",AuxTipoRecorridoOCVC);
       // [vista setFechaJuego:[NSDate date]];
    }
    XML_OUT;
}

- (IBAction)btnPista:(id)sender {
    
    if (juego.idobraSig == 0 && juego.idJuego!=0){//TxtComparar.text == NULL && txtJuego.text !=NULL) {
     ContarObras = 1;
     }
    /*
    NSMutableString * miCadena;
     miCadena = [NSMutableString stringWithString: @"Hola soy una cadena"];
     [miCadena appendFormat:@" y estoy siendo modificada"]; 
     [miCadena appendFormat:@" dos veces."]; 
     NSLog (@" %@", miCadena);
     ----
     ContarObras = [NSMutableString stringWithString:@"1"];
     NSLog(@"contar obras --> %@",ContarObras);
     /*/

    
    //if ([TxtComparar.text isEqualToString:(txtPista.text)]) {
         
       // [ContarObras appendFormat:@"1"];
        //ContarObrasJuego = @"1";
   // }
    //NSLog(@"Mostrando Contar --> %@",ContarObras);
    
    //YO aux = txtPista.text;
    
    //FTPUpload *fu = [[FTPUpload alloc]initWithString:self.filePath];
    //    Pista *Obtener = [[Pista alloc] init];
    //    NSLog(@"llamando funcion con valor id %@",aux);
    //   auxidpista = [Obtener ObtPista:aux];
    //
    //NSLog(@"prob %@",auxidpista);
    //    Pista *obtenerget = [[Pista alloc] init];
    //
    //    [obtenerget getSoapPista];
    //
    //    NSLog(@"Resultado del get? %@",[obtenerget getSoapPista]);
    //    UIAlertView *alert = [[UIAlertView alloc]
    //                          initWithTitle:@"Gracias!"
    //                          message:aux
    //                          delegate:self
    //                          cancelButtonTitle:@"Continuar"
    //                          otherButtonTitles:nil];
    //    [alert show];
    //    [alert release];
	
	NSString *idObraActual = [NSString stringWithFormat:@"%d", (juego.idObraActual)];
	NSString *parameters = [Configuracion soapMethodInvocationVariable:@"ObraPerteneceAJuego", @"id_Obra", idObraActual, nil];
	NSString *soapMessage = [Configuracion SOAPMESSAGE:(parameters)];
	
    NSMutableString *u = [NSMutableString stringWithString:[Configuracion kPostURL]];
	[u setString:[u stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:u];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: ([Configuracion soapMethodInvocationVariable:@"ObraPerteneceAJuego", nil]) forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if( theConnection ){
        webData = [[NSMutableData data] retain];
    }
	else{
		NSLog(@"theConnection is NULL");
	}
    // NSString *descripcion = [[oo getDesc]
    // NSString *descripcion = [[oo getDesc] objectAtIndex:[myIndexPath row]];
    //NSMutableString *h = [c getSoap];
    //NSMutableString *mensaje = [Pista getSoap];
    /*
     MyClass * collection = [[MyClass alloc] init];
     [collection setCollection:someArray];
     [collection addToCollection:someArray];
     */
    //if ([txtJuego.text isEqualToString:(@"0")]) {
       // txtJuego.text = [NSString stringWithFormat:@"%@",AuxJuegoId];
    //setIdPistaSiguiente:[NSString stringWithFormat:@"%@",txtObraSiguiente.text]];
   // }
}//llave del boton pista

- (IBAction)btnPista2:(id)sender {
    //yourButton.hidden = YES;
    btnPista.hidden = YES;
    btnObtPista.hidden = true;
    btnRepetirPista.hidden = false;
    btnEstadoJuego.hidden = false;
    /*if ([juego.pistaActual isEqualToString:(juego.)]){//txtPista.text isEqualToString:(AuxIdPistaSiguiente)]) {
        ContarObras = ContarObras + 1;
    }*/
    
    //Instanciamos la variable de las preferencias de la aplicación
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //Guardamos la fecha actual en la variable hoy
    
    //Guardamos el valor de hoy en las variables de preferencias de la aplicación
    //[defaults setObject:hoy forKey:@"ValorHoy"];
    //Forzamos la sincronización para que guarde el valor ya
    //[defaults synchronize];
//    if (TxtComparar.text == NULL){
//        //NSDate *hoy = [NSDate date];
//        NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
//                                                              dateStyle:NSDateFormatterShortStyle
//                                                              timeStyle:NSDateFormatterFullStyle];
//        NSLog(@"%@",dateString);
//        HoraJuego = [dateString substringFromIndex:9];
//        HoraJuego = [HoraJuego substringToIndex:8];
//        NSLog(@" mostrando hora a pasar --> %@",HoraJuego);
       // NSDate *hora = [NSDateComponents hour];
        /*
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"dd-MM-yyyy"];
         NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
         NSLog(@"%@", strDate);
         [dateFormatter release];
         */
        //idsiguiente = [auxidpista substringToIndex:3];
        //NSTimeInterval diff = [date2 timeIntervalSinceDate:date1];
        
    //NSLog(@" fecha ?? %@ ",hoy);
       // NSLog(@" hora hora -->  ?? %@ ",hora);
   // }
    
    //Pista *ObtPista = [[Pista alloc] init];
    //ObtPista ObtPistaTexto [txtPista.text, txtJuego.text];
    //[ObtPista ObtPistaTexto:txtPista.text IdPista:txtJuego.text];
    //-(Pista *)ObtPistaTexto: (NSString*)IdObra IdPista:(NSString*)idjuego
    //recordResults = FALSE;
    pis3=@"1";

	NSString *idObraActual = [NSString stringWithFormat:@"%d",juego.idObraActual];
	NSString *idJuego = [NSString stringWithFormat:@"%d",juego.idJuego];
	NSString *parameters = [Configuracion soapMethodInvocationVariable:@"BusquedaPista", @"id_Obra", idObraActual, @"id_Juego", idJuego, nil];
	NSString *soapMessage = [Configuracion SOAPMESSAGE:(parameters)];
		
    NSMutableString *u = [NSMutableString stringWithString:[Configuracion kPostURL]];
    [u setString:[u stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:u];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: ([Configuracion soapMethodInvocationVariable:@"BusquedaPista", nil]) forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( theConnection )
    {
        webData = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
    //AuxCantidad = txtJuego.text;
    //Cantidad = txtJuego.text;
    //SumarObras = SumarObras + 1;
    
    
    
    
}//llave btn pista2

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
	NSLog(@"OCVC > didReceiveData");
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"ERROR with theConnection");
	[connection release];
	[webData release];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"DONE. Received Bytes: %d", [webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"Received XML: %@",theXML);
	[theXML release];
	
	if (xmlParser)
    {
        [xmlParser release];
    }
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
	[connection release];
	[webData release];
}

-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict {
    
    NSLog(@"start elementName: %@",elementName);
    if( [elementName containsString:@"ns1"])
    {
        pedidoActual=elementName;
    }
    if( [elementName isEqualToString:@"return"])
    {
        if (!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if (elementFound)
    {
        [soapResults appendString: string];
        aux = soapResults;
    }
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    
    XML_IN;

        NSLog(@"end elementName: %@",elementName);
    if ([elementName isEqualToString:@"return"])
    {
        
        /*
        NSData *jsonData = [soapResults dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e = nil;
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
        NSLog(@"%@", json);*/
        
        NSLog(@"pedidoActual: %@",pedidoActual);
        //---displays the country---
        NSLog(@"soapResults: %@",soapResults);
        parsed.soapResult = soapResults;
        [parsed parsing:pedidoActual];
        /*NSString *AyudaJuego; // ARRANCAR
        
        AyudaJuego = soapResults; // ARRANCAR
        
        auxidpista = soapResults; // ARRANCAR
        */
        //<NUEVO>
        if([pedidoActual isEqualToString:@"ns1:getDataObraResponse"]){
            [juego setIdObraActual:[[parsed getParameter:(@"id_obra")]intValue]];
        }
        if([pedidoActual isEqualToString:@"ns1:BusquedaPistaResponse"]){
            NSLog(@"CASO 2");
            NSLog(@"Estado:%d",2);
            //txtObtenerPista.text = [auxpista substringFromIndex:5]; //EN CASO OBT PISTA OBTIENE PISTA
            [juego setEstado:1];
            [juego setPistaActual:[parsed getParameter:(@"pista"):2]];//ESTADOJUEGO
            //idsiguiente = [auxidpista substringToIndex:3];
            //[juego setIdobraSig:[[parsed getParameter:(@"idObraSiguiente")] intValue]];
            //txtObraSiguiente.text = idsiguiente;
            
            if ([pis3 isEqual: @"1"])   //si hay pista previa o no
            {
                NSLog(@"Estado:%d",3);
                //IdPistaSiguiente = idsiguiente; //ID OBRA SIGUIENTE
                if(juego.idObraActual==juego.idobraSig)
                    juego.contar = juego.contar+1;
                [juego setIdobraSig:[[parsed getParameter:(@"id_proxima"):2] intValue]];//[auxidpista substringToIndex:3]];
                //NSLog(@"Pista Siguiente !!!! --> %@",IdPistaSiguiente);
                UIAlertView *Mensaje = [[UIAlertView alloc]
                                        initWithTitle:@"Pista!"
                                        message:@"Puede volver a leer la pista, seleccionando Repetir Pista. Para continuar, seleccione Estado Juego"
                                        delegate:self
                                        cancelButtonTitle:@"Continuar"
                                        otherButtonTitles:nil];
                [Mensaje show];
                UIAlertView *alert1 = [[UIAlertView alloc]
                                       initWithTitle:@"Pista:"
                                       message:juego.pistaActual//txtObtenerPista.text
                                       delegate:self
                                       cancelButtonTitle:@"Continuar"
                                       otherButtonTitles:nil];
                [alert1 show];
                [alert1 release];
            }
        }
        if([pedidoActual isEqualToString:@"ns1:ObraPerteneceAJuegoResponse"]){//else    //entro aca cuando recibo el estado del juego
            if ([[parsed getParameter:(@"ret"):1] isEqualToString:@"0"] && juego.idobraSig!=juego.idObraActual ) //AyudaJuego isEqual: @"0"])
            {
                txtJuego.text = auxidpista;
                UIAlertView *alertNoJuego = [[UIAlertView alloc]
                                             initWithTitle:@"Esta obra"
                                             message:@"NO esta asociada a un Juego!"
                                             delegate:self
                                             cancelButtonTitle:@"Continuar"
                                             otherButtonTitles:nil];
                [alertNoJuego show];
                [alertNoJuego release];
            } else {
                NSLog(@"Estado:%d",7);
                btnObtPista.hidden = false;
                if(![[parsed getParameter:(@"ret"):1] isEqualToString:@"0"]){
                    if(juego.idJuego==0){
                        [juego setIdJuego:[[parsed getParameter:(@"ret"):1] intValue]];
                        [juego setIdObraPrimera:[[parsed getParameter:(@"id_obra")]intValue]];
                    }
                }
                pis3=@"1";
                UIAlertView *alertSiJuego = [[UIAlertView alloc]
                                             initWithTitle:@"Esta obra SI esta asociada a un Juego!"
                                             message:@"Ya esta jugando. Para leer la pista Seleccione Obtener Pista"
                                             delegate:self
                                             cancelButtonTitle:@"Continuar"
                                             otherButtonTitles:nil];
                [alertSiJuego show];
                [alertSiJuego release];
                btnPista.hidden = false;
            }//llave del else
        }

        //</NUEVO>
        
        
        //
        /*if ([pedidoActual isEqualToString:@"ns1:getDataObraResponse"]){//caracteres > (100)) { // datos obra
            NSLog(@"CASO 1");
            NSLog(@"Estado:%d",1);
            txtPista.text = [soapResults substringToIndex:3];   //FIXME: obtiene id de obra
            auxpista = soapResults;
            NSLog(@"Estado:%d",2);
            //BusquedaPista = txtPista.text;
            //int number = [[myTextField text] intValue];
            //txtPista.text = [soapResults substringToIndex:3];
            txtObtenerPista.text = [auxpista substringFromIndex:5]; //EN CASO OBT PISTA OBTIENE PISTA
            //idsiguiente = [auxidpista substringToIndex:3];
            NSLog(@"txtObtenerPista: %@",txtObtenerPista.text);
            NSLog(@"siguiente...:%@",idsiguiente);
            txtObraSiguiente.text = idsiguiente;
            //pis1 = [BusquedaPista intValue];
            //txtJuego.text = auxidpista;

            if ([pis3 isEqual: @"1"])   //si hay pista previa o no
            {
                NSLog(@"Estado:%d",3);
                IdPistaSiguiente = idsiguiente; //ID OBRA SIGUIENTE
                
                //NSLog(@"Pista Siguiente !!!! --> %@",IdPistaSiguiente);
                UIAlertView *Mensaje = [[UIAlertView alloc]
                                               initWithTitle:@"Pista!!!!!!"
                                               message:@"Puede volver a leer la pista, seleccionando Repetir Pista. Para continuar, seleccione Estado Juego"
                                               delegate:self
                                               cancelButtonTitle:@"Continuar"
                                               otherButtonTitles:nil];
                [Mensaje show];
                UIAlertView *alert1 = [[UIAlertView alloc]
                                       initWithTitle:@"Pista:"
                                       message:txtObtenerPista.text
                                       delegate:self
                                       cancelButtonTitle:@"Continuar"
                                       otherButtonTitles:nil];
                [alert1 show];
                [alert1 release];
            }
        }*//*
        if([pedidoActual isEqualToString:@"ns1:BusquedaPistaResponse"]){
            NSLog(@"CASO 2");
            NSLog(@"Estado:%d",2);
            //BusquedaPista = txtPista.text;
            //int number = [[myTextField text] intValue];
            //txtPista.text = [soapResults substringToIndex:3];
            txtObtenerPista.text = [auxpista substringFromIndex:5]; //EN CASO OBT PISTA OBTIENE PISTA

            [juego setPistaActual:[auxpista substringFromIndex:5]];//ESTADOJUEGO
            idsiguiente = [auxidpista substringToIndex:3];
            [juego setIdobraSig:[auxidpista substringToIndex:3]];
            NSLog(@"txtObtenerPista: %@",txtObtenerPista.text);
            NSLog(@"siguiente...:%@",idsiguiente);
            txtObraSiguiente.text = idsiguiente;
            //pis1 = [BusquedaPista intValue];
            //txtJuego.text = auxidpista;
            
            if ([pis3 isEqual: @"1"])   //si hay pista previa o no
            {
                NSLog(@"Estado:%d",3);
                IdPistaSiguiente = idsiguiente; //ID OBRA SIGUIENTE
                [juego setIdobraSig:[auxidpista substringToIndex:3]];
                //NSLog(@"Pista Siguiente !!!! --> %@",IdPistaSiguiente);
                UIAlertView *Mensaje = [[UIAlertView alloc]
                                        initWithTitle:@"Pista!!!!!!"
                                        message:@"Puede volver a leer la pista, seleccionando Repetir Pista. Para continuar, seleccione Estado Juego"
                                        delegate:self
                                        cancelButtonTitle:@"Continuar"
                                        otherButtonTitles:nil];
                [Mensaje show];
                UIAlertView *alert1 = [[UIAlertView alloc]
                                       initWithTitle:@"Pista:"
                                       message:txtObtenerPista.text
                                       delegate:self
                                       cancelButtonTitle:@"Continuar"
                                       otherButtonTitles:nil];
                [alert1 show];
                [alert1 release];
            }
        }/*
        if([pedidoActual isEqualToString:@"ns1:ObraPerteneceAJuegoResponse"])//else    //entro aca cuando recibo el estado del juego
        {
            NSLog(@"CASO 3");
            NSLog(@"Estado:%d",4);
            //if ([auxidpista isEqual: @"0"]) {// Esta obra SI esta asociada a un Juego! Si presiona boton Obtener Pista, va a comenzar a jugar..
                    //|| [IdPistaSiguiente isEqualToString:txtPista.text]
            if ([TxtComparar.text isEqualToString:txtPista.text]) {
                AyudaJuego = txtPista.text;
                NSLog(@"Estado:%d",5);
            }
            if ([AyudaJuego isEqual: @"0"])
            {
                NSLog(@"Estado:%d",6);
                txtJuego.text = auxidpista;
                [juego setPistaActual:auxidpista];
                NSLog(@"IdPistaSiguiente: %@",IdPistaSiguiente);
                NSLog(@"idsiguiente: %@",idsiguiente);
                UIAlertView *alertNoJuego = [[UIAlertView alloc]
                                             initWithTitle:@"Esta obra"
                                             message:@"NO esta asociada a un Juego!"
                                             delegate:self
                                             cancelButtonTitle:@"Continuar"
                                             otherButtonTitles:nil];
                [alertNoJuego show];
                [alertNoJuego release];
            } else {
                NSLog(@"Estado:%d",7);
                if ([auxidpista isEqualToString:@"0"] && [txtPista.text isEqualToString:(AuxIdPistaSiguiente)]) {
                    auxidpista = AuxJuegoId;
                    pis3=@"1";
                    NSLog(@"Estado:%d",8);
                }
                btnObtPista.hidden = false;
                txtJuego.text = auxidpista;
                [juego setIdJuego:[auxidpista intValue]];
                pis3=@"1";
                UIAlertView *alertSiJuego = [[UIAlertView alloc]
                                             initWithTitle:@"Esta obra SI esta asociada a un Juego!"
                                             message:@"Ya esta jugando. Para leer la pista Seleccione Obtener Pista"
                                             delegate:self
                                             cancelButtonTitle:@"Continuar"
                                             otherButtonTitles:nil];
                //Pista  *temp = [[Pista alloc] init];
                //[temp ObtPistaTexto:txtPista.text IdPista:txtPista.text];
                //NSLog(@" string %@",temp);
                [alertSiJuego show]; 
                [alertSiJuego release];
                btnPista.hidden = false;
                //
            }//llave del else
        }*/
        [soapResults setString:@""];
        elementFound = FALSE;
    }
    XML_OUT;
}



- (void)dealloc {
    [txtPista release];
    [txtJuego release];
    [txtObtenerPista release];
    [btnPista release];
    [btnObtPista release];
    [btnRepetirPista release];
    [_lblPista release];
    [txtObraSiguiente release];
    [TxtComparar release];
    [btnEstadoJuego release];
    [super dealloc];
    
}
- (IBAction)btnRepetirPista:(id)sender {
    btnPista.hidden = YES;
    btnObtPista.hidden = YES;
    //IdPistaSiguiente = AuxPistaSiguiente;
    //NSLog(@"Pista Siguiente !!!! --> %@",IdPistaSiguiente);
    
    UIAlertView *MostrarMensaje = [[UIAlertView alloc]
                                   initWithTitle:@"Pista!"
                                   message:@"Para continuar, seleccione Estado Juego"
                                   delegate:self
                                   cancelButtonTitle:@"Continuar"
                                   otherButtonTitles:nil];
    [MostrarMensaje show];
    
    
    UIAlertView *MostrarPista = [[UIAlertView alloc]
                                 initWithTitle:@"Pista!"
                                 message:juego.pistaActual//txtObtenerPista.text
                                 delegate:self
                                 cancelButtonTitle:@"Continuar"
                                 otherButtonTitles:nil];
    [MostrarPista show];
    

    

}
- (IBAction)btnDatosJuegos:(id)sender {
/*
 NextViewController *nextView = [[NextViewController alloc] initWithNibName:nil
 bundle:nil];
 
 [nextView setText:@"Hola desde la vista anterior"];
 
 [self.navigationController pushViewController:nextView
 animated:YES];
 */
    /*
    DatosJuegosViewController *VistaJugando = [[DatosJuegosViewController alloc] initWithNibName:nil bundle:nil];
    
    [VistaJugando setText:@"Hola desde la vista anterior"];
    
    [self.navigationController pushViewController:VistaJugando
                                         animated:YES];
 
 */
 
 
}
@end

