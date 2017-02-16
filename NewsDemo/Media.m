//
//  Media.m
//  ICreative
//
//  Created by Simrandeep Singh on 24/11/16.
//  Copyright © 2016 Simrandeep Singh. All rights reserved.
//

#import "UIUtils.h"
#import "Media.h"

@implementation Media

+ (instancetype) buildMediaModelWithDictionary:(NSDictionary *)dict
{
	Media* media = [[Media alloc]initWithDict:dict];
	return media;
}

- (instancetype) initWithDict:(NSDictionary*)dict
{
	if(self = [super init])
	{
		self.mediaID = [dict objectForKey:@"id"];
		self.mediaTitle = [dict objectForKey:@"title"];
		self.mediaDescript = [dict objectForKey:@"description"];
		self.mediaType = [dict objectForKey:@"type"];
		int length = [[dict objectForKey:@"length"] intValue];
		self.mediaLength = [UIUtils timeFormatConvertToSeconds:length];
		self.mediaUrl = [dict objectForKey:@"url"];
		self.mediaThumbnailUrl = [dict objectForKey:@"thumbnail_url"];
		self.mediaCreatedAt = [dict objectForKey:@"created_at"];
		self.mediaUpdatedAt = [dict objectForKey:@"updated_at"];
	}
	return self;
}

- (instancetype) initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	if (self)
	{
		self.mediaID = [decoder decodeObjectForKey:@"id"];
		self.mediaTitle = [decoder decodeObjectForKey:@"mediaTitle"];
		self.mediaDescript = [decoder decodeObjectForKey:@"mediaDescript"];
		self.mediaType = [decoder decodeObjectForKey:@"type"];
		int length = [[decoder decodeObjectForKey:@"length"] intValue];
		self.mediaLength = [UIUtils timeFormatConvertToSeconds:length];
		self.mediaUrl = [decoder decodeObjectForKey:@"url"];
		self.mediaThumbnailUrl = [decoder decodeObjectForKey:@"thumbnail_url"];
		self.mediaCreatedAt = [decoder decodeObjectForKey:@"created_at"];
		self.mediaUpdatedAt = [decoder decodeObjectForKey:@"updated_at"];
	}
	return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
	if (self.mediaID)
		[aCoder encodeObject:self.mediaID forKey:@"id"];
	
	if (self.mediaTitle)
		[aCoder encodeObject:self.mediaTitle forKey:@"mediaTitle"];
	
	if (self.mediaDescript)
		[aCoder encodeObject:self.mediaDescript forKey:@"mediaDescript"];
	
	if (self.mediaType)
		[aCoder encodeObject:self.mediaType forKey:@"type"];
	
	if (self.mediaLength)
		[aCoder encodeObject:self.mediaLength forKey:@"length"];
	
	if (self.mediaUrl)
		[aCoder encodeObject:self.mediaUrl forKey:@"url"];
	
	if (self.mediaThumbnailUrl)
		[aCoder encodeObject:self.mediaThumbnailUrl forKey:@"thumbnail_url"];
	
	if (self.mediaCreatedAt)
		[aCoder encodeObject:self.mediaCreatedAt forKey:@"created_at"];
	
	if (self.mediaUpdatedAt)
		[aCoder encodeObject:self.mediaUpdatedAt forKey:@"updated_at"];
}

@end
