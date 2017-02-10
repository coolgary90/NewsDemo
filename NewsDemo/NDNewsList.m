//
//  NDNewsList.m
//  NewsDemo
//
//  Created by Amanpreet singh on 06/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "NDCustomCell.h"
#import "Define.h"
#import "NDNewsDetail.h"
#import "NDCustomMenu.h"
#import "NDWebServices.h"
#import "UIImageView+WebCache.h"
#import "NDNewsList.h"

@interface NDNewsList ()
{
    NSDictionary* _jsonResponse;
    NSMutableArray* _newsListImage;
    NSMutableArray* _newsListTitle;
    NSMutableArray* _newsListDescription;
    NSMutableArray* _newsListUrl;
    NSString* _newsFilterValue;
    UIActivityIndicatorView* activityIndicator;
    UIView* backgroundView;
    UISwipeGestureRecognizer* gesture;
   
}

@end

@implementation NDNewsList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NDWebServices* sharedObject = [NDWebServices sharedInstance];
    [sharedObject getNewsListFromSources:self.selectedNewsSources];
    _newsFilterValue = kTopNews;
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.view.center;
    activityIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0);
    activityIndicator.color = [UIColor blueColor];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    self.tableViewNewsList.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNewsListLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(newsListReceived:) name:kNewsListLoadedNotification object:nil];
    self.topFilterButton.enabled=NO;
    self.popularFilterButton.enabled=NO;
    self.latestFilterButton.enabled=NO;

}

#pragma mark IBAction methods

// This method called when any of top 3 buttons gets clicked

- (IBAction)SortNewsClicked:(UIButton*)sender
{
    [self loadBackGroundView];                                       
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNewsListLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(newsListReceived:) name:kNewsListLoadedNotification object:nil];
    NDWebServices* sharedObject = [NDWebServices sharedInstance];
    NSUInteger tagValue = sender.tag;
    if(tagValue == 0)
    {
        _newsFilterValue = kTopNews;
        self.topFilterButton.backgroundColor = kColorSelectedFilter;
        self.latestFilterButton.backgroundColor = kColorUnSelectedFilter;
        self.popularFilterButton.backgroundColor = kColorUnSelectedFilter;
        [sharedObject getNewsListFromSources:self.selectedNewsSources filterBy:_newsFilterValue];
        
        
    }
    else if (tagValue == 1)
    {
        _newsFilterValue = kLatestNews;
        self.topFilterButton.backgroundColor = kColorUnSelectedFilter;
        self.latestFilterButton.backgroundColor = kColorSelectedFilter;
        self.popularFilterButton.backgroundColor = kColorUnSelectedFilter;
        [sharedObject getNewsListFromSources:self.selectedNewsSources filterBy:_newsFilterValue];


    }
    else if (tagValue == 2)
    {
        _newsFilterValue = kPopularNews;
        self.topFilterButton.backgroundColor = kColorUnSelectedFilter;
        self.latestFilterButton.backgroundColor = kColorUnSelectedFilter;
        self.popularFilterButton.backgroundColor = kColorSelectedFilter;
        [sharedObject getNewsListFromSources:self.selectedNewsSources filterBy:_newsFilterValue];



    }
}


# pragma mark Table View Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_newsListTitle count];
   
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    static NSString* cellIdentifier = @"tableViewListCell";
    NDCustomCell* cell = (NDCustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NDCustomCell" owner:self options:nil] objectAtIndex:0];
        
    }
    cell.newsTitle.text = [_newsListTitle objectAtIndex:indexPath.row];
    cell.newsDescription.text = [_newsListDescription objectAtIndex:indexPath.row];
    [cell.newsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_newsListImage objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:kPlaceHolderImage]];
    cell.newsTitle.numberOfLines = 0;
    [cell.newsTitle adjustsFontSizeToFitWidth];
    cell.newsImage.contentMode = UIViewContentModeScaleToFill;
    cell.newsDescription.numberOfLines = 0;
    return cell;
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:kMain bundle:nil];
    NDNewsDetail *newsDetailObj = [storyboard instantiateViewControllerWithIdentifier:@"NewsDetail"];
    newsDetailObj.newsUrl = [_newsListUrl objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:newsDetailObj animated:YES];

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 150;
    
}



#pragma mark Custom Methods


// This method called when NSNotification with name kNewsListLoadedNotification fired after fetching data from service

-( void)newsListReceived:(NSNotification*)info
{
   NSDictionary* response = info.userInfo;
   NSUInteger articlesCount = [[response objectForKey:kNewsArticles] count];
   if(articlesCount == 0)
   {
        
        [self displayAlert];
   }
  else
  {
        _newsListImage= [[ NSMutableArray alloc]init];
        _newsListTitle = [[NSMutableArray alloc]init];
        _newsListDescription = [[NSMutableArray alloc]init];
        _newsListUrl = [[NSMutableArray alloc]init];

    for( int j = 0; j<articlesCount; j++)
    {
        if(![[[response objectForKey:kNewsArticles][j]objectForKey:@"description"] isEqual:[NSNull null]])
        {
            [_newsListTitle addObject:[[response objectForKey:kNewsArticles][j]objectForKey:@"title"] ];
            [_newsListImage addObject:[[response objectForKey:kNewsArticles][j]objectForKey:@"urlToImage"] ];
            [_newsListDescription addObject:[[response objectForKey:kNewsArticles][j]objectForKey:@"description"]];
            [_newsListUrl addObject:[[response objectForKey:kNewsArticles][j]objectForKey:@"url"]];
        }
     
    
    }
    
      [self loadingFetchedNews];

   }
   
}



//This method display Alert to user that No news Available with selected filter

- (void)displayAlert
{
    self.topFilterButton.enabled = YES;
    self.popularFilterButton.enabled = YES;
    self.latestFilterButton.enabled = YES;
   UIAlertController* alert = [UIAlertController alertControllerWithTitle:kAlertOops message:KAlertNoNews preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:kAlertOk style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^
    {
    [activityIndicator startAnimating];
    [activityIndicator removeFromSuperview];
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
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center=self.view.center;
        activityIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0);
        activityIndicator.color = [UIColor blueColor];
        [backgroundView addSubview:activityIndicator];
        [self.view addSubview:backgroundView];
        [activityIndicator startAnimating];
    });

}


//This method loads the fetched News in TableView

- (void)loadingFetchedNews
{
    
dispatch_async(dispatch_get_main_queue(), ^
    {
        [activityIndicator startAnimating];
        [activityIndicator removeFromSuperview];
        [backgroundView removeFromSuperview];
        self.topFilterButton.enabled = YES;
        self.popularFilterButton.enabled = YES;
        self.latestFilterButton.enabled = YES;
        self.tableViewNewsList.delegate = self;
        self.tableViewNewsList.dataSource = self;
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
