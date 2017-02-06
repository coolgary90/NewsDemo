//
//  NDNewsSources.m
//  NewsDemo
//
//  Created by Amanpreet singh on 05/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "UIImageView+WebCache.h"

#import "NDWebServices.h"
#import "UIButton+WebCache.h"
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

    UIActivityIndicatorView* activityIndicator;
    

    
    
}

@end

@implementation NDNewsSources

- (void)viewDidLoad {
    [super viewDidLoad];
    
    newsSourcesImage=[[NSMutableArray alloc]init];
    newsSourcesNames=[[NSMutableArray alloc]init];
    newSourcesid = [[NSMutableArray alloc]init];
    newSourcesCategories =[[NSMutableArray alloc]init];
    newSourcesUniqueCategories = [[NSMutableArray alloc]init];
    
    jsonResponse = [[NSDictionary alloc]init];
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center=self.view.center;
    activityIndicator.transform=CGAffineTransformMakeScale(2.0, 2.0);
    activityIndicator.color = [UIColor blueColor];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    NDWebServices* sharedObject = [NDWebServices sharedInstance];
     [sharedObject getNewsSources];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"SourceListLoaded" object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(NewsSourcesReceived:) name:@"SourceListLoaded" object:nil];
    
}


-(void)NewsSourcesReceived:(NSNotification*)info
{

    NSLog(@"received value is %@",[info.userInfo objectForKey:@"sources"]);
    [self reloadSources:info.userInfo];
}

-( void)reloadSources:(NSDictionary*)response
{
    NSUInteger totalSources = [[response objectForKey:@"sources"] count];
    for( int j=0; j<totalSources; j++)
    {
        [newsSourcesNames addObject:[[response objectForKey:@"sources"][j]objectForKey:@"name"] ];
        [newsSourcesImage addObject:[[[response objectForKey:@"sources"][j]objectForKey:@"urlsToLogos"] objectForKey:@"small"]];
        [newSourcesid addObject:[[response objectForKey:@"sources"][j]objectForKey:@"id"]];
        [newSourcesCategories addObject:[[response objectForKey:@"sources"][j]objectForKey:@"category"]];
    }
    
    newSourcesUniqueCategories = [newSourcesCategories valueForKeyPath:@"@distinctUnionOfObjects.self"];
    dispatch_async(dispatch_get_main_queue(), ^
    {
    [activityIndicator startAnimating];
    [activityIndicator removeFromSuperview];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.collectionView reloadData];
    }
    );
   
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [newsSourcesNames count];
    
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    
    
    UIButton* sourcebackgroundImage=(UIButton*)[cell viewWithTag:100];
    UILabel* sourceName=(UILabel*)[cell viewWithTag:101];
    sourceName.text=[newsSourcesNames objectAtIndex:indexPath.row];
    [sourcebackgroundImage sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[newsSourcesImage objectAtIndex:indexPath.row]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"No-image.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if(image)
         {
             NSLog(@"passed");
             [sourcebackgroundImage setUserInteractionEnabled:YES];

             
         }
         else
         {
             NSLog(@"failed");

         }
     }];
    
    [sourcebackgroundImage setContentMode:UIViewContentModeScaleAspectFit];
    
    return cell;
    
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NDNewsList* newsListObj = [storyBoard instantiateViewControllerWithIdentifier:@"newsList"];
    newsListObj.newsId=[newSourcesid objectAtIndex:indexPath.row];
    newsListObj.newsCategories = newSourcesUniqueCategories;
    [self.navigationController presentViewController:newsListObj animated:YES completion:nil];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


    

//- (NSDictionary*)getNewsSources
//{
////        NSDictionary* __block Response;
////        NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
////        NSURLSession* session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
////        NSURLSessionDataTask* dataTask = [ session dataTaskWithURL:[NSURL URLWithString:@"https://newsapi.org/v1/sources?language=en"] completionHandler: ^(NSData* data , NSURLResponse* response , NSError* error){
////            if(error == nil)
////            {
////                Response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
////                return Response;
////                
////            }
////        }];
////        [dataTask resume];
////        return Response;
//    
//   
//}
//
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
