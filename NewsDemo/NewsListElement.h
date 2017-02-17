//
//  NewsListElement.h
//  NewsDemo
//
//  Created by Amanpreet Singh on 17/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsListElement : NSObject

+ (instancetype)createNewsList :(NSDictionary*)newsList;

@property (strong, nonatomic) NSString* newsTitle;
@property (strong, nonatomic) NSString* newsDescription;
@property (strong, nonatomic) NSString* newsImage;
@property (strong, nonatomic) NSString* newsUrl;


@end
