//
//  NDNewsSources.m
//  NewsDemo
//
//  Created by Amanpreet singh on 05/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "NDCustomMenu.h"
#import "Define.h"
#import "NDWebServices.h"
#import "NDNewsList.h"
#import "NDNewsSources.h"

@interface NDNewsSources ()
{
    NSDictionary* _jsonResponse;
    NSMutableArray* _newsSourcesNames;
    NSMutableArray* _newsSourcesImage;
    NSMutableArray* _newsSourcesid;
    NSMutableArray* _newSourcesCategories;
    NSMutableArray* _newSourcesUniqueCategories;
    NSMutableArray* _newsOptions;
    UIActivityIndicatorView* activityIndicator;
    UITapGestureRecognizer* gesture;
    UIView* backgroundView;
    UIBarButtonItem* menu;
    
}

@end

@implementation NDNewsSources

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _newsSourcesImage = [[NSMutableArray alloc]init];
    _newsSourcesNames = [[NSMutableArray alloc]init];
    _newsSourcesid = [[NSMutableArray alloc]init];
    _newSourcesCategories = [[NSMutableArray alloc]init];
    _newsOptions = [[NSMutableArray alloc]init];
    _newSourcesUniqueCategories = [[NSMutableArray alloc]init];
    _jsonResponse = [[NSDictionary alloc]init];
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center=self.view.center;
    activityIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0);
    activityIndicator.color = [UIColor blueColor];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    NDWebServices* sharedObject = [NDWebServices sharedInstance];
     [sharedObject getNewsSources];                            // Fetching list of News Sources
    
    UIImage *image = [[UIImage imageNamed:@"menu5.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    menu = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(menuClicked:)];
    self.navigationItem.leftBarButtonItem=menu;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNewsSourcesLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(reloadSources:) name:kNewsSourcesLoadedNotification object:nil];
    
}


-( void)reloadSources:(NSNotification*)info
{
    
    NSDictionary* response = info.userInfo;
    NSUInteger totalSources = [[response objectForKey:@"sources"] count];
    for( int j = 0; j<totalSources; j++)
    {
        [_newsSourcesNames addObject:[[response objectForKey:@"sources"][j]objectForKey:@"name"] ];
        [_newsSourcesImage addObject:[[[response objectForKey:@"sources"][j]objectForKey:@"urlsToLogos"] objectForKey:@"small"]];
        [_newsSourcesid addObject:[[response objectForKey:@"sources"][j]objectForKey:@"id"]];
        [_newSourcesCategories addObject:[[response objectForKey:@"sources"][j]objectForKey:@"category"]];
    }
    
    _newSourcesUniqueCategories = [_newSourcesCategories valueForKeyPath:kUniqueObjects];
       [self reloadCollectionView];
   
}


-(void)reloadNewSources:(NSNotification*)info
{
    
    NSDictionary* response = info.userInfo;
    _newsSourcesNames = [[NSMutableArray alloc]init];
    _newsSourcesImage = [[NSMutableArray alloc]init];
    _newsSourcesid = [[NSMutableArray alloc]init];
    _newsOptions = [[NSMutableArray alloc]init];
    
    NSUInteger totalSources = [[response objectForKey:@"sources"] count];
    for( int j = 0; j<totalSources; j++)
    {
        
        [_newsSourcesNames addObject:[[response objectForKey:@"sources"][j]objectForKey:@"name"] ];
        [_newsSourcesImage addObject:[[[response objectForKey:@"sources"][j]objectForKey:@"urlsToLogos"] objectForKey:@"small"]];
        [_newsSourcesid addObject:[[response objectForKey:@"sources"][j]objectForKey:@"id"]];

    }
    [self reloadCollectionView];
    
}


# pragma mark CollectionView Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_newsSourcesNames count];
    
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellIdentifier = @"collectionViewCell";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImageView* sourcebackgroundImage = (UIImageView*)[cell viewWithTag:100];
    UILabel* sourceName=(UILabel*)[cell viewWithTag:101];
    sourceName.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    sourceName.text = [_newsSourcesNames objectAtIndex:indexPath.row];
    [sourceName setFont:[UIFont systemFontOfSize:15]];
    [sourcebackgroundImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_newsSourcesImage objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:kPlaceHolderImage]];
    [sourcebackgroundImage setContentMode:UIViewContentModeScaleToFill];
    
    if([_newsOptions containsObject:[_newsSourcesid objectAtIndex:indexPath.row]])
    {
        cell.layer.borderColor = [UIColor blueColor].CGColor;
        cell.layer.borderWidth = 3.0;
    }
    else
    {
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        cell.layer.borderWidth = 1.0;
    }
    return cell;
    
    
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell* cell  = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor blueColor].CGColor;
    cell.layer.borderWidth = 3.0;
    [_newsOptions addObject:[_newsSourcesid objectAtIndex:indexPath.row]];
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell* cell  = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    cell.layer.borderWidth = 0.0;
    [_newsOptions removeObject:[_newsSourcesid objectAtIndex:indexPath.row]];

}




# pragma mark TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
return [_newSourcesUniqueCategories count];
       
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       static NSString* cellIdentifier = @"newsCategories";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
        cell.textLabel.text = [[_newSourcesUniqueCategories objectAtIndex:indexPath.row] capitalizedString];
        cell.textLabel.numberOfLines=0;
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [self loadBackgroundView];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:kCategorizeSourcesLoadedNotification object:nil];
        [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(reloadNewSources:) name:kCategorizeSourcesLoadedNotification object:nil];
        NDWebServices* sharedObject = [NDWebServices sharedInstance];
        [sharedObject getNewsSourcesWithCategory:[_newSourcesUniqueCategories objectAtIndex:indexPath.row]];
    
}



#pragma mark IBActions

//This method is responsible for navigating to next View Controller which loads News from Selected  Sources

- (IBAction)continueClicked:(id)sender
{
    if([_newsOptions count]<2)
    {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:KAlertMinimumSourceSelection preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:kAlertOk style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else
    {
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:kMain bundle:nil];
        NDNewsList* newsListObj = [storyBoard instantiateViewControllerWithIdentifier:kNewsList];
        newsListObj.selectedNewsSources = _newsOptions ;
        newsListObj.newsCategories = _newSourcesUniqueCategories;
        [self.navigationController pushViewController:newsListObj animated:YES];
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This method called when UIBarButton Item Clicked

- (void)menuClicked:(UIButton*)sender
{
    
    
    NDCustomMenu* backGroundView = [[[NSBundle mainBundle]loadNibNamed:@"NDCustomMenu" owner:self options:nil] objectAtIndex:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(sender.tag == 0)
        {
            
            backGroundView.translatesAutoresizingMaskIntoConstraints=YES;
            backGroundView.frame = CGRectMake(0, self.header.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:backGroundView];
            backGroundView.sideView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            backGroundView.tableNewsCategories.backgroundColor=[UIColor whiteColor];
            backGroundView.tableNewsCategories.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
            backGroundView.tableNewsCategories.delegate=self;
            backGroundView.tableNewsCategories.dataSource=self;
            [backGroundView.tableNewsCategories reloadData];
            gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeCustomMenu)];
            [backGroundView.sideView addGestureRecognizer:gesture];
            sender.tag=1;
            NSString * _versionNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
            NSString* _buildNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            NSString* _BuildInfo = [NSString stringWithFormat:@"V%@ (%@)", _versionNumber, _buildNumber];
            
            backGroundView.appVersion.text = _BuildInfo;
            
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
            
            sender.tag=0;
            
        }
    }
                   );
    
}



#pragma mark Custom Methods

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
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center=self.view.center;
        
        activityIndicator.transform=CGAffineTransformMakeScale(2.0, 2.0);
        activityIndicator.color = [UIColor blueColor];
        [backgroundView addSubview:activityIndicator];
        [self.view addSubview:backgroundView];
        [activityIndicator startAnimating];
        menu.tag=0;

    });
    
}


// This method removes Activity Indicator from Super View

-(void)reloadCollectionView
{
    
dispatch_async(dispatch_get_main_queue(), ^
{
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    [backgroundView removeFromSuperview];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection=YES;
    [self.collectionView reloadData];
                       
});
    
}

// This method removes the Custom Menu View from Current View

-(void)removeCustomMenu
{
    
    for(UIView* subview in self.view.subviews)
    {
        if([subview isKindOfClass:[NDCustomMenu class]])
        {
            [subview removeFromSuperview];
        }
    }
    
    menu.tag=0;

    
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
