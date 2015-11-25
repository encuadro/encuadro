//
//  ViewController.h
//  test_WS
//
//  Created by Juan Cardelino on 11/23/15.
//  Copyright © 2015 Juan Cardelino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
	NSMutableData *webData;
	NSMutableString *soapResults;
	NSXMLParser *xmlParser;
	UILabel *etiqueta;
}

	-(IBAction)buttonClick;
	-(void *)pruebaConexion;
	@property (nonatomic, retain) IBOutlet UILabel *etiqueta;
	@property (nonatomic, retain) NSMutableData* webData;
@end

