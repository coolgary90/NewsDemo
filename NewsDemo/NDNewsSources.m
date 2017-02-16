//
//  NDNewsSources.m
//  NewsDemo
//
//  Created by Amanpreet singh on 05/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "CustomCollectionViewCell.h"
#import "SourceElement.h"
#import "UIImageView+WebCache.h"
#import "NDCustomMenu.h"
#import "Define.h"
#import "NDWebServices.h"
#import "NDNewsList.h"
#import "DataManager.h"
#import "NDNewsSources.h"

@interface NDNewsSources ()
{
    
    NSMutableArray* _newSourcesUniqueCategories;
    NSMutableArray* _newsOptions;
    NSMutableArray* _newsSourcesArray;
    UIActivityIndicatorView* customActivityIndicator;
    UITapGestureRecognizer* gesture;
    UIView* backgroundView;
    UIBarButtonItem* menu;
    
    
}

@end

@implementation NDNewsSources

- (void)viewDidLoad {
    [super viewDidLoad];
    _newsSourcesArray = [[NSMutableArray alloc]init];
    _newsOptions = [[NSMutableArray alloc]init];
    _newSourcesUniqueCategories = [[NSMutableArray alloc]init];

    [self.view bringSubviewToFront:self.activityIndicator];
    self.activityIndicator.color = [UIColor blueColor];
    self.activityIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0);
    [self.activityIndicator startAnimating];
    self.collectionView.allowsMultipleSelection=YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    [self fetchNewsSources];
    UIImage *image = [[UIImage imageNamed:@"menu5.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    menu = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(menuClicked:)];
    self.navigationItem.leftBarButtonItem=menu;
    
}



- (void)fetchNewsSources
{
    DataManager* dataManagerObj = [DataManager sharedInstance];
    [dataManagerObj getNewsList:^(NSMutableArray* newsSourceList){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _newsSourcesArray = newsSourceList;
            [self.activityIndicator stopAnimating];
            [self.activityIndicator setHidden:YES];
            
            [self.collectionView reloadData];
        });
    }];
}

# pragma mark CollectionView Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_newsSourcesArray count];
    
}

 -(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   if(IS_IPHONE_5)
   {
     return CGSizeMake(125, 125);
    
   }
   else
   {
     return CGSizeMake(162, 138);
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellIdentifier = @"CollectionCell";
    CustomCollectionViewCell* customCollectionViewCell =(CustomCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    SourceElement* sourceElementObj = [_newsSourcesArray objectAtIndex:indexPath.row];
    [customCollectionViewCell loadCellData:sourceElementObj];
    if([_newsOptions containsObject:sourceElementObj.sourceID ])
        {
            customCollectionViewCell.layer.borderColor = [UIColor blueColor].CGColor;
            customCollectionViewCell.layer.borderWidth = 3.0;
        }
        else
        {
            customCollectionViewCell.layer.borderColor = [UIColor blackColor].CGColor;
            customCollectionViewCell.layer.borderWidth = 1.0;
        }

    
    return customCollectionViewCell;

    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell* cell  = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor blueColor].CGColor;
    cell.layer.borderWidth = 3.0;
    SourceElement* sourceElementObj = [_newsSourcesArray objectAtIndex:indexPath.row];
    
    [_newsOptions addObject:sourceElementObj.sourceID];
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell* cell  = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 1.0;
    SourceElement* sourceElementObj = [_newsSourcesArray objectAtIndex:indexPath.row];
    [_newsOptions removeObject:sourceElementObj.sourceID];

}




# pragma mark TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[[NSUserDefaults standardUserDefaults]objectForKey:kNewsUniqueSourceCategories]count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       static NSString* cellIdentifier = @"newsCategories";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
       cell.textLabel.text =[[[[NSUserDefaults standardUserDefaults]objectForKey:kNewsUniqueSourceCategories] objectAtIndex:indexPath.row] capitalizedString];
    
        cell.textLabel.numberOfLines=0;
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self loadBackgroundView];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    DataManager* dataManagerObj = [DataManager sharedInstance];
    [dataManagerObj getNewsListWithCategory:[[[[NSUserDefaults standardUserDefaults] objectForKey:kNewsUniqueSourceCategories] objectAtIndex:indexPath.row] lowercaseString]withCompetionHandler:^(NSMutableArray* newSourceList){
        dispatch_async(dispatch_get_main_queue(), ^{
        _newsSourcesArray = [[NSMutableArray alloc]init];
        _newsSourcesArray = newSourceList;
            [self.activityIndicator stopAnimating];
            [self.activityIndicator setHidden:YES];
            [self reloadCollectionView];
//            [self.collectionView reloadData];
        });

        
    }];
    
}



#pragma mark IBActions

//This method is responsible for navigating to next View Controller which loads News from Selected  Sources

- (IBAction)continueClicked:(id)sender
{
    if([_newsOptions count]<2)
    {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:kAlertMinimumSourceSelection preferredStyle:UIAlertControllerStyleAlert];
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
            
            backGroundView.translatesAutoresizingMaskIntoConstraints = YES;
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
        [self.view addSubview:backgroundView];
        [self.view bringSubviewToFront:self.activityIndicator];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        menu.tag=0;

    });
    
}


// This method removes Activity Indicator from Super View

-(void)reloadCollectionView
{
    
dispatch_async(dispatch_get_main_queue(), ^
{

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


//-( void)reloadSources:(NSNotification*)info
//{
//
//    NSDictionary* response = info.userInfo;
//    NSUInteger totalSources = [[response objectForKey:kSources] count];
//    for( int j = 0; j<totalSources; j++)
//    {
//        [_newsSourcesNames addObject:[[response objectForKey:kSources][j]objectForKey:kNewsSourceName] ];
//        [_newsSourcesImage addObject:[[[response objectForKey:kSources][j]objectForKey:kNewsSourcesUrlToLogo] objectForKey:@"small"]];
//        [_newsSourcesid addObject:[[response objectForKey:kSources][j]objectForKey:kNewsSourcesId]];
//        [_newSourcesCategories addObject:[[response objectForKey:kSources][j]objectForKey:kNewsSourcesCategory]];
//    }
//
//    _newSourcesUniqueCategories = [_newSourcesCategories valueForKeyPath:kUniqueObjects];
//       [self reloadCollectionView];
//
//}


//-(void)reloadNewSources:(NSNotification*)info
//{
//
//    NSDictionary* response = info.userInfo;
//    _newsSourcesNames = [[NSMutableArray alloc]init];
//    _newsSourcesImage = [[NSMutableArray alloc]init];
//    _newsSourcesid = [[NSMutableArray alloc]init];
//    _newsOptions = [[NSMutableArray alloc]init];
//
//    NSUInteger totalSources = [[response objectForKey:kSources] count];
//    for( int j = 0; j<totalSources; j++)
//    {
//
//        [_newsSourcesNames addObject:[[response objectForKey:kSources][j]objectForKey:kNewsSourceName] ];
//        [_newsSourcesImage addObject:[[[response objectForKey:kSources][j]objectForKey:kNewsSourcesUrlToLogo] objectForKey:@"small"]];
//        [_newsSourcesid addObject:[[response objectForKey:kSources][j]objectForKey:kNewsSourcesId]];
//
//    }
//    [self reloadCollectionView];
//
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
