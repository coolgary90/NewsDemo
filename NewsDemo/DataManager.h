//
//  DataManager.h
//  ICreative
//
//  Created by Simrandeep Singh on 10/11/16.
//  Copyright © 2016 Simrandeep Singh. All rights reserved.
//

#import "WebServiceResponse.h"

@interface DataManager : NSObject

@property (nonatomic, strong) NSArray* categoryList;
@property (nonatomic, assign) BOOL allowWifiDownload;
@property (strong,nonatomic) NSCache* cache;;
@property (strong,nonatomic) NSString* imageUrl;
+ (DataManager*)sharedInstance;


# pragma mark Sources and News Fetch Methods

-(void)getNewsListFromSources:(NSMutableArray*)sources withCompetionHandler:(void(^)(NSMutableArray* sourceList))completionBlock;

- (void)getNewsListWithCategory:(NSString*)category withCompetionHandler:(void(^)(NSMutableArray* sourceList))completionBlock;


- (void)getNewsList :(void(^)(NSMutableArray* sourceList))completionBlock;


-(void)getNewsListFromSources:(NSMutableArray*)sources filterBy:(NSString*)filter withCompletionHandler:(void(^)(NSMutableArray* newsList))completionBlock;

-(void) loadingImage:(NSString*)urlString withImageView:(UIImageView*)imageView;

#pragma mark -
@end

