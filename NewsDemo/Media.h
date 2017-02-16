//
//  Media.h
//  ICreative
//
//  Created by Simrandeep Singh on 24/11/16.
//  Copyright © 2016 Simrandeep Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Media : NSObject

@property (nonatomic,strong) NSString* mediaID;
@property (nonatomic,strong) NSString* mediaTitle;
@property (nonatomic,strong) NSString* mediaDescript;
@property (nonatomic,strong) NSString* mediaType;
@property (nonatomic,strong) NSString* mediaLength;
@property (nonatomic,strong) NSURL* mediaUrl;
@property (nonatomic,strong) NSURL* mediaThumbnailUrl;
@property (nonatomic,strong) NSString* mediaCreatedAt;
@property (nonatomic,strong) NSString* mediaUpdatedAt;

+ (instancetype) buildMediaModelWithDictionary:(NSDictionary*)dict;

@end
