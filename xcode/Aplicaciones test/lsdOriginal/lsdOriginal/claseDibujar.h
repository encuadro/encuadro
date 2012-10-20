//
//  claseDibujar.h
//  LSD
//
//  Created by juani on 12/29/11.
//  Copyright (c) 2011 pablofloresguridi@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface claseDibujar : UIView


@property(nonatomic, readwrite) int cantidadLsd;

@property(nonatomic, readwrite) double* segmentos_lsd;

@property(nonatomic, readwrite) int dealloc;
;
@property(nonatomic, readwrite) bool lsd_all;

- (id)initWithFrame:(CGRect)frame;
-(void)drawRect:(CGRect)rect; //cantidadSeg:(int) cantidadSeg segmentos: (float*) segmentos;

@end
