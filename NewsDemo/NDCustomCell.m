//
//  NDCustomCell.m
//  NewsDemo
//
//  Created by Amanpreet singh on 06/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "UIImageView+WebCache.h"
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
    [self.newsImage sd_setImageWithURL:[NSURL URLWithString:newsList.newsImage] placeholderImage:[UIImage imageNamed:@"No-image.png"]];
    self.newsImage.contentMode = UIViewContentModeScaleToFill;



}


@end
