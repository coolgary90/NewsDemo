//
//  CustomCollectionViewCell.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 16/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Define.h"
#import "DataManager.h"
#import "ImageManager.h"
#import "CustomCollectionViewCell.h"

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
    [self loadingImage:sourceElementObj.sourceImage ];
    
}



// This method loads the images of News Sources  from url and set the image on ImageView

-(void) loadingImage:(NSString*)urlString
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
                    self.sourceImage.image= sourceimage;
                    self.sourceImage.contentMode = UIViewContentModeScaleToFill;
                });
              
          }}] resume];
}
else
{
    if(_sourceElement.sourceImage == urlString)
    dispatch_async(dispatch_get_main_queue(), ^{
        self.sourceImage.image = sourceimage;
        self.sourceImage.contentMode = UIViewContentModeScaleToFill;
    });
}
}




@end
