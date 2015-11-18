//
//  Configuracion.m
//  app0100
//
//  Created by encuadro on 10/2/14.
//
//

#import "Configuracion.h"

//static NSString * IPSERVER = @"192.168.0.127";

static NSString * HEADMENSAJE = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
"<soap:Body>\n";

static NSString * TAILMENSAJE = @"</soap:Body>\n"
"</soap:Envelope>\n";

@implementation Configuracion



+ (NSString *) SOAPMESSAGE:(NSString *)parameters{
    NSString * ret = [NSString stringWithFormat:@"%@%@%@",HEADMENSAJE,parameters,TAILMENSAJE ];
    return ret;
}
+ (NSString*) kPostURL {
		NSString * ret = [NSString stringWithFormat:@"http://%@/server_php/server_php.php",[self ipserver]];
	return ret;
}

+ (NSString*) ipserver {
	NSString *ret=@"192.168.0.127";
	return ret;
}

+ (NSString *) soapMethodInvocation:(NSString *)param1 elemento:(NSString *)param2 identificador:(int)param3{
	NSString * ret = [NSString stringWithFormat:@"<%@ xmlns=\"%@/%@\">\n"
								 "<%@>%d</%@>"
								 "</%@>\n",param1, [self kPostURL], param1, param2, param3, param2, param1];
	/*
	NSString * ret = [NSString stringWithFormat:@"<ObraPerteneceAJuego xmlns=\"http://%@/server_php/server_php.php/ObraPerteneceAJuego\">\n"
							"<id_Obra>%@</id_Obra>"
							"</ObraPerteneceAJuego>\n",[self ipserver] ,[NSString stringWithFormat:@"%d",juego.idObraActual]];
	*/
	return ret;
}


@end
