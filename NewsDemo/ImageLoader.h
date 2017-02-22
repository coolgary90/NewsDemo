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

@property(strong,nonatomic) NSCache* cache;

+(ImageLoader*)sharedInstance;

-(void)loadingImage:(NSString*)urlString withcompletionHandler:(void(^)(UIImage* myimage))completionBlock;
@end
