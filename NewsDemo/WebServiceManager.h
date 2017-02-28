//
//  WebServiceManager.h
//
//

//#import "Defines.h"
#import <Foundation/Foundation.h>
#import "WebServiceResponse.h"

@interface WebServiceManager : NSObject




+ (NSMutableURLRequest*) getRequestWithService:(NSString*)service;

+ (void) sendRequest:(NSURLRequest*)request
		  completion:(void (^)(WebServiceResponse* response)) callback;

+ (BOOL) isConnectedToNetwork;
+ (BOOL) isConnectedToWifi;

+ (void) printRequest:(NSURLRequest*)customUrlRequest;
+ (void) printResponse:(NSData*)data;

@end
