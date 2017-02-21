//
//  SourceElement.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 16/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "Define.h"
#import "SourceElement.h"

@implementation SourceElement



+(instancetype)createSourceList:(NSDictionary*)dict
{
    SourceElement* sourceElementobj = [[SourceElement alloc]initWithArray:dict];
    return sourceElementobj;
    
}


- (instancetype)initWithArray:(NSDictionary*)dict{
    
    
    if(self = [super init])
    {
    self.sourceName = [dict objectForKey:kNewsSourceName];
    self.sourceID = [dict objectForKey:kNewsSourcesId];
    self.sourceImage = [[dict objectForKey:kNewsSourcesUrlToLogo] objectForKey:@"small"];
    }
    return self;
    
}
@end
