//
//  CategoryBasedData.m
//  ICreative
//
//  Created by Simrandeep Singh on 28/11/16.
//  Copyright © 2016 Simrandeep Singh. All rights reserved.
//

#import "CategoryBasedData.h"
#import "SubCategory.h"

@implementation CategoryBasedData

+ (instancetype) buildCategoryBasedDataModelWithDictionary:(NSDictionary*)dict;
{
    CategoryBasedData *categoryBasedData = [[CategoryBasedData alloc] initWithDictionary:dict];
    return categoryBasedData;
}
- (instancetype) initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
        NSDictionary* responseDict=[dict objectForKey:@"response"];
        self.status = [responseDict objectForKey:@"status"];
        self.message = [responseDict objectForKey:@"message"];
        self.categoryName = [responseDict objectForKey:@"category"];
        self.categoryID = [responseDict objectForKey:@"category_id"];
        self.categoryImageUrl = [responseDict objectForKey:@"category_image_url"];
        self.subCategoryList = [[NSMutableArray alloc] init];
        NSDictionary* dataDict = [responseDict objectForKey:@"data"];
        for (NSDictionary* data in dataDict) {
            [self.subCategoryList addObject:
             [SubCategory buildSubCategoryBasedDataModelWithDictionary:data]];
        }
    }
    return self;
}
@end
