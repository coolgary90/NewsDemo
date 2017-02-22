//
//  NDCustomCell.m
//  NewsDemo
//
//  Created by Amanpreet singh on 06/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "ImageLoader.h"
#import "NDCustomCell.h"

@implementation NDCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)loadCellData:(NewsListElement *)newsList
{
    self.newsTitle.text = newsList.newsTitle;
    [self.newsTitle setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:16]];
    self.newsTitle.numberOfLines = 0;
    [self.newsTitle adjustsFontSizeToFitWidth];
    self.newsDescription.text = newsList.newsDescription;
    self.newsDescription.numberOfLines = 0;
    ImageLoader* sharedObject = [ImageLoader sharedInstance];
    [sharedObject loadingImage:newsList.newsImage withcompletionHandler:^(UIImage* receivedNewsImage){
    dispatch_async(dispatch_get_main_queue(), ^{
        self.newsImage.image =receivedNewsImage;
        self.newsImage.contentMode = UIViewContentModeScaleToFill;
        });
    }];
    

    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 2), ^
//    {
//      NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:newsList.newsImage]];
//       dispatch_async(dispatch_get_main_queue(), ^
//        {
//            self.newsImage.image = [UIImage imageWithData:data];
//            self.newsImage.contentMode = UIViewContentModeScaleToFill;
//        });
//                       
//    });
    
}


@end
