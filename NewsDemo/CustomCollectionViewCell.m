//
//  CustomCollectionViewCell.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 16/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "Define.h"
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 2), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:sourceElementObj.sourceImage]];
        dispatch_async(dispatch_get_main_queue(), ^
        {
        self.sourceImage.image = [UIImage imageWithData:data];
        self.sourceImage.contentMode = UIViewContentModeScaleToFill;
        });
        
        
    });
    }
    

@end
