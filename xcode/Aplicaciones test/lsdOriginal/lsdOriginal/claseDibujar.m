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

@synthesize cantidadLsd=_cantidadLsd;

@synthesize segmentos_lsd=segmentos_lsd;
@synthesize dealloc=_dealloc;


@synthesize lsd_all=_lsd_all;


double cgx1;
double cgy1;
double cgx2;
double cgy2;
CGPoint puntos2[2], puntos[2];
double cgesq1;
double cgesq2;
double cgrep1;
double cgrep2;
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
//               printf("%d\n",self.cantidadLsd);
//                    printf("%f\t %f \t %f\t %f\n",cgx1,cgy1,cgx2,cgy2);
        }

    }
    
}



@end
