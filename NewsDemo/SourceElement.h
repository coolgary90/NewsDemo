//
//  SourceElement.h
//  NewsDemo
//
//  Created by Amanpreet Singh on 16/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SourceElement : NSObject


+(instancetype)createSourceList:(NSDictionary*)fetchedSource;

@property(strong, nonatomic) NSString* sourceName;
@property(strong, nonatomic) NSString* sourceID;
@property(strong, nonatomic) NSString* sourceImage;
@property(weak, nonatomic) NSString* sourceCategory;






@end
