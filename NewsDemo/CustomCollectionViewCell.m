//
//  CustomCollectionViewCell.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 16/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "Define.h"
#import "ImageLoader.h"
#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)loadCellData:(SourceElement*)sourceElementObj

{
    self.sourceLabel.text = sourceElementObj.sourceName;
    [self.sourceLabel setFont:[UIFont systemFontOfSize:15]];
    ImageLoader* sharedObject = [ImageLoader sharedInstance];
    [sharedObject loadingImage:sourceElementObj.sourceImage withcompletionHandler:^(UIImage* finalImage){
        dispatch_async(dispatch_get_main_queue(), ^{
        self.sourceImage.image=finalImage;
        self.sourceImage.contentMode = UIViewContentModeScaleToFill;

        });
    }];
}
@end
