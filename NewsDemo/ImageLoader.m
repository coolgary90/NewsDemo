//
//  ImageLoader.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 22/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ImageLoader.h"
#import "DataManager.h"

@implementation ImageLoader





+(void) loadingImage:(NSString*)urlString withImageView:(UIImageView*)imageView
{
    __block NSString *imageUrl = urlString;
    imageView.image = nil;
    __block UIImage* sourceimage  = [[DataManager sharedInstance].cache objectForKey:urlString];
    if(!sourceimage)
    {
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:
          ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
          {
              if(data)
              {
                  sourceimage = [UIImage imageWithData:data];
                  [[DataManager sharedInstance].cache setObject:sourceimage forKey:urlString];
                  if(imageUrl==urlString)
                      dispatch_async(dispatch_get_main_queue(), ^
                                     {
                                         imageView.image= sourceimage;
                                         imageView.contentMode = UIViewContentModeScaleToFill;
                                     });
                  
              }}] resume];
        
    }
    //});
    
    else
    {
        if(imageUrl==urlString)
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image= sourceimage;
                imageView.contentMode = UIViewContentModeScaleToFill;
            });
    }
}


+(void) loadingImageFromUrl:(NSString*)urlString withCompletion:(void (^)(UIImage* ,NSString*))completionBlock{
    
    __block UIImage* sourceimage  = [[DataManager sharedInstance].cache objectForKey:urlString];
    if(!sourceimage)
    {
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
          ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
          {
              if(data)
              {
                  sourceimage = [UIImage imageWithData:data];
                  [[DataManager sharedInstance].cache setObject:sourceimage forKey:urlString];
                  completionBlock(sourceimage,urlString);
                  
                  
              }}] resume];
//        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:
//          ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
//          {
//              if(data)
//              {
//                  sourceimage = [UIImage imageWithData:data];
//                  [[DataManager sharedInstance].cache setObject:sourceimage forKey:urlString];
//                  completionBlock(sourceimage,urlString);
//                  
//                  
//              }}] resume];
        
    }
    else
    {
        
        completionBlock(sourceimage,urlString);
    }
    
}

+(UIImage*)loadingImageFromCache:(NSString*)urlString
{
    
    UIImage* sourceimage  = [[DataManager sharedInstance].cache objectForKey:urlString];
    return sourceimage;
}






@end
