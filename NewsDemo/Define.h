//
//  Define.h
//  NewsDemo
//
//  Created by Amanpreet Singh on 07/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#ifndef Define_h
#define Define_h


#define kAlertMinimumSourceSelection @"Please select atleast 2 to continue..."
#define kAlertOk @"Ok"
#define kAlertNoNews @"No news available for this category"
#define kAlertOops @"Oops..."
#define kMain @"Main"
#define kNewsListLoadedNotification @"NewsListLoaded"
#define kNewsSourcesLoadedNotification @"SourceListLoaded"
#define kCategorizeSourcesLoadedNotification @"CatagorizeSourceListLoaded"
#define kPlaceHolderImage @"No-image.png"
#define kSources @"sources"
#define kNewsSourceName @"name"
#define kNewsSourcesUrlToLogo @"urlsToLogos"
#define kNewsSourcesId @"id"
#define kNewsSourcesCategory @"category"
#define kName @"name"
#define kUniqueObjects @"@distinctUnionOfObjects.self"
#define kNewsList @"newsList"
#define kTopNews @"top";
#define kPopularNews @"popular";
#define kNewsArticles @"articles"
#define kNewsDescription @"description"
#define kNewsTitle @"title"
#define kNewsUrl @"url"
#define kNewsUrlToImage @"urlToImage"
#define kLatestNews @"latest";
#define kNewsSourcesUrl @"https://newsapi.org/v1/sources?language=en"
#define kNewsFromSourceUrl @"https://newsapi.org/v1/articles?"
#define kNewsApiKey @"589e9375eca54120bc116e72ae1d9eeb"
#define kNewsStatus @"status"
#define kNewsError @"error"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define kwelcomeMessage @"Welcome to News"
#define kAppDescription @"The best stories from the sources you love , selected just for you. The more you need, the more personalized your News become"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )



#define kColorSelectedFilter  [UIColor colorWithRed:0.0/255.0 green:77.0/255.0 blue:159.0/255.0 alpha:1.0]
#define kColorUnSelectedFilter  [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]
//NewsListLoaded
//SourceListLoaded

#endif /* Define_h */
