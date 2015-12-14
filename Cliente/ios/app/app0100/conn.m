//
//  conn.m
//  app0100
//
//  Created by encuadro on 2/25/13.
//
//

#import "conn.h"
#import "Configuracion.h"

@implementation conn
/*
-(conn *)initconFunc:(NSString *)string{
    finish = NO;
    worked = NO;
	NSString *arguments = [Configuracion soapMethodInvocationVariable:string, nil];
	NSString *soapMessage = [Configuracion SOAPMESSAGE:arguments];
	
    NSMutableString *u = [NSMutableString stringWithString: [Configuracion kPostURL]];
	[u setString:[u stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:u];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *s = [Configuracion soapMethodInvocationVariable: string, nil];
	[theRequest addValue: s  forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setTimeoutInterval:60];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( theConnection ){
        webData = [[NSMutableData data] retain];
        NSLog(@"entro");
    }
	else{
		NSLog(@"no entro");
    }
    return self;
}
 *//*
-(conn*)initconFunc:(NSString *)string yNomParam:(NSString *)string2 yParam:(NSString*)inti{
    finish = NO;
    worked = NO;
	NSString *arguments = [Configuracion soapMethodInvocationVariable:string, string2, inti, nil];
	NSString * soapMessage = [Configuracion SOAPMESSAGE:arguments];
    NSMutableString *u = [NSMutableString stringWithString:[Configuracion kPostURL]];
	[u setString:[u stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:u];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *s = [Configuracion soapMethodInvocationVariable: string, nil];
	[theRequest addValue: s  forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setTimeoutInterval:60];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( theConnection ){
        webData = [[NSMutableData data] retain];
        NSLog(@"entro");
        
    }
	else{
		NSLog(@"no entro");
    }
    return self;
}*/
/*
-(conn*)initConFuncion:(NSString *)nomFuncion NombreParametro:(NSString *)nombreParametro yNombreIma:(NSString *)nombreDato yNombreSegParam:(NSString *)nombreParam2 yIdSala:(NSString*)nombreDato2{
    finish = NO;
    worked = NO;
	NSString *arguments = [Configuracion soapMethodInvocationVariable:nomFuncion, nombreParametro, nombreDato, nombreParam2, nombreDato2, nil];
	NSString * soapMessage = [Configuracion SOAPMESSAGE:arguments];
	
	NSMutableString *u = [NSMutableString stringWithString:[Configuracion kPostURL]];
	[u setString:[u stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:u];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *s = [Configuracion soapMethodInvocationVariable: nomFuncion, nil];
	[theRequest addValue: s  forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setTimeoutInterval:60];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( theConnection ){
        webData = [[NSMutableData data] retain];
        NSLog(@"entro");
    }
	else{
		NSLog(@"no entro");
    }
    return self;
}

*/

-(conn *) initGenerico:(NSString *)invocation functionName:(NSString *)funcName{
	finish = NO;
	worked = NO;
	NSLog(@"INVOCATION: %@", invocation);
	NSString *soapMessage = [Configuracion SOAPMESSAGE:invocation];
	NSMutableString *u = [NSMutableString stringWithString:[Configuracion kPostURL]];
	[u setString:[u stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURL *url = [NSURL URLWithString:u];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: funcName  forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	[theRequest setTimeoutInterval:60];
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if( theConnection ){
		webData = [[NSMutableData data] retain];
		//NSLog(@">entro (variable)");
	}
	else{
		NSLog(@"theConnection is NULL");
		//NSLog(@">no entro (variable)");
	}
	return self;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[webData appendData:data];
}

-(void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error{
	NSLog(@"%@", error);
    worked = NO;
    finish = YES;
	[connection release];
	[webData release];
}

-(conn *)connectionDidFinishLoading:(NSURLConnection *)connection{
	NSLog(@"DONE. Received Bytes: %d", [webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    [theXML release];
	if (xmlParser){
        [xmlParser release];
    }
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser  parse];
	[connection release];
	[webData release];
}

-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict {
    if( [elementName isEqualToString:@"return"]){
        if (!soapResults){
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string{
    if (elementFound){
        [soapResults appendString: string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"return"]){
        finish = YES;
        worked = YES;
        //---displays the country---
        //[soapResults setString:@""];
        //elementFound = FALSE;
    }
}

-(NSMutableString *)getSoap{
    return soapResults;
}
-(void) setParser{
    parser = [[Parser alloc] init];
    [parser parsing:soapResults];
}

@end
