//
//  UIUtils.m
//
//
#import "WebServiceManager.h"
//#import "EKLoaderView.h"
//#import "Defines.h"
#import "UIUtils.h"

@implementation UIUtils

/*
 Show Alert View with message, title and OK button
 msg represents message displayed in alert view
 title represents title displayed in alert view
 */
+ (void) messageAlert:(NSString*)msg title:(NSString*)title presentViewC:(UIViewController*)sender
{
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
																   message:msg
															preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction* dismissAction = [UIAlertAction actionWithTitle:@"OK"
															style:UIAlertActionStyleDestructive
														  handler:nil];
	[alert addAction:dismissAction];
	if (sender.presentedViewController)
	{	// if already any other sender.presentedViewController present.. dismiss first.
		if ([sender.presentedViewController isKindOfClass:[UIAlertController class]])
			[sender dismissViewControllerAnimated:NO completion:nil];
	}
	[sender presentViewController:alert animated:YES completion:nil];
}
#pragma mark -

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

+ (NSDate*) fileModifiedDate:(NSString*)path
{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:path])
		return nil;
	
	NSError* error = nil;
	NSDictionary* attributes = [fileManager attributesOfItemAtPath:path error:&error];
	if (!attributes)
		return nil;
	return [attributes fileCreationDate];
}

+ (NSString *)timeFormatConvertToSeconds:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
//    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];

    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

+ (void) showLoadingView:(BOOL)show
{
//	if (show)
//		[[EKLoaderView loaderView] showLoader];
//	else
//		[[EKLoaderView loaderView] removeLoader];
}

+ (void) premiumAcountAction:(UIViewController*)sender
{
//	UIAlertController* alertController = [UIAlertController
//										  alertControllerWithTitle:@"Get Platinum Account"
//										  message:@"This Video is available with our Platinum Subscription, would you like to get a Platinum account?"
//										  preferredStyle:UIAlertControllerStyleAlert];
//
//	UIAlertAction* cancelAction = [UIAlertAction
//								   actionWithTitle:@"No"
//								   style:UIAlertActionStyleCancel
//								   handler:^(UIAlertAction *action)
//								   {
//								   }];
//	
//	UIAlertAction* okAction = [UIAlertAction
//							   actionWithTitle:@"Yes"
//							   style:UIAlertActionStyleDefault
//							   handler:^(UIAlertAction *action)
//							   {
//								   NSURL *url = [NSURL URLWithString:kCartURL];
//								   [[UIApplication sharedApplication] openURL:url];
//							   }];
//	[alertController addAction:cancelAction];
//	[alertController addAction:okAction];
//	
//	if (sender.presentedViewController)
//	{	// if alraeady any other sender.presentedViewController present.. dismiss first.
//		if ([sender.presentedViewController isKindOfClass:[UIAlertController class]])
//			[sender dismissViewControllerAnimated:NO completion:nil];
//	}
//	[sender presentViewController:alertController animated:YES completion:nil];
}
@end
