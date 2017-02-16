//
//  CustomCollectionViewCell.h
//  NewsDemo
//
//  Created by Amanpreet Singh on 16/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SourceElement.h"

@interface CustomCollectionViewCell : UICollectionViewCell


@property(weak,nonatomic) IBOutlet UIImageView* sourceImage;
@property(weak,nonatomic) IBOutlet UILabel* sourceLabel;

-(void)loadCellData:(SourceElement*)sourceElementObj;


@end
