//
//  Configuracion.m
//  app0100
//
//  Created by encuadro on 10/2/14.
//
//

#import "Configuracion.h"

@implementation Configuracion


+ (NSString *) SOAPMESSAGE:(NSString *)parameters{
    NSString * ret = [NSString stringWithFormat:@"%@%@%@",HEADMENSAJE,parameters,TAILMENSAJE ];
    return ret;
}


@end
