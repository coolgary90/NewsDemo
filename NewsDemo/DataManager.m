//
//  DataManager.m
//  ICreative
//
//  Created by Simrandeep Singh on 10/11/16.
//  Copyright © 2016 Simrandeep Singh. All rights reserved.
//


#import "Define.h"
#import "SourceCategories.h"
#import "WebServiceManager.h"
#import "UIUtils.h"
//#import "User.h"
#import "CategoryBasedData.h"
#import "SourceElement.h"
#import "DataManager.h"

@interface DataManager ()

@property (nonatomic, strong) NSMutableArray* savedMediaList;

@end

@implementation DataManager
{
    NSMutableArray* fetchedArticles;
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

-(void)getNewsListFromSources:(NSMutableArray*)sources withCompletionHandler:(void(^)(NSMutableArray* newsList))completionBlock
{
    
    fetchedArticles = [[NSMutableArray alloc]init];
    NSMutableArray* finalList  = [[NSMutableArray alloc]init];
//    NSMutableArray* myarray = [[NSMutableArray alloc]init];
//    for (int __block i=0; i<[sources count]; i++) {
    
    
    __block int i= 0;
        [self fetchNewsList:sources withIndex:i withCompletionHandler:^(NSMutableArray* arra){
            
            i++;
            if(i<[sources count])
            {
                
                [finalList addObjectsFromArray:arra];
                 [self fetchNewsList:sources withIndex:0 withCompletionHandler:^(NSMutableArray* arra){
                     
                 }];
                
            }
            else
            {
                completionBlock(finalList);
                
            }
        }];
//            [myarray addObject:arra];
//            i++;
//        }];
//        
//    }
   
    
    
}


- (void)fetchNewsList:(NSMutableArray*)newsSource withIndex:(int)index withCompletionHandler:(void(^)(NSMutableArray* newsList))completionBlock
{
    
    int __block indexValue = index;

    NSString* urlString = [kNewsFromSourceUrl stringByAppendingString:[NSString stringWithFormat:@"source=%@&apiKey=%@",[newsSource objectAtIndex:indexValue],kNewsApiKey]];
    NSURLRequest* request  = [WebServiceManager getRequestWithService:urlString];
    
    [WebServiceManager sendRequest:request completion:^(WebServiceResponse* response){
        if(response.status)
        {
            
            NSDictionary* jsonResponse;
            jsonResponse = [self dictFromJson:response.responseData];
            
            for (int i = 0; i<[[jsonResponse objectForKey:kNewsArticles]count]; i++)
            {
                [fetchedArticles addObject:[jsonResponse objectForKey:kNewsArticles][i]];
            }
            
        
             completionBlock(fetchedArticles);
        }
    
    }];
}




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

- (void) addMediaToSavedList:(Media*)media
{
	if (media == nil)
		return;
	
	if (self.savedMediaList == nil)
		[self readSavedMediaData];

	[self.savedMediaList addObject:media];
	[self saveMediaData];
}

- (void) deleteMediafromSavedList:(Media*)media
{
	[self.savedMediaList removeObject:media];
	[self saveMediaData];
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
