//
//  EstadoJuego.m
//  app0100
//
//  Created by encuadro on 9/30/14.
//
//

#import "EstadoJuego.h"

@implementation EstadoJuego
@synthesize estado;
@synthesize idJuego;
@synthesize pistaActual;
@synthesize idPista;
@synthesize idobraSig;
@synthesize horaInicio;
@synthesize contar;
@synthesize idObraActual;
@synthesize idObraPrimera;
@synthesize cantObras;
@synthesize start;
@synthesize tiempoTotal;

- (id) init{
    self = [super init];
    if (self) {
        idJuego = 0;
        idobraSig = 0;
        self.estado = 0;
    }
    return self;
}

- (BOOL) juegoTerminado{
    if( contar==cantObras){
        tiempoTotal = CACurrentMediaTime() - start;
        //self = [super init];
        return true;
    }
    return false;
}

- (int) faltan{
    return cantObras-contar;
}
@end



