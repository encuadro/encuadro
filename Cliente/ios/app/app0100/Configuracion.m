//
//  Configuracion.m
//  app0100
//
//  Created by encuadro on 10/2/14.
//
//

#import "Configuracion.h"

static NSString * HEADMENSAJE = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
"<soap:Body>\n";

static NSString * TAILMENSAJE = @"</soap:Body>\n"
"</soap:Envelope>\n";

@implementation Configuracion

+ (NSString *) SOAPMESSAGE:(NSString *)parameters{
    NSString * ret = [NSString stringWithFormat:@"%@%@%@",HEADMENSAJE,parameters,TAILMENSAJE ];
    return ret;
}
+ (NSString*) kPostURL {
		NSString * ret = [NSString stringWithFormat:@"http://%@/server_php/server_php.php",[self ipserver]];
	return ret;
}

+ (NSString*) ipserver {
	NSString *ret=@"164.73.57.5";
	return ret;
}

+ (NSString *) soapMethodInvocationVariable:(NSString *)arg1,...{
	NSMutableArray *arguments=[[NSMutableArray alloc]initWithArray:nil];
	id eachObject = 0;
	va_list argumentList;
	int counter = 0;
	
	if (arg1)
	{
		[arguments addObject: arg1];
		counter++;
		va_start(argumentList, arg1);
		while ((eachObject = va_arg(argumentList, id)))
		{
			[arguments addObject: eachObject];
			counter++;
		}
		va_end(argumentList);
	}
	
	
	//NSLog(@"******** TOTAL: %i ARGUMENTOS",counter);
	NSString *invocation;
	
	switch (counter) {
	case 1:{
			invocation = [NSString stringWithFormat:@"<%@ xmlns=\"%@/%@\">\n"
									"</%@>\n",[arguments objectAtIndex:0], [self kPostURL], [arguments objectAtIndex:0],
									[arguments objectAtIndex:0]];
			return invocation;
			break;
	}
		case 3:{
			invocation = [NSString stringWithFormat:@"<%@ xmlns=\"%@/%@\">\n"
									"<%@>%@</%@>"
									"</%@>\n",[arguments objectAtIndex:0], [self kPostURL], [arguments objectAtIndex:0],
									[arguments objectAtIndex:1], [arguments objectAtIndex:2], [arguments objectAtIndex:1],
									[arguments objectAtIndex:0]];
			return invocation;
			break;
		}
		case 5:{
			invocation = [NSString stringWithFormat:@"<%@ xmlns=\"%@/%@\">\n"
									"<%@>%@</%@>"
									"<%@>%@</%@>"
									"</%@>\n",[arguments objectAtIndex:0], [self kPostURL], [arguments objectAtIndex:0],
									[arguments objectAtIndex:1], [arguments objectAtIndex:2], [arguments objectAtIndex:1],
									[arguments objectAtIndex:3], [arguments objectAtIndex:4], [arguments objectAtIndex:3],
									[arguments objectAtIndex:0]];
			return invocation;
			break;
		}
		case 9: {
			invocation = [NSString stringWithFormat:@"<%@ xmlns=\"%@/%@\">\n"
									"<%@>%@</%@>"
									"<%@>%@</%@>"
									"<%@>%@</%@>"
									"<%@>%@</%@>"
									"</%@>\n",[arguments objectAtIndex:0], [self kPostURL], [arguments objectAtIndex:0],
									[arguments objectAtIndex:1], [arguments objectAtIndex:2], [arguments objectAtIndex:1],
									[arguments objectAtIndex:3], [arguments objectAtIndex:4], [arguments objectAtIndex:3],
									[arguments objectAtIndex:5], [arguments objectAtIndex:6], [arguments objectAtIndex:5],
									[arguments objectAtIndex:7], [arguments objectAtIndex:8], [arguments objectAtIndex:7],
									[arguments objectAtIndex:0]];
			return invocation;
			break;
		}
  default:
			break;
	}
}
@end
