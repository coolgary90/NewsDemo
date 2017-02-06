//
//  NDWebServices.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 06/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#import "NDWebServices.h"

@implementation NDWebServices


+ (NDWebServices*)sharedInstance
{
    static NDWebServices* sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[super alloc]init];
        
    });
    return sharedObject;
}


- (void)getNewsSources
{
    NSDictionary* __block jsonResponse;
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURLSessionDataTask* dataTask = [ session dataTaskWithURL:[NSURL URLWithString:@"https://newsapi.org/v1/sources?language=en"] completionHandler: ^(NSData* data , NSURLResponse* response , NSError* error){
    if(error == nil)
    {
    jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SourceListLoaded" object:self userInfo:jsonResponse];
        
    }
    }];
    [dataTask resume];
    
}

- (void)getNewsList:(NSString*)newsSource
{
    NSDictionary* __block jsonResponse;
    NSString* urlString = [NSString stringWithFormat:@"https://newsapi.org/v1/articles?source=%@&apiKey=589e9375eca54120bc116e72ae1d9eeb",newsSource];
    
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURLSessionDataTask* dataTask = [ session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler: ^(NSData* data , NSURLResponse* response , NSError* error){
        
        if(error == nil)
        {
            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsListLoaded" object:self userInfo:jsonResponse];
            
        }
    }];
    [dataTask resume];

    
}

- (void)getNewsListSortedBy:(NSString *)newsSource sortedBy:(NSString*)sort
{
    
    NSDictionary* __block jsonResponse;
    NSString* urlString = [NSString stringWithFormat:@"https://newsapi.org/v1/articles?source=%@&sortBy=%@&apiKey=589e9375eca54120bc116e72ae1d9eeb",newsSource,sort];
    
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURLSessionDataTask* dataTask = [ session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler: ^(NSData* data , NSURLResponse* response , NSError* error){
        
        if(error == nil)
        {
            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsListLoaded" object:self userInfo:jsonResponse];
            
        }
    }];
    [dataTask resume];
}
@end
