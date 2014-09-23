//
//  obtSalas.h
//  app0100
//
//  Created by encuadro on 3/8/13.
//
//

#import <Foundation/Foundation.h>
#import "conn.h"
#import "FTP.h"

BOOL finSal;
@interface obtSalas : NSObject{
    conn *c;
    conn *c2;
    NSString *rutita;
}
@property(nonatomic,retain)NSMutableArray *autorNombre;
@property(nonatomic,retain)NSMutableArray *autorDescripcion;
@property(nonatomic,retain)NSMutableArray *autorImagen;
@property(nonatomic,retain)NSMutableArray *datos2;
-(obtSalas*)init;
-(obtSalas*)initWithString:(NSString*)idSala;
-(void)contConexion;
-(void)contConexion2;
-(void)contFTP;
-(NSMutableArray*)getNom;
-(NSMutableArray*)getDesc;
-(NSMutableArray*)getIma;
-(NSMutableArray*)getSalas;
@end
