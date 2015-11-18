//
//  Configuracion.h
//  app0100
//
//  Created by encuadro on 10/2/14.
//
//

#import <Foundation/Foundation.h>

//static NSString * IPSERVER = @"192.168.0.127";

//static (NSString*) soapMensaje(NSString*)parameters;


@interface Configuracion : NSObject{
	
}

+ (NSString*) SOAPMESSAGE: (NSString*) parameters;
+ (NSString*) kPostURL;
+ (NSString*) ipserver;
+ (NSString*) soapMethodInvocation:(NSString *)param1 elemento:(NSString *)param2 identificador:(int)param3;

@end
