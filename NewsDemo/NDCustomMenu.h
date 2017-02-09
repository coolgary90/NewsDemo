//
//  NDCustomMenu.h
//  NewsDemo
//
//  Created by Amanpreet Singh on 06/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDCustomMenu : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableNewsCategories;
@property (weak, nonatomic) IBOutlet UIView *sideView;
@property (weak, nonatomic) IBOutlet UILabel *appVersion;


@end
