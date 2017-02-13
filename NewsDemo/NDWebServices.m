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
    NSURLSessionDataTask* dataTask = [session dataTaskWithURL:[NSURL URLWithString:kNewsSourcesUrl] completionHandler: ^(NSData* data , NSURLResponse* response , NSError* error){
    if(error == nil)
    {
    jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewsSourcesLoadedNotification object:self userInfo:jsonResponse];
        
    }
    }];
    [dataTask resume];
    
}


// This method fetched News Sources from particular category

- (void) getNewsSourcesWithCategory:(NSString*)category

{
    NSDictionary* __block jsonResponse;
    NSString* Urlstring = [kNewsSourcesUrl stringByAppendingString:[NSString stringWithFormat:@"&category=%@",category]];
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

- (void) getNewsListFromSources:(NSMutableArray*)sources;

{
    newsSourceSelected = [[NSMutableArray alloc]init];
    fetchedArticles = [[NSMutableArray alloc]init];
    [newsSourceSelected addObjectsFromArray:sources];
    [self startFetchNewsListFromSources:newsSourceSelected Atindex:0];
    
}

//This method fetched list of News from selected Sources and fire NSNotification when News from all sources get fetched

- (void) startFetchNewsListFromSources:(NSMutableArray*)sources Atindex:(int)index;
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
    [self fetchNewsListFromSources:sources sortedBy:sort AtIndex:0];

}

//This method fetched News from selected sources which are sorted by the selected Filter and then fire NSNotification

-(void)fetchNewsListFromSources:(NSMutableArray*)sources sortedBy:(NSString*)sort AtIndex:(int)index
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
            if(![[jsonResponse objectForKey:kNewsStatus] isEqualToString:kNewsError])
            {
                for( int i = 0; i<[[jsonResponse objectForKey:kNewsArticles] count]; i++)
                {
                    [fetchedArticles addObject:[jsonResponse objectForKey:kNewsArticles][i]];
                    
                }
            }
            indexValue++;
            if(indexValue<[newsSourceSelected count])
            {
                [self fetchNewsListFromSources:newsSourceSelected sortedBy:sortBy AtIndex:indexValue];
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



@end
