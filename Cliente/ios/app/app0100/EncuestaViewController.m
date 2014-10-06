//
//  EncuestaViewController.m
//  app0100
//
//  Created by encuadro on 2/19/14.
//
//

#import "EncuestaViewController.h"

@interface EncuestaViewController ()

@end

@implementation EncuestaViewController

@synthesize greeting, nameInput, webData, soapResults, xmlParser, txtTipoVisita, txtNacionalidad, txtSexo, txtRangoEdad, segRangoEdad, segSexo, segNacionalidad, SegTipoVisita;


BOOL *elementFound;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(IBAction)buttonClick:(id)sender
{
	recordResults = FALSE;
    
	NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<Altavisita xmlns=\"http://%@/server_php/server_php.php/Altavisita\">\n"
                             "<nacionalidad>%@</nacionalidad>"
                             "<sexo>%@</sexo>"
                             "<tipo_visita>%@</tipo_visita>"
                             "<rango_edad>%@</rango_edad>"
                             "</Altavisita>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",IPSERVER, txtNacionalidad.text, txtSexo.text, txtTipoVisita.text,txtRangoEdad.text];
	NSLog(soapMessage);
    NSMutableString *u = [NSMutableString stringWithString:kPostURL];
    // [u appendString:[NSString stringWithFormat:@"/borrarUsuario?idUsuario=%d",13]];
	[u setString:[u stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:u];
    //
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: [NSString stringWithFormat:@"http://%@/server_php/server_php.php/Altavisita",IPSERVER] forHTTPHeaderField:@"SOAPAction"];
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
	
	[nameInput resignFirstResponder];
	
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
        //---displays the country---
        NSLog(@"%@",soapResults);
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Gracias!"
                              /*message:soapResults*/message:@"Prosiga su visita."
                              delegate:self
                              cancelButtonTitle:@"Continuar"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        [soapResults setString:@""];
        elementFound = FALSE;
    }
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
 
 - (void)loadView {
 }
 */


//Implement viewDidLoad if you need to do additional setup after loading the view.
- (void)viewDidLoad {
	[super viewDidLoad];
    self.nameInput.hidden = true;
    
    self.txtTipoVisita.text = @"Individual";
    self.txtTipoVisita.hidden = true;
    
    self.txtNacionalidad.text = @"Uruguaya";
    self.txtNacionalidad.hidden = true;
    
    self.txtSexo.text = @"Masculino";
    self.txtSexo.hidden = true;
    
    self.txtRangoEdad.text = @"+ de 18";
    self.txtRangoEdad.hidden = true;
    
    //    self.txtCuestionario.text =@"Si";
    //self.txtCuestionario.hidden = true;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc
{
	[xmlParser release];
    [txtNacionalidad release];
    [txtSexo release];
    [txtRangoEdad release];
    [txtTipoVisita release];
    
    //    [_segEdad release];
    //    [_segNacionalidad release];
    //    [_segSexo release];
    [SegTipoVisita release];
    [segNacionalidad release];
    [segSexo release];
    [segRangoEdad release];
    [txtTipoVisita release];
    [txtNacionalidad release];
    [txtSexo release];
    [txtRangoEdad release];
	[super dealloc];
}

//-(IBAction)segmentedControlIndexCuestionario{
//    switch (self.segCuestionario.selectedSegmentIndex) {
//        case 0:
//            self.txtCuestionario.text =@"Si";
//            break;
//        case 1:
//            self.txtCuestionario.text =@"No";
//            break;
//        default:
//            break;
//    }
//}
-(IBAction)segmentedControlIndexTipoVisita{
    switch (self.SegTipoVisita.selectedSegmentIndex) {
        case 0:
            self.txtTipoVisita.text =@"Grupal";
            break;
        case 1:
            self.txtTipoVisita.text =@"Individual";
            break;
        default:
            break;
    }
    
}


-(IBAction)segmentedControlIndexSexo{
    switch (self.segSexo.selectedSegmentIndex) {
        case 0:
            self.txtSexo.text = @"Masculino";
            break;
        case 1:
            self.txtSexo.text = @"Femenino";
            break;
        default:
            break;
    }
}

-(IBAction)segmentedControlIndexNacionalidad{
    switch (self.segNacionalidad.selectedSegmentIndex) {
        case 0:
            self.txtNacionalidad.text = @"Uruguaya";
            break;
        case 1:
            self.txtNacionalidad.text = @"Extranjera";
            break;
        default:
            break;
    }
}

-(IBAction)segmentedControlIndexRangoEdad{
    switch (self.segRangoEdad.selectedSegmentIndex) {
        case 0:
            self.txtRangoEdad.text =@"0 a 12";
            break;
        case 1:
            self.txtRangoEdad.text =@"13 a 15";
            break;
        case 2:
            self.txtRangoEdad.text =@"16 a 18";
            break;
        case 3:
            self.txtRangoEdad.text =@"+ de 18";
            break;
        default:
            break;
    }
}


//- (IBAction)btnVista2 {
//    self.view = vista2;
//}
// segunda vista, segunda pantalla, de aca para abajo...
- (IBAction)btnPrueba:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mensaje Prueba"
                                                    message:@"Desea Continuar" delegate:self cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Si", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex: (NSInteger)buttonIndex

{ NSString *title = [alert buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Si"]) {
        NSLog(@"Si");
        UIAlertView *Pista = [[UIAlertView alloc] initWithTitle:@"¡PISTA!"
                                                        message:@"Mensaje de pista..." delegate:self cancelButtonTitle:@"Aceptar"
                                              otherButtonTitles:nil];
        [Pista show];
        [Pista release];
    }
    else if ([title isEqualToString:@"No"]) {
        NSLog(@"No");
    }
}

- (void)viewDidUnload {
    [self setSegTipoVisita:nil];
    [self setSegNacionalidad:nil];
    [self setSegSexo:nil];
    [self setSegRangoEdad:nil];
    [self setTxtTipoVisita:nil];
    [self setTxtNacionalidad:nil];
    [self setTxtSexo:nil];
    [self setTxtRangoEdad:nil];
    [super viewDidUnload];
}
@end


/*

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
 */
