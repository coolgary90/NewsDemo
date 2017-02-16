//
//  MFLog.h
//  Logging
//
//  Created by Waseem on 11/03/16.
//  Copyright © 2016 Mindfire. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	LOG_FLAG_OFF			= 0,
	LOG_FLAG_DEBUGINFO		= 1 << 0,
	LOG_FLAG_ERRORS			= 1 << 1,
	LOG_FLAG_PARSING		= 1 << 2,
	LOG_FLAG_ALL			= 1 << 3
} LogFLAG;

#define LOG_LEVEL_OFF			LOG_FLAG_OFF
#define LOG_LEVEL_DEBUGINFO		(LOG_FLAG_DEBUGINFO)
#define LOG_LEVEL_ERRORS		(LOG_FLAG_DEBUGINFO | LOG_FLAG_ERRORS)
#define LOG_LEVEL_PARSING		(LOG_FLAG_DEBUGINFO | LOG_FLAG_ERRORS | LOG_FLAG_PARSING)
#define LOG_LEVEL_ALL			(LOG_FLAG_DEBUGINFO | LOG_FLAG_ERRORS | LOG_FLAG_PARSING | LOG_FLAG_ALL)

#define LOG_MACRO(lvl, frmt, ...) \
[MFLog log:lvl file:__FILE__ function:__FUNCTION__ line:__LINE__ format:(frmt), ##__VA_ARGS__ ]


#define MFLogDEBUGINFO(frmt, ...) LOG_MACRO(LOG_FLAG_DEBUGINFO, frmt, ##__VA_ARGS__)
#define MFLogERRORS(frmt, ...) LOG_MACRO(LOG_FLAG_ERRORS, frmt, ##__VA_ARGS__)
#define MFLogPARSING(frmt, ...) LOG_MACRO(LOG_FLAG_PARSING, frmt, ##__VA_ARGS__)
#define MFLogALL(frmt, ...) LOG_MACRO(LOG_FLAG_ALL, frmt, ##__VA_ARGS__)

/*!
 @class
 @abstract    Logging strategy for MFLog
 @discussion  This class implements a logging strategy which writes to the console or File while debugging.
 */

@interface MFLog : NSObject

+ (void) log:(LogFLAG)inLogLevel
			   file:(const char *)file
		   function:(const char *)function
			   line:(int)line
			 format:(NSString *)format, ...;

+ (void) consoleLog:(int)logLevel;
+ (void) fileLog:(int)logLevel atPath:(NSString*)filePath size:(NSInteger)size;

@end

/*! ====== How to use -- Example  ========
 
[MFLog consoleLog:LOG_LEVEL_ALL];

NSString *path = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path];
path = [path stringByAppendingFormat:@"/log.txt"];
[MFLog fileLog:LOG_LEVEL_DEBUGINFO atPath:path size:10000];

MFLogALL(@"ALL");
MFLogDEBUGINFO(@"DEBUG");
MFLogERRORS(@"ERROR");
MFLogPARSING(@"PARSING");

*/


