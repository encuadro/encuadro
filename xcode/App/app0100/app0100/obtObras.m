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
    finOb = NO;
    self.autorNombre = [[NSMutableArray alloc] init];
    self.autorAutor = [[NSMutableArray alloc] init];
    self.autorDesc = [[NSMutableArray alloc] init];
    self.autorImagen = [[NSMutableArray alloc] init];
    conn *c = [[conn alloc]initconFunc:@"getObraSala" yNomParam:@"id" yParam:idSala];
    while(!finish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSMutableString *h = [c getSoap];
    NSArray *h2 = [h componentsSeparatedByString:@"=>"];
    self.obras = [[NSMutableArray alloc] init];
    int sized = [h2 count];
    for(int i=0;i<sized-1;i++){
        [self.obras addObject:[h2 objectAtIndex:i]];
        conn *c2 = [[conn alloc] initconFunc:@"getDataObra" yNomParam:@"nombre_obra" yParam:[h2 objectAtIndex:i]];
        while(!finish) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSMutableString *cmas = [c2 getSoap];
        NSArray *datosObra = [cmas componentsSeparatedByString:@"=>"];
        [self.autorNombre addObject:[datosObra objectAtIndex:1]];
        [self.autorAutor addObject:[datosObra objectAtIndex:6]];
        [self.autorDesc addObject:[datosObra objectAtIndex:2]];
        NSString *rutita = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
        FTP *f = [[FTP alloc] initWithString:rutita yotroString:[datosObra objectAtIndex:4] ytipo:@"obras" yId:[datosObra objectAtIndex:0] ytipo2:@"imagen"];
        while(!finiteFTP) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        [self.autorImagen addObject:rutita];
        }
    finOb = YES;
    return self;
}

-(obtObras*)initConNombreObraParaContenidos:(NSString *)idObra{
    finOb = NO;
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
    while(!finish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSMutableString *contenidos = [c getSoap];
    NSArray *datos = [contenidos componentsSeparatedByString:@"=>"];
    for(int f=1;f<=12;f++){
        if(f == 1){
            if(![[datos objectAtIndex:f] isEqualToString:@"null"]){
                NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f] ytipo:@"obras" yId:[datos objectAtIndex:0] ytipo2:@"audio"];
                while(!finiteFTP) {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
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
                while(!finiteFTP) {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
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
                while(!finiteFTP) {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
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
                    FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f] ytipo:@"obras" yId:[datos objectAtIndex:0] ytipo2:@"animacion"];
                    while(!finiteFTP) {
                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    }
                    self.anim1 = ruta;
                }
                if(f==9){
                    NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                    FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f] ytipo:@"obras" yId:[datos objectAtIndex:0] ytipo2:@"animacion"];
                    while(!finiteFTP) {
                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    }
                    self.anim2 = ruta;
                }
                if(f==10){
                    NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                    FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f] ytipo:@"obras" yId:[datos objectAtIndex:0] ytipo2:@"animacion"];
                    while(!finiteFTP) {
                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    }
                    self.anim3 = ruta;
                }
                if(f==11){
                    NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                    FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f] ytipo:@"obras" yId:[datos objectAtIndex:0] ytipo2:@"animacion"];
                    while(!finiteFTP) {
                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    }
                    self.anim4 = ruta;
                }
                if(f==12){
                    NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                    FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f] ytipo:@"obras" yId:[datos objectAtIndex:0] ytipo2:@"animacion"];
                    while(!finiteFTP) {
                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    }
                    self.anim5 = ruta;
                }
            }
        }
    }
    finOb = YES;
    return self;
}


-(obtObras*)initNombreIma:(NSString *)nombreImagen yIdSala:(NSString*)idSala{
    finOb = NO;
    self.autorNombre = [[NSMutableArray alloc] init];
    self.autorAutor = [[NSMutableArray alloc] init];
    self.autorDesc = [[NSMutableArray alloc] init];
    self.autorImagen = [[NSMutableArray alloc] init];
    self.idObra = [NSString stringWithFormat:@"%@",@"-1"];
    conn *c = [[conn alloc]initConFuncion:@"getNombreObra" NombreParametro:@"nombre_archivo" yNombreIma:nombreImagen yNombreSegParam:@"id_sala" yIdSala:idSala];
    while(!finish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSMutableString *ms = [c getSoap];
    NSLog(@"idDEsc: %@",ms);
    NSString *nms = [NSString stringWithString:ms];
    do{
        conn *c2 = [[conn alloc] initconFunc:@"terminoDescriptor" yNomParam:@"id_descriptor" yParam:nms];
        while(!finish) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        self.idObra = [c2 getSoap];
    }while([self.idObra isEqualToString:@"-1"] || !(self.idObra));
    conn *c3 = [[conn alloc] initconFunc:@"getNombreObraApartirDelID" yNomParam:@"id_obra" yParam:self.idObra];
    while(!finish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    self.nombreObra = [c3 getSoap];
    [self obtDatosObraConNombreObra:self.nombreObra];
    [self initConNombreObraParaContenidos:self.nombreObra];
    finOb =YES;
    return self;
}

-(void)obtDatosObraConNombreObra:(NSString *)nombreObra{
    conn *c = [[conn alloc] initconFunc:@"getDataObra" yNomParam:@"nombre_obra" yParam:nombreObra];
    while(!finish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSMutableString *cmas = [c getSoap];
    NSArray *datosObra = [cmas componentsSeparatedByString:@"=>"];
    [self.autorNombre addObject:[datosObra objectAtIndex:1]];
    [self.autorAutor addObject:[datosObra objectAtIndex:6]];
    [self.autorDesc addObject:[datosObra objectAtIndex:2]];
    NSString *rutita = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
    FTP *f = [[FTP alloc] initWithString:rutita yotroString:[datosObra objectAtIndex:4] ytipo:@"obras" yId:[datosObra objectAtIndex:0] ytipo2:@"imagen"];
    while(!finiteFTP) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [self.autorImagen addObject:rutita];
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
