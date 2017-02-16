//
//  WebServiceResponse.h
//  ICreative
//
//  Created by Simrandeep Singh on 25/11/16.
//  Copyright © 2016 Simrandeep Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceResponse : NSObject

@property (nonatomic, strong) NSData* responseData;
@property (nonatomic, strong) NSString* errorString;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) BOOL isSuccess;

+ (instancetype) noInternetResponse;
@end
