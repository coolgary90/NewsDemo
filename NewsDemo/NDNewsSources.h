//
//  NDNewsSources.h
//  NewsDemo
//
//  Created by Amanpreet singh on 05/02/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDNewsSources : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout>

@property( weak , nonatomic) IBOutlet UICollectionView* collectionView;

@end
