//
//  ImageManager.h
//  MyUtils
//
//  Created by Tushar Mohan on 01/12/16.
//  Copyright © 2016 Tushar Mohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define DEBUG_MODE 1

@interface ImageManager : NSObject

/**
 * Returns a UIImage object once it has been retreived from the web server.
 */
+ (void)loadImageWithName:(NSString*)name withCompletion:(void (^)(UIImage* image))setImage;

/**
 * To flush the session data after user exists/ terminates the session
 */
+ (void)clearDiskCache;

/**
 * Removes the resource
 
 @param fileName name of file to be purged
 */
+ (void)removeResourceForPathName:(NSString*)fileName;
+ (UIImage*) imageWithName:(NSString*)fileNamel;



/**
 * Calculates the size of the cache folder

 @return the size in bytes
 */
+ (unsigned long long int)getCacheSize;

@end

#define _gImageManager [ImageManager]
