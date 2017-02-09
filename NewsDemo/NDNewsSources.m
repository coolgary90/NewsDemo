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
    NSDictionary* jsonResponse;
    NSMutableArray* newsSourcesNames;
    NSMutableArray* newsSourcesImage;
    NSMutableArray* newSourcesid;
    NSMutableArray* newSourcesCategories;
    NSMutableArray* newSourcesUniqueCategories;
    NSMutableArray* newsOptions;
    UIActivityIndicatorView* activityIndicator;
    UITapGestureRecognizer* gesture;
    UIView* backgroundView;
    UIBarButtonItem* menu;
    

    
    
}

@end

@implementation NDNewsSources

- (void)viewDidLoad {
    [super viewDidLoad];
    
    newsSourcesImage = [[NSMutableArray alloc]init];
    newsSourcesNames = [[NSMutableArray alloc]init];
    newSourcesid = [[NSMutableArray alloc]init];
    newSourcesCategories = [[NSMutableArray alloc]init];
    newsOptions = [[NSMutableArray alloc]init];
    newSourcesUniqueCategories = [[NSMutableArray alloc]init];
    jsonResponse = [[NSDictionary alloc]init];
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center=self.view.center;
    activityIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0);
    activityIndicator.color = [UIColor blueColor];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    NDWebServices* sharedObject = [NDWebServices sharedInstance];
     [sharedObject getNewsSources];                            // Fetching list of News Sources
    
    UIImage *image = [[UIImage imageNamed:@"menu.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
        [newsSourcesNames addObject:[[response objectForKey:@"sources"][j]objectForKey:@"name"] ];
        [newsSourcesImage addObject:[[[response objectForKey:@"sources"][j]objectForKey:@"urlsToLogos"] objectForKey:@"small"]];
        [newSourcesid addObject:[[response objectForKey:@"sources"][j]objectForKey:@"id"]];
        [newSourcesCategories addObject:[[response objectForKey:@"sources"][j]objectForKey:@"category"]];
    }
    
    newSourcesUniqueCategories = [newSourcesCategories valueForKeyPath:kUniqueObjects];
       [self reloadCollectionView];
   
}


-(void)reloadNewSources:(NSNotification*)info
{
    
    NSDictionary* response = info.userInfo;
    newsSourcesNames = [[NSMutableArray alloc]init];
    newsSourcesImage = [[NSMutableArray alloc]init];
    newSourcesid = [[NSMutableArray alloc]init];
    newsOptions = [[NSMutableArray alloc]init];
    
    NSUInteger totalSources = [[response objectForKey:@"sources"] count];
    for( int j = 0; j<totalSources; j++)
    {
        [newsSourcesNames addObject:[[response objectForKey:@"sources"][j]objectForKey:@"name"] ];
        [newsSourcesImage addObject:[[[response objectForKey:@"sources"][j]objectForKey:@"urlsToLogos"] objectForKey:@"small"]];
        [newSourcesid addObject:[[response objectForKey:@"sources"][j]objectForKey:@"id"]];

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
    return [newsSourcesNames count];
    
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellIdentifier = @"collectionViewCell";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImageView* sourcebackgroundImage = (UIImageView*)[cell viewWithTag:100];
    UILabel* sourceName=(UILabel*)[cell viewWithTag:101];
    sourceName.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    sourceName.text=[newsSourcesNames objectAtIndex:indexPath.row];
    [sourcebackgroundImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[newsSourcesImage objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:kPlaceHolderImage]];
    [sourcebackgroundImage setContentMode:UIViewContentModeScaleToFill];
    
    if([newsOptions containsObject:[newSourcesid objectAtIndex:indexPath.row]])
    {
        cell.layer.borderColor = [UIColor blueColor].CGColor;
        cell.layer.borderWidth = 3.0;
    }
    else
    {
        cell.layer.borderColor = [UIColor clearColor].CGColor;
        cell.layer.borderWidth = 0.0;
    }
    return cell;
    
    
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell* cell  = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor blueColor].CGColor;
    cell.layer.borderWidth = 3.0;
    [newsOptions addObject:[newSourcesid objectAtIndex:indexPath.row]];
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell* cell  = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    cell.layer.borderWidth = 0.0;
    [newsOptions removeObject:[newSourcesid objectAtIndex:indexPath.row]];

}

#pragma mark IBActions

//This method is responsible for navigating to next View Controller which loads News from Selected  Sources

 - (IBAction)continueClicked:(id)sender
{
    if([newsOptions count]<2)
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
        newsListObj.selectedNewsSources = newsOptions ;
        newsListObj.newsCategories = newSourcesUniqueCategories;
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
            NSString* sBuildInfo = [NSString stringWithFormat:@"V%@ (%@)", _versionNumber, _buildNumber];
            
            backGroundView.appVersion.text = sBuildInfo;

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



# pragma mark TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
return [newSourcesUniqueCategories count];
   
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       static NSString* cellIdentifier = @"newsCategories";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
        cell.textLabel.text = [[newSourcesUniqueCategories objectAtIndex:indexPath.row] capitalizedString];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [self loadBackgroundView];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:kCategorizeSourcesLoadedNotification object:nil];
        [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(reloadNewSources:) name:kCategorizeSourcesLoadedNotification object:nil];
        NDWebServices* sharedObject = [NDWebServices sharedInstance];
        [sharedObject getNewsSourcesWithCategory:[newSourcesUniqueCategories objectAtIndex:indexPath.row]];
    
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
        backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, self.header.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        backgroundView.center= self.view.center;
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
