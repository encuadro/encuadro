//
//  EstadoJuego.h
//  app0100
//
//  Created by encuadro on 9/30/14.
//
//

#import <Foundation/Foundation.h>

@interface EstadoJuego : NSObject{

}

- (id)init;
- (BOOL) juegoTerminado;
- (int) faltan;

@property int estado;
@property int idJuego;
@property int contar;
@property(retain,nonatomic) NSString *pistaActual;
@property(retain,nonatomic) NSString *idPista;
@property int idobraSig;
@property(retain,nonatomic) NSString *horaInicio;
@property int idObraActual;
@property int idObraPrimera;
@property int cantObras;
@property CFTimeInterval start;
@property CFTimeInterval tiempoTotal;

@end





