//
//  SourceCategories.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 16/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "Define.h"
#import "SourceCategories.h"

@implementation SourceCategories



+(SourceCategories*)sharedInstance
{
    static SourceCategories* sharedObject =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[SourceCategories alloc]init];
        
    });
    return sharedObject;
}


 -(NSMutableArray*)uniqueSourceCategories:(NSMutableArray *)sourceList
{
    NSMutableArray* sourceCategoriesArray = [[NSMutableArray alloc]init];
    NSMutableArray* uniqueSourceCategories  =[[ NSMutableArray alloc]init];
    
    for(NSDictionary* dict in sourceList)
    {
        
        [sourceCategoriesArray addObject:[dict objectForKey:kNewsSourcesCategory]];
        

    }
        uniqueSourceCategories = [sourceCategoriesArray valueForKeyPath:kUniqueObjects];
    return uniqueSourceCategories;
}
@end
