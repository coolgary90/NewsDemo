//
//  NewsListElement.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 17/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "Define.h"
#import "NewsListElement.h"

@implementation NewsListElement

+ (instancetype)createNewsList:(NSDictionary *)newsList
{
    NewsListElement* newsListObj = [[NewsListElement alloc]initWithArray:newsList];
    return newsListObj;
}

- (instancetype)initWithArray:(NSDictionary*)newsList
{
    if(self = [super init])
    {
        self.newsTitle = [newsList objectForKey:kNewsTitle];
        self.newsDescription =[ newsList objectForKey:kNewsDescription];
        self.newsImage = [newsList objectForKey:kNewsUrlToImage];
        self.newsUrl = [newsList objectForKey:kNewsUrl];
        
    }
    return self;
}

@end
