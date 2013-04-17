//
//  obtObras.h
//  app0100
//
//  Created by encuadro on 3/7/13.
//
//

#import <Foundation/Foundation.h>
#import "conn.h"
#import "FTP.h"
#import "NetworkManager.h"

BOOL finOb;
@interface obtObras : NSObject{
    
}
@property (nonatomic, retain) NSMutableArray *autorImagen;
@property (nonatomic, retain) NSMutableArray *autorNombre;
@property (nonatomic, retain) NSMutableArray *autorAutor;
@property (nonatomic, retain) NSMutableArray *autorDesc;
@property (nonatomic, retain) NSMutableArray *obras;
@property (nonatomic, retain) NSMutableString *idObra;
@property (nonatomic, retain) NSMutableString *nombreObra;
@property (nonatomic, retain) NSString *audio;
@property (nonatomic, retain) NSString *video;
@property (nonatomic, retain) NSString *texto;
@property (nonatomic, retain) NSString *modelo3d;
@property (nonatomic, retain) NSString *anim1;
@property (nonatomic, retain) NSString *anim2;
@property (nonatomic, retain) NSString *anim3;
@property (nonatomic, retain) NSString *anim4;
@property (nonatomic, retain) NSString *anim5;
-(obtObras*)initConId:(NSString*)idSala;
-(obtObras*)initConNombreObraParaContenidos:(NSString*)idObra;
-(obtObras*)initNombreIma:(NSString*)nombreImagen yIdSala:(NSString*)idSala;
-(void)obtDatosObraConNombreObra:(NSString*)nombreObra;
-(NSMutableArray*)getNombre;
-(NSMutableArray*)getAutor;
-(NSMutableArray*)getDesc;
-(NSMutableArray*)getImagen;
-(NSMutableArray*)getObras;
-(NSString*)getAudio;
-(NSString*)getVideo;
-(NSString*)getModelo;
-(NSString*)getTexto;
-(NSMutableArray*)getAnimaciones; 
@end
