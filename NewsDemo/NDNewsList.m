//
//  NDNewsList.m
//  NewsDemo
//
//  Created by Amanpreet singh on 06/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "NDCustomCell.h"
#import "Define.h"
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


// This method closes the current View Controller

- (IBAction)doneClicked:(UIButton*)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// This method open and close the category Options

- (IBAction)menuClicked:(UIButton*)sender
{
    
    
    NDCustomMenu* backGroundView = [[[NSBundle mainBundle]loadNibNamed:@"NDCustomMenu" owner:self options:nil] objectAtIndex:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(sender.tag == 0)
        {
            
            backGroundView.translatesAutoresizingMaskIntoConstraints=YES;
            backGroundView.frame=CGRectMake(0, self.menuButton.frame.origin.y+self.menuButton.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:backGroundView];
            self.doneButton.hidden = YES;
            backGroundView.sideView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            backGroundView.tableNewsCategories.backgroundColor=[UIColor whiteColor];
            backGroundView.tableNewsCategories.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
            backGroundView.tableNewsCategories.delegate=self;
            backGroundView.tableNewsCategories.dataSource=self;
            [backGroundView.tableNewsCategories reloadData];
            gesture =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(removeCustomMenu)];
            gesture.direction=UISwipeGestureRecognizerDirectionLeft;
            [backGroundView.sideView addGestureRecognizer:gesture];
            sender.tag=1;
        }
        else
        {
            for(UIView* subview in self.view.subviews)
            {
                if([subview isKindOfClass:[NDCustomMenu class]])
                {
                    [subview removeFromSuperview];
                }
            }
            
            self.doneButton.hidden = NO;
            sender.tag=0;

        }
}
                   );
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark Table View Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==0)
    {
    return [newsListTitle count];
    }
    else
    {
        return [_newsCategories count];
    }
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if(tableView.tag == 0)
    {
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
    else
            {
        
        static NSString* cellIdentifier2 = @"newsCategories";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
            
        }
        cell.textLabel.text = [[self.newsCategories objectAtIndex:indexPath.row] capitalizedString];
       cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    


    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==0)
    {
    }
    else
    {
      [self loadBackgroundView];
      NDWebServices* sharedObject = [NDWebServices sharedInstance];
      [sharedObject getNewsListFromSources:self.selectedNewsSources atIndex:0 withMatchingCategory:[[self.newsCategories objectAtIndex:indexPath.row] lowercaseString] filteredBy:newsFilterValue];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView.tag==1)
    {
        return 30;
    }
    else
    {
    return 140;
    }
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

    for( int j=0; j<articlesCount; j++)
    {
        
      [newsListTitle addObject:[[response objectForKey:@"articles"][j]objectForKey:@"title"] ];
      [newsListImage addObject:[[response objectForKey:@"articles"][j]objectForKey:@"urlToImage"] ];
      [newsListDescription addObject:[[response objectForKey:@"articles"][j]objectForKey:@"description"]];
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
