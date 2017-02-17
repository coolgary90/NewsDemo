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
@property(strong, nonatomic) NSMutableArray* selectedNewsSources;

@property(weak, nonatomic) IBOutlet UITableView* tableViewNewsList;
@property(weak, nonatomic) IBOutlet UITableView* tableViewNewsCategories;
@property(weak, nonatomic) IBOutlet UIView* backGroundView;
@property(weak, nonatomic) IBOutlet UIButton* topFilterButton;
@property(weak, nonatomic) IBOutlet UIButton* latestFilterButton;
@property(weak, nonatomic) IBOutlet UIButton* popularFilterButton;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;



@end
