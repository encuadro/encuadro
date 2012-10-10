//
//  claseDibujar.m
//  LSD
//
//  Created by juani on 12/29/11.
//  Copyright (c) 2011 pablofloresguridi@gmail.com. All rights reserved.
//

#import "claseDibujar.h"
//#include "lsd_cmd.h"
//#include "segments.h"

@implementation claseDibujar

@synthesize cantidadSegmentos = _cantidadSegmentos;
@synthesize segmentos = _segmenos;
@synthesize esquinas = _esquinas;
@synthesize esquinasReproyectadas = _esquinasReproyectadas;
@synthesize dealloc=_dealloc;

@synthesize segments=_segments;
@synthesize corners=_corners;
@synthesize reproyected=_reproyected;


CGFloat cgx1;
CGFloat cgy1;
CGFloat cgx2;
CGFloat cgy2;
CGPoint puntos2[2];
CGFloat cgesq1;
CGFloat cgesq2;
CGFloat cgrep1;
CGFloat cgrep2;
int dim=7;

UITextField *text;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.transform =CGAffineTransformMake(0, 1, -1, 0, 0, 0);
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*Dibujo lineas*/
    
    for(int i=0;i<self.cantidadSegmentos;i++){
        
        /*Las primeras 4 lineas son las del borde de la pantalla*/
        

            cgx1=self.segmentos[i*dim]*1024/480;
            cgy1=self.segmentos[i*dim+1]*768/360;
            cgx2=self.segmentos[i*dim+2]*1024/480;
            cgy2=self.segmentos[i*dim+3]*768/360;
            
            
            CGContextSetRGBStrokeColor(context, 255, 0, 0, 1);
            puntos2[0]=CGPointMake(cgx1,cgy1);
            puntos2[1]=CGPointMake(cgx2,cgy2);
            CGContextStrokeLineSegments(context, puntos2, 2);
          }
    
}



@end
