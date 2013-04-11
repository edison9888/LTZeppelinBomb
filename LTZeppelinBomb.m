//
//  LTZeppelinBomb.m
//  LTZeppelinBomb
//
//  Created by Lex Tang on 2/29/12.
//  Copyright (c) 2012 LexTang.com. All rights reserved.
//

#import "LTZeppelinBomb.h"
#import <CommonCrypto/CommonDigest.h>

#define kParamsDefault @"token=%@&app=%@&app_version=%@&os_version=%@&%@"
#define kTimeoutInterval 10.

static NSString* _myName = nil;
static NSString* _zeppelinURI = nil;
static BOOL _isADrill = NO;

@interface NSString(md5HexDigest)
- (NSString*)md5HexDigest;
@end

@implementation NSString(md5HexDigest)
- (NSString *)md5HexDigest
{
	const char *originalStr = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5(originalStr, strlen(originalStr), result);
	
	NSMutableString *hash = [NSMutableString
                                stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[hash appendFormat:@"%02x", result[i]];
	}
	return [hash lowercaseString];
}
@end

@implementation LTZeppelinBomb

+ (LTZeppelinBomb*)theHugest
{
  static LTZeppelinBomb* _sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[LTZeppelinBomb alloc] init];
  });
  return _sharedInstance;
}

- (void)dropABombOnMe:(NSString*)myName
          zeppelinURI:(NSString*)uriString
             isADrill:(BOOL)isADrill
{
  _myName = myName;
  _zeppelinURI = uriString;
  _isADrill = isADrill;
  [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
   (UIRemoteNotificationTypeBadge |
    UIRemoteNotificationTypeSound |
    UIRemoteNotificationTypeAlert)];
}

- (void)reportMyPosition:(id)myPosition
{
#if __has_feature(objc_arc)
#else
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
#endif
  NSString *positionString = [myPosition description];
  positionString = [positionString stringByTrimmingCharactersInSet:
                    [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
  positionString = [positionString
                    stringByReplacingOccurrencesOfString:@" " withString:@""];
  NSString *positionHash = [positionString md5HexDigest];
  if (positionString) {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:positionString forKey:@"UserDeviceToken"];
    [defaults setObject:positionString forKey:@"UserDeviceTokenMD5"];
  }
  
  NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:
                          @"CFBundleShortVersionString"];
  NSString *osVersion = [[UIDevice currentDevice] valueForKey:@"systemVersion"];
  NSString *post = [NSString stringWithFormat:kParamsDefault,
                    positionString,
                    _myName,
                    appVersion,
                    osVersion,
                    (_isADrill) ? @"sandbox=1" : @"sandbox=0"];
  NSData * postData = [post dataUsingEncoding:NSUTF8StringEncoding];
  
  NSMutableURLRequest * connection = [NSMutableURLRequest requestWithURL:
                                      [NSURL URLWithString:_zeppelinURI]];
  [connection setHTTPMethod:@"POST"];
  [connection setTimeoutInterval:kTimeoutInterval];
  [connection setCachePolicy:NSURLRequestUseProtocolCachePolicy];
  [connection setHTTPBody:postData];
  [connection setValue:positionHash forHTTPHeaderField:@"udt"];
  NSError *error;
  NSData * data = [NSURLConnection sendSynchronousRequest:connection
                                        returningResponse:nil
                                                    error:&error];
  NSString * response =[[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
#ifdef DEBUG
  if (error)
    NSLog(@"[Zeppelin] Failed to drop a bomb on you: %@",
          [error localizedDescription]);
  else
    NSLog(@"[Zeppelin] Aimed at you: %@", response);
#endif
  
#if __has_feature(objc_arc)
#else 
  [pool release]; pool = nil;
#endif
  [NSThread exit];
}

- (void)confirmMyPosition:(NSData*)myPositionData;
{
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  NSString * savedDeviceToken = [defaults objectForKey:@"UserDeviceToken"];
  if (savedDeviceToken == nil) {
    [NSThread detachNewThreadSelector:@selector(reportMyPosition:)
                             toTarget:[LTZeppelinBomb theHugest]
                           withObject:myPositionData];
    [defaults setObject:myPositionData forKey:@"UserDeviceToken"];
    [defaults synchronize];
  }
}

- (void)disposeTheBomb:(NSDictionary*)bomb
               succeed:(void (^)(NSDictionary* bomb))succeedBlock
                failed:(void (^)(NSDictionary* bomb))failedBlock
{
  NSDictionary *aps = [bomb objectForKey:@"aps"];
  if (aps == nil)
  {
    failedBlock(bomb);
    return;
  }
  NSDictionary *alertObj = [aps objectForKey:@"alert"];
  if (alertObj == nil)
  {
    failedBlock(aps);
    return;
  }
  succeedBlock(alertObj);
}

- (void)outOfRange:(NSError*)error
{
#ifdef DEBUG
  NSLog(@"[Zeppelin] Failed to aim you: %@", [error localizedDescription]);
#endif
  [NSThread detachNewThreadSelector:@selector(reportMyPosition:)
                           toTarget:self
                         withObject:nil];
}

#if __has_feature(objc_arc)
#else
- (oneway void)release
{
  NSAssert1(1==0, @"[Zeppelin] I will never die!", self);
}

- (id)retain
{
  return _sharedInstance;
}
#endif

@end
