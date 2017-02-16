//
//  DataManager.h
//  ICreative
//
//  Created by Simrandeep Singh on 10/11/16.
//  Copyright © 2016 Simrandeep Singh. All rights reserved.
//

#import "Media.h"
//#import "User.h"
//#import "SignUpForm.h"
#import "WebServiceResponse.h"
//#import "LogInForm.h"
#import "CategoryBasedData.h"

@interface DataManager : NSObject

//@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray* categoryList;
@property (nonatomic, assign) BOOL allowWifiDownload;

+ (DataManager*) sharedInstance;

// Media API
- (void) getCategoryListwithCallback:(void (^)(NSArray* categoryList))callback;

- (void) getVideoListforCategory:(NSString*)category
                    withCallback:(void (^)(CategoryBasedData* categoryBasedData))callback;
// News Feed API
- (void) getFeedListwithCallback:(void(^)(NSArray* feedList)) callback;

// User API
//- (void) sendSignUpRequestWithDetails:(SignUpForm*)signUpForm
//                         withCallback:(void (^)(WebServiceResponse *response))callback;

- (void) sendLogInRequestWithDetails:(NSDictionary*)dict
                        withCallback:(void (^)(WebServiceResponse* user))callback;
- (void) sendLogOutRequest:(void (^)(WebServiceResponse* response))callback;
- (void) sendRefreshRequestWithCallback:(void (^)(WebServiceResponse* response))callback;




// My Methods
- (void)getNewsList :(void(^)(NSMutableArray* sourceList))completionBlock;
- (void)getNewsListWithCategory:(NSString*)category withCompetionHandler:(void(^)(NSMutableArray* sourceList))completionBlock;
-(void)getNewsListFromSources:(NSMutableArray*)sources withCompletionHandler:(void(^)(NSMutableArray* newsList))completionBlock;



#pragma mark -
- (void) addMediaToSavedList:(Media*)media;
- (void) deleteMediafromSavedList:(Media*)media;
- (NSArray*) getMediaList;

@end

#define gDataManager [DataManager sharedInstance]
