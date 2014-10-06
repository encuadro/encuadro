//
//  Configuracion.h
//  app0100
//
//  Created by encuadro on 10/2/14.
//
//

#import <Foundation/Foundation.h>

static NSString * IPSERVER = @"192.168.10.185";
static NSString * HTTPSERVER = @"http://%@/server_php/server_php.php",*IPSERVER;
static NSString * HEADMENSAJE = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                    "<soap:Body>\n";

static NSString * TAILMENSAJE = @"</soap:Body>\n"
                                "</soap:Envelope>\n";


//static (NSString*) soapMensaje(NSString*)parameters;


@interface Configuracion : NSObject{
   
}

+ (NSString*) SOAPMESSAGE: (NSString*) parameters;



@end
