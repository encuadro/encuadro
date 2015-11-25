//
//  ViewController.m
//  test_WS
//
//  Created by Juan Cardelino on 11/23/15.
//  Copyright © 2015 Juan Cardelino. All rights reserved.
//

#import "ViewController.h"

NSString *ip = @"192.168.0.101";

@interface ViewController ()
@end

@implementation ViewController

	@synthesize webData;
	@synthesize etiqueta;

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(void*)pruebaConexion{
	//finish = NO;
	//worked = NO;
	
	

	NSString *soapMessage = [NSString stringWithFormat:
	@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
	"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
	"<soap:Body>\n"
	"<getAllDataObraSala xmlns=\"http://%@/server_php/server_php.php/getAllDataObraSala\">\n"
	"<id>161</id>\n"
	"</getAllDataObraSala>\n"
	"</soap:Body>\n"
	"</soap:Envelope>\n", ip];
	//NSLog(@"\n\n***************** conex: %@",soapMessage);
	
	NSMutableString *u = [NSMutableString stringWithString: [NSString stringWithFormat: @"http://%@/server_php/server_php.php", ip]];
	[u setString:[u stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURL *url = [NSURL URLWithString:u];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	NSString *s = [NSString stringWithFormat:@"http://%@/server_php/server_php.php/getAllDataObraSala", ip];
	[theRequest addValue: s  forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	[theRequest setTimeoutInterval:60];
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	 if( theConnection ){
		webData = [[NSMutableData data] retain];
		NSLog(@"entro");
		NSLog(@"theConnection: %@", [NSString stringWithFormat:@"%@", theConnection]);
		 
	}
	else{
		NSLog(@"no entro");
	}
	
	return self;
}



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
	NSLog(@"DidReceiveResponse");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
	NSLog(@"DidReceiveData");
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"ERROR with theConnection");
	etiqueta.text = [NSString stringWithFormat:@"Comunicación con %@: ERROR", ip];
	[connection release];
	[webData release];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"DONE. Received Bytes: %d", [webData length]);
	etiqueta.text = [NSString stringWithFormat:@"Comunicación con %@: %i bytes recibidos", ip,[webData length]];
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



-(IBAction)buttonClick{
	NSLog(@"Button tapped");
	[self pruebaConexion];
}


@end
