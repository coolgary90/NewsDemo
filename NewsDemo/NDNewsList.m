//
//  NDNewsList.m
//  NewsDemo
//
//  Created by Amanpreet singh on 06/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "NDCustomCell.h"
#import "UIButton+WebCache.h"
#import "NDNewsList.h"

@interface NDNewsList ()
{
    NSDictionary* jsonResponse;
    NSMutableArray* newsListImage;
    NSMutableArray* newsListTitle;
    NSMutableArray* newsListDescription;

    
    
    
}

@end

@implementation NDNewsList

- (void)viewDidLoad {
    [super viewDidLoad];
    newsListImage= [[ NSMutableArray alloc]init];
    newsListTitle = [[NSMutableArray alloc]init];
    newsListDescription = [[NSMutableArray alloc]init];

    
    
    
    
    NSString* str=@"https://newsapi.org/v1/articles?source=";
    str= [str stringByAppendingString:[NSString stringWithFormat:@"%@&apiKey=589e9375eca54120bc116e72ae1d9eeb",self.newsId]];
    
    
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURLSessionDataTask* datatask = [session dataTaskWithURL:[NSURL URLWithString:str] completionHandler:^(NSData* data , NSURLResponse* rsponseKey , NSError* error){
        
        NSLog(@"error %@",[error localizedDescription]);
        
        if(error == nil)
        {
            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary* articles = [[NSDictionary alloc]init];
            articles = [jsonResponse objectForKey:@"articles"];
            NSUInteger i=[articles count];
            
            for( int j=0; j<i; j++)
            {
                
                [newsListTitle addObject:[[jsonResponse objectForKey:@"articles"][j]objectForKey:@"title"] ];
//
//                
                [newsListImage addObject:[[jsonResponse objectForKey:@"articles"][j]objectForKey:@"urlToImage"] ];
                [newsListDescription addObject:[[jsonResponse objectForKey:@"articles"][j]objectForKey:@"description"]];
//
                
                
            }
            
            self.tableViewNewsList.delegate=self;
            self.tableViewNewsList.dataSource=self;
            [self.tableViewNewsList reloadData];
            
        }
        
        
    }];
    [datatask resume];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NDCustomCell* cell = (NDCustomCell*)[tableView dequeueReusableCellWithIdentifier:@"tableViewListCelll"];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NDCustomCell" owner:self options:nil] objectAtIndex:0];
        
    }
    
    cell.newsTitle.text=[newsListTitle objectAtIndex:indexPath.row];
    cell.newsDescription.text=[newsListDescription objectAtIndex:indexPath.row];
    [cell.newsImage sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[newsListImage objectAtIndex:indexPath.row]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"No-image.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         [self.view setUserInteractionEnabled:YES];
         NSLog(@"error %@",[error localizedDescription]);
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
    cell.newsTitle.numberOfLines=0;
    cell.newsDescription.numberOfLines=0;

    return cell;
    
    


    
    
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
