//
//  obtObras.m
//  app0100
//
//  Created by encuadro on 3/7/13.
//
//

#import "obtObras.h"
#import "conn.h"
#import "FTP.h"
#import "NetworkManager.h"

@implementation obtObras
@synthesize autorNombre = _autorNombre;
@synthesize autorAutor = _autorAutor;
@synthesize autorDesc = _autorDesc;
@synthesize autorImagen = _autorImagen;
@synthesize obras = _obras;
@synthesize audio = _audio;
@synthesize video = _video;
@synthesize texto = _texto;
@synthesize modelo3d = _modelo3d;
@synthesize anim1 = _anim1;
@synthesize anim2 = _anim2;
@synthesize anim3 = _anim3;
@synthesize anim4 = _anim4;
@synthesize anim5 = _anim5;
@synthesize idObra = _idObra;
@synthesize nombreObra = _nombreObra;

-(obtObras*)initConId:(NSString *)idSala{
    self.autorNombre = [[NSMutableArray alloc] init];
    self.autorAutor = [[NSMutableArray alloc] init];
    self.autorDesc = [[NSMutableArray alloc] init];
    self.autorImagen = [[NSMutableArray alloc] init];
    conn *c = [[conn alloc]initconFunc:@"getObraSala" yNomParam:@"id" yParam:idSala];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        NSMutableString *h = [c getSoap];
        NSArray *h2 = [h componentsSeparatedByString:@"=>"];
        self.obras = [[NSMutableArray alloc] init];
        int sized = [h2 count];
        conn *c2;
        for(int i=0;i<sized-1;i++){
            [self.obras addObject:[h2 objectAtIndex:i]];
            c2 = [[conn alloc] initconFunc:@"getDataObra" yNomParam:@"nombre_obra" yParam:[h2 objectAtIndex:i]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
                NSMutableString *cmas = [c2 getSoap];
                NSArray *datosObra = [cmas componentsSeparatedByString:@"=>"];
                [self.autorNombre addObject:[datosObra objectAtIndex:1]];
                [self.autorAutor addObject:[datosObra objectAtIndex:6]];
                [self.autorDesc addObject:[datosObra objectAtIndex:2]];
                NSString *rutita = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                FTP *f = [[FTP alloc] initWithString:rutita yotroString:[datosObra objectAtIndex:4] ytipo:@"obras" yId:[datosObra objectAtIndex:0] ytipo2:@"imagen"];
                [self.autorImagen addObject:rutita];
            });
        }
    });
    return self;
}

-(obtObras*)initConNombreObraParaContenidos:(NSString *)idObra{
    self.audio = [[NSString alloc]init];
    self.video = [[NSString alloc]init];
    self.modelo3d = [[NSString alloc] init];
    self.texto = [[NSString alloc]init];
    self.anim1 = [[NSString alloc]init];
    self.anim2 = [[NSString alloc]init];
    self.anim3 = [[NSString alloc]init];
    self.anim4 = [[NSString alloc]init];
    self.anim5 = [[NSString alloc]init];
    conn *c = [[conn alloc]initconFunc:@"getContenidoObra" yNomParam:@"nombre" yParam:idObra];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        NSMutableString *contenidos = [c getSoap];
        NSArray *datos = [contenidos componentsSeparatedByString:@"=>"];
        for(int f=1;f<=12;f++){
            if(f == 1){
                if(![[datos objectAtIndex:f] isEqualToString:@"null"]){
                    NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                    FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f] ytipo:@"obras" yId:[datos objectAtIndex:0] ytipo2:@"audio"];
                    self.audio = ruta;
                }
                else{
                    self.audio = @"null";
                }
                
            }
            if (f == 2){
                if(![[datos objectAtIndex:f] isEqualToString:@"null"]){
                    NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                    FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f] ytipo:@"obras" yId:[datos objectAtIndex:0] ytipo2:@"video"];
                    self.video = ruta;
                }
                else{
                    self.video = @"null";
                }
            }
            if (f == 3){
                self.texto = [datos objectAtIndex:f];
            }
            if (f == 4){
                if(![[datos objectAtIndex:f] isEqualToString:@"null"]){
                    NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                    FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f] ytipo:@"obras" yId:[datos objectAtIndex:0] ytipo2:@"modelo"];
                    self.modelo3d = ruta;
                }
                else{
                    self.modelo3d = @"null";
                }
            }
            if(f == 8 || f > 8){
                if([[datos objectAtIndex:f] isEqualToString:@"null"]){
                    self.anim1 = @"null";
                    self.anim2 = @"null";
                    self.anim3 = @"null";
                    self.anim4 = @"null";
                    self.anim5 = @"null";
                    break;
                }
                else{
                    if(f == 8){
                        NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                        //NSString *ruta = @"/private/var/mobile/Applications/84E285EB-8337-47B5-A63E-96226A8AB431/anim1.pod";
                        FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f] ytipo:@"obras" yId:[datos objectAtIndex:0] ytipo2:@"animacion"];
                        self.anim1 = ruta;
                    }
                    if(f==9){
                        NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                        //NSString *ruta = @"/private/var/mobile/Applications/84E285EB-8337-47B5-A63E-96226A8AB431/anim2.pod";
                        FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f] ytipo:@"obras" yId:[datos objectAtIndex:0] ytipo2:@"animacion"];
                        self.anim2 = ruta;
                    }
                    if(f==10){
                        NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                        //NSString *ruta = @"/private/var/mobile/Applications/84E285EB-8337-47B5-A63E-96226A8AB431/anim3.pod";
                        FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f] ytipo:@"obras" yId:[datos objectAtIndex:0] ytipo2:@"animacion"];
                        self.anim3 = ruta;
                    }
                    if(f==11){
                        NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                        //NSString *ruta = @"/private/var/mobile/Applications/84E285EB-8337-47B5-A63E-96226A8AB431/anim4.pod";
                        FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f] ytipo:@"obras" yId:[datos objectAtIndex:0] ytipo2:@"animacion"];
                        self.anim4 = ruta;
                    }
                    if(f==12){
                        NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                        //NSString *ruta = @"/private/var/mobile/Applications/84E285EB-8337-47B5-A63E-96226A8AB431/anim5.pod";
                        FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f] ytipo:@"obras" yId:[datos objectAtIndex:0] ytipo2:@"animacion"];
                        self.anim5 = ruta;
                    }
                }
            }
        }
    });
    return self;
}

-(obtObras*)initNombreIma:(NSString *)nombreImagen yIdSala:(NSString*)idSala{
    self.idObra = [[NSMutableString alloc] init];
    conn *c = [[conn alloc]initConFuncion:@"getNombreObra" NombreParametro:@"nombre_archivo" yNombreIma:nombreImagen yNombreSegParam:@"id_sala" yIdSala:idSala];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        self.idObra = [c getSoap];
        NSLog(@"idObra: %@",self.idObra);
        //conn *c2 = [[conn alloc]initconFunc:@"getNombreObraApartirDelID" yNomParam:@"id_obra" yParam:self.idObra];
        
    });
    return self;
}

-(NSMutableArray*)getNombre{
    return self.autorNombre;
}

-(NSMutableArray*)getAutor{
    return self.autorAutor;
}

-(NSMutableArray*)getDesc{
    return self.autorDesc;
}

-(NSMutableArray*)getImagen{
    return self.autorImagen;
}

-(NSMutableArray*)getObras{
    return self.obras;
}

-(NSString*)getAudio{
    return self.audio;
}

-(NSString*)getVideo{
    return self.video;
}

-(NSString*)getTexto{
    return self.texto;
}

-(NSString*)getModelo{
    return self.modelo3d;
}

-(NSMutableArray*)getAnimaciones{
    NSMutableArray *an = [[NSMutableArray alloc]init];
    [an addObject:self.anim1];
    [an addObject:self.anim2];
    [an addObject:self.anim3];
    [an addObject:self.anim4];
    [an addObject:self.anim5];
    return an;
}

@end
