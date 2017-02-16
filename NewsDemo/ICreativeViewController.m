//
//  ICreativeViewController.m
//  ICreative
//
//  Created by Simrandeep Singh on 17/11/16.
//  Copyright © 2016 Simrandeep Singh. All rights reserved.
//


#import "DataManager.h"
//#import "UICachedFileMgr.h"
//#import "FeedElement.h"
#import "ICreativeViewController.h"
//#import "NewsFeedCollectionViewCell.h"
#import "WebServiceManager.h"
#import "UIUtils.h"


@interface ICreativeViewController ()
{
	NSArray* _feedList;
	BOOL _isFirstTime;
}

@end

@implementation ICreativeViewController

- (void) viewDidLoad
{
	[super viewDidLoad];
    self.navigationController.tabBarController.delegate=self;
    
    
    NSString* orientationChangedNotification = @"orientation got changed";
    [[NSNotificationCenter defaultCenter] postNotificationName:orientationChangedNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
   
    
    if([WebServiceManager isConnectedToNetwork])
    {
        _isFirstTime = YES;
        [self loadData];
    }
    else
    {
//        [UIUtils messageAlert:kServiceErrorMessage title:@"No Internet" presentViewC:self];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	if (_isFirstTime == NO)
    [self loadWebPage];
}

- (void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:YES];
	_isFirstTime = NO;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (void) loadWebPage
{
	_newsFeedCollectionView.hidden = YES;
	_neewsFeedWebView.hidden = NO;

//	NSString* urlStr = kNewsFeedWebUrl;
//	if (urlStr)
//		[_neewsFeedWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
	[_activityIndicator startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
	[_activityIndicator stopAnimating];
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (navigationType == UIWebViewNavigationTypeLinkClicked )
	{
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}
	
	return YES;
}

- (void) loadData
{
	_newsFeedCollectionView.hidden = NO;
	_neewsFeedWebView.hidden = YES;
    [_activityIndicator startAnimating];

	[gDataManager getFeedListwithCallback:^(NSArray* feedList)
	{
		_feedList = feedList;
        [self.newsFeedCollectionView reloadData];
		[_activityIndicator stopAnimating];
	}];
}

#pragma mark -

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [_feedList count];
}

//- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString* cellIdentifier = @"NewsFeedCell";
//    NewsFeedCollectionViewCell* cell = (NewsFeedCollectionViewCell* )[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//
//    FeedElement* feedElement = [_feedList objectAtIndex:indexPath.row];
//    [cell loadCellData:feedElement];  
//    return cell;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return collectionView.bounds.size;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    FeedElement* feedElement = [_feedList objectAtIndex:indexPath.row];
//    NSString* url = feedElement.feedOptionalUrl;
//    if (url)
//    {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    }
}


#pragma mark
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController* navigationController = (UINavigationController*) viewController;
    UIViewController* uiViewController = (UIViewController*)navigationController.topViewController;
    if([uiViewController isKindOfClass:[ICreativeViewController class]])
    [self loadWebPage];
    
}
- (void)orientationChanged:(NSNotification* )notification
{
    [self.newsFeedCollectionView reloadData];
}

@end
