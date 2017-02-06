//
//  NDNewsList.h
//  NewsDemo
//
//  Created by Amanpreet singh on 06/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDNewsList : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic) NSString* newsId;
@property(strong, nonatomic) NSMutableArray* newsCategories;
@property(strong, nonatomic) IBOutlet UITableView* tableViewNewsList;
@property(strong, nonatomic) IBOutlet UITableView* tableViewNewsCategories;
@property(strong, nonatomic) IBOutlet UIView* backGroundView;
@property(strong, nonatomic) IBOutlet UIButton* menuButton;
@property(strong, nonatomic) IBOutlet UIButton* doneButton;


@end
