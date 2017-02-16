//
//  CustomCollectionViewCell.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 16/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "Define.h"
#import "UIImageView+WebCache.h"
#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)loadCellData:(SourceElement*)sourceElementObj
{
    
    
    self.sourceLabel.text = sourceElementObj.sourceName;
    [self.sourceImage sd_setImageWithURL:[NSURL URLWithString:sourceElementObj.sourceImage] placeholderImage:[UIImage imageNamed:kPlaceHolderImage]];
    
    
    }
    

@end
