//
//  ImageLoader.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 22/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ImageLoader.h"

@implementation ImageLoader


+(ImageLoader*)sharedInstance
{
    static ImageLoader* sharedObject =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject  = [[ImageLoader alloc]init];
    });
    return sharedObject;
}

-(id)init
{
   
    if(self = [super init])
    {
       self.cache = [[NSCache alloc]init];
    }
    return self;
}


-(void)loadingImage:(NSString *)urlString withcompletionHandler:(void (^)(UIImage *))completionBlock
{
    
    UIImage* sourceimage  = [self.cache objectForKey:urlString];
    if(!sourceimage)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlString]];
        UIImage* finalImage = [UIImage imageWithData:data];
        [self.cache setObject:finalImage forKey:urlString];
        completionBlock(finalImage);
        });
    }
    else
     {
         completionBlock(sourceimage);
    }
}







@end
