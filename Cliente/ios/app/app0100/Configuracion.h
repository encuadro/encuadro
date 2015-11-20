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
//+ (NSString*) soapMethodInvocationInt:(NSString *)method par1name:(NSString *)p1n par1value:(int)p1v;
//+ (NSString*) soapMethodInvocationStr:(NSString *)method par1name:(NSString *)p1n par1value:(NSString *)p1v;
+ (NSString*) soapMethodInvocationVariable:(NSString *)arg1,...;

@end
