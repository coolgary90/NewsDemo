//
//  WebServiceManager.m
//
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"
#include <sys/xattr.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>
#import <UIKit/UIKit.h>

#import "DataManager.h"



@implementation WebServiceManager

#pragma mark - GET requests
//+ (NSMutableURLRequest*) getAuthorizationRequestWithService:(NSString*)service
//{
//    NSMutableURLRequest* request = [WebServiceManager getRequestWithService:service];
////    NSString* token = gDataManager.user.token;
//    if (token)
//    {
//        [request setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    }
//    return request;
//}
//
//+ (NSMutableURLRequest*) getRequestWithUrl:(NSString*)url
//{
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
//                                    [NSURL URLWithString:url]];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
////    [request setValue:KSecretKey forHTTPHeaderField:@"x-api-key"];
//    [request setTimeoutInterval:60.0];
//    
//    return request;
//}

+ (NSMutableURLRequest*) getRequestWithService:(NSString*)service
{
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
									[NSURL URLWithString:service]];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setTimeoutInterval:60.0];

	return request;
}

#pragma mark - POST requests
//+ (NSMutableURLRequest*) postAuthorizationRequestWithService:(NSString*)service
//                                   withpostDict:(NSDictionary*)postDict
//{
//    NSMutableURLRequest* request = [WebServiceManager postRequestWithService:service withpostDict:postDict];
////    NSString* token = gDataManager.user.token;
//    if (token)
//    {
//        [request setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    }
//    return request;
//}
//
//+ (NSMutableURLRequest*) postRequestWithService:(NSString*)service
//                                withpostDict:(NSDictionary*)postDict
//{
////    NSString* urlString = [kBaseURL stringByAppendingString:service];
////    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//
//    NSData* postData = [NSJSONSerialization dataWithJSONObject:postDict
//                                                       options:NSJSONWritingPrettyPrinted error:nil];;
//    
//    NSString* postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
//    
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
//                                    [NSURL URLWithString:urlString]];
//    
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
////    [request setValue:KSecretKey forHTTPHeaderField:@"x-api-key"];
//	[request setTimeoutInterval:60.0];
//    [request setHTTPBody:postData];
//	
//    return request;
//}

#pragma mark - Send Request

+ (void) sendRequest:(NSURLRequest*)request
          completion:(void (^)(WebServiceResponse* response)) callback
{
    if ([WebServiceManager isConnectedToNetwork] == NO)
    {
        
        callback([WebServiceResponse noInternetResponse]);
        return;
    }
    
    [WebServiceManager printRequest:request];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
    completionHandler:^(NSData* responseData,NSURLResponse* response, NSError* error)
  {
	  [WebServiceManager printResponse:responseData];
      
      WebServiceResponse* serviceResponse = [[WebServiceResponse alloc] init];
      NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
      NSUInteger responseStatusCode = [httpResponse statusCode];
      
      if (responseStatusCode == 200 || responseStatusCode == 201 || responseStatusCode == 202)
      {
          dispatch_async(dispatch_get_main_queue(), ^
                         {
                             
                            serviceResponse.responseData = responseData;
                            serviceResponse.status=true;

                             
                             callback(serviceResponse);
                         });
      }
      else
      {
          dispatch_async(dispatch_get_main_queue(), ^
                        {
                            NSDictionary* responseDict = nil;
                            if (responseData)
                            {
                                responseDict = [[NSJSONSerialization
                                             JSONObjectWithData:responseData options:kNilOptions error:nil] objectForKey:@"response"];
                            }
                            
//							NSString* errorString = (responseDict) ? [responseDict objectForKey:@"message"] : kServiceErrorMessage;
//                            serviceResponse.isSuccess = NO;
//                            serviceResponse.errorString = errorString;
                             callback(serviceResponse);
                         });
      }
      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  }];
    
    [dataTask resume];
}

+ (BOOL) isConnectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    // synchronous model
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
//        MFLogDEBUGINFO(@"Error. Could not recover network reachability flags\n");
        return 0;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    return (isReachable && !needsConnection);
}

+ (BOOL) isConnectedToWifi
{
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	BOOL success = SCNetworkReachabilityGetFlags(reachability, &flags);
	CFRelease(reachability);
	if (!success) {
		return NO;
	}
	BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
	BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
	BOOL isNetworkReachable = (isReachable && !needsConnection);
	
	if (!isNetworkReachable) {
		return NO;
	} else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
		return NO;
	} else {
		return YES;
	}
}

+ (void) printRequest:(NSURLRequest*)customUrlRequest
{
//	MFLogDEBUGINFO(@"Request# \n URL : %@ \n Headers : %@ \n Request Method : %@ \n Post body : %@\n",customUrlRequest.URL.absoluteString, customUrlRequest.allHTTPHeaderFields.description,customUrlRequest.HTTPMethod,customUrlRequest.HTTPBody?[NSJSONSerialization JSONObjectWithData:customUrlRequest.HTTPBody options:0 error:NULL]:customUrlRequest.HTTPBody);
}

+ (void) printResponse:(NSData*)data
{
	if (data) {
		NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"%@",responseString);
//		MFLogDEBUGINFO(@"Response String # %@",responseString);
	}
}
@end
