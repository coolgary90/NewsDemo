//
//  ImageLoader.h
//  NewsDemo
//
//  Created by Amanpreet Singh on 22/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ImageLoader : NSObject



+(void) loadingImage:(NSString*)urlString withImageView:(UIImageView*)imageView;

+(void) loadingSourceImage:(NSString*)urlString withcompletionHandler:(void(^)(UIImage* myimage))completionBlock;

@property(strong,nonatomic) NSString* imageUrl;

+(UIImage*)loadingImageFromCache:(NSString*)urlString;

+(void) loadingImageFromUrl:(NSString*)urlString withCompletion:(void (^)(UIImage* ,NSString*))completionBlock;



@end
