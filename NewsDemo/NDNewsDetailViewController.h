//
//  NDNewsDetail.h
//  NewsDemo
//
//  Created by Amanpreet Singh on 08/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDNewsDetailViewController : UIViewController <UIWebViewDelegate>

@property(weak, nonatomic) NSString* newsUrl;
@property(weak, nonatomic) IBOutlet UIWebView* webView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;



@end
