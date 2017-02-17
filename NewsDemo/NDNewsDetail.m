//
//  NDNewsDetail.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 08/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#import "NDNewsDetail.h"

@interface NDNewsDetail ()

@end

@implementation NDNewsDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.newsUrl]]];
    self.activityIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0);
    [self.view bringSubviewToFront:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
        
    }
    );
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
