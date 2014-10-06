//
//  ImagenServerViewController.h
//  app0c
//
//  Created by encuadro augmented reality on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ReaderSampleViewController.h"
#import "ObraCompletaViewController.h"
#import "NetworkManager.h"
#import "FTPUpload.h"
#import "ReaderSampleViewController.h"
#import "obtObras.h"

#import "EstadoJuego.h"

NSString *returnString;
@interface ImagenServerViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UIActivityIndicatorView *activity;
    UIImageView *imagenView;
    UIButton *tomarFoto;

}


@property (nonatomic,retain)IBOutlet UIImageView *imagenView;
@property (nonatomic,retain)IBOutlet UIButton *tomarFoto;
@property (nonatomic, retain)IBOutlet UIButton *enviar;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *twitt;
-(IBAction)tomarFoto:(id)sender;

@property(nonatomic,retain)NSString *filePath;
//

//
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) IBOutlet UILabel *load;
//@property (retain, nonatomic) IBOutlet UIView *vista;
@property (retain, nonatomic) IBOutlet UILabel *mensaje;
-(void)subir;
-(IBAction)tweet;
//tipo recorrido
@property (nonatomic, retain) NSString * AuxTipoRecorridoISVC;
//
@property (nonatomic, retain) NSString * AuxSiguientePImagen;
@property (nonatomic, retain) NSString * AuxJImagen;
@property (nonatomic, retain) NSString * AuxContarJImagen;
@property (nonatomic, retain) NSString * AuxHoraJImagen;

@property (retain,nonatomic) EstadoJuego * juego;

@end
