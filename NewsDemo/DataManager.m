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



//- (void)fetchNewsList:(NSMutableArray*)newsSource withIndex:(int)index withFilter:(NSString*)filter{
//    
//    int __block indexValue = index;
//    NSString* urlString;
//    NSString* sortedBy;
//    
//    if(filter == nil)
//    {
//        sortedBy = filter;
//        
//     urlString = [kNewsFromSourceUrl stringByAppendingString:[NSString stringWithFormat:@"source=%@&apiKey=%@",[newsSource objectAtIndex:indexValue],kNewsApiKey]];
//    }
//    else
//    {
//        sortedBy = filter;
//         urlString = [kNewsFromSourceUrl stringByAppendingString:[NSString stringWithFormat:@"source=%@&sortBy=%@&apiKey=%@",[newsSource objectAtIndex:indexValue],sortedBy,kNewsApiKey]];
//    }
//    NSURLRequest* request  = [WebServiceManager getRequestWithService:urlString];
//    [WebServiceManager sendRequest:request completion:^(WebServiceResponse* response){
//        if(response.status)
//        {
//            
//            NSDictionary* jsonResponse;
//            jsonResponse = [self dictFromJson:response.responseData];
//            
//            for (int i = 0; i<[[jsonResponse objectForKey:kNewsArticles]count]; i++)
//            {
//                [fetchedArticles addObject:[jsonResponse objectForKey:kNewsArticles][i]];
//            }
//            indexValue++;
//            if(indexValue<[newsSource count])
//            {
//                [self fetchNewsList:newsSource withIndex:indexValue withFilter:sortedBy];
//            }
//            else
//            {
//                [self buildNewsList:fetchedArticles];
//            }
//        }
//    }];
//}


- (NSMutableArray*)buildNewsList:(NSMutableArray*)newsList
{
 
    NSMutableArray* finalNewsListArray = [[NSMutableArray alloc]init];
    for(NSDictionary* newsListDict in newsList)
    {
        [finalNewsListArray addObject:[NewsListElement createNewsList:newsListDict]];
        
    }
    return finalNewsListArray;
//    NSDictionary* finalNewsListDict = [NSDictionary dictionaryWithObjectsAndKeys:finalNewsListArray,@"finalNewsList", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNewsListLoadedNotification object:self userInfo:finalNewsListDict];
    
}
//- (void)buildNewsList:(NSMutableArray*)newsList
//{
//    
//    NSMutableArray* finalNewsListArray = [[NSMutableArray alloc]init];
//    for(NSDictionary* newsListDict in newsList)
//    {
//        [finalNewsListArray addObject:[NewsListElement createNewsList:newsListDict]];
//        
//    }
//    NSDictionary* finalNewsListDict = [NSDictionary dictionaryWithObjectsAndKeys:finalNewsListArray,@"finalNewsList", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNewsListLoadedNotification object:self userInfo:finalNewsListDict];
//    
//}







//- (void) getFeedListwithCallback:(void(^)(NSArray* feedList)) callback
//{
//    NSURLRequest* request = [WebServiceManager getAuthorizationRequestWithService:KFeedURL];
//    [WebServiceManager sendRequest:request completion:^(WebServiceResponse* response)
//    {
//        if (response.status)
//        {
//            NSDictionary* responseDict = [self dictFromJson:response.responseData];
//            MFLogPARSING(@"\n\n\nhere is my extracted response for feed list %@",responseDict);
//            NSDictionary* dict = [responseDict objectForKey:@"response"];
//            NSArray* dataArray = [dict objectForKey:@"data"];
//            NSMutableArray* feedList  = [[NSMutableArray alloc] init];
//            for (NSDictionary* data in dataArray)
//            {
//                [feedList addObject :
//                 [FeedElement buildFeedElementModelwithDictionary:data]];
//            }
//            
//            callback(feedList);
//        }
//        else
//        {
//            callback(nil);
//        }
//    }];
//}
//
//#pragma mark
//
//- (void) getCategoryListwithCallback:(void (^)(NSArray* categoryList))callback
//{
//    NSURLRequest* request = [WebServiceManager getAuthorizationRequestWithService:KCategoriesURL];
//    
//    [WebServiceManager sendRequest:request completion:^(WebServiceResponse* response)
//    {
//        if (response.status)
//        {
//            NSDictionary* responseDict = [self dictFromJson:response.responseData];
//            MFLogPARSING(@"\n\n\nhere is my extracted response for category list %@",responseDict);
//            NSDictionary* dict = [responseDict objectForKey:@"response"];
//            NSArray* dataArray = [dict objectForKey:@"data"];
//            NSMutableArray* categoryList  = [[NSMutableArray alloc] init];
//            for (NSDictionary* data in dataArray)
//            {
//                [categoryList addObject :
//                 [VideoCategory buildVideoCategoryModelWithDictionary:data]];
//            }
//            
//            _categoryList = categoryList;
//            callback(categoryList);
//        }
//        else
//        {
//            callback(nil);
//        }
//    }];
//}

//- (void) getVideoListforCategory:(NSString*)category withCallback:(void (^)(CategoryBasedData* categoryBasedData))callback
//{
//    NSURLRequest* request = [WebServiceManager getAuthorizationRequestWithService:[NSString stringWithFormat:@"%@/%@",KCategoryURL,category]];
//    [WebServiceManager sendRequest:request completion:^(WebServiceResponse* response)
//    {
//        if (response.status)
//        {
//            NSDictionary* dict = [self dictFromJson:response.responseData];
//            MFLogPARSING(@"\n\n\nhere is my extracted response for video list for categoryName %@ \n %@",category,dict);
//            CategoryBasedData* categoryBasedData = [CategoryBasedData buildCategoryBasedDataModelWithDictionary:dict];
//            callback(categoryBasedData);
//        }
//        else
//        {
//            callback(nil);
//        }
//    }];
//}

#pragma mark

//- (void) sendSignUpRequestWithDetails:(SignUpForm*)signUpForm withCallback:(void (^)(WebServiceResponse *response))callback
//{
//    NSURLRequest* request = [WebServiceManager postRequestWithService:kSignUpURL withpostDict:[signUpForm dictionaryRepresentationofSignUpForm]];
//    
//    [WebServiceManager sendRequest:request completion:^(WebServiceResponse* response)
//    {
//        if (response.status)
//        {
//            NSDictionary* dict = [self dictFromJson:response.responseData];
//			MFLogPARSING(@"\n\n\nhere is my extracted response for Login IN \n %@ ",dict);
//			_user = [User buildUserModelwithDictionary:dict];
//			[self saveUserData];
//        }
//        callback(response);
//
//    }];
//}

//- (void) sendLogInRequestWithDetails:(NSDictionary*)dict withCallback:(void (^)(WebServiceResponse* response))callback
//{
//    NSURLRequest* request = [WebServiceManager postRequestWithService:kLogInURL  withpostDict:dict];
//    
//    [WebServiceManager sendRequest:request completion:^(WebServiceResponse* response)
//    {
//        if (response.status)
//        {
//            NSDictionary* dict = [self dictFromJson:response.responseData];
//            MFLogPARSING(@"\n\n\nhere is my extracted response for Login IN \n %@ ",dict);
//            _user = [User buildUserModelwithDictionary:dict];
//            [self saveUserData];
//        }
//        callback(response);
//    }];
//}

//- (void) saveUserData
//{
//	NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
//	if (_user.token)
//	{
//		NSData* data = [NSKeyedArchiver archivedDataWithRootObject:_user];
//		[standardUserDefaults setObject:data forKey:@"USER_DATA"];
//	}
//	else
//	{
//		[standardUserDefaults setObject:nil forKey:@"USER_DATA"];
//	}
//	[standardUserDefaults synchronize];
//}

//- (void) sendLogOutRequest:(void (^)(WebServiceResponse* response))callback
//{
//    NSURLRequest* request = [WebServiceManager getAuthorizationRequestWithService:KLogOutURL];
//	[UIUtils showLoadingView:YES];
//    [WebServiceManager sendRequest:request completion:^(WebServiceResponse* response)
//    {
//        if (response.status)
//        {
//            NSDictionary* dict = [self dictFromJson:response.responseData];
//            MFLogPARSING(@"\n\n\nhere is my extracted response for Logout API \n %@ ",dict);
//        }
//		_user = nil;
//		[self saveUserData];
//		[UIUtils showLoadingView:NO];
//        callback(response);
//    }];
//}

//- (void) sendRefreshRequestWithCallback:(void (^)(WebServiceResponse* response))callback
//{
//    NSURLRequest* request = [WebServiceManager getAuthorizationRequestWithService:KRefreshURL];
//    
//    [WebServiceManager sendRequest:request completion:^(WebServiceResponse* response)
//    {
//        if(response.status)
//        {
//			NSDictionary* dict = [self dictFromJson:response.responseData];
//			MFLogPARSING(@"\n\n\nhere is my extracted response for Refresh API \n %@ ",dict);
//
//			NSDictionary* responseDict = [dict objectForKey:@"response"];
//			_user.token = [responseDict objectForKey:@"token"];
//	        [self saveUserData];
//        }
//        callback(response);
//    }];
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

//- (void) addMediaToSavedList:(Media*)media
//{
//	if (media == nil)
//		return;
//	
//	if (self.savedMediaList == nil)
//		[self readSavedMediaData];
//
//	[self.savedMediaList addObject:media];
//	[self saveMediaData];
//}

//- (void) deleteMediafromSavedList:(Media*)media
//{
//	[self.savedMediaList removeObject:media];
//	[self saveMediaData];
//}

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
