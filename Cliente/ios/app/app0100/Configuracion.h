//
//  Configuracion.h
//  app0100
//
//  Created by encuadro on 10/2/14.
//
//

#import <Foundation/Foundation.h>

//static (NSString*) soapMensaje(NSString*)parameters;

@interface Configuracion : NSObject{
	
}

+ (NSString*) SOAPMESSAGE: (NSString*) parameters;
+ (NSString*) kPostURL;
+ (NSString*) ipserver;
+ (NSString*) soapMethodInvocationVariable:(NSString *)arg1,...;

@end
