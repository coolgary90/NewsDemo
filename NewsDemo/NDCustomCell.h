//
//  NDCustomCell.h
//  NewsDemo
//
//  Created by Amanpreet singh on 06/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* newsTitle;
@property (weak, nonatomic) IBOutlet UILabel* newsDescription;
@property (weak, nonatomic) IBOutlet UIImageView* newsImage;

@end
