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
    NSDictionary* jsonResponse;
    NSMutableArray* newsListImage;
    NSMutableArray* newsListTitle;
    NSMutableArray* newsListDescription;
    NSMutableArray* newsListUrl;
    NSString* newsFilterValue;
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
    newsFilterValue=kTopNews;
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center=self.view.center;
    activityIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0);
    activityIndicator.color = [UIColor blueColor];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    self.tableViewNewsList.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNewsListLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(newsListReceived:) name:kNewsListLoadedNotification object:nil];

}

#pragma mark IBAction methods

// This method called when any of top 3 buttons gets clicked

- (IBAction)SortNewsClicked:(UIButton*)sender
{
    backgroundView.translatesAutoresizingMaskIntoConstraints = YES;
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    backgroundView.center= self.view.center;
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center=self.view.center;
    activityIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0);
    activityIndicator.color = [UIColor blueColor];
    [backgroundView addSubview:activityIndicator];
    [self.view addSubview:backgroundView];
    [activityIndicator startAnimating];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNewsListLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(newsListReceived:) name:kNewsListLoadedNotification object:nil];
    NDWebServices* sharedObject = [NDWebServices sharedInstance];
    NSUInteger tagValue = sender.tag;
    if(tagValue == 0)
    {
        newsFilterValue = kTopNews;
        self.topFilterButton.backgroundColor = kColorSelectedFilter;
        self.latestFilterButton.backgroundColor = kColorUnSelectedFilter;
        self.popularFilterButton.backgroundColor = kColorUnSelectedFilter;
        [sharedObject getNewsListFromSources:self.selectedNewsSources filterBy:newsFilterValue];
        
        
    }
    else if (tagValue == 1)
    {
        newsFilterValue = kLatestNews;
        self.topFilterButton.backgroundColor = kColorUnSelectedFilter;
        self.latestFilterButton.backgroundColor = kColorSelectedFilter;
        self.popularFilterButton.backgroundColor = kColorUnSelectedFilter;
        [sharedObject getNewsListFromSources:self.selectedNewsSources filterBy:newsFilterValue];


    }
    else if (tagValue == 2)
    {
        newsFilterValue = kPopularNews;
        self.topFilterButton.backgroundColor = kColorUnSelectedFilter;
        self.latestFilterButton.backgroundColor = kColorUnSelectedFilter;
        self.popularFilterButton.backgroundColor = kColorSelectedFilter;
        [sharedObject getNewsListFromSources:self.selectedNewsSources filterBy:newsFilterValue];



    }
}


# pragma mark Table View Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [newsListTitle count];
   
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    static NSString* cellIdentifier = @"tableViewListCell";
    NDCustomCell* cell = (NDCustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NDCustomCell" owner:self options:nil] objectAtIndex:0];
        
    }
    cell.newsTitle.text=[newsListTitle objectAtIndex:indexPath.row];
    cell.newsDescription.text=[newsListDescription objectAtIndex:indexPath.row];
    [cell.newsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[newsListImage objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:kPlaceHolderImage]];
    cell.newsTitle.numberOfLines=0;
    [cell.newsTitle adjustsFontSizeToFitWidth];
    cell.newsImage.contentMode=UIViewContentModeScaleAspectFit;
    cell.newsDescription.numberOfLines=0;
    return cell;
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard* storyboard= [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NDNewsDetail *newsDetailObj = [storyboard instantiateViewControllerWithIdentifier:@"NewsDetail"];
    newsDetailObj.newsUrl = [newsListUrl objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:newsDetailObj animated:YES];

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 140;
    
}

-(void)newsListReceived:(NSNotification*)info
{
    
    [self reloadSources:info.userInfo];
}

-( void)reloadSources:(NSDictionary*)response
{
    
   NSUInteger articlesCount = [[response objectForKey:@"articles"] count];
   if(articlesCount == 0)
   {
        
        [self displayAlert];
   }
  else
  {
        newsListImage= [[ NSMutableArray alloc]init];
        newsListTitle = [[NSMutableArray alloc]init];
        newsListDescription = [[NSMutableArray alloc]init];
      newsListUrl = [[NSMutableArray alloc]init];

    for( int j=0; j<articlesCount; j++)
    {
        
      [newsListTitle addObject:[[response objectForKey:@"articles"][j]objectForKey:@"title"] ];
      [newsListImage addObject:[[response objectForKey:@"articles"][j]objectForKey:@"urlToImage"] ];
      [newsListDescription addObject:[[response objectForKey:@"articles"][j]objectForKey:@"description"]];
        [newsListUrl addObject:[[response objectForKey:@"articles"][j]objectForKey:@"url"]];
    
    }
    
     dispatch_async(dispatch_get_main_queue(), ^
    {
    [activityIndicator startAnimating];
    [activityIndicator removeFromSuperview];
    [backgroundView removeFromSuperview];
    self.tableViewNewsList.delegate=self;
    self.tableViewNewsList.dataSource=self;
    self.tableViewNewsList.rowHeight=UITableViewAutomaticDimension;
    [self.tableViewNewsList reloadData];
    });
                   

   }
   
}

- (void)displayAlert
{
    
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

// This methods loads the background screen with Activity Indicator until response received


- (void)loadBackgroundView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for(UIView* subview in self.view.subviews)
        {
            if([subview isKindOfClass:[NDCustomMenu class]])
            {
                [subview removeFromSuperview];
            }
        }
        backgroundView.translatesAutoresizingMaskIntoConstraints=YES;
        backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        backgroundView.center= self.view.center;
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center=self.view.center;
        
        activityIndicator.transform=CGAffineTransformMakeScale(2.0, 2.0);
        activityIndicator.color = [UIColor blueColor];
        [backgroundView addSubview:activityIndicator];
        [self.view addSubview:backgroundView];
        [activityIndicator startAnimating];
        _menuButton.tag=0;
        [_doneButton setHidden:NO];
        
        
    });

}

-(void)removeCustomMenu
{
    
    for(UIView* subview in self.view.subviews)
    {
        if([subview isKindOfClass:[NDCustomMenu class]])
        {
            [subview removeFromSuperview];
        }
    }
    self.doneButton.hidden = NO;
    self.menuButton.tag=0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
