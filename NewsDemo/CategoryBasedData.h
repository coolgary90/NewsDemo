//
//  CategoryBasedData.h
//  ICreative
//
//  Created by Simrandeep Singh on 28/11/16.
//  Copyright © 2016 Simrandeep Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryBasedData : NSObject
@property (nonatomic,strong) NSString* status;
@property (nonatomic,strong) NSString* message;
@property (nonatomic,strong) NSString* categoryName;
@property (nonatomic,strong) NSString* categoryID;
@property (nonatomic,strong) NSString* categoryImageUrl;
@property (nonatomic,strong) NSMutableArray* subCategoryList;

+ (instancetype) buildCategoryBasedDataModelWithDictionary:(NSDictionary*)dict;

@end
