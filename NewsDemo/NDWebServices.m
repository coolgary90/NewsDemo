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
            [[NSNotificationCenter defaultCenter] postNotificationName:kNewsListLoadedNotification object:self userInfo:jsonResponse];
            
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
            [[NSNotificationCenter defaultCenter] postNotificationName:kNewsListLoadedNotification object:self userInfo:jsonResponse];
            
        }
    }];
    [dataTask resume];
}



-(void)getNewsListFromSources:(NSMutableArray*)sources;

{
    newsSourceSelected = [[NSMutableArray alloc]init];
    fetchedArticles = [[NSMutableArray alloc]init];
    
    [newsSourceSelected addObjectsFromArray:sources];
    [self fetchNewsListFromSources:newsSourceSelected Atindex:0];
    
}


- (void)fetchNewsListFromSources:(NSMutableArray*)sources Atindex:(int)index;
{
    
    
    NSDictionary* __block jsonResponse;
    
    int __block indexValue =index;
    NSString* urlString = [NSString stringWithFormat:@"https://newsapi.org/v1/articles?source=%@&apiKey=589e9375eca54120bc116e72ae1d9eeb",[sources objectAtIndex:indexValue]];
    
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURLSessionDataTask* dataTask = [ session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler: ^(NSData* data , NSURLResponse* response , NSError* error){
        
        if(error == nil)
        {
            NSMutableDictionary* dicttemp = [[NSMutableDictionary alloc]init];
            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            [dicttemp setObject:[jsonResponse objectForKey:@"articles"] forKey:@"am"];
            
            for( int i=0; i<[[dicttemp objectForKey:@"am" ] count]; i++)
            {
                [fetchedArticles addObject:[dicttemp objectForKey:@"am"][i]];

            }
            
            indexValue++;
            if(indexValue<[newsSourceSelected count])
            {
                [self fetchNewsListFromSources:newsSourceSelected Atindex:indexValue];
                
            }
            else
            {
                NSMutableDictionary* dict =[[NSMutableDictionary alloc]init];
                [dict setObject:fetchedArticles forKey:@"articles"];
                
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsListLoaded" object:self userInfo:dict];

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


-(void)fetchNewsListFromSources:(NSMutableArray*)sources filteredBy:(NSString*)sort AtIndex:(int)index{
    
    
    NSDictionary* __block jsonResponse;
    
    int __block indexValue =index;
    NSString* __block sortBy =sort;
    NSString* urlString = [NSString stringWithFormat:@"https://newsapi.org/v1/articles?source=%@&sortBy=%@&apiKey=589e9375eca54120bc116e72ae1d9eeb",[sources objectAtIndex:indexValue],sort];
    
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURLSessionDataTask* dataTask = [ session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler: ^(NSData* data , NSURLResponse* response , NSError* error){
        
        if(error == nil)
        {
            NSMutableDictionary* receivedArticles = [[NSMutableDictionary alloc]init];
            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            if(![[jsonResponse objectForKey:@"status"] isEqualToString:@"error"])
            {
            [receivedArticles setObject:[jsonResponse objectForKey:@"articles"] forKey:@"articles"];
            
            for( int i=0; i<[[receivedArticles objectForKey:@"articles" ] count]; i++)
            {
                [fetchedArticles addObject:[receivedArticles objectForKey:@"articles"][i]];
                
            }
            }
            indexValue++;
            if(indexValue<[newsSourceSelected count])
            {
                [self fetchNewsListFromSources:newsSourceSelected filteredBy:sortBy AtIndex:indexValue];
                
            }
            else
            {
                NSMutableDictionary* dict =[[NSMutableDictionary alloc]init];
                if(fetchedArticles)
                {
                [dict setObject:fetchedArticles forKey:@"articles"];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kNewsListLoadedNotification object:self userInfo:dict];
                
            }
            
        }
    }];
    [dataTask resume];

    
    
    
}




- (void)getNewsListFromSources:(NSMutableArray*)sources atIndex:(int)index withMatchingCategory:(NSString*)category filteredBy:(NSString*)sort


{
    
    NSDictionary* __block jsonResponse;
    
    int __block indexValue =index;
//    NSString* __block categoryValue = category;
//    NSString* __block sortValue = sort;
    
    NSString* urlString = [NSString stringWithFormat:@"https://newsapi.org/v1/articles?source=%@&category=%@&sortBy=%@&apiKey=589e9375eca54120bc116e72ae1d9eeb",[sources objectAtIndex:indexValue],category,sort];
    
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURLSessionDataTask* dataTask = [ session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler: ^(NSData* data , NSURLResponse* response , NSError* error){
        
        if(error == nil)
        {
            NSMutableDictionary* receivedArticles = [[NSMutableDictionary alloc]init];
            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            if(![[jsonResponse objectForKey:@"status"] isEqualToString:@"error"])
            {
                [receivedArticles setObject:[jsonResponse objectForKey:@"articles"] forKey:@"articles"];
                
                for( int i=0; i<[[receivedArticles objectForKey:@"articles" ] count]; i++)
                {
                    [fetchedArticles addObject:[receivedArticles objectForKey:@"articles"][i]];
                    
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
                    [dict setObject:fetchedArticles forKey:@"articles"];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kNewsListLoadedNotification object:self userInfo:dict];
                
            }
            
        }
    }];
    [dataTask resume];

    
}



@end
