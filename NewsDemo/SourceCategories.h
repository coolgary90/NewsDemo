//
//  SourceCategories.h
//  NewsDemo
//
//  Created by Amanpreet Singh on 16/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SourceCategories : NSObject


+(SourceCategories*)sharedInstance;


- (NSMutableArray*)uniqueSourceCategories:(NSMutableArray*)dict;
@end
