//
//  SubCategory.m
//  ICreative
//
//  Created by Simrandeep Singh on 28/11/16.
//  Copyright © 2016 Simrandeep Singh. All rights reserved.
//

#import "SubCategory.h"
#import "Media.h"

@implementation SubCategory

+ (instancetype) buildSubCategoryBasedDataModelWithDictionary:(NSDictionary*)dict
{
    SubCategory* subCategory = [[SubCategory alloc] initWithDictionary:dict];
    return subCategory;
}
- (instancetype) initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
        self.categoryName = [dict objectForKey:@"sub_category"];
        self.mediaArray = [[NSMutableArray alloc] init];
        NSDictionary* mediaArray = [dict objectForKey:@"media"];
        for (NSDictionary* mediaDict in mediaArray) {
            [self.mediaArray addObject:[Media buildMediaModelWithDictionary:mediaDict]];
        }
    }
    return self;
}
@end
