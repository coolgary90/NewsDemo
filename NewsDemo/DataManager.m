//
//  DataManager.m
//  ICreative
//
//  Created by Simrandeep Singh on 10/11/16.
//  Copyright © 2016 Simrandeep Singh. All rights reserved.
//


#import "Define.h"
#import "NewsListElement.h"
#import "SourceCategories.h"
#import "WebServiceManager.h"
#import "UIUtils.h"
#import "SourceElement.h"
#import "DataManager.h"

@interface DataManager ()

@property (nonatomic, strong) NSMutableArray* savedMediaList;

@end

@implementation DataManager
{
    
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedManager;
    dispatch_once(&once, ^{
        sharedManager = [[DataManager alloc] init];
    });
    return sharedManager;
}

//- (id) init
//{
////    if (self = [super init])
////    {
////		NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
////        NSData* userData = [standardUserDefaults objectForKey:@"USER_DATA"];
////        _user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
////		_allowWifiDownload = [[standardUserDefaults objectForKey:@"AllowWifiDownload"] boolValue];
////    }
////    return self;
//}

#pragma mark


// This method fetched news sources and send it to NDNewsSources class on completion

- (void)getNewsList :(void(^)(NSMutableArray* sourceList))completionBlock;
{
    
    
    NSURLRequest* request  = [WebServiceManager getRequestWithService:kNewsSourcesUrl];
    [WebServiceManager sendRequest:request completion:^(WebServiceResponse* response){
        
        
        if(response.status)
        {
            NSDictionary* responseDict = [self dictFromJson:response.responseData];
            NSMutableArray* newsSourcesList = [responseDict objectForKey:@"sources"];
            NSMutableArray* finalSourceListArray = [[NSMutableArray alloc]init];
            NSMutableArray* uniqueCategories  = [[NSMutableArray alloc]init];
            for (NSDictionary* data in newsSourcesList)
            {
                 [finalSourceListArray addObject:[SourceElement createSourceList:data]];
                
            }
            
            SourceCategories* sourceCategoriesObj = [SourceCategories sharedInstance];
            uniqueCategories =[sourceCategoriesObj uniqueSourceCategories:newsSourcesList];
            [[NSUserDefaults standardUserDefaults]setObject:uniqueCategories forKey:kNewsUniqueSourceCategories];
            completionBlock(finalSourceListArray);
            
            
            
            
        }
    }];
    
    
}

// This method fetched news sources with particular category and send it to NDNewsSources class on completion



- (void)getNewsListWithCategory:(NSString*)category withCompetionHandler :(void(^)(NSMutableArray* sourceList))completionBlock{
    
    NSString* Urlstring = [kNewsSourcesUrl stringByAppendingString:[NSString stringWithFormat:@"&category=%@",category]];

    NSURLRequest* request  = [WebServiceManager getRequestWithService:Urlstring];
    [WebServiceManager sendRequest:request completion:^(WebServiceResponse* response){
        
        
        if(response.status)
        {
            NSDictionary* responseDict = [self dictFromJson:response.responseData];
            NSMutableArray* newsSourcesList = [responseDict objectForKey:@"sources"];
            NSMutableArray* finalSourceListArray = [[NSMutableArray alloc]init];
            for (NSDictionary* data in newsSourcesList)
            {
                [finalSourceListArray addObject:[SourceElement createSourceList:data]];
                
            }
            completionBlock(finalSourceListArray);
            
            
            
            
        }
    }];

    
    
}

// This method fetch News list from selected sources by calling fetchNewsList method and return array of News list to NDNewsList class in completion block

-(void)getNewsListFromSources:(NSMutableArray*)sources  withCompetionHandler:(void (^)(NSMutableArray *))completionBlock
{
    NSMutableArray* fetchedSources= [[NSMutableArray alloc]init];
    
    for(int i=0;i<[sources count];i++)
    {
        [self fetchNewsList:[sources objectAtIndex:i]  withFilter:nil withCompetionHandler:^(NSMutableArray* finalArray)
        {
            [fetchedSources addObjectsFromArray:finalArray];
            if(i==([sources count]-1))
            completionBlock(fetchedSources);
         }];
    }
}

// This method fetch News list from selected sources  with filter by calling fetchNewsList method and return array of News list to NDNewsList class in completion block

-(void)getNewsListFromSources:(NSMutableArray*)sources filterBy:(NSString*)filter withCompletionHandler:(void(^)(NSMutableArray* newsList))completionBlock{
    
    
    NSMutableArray* fetchedSources= [[NSMutableArray alloc]init];
    
    for(int i=0;i<[sources count];i++)
    {
        [self fetchNewsList:[sources objectAtIndex:i]  withFilter:filter withCompetionHandler:^(NSMutableArray* finalArray)
         {
             [fetchedSources addObjectsFromArray:finalArray];
             if(i==([sources count]-1))
                 
                 completionBlock(fetchedSources);
         }];
    }

    
}




- (void)fetchNewsList:(NSString*)newsSource  withFilter:(NSString*)filter withCompetionHandler:(void (^)(NSMutableArray *))completionBlock{
    
    NSString* urlString;
    NSString* sortedBy;
    
    if(filter == nil)
    {
        sortedBy = filter;
        
        urlString = [kNewsFromSourceUrl stringByAppendingString:[NSString stringWithFormat:@"source=%@&apiKey=%@",newsSource,kNewsApiKey]];
    }
    else
    {
        sortedBy = filter;
        urlString = [kNewsFromSourceUrl stringByAppendingString:[NSString stringWithFormat:@"source=%@&sortBy=%@&apiKey=%@",newsSource,sortedBy,kNewsApiKey]];
    }
    NSURLRequest* request  = [WebServiceManager getRequestWithService:urlString];
    
    [WebServiceManager sendRequest:request completion:^(WebServiceResponse* response){
        
        if(response.status)
        {
            
            NSMutableArray* sourceData = [[NSMutableArray alloc] init];
            NSDictionary* responseDict;
            responseDict = [self dictFromJson:response.responseData];
            NSArray* articlesArray = [responseDict objectForKey:kNewsArticles];
            
            for (NSDictionary* articleDict in articlesArray)
            {
             if(![[articleDict objectForKey:kNewsDescription] isEqual:[NSNull null]] && ![[articleDict objectForKey:kNewsUrlToImage] isEqual:[NSNull null]])
            [sourceData addObject:[NewsListElement createNewsList:articleDict]];
            }
            completionBlock(sourceData);
        }
        else
        {
            completionBlock(nil);

        }

    }];
}





//- (NSMutableArray*)buildNewsList:(NSMutableArray*)newsList
//{
// 
//    NSMutableArray* finalNewsListArray = [[NSMutableArray alloc]init];
//    for(NSDictionary* newsListDict in newsList)
//    {
//        [finalNewsListArray addObject:[NewsListElement createNewsList:newsListDict]];
//        
//    }
//    return finalNewsListArray;
//    
//}


#pragma mark -

- (void) readSavedMediaData
{
	NSData* mediaData = [[NSUserDefaults standardUserDefaults]
						objectForKey:@"SAVED_MEDIA"];
	self.savedMediaList = [NSKeyedUnarchiver unarchiveObjectWithData:mediaData];
	if (self.savedMediaList == nil)
	{
		self.savedMediaList = [[NSMutableArray alloc] init];
	}
}



- (NSArray*) getMediaList
{
	if (self.savedMediaList == nil)
		[self readSavedMediaData];

	return self.savedMediaList;
}

- (void) saveMediaData
{
	NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.savedMediaList];
	[standardUserDefaults setObject:data forKey:@"SAVED_MEDIA"];
	[standardUserDefaults synchronize];
}

- (void) setAllowWifiDownload:(BOOL)allowWifiDownload
{
	_allowWifiDownload = allowWifiDownload;
	NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
	[standardUserDefaults setObject:[NSNumber numberWithBool:_allowWifiDownload] forKey:@"AllowWifiDownload"];
	[standardUserDefaults synchronize];
}

#pragma mark -

- (NSDictionary*) dictFromJson: (NSData*) responseData
{
    NSDictionary* dictJ=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    return dictJ;
}

@end
