//
//  NDNewsSources.m
//  NewsDemo
//
//  Created by Amanpreet singh on 05/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "NDNewsList.h"
#import "NDNewsSources.h"

@interface NDNewsSources ()
{
    NSDictionary* jsonResponse;
    NSMutableArray* newsSourcesNames;
    NSMutableArray* newsSourcesImage;
    NSMutableArray* newSourcesid;
    

    
    
}

@end

@implementation NDNewsSources

- (void)viewDidLoad {
    [super viewDidLoad];
    
    newsSourcesImage=[[NSMutableArray alloc]init];
    newsSourcesNames=[[NSMutableArray alloc]init];
    newSourcesid = [[NSMutableArray alloc]init];
    

    
    
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURLSessionDataTask* datatask = [session dataTaskWithURL:[NSURL URLWithString:@"https://newsapi.org/v1/sources?language=en"] completionHandler:^(NSData* data , NSURLResponse* rsponseKey , NSError* error){
        
        
        if(error == nil)
        {
        jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary* sources = [[NSDictionary alloc]init];
        sources = [jsonResponse objectForKey:@"sources"];
        NSUInteger i=[sources count];
        
        for( int j=0; j<i; j++)
        {
            
            [newsSourcesNames addObject:[[jsonResponse objectForKey:@"sources"][j]objectForKey:@"name"] ];
             
            
             [newsSourcesImage addObject:[[[jsonResponse objectForKey:@"sources"][j]objectForKey:@"urlsToLogos"] objectForKey:@"small"]];
            [newSourcesid addObject:[[jsonResponse objectForKey:@"sources"][j]objectForKey:@"id"]];
             

            
        }
            
            self.collectionView.delegate=self;
            self.collectionView.dataSource=self;
            [self.collectionView reloadData];
            
        }

        
    }];
    [datatask resume];
    
    
    
    
    
    // Do any additional setup after loading the view.
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
    
    
//    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[newsSourcesImage objectAtIndex:indexPath.row]]] placeholderImage:nil options:SDWebImageProgressiveDownload];
    sourceName.text=[newsSourcesNames objectAtIndex:indexPath.row];
    
    
    
    
    [sourcebackgroundImage sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[newsSourcesImage objectAtIndex:indexPath.row]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"No-image.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         [self.view setUserInteractionEnabled:YES];
         NSLog(@"error %@",[error localizedDescription]);
         //imgTerm = [[UIImage alloc]init];
         if(image)
         {
             NSLog(@"passed");
//             [cell.imgViewIcon setUserInteractionEnabled:YES];
//             [cell.imgViewIcon setExclusiveTouch:YES];
             
         }
         else
         {
             NSLog(@"failed");

//             [cell.imgViewIcon setUserInteractionEnabled:YES];
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
    
    [self.navigationController presentViewController:newsListObj animated:YES completion:nil];
    
    
    
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
