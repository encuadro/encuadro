//
//  obtObras.m
//  app0100
//
//  Created by encuadro on 3/7/13.
//
//

#import "obtObras.h"


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
    self.obras = [[NSMutableArray alloc] init];
    self.autorNombre = [[NSMutableArray alloc] init];
    self.autorAutor = [[NSMutableArray alloc] init];
    self.autorDesc = [[NSMutableArray alloc] init];
    self.autorImagen = [[NSMutableArray alloc] init];
    conn *c = [[conn alloc] initconFunc:@"getAllDataObraSala" yNomParam:@"id" yParam:idSala];
    while(!finish){
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSMutableString *h = [c getSoap];
    if(worked == YES){
        if([h isEqualToString:@"-1"]){
            [self.obras addObject:@"-1"];
            [self.autorNombre addObject:@"-1"];
            [self.autorAutor addObject:@"-1"];
            [self.autorDesc addObject:@"-1"];
            [self.autorImagen addObject:@"-1"];
        }
        else{
            NSArray *h2 = [h componentsSeparatedByString:@"=>"];
            int sized = [h2 count];
            int cont = 0;
            for(int i=0;i<sized-1;i=i+5){
                [self.obras addObject:[h2 objectAtIndex:i]];
            }
            for(int i=1;i<sized;i=i+5){
                [self.autorNombre addObject:[h2 objectAtIndex:i]];
            }
            for(int i=2;i<sized;i=i+5){
                [self.autorAutor addObject:[h2 objectAtIndex:i]];
            }
            for(int i=3;i<sized;i=i+5){
                [self.autorDesc addObject:[h2 objectAtIndex:i]];
            }
            for(int i=4;i<sized;i=i+5){
                NSString *rutita = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                FTP *f = [[FTP alloc] initWithString:rutita yotroString:[h2 objectAtIndex:i]];
                while(!finiteFTP) {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
                if(anduvo == NO)
                    [self.autorImagen addObject:[[NSBundle mainBundle] pathForResource:@"enCuadroIcon" ofType:@"png"]];
                else
                    [self.autorImagen addObject:rutita];
            }
        }
    }
    else{
        [self.obras addObject:@"-1"];
        [self.autorNombre addObject:@"-1"];
        [self.autorAutor addObject:@"-1"];
        [self.autorDesc addObject:@"-1"];
        [self.autorImagen addObject:@"-1"];
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
    if(worked == YES){
        NSArray *datos = [contenidos componentsSeparatedByString:@"=>"];
        for(int f=1;f<=12;f++){
            if(f == 1){
                if(![[datos objectAtIndex:f] isEqualToString:@"null"]){
                    NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                    FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f]];
                    while(!finiteFTP) {
                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    }
                    if(anduvo == NO)
                        self.audio = @"null";
                    else
                        self.audio = ruta;
                }
                else
                    self.audio = @"null";
            }
            if (f == 2){
                if(![[datos objectAtIndex:f] isEqualToString:@"null"]){
                    NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                    FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f]];
                    while(!finiteFTP) {
                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    }
                    if(anduvo == NO)
                        self.video = @"null";
                    else
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
                    FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f]];
                    while(!finiteFTP) {
                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    }
                    if(anduvo == NO)
                        self.modelo3d = @"null";
                    else
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
                        NSLog(@"%@", [datos objectAtIndex:f]);
                        NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                        FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f]];
                        while(!finiteFTP) {
                            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                        }
                        if(anduvo == NO)
                            self.anim1 = @"null";
                        else
                            self.anim1 = ruta;
                    }
                    if(f==9){
                        NSLog(@"%@", [datos objectAtIndex:f]);
                        NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                        FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f]];
                        while(!finiteFTP) {
                            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                        }
                        if(anduvo == NO)
                            self.anim2 = @"null";
                        else
                            self.anim2 = ruta;
                    }
                    if(f==10){
                        NSLog(@"%@", [datos objectAtIndex:f]);
                        NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                        FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f]];
                        while(!finiteFTP) {
                            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                        }
                        if(anduvo == NO)
                            self.anim3 = @"null";
                        else
                            self.anim3 = ruta;
                    }
                    if(f==11){
                        NSLog(@"%@", [datos objectAtIndex:f]);
                        NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                        FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f]];
                        while(!finiteFTP) {
                            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                        }
                        if(anduvo == NO)
                            self.anim4 = @"null";
                        else
                            self.anim4 = ruta;
                    }
                    if(f==12){
                        NSLog(@"%@", [datos objectAtIndex:f]);
                        NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                        FTP *ft = [[FTP alloc] initWithString:ruta yotroString:[datos objectAtIndex:f]];
                        while(!finiteFTP) {
                            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                        }
                        if(anduvo == NO)
                            self.anim5 = @"null";
                        else
                            self.anim5 = ruta;
                    }
                }
            }
        }
    }
    else{
        self.audio = @"null";
        self.video = @"null";
        self.modelo3d = @"null";
        self.anim1 = @"null";
        self.anim2 = @"null";
        self.anim3 = @"null";
        self.anim4 = @"null";
        self.anim5 = @"null";

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
    self.idObra = ms;
    /*do{
        conn *c2 = [[conn alloc] initconFunc:@"terminoDescriptor" yNomParam:@"id_descriptor" yParam:nms];
        while(!finish) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        self.idObra = [c2 getSoap];
    }while([self.idObra isEqualToString:@"-1"] || !(self.idObra));*/
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
    if(worked == YES){
        NSArray *datosObra = [cmas componentsSeparatedByString:@"=>"];
        [self.autorNombre addObject:[datosObra objectAtIndex:1]];
        [self.autorAutor addObject:[datosObra objectAtIndex:6]];
        [self.autorDesc addObject:[datosObra objectAtIndex:2]];
        NSString *rutita = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
        FTP *f = [[FTP alloc] initWithString:rutita yotroString:[datosObra objectAtIndex:4]];
        while(!finiteFTP) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        if(anduvo == NO)
            [self.autorImagen addObject:[[NSBundle mainBundle] pathForResource:@"enCuadroIcon" ofType:@"png"]];
        else
            [self.autorImagen addObject:rutita];
    }
    else{
        [self.obras addObject:@"-1"];
        [self.autorNombre addObject:@"-1"];
        [self.autorAutor addObject:@"-1"];
        [self.autorDesc addObject:@"-1"];
        [self.autorImagen addObject:@"-1"];
    }
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
////
-(NSString*)getIdObras{
    return self.idObra;
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
