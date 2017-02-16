//
//  SubCategory.h
//  ICreative
//
//  Created by Simrandeep Singh on 28/11/16.
//  Copyright © 2016 Simrandeep Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubCategory : NSObject

@property (nonatomic,strong) NSString* categoryName;
@property (nonatomic,strong) NSMutableArray* mediaArray;

+ (instancetype) buildSubCategoryBasedDataModelWithDictionary:(NSDictionary*)dict;

@end
