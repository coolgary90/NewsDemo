//
//  ImageManager.m
//  MyUtils
//
//  Created by Tushar Mohan on 01/12/16.
//  Copyright © 2016 Tushar Mohan. All rights reserved.
//

#import "ImageManager.h"

#define	kCachedResourceFolder  @"CachedFiles/"
#define kDEBUG_STRING_FORMAT @"ImageManager: Request# \n URL : %@ \n Headers : %@ \n Request Method : %@ \n Post body : %@\n"
#define kHTTP_SUCCESS_CODES statusCode == 200 || statusCode == 201 || statusCode == 202
#define kHTTP_CLIENT_ERRORS statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404
#define asyncGetMainQueue(a) dispatch_async(dispatch_get_main_queue(), ^{a});

@implementation ImageManager
#pragma mark -Public API
+ (void)loadImageWithName:(NSString*)name withCompletion:(void (^)(UIImage*))setImage
{
    if(![name isEqualToString:@""])
    {
        UIImage *localImageData = [ImageManager imageWithName:name];
        
        if(!localImageData)
        {
            [ImageManager sendRequestWithURL:[self buildImageRequestWithURL:name]
                           completionHandler:^(NSData *data, NSError *error)
             {
                 if( data != nil )
                 {
                     NSString* filePath = [ImageManager cacheFilePath:name];
                     [ImageManager saveFileToDisk:data atPath:filePath];
                     
                     NSLog(@"ImageManager: Loading Image from remote server");
                     
                     
                     asyncGetMainQueue(setImage([UIImage imageWithData:data]););
                 }
                 else
                 {
                     asyncGetMainQueue(setImage(nil););
                 }
             }];
        }
        else
        {
            NSLog(@"ImageManager: Loading Image from device cache");
            setImage(localImageData);
        }
        
    }
    else
    {
        setImage(nil);
    }
}

+ (void) clearDiskCache
{
    NSLog(@"ImageManager: Deleting the content from cache");
    
    NSString* filePath = [ImageManager cacheDirectoryPath];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:filePath error:nil];
}

+ (void) removeResourceForPathName:(NSString*)fileName
{
    NSString* filePath = [ImageManager cachedFilePathName:fileName];
    
    if (filePath)
    {
        NSFileManager* fileMgr = [NSFileManager defaultManager];
        [fileMgr removeItemAtPath:filePath error:nil];
    }
}
#pragma mark
#pragma mark -Private API
+ (NSMutableURLRequest*)buildImageRequestWithURL:(NSString*) imageName
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageName]];
    
    return request;
}

+ (NSString*) documentDirectoryWithSubpath:(NSString*)subpath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if (paths.count <= 0)
        return nil;
    
    NSString* dirPath = [paths objectAtIndex:0];
    
    if (subpath)
        dirPath = [dirPath stringByAppendingFormat:@"/%@", subpath];
    
    return dirPath;
}

+ (NSString*) cacheDirectoryPath
{
    return [ImageManager documentDirectoryWithSubpath:kCachedResourceFolder];
}

+ (UIImage*) imageWithName:(NSString*)fileName
{
    if (fileName == nil)
        return nil;
    
    NSString* filePath = [ImageManager cachedFilePathName:fileName];
    UIImage* image = (filePath) ? [UIImage imageWithContentsOfFile:filePath] : nil;
    
    return image;
}

+ (NSString*) cachedFilePathName:(NSString*)fileName
{
    NSString* filePath = [ImageManager cacheFilePath:fileName];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    BOOL isFileExist = [fileMgr fileExistsAtPath:filePath];
    
    if (!isFileExist)
    {
        filePath = nil;
    }
    
    return filePath;
}

+ (BOOL) saveFileToDisk:(NSData*)fileData atPath:(NSString*)filePath
{
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSString* dirPath = [filePath stringByDeletingLastPathComponent];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath])
    {
        [fileMgr createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    BOOL succeed = [fileData writeToFile:filePath atomically:YES];
    return succeed;
}

+ (NSString*) cacheFilePath:(NSString*)fileName
{
    NSString* filePath = [ImageManager cacheDirectoryPath];
    return [filePath stringByAppendingString:fileName];
}

+ (unsigned long long int)getCacheSize
{
    NSString* folderPath = [self cacheDirectoryPath];
    
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject])
    {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager]
                                        attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName]
                                        error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
}
#pragma mark
#pragma mark -WebService Method
+ (void)sendRequestWithURL:(NSMutableURLRequest*)request
         completionHandler:(void(^)(NSData* data,NSError* error))handler{
    
    if (DEBUG_MODE)
    {
        NSLog(kDEBUG_STRING_FORMAT,request.URL.absoluteString, request.allHTTPHeaderFields.description,request.HTTPMethod,request.HTTPBody?[NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:NULL]:request.HTTPBody);
    }
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                         long statusCode = [(NSHTTPURLResponse*) response statusCode];
                                         
                                         if(kHTTP_SUCCESS_CODES)
                                         {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 handler(data, nil);
                                             });
                                         }
                                         else  if(kHTTP_CLIENT_ERRORS)
                                         {
                                             if (DEBUG_MODE)
                                             {
                                                 NSLog(@"ImageManager: Status Code: %ld",statusCode);
                                             }
                                             
                                             handler(nil,nil);
                                         }
                                         else
                                             if (error)
                                             {
                                                 if(response)
                                                 {
                                                     if(DEBUG_MODE)
                                                     {
                                                         NSLog(@"ImageManager: %@", response);
                                                     }
                                                 }
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     handler(nil, error);
                                                 });
                                             }
                                     }] resume];
}
@end
