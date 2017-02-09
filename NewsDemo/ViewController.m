//
//  ViewController.m
//  NewsDemo
//
//  Created by Amanpreet Singh on 03/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//
#import "Define.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.welcomeAppMessage.text = kwelcomeMessage;
    self.AppDescription.text = kAppDescription;
    
    

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
