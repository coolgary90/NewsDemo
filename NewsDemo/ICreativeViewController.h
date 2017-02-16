//
//  ICreativeViewController.h
//  ICreative
//
//  Created by Simrandeep Singh on 17/11/16.
//  Copyright © 2016 Simrandeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICreativeViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource,UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (weak, nonatomic) IBOutlet UICollectionView *newsFeedCollectionView;
@property (weak, nonatomic) IBOutlet UIWebView *neewsFeedWebView;


@end
