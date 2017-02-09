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

- (void) getNewsSources;
- (void) getNewsSourcesWithCategory:(NSString*)category;
- (void) getNewsListFromSources:(NSMutableArray*)sources;
- (void) startFetchNewsListFromSources:(NSMutableArray*)sourceName Atindex:(int)index;
- (void) getNewsListFromSources:(NSMutableArray*)sources filterBy:(NSString*)sort;
- (void) fetchNewsListFromSources:(NSMutableArray*) sortedBy:(NSString*)sort AtIndex:(int)index;

@end
