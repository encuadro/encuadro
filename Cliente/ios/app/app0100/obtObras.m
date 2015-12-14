//
//  obtObras.m
//  app0100
//
//  Created by encuadro on 3/7/13.
//
//

#import "obtObras.h"
#import "Parser.h"
#import "conn.h"

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
    Parser *parser = [[Parser alloc]init];
    self.obras = [[NSMutableArray alloc] init];
    self.autorNombre = [[NSMutableArray alloc] init];
    self.autorAutor = [[NSMutableArray alloc] init];
    self.autorDesc = [[NSMutableArray alloc] init];
    self.autorImagen = [[NSMutableArray alloc] init];
	
	//conn *c = [[conn alloc] initconFunc:@"getAllDataObraSala" yNomParam:@"id" yParam:idSala];
	NSString *funcName = @"getAllDataObraSala";
	NSString *arguments = [Configuracion soapMethodInvocationVariable: funcName, @"id", idSala, nil];
	conn *c = [[conn alloc] initGenerico:arguments functionName:funcName];
	NSLog(@"PRUEBA_1");
	
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
            [parser parsing:h];
            for(int x=0;x<parser.length;x++){
            [self.obras addObject:[parser getParameter:@"id_obra":x]];
            [self.autorNombre addObject:[parser getParameter:@"nombre_obra":x]];
            [self.autorAutor addObject:[parser getParameter:@"autor":x]];
            [self.autorDesc addObject:[parser getParameter:@"descripcion":x]];
            [self.obras addObject:[parser getParameter:@"imagen":x]];
            NSString *rutita = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
            FTP *ftp = [[FTP alloc] initWithString:rutita yotroString:[parser getParameter:@"imagen":x]];
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
    Parser *parser;
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
	
	//conn *c = [[conn alloc]initconFunc:@"getContenidoObra" yNomParam:@"nombre" yParam:idObra];
	
	NSString *funcName = @"getContenidoObra";
	NSString *arguments = [Configuracion soapMethodInvocationVariable: funcName, @"nombre", idObra, nil];
	conn *c = [[conn alloc] initGenerico:arguments functionName:funcName];
	NSLog(@"PRUEBA_2");
	
	
    while(!finish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSMutableString *contenidos = [c getSoap];
    if(worked == YES){
        parser = [[Parser alloc]initWhitString:contenidos];
        FTP *ft;
        //obtiene audio
        if(![[parser getParameter:@"audio"] isEqualToString:@"null"]){
            NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
            ft= [[FTP alloc] initWithString:ruta yotroString:[parser getParameter:@"audio"]];
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
        //obtiene video
        if(![[parser getParameter:@"video"] isEqualToString:@"null"]){
            NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
            ft = [[FTP alloc] initWithString:ruta yotroString:[parser getParameter:@"video"]];
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
        //obtiene texto
        self.texto = [parser getParameter:@"texto"];
        //obtiene modelo
        if(![[parser getParameter:@"modelo"] isEqualToString:@"null"]){
            NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
            ft = [[FTP alloc] initWithString:ruta yotroString:[parser getParameter:@"modelo"]];
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
        //obtiene animaciones
        NSArray *anim = [[parser getParameter:@"anim"] componentsSeparatedByString:@"=>"];
        if([[anim objectAtIndex:0] isEqualToString:@"null"]){
                self.anim1 = @"null";
                self.anim2 = @"null";
                self.anim3 = @"null";
                self.anim4 = @"null";
                self.anim5 = @"null";
        }else{
           NSMutableArray *animaciones = [[NSMutableArray alloc]init];
          for(int f=0;f<anim.count-1;f++){
            NSLog(@"%@", [anim objectAtIndex:f]);
            NSString *ruta = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
            ft = [[FTP alloc] initWithString:ruta yotroString:[anim objectAtIndex:f]];
            while(!finiteFTP) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            if(anduvo == NO)
                animaciones[f]=@"null";//[animaciones setValue:@"null" forKey:f];//self.anim1 = @"null";
            else
                animaciones[f]=ruta;//[animaciones setValue:ruta forKey:f];//self.anim1 = ruta;
            
         }
        self.anim1 = animaciones[0];
        self.anim2 = animaciones[1];
        self.anim3 = animaciones[2];
        self.anim4 = animaciones[3];
        self.anim5 = animaciones[4];
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
	
	//conn *c = [[conn alloc]initConFuncion:@"getNombreObra" NombreParametro:@"nombre_archivo" yNombreIma:nombreImagen yNombreSegParam:@"id_sala" yIdSala:idSala];
	
	//NSString *arguments1 = [Configuracion soapMethodInvocationVariable: @"getNombreObra", @"nombre_archivo", nombreImagen, @"id_sala", idSala, nil];

	NSString *funcName = @"getNombreObra";
	NSString *arguments1 = [Configuracion soapMethodInvocationVariable: funcName, @"id_sala", idSala, @"nombre_archivo", nombreImagen, nil];
	conn *c = [[conn alloc] initGenerico:arguments1 functionName:funcName];
	NSLog(@"PRUEBA_3");
	
	while(!finish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSMutableString *ms = [c getSoap];
    self.idObra = ms;
	
	//conn *c3 = [[conn alloc] initconFunc:@"getNombreObraApartirDelID" yNomParam:@"id_obra" yParam:self.idObra];
	
	NSString *funcName2 = @"getNombreObraApartirDelID";
	NSString *arguments3 = [Configuracion soapMethodInvocationVariable: funcName2, @"id_obra", self.idObra, nil];
	conn *c3 = [[conn alloc] initGenerico:arguments3 functionName:funcName2];
	NSLog(@"PRUEBA_4");
	NSLog(@"idObra: %@", self.idObra);
	
    while(!finish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
	NSLog(@"getSOAP: %@", [c3 getSoap]);
    self.nombreObra = [c3 getSoap];
    [self obtDatosObraConNombreObra:self.nombreObra];
    [self initConNombreObraParaContenidos:self.nombreObra];
    finOb =YES;
    return self;
}


-(void)obtDatosObraConNombreObra:(NSString *)nombreObra{
    Parser *parser;
	//conn *c = [[conn alloc] initconFunc:@"getDataObra" yNomParam:@"nombre_obra" yParam:nombreObra];
	NSString *funcName = @"getDataObra";
	NSString *arguments = [Configuracion soapMethodInvocationVariable:funcName, @"nombre_obra", nombreObra, nil];
	conn *c = [[conn alloc] initGenerico:arguments functionName:funcName];
	
    while(!finish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSMutableString *cmas = [c getSoap];
    if(worked == YES){
        parser = [[Parser alloc]initWhitString:(cmas)];
        [self.autorNombre addObject:[parser getParameter:@"nombre_obra"]];
        [self.autorAutor addObject:[parser getParameter:@"autor"]];
        [self.autorDesc addObject:[parser getParameter:@"descripcion_obra"]];
        NSString *rutita = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
        FTP *f = [[FTP alloc] initWithString:rutita yotroString:[parser getParameter:@"imagen"]];
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
