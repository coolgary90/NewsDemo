//
//  ViewController.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 03/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "Define.h"
#import "InitialViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.welcomeAppMessage.text = kwelcomeMessage;
    self.AppDescription.text = kAppDescription;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kNewsUniqueSourceCategories];
    
    
    

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
