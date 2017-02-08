//
//  NDWebServices.h
//  NewsDemo
//
//  Created by Amanpreet Singh on 06/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDWebServices : NSObject


+(NDWebServices*)sharedInstance;

-(void)getNewsSources;

- (void)getNewsSourcesWithCategory:(NSString*)category;
-(void)getNewsListFromSources:(NSMutableArray*)sources;
-(void)getNewsListFromSources:(NSMutableArray*)sources filterBy:(NSString*)sort;
- (void)getNewsListFromSources:(NSMutableArray*)sources atIndex:(int)index withMatchingCategory:(NSString*)category filteredBy:(NSString*)sort;
-(void)fetchNewsListFromSources:(NSMutableArray*) filteredBy:(NSString*)sort AtIndex:(int)index;
- (void)startFetchNewsListFromSources:(NSMutableArray*)sourceName Atindex:(int)index;

//-(void)getNewsList:(NSString*)newsSource;
//-(void)getNewsListSortedBy:(NSString*)newsSource sortedBy:(NSString*)sort;






@end
