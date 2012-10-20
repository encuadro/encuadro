//
//  HelloWorldView.m
//  lsd_original
//
//  Created by Pablo Flores Guridi on 20/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"
#import "Isgl3dViewController.h"

/*viewView*/
@implementation videoView


- (id) init {
	
	if ((self = [super init])) {
        
	}
	
	return self;
}



- (void) dealloc {
    
	[super dealloc];
}

@end


/*HelloWorldView*/
@interface HelloWorldView()

@end


@implementation HelloWorldView


bool corners, segments, reproyected, lsd_all;


- (bool) getLsd_all
{
    return lsd_all;
}

- (id) init {
	/*"Si el init del padre anduvo bien..."*/
	if ((self = [super init])) {
        
        
        if (false) printf("init del HelloWorldView\n");
        lsd_all=NO;
 
        
        /* Create a container node as a parent for all scene objects.*/
        _container = [self.scene createNode];
               
        /* Generamos el boton para dibujar los segmentos del LSD */
        
        Isgl3dTextureMaterial * lsdMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"LSD.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dGLUIButton * lsdButton = [Isgl3dGLUIButton buttonWithMaterial:lsdMaterial width:14.4 height:9.8];
		[self.scene addChild:lsdButton];
        
        
        [lsdButton setX:30 andY:20];
        
        lsdButton.interactive = YES;
        [lsdButton addEvent3DListener:self method:@selector(lsdTouched:) forEventType:TOUCH_EVENT];
        
        self.camera.position = iv3(0,0,0.1);
        [self.camera setLookAt:iv3(self.camera.x, self.camera.y,0) ];
        
        /*Seteamos el fov.*/
        self.camera.fov = 34.441;
        
        [self schedule:@selector(tick:)];
	}
	return self;
}

- (void) dealloc {
    
	[super dealloc];
}


- (void) tick:(float)dt {

    
}

- (void) lsdTouched:(id)sender {
    
    if (lsd_all==YES) {
        lsd_all =NO;
        printf("LSD no\n");
    }
    else if (lsd_all==NO) {
        lsd_all=YES;
        printf("LSD si\n");
    }
}


@end

