//
//  UIUtils.h
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIUtils : NSObject

+ (void) messageAlert:(NSString*)msg title:(NSString*)title presentViewC:(id)sender;
+ (NSString*) documentDirectoryWithSubpath:(NSString*)subpath;

+ (BOOL) saveFileToDisk:(NSData*)fileData atPath:(NSString*)filePath;
+ (NSDate*) fileModifiedDate:(NSString*)path;

+ (NSString *)timeFormatConvertToSeconds:(int)totalSeconds;

+ (void) showLoadingView:(BOOL)show;

+ (void) premiumAcountAction:(id)sender;

@end

