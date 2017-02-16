//
//  WebServiceManager.h
//
//

//#import "Defines.h"
#import <Foundation/Foundation.h>
#import "WebServiceResponse.h"

@interface WebServiceManager : NSObject


+ (NSMutableURLRequest*) getAuthorizationRequestWithService:(NSString*)service;
+ (NSMutableURLRequest*) getRequestWithUrl:(NSString*)url;

+ (NSMutableURLRequest*) getRequestWithService:(NSString*)service;

+ (NSMutableURLRequest*) postAuthorizationRequestWithService:(NSString*)service
                                                withpostDict:(NSDictionary*)postDict;

+ (NSMutableURLRequest*) postRequestWithService:(NSString*)service
                            withpostDict:(NSDictionary*)postDict;

+ (void) sendRequest:(NSURLRequest*)request
		  completion:(void (^)(WebServiceResponse* response)) callback;

+ (BOOL) isConnectedToNetwork;
+ (BOOL) isConnectedToWifi;

+ (void) printRequest:(NSURLRequest*)customUrlRequest;
+ (void) printResponse:(NSData*)data;

@end
