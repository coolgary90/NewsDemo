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
-(void)getNewsList:(NSString*)newsSource;
-(void)getNewsListSortedBy:(NSString*)newsSource sortedBy:(NSString*)sort;





@end
