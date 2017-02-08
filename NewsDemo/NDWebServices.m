//
//  NDWebServices.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 06/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "Define.h"
#import "NDWebServices.h"

@implementation NDWebServices
{
    NSMutableArray* newsSourceSelected;
    NSMutableArray* fetchedArticles;
    
}


+ (NDWebServices*)sharedInstance
{
    static NDWebServices* sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[super alloc]init];
        
    });
    return sharedObject;
}

// This method fetched News from all the available resources

- (void)getNewsSources
{
    NSDictionary* __block jsonResponse;
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURLSessionDataTask* dataTask = [ session dataTaskWithURL:[NSURL URLWithString:KNewsSourcesUrl] completionHandler: ^(NSData* data , NSURLResponse* response , NSError* error){
    if(error == nil)
    {
    jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewsSourcesLoadedNotification object:self userInfo:jsonResponse];
        
    }
    }];
    [dataTask resume];
    
}


// This method fetched News Sources from particular category

- (void)getNewsSourcesWithCategory:(NSString*)category

{
    NSDictionary* __block jsonResponse;
    NSString* Urlstring = [KNewsSourcesUrl stringByAppendingString:[NSString stringWithFormat:@"&category=%@",category]];
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURLSessionDataTask* dataTask = [ session dataTaskWithURL:[NSURL URLWithString:Urlstring] completionHandler: ^(NSData* data , NSURLResponse* response , NSError* error){
        if(error == nil)
        {
            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kCategorizeSourcesLoadedNotification object:self userInfo:jsonResponse];
            
        }
    }];
    [dataTask resume];
}

-(void)getNewsListFromSources:(NSMutableArray*)sources;

{
    newsSourceSelected = [[NSMutableArray alloc]init];
    fetchedArticles = [[NSMutableArray alloc]init];
    [newsSourceSelected addObjectsFromArray:sources];
    [self startFetchNewsListFromSources:newsSourceSelected Atindex:0];
    
}

//This method fetched list of News from selected Sources

- (void)startFetchNewsListFromSources:(NSMutableArray*)sources Atindex:(int)index;
{
    
    
    NSDictionary* __block jsonResponse;
    int __block indexValue = index;
    NSString* urlString = [kNewsFromSourceUrl stringByAppendingString:[NSString stringWithFormat:@"source=%@&apiKey=%@",[sources objectAtIndex:indexValue],kNewsApiKey]];
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURLSessionDataTask* dataTask = [ session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler: ^(NSData* data , NSURLResponse* response , NSError* error){
        
        if(error == nil)
        {

            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            for (int i = 0; i<[[jsonResponse objectForKey:kNewsArticles]count]; i++)
            {
                [fetchedArticles addObject:[jsonResponse objectForKey:kNewsArticles][i]];
            }

            indexValue++;
            if(indexValue<[newsSourceSelected count])
            {
                [self startFetchNewsListFromSources:newsSourceSelected Atindex:indexValue];
                
            }
            else
            {
                NSMutableDictionary* receivedArticles = [[NSMutableDictionary alloc]init];
                [receivedArticles setObject:fetchedArticles forKey:kNewsArticles];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsListLoaded" object:self userInfo:receivedArticles];

            }
            
        }
    }];
    [dataTask resume];

}



-(void)getNewsListFromSources:(NSMutableArray *)sources filterBy:(NSString *)sort
{
    
    newsSourceSelected = [[NSMutableArray alloc]init];
    fetchedArticles = [[NSMutableArray alloc]init];
    [newsSourceSelected addObjectsFromArray:sources];
    [self fetchNewsListFromSources:sources filteredBy:sort AtIndex:0];

}

//This method fetched News from selected sources which are sorted by the selected Filter

-(void)fetchNewsListFromSources:(NSMutableArray*)sources filteredBy:(NSString*)sort AtIndex:(int)index
{
    
    NSDictionary* __block jsonResponse;
    int __block indexValue = index;
    NSString* __block sortBy = sort;
     NSString* urlString = [kNewsFromSourceUrl stringByAppendingString:[NSString stringWithFormat:@"source=%@&sortBy=%@&apiKey=%@",[sources objectAtIndex:indexValue],sort,kNewsApiKey] ];
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURLSessionDataTask* dataTask = [ session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler: ^(NSData* data , NSURLResponse* response , NSError* error){
        
        if(error == nil)
        {

            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if(![[jsonResponse objectForKey:KNewsStatus] isEqualToString:kNewsError])
            {
                for( int i = 0; i<[[jsonResponse objectForKey:kNewsArticles] count]; i++)
                {
                    [fetchedArticles addObject:[jsonResponse objectForKey:kNewsArticles][i]];
                    
                }
            }
            indexValue++;
            if(indexValue<[newsSourceSelected count])
            {
                [self fetchNewsListFromSources:newsSourceSelected filteredBy:sortBy AtIndex:indexValue];
            }
            else
            {
                NSMutableDictionary* receivedArticles = [[NSMutableDictionary alloc]init];
                if(fetchedArticles)
                {
                [receivedArticles setObject:fetchedArticles forKey:kNewsArticles];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNewsListLoadedNotification object:self userInfo:receivedArticles];
                }
            }
            
        }
    }];
    [dataTask resume];

}




- (void)getNewsListFromSources:(NSMutableArray*)sources atIndex:(int)index withMatchingCategory:(NSString*)category filteredBy:(NSString*)sort


{
    
    NSDictionary* __block jsonResponse;
    int __block indexValue =index;
    NSString* urlString = [NSString stringWithFormat:@"https://newsapi.org/v1/articles?source=%@&category=%@&sortBy=%@&apiKey=589e9375eca54120bc116e72ae1d9eeb",[sources objectAtIndex:indexValue],category,sort];
    
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURLSessionDataTask* dataTask = [ session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler: ^(NSData* data , NSURLResponse* response , NSError* error){
        
        if(error == nil)
        {
            NSMutableDictionary* receivedArticles = [[NSMutableDictionary alloc]init];
            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            if(![[jsonResponse objectForKey:KNewsStatus] isEqualToString:kNewsError])
            {
                [receivedArticles setObject:[jsonResponse objectForKey:kNewsArticles] forKey:kNewsArticles];
                
                for( int i=0; i<[[receivedArticles objectForKey:kNewsArticles] count]; i++)
                {
                    [fetchedArticles addObject:[receivedArticles objectForKey:kNewsArticles][i]];
                    
                }
            }
            indexValue++;
            if(indexValue<[newsSourceSelected count])
                
            {
                [self getNewsListFromSources:sources atIndex:indexValue withMatchingCategory:category filteredBy:sort];
                
            }
            else
            {
                NSMutableDictionary* dict =[[NSMutableDictionary alloc]init];
                if(fetchedArticles)
                {
                    [dict setObject:fetchedArticles forKey:kNewsArticles];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kNewsListLoadedNotification object:self userInfo:dict];
                
            }
            
        }
    }];
    [dataTask resume];

    
}







@end
