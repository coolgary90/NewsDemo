//
//  NDNewsList.m
//  NewsDemo
//
//  Created by Amanpreet singh on 06/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "NDCustomCell.h"
#import "UIUtils.h"
#import "WebServiceManager.h"
#import "NewsListElement.h"
#import "DataManager.h"
#import "Define.h"
#import "NDNewsDetail.h"
#import "NDCustomMenu.h"
#import "UIImageView+WebCache.h"
#import "NDNewsList.h"

@interface NDNewsList ()
{

    NSMutableArray* _newsList;
    NSString* _newsFilterValue;
    UIView* backgroundView;
   
}

@end

@implementation NDNewsList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _newsFilterValue = kTopNews;
    self.tableViewNewsList.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.topFilterButton.enabled=NO;
    self.popularFilterButton.enabled=NO;
    self.latestFilterButton.enabled=NO;
    [self fetchNewsList];
    

}


 // This method fetch news from selected News Sources

 - (void)fetchNewsList
{
    if([WebServiceManager isConnectedToNetwork])
    {
        self.activityIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0);
        [self.view bringSubviewToFront:self.activityIndicator];
        [self.activityIndicator startAnimating];
        DataManager* dataManagerObj =[DataManager sharedInstance];
        
        [dataManagerObj getNewsListFromSources:self.selectedNewsSources withCompetionHandler:^(NSMutableArray* finalNewsList){
            _newsList  = [[NSMutableArray alloc]init];
            _newsList = finalNewsList;
            [self loadingFetchedNews];
        }];
    }
    else
        [UIUtils messageAlert:KNoNetwork title:kAlertOops presentViewC:self];
    
}


#pragma mark IBAction methods

// This method called when any of top 3 buttons gets clicked

- (IBAction)SortNewsClicked:(UIButton*)sender
{
    [self loadBackGroundView];                                       
    DataManager* sharedObject  = [DataManager sharedInstance];
    NSUInteger tagValue = sender.tag;
    if(tagValue == 0)
    {
        _newsFilterValue = kTopNews;
        self.topFilterButton.backgroundColor = kColorSelectedFilter;
        self.latestFilterButton.backgroundColor = kColorUnSelectedFilter;
        self.popularFilterButton.backgroundColor = kColorUnSelectedFilter;
        [sharedObject getNewsListFromSources:self.selectedNewsSources filterBy:_newsFilterValue  withCompletionHandler:^(NSMutableArray* sortedList){
            if([sortedList count]==0)
                [self displayAlert];
            else
            {
                [_newsList removeAllObjects];
                _newsList = sortedList;
                [self loadingFetchedNews];
            }
           
        }];
        
        
    }
    else if (tagValue == 1)
    {
        _newsFilterValue = kLatestNews;
        self.topFilterButton.backgroundColor = kColorUnSelectedFilter;
        self.latestFilterButton.backgroundColor = kColorSelectedFilter;
        self.popularFilterButton.backgroundColor = kColorUnSelectedFilter;
        [sharedObject getNewsListFromSources:self.selectedNewsSources filterBy:_newsFilterValue  withCompletionHandler:^(NSMutableArray* sortedList){
            if([sortedList count]==0)
                [self displayAlert];
            else
            {
                [_newsList removeAllObjects];
                _newsList = sortedList;
                [self loadingFetchedNews];
            }

        }];


    }
    else if (tagValue == 2)
    {
        _newsFilterValue = kPopularNews;
        self.topFilterButton.backgroundColor = kColorUnSelectedFilter;
        self.latestFilterButton.backgroundColor = kColorUnSelectedFilter;
        self.popularFilterButton.backgroundColor = kColorSelectedFilter;
        [sharedObject getNewsListFromSources:self.selectedNewsSources filterBy:_newsFilterValue  withCompletionHandler:^(NSMutableArray* sortedList){
            if([sortedList count]==0)
            [self displayAlert];
            else
            {
              [_newsList removeAllObjects];
              _newsList = sortedList;
              [self loadingFetchedNews];
            }

        }];
        



    }
}


# pragma mark Table View Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_newsList count];
   
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    static NSString* cellIdentifier = @"tableViewListCell";
    NDCustomCell* cell = (NDCustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NDCustomCell" owner:self options:nil] objectAtIndex:0];
    }
    NewsListElement* newsListElementObj = [_newsList objectAtIndex:indexPath.row];
    [cell loadCellData:newsListElementObj];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:kMain bundle:nil];
    NDNewsDetail *newsDetailObj = [storyboard instantiateViewControllerWithIdentifier:@"NewsDetail"];
    NewsListElement* newsListElementObj = [_newsList objectAtIndex:indexPath.row];
    newsDetailObj.newsUrl = newsListElementObj.newsUrl;
    [self.navigationController pushViewController:newsDetailObj animated:YES];

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 150;
    
}



#pragma mark Custom Methods


//This method display Alert to user that No news Available with selected filter

- (void)displayAlert
{
    self.topFilterButton.enabled = YES;
    self.popularFilterButton.enabled = YES;
    self.latestFilterButton.enabled = YES;
   UIAlertController* alert = [UIAlertController alertControllerWithTitle:kAlertOops message:kAlertNoNews preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:kAlertOk style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^
    {
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidden:YES];
    [backgroundView removeFromSuperview];
    });
}



// This method loads the background view until News get fetched

 - (void)loadBackGroundView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topFilterButton.enabled = NO;
        self.popularFilterButton.enabled = NO;
        self.latestFilterButton.enabled = NO;
        
        backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:backgroundView];
        [self.view bringSubviewToFront:self.activityIndicator];
        [self.activityIndicator setHidden:NO];
        self.activityIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0);
        [self.activityIndicator  startAnimating];
    });

}


//This method loads the fetched News in TableView

- (void)loadingFetchedNews
{
    
dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
        [backgroundView removeFromSuperview];
        self.topFilterButton.enabled = YES;
        self.popularFilterButton.enabled = YES;
        self.latestFilterButton.enabled = YES;
        self.tableViewNewsList.rowHeight = UITableViewAutomaticDimension;
        [self.tableViewNewsList reloadData];
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//-(void)newsListReceived:(NSNotification*)info
//{
//
//    [self reloadSources:info.userInfo];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
