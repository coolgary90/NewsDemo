//
//  MFLog.m
//  Logging
//
//  Created by Waseem on 11/03/16.
//  Copyright © 2016 Mindfire. All rights reserved.
//

#import "MFLog.h"

#pragma mark -

@interface MFLog ()

@property int consoleLogLevel;

@property(nonatomic, assign) int fileLogLevel;
@property(nonatomic, strong) NSString* logFilePath;	/*!< Path to log file */
@property(nonatomic, assign) NSInteger truncateBytes;	/*!< Bytes at which to truncate file */
@property(nonatomic, strong) NSLock* logLock;  //Lock used to sync log writing by many threads.

@end

@implementation MFLog

+ (instancetype) logManager
{
	static dispatch_once_t once;
	static id sharedInstance;
	dispatch_once(&once, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (id) init
{
	if (self = [super init])
	{
		self.consoleLogLevel = LOG_LEVEL_OFF;
		self.fileLogLevel = LOG_LEVEL_OFF;
	}
	return self;
}

+ (void) consoleLog:(int)logLevel
{
	MFLog* logManager = [MFLog logManager];
	logManager.consoleLogLevel = logLevel;
}

+ (void) fileLog:(int)logLevel atPath:(NSString*)filePath size:(NSInteger)size
{
	MFLog* logManager = [MFLog logManager];
	logManager.fileLogLevel = logLevel;
	logManager.logFilePath = filePath;
	logManager.truncateBytes = size;
}

+ (void) log:(LogFLAG)inLogLevel
			   file:(const char *)file
		   function:(const char *)function
			   line:(int)line
			 format:(NSString *)format, ...
{
	if (format.length == 0)
		return;
	
	MFLog* logManager = [MFLog logManager];
	BOOL fileLogOn = (inLogLevel & logManager.fileLogLevel);
	BOOL consoleLogOn = (inLogLevel & logManager.consoleLogLevel);
	if ((fileLogOn || consoleLogOn) == NO)
		return;

	va_list argList;
	va_start(argList, format);
	NSString* logMsg = [[NSString alloc] initWithFormat:format arguments:argList];
	va_end(argList);
	NSString* functionName =[[NSString alloc] initWithBytes:function length:strlen(function) encoding:NSUTF8StringEncoding];
	
	if (consoleLogOn)
	{
		NSString* logMessage = [NSString stringWithFormat:@"(%@:%d) %@", functionName, line, logMsg];
		NSLog(@"%@\r\n", logMessage);
	}
	
	if (fileLogOn)
	{
		NSString* logMessage = [NSString stringWithFormat:@"(%@ %@:%d) %@", [logManager logDate], functionName, line, logMsg];
		[logManager writeToLog:logMessage];
	}
}

- (NSString*) logDate
{
	NSDate* now = [NSDate date];
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
	NSString* formattedDate = [dateFormatter stringFromDate:now];
	return formattedDate;
}

- (void) writeToLog:(NSString *)logMessage
{
	if (self.logFilePath.length == 0)
		return;
	
	if( !self.logLock )
		self.logLock = [[NSLock alloc] init];
	[self.logLock lock];

	NSData* logEntry =  [[logMessage stringByAppendingString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding];
	NSFileManager* fm = [[NSFileManager alloc] init];
	
	if(![fm fileExistsAtPath:self.logFilePath])
	{
		[fm createFileAtPath:self.logFilePath contents:logEntry attributes:nil];
	}
	else
	{
		NSDictionary* attrs = [fm attributesOfItemAtPath:self.logFilePath error:nil];
		NSFileHandle* file = [NSFileHandle fileHandleForWritingAtPath:self.logFilePath];
		if ([attrs fileSize] > self.truncateBytes)
		{
			[file truncateFileAtOffset:0];
		}
		
		[file seekToEndOfFile];
		[file writeData:logEntry];
		[file closeFile];
	}
	[self.logLock unlock];
}

@end
