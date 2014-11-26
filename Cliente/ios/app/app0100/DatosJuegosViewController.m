//
//  DatosJuegosViewController.m
//  app0100
//
//  Created by encuadro on 3/14/14.
//
//

#import "DatosJuegosViewController.h"


@interface DatosJuegosViewController ()

@end

@implementation DatosJuegosViewController
@synthesize btnCantidadObras = _btnCantidadObras;
@synthesize btnIrSalas = _btnIrSalas;
@synthesize btnEscanearObras = _btnEscanearObras;

@synthesize VariablePasarIdJuego = _VariablePasarIdJuego;
@synthesize lblIdJuego = _lblIdJuego;
@synthesize lblJuego = _lblJuego;
@synthesize VariablePasarIdObra = _VariablePasarIdObra;
@synthesize lblIdObra = _lblIdObra;
@synthesize Aux1 = _Aux1;
@synthesize Suma = _Suma;
@synthesize AuxJuego = _auxJuego;
@synthesize IdPistaSiguiente = _IdPistaSiguiente;
@synthesize lblObraSiguiente = _lblObraSiguiente;
@synthesize AuxContarObras= _AuxContarObras;
@synthesize lblContarObra = _lblContarObra;
@synthesize AuxSuma;
@synthesize lblObrasTotal = _lblObrasTotal;
@synthesize AuxObrasJuego = _AuxObrasJuego;
@synthesize ObrasTotal = _ObrasTotal;
@synthesize lblFechaJuego = _lblFechaJuego;
@synthesize FechaJuego = _FechaJuego;
@synthesize HoraComienzo = _HoraComienzo;
@synthesize auxHora = _auxHora;
@synthesize HoraFinJuego = _HoraFinJuego;
@synthesize TotalJuego = _TotalJuego;
@synthesize AuxTipoRecorridoDJVC = _AuxTipoRecorridoDJVC;
@synthesize juego;


@synthesize greeting, nameInput, webData, soapResults, xmlParser;

BOOL *elementFound;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//[lblUno setText:[NSString stringWithFormat:@"%@",lblUnoString]];
//    NSString *auxiliar;
//    if (_HoraComienzo != NULL){
//         auxiliar = _HoraComienzo;
//        _auxHora = _HoraComienzo;
//        NSLog(@"mostrando  en if AUXILIAR %@",auxiliar);
//    }
    //_btnEscanearObras.hidden = TRUE;
    //_btnIrSalas.hidden = TRUE;
    _lblIdJuego.hidden = TRUE;
    _lblIdObra.hidden = TRUE;
    _lblObraSiguiente.hidden = TRUE;
    _lblJuego.hidden = TRUE;
    _lblFechaJuego.hidden = TRUE;
    
    if ([_AuxTipoRecorridoDJVC isEqual:@"1"]) {
        _btnEscanearObras.hidden = FALSE;
        _btnIrSalas.hidden = TRUE;
    }else{
        _btnEscanearObras.hidden = TRUE;
        _btnIrSalas.hidden = FALSE;
    }
    
    
    [_lblIdObra setText:[NSString stringWithFormat:@"%d",juego.idObraActual]];//_VariablePasarIdObra]];
    [_lblIdJuego setText:[NSString stringWithFormat:@"%d",juego.idJuego]];//_VariablePasarIdJuego]];
    [_lblObraSiguiente setText:[NSString stringWithFormat:@"%d",juego.idobraSig]];//_IdPistaSiguiente]];
    [_lblContarObra setText:[NSString stringWithFormat:@"%d",juego.contar]];//_AuxContarObras]];
    //if (_HoraComienzo == NULL) {
      //  [_lblFechaJuego setText:[NSString stringWithFormat:@"%@",_auxHora]];
    //}
    [_lblFechaJuego setText:[NSString stringWithFormat:@"%@",juego.horaInicio]];//_HoraComienzo]];
    NSLog(@"mostrando AUXILIAR %@",juego.horaInicio);//_HoraComienzo);
    
    
    //[_lblFechaJuego NSArray: _FechaJuego];
    
    // NSDate *hoy = [NSDate date];
   // NSLog(@" fecha ?? %@ ",hoy);
    
//    if ([_VariablePasarIdJuego isEqualToString:@"0"]) {
//         [_lblIdJuego setText:[NSString stringWithFormat:@"No hay juego"]];
//    } else {
//       //[self metodoQueRecibeUnParametro:@"Parametro recibido de texto"];
//        [self Juego:_VariablePasarIdJuego];
//         //[_lblIdJuego setText:[NSString stringWithFormat:@"%@",_VariablePasarIdJuego]];
//        //[defaults setValue:[_VariablePasarIdJuego] forKey:_Aux1];
//        //[satelite actualizarCoordenadasX: nueva_coordenada_x Y: nueva_coordenada_y]
//        
//        //[_Aux1 setAux1: _VariablePasarIdJuego];
//        
//        
//        //[self setAux1:_Aux1];
//        
//       // [_lblJuego setText:[NSString stringWithFormat:@"%@",_VariablePasarIdJuego]];
    //}
    
    
    //[_lblSuma setTag:_Suma];
    recordResults = FALSE;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<CantidadObrasJuego xmlns=\"http://%@/server_php/server_php.php/CantidadObrasJuego\">\n"
                             "<id_juego>%@</id_juego>"
                             "</CantidadObrasJuego>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",IPSERVER,[NSString stringWithFormat:@"%d",juego.idJuego]];//_VariablePasarIdJuego];
    NSLog(soapMessage);
    NSMutableString *u = [NSMutableString stringWithString:kPostURL];
    // [u appendString:[NSString stringWithFormat:@"/borrarUsuario?idUsuario=%d",13]];
    [u setString:[u stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:u];
    //
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: [NSString stringWithFormat:@"http://%@/server_php/server_php.php/CantidadObrasJuego",IPSERVER] forHTTPHeaderField:@"SOAPAction"];
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
    //[_lblContarObra setText:[NSString stringWithFormat:@"%@",_AuxContarObras]];
    //[_lblObrasTotal setText:[NSString stringWithFormat:@"%@",_ObrasTotal]];
    
}
	
    // Do any additional setup after loading the view.
- (IBAction)btnCantidadObras:(id)sender {
    _btnCantidadObras.hidden = TRUE;
    if (juego.contar!=0){//_lblContarObra != NULL) {
        int aux2 = juego.contar;//[_AuxContarObras intValue];
        //int resta = AuxSuma - aux2;
        AuxSuma = AuxSuma - aux2;
        NSLog(@"aux2 = %i",aux2);
        NSLog(@"Resta da resultado de = %i",AuxSuma);
        //unique = [NSString stringWithFormat:@"%d",mynumber];
        //[NSString stringWithFormat:@"%i",ContarObras]
        if (juego.juegoTerminado){//AuxSuma == 0) {
            
           /* NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                  dateStyle:NSDateFormatterShortStyle
                                                                  timeStyle:NSDateFormatterFullStyle];
            
            _HoraFinJuego = [dateString substringFromIndex:8];
            _HoraFinJuego = [_HoraFinJuego substringToIndex:8];
            NSLog(@"Hora fin de juego: %@",_HoraFinJuego);
            //hora inicio
            NSString *HoraInicio = [_HoraComienzo substringWithRange:NSMakeRange(0,2)];
            int HoraI = [HoraInicio integerValue];
            //minuto inicio
            NSString  *MinutoInicio = [_HoraComienzo substringWithRange:NSMakeRange(3,2)];
            int MinutoI = [MinutoInicio integerValue];
            //segundo inicio
            NSString  *SegundoInicio = [_HoraComienzo substringWithRange:NSMakeRange(6,2)];
            int SegundoI = [SegundoInicio integerValue];
            //hora final
            NSString *HoraFinal = [_HoraFinJuego substringWithRange:NSMakeRange(0,2)];
            int HoraF = [HoraFinal integerValue];
            //minuto final
            NSString  *MinutoFinal = [_HoraFinJuego substringWithRange:NSMakeRange(3,2)];
            int MinutoF = [MinutoFinal integerValue];
            //segundo final
            NSString  *SegundoFinal = [_HoraFinJuego substringWithRange:NSMakeRange(6,2)];
            int SegundoF = [SegundoFinal integerValue];
            if (HoraI == HoraF){
                int TotalMinutos = MinutoF - MinutoI;
                
                int TotalSegundos = SegundoF - SegundoI;
                
                TotalMinutos = TotalMinutos * 60;
                
                 _TotalJuego = TotalSegundos + TotalMinutos;
            }*/
            
            int endTimeSeg = juego.tiempoTotal;
            int min = endTimeSeg/60;
            int seg = endTimeSeg%60;
            UIAlertView *alertFinJuego = [[UIAlertView alloc]
                                      initWithTitle:@"Juego terminado..."
                                      message:[NSString stringWithFormat:@"Tiempo Total: %d Minutos, \n\t %d Segundos", min,seg]
                                      delegate:self
                                      cancelButtonTitle:@"Continuar"
                                      otherButtonTitles:nil];
            [alertFinJuego show];
            [alertFinJuego release];
            juego = [[EstadoJuego alloc]init];

            
        } else {
            //_AuxObrasJuego = [NSString stringWithFormat:@"%d",AuxSuma];
            UIAlertView *alertSuma = [[UIAlertView alloc]
                                      initWithTitle:@"Faltan..."
                                      message:[NSString stringWithFormat:@"%d",AuxSuma]//_AuxObrasJuego
                                      delegate:self
                                      cancelButtonTitle:@"Continuar"
                                      otherButtonTitles:nil];
            [alertSuma show];
            [alertSuma release];
        }
        
        
        
    }
    
    [nameInput resignFirstResponder];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_btnEscanearObras release];
    [_btnIrSalas release];
    [_btnCantidadObras release];
    [_lblObrasTotal release];
    //[_lblTexto release];
    //[super dealloc];
}
- (void)viewDidUnload {
    [self setBtnEscanearObras:nil];
    [self setBtnIrSalas:nil];
    [self setBtnCantidadObras:nil];
    [self setLblObrasTotal:nil];
    //[self setLblTexto:nil];
    //[super viewDidUnload];
}



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"ERROR with theConenction");
	[connection release];
	[webData release];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"DONE. Received Bytes: %d", [webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(theXML);
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
    }
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"return"])
    {
        //[NSNumberFormatter numberFromString:@"7"];
        //---displays the country---
        NSLog(@"%@",soapResults);
        
        //[NSNumberFormatter numberFromString:soapResults];
//        /int n = [s intValue];
        //ContarObras = [AuxContarO intValue]
        Parser * parser = [[Parser alloc] initWhitString:(soapResults)];
        _ObrasTotal = [[parser getParameter:@"ret"]intValue];
        [juego setCantObras:[[parser getParameter:@"ret"] intValue]];
        AuxSuma = juego.cantObras;
        [_lblObrasTotal setText:[NSString stringWithFormat:@"%d",juego.cantObras]];//_ObrasTotal]];
        
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Obras Totales"
                              message:(@"Obras totales %@",[NSString stringWithFormat:@"%d",juego.cantObras])//soapResults)
                              delegate:self
                              cancelButtonTitle:@"Continuar"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        [soapResults setString:@""];
        elementFound = FALSE;
    }
}
-(void)Juego:(NSString *)VariablePasarIdJuego
{
    [_lblJuego setText:[NSString stringWithFormat:@"%d",juego.idJuego]];
}
/*
 - (void)metodoQueRecibeUnParametro:(NSString *)parametro
 {
 //Este metodo recibe un parametro de texto y lo muestra en la etiqueta.
 _mostrarTexto.text = parametro;
 }
 }*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"IrObras"])
    {
        /*
         DatosJuegosViewController *vista = [segue destinationViewController];
         
         //[vista setVariablePasar1:[NSString stringWithFormat:@"label label"]];
         [vista setVariablePasarIdJuego:[NSString stringWithFormat:@"%@",txtJuego.text]];
         */
        AutorTableViewController *VistaAutor = [segue destinationViewController];
        /*[VistaAutor setAuxSiguienteP:[NSString stringWithString:_IdPistaSiguiente]];
        [VistaAutor setAuxJ:[NSString stringWithString:_VariablePasarIdJuego]];
        [VistaAutor setAuxContarJ:[NSString stringWithString:_AuxContarObras]];
        [VistaAutor setAuxHoraJ:[NSString stringWithString:_HoraComienzo]];*/
        [VistaAutor setJuego: juego];
    }
    if ([[segue identifier] isEqualToString:@"IrEscanear"])
    {
        /*
         DatosJuegosViewController *vista = [segue destinationViewController];
         
         //[vista setVariablePasar1:[NSString stringWithFormat:@"label label"]];
         [vista setVariablePasarIdJuego:[NSString stringWithFormat:@"%@",txtJuego.text]];
         */
        
        ReaderSampleViewController *VistaEscanear = [segue destinationViewController];
        [VistaEscanear setJuego: juego];
        /*[VistaEscanear setAuxSiguientePEscanear:[NSString stringWithString:_IdPistaSiguiente]];
        [VistaEscanear setAuxJEscanear:[NSString stringWithString:_VariablePasarIdJuego]];
        [VistaEscanear setAuxContarJEscanear:[NSString stringWithString:_AuxContarObras]];
        [VistaEscanear setAuxHoraJEscanear:[NSString stringWithString:_HoraComienzo]];*/
        
    }
}



@end
