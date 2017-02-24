//
//  CustomCollectionViewCell.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 16/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Define.h"
#import "ImageLoader.h"
#import "ImageManager.h"
#import "CustomCollectionViewCell.h"
#import "DataManager.h"

@implementation CustomCollectionViewCell

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.sourceImage.image = nil;
}

- (void)loadCellData:(SourceElement*)sourceElementObj

{
    self.sourceElement = sourceElementObj;
    self.sourceLabel.text = sourceElementObj.sourceName;
    [self.sourceLabel setFont:[UIFont systemFontOfSize:15]];
    [self loadingImage:sourceElementObj.sourceImage withImageView:self.sourceImage];
    
}


-(void) loadingImage:(NSString*)urlString withImageView:(UIImageView*)imageView
{

__block UIImage* sourceimage  = [[DataManager sharedInstance].cache objectForKey:urlString];
if(!sourceimage)
{
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:
      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          if(data)
          {
              sourceimage = [UIImage imageWithData:data];
              [[DataManager sharedInstance].cache setObject:sourceimage forKey:urlString];
        if(_sourceElement.sourceImage == urlString)
            
                  dispatch_async(dispatch_get_main_queue(), ^
                    {
                    imageView.image= sourceimage;
                    imageView.contentMode = UIViewContentModeScaleToFill;
                });
              
          }}] resume];
}
else
{
    if(_sourceElement.sourceImage == urlString)
    dispatch_async(dispatch_get_main_queue(), ^{
        imageView.image= sourceimage;
        imageView.contentMode = UIViewContentModeScaleToFill;
    });
}
}

//    [ImageLoader loadingImageFromUrl:sourceElementObj.sourceImage withCompletion:^(UIImage* receivedImage , NSString* receivedUrlString){
//        if(receivedUrlString==sourceElementObj.sourceImage)
//        {
//            self.sourceImage.image = receivedImage;
//        }
//
//
//    }];


@end
