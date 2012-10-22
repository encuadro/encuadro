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
@synthesize cantidadLsd=_cantidadLsd;

@synthesize segmentos_lsd=segmentos_lsd;
@synthesize segmentos = _segmenos;
@synthesize esquinas = _esquinas;
@synthesize esquinasReproyectadas = _esquinasReproyectadas;
@synthesize dealloc=_dealloc;

@synthesize segments=_segments;
@synthesize corners=_corners;
@synthesize reproyected=_reproyected;
@synthesize lsd_all=_lsd_all;


CGFloat cgx1;
CGFloat cgy1;
CGFloat cgx2;
CGFloat cgy2;
CGPoint puntos2[2], puntos[2];
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
//        self.transform =CGAffineTransformMake(0, 1, -1, 0, 0, 0);
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
        
        /*Para el iPad*/
        if (self.segments)
        {
            cgx1=self.segmentos[i*dim]*1024/480;
            cgy1=self.segmentos[i*dim+1]*768/360;
            cgx2=self.segmentos[i*dim+2]*1024/480;
            cgy2=self.segmentos[i*dim+3]*768/360;
            
            
            CGContextSetRGBStrokeColor(context, 255, 0, 0, 1);
            puntos2[0]=CGPointMake(cgx1,cgy1);
            puntos2[1]=CGPointMake(cgx2,cgy2);
            CGContextStrokeLineSegments(context, puntos2, 2);
            
            
        }
        
        if (i<36){
            if (self.corners)
            {
                
                
                cgesq1=self.esquinas[i][0]*1024/480;
                cgesq2=self.esquinas[i][1]*768/360;
                
                
                text = [UITextField new];
                [text setTextColor: [UIColor greenColor]];
                
                [text setText:[NSString stringWithFormat:@"%d", i]];
                [text drawTextInRect:CGRectMake(cgesq1, cgesq2, 20, 20)];
                
                CGContextStrokeRect(context, CGRectMake(cgesq1, cgesq2, 4, 4));
                
                [text release];
                
            }
            
            if (self.reproyected)
            {
                
                
                cgrep1=self.esquinasReproyectadas[i][0]*1024/(480*self.esquinasReproyectadas[i][2]);
                cgrep2=self.esquinasReproyectadas[i][1]*768/(360*self.esquinasReproyectadas[i][2]);
                
                
                CGContextSetRGBStrokeColor(context, 0, 0,255, 1);
                CGContextStrokeRect(context, CGRectMake(cgrep1, cgrep2, 4, 4));
                
            }
        }
    }
    
    if (self.lsd_all)
    {
        for(int i=0;i<self.cantidadLsd;i++){
            
            cgx1=self.segmentos_lsd[i*dim]*1024/480;
            cgy1=self.segmentos_lsd[i*dim+1]*768/360;
            cgx2=self.segmentos_lsd[i*dim+2]*1024/480;
            cgy2=self.segmentos_lsd[i*dim+3]*768/360;
            
      
            
            CGContextSetRGBStrokeColor(context, 255, 255, 255, 1);
            puntos[0]=CGPointMake(cgx1,cgy1);
            puntos[1]=CGPointMake(cgx2,cgy2);
            CGContextStrokeLineSegments(context, puntos, 2);
            
           // if (((cgx1==0)&&(cgy1==768))|| ((cgx2==0)&&(cgy2==768))) printf("%d \t %d\n",i,self.cantidadLsd);
               printf("%d\n",self.cantidadLsd);
                    printf("%f\t %f \t %f\t %f\n",cgx1,cgy1,cgx2,cgy2);
        }

    }
    
}



@end
