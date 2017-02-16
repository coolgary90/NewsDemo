//
//  WebServiceResponse.m
//  ICreative
//
//  Created by Simrandeep Singh on 25/11/16.
//  Copyright © 2016 Simrandeep Singh. All rights reserved.
//

#import "WebServiceResponse.h"
#define kNetworkErrorMessage @"Connection Time Out. Please check your network connection."

@implementation WebServiceResponse

+ (instancetype) noInternetResponse
{
    WebServiceResponse* response = [[WebServiceResponse alloc] init];
    response.isSuccess = NO;
    response.errorString = kNetworkErrorMessage;
    
    return response;
}

@end
